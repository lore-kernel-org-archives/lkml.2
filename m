Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148Ab1FHIgb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 04:36:31 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55107 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754290Ab1FHIgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 04:36:02 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: Joerg Roedel <Joerg.Roedel@amd.com>
Cc: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        David Brown <davidb@codeaurora.org>,
        David Woodhouse <dwmw2@infradead.org>,
        <iommu@lists.linux-foundation.org>, <linux-pci@vger.kernel.org>,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH 4/4] x86: intel-iommu: move to drivers/iommu/
Date: Wed,  8 Jun 2011 11:34:22 +0300
Message-Id: <1307522062-19273-5-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1307522062-19273-1-git-send-email-ohad@wizery.com>
References: <1307522062-19273-1-git-send-email-ohad@wizery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This should ease finding similarities with different platforms,
with the intention of solving problems once in a generic framework
which everyone can use.

Note: to move intel-iommu.c, the declaration of pci_find_upstream_pcie_bridge()
has to move from drivers/pci/pci.h to include/linux/pci.h. This is handled
in this patch, too.

Compile-tested on x86_64.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 arch/x86/Kconfig                     |   11 -----------
 drivers/iommu/Kconfig                |   11 +++++++++++
 drivers/iommu/Makefile               |    1 +
 drivers/{pci => iommu}/intel-iommu.c |    1 -
 drivers/pci/Makefile                 |    2 +-
 drivers/pci/pci.h                    |    2 --
 include/linux/pci.h                  |   11 +++++++++++
 7 files changed, 24 insertions(+), 15 deletions(-)
 rename drivers/{pci => iommu}/intel-iommu.c (99%)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 1b6a2e2..d22662c 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1912,17 +1912,6 @@ config PCI_CNB20LE_QUIRK
 
 	  You should say N unless you know you need this.
 
-config DMAR
-	bool "Support for DMA Remapping Devices (EXPERIMENTAL)"
-	depends on PCI_MSI && ACPI && EXPERIMENTAL
-	select IOMMU_API
-	help
-	  DMA remapping (DMAR) devices support enables independent address
-	  translations for Direct Memory Access (DMA) from devices.
-	  These DMA remapping devices are reported via ACPI tables
-	  and include PCI device scope covered by these DMA
-	  remapping devices.
-
 config DMAR_DEFAULT_ON
 	def_bool y
 	prompt "Enable DMA Remapping Devices by default"
diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index 555f5a8..b03a980 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -40,3 +40,14 @@ config AMD_IOMMU_STATS
 	  statistics about whats happening in the driver and exports that
 	  information to userspace via debugfs.
 	  If unsure, say N.
+
+config DMAR
+	bool "Support for DMA Remapping Devices (EXPERIMENTAL)"
+	depends on PCI_MSI && ACPI && EXPERIMENTAL
+	select IOMMU_API
+	help
+	  DMA remapping (DMAR) devices support enables independent address
+	  translations for Direct Memory Access (DMA) from devices.
+	  These DMA remapping devices are reported via ACPI tables
+	  and include PCI device scope covered by these DMA
+	  remapping devices.
diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
index d099d39..aaac56d 100644
--- a/drivers/iommu/Makefile
+++ b/drivers/iommu/Makefile
@@ -1,3 +1,4 @@
 obj-$(CONFIG_IOMMU_API) += iommu.o
 obj-$(CONFIG_MSM_IOMMU) += msm-iommu.o
 obj-$(CONFIG_AMD_IOMMU) += amd_iommu.o
+obj-$(CONFIG_DMAR) += intel-iommu.o
diff --git a/drivers/pci/intel-iommu.c b/drivers/iommu/intel-iommu.c
similarity index 99%
rename from drivers/pci/intel-iommu.c
rename to drivers/iommu/intel-iommu.c
index 59f17ac..fd7a055 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -42,7 +42,6 @@
 #include <linux/pci-ats.h>
 #include <asm/cacheflush.h>
 #include <asm/iommu.h>
-#include "pci.h"
 
 #define ROOT_SIZE		VTD_PAGE_SIZE
 #define CONTEXT_SIZE		VTD_PAGE_SIZE
diff --git a/drivers/pci/Makefile b/drivers/pci/Makefile
index c85f744..7826920 100644
--- a/drivers/pci/Makefile
+++ b/drivers/pci/Makefile
@@ -30,7 +30,7 @@ obj-$(CONFIG_PCI_MSI) += msi.o
 obj-$(CONFIG_HT_IRQ) += htirq.o
 
 # Build Intel IOMMU support
-obj-$(CONFIG_DMAR) += dmar.o iova.o intel-iommu.o
+obj-$(CONFIG_DMAR) += dmar.o iova.o
 
 obj-$(CONFIG_INTR_REMAP) += dmar.o intr_remapping.o
 
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 731e202..b7bf11d 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -184,8 +184,6 @@ pci_match_one_device(const struct pci_device_id *id, const struct pci_dev *dev)
 	return NULL;
 }
 
-struct pci_dev *pci_find_upstream_pcie_bridge(struct pci_dev *pdev);
-
 /* PCI slot sysfs helper code */
 #define to_pci_slot(s) container_of(s, struct pci_slot, kobj)
 
diff --git a/include/linux/pci.h b/include/linux/pci.h
index c446b5c..970bfe0 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1589,5 +1589,16 @@ int pci_vpd_find_tag(const u8 *buf, unsigned int off, unsigned int len, u8 rdt);
 int pci_vpd_find_info_keyword(const u8 *buf, unsigned int off,
 			      unsigned int len, const char *kw);
 
+/**
+ * pci_find_upstream_pcie_bridge - find upstream PCIe-to-PCI bridge of a device
+ * @pdev: the PCI device
+ *
+ * if the device is PCIE, return NULL
+ * if the device isn't connected to a PCIe bridge (that is its parent is a
+ * legacy PCI bridge and the bridge is directly connected to bus 0), return its
+ * parent
+ */
+struct pci_dev *pci_find_upstream_pcie_bridge(struct pci_dev *pdev);
+
 #endif /* __KERNEL__ */
 #endif /* LINUX_PCI_H */
-- 
1.7.1

