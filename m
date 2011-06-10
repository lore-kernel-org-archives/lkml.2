Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758201Ab1FJV5c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 17:57:32 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56144 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758146Ab1FJV5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 17:57:25 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: Joerg Roedel <Joerg.Roedel@amd.com>
Cc: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        David Brown <davidb@codeaurora.org>,
        David Woodhouse <dwmw2@infradead.org>,
        <iommu@lists.linux-foundation.org>, <linux-pci@vger.kernel.org>,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH v2 3/4] x86: amd_iommu: move to drivers/iommu/
Date: Sat, 11 Jun 2011 00:55:46 +0300
Message-Id: <1307742947-32118-4-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1307742947-32118-1-git-send-email-ohad@wizery.com>
References: <1307742947-32118-1-git-send-email-ohad@wizery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This should ease finding similarities with different platforms,
with the intention of solving problems once in a generic framework
which everyone can use.

Compile-tested on x86_64.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 arch/x86/Kconfig                               |   28 -----------------------
 arch/x86/kernel/Makefile                       |    2 +-
 drivers/iommu/Kconfig                          |   29 ++++++++++++++++++++++++
 drivers/iommu/Makefile                         |    1 +
 {arch/x86/kernel => drivers/iommu}/amd_iommu.c |    0
 5 files changed, 31 insertions(+), 29 deletions(-)
 rename {arch/x86/kernel => drivers/iommu}/amd_iommu.c (100%)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 460d573..1b6a2e2 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -680,34 +680,6 @@ config CALGARY_IOMMU_ENABLED_BY_DEFAULT
 	  Calgary anyway, pass 'iommu=calgary' on the kernel command line.
 	  If unsure, say Y.
 
-config AMD_IOMMU
-	bool "AMD IOMMU support"
-	select SWIOTLB
-	select PCI_MSI
-	select PCI_IOV
-	select IOMMU_API
-	depends on X86_64 && PCI && ACPI
-	---help---
-	  With this option you can enable support for AMD IOMMU hardware in
-	  your system. An IOMMU is a hardware component which provides
-	  remapping of DMA memory accesses from devices. With an AMD IOMMU you
-	  can isolate the the DMA memory of different devices and protect the
-	  system from misbehaving device drivers or hardware.
-
-	  You can find out if your system has an AMD IOMMU if you look into
-	  your BIOS for an option to enable it or if you have an IVRS ACPI
-	  table.
-
-config AMD_IOMMU_STATS
-	bool "Export AMD IOMMU statistics to debugfs"
-	depends on AMD_IOMMU
-	select DEBUG_FS
-	---help---
-	  This option enables code in the AMD IOMMU driver to collect various
-	  statistics about whats happening in the driver and exports that
-	  information to userspace via debugfs.
-	  If unsure, say N.
-
 # need this always selected by IOMMU for the VIA workaround
 config SWIOTLB
 	def_bool y if X86_64
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 90b06d4..aef0298 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -123,7 +123,7 @@ ifeq ($(CONFIG_X86_64),y)
 
 	obj-$(CONFIG_GART_IOMMU)	+= amd_gart_64.o aperture_64.o
 	obj-$(CONFIG_CALGARY_IOMMU)	+= pci-calgary_64.o tce_64.o
-	obj-$(CONFIG_AMD_IOMMU)		+= amd_iommu_init.o amd_iommu.o
+	obj-$(CONFIG_AMD_IOMMU)		+= amd_iommu_init.o
 
 	obj-$(CONFIG_PCI_MMCONFIG)	+= mmconf-fam10h_64.o
 	obj-y				+= vsmp_64.o
diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index 21a80bf..9246c5b 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -17,3 +17,32 @@ config MSM_IOMMU
 config IOMMU_PGTABLES_L2
 	def_bool y
 	depends on MSM_IOMMU && MMU && SMP && CPU_DCACHE_DISABLE=n
+
+# AMD IOMMU support
+config AMD_IOMMU
+	bool "AMD IOMMU support"
+	select SWIOTLB
+	select PCI_MSI
+	select PCI_IOV
+	select IOMMU_API
+	depends on X86_64 && PCI && ACPI
+	---help---
+	  With this option you can enable support for AMD IOMMU hardware in
+	  your system. An IOMMU is a hardware component which provides
+	  remapping of DMA memory accesses from devices. With an AMD IOMMU you
+	  can isolate the the DMA memory of different devices and protect the
+	  system from misbehaving device drivers or hardware.
+
+	  You can find out if your system has an AMD IOMMU if you look into
+	  your BIOS for an option to enable it or if you have an IVRS ACPI
+	  table.
+
+config AMD_IOMMU_STATS
+	bool "Export AMD IOMMU statistics to debugfs"
+	depends on AMD_IOMMU
+	select DEBUG_FS
+	---help---
+	  This option enables code in the AMD IOMMU driver to collect various
+	  statistics about whats happening in the driver and exports that
+	  information to userspace via debugfs.
+	  If unsure, say N.
diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
index 1a71c82..4237eaf 100644
--- a/drivers/iommu/Makefile
+++ b/drivers/iommu/Makefile
@@ -1,2 +1,3 @@
 obj-$(CONFIG_IOMMU_API) += iommu.o
 obj-$(CONFIG_MSM_IOMMU) += msm_iommu.o msm_iommu_dev.o
+obj-$(CONFIG_AMD_IOMMU) += amd_iommu.o
diff --git a/arch/x86/kernel/amd_iommu.c b/drivers/iommu/amd_iommu.c
similarity index 100%
rename from arch/x86/kernel/amd_iommu.c
rename to drivers/iommu/amd_iommu.c
-- 
1.7.1

