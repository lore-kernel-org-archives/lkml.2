Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758204Ab1FJV57 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 17:57:59 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56144 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758152Ab1FJV51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 17:57:27 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: Joerg Roedel <Joerg.Roedel@amd.com>
Cc: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        David Brown <davidb@codeaurora.org>,
        David Woodhouse <dwmw2@infradead.org>,
        <iommu@lists.linux-foundation.org>, <linux-pci@vger.kernel.org>,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH v2 4/4] x86/ia64: intel-iommu: move to drivers/iommu/
Date: Sat, 11 Jun 2011 00:55:47 +0300
Message-Id: <1307742947-32118-5-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1307742947-32118-1-git-send-email-ohad@wizery.com>
References: <1307742947-32118-1-git-send-email-ohad@wizery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This should ease finding similarities with different platforms,
with the intention of solving problems once in a generic framework
which everyone can use.

Note: to move intel-iommu.c, the declaration of pci_find_upstream_pcie_bridge()
has to move from drivers/pci/pci.h to include/linux/pci.h. This is handled
in this patch, too.

As suggested, also drop DMAR's EXPERIMENTAL tag while we're at it.

Compile-tested on x86_64.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
sorry, not tested on ia64 (not even compiled)

 arch/ia64/Kconfig                       |   21 -------------
 arch/x86/Kconfig                        |   50 -------------------------------
 drivers/iommu/Kconfig                   |   49 ++++++++++++++++++++++++++++++
 drivers/iommu/Makefile                  |    2 +
 drivers/{pci => iommu}/dmar.c           |    0
 drivers/{pci => iommu}/intel-iommu.c    |    1 -
 drivers/{pci => iommu}/intr_remapping.c |    1 -
 drivers/{pci => iommu}/intr_remapping.h |    0
 drivers/{pci => iommu}/iova.c           |    0
 drivers/pci/Makefile                    |    5 ---
 drivers/pci/pci.h                       |    2 -
 include/linux/pci.h                     |   11 +++++++
 12 files changed, 62 insertions(+), 80 deletions(-)
 rename drivers/{pci => iommu}/dmar.c (100%)
 rename drivers/{pci => iommu}/intel-iommu.c (99%)
 rename drivers/{pci => iommu}/intr_remapping.c (99%)
 rename drivers/{pci => iommu}/intr_remapping.h (100%)
 rename drivers/{pci => iommu}/iova.c (100%)

diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index 9929e4e..7336ba6 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -627,27 +627,6 @@ source "drivers/pci/hotplug/Kconfig"
 
 source "drivers/pcmcia/Kconfig"
 
-config DMAR
-        bool "Support for DMA Remapping Devices (EXPERIMENTAL)"
-        depends on IA64_GENERIC && ACPI && EXPERIMENTAL
-	help
-	  DMA remapping (DMAR) devices support enables independent address
-	  translations for Direct Memory Access (DMA) from devices.
-	  These DMA remapping devices are reported via ACPI tables
-	  and include PCI device scope covered by these DMA
-	  remapping devices.
-
-config DMAR_DEFAULT_ON
-	def_bool y
-	prompt "Enable DMA Remapping Devices by default"
-	depends on DMAR
-	help
-	  Selecting this option will enable a DMAR device at boot time if
-	  one is found. If this option is not selected, DMAR support can
-	  be enabled by passing intel_iommu=on to the kernel. It is
-	  recommended you say N here while the DMAR code remains
-	  experimental.
-
 endmenu
 
 endif
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 1b6a2e2..a169573 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1912,56 +1912,6 @@ config PCI_CNB20LE_QUIRK
 
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
-config DMAR_DEFAULT_ON
-	def_bool y
-	prompt "Enable DMA Remapping Devices by default"
-	depends on DMAR
-	help
-	  Selecting this option will enable a DMAR device at boot time if
-	  one is found. If this option is not selected, DMAR support can
-	  be enabled by passing intel_iommu=on to the kernel. It is
-	  recommended you say N here while the DMAR code remains
-	  experimental.
-
-config DMAR_BROKEN_GFX_WA
-	bool "Workaround broken graphics drivers (going away soon)"
-	depends on DMAR && BROKEN
-	---help---
-	  Current Graphics drivers tend to use physical address
-	  for DMA and avoid using DMA APIs. Setting this config
-	  option permits the IOMMU driver to set a unity map for
-	  all the OS-visible memory. Hence the driver can continue
-	  to use physical addresses for DMA, at least until this
-	  option is removed in the 2.6.32 kernel.
-
-config DMAR_FLOPPY_WA
-	def_bool y
-	depends on DMAR
-	---help---
-	  Floppy disk drivers are known to bypass DMA API calls
-	  thereby failing to work when IOMMU is enabled. This
-	  workaround will setup a 1:1 mapping for the first
-	  16MiB to make floppy (an ISA device) work.
-
-config INTR_REMAP
-	bool "Support for Interrupt Remapping (EXPERIMENTAL)"
-	depends on X86_64 && X86_IO_APIC && PCI_MSI && ACPI && EXPERIMENTAL
-	---help---
-	  Supports Interrupt remapping for IO-APIC and MSI devices.
-	  To use x2apic mode in the CPU's which support x2APIC enhancements or
-	  to support platforms with CPU's having > 8 bit APIC ID, say Y.
-
 source "drivers/pci/pcie/Kconfig"
 
 source "drivers/pci/Kconfig"
diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index 9246c5b..e2a5f14 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -46,3 +46,52 @@ config AMD_IOMMU_STATS
 	  statistics about whats happening in the driver and exports that
 	  information to userspace via debugfs.
 	  If unsure, say N.
+
+# Intel IOMMU support
+config DMAR
+	bool "Support for DMA Remapping Devices"
+	depends on PCI_MSI && ACPI && (X86 || IA64_GENERIC)
+	select IOMMU_API
+	help
+	  DMA remapping (DMAR) devices support enables independent address
+	  translations for Direct Memory Access (DMA) from devices.
+	  These DMA remapping devices are reported via ACPI tables
+	  and include PCI device scope covered by these DMA
+	  remapping devices.
+
+config DMAR_DEFAULT_ON
+	def_bool y
+	prompt "Enable DMA Remapping Devices by default"
+	depends on DMAR
+	help
+	  Selecting this option will enable a DMAR device at boot time if
+	  one is found. If this option is not selected, DMAR support can
+	  be enabled by passing intel_iommu=on to the kernel.
+
+config DMAR_BROKEN_GFX_WA
+	bool "Workaround broken graphics drivers (going away soon)"
+	depends on DMAR && BROKEN && X86
+	---help---
+	  Current Graphics drivers tend to use physical address
+	  for DMA and avoid using DMA APIs. Setting this config
+	  option permits the IOMMU driver to set a unity map for
+	  all the OS-visible memory. Hence the driver can continue
+	  to use physical addresses for DMA, at least until this
+	  option is removed in the 2.6.32 kernel.
+
+config DMAR_FLOPPY_WA
+	def_bool y
+	depends on DMAR && X86
+	---help---
+	  Floppy disk drivers are known to bypass DMA API calls
+	  thereby failing to work when IOMMU is enabled. This
+	  workaround will setup a 1:1 mapping for the first
+	  16MiB to make floppy (an ISA device) work.
+
+config INTR_REMAP
+	bool "Support for Interrupt Remapping (EXPERIMENTAL)"
+	depends on X86_64 && X86_IO_APIC && PCI_MSI && ACPI && EXPERIMENTAL
+	---help---
+	  Supports Interrupt remapping for IO-APIC and MSI devices.
+	  To use x2apic mode in the CPU's which support x2APIC enhancements or
+	  to support platforms with CPU's having > 8 bit APIC ID, say Y.
diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
index 4237eaf..49e9c0f 100644
--- a/drivers/iommu/Makefile
+++ b/drivers/iommu/Makefile
@@ -1,3 +1,5 @@
 obj-$(CONFIG_IOMMU_API) += iommu.o
 obj-$(CONFIG_MSM_IOMMU) += msm_iommu.o msm_iommu_dev.o
 obj-$(CONFIG_AMD_IOMMU) += amd_iommu.o
+obj-$(CONFIG_DMAR) += dmar.o iova.o intel-iommu.o
+obj-$(CONFIG_INTR_REMAP) += dmar.o intr_remapping.o
diff --git a/drivers/pci/dmar.c b/drivers/iommu/dmar.c
similarity index 100%
rename from drivers/pci/dmar.c
rename to drivers/iommu/dmar.c
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
diff --git a/drivers/pci/intr_remapping.c b/drivers/iommu/intr_remapping.c
similarity index 99%
rename from drivers/pci/intr_remapping.c
rename to drivers/iommu/intr_remapping.c
index 3607faf..1a89d4a 100644
--- a/drivers/pci/intr_remapping.c
+++ b/drivers/iommu/intr_remapping.c
@@ -13,7 +13,6 @@
 #include "intr_remapping.h"
 #include <acpi/acpi.h>
 #include <asm/pci-direct.h>
-#include "pci.h"
 
 static struct ioapic_scope ir_ioapic[MAX_IO_APICS];
 static struct hpet_scope ir_hpet[MAX_HPET_TBS];
diff --git a/drivers/pci/intr_remapping.h b/drivers/iommu/intr_remapping.h
similarity index 100%
rename from drivers/pci/intr_remapping.h
rename to drivers/iommu/intr_remapping.h
diff --git a/drivers/pci/iova.c b/drivers/iommu/iova.c
similarity index 100%
rename from drivers/pci/iova.c
rename to drivers/iommu/iova.c
diff --git a/drivers/pci/Makefile b/drivers/pci/Makefile
index c85f744..f7739d0 100644
--- a/drivers/pci/Makefile
+++ b/drivers/pci/Makefile
@@ -29,11 +29,6 @@ obj-$(CONFIG_PCI_MSI) += msi.o
 # Build the Hypertransport interrupt support
 obj-$(CONFIG_HT_IRQ) += htirq.o
 
-# Build Intel IOMMU support
-obj-$(CONFIG_DMAR) += dmar.o iova.o intel-iommu.o
-
-obj-$(CONFIG_INTR_REMAP) += dmar.o intr_remapping.o
-
 obj-$(CONFIG_PCI_IOV) += iov.o
 
 #
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

