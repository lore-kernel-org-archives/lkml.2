Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198Ab1FBWbO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 18:31:14 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36061 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851Ab1FBWbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 18:31:10 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-media@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: <laurent.pinchart@ideasonboard.com>, <Hiroshi.DOYU@nokia.com>,
        <arnd@arndb.de>, <davidb@codeaurora.org>, <Joerg.Roedel@amd.com>,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: [RFC 4/6] drivers: iommu: move to a dedicated folder
Date: Fri,  3 Jun 2011 01:27:41 +0300
Message-Id: <1307053663-24572-5-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1307053663-24572-1-git-send-email-ohad@wizery.com>
References: <1307053663-24572-1-git-send-email-ohad@wizery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create a dedicated folder for iommu drivers, and move the base
iommu implementation over there.

Grouping the varius iommu drivers in a single location will help
finding similar problems shared by different platforms, so they
could be solved once, in the iommu framework, instead of solved
differently (or duplicated) in each driver.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 arch/arm/mach-msm/Kconfig       |    3 ---
 arch/arm/plat-omap/Kconfig      |    3 ---
 arch/x86/Kconfig                |    5 ++---
 drivers/Kconfig                 |    2 ++
 drivers/Makefile                |    1 +
 drivers/base/Makefile           |    1 -
 drivers/iommu/Kconfig           |    3 +++
 drivers/iommu/Makefile          |    1 +
 drivers/{base => iommu}/iommu.c |    0
 9 files changed, 9 insertions(+), 10 deletions(-)
 create mode 100644 drivers/iommu/Kconfig
 create mode 100644 drivers/iommu/Makefile
 rename drivers/{base => iommu}/iommu.c (100%)

diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
index 1516896..efb7b7d 100644
--- a/arch/arm/mach-msm/Kconfig
+++ b/arch/arm/mach-msm/Kconfig
@@ -205,9 +205,6 @@ config MSM_GPIOMUX
 config MSM_V2_TLMM
 	bool
 
-config IOMMU_API
-	bool
-
 config MSM_SCM
 	bool
 endif
diff --git a/arch/arm/plat-omap/Kconfig b/arch/arm/plat-omap/Kconfig
index 1c3acb5..1bb1981 100644
--- a/arch/arm/plat-omap/Kconfig
+++ b/arch/arm/plat-omap/Kconfig
@@ -131,9 +131,6 @@ config OMAP_MBOX_KFIFO_SIZE
 	  This can also be changed at runtime (via the mbox_kfifo_size
 	  module parameter).
 
-config IOMMU_API
-	bool
-
 #can't be tristate; iommu api doesn't support un-registration
 config OMAP_IOMMU
 	bool
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index da34972..460d573 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -685,6 +685,7 @@ config AMD_IOMMU
 	select SWIOTLB
 	select PCI_MSI
 	select PCI_IOV
+	select IOMMU_API
 	depends on X86_64 && PCI && ACPI
 	---help---
 	  With this option you can enable support for AMD IOMMU hardware in
@@ -720,9 +721,6 @@ config SWIOTLB
 config IOMMU_HELPER
 	def_bool (CALGARY_IOMMU || GART_IOMMU || SWIOTLB || AMD_IOMMU)
 
-config IOMMU_API
-	def_bool (AMD_IOMMU || DMAR)
-
 config MAXSMP
 	bool "Enable Maximum number of SMP Processors and NUMA Nodes"
 	depends on X86_64 && SMP && DEBUG_KERNEL && EXPERIMENTAL
@@ -1945,6 +1943,7 @@ config PCI_CNB20LE_QUIRK
 config DMAR
 	bool "Support for DMA Remapping Devices (EXPERIMENTAL)"
 	depends on PCI_MSI && ACPI && EXPERIMENTAL
+	select IOMMU_API
 	help
 	  DMA remapping (DMAR) devices support enables independent address
 	  translations for Direct Memory Access (DMA) from devices.
diff --git a/drivers/Kconfig b/drivers/Kconfig
index 3bb154d..9d51318 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -126,4 +126,6 @@ source "drivers/hwspinlock/Kconfig"
 
 source "drivers/clocksource/Kconfig"
 
+source "drivers/iommu/Kconfig"
+
 endmenu
diff --git a/drivers/Makefile b/drivers/Makefile
index 09f3232..2f7a71a 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -122,3 +122,4 @@ obj-y				+= ieee802154/
 obj-y				+= clk/
 
 obj-$(CONFIG_HWSPINLOCK)	+= hwspinlock/
+obj-$(CONFIG_IOMMU_API)		+= iommu/
diff --git a/drivers/base/Makefile b/drivers/base/Makefile
index 4c5701c..5ab0d07 100644
--- a/drivers/base/Makefile
+++ b/drivers/base/Makefile
@@ -13,7 +13,6 @@ obj-$(CONFIG_FW_LOADER)	+= firmware_class.o
 obj-$(CONFIG_NUMA)	+= node.o
 obj-$(CONFIG_MEMORY_HOTPLUG_SPARSE) += memory.o
 obj-$(CONFIG_SMP)	+= topology.o
-obj-$(CONFIG_IOMMU_API) += iommu.o
 ifeq ($(CONFIG_SYSFS),y)
 obj-$(CONFIG_MODULES)	+= module.o
 endif
diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
new file mode 100644
index 0000000..2c5dfb4
--- /dev/null
+++ b/drivers/iommu/Kconfig
@@ -0,0 +1,3 @@
+# IOMMU_API always gets selected by whoever wants it.
+config IOMMU_API
+	bool
diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
new file mode 100644
index 0000000..241ba4c
--- /dev/null
+++ b/drivers/iommu/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_IOMMU_API) += iommu.o
diff --git a/drivers/base/iommu.c b/drivers/iommu/iommu.c
similarity index 100%
rename from drivers/base/iommu.c
rename to drivers/iommu/iommu.c
-- 
1.7.1

