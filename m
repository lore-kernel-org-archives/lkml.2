Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993Ab2FTMgz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 08:36:55 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13743 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337Ab2FTMgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 08:36:54 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 20 Jun 2012 05:33:58 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>, <ccross@android.com>, <olof@lixom.net>
CC: <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bandik@nvidia.com>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V2] ARM: tegra: apbio access using dma for tegra20 only
Date: Wed, 20 Jun 2012 18:06:34 +0530
Message-ID: <1340195794-26571-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Tegra20 HW issue with accessing APBIO registers (such
as fuse registers) directly from the CPU concurrently with
APB DMA accesses has been fixed in Tegra30 and later chips.

Access these registers directly from the CPU on Tegra30
and later, and apply the workaround only for Tegra20.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
Changes from V1:
- If device is booted with non-DT then assume it as Tegra20 based system.

 arch/arm/mach-tegra/Makefile |    3 +-
 arch/arm/mach-tegra/apbio.c  |   59 ++++++++++++++++++++++++++++++++++++++---
 arch/arm/mach-tegra/apbio.h  |   19 +-------------
 arch/arm/mach-tegra/common.c |    3 ++
 4 files changed, 60 insertions(+), 24 deletions(-)

diff --git a/arch/arm/mach-tegra/Makefile b/arch/arm/mach-tegra/Makefile
index 508d816..c3d7303 100644
--- a/arch/arm/mach-tegra/Makefile
+++ b/arch/arm/mach-tegra/Makefile
@@ -9,6 +9,7 @@ obj-y					+= fuse.o
 obj-y					+= pmc.o
 obj-y					+= flowctrl.o
 obj-y					+= powergate.o
+obj-y					+= apbio.o
 obj-$(CONFIG_CPU_IDLE)			+= cpuidle.o
 obj-$(CONFIG_CPU_IDLE)			+= sleep.o
 obj-$(CONFIG_ARCH_TEGRA_2x_SOC)         += tegra2_clocks.o
@@ -17,7 +18,7 @@ obj-$(CONFIG_ARCH_TEGRA_3x_SOC)		+= tegra30_clocks.o
 obj-$(CONFIG_SMP)			+= platsmp.o headsmp.o
 obj-$(CONFIG_SMP)                       += reset.o
 obj-$(CONFIG_HOTPLUG_CPU)               += hotplug.o
-obj-$(CONFIG_TEGRA_SYSTEM_DMA)		+= dma.o apbio.o
+obj-$(CONFIG_TEGRA_SYSTEM_DMA)		+= dma.o
 obj-$(CONFIG_CPU_FREQ)                  += cpu-tegra.o
 obj-$(CONFIG_TEGRA_PCI)			+= pcie.o
 obj-$(CONFIG_USB_SUPPORT)		+= usb_phy.o
diff --git a/arch/arm/mach-tegra/apbio.c b/arch/arm/mach-tegra/apbio.c
index e75451e..74ac0db 100644
--- a/arch/arm/mach-tegra/apbio.c
+++ b/arch/arm/mach-tegra/apbio.c
@@ -15,6 +15,10 @@
 
 #include <linux/kernel.h>
 #include <linux/io.h>
+#include <mach/iomap.h>
+#include <linux/of.h>
+
+#ifdef CONFIG_TEGRA_SYSTEM_DMA
 #include <linux/dma-mapping.h>
 #include <linux/spinlock.h>
 #include <linux/completion.h>
@@ -22,7 +26,6 @@
 #include <linux/mutex.h>
 
 #include <mach/dma.h>
-#include <mach/iomap.h>
 
 #include "apbio.h"
 
@@ -33,6 +36,9 @@ static u32 *tegra_apb_bb;
 static dma_addr_t tegra_apb_bb_phys;
 static DECLARE_COMPLETION(tegra_apb_wait);
 
+static u32 tegra_apb_readl_direct(unsigned long offset);
+static void tegra_apb_writel_direct(u32 value, unsigned long offset);
+
 bool tegra_apb_init(void)
 {
 	struct tegra_dma_channel *ch;
@@ -72,13 +78,13 @@ static void apb_dma_complete(struct tegra_dma_req *req)
 	complete(&tegra_apb_wait);
 }
 
-u32 tegra_apb_readl(unsigned long offset)
+static u32 tegra_apb_readl_using_dma(unsigned long offset)
 {
 	struct tegra_dma_req req;
 	int ret;
 
 	if (!tegra_apb_dma && !tegra_apb_init())
-		return readl(IO_TO_VIRT(offset));
+		return tegra_apb_readl_direct(offset);
 
 	mutex_lock(&tegra_apb_dma_lock);
 	req.complete = apb_dma_complete;
@@ -108,13 +114,13 @@ u32 tegra_apb_readl(unsigned long offset)
 	return *((u32 *)tegra_apb_bb);
 }
 
