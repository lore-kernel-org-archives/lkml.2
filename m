Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810Ab1G0TTY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 15:19:24 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:10266 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753607Ab1G0TTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 15:19:22 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6420"; a="106317184"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        David Brown <davidb@codeaurora.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: [PATCHv4 1/2] ARM: Set proper TEXT_OFFSET for newer MSMs
Date: Wed, 27 Jul 2011 12:19:14 -0700
Message-Id: <1311794355-26988-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.6.233.gd79bc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MSMs post 8x50 have 2Mb at the beginning of RAM reserved for
shared memory. Since the kernel hasn't typically been told this
RAM exists, PHYS_OFFSET has been set to 0xN0200000 and the memory
atags passed to the kernel have matched. This doesn't play nicely
with things such as AUTO_ZRELADDR, which doesn't work at all, and
dynamic phys to virt, which requires an MSM specific workaround.

Work around these issues by telling the kernel RAM starts at
0xN0000000 (it actually does) and fixup the atags from the
bootloader (if necessary) to say the same. In addition, make sure
to set TEXT_OFFSET at least 2Mb beyond the start of RAM so that
the kernel doesn't end up being decompressed into shared memory.

After doing this, AUTO_ZRELADDR should work on MSM with no
problems and ARM_PATCH_PHYS_VIRT_16BIT should no longer be
necessary.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Acked-by: Nicolas Pitre <nicolas.pitre@linaro.org>
---

No changes since v3

 arch/arm/Makefile                       |    3 +++
 arch/arm/mach-msm/board-msm7x30.c       |   22 ++++++++++++++++++++++
 arch/arm/mach-msm/board-msm8960.c       |   22 ++++++++++++++++++++++
 arch/arm/mach-msm/board-msm8x60.c       |   25 +++++++++++++++++++++++++
 arch/arm/mach-msm/include/mach/memory.h |    6 +++---
 5 files changed, 75 insertions(+), 3 deletions(-)

diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index f5b2b39..44b1d02 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -128,6 +128,9 @@ textofs-$(CONFIG_PM_H1940)      := 0x00108000
 ifeq ($(CONFIG_ARCH_SA1100),y)
 textofs-$(CONFIG_SA1111) := 0x00208000
 endif
+textofs-$(CONFIG_ARCH_MSM7X30) := 0x00208000
+textofs-$(CONFIG_ARCH_MSM8X60) := 0x00208000
+textofs-$(CONFIG_ARCH_MSM8960) := 0x00208000
 
 # Machine directory name.  This list is sorted alphanumerically
 # by CONFIG_* macro name.
diff --git a/arch/arm/mach-msm/board-msm7x30.c b/arch/arm/mach-msm/board-msm7x30.c
index b7a8496..d1e4cc8 100644
--- a/arch/arm/mach-msm/board-msm7x30.c
+++ b/arch/arm/mach-msm/board-msm7x30.c
@@ -24,6 +24,7 @@
 #include <linux/smsc911x.h>
 #include <linux/usb/msm_hsusb.h>
 #include <linux/clkdev.h>
+#include <linux/memblock.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
@@ -42,6 +43,21 @@
 
 extern struct sys_timer msm_timer;
 
