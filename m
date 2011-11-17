Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757996Ab1KQRJh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 12:09:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22029 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754291Ab1KQRJf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 12:09:35 -0500
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH] iommu: Include MSI susceptibility to DMA in creating iommu
 groups
To: Joerg.Roedel@amd.com, iommu@lists.linux-foundation.org
Cc: dwmw2@infradead.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, alex.williamson@redhat.com
Date: Thu, 17 Nov 2011 10:09:26 -0700
Message-ID: <20111117170800.3125.84150.stgit@bling.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IOMMU drivers should account for the platform's susceptibility to
DMA triggered MSI interrupts in creating IOMMU groups.  Skip
devices when the IOMMU can't isolate MSI from DMA, but allow
an iommu=group_unsafe_msi option for opt-in.  This removes the
leap in logic for users that IOMMU_CAP_INTR_REMAP is required for
interrupt security when they may be running on a non-x86 platform
that does not have this dependency.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 Documentation/kernel-parameters.txt |    9 ++++++---
 arch/ia64/include/asm/iommu.h       |    2 ++
 arch/ia64/kernel/pci-dma.c          |    1 +
 arch/x86/include/asm/iommu.h        |    1 +
 arch/x86/kernel/pci-dma.c           |   12 ++++++++++++
 drivers/iommu/amd_iommu.c           |    7 +++++++
 drivers/iommu/intel-iommu.c         |    7 +++++++
 7 files changed, 36 insertions(+), 3 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 9d5ac6c..ffa43b7 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1059,9 +1059,12 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 		nomerge
 		forcesac
 		soft
-		pt		[x86, IA-64]
-		group_mf	[x86, IA-64]
-
+		pt			[x86, IA-64]
+		group_mf		[x86, IA-64]
+			Group multifunction devices together in IOMMU API.
+		group_unsafe_msi	[x86, IA-64]
+			Allow grouping of devices even when the platfom
+			does not provide MSI isolation in IOMMU API.
 
 	io7=		[HW] IO7 for Marvel based alpha systems
 			See comment before marvel_specify_io7 in
diff --git a/arch/ia64/include/asm/iommu.h b/arch/ia64/include/asm/iommu.h
index b6a809f..b726572 100644
--- a/arch/ia64/include/asm/iommu.h
+++ b/arch/ia64/include/asm/iommu.h
@@ -12,11 +12,13 @@ extern int force_iommu, no_iommu;
 extern int iommu_pass_through;
 extern int iommu_detected;
 extern int iommu_group_mf;
+extern int iommu_group_unsafe_msi;
 #else
 #define iommu_pass_through	(0)
 #define no_iommu		(1)
 #define iommu_detected		(0)
 #define iommu_group_mf		(0)
+#define iommu_group_unsafe_msi	(0)
 #endif
 extern void iommu_dma_init(void);
 extern void machvec_init(const char *name);
diff --git a/arch/ia64/kernel/pci-dma.c b/arch/ia64/kernel/pci-dma.c
index eb11757..63721ce 100644
--- a/arch/ia64/kernel/pci-dma.c
+++ b/arch/ia64/kernel/pci-dma.c
@@ -34,6 +34,7 @@ int force_iommu __read_mostly;
 
 int iommu_pass_through;
 int iommu_group_mf;
+int iommu_group_unsafe_msi;
 
 /* Dummy device used for NULL arguments (normally ISA). Better would
    be probably a smaller DMA mask, but this is bug-to-bug compatible
diff --git a/arch/x86/include/asm/iommu.h b/arch/x86/include/asm/iommu.h
index dffc38e..e3d289c 100644
--- a/arch/x86/include/asm/iommu.h
+++ b/arch/x86/include/asm/iommu.h
@@ -6,6 +6,7 @@ extern int force_iommu, no_iommu;
 extern int iommu_detected;
 extern int iommu_pass_through;
 extern int iommu_group_mf;
+extern int iommu_group_unsafe_msi;
 
 /* 10 seconds */
 #define DMAR_OPERATION_TIMEOUT ((cycles_t) tsc_khz*10*1000)
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 1c4d769..80eb6b6 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -54,6 +54,16 @@ int iommu_pass_through __read_mostly;
  */
 int iommu_group_mf __read_mostly;
 
+/*
+ * For the iommu_device_group interface, we not only need to be concerned
+ * with DMA isolation between devices, but also DMA isolation that could
+ * affect the platform, including MSI isolation.  If a platform is
+ * susceptible to malicious DMA writes triggering MSI interrupts, the
+ * IOMMU driver can't reasonably group devices.  This allows the iommu
+ * driver to ignore MSI isolation when creating groups.
+ */
+int iommu_group_unsafe_msi __read_mostly;
+
 extern struct iommu_table_entry __iommu_table[], __iommu_table_end[];
 
 /* Dummy device used for NULL arguments (normally ISA). */
@@ -180,6 +190,8 @@ static __init int iommu_setup(char *p)
 			iommu_pass_through = 1;
 		if (!strncmp(p, "group_mf", 8))
 			iommu_group_mf = 1;
+		if (!strncmp(p, "group_unsafe_msi", 16))
+			iommu_group_unsafe_msi = 1;
 
 		gart_parse_options(p);
 
diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index ad074dc..5f55e7a 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -2794,6 +2794,13 @@ static int amd_iommu_device_group(struct device *dev, unsigned int *groupid)
 	struct pci_dev *pdev = to_pci_dev(dev);
 	u16 devid;
 
+	if (!iommu_group_unsafe_msi) {
+		printk_once(KERN_NOTICE "%s: "
+			    "IOMMU device group disabled without interrupt remapping support",
+			    pci_bus_type.name);
+		return -ENODEV;
+	}
+
 	if (!dev_data)
 		return -ENODEV;
 
diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index e918f72..f3fcd69 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -4094,6 +4094,13 @@ static int intel_iommu_device_group(struct device *dev, unsigned int *groupid)
 		u32 group;
 	} id;
 
+	if (!intr_remapping_enabled && !iommu_group_unsafe_msi) {
+		printk_once(KERN_NOTICE "%s: "
+			    "IOMMU device group disabled without interrupt remapping support",
+			    pci_bus_type.name);
+		return -ENODEV;
+	}
+
 	if (iommu_no_mapping(dev))
 		return -ENODEV;
 

