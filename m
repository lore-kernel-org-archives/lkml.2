Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752437Ab1JUT45 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 15:56:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45103 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752317Ab1JUT4y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 15:56:54 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 4/4] iommu: Add option to group multi-function devices
To: joerg.roedel@amd.com, dwmw2@infradead.org,
        iommu@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, chrisw@redhat.com, agraf@suse.de,
        dwg@au1.ibm.com, scottwood@freescale.com, B08248@freescale.com,
        benh@kernel.crashing.org, alex.williamson@redhat.com
Date: Fri, 21 Oct 2011 13:56:24 -0600
Message-ID: <20111021195624.8438.75945.stgit@s20.home>
In-Reply-To: <20111021195412.8438.9951.stgit@s20.home>
References: <20111021195412.8438.9951.stgit@s20.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The option iommu=group_mf indicates the that the iommu driver should
expose all functions of a multi-function PCI device as the same
iommu_device_group.  This is useful for disallowing individual functions
being exposed as independent devices to userspace as there are often
hidden dependencies.  Virtual functions are not affected by this option.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 Documentation/kernel-parameters.txt |    4 +++-
 arch/ia64/include/asm/iommu.h       |    2 ++
 arch/ia64/kernel/pci-dma.c          |    1 +
 arch/x86/include/asm/iommu.h        |    1 +
 arch/x86/kernel/pci-dma.c           |   11 +++++++++++
 drivers/iommu/amd_iommu.c           |   10 +++++++++-
 drivers/iommu/intel-iommu.c         |    3 +++
 7 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 614d038..db78b6f 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1036,7 +1036,9 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 		nomerge
 		forcesac
 		soft
-		pt	[x86, IA-64]
+		pt		[x86, IA-64]
+		group_mf	[x86, IA-64]
+
 
 	io7=		[HW] IO7 for Marvel based alpha systems
 			See comment before marvel_specify_io7 in
diff --git a/arch/ia64/include/asm/iommu.h b/arch/ia64/include/asm/iommu.h
index 745e095..196b7b2 100644
--- a/arch/ia64/include/asm/iommu.h
+++ b/arch/ia64/include/asm/iommu.h
@@ -11,8 +11,10 @@ extern int force_iommu, no_iommu;
 extern int iommu_detected;
 #ifdef	CONFIG_DMAR
 extern int iommu_pass_through;
+extern int iommu_group_mf;
 #else
 #define iommu_pass_through	(0)
+#define iommu_group_mf		(0)
 #endif
 extern void iommu_dma_init(void);
 extern void machvec_init(const char *name);
diff --git a/arch/ia64/kernel/pci-dma.c b/arch/ia64/kernel/pci-dma.c
index f6b1ff0..7b024c7 100644
--- a/arch/ia64/kernel/pci-dma.c
+++ b/arch/ia64/kernel/pci-dma.c
@@ -33,6 +33,7 @@ int force_iommu __read_mostly;
 #endif
 
 int iommu_pass_through;
+int iommu_group_mf;
 
 /* Dummy device used for NULL arguments (normally ISA). Better would
    be probably a smaller DMA mask, but this is bug-to-bug compatible
diff --git a/arch/x86/include/asm/iommu.h b/arch/x86/include/asm/iommu.h
index 345c99c..dffc38e 100644
--- a/arch/x86/include/asm/iommu.h
+++ b/arch/x86/include/asm/iommu.h
@@ -5,6 +5,7 @@ extern struct dma_map_ops nommu_dma_ops;
 extern int force_iommu, no_iommu;
 extern int iommu_detected;
 extern int iommu_pass_through;
+extern int iommu_group_mf;
 
 /* 10 seconds */
 #define DMAR_OPERATION_TIMEOUT ((cycles_t) tsc_khz*10*1000)
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index b49d00d..3b730fb 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -44,6 +44,15 @@ int iommu_detected __read_mostly = 0;
  */
 int iommu_pass_through __read_mostly;
 
+/*
+ * Group multi-function PCI devices into a single device-group for the
+ * iommu_device_group interface.  This tells the iommu driver to pretend
+ * it cannot distinguish between functions of a device, exposing only one
+ * group for the device.  Useful for disallowing use of individual PCI
+ * functions from userspace drivers.
+ */
+int iommu_group_mf __read_mostly;
+
 extern struct iommu_table_entry __iommu_table[], __iommu_table_end[];
 
 /* Dummy device used for NULL arguments (normally ISA). */
@@ -168,6 +177,8 @@ static __init int iommu_setup(char *p)
 #endif
 		if (!strncmp(p, "pt", 2))
 			iommu_pass_through = 1;
+		if (!strncmp(p, "group_mf", 8))
+			iommu_group_mf = 1;
 
 		gart_parse_options(p);
 
diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 1d82b63..6f75536 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -2776,11 +2776,19 @@ static int amd_iommu_domain_has_cap(struct iommu_domain *domain,
 static int amd_iommu_device_group(struct device *dev, unsigned int *groupid)
 {
 	struct iommu_dev_data *dev_data = dev->archdata.iommu;
+	struct pci_dev *pdev = to_pci_dev(dev);
+	u16 devid;
 
 	if (!dev_data)
 		return -ENODEV;
 
-	*groupid = amd_iommu_alias_table[dev_data->devid];
+	if (pdev->is_virtfn || !iommu_group_mf)
+		devid = dev_data->devid;
+	else
+		devid = calc_devid(pdev->bus->number,
+				   PCI_DEVFN(PCI_SLOT(pdev->devfn), 0));
+
+	*groupid = amd_iommu_alias_table[devid];
 
 	return 0;
 }
diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index d23d66a..a5e1a2f 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -3939,6 +3939,9 @@ static int intel_iommu_device_group(struct device *dev, unsigned int *groupid)
 		}
 	}
 
+	if (!pdev->is_virtfn && iommu_group_mf)
+		id.pci.devfn = PCI_DEVFN(PCI_SLOT(id.pci.devfn), 0);
+
 	*groupid = id.group;
 
 	return 0;