+static void __init msm7x30_fixup(struct machine_desc *desc, struct tag *tag,
+			 char **cmdline, struct meminfo *mi)
+{
+	for (; tag->hdr.size; tag = tag_next(tag))
+		if (tag->hdr.tag == ATAG_MEM && tag->u.mem.start == 0x200000) {
+			tag->u.mem.start = 0;
+			tag->u.mem.size += SZ_2M;
+		}
+}
+
+static void __init msm7x30_reserve(void)
+{
+	memblock_remove(0x0, SZ_2M);
+}
+
 static int hsusb_phy_init_seq[] = {
 	0x30, 0x32,	/* Enable and set Pre-Emphasis Depth to 20% */
 	0x02, 0x36,	/* Disable CDR Auto Reset feature */
@@ -107,6 +123,8 @@ static void __init msm7x30_map_io(void)
 
 MACHINE_START(MSM7X30_SURF, "QCT MSM7X30 SURF")
 	.boot_params = PLAT_PHYS_OFFSET + 0x100,
+	.fixup = msm7x30_fixup,
+	.reserve = msm7x30_reserve,
 	.map_io = msm7x30_map_io,
 	.init_irq = msm7x30_init_irq,
 	.init_machine = msm7x30_init,
@@ -115,6 +133,8 @@ MACHINE_END
 
 MACHINE_START(MSM7X30_FFA, "QCT MSM7X30 FFA")
 	.boot_params = PLAT_PHYS_OFFSET + 0x100,
+	.fixup = msm7x30_fixup,
+	.reserve = msm7x30_reserve,
 	.map_io = msm7x30_map_io,
 	.init_irq = msm7x30_init_irq,
 	.init_machine = msm7x30_init,
@@ -123,6 +143,8 @@ MACHINE_END
 
 MACHINE_START(MSM7X30_FLUID, "QCT MSM7X30 FLUID")
 	.boot_params = PLAT_PHYS_OFFSET + 0x100,
+	.fixup = msm7x30_fixup,
+	.reserve = msm7x30_reserve,
 	.map_io = msm7x30_map_io,
 	.init_irq = msm7x30_init_irq,
 	.init_machine = msm7x30_init,
diff --git a/arch/arm/mach-msm/board-msm8960.c b/arch/arm/mach-msm/board-msm8960.c
index 35c7cee..b04468e 100644
--- a/arch/arm/mach-msm/board-msm8960.c
+++ b/arch/arm/mach-msm/board-msm8960.c
@@ -20,16 +20,34 @@
 #include <linux/io.h>
 #include <linux/irq.h>
 #include <linux/clkdev.h>
+#include <linux/memblock.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 #include <asm/hardware/gic.h>
+#include <asm/setup.h>
 
 #include <mach/board.h>
 #include <mach/msm_iomap.h>
 
 #include "devices.h"
 
+static void __init msm8960_fixup(struct machine_desc *desc, struct tag *tag,
+			 char **cmdline, struct meminfo *mi)
+{
+	for (; tag->hdr.size; tag = tag_next(tag))
+		if (tag->hdr.tag == ATAG_MEM &&
+				tag->u.mem.start == 0x40200000) {
+			tag->u.mem.start = 0x40000000;
+			tag->u.mem.size += SZ_2M;
+		}
+}
+
+static void __init msm8960_reserve(void)
+{
+	memblock_remove(0x40000000, SZ_2M);
+}
+
 static void __init msm8960_map_io(void)
 {
 	msm_map_msm8960_io();
@@ -76,6 +94,8 @@ static void __init msm8960_rumi3_init(void)
 }
 
 MACHINE_START(MSM8960_SIM, "QCT MSM8960 SIMULATOR")
+	.fixup = msm8960_fixup,
+	.reserve = msm8960_reserve,
 	.map_io = msm8960_map_io,
 	.init_irq = msm8960_init_irq,
 	.timer = &msm_timer,
@@ -83,6 +103,8 @@ MACHINE_START(MSM8960_SIM, "QCT MSM8960 SIMULATOR")
 MACHINE_END
 
 MACHINE_START(MSM8960_RUMI3, "QCT MSM8960 RUMI3")
+	.fixup = msm8960_fixup,
+	.reserve = msm8960_reserve,
 	.map_io = msm8960_map_io,
 	.init_irq = msm8960_init_irq,
 	.timer = &msm_timer,
diff --git a/arch/arm/mach-msm/board-msm8x60.c b/arch/arm/mach-msm/board-msm8x60.c
index 1163b6f..9221f54 100644
--- a/arch/arm/mach-msm/board-msm8x60.c
+++ b/arch/arm/mach-msm/board-msm8x60.c
@@ -20,14 +20,31 @@
 #include <linux/platform_device.h>
 #include <linux/io.h>
 #include <linux/irq.h>
+#include <linux/memblock.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 #include <asm/hardware/gic.h>
+#include <asm/setup.h>
 
 #include <mach/board.h>
 #include <mach/msm_iomap.h>
 
+static void __init msm8x60_fixup(struct machine_desc *desc, struct tag *tag,
+			 char **cmdline, struct meminfo *mi)
+{
+	for (; tag->hdr.size; tag = tag_next(tag))
+		if (tag->hdr.tag == ATAG_MEM &&
+				tag->u.mem.start == 0x40200000) {
+			tag->u.mem.start = 0x40000000;
+			tag->u.mem.size += SZ_2M;
+		}
+}
+
+static void __init msm8x60_reserve(void)
+{
+	memblock_remove(0x40000000, SZ_2M);
+}
 
 static void __init msm8x60_map_io(void)
 {
@@ -65,6 +82,8 @@ static void __init msm8x60_init(void)
 }
 
 MACHINE_START(MSM8X60_RUMI3, "QCT MSM8X60 RUMI3")
+	.fixup = msm8x60_fixup,
+	.reserve = msm8x60_reserve,
 	.map_io = msm8x60_map_io,
 	.init_irq = msm8x60_init_irq,
 	.init_machine = msm8x60_init,
@@ -72,6 +91,8 @@ MACHINE_START(MSM8X60_RUMI3, "QCT MSM8X60 RUMI3")
 MACHINE_END
 
 MACHINE_START(MSM8X60_SURF, "QCT MSM8X60 SURF")
+	.fixup = msm8x60_fixup,
+	.reserve = msm8x60_reserve,
 	.map_io = msm8x60_map_io,
 	.init_irq = msm8x60_init_irq,
 	.init_machine = msm8x60_init,
@@ -79,6 +100,8 @@ MACHINE_START(MSM8X60_SURF, "QCT MSM8X60 SURF")
 MACHINE_END
 
 MACHINE_START(MSM8X60_SIM, "QCT MSM8X60 SIMULATOR")
+	.fixup = msm8x60_fixup,
+	.reserve = msm8x60_reserve,
 	.map_io = msm8x60_map_io,
 	.init_irq = msm8x60_init_irq,
 	.init_machine = msm8x60_init,
@@ -86,6 +109,8 @@ MACHINE_START(MSM8X60_SIM, "QCT MSM8X60 SIMULATOR")
 MACHINE_END
 
 MACHINE_START(MSM8X60_FFA, "QCT MSM8X60 FFA")
+	.fixup = msm8x60_fixup,
+	.reserve = msm8x60_reserve,
 	.map_io = msm8x60_map_io,
 	.init_irq = msm8x60_init_irq,
 	.init_machine = msm8x60_init,
diff --git a/arch/arm/mach-msm/include/mach/memory.h b/arch/arm/mach-msm/include/mach/memory.h
index f2f8d29..58d5e7e 100644
--- a/arch/arm/mach-msm/include/mach/memory.h
+++ b/arch/arm/mach-msm/include/mach/memory.h
@@ -22,11 +22,11 @@
 #elif defined(CONFIG_ARCH_QSD8X50)
 #define PLAT_PHYS_OFFSET		UL(0x20000000)
 #elif defined(CONFIG_ARCH_MSM7X30)
-#define PLAT_PHYS_OFFSET		UL(0x00200000)
+#define PLAT_PHYS_OFFSET		UL(0x00000000)
 #elif defined(CONFIG_ARCH_MSM8X60)
-#define PLAT_PHYS_OFFSET		UL(0x40200000)
+#define PLAT_PHYS_OFFSET		UL(0x40000000)
 #elif defined(CONFIG_ARCH_MSM8960)
-#define PLAT_PHYS_OFFSET		UL(0x40200000)
+#define PLAT_PHYS_OFFSET		UL(0x40000000)
 #else
 #define PLAT_PHYS_OFFSET		UL(0x10000000)
 #endif
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