-void tegra_apb_writel(u32 value, unsigned long offset)
+static void tegra_apb_writel_using_dma(u32 value, unsigned long offset)
 {
 	struct tegra_dma_req req;
 	int ret;
 
 	if (!tegra_apb_dma && !tegra_apb_init()) {
-		writel(value, IO_TO_VIRT(offset));
+		tegra_apb_writel_direct(value, offset);
 		return;
 	}
 
@@ -143,3 +149,46 @@ void tegra_apb_writel(u32 value, unsigned long offset)
 
 	mutex_unlock(&tegra_apb_dma_lock);
 }
+#else
+#define tegra_apb_readl_using_dma tegra_apb_readl_direct
+#define tegra_apb_writel_using_dma tegra_apb_writel_direct
+#endif
+
+typedef u32 (*apbio_read_fptr)(unsigned long offset);
+typedef void (*apbio_write_fptr)(u32 value, unsigned long offset);
+
+static apbio_read_fptr apbio_read;
+static apbio_write_fptr apbio_write;
+
+static u32 tegra_apb_readl_direct(unsigned long offset)
+{
+	return readl(IO_TO_VIRT(offset));
+}
+
+static void tegra_apb_writel_direct(u32 value, unsigned long offset)
+{
+	writel(value, IO_TO_VIRT(offset));
+}
+
+void tegra_apb_io_init(void)
+{
+	/* Need to use dma only when it is Tegra20 based platform */
+	if (of_machine_is_compatible("nvidia,tegra20") ||
+			!of_have_populated_dt()) {
+		apbio_read = tegra_apb_readl_using_dma;
+		apbio_write = tegra_apb_writel_using_dma;
+	} else {
+		apbio_read = tegra_apb_readl_direct;
+		apbio_write = tegra_apb_writel_direct;
+	}
+}
+
+u32 tegra_apb_readl(unsigned long offset)
+{
+	return apbio_read(offset);
+}
+
+void tegra_apb_writel(u32 value, unsigned long offset)
+{
+	apbio_write(value, offset);
+}
diff --git a/arch/arm/mach-tegra/apbio.h b/arch/arm/mach-tegra/apbio.h
index 8b49e8c..f05d71c 100644
--- a/arch/arm/mach-tegra/apbio.h
+++ b/arch/arm/mach-tegra/apbio.h
@@ -16,24 +16,7 @@
 #ifndef __MACH_TEGRA_APBIO_H
 #define __MACH_TEGRA_APBIO_H
 
-#ifdef CONFIG_TEGRA_SYSTEM_DMA
-
+void tegra_apb_io_init(void);
 u32 tegra_apb_readl(unsigned long offset);
 void tegra_apb_writel(u32 value, unsigned long offset);
-
-#else
-#include <asm/io.h>
-#include <mach/io.h>
-
-static inline u32 tegra_apb_readl(unsigned long offset)
-{
-        return readl(IO_TO_VIRT(offset));
-}
-
-static inline void tegra_apb_writel(u32 value, unsigned long offset)
-{
-        writel(value, IO_TO_VIRT(offset));
-}
-#endif
-
 #endif
diff --git a/arch/arm/mach-tegra/common.c b/arch/arm/mach-tegra/common.c
index 204a5c8..96fef6b 100644
--- a/arch/arm/mach-tegra/common.c
+++ b/arch/arm/mach-tegra/common.c
@@ -33,6 +33,7 @@
 #include "clock.h"
 #include "fuse.h"
 #include "pmc.h"
+#include "apbio.h"
 
 /*
  * Storage for debug-macro.S's state.
@@ -127,6 +128,7 @@ static void __init tegra_init_cache(u32 tag_latency, u32 data_latency)
 #ifdef CONFIG_ARCH_TEGRA_2x_SOC
 void __init tegra20_init_early(void)
 {
+	tegra_apb_io_init();
 	tegra_init_fuse();
 	tegra2_init_clocks();
 	tegra_clk_init_from_table(tegra20_clk_init_table);
@@ -138,6 +140,7 @@ void __init tegra20_init_early(void)
 #ifdef CONFIG_ARCH_TEGRA_3x_SOC
 void __init tegra30_init_early(void)
 {
+	tegra_apb_io_init();
 	tegra_init_fuse();
 	tegra30_init_clocks();
 	tegra_clk_init_from_table(tegra30_clk_init_table);
-- 
1.7.1.1

