Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758185Ab1FJV5b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 17:57:31 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56144 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758141Ab1FJV5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 17:57:23 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: Joerg Roedel <Joerg.Roedel@amd.com>
Cc: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        David Brown <davidb@codeaurora.org>,
        David Woodhouse <dwmw2@infradead.org>,
        <iommu@lists.linux-foundation.org>, <linux-pci@vger.kernel.org>,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH v2 2/4] msm: iommu: move to drivers/iommu/
Date: Sat, 11 Jun 2011 00:55:45 +0300
Message-Id: <1307742947-32118-3-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1307742947-32118-1-git-send-email-ohad@wizery.com>
References: <1307742947-32118-1-git-send-email-ohad@wizery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This should ease finding similarities with different platforms,
with the intention of solving problems once in a generic framework
which everyone can use.

Compile-tested for MSM8X60.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 arch/arm/mach-msm/Kconfig                          |   16 ----------------
 arch/arm/mach-msm/Makefile                         |    2 +-
 drivers/iommu/Kconfig                              |   16 ++++++++++++++++
 drivers/iommu/Makefile                             |    1 +
 .../mach-msm/iommu.c => drivers/iommu/msm_iommu.c  |    0
 .../iommu_dev.c => drivers/iommu/msm_iommu_dev.c   |    0
 6 files changed, 18 insertions(+), 17 deletions(-)
 rename arch/arm/mach-msm/iommu.c => drivers/iommu/msm_iommu.c (100%)
 rename arch/arm/mach-msm/iommu_dev.c => drivers/iommu/msm_iommu_dev.c (100%)

diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
index efb7b7d..888e925 100644
--- a/arch/arm/mach-msm/Kconfig
+++ b/arch/arm/mach-msm/Kconfig
@@ -148,22 +148,6 @@ config MACH_MSM8960_RUMI3
 
 endmenu
 
-config MSM_IOMMU
-	bool "MSM IOMMU Support"
-	depends on ARCH_MSM8X60 || ARCH_MSM8960
-	select IOMMU_API
-	default n
-	help
-	  Support for the IOMMUs found on certain Qualcomm SOCs.
-	  These IOMMUs allow virtualization of the address space used by most
-	  cores within the multimedia subsystem.
-
-	  If unsure, say N here.
-
-config IOMMU_PGTABLES_L2
-	def_bool y
-	depends on MSM_IOMMU && MMU && SMP && CPU_DCACHE_DISABLE=n
-
 config MSM_DEBUG_UART
 	int
 	default 1 if MSM_DEBUG_UART1
diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
index 9519fd2..b70658c 100644
--- a/arch/arm/mach-msm/Makefile
+++ b/arch/arm/mach-msm/Makefile
@@ -3,7 +3,7 @@ obj-y += clock.o
 obj-$(CONFIG_DEBUG_FS) += clock-debug.o
 
 obj-$(CONFIG_MSM_VIC) += irq-vic.o
-obj-$(CONFIG_MSM_IOMMU) += iommu.o iommu_dev.o devices-iommu.o
+obj-$(CONFIG_MSM_IOMMU) += devices-iommu.o
 
 obj-$(CONFIG_ARCH_MSM7X00A) += dma.o irq.o acpuclock-arm11.o
 obj-$(CONFIG_ARCH_MSM7X30) += dma.o
diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index 2c5dfb4..21a80bf 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -1,3 +1,19 @@
 # IOMMU_API always gets selected by whoever wants it.
 config IOMMU_API
 	bool
+
+# MSM IOMMU support
+config MSM_IOMMU
+	bool "MSM IOMMU Support"
+	depends on ARCH_MSM8X60 || ARCH_MSM8960
+	select IOMMU_API
+	help
+	  Support for the IOMMUs found on certain Qualcomm SOCs.
+	  These IOMMUs allow virtualization of the address space used by most
+	  cores within the multimedia subsystem.
+
+	  If unsure, say N here.
+
+config IOMMU_PGTABLES_L2
+	def_bool y
+	depends on MSM_IOMMU && MMU && SMP && CPU_DCACHE_DISABLE=n
diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
index 241ba4c..1a71c82 100644
--- a/drivers/iommu/Makefile
+++ b/drivers/iommu/Makefile
@@ -1 +1,2 @@
 obj-$(CONFIG_IOMMU_API) += iommu.o
+obj-$(CONFIG_MSM_IOMMU) += msm_iommu.o msm_iommu_dev.o
diff --git a/arch/arm/mach-msm/iommu.c b/drivers/iommu/msm_iommu.c
similarity index 100%
rename from arch/arm/mach-msm/iommu.c
rename to drivers/iommu/msm_iommu.c
diff --git a/arch/arm/mach-msm/iommu_dev.c b/drivers/iommu/msm_iommu_dev.c
similarity index 100%
rename from arch/arm/mach-msm/iommu_dev.c
rename to drivers/iommu/msm_iommu_dev.c
-- 
1.7.1

