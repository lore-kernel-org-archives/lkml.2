Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932490Ab1LENlV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 08:41:21 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:38321
	"EHLO VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932319Ab1LENfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 08:35:08 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-FB-SS: 0,
X-WSS-ID: 0LVQGED-02-AUM-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 07/22] iommu/amd: Put IOMMUv2 capable devices in pt_domain
Date: Mon, 5 Dec 2011 14:34:22 +0100
Message-ID: <1323092077-25501-8-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1323092077-25501-1-git-send-email-joerg.roedel@amd.com>
References: <1323092077-25501-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the device starts to use IOMMUv2 features the dma handles
need to stay valid. The only sane way to do this is to use a
identity mapping for the device and not translate it by the
iommu. This is implemented with this patch. Since this lifts
the device-isolation there is also a new kernel parameter
which allows to disable that feature.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 Documentation/kernel-parameters.txt |    5 ++
 drivers/iommu/amd_iommu.c           |   94 +++++++++++++++++++++++++++++------
 drivers/iommu/amd_iommu_init.c      |    4 ++
 drivers/iommu/amd_iommu_types.h     |    4 ++
 4 files changed, 91 insertions(+), 16 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index a0c5c5f..d55f2ad 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -329,6 +329,11 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 				    is a lot of faster
 			off	  - do not initialize any AMD IOMMU found in
 				    the system
+			force_isolation - Force device isolation for all
+					  devices. The IOMMU driver is not
+					  allowed anymore to lift isolation
+					  requirements as needed. This option
+					  does not override iommu=pt
 
 	amijoy.map=	[HW,JOY] Amiga joystick support
 			Map of devices attached to JOY0DAT and JOY1DAT
diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index f2eec1c..bde2776 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -67,6 +67,7 @@ struct iommu_cmd {
 };
 
 static void update_domain(struct protection_domain *domain);
+static int __init alloc_passthrough_domain(void);
 
 /****************************************************************************
  *
@@ -147,6 +148,24 @@ static struct iommu_dev_data *get_dev_data(struct device *dev)
 	return dev->archdata.iommu;
 }
 
+static bool pci_iommuv2_capable(struct pci_dev *pdev)
+{
+	static const int caps[] = {
+		PCI_EXT_CAP_ID_ATS,
+		PCI_PRI_CAP,
+		PCI_PASID_CAP,
+	};
+	int i, pos;
+
+	for (i = 0; i < 3; ++i) {
+		pos = pci_find_ext_capability(pdev, caps[i]);
+		if (pos == 0)
+			return false;
+	}
+
+	return true;
+}
+
 /*
  * In this function the list of preallocated protection domains is traversed to
  * find the domain for a specific device
@@ -204,6 +223,7 @@ static bool check_device(struct device *dev)
 
 static int iommu_init_device(struct device *dev)
 {
+	struct pci_dev *pdev = to_pci_dev(dev);
 	struct iommu_dev_data *dev_data;
 	u16 alias;
 
@@ -228,6 +248,13 @@ static int iommu_init_device(struct device *dev)
 		dev_data->alias_data = alias_data;
 	}
 
+	if (pci_iommuv2_capable(pdev)) {
+		struct amd_iommu *iommu;
+
+		iommu              = amd_iommu_rlookup_table[dev_data->devid];
+		dev_data->iommu_v2 = iommu->is_iommu_v2;
+	}
+
 	dev->archdata.iommu = dev_data;
 
 	return 0;
@@ -1762,7 +1789,7 @@ static void __detach_device(struct iommu_dev_data *dev_data)
 	 * passthrough domain if it is detached from any other domain.
 	 * Make sure we can deassign from the pt_domain itself.
 	 */
-	if (iommu_pass_through &&
+	if (dev_data->passthrough &&
 	    (dev_data->domain == NULL && domain != pt_domain))
 		__attach_device(dev_data, pt_domain);
 }
@@ -1820,18 +1847,20 @@ static struct protection_domain *domain_for_device(struct device *dev)
 static int device_change_notifier(struct notifier_block *nb,
 				  unsigned long action, void *data)
 {
-	struct device *dev = data;
-	u16 devid;
-	struct protection_domain *domain;
 	struct dma_ops_domain *dma_domain;
+	struct protection_domain *domain;
+	struct iommu_dev_data *dev_data;
+	struct device *dev = data;
 	struct amd_iommu *iommu;
 	unsigned long flags;
+	u16 devid;
 
 	if (!check_device(dev))
 		return 0;
 
-	devid  = get_device_id(dev);
-	iommu  = amd_iommu_rlookup_table[devid];
+	devid    = get_device_id(dev);
+	iommu    = amd_iommu_rlookup_table[devid];
+	dev_data = get_dev_data(dev);
 
 	switch (action) {
 	case BUS_NOTIFY_UNBOUND_DRIVER:
@@ -1840,7 +1869,7 @@ static int device_change_notifier(struct notifier_block *nb,
 
 		if (!domain)
 			goto out;
-		if (iommu_pass_through)
+		if (dev_data->passthrough)
 			break;
 		detach_device(dev);
 		break;
@@ -2436,8 +2465,9 @@ static int amd_iommu_dma_supported(struct device *dev, u64 mask)
  */
 static void prealloc_protection_domains(void)
 {
-	struct pci_dev *dev = NULL;
+	struct iommu_dev_data *dev_data;
 	struct dma_ops_domain *dma_dom;
+	struct pci_dev *dev = NULL;
 	u16 devid;
 
 	for_each_pci_dev(dev) {
@@ -2446,6 +2476,16 @@ static void prealloc_protection_domains(void)
 		if (!check_device(&dev->dev))
 			continue;
 
+		dev_data = get_dev_data(&dev->dev);
+		if (!amd_iommu_force_isolation && dev_data->iommu_v2) {
+			/* Make sure passthrough domain is allocated */
+			alloc_passthrough_domain();
+			dev_data->passthrough = true;
+			attach_device(&dev->dev, pt_domain);
+			pr_info("AMD-Vi: Using passthough domain for device %s\n",
+				dev_name(&dev->dev));
+		}
+
 		/* Is there already any domain for it? */
 		if (domain_for_device(&dev->dev))
 			continue;
@@ -2476,6 +2516,7 @@ static struct dma_map_ops amd_iommu_dma_ops = {
 
 static unsigned device_dma_ops_init(void)
 {
+	struct iommu_dev_data *dev_data;
 	struct pci_dev *pdev = NULL;
 	unsigned unhandled = 0;
 
@@ -2485,7 +2526,12 @@ static unsigned device_dma_ops_init(void)
 			continue;
 		}
 
-		pdev->dev.archdata.dma_ops = &amd_iommu_dma_ops;
+		dev_data = get_dev_data(&pdev->dev);
+
+		if (!dev_data->passthrough)
+			pdev->dev.archdata.dma_ops = &amd_iommu_dma_ops;
+		else
+			pdev->dev.archdata.dma_ops = &nommu_dma_ops;
 	}
 
 	return unhandled;
@@ -2612,6 +2658,20 @@ out_err:
 	return NULL;
 }
 
+static int __init alloc_passthrough_domain(void)
+{
+	if (pt_domain != NULL)
+		return 0;
+
+	/* allocate passthrough domain */
+	pt_domain = protection_domain_alloc();
+	if (!pt_domain)
+		return -ENOMEM;
+
+	pt_domain->mode = PAGE_MODE_NONE;
+
+	return 0;
+}
 static int amd_iommu_domain_init(struct iommu_domain *dom)
 {
 	struct protection_domain *domain;
@@ -2798,21 +2858,23 @@ static struct iommu_ops amd_iommu_ops = {
 
 int __init amd_iommu_init_passthrough(void)
 {
-	struct amd_iommu *iommu;
+	struct iommu_dev_data *dev_data;
 	struct pci_dev *dev = NULL;
+	struct amd_iommu *iommu;
 	u16 devid;
+	int ret;
 
-	/* allocate passthrough domain */
-	pt_domain = protection_domain_alloc();
-	if (!pt_domain)
-		return -ENOMEM;
-
-	pt_domain->mode |= PAGE_MODE_NONE;
+	ret = alloc_passthrough_domain();
+	if (ret)
+		return ret;
 
 	for_each_pci_dev(dev) {
 		if (!check_device(&dev->dev))
 			continue;
 
+		dev_data = get_dev_data(&dev->dev);
+		dev_data->passthrough = true;
+
 		devid = get_device_id(&dev->dev);
 
 		iommu = amd_iommu_rlookup_table[devid];
diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index d1e5067..7c3fd57 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -146,6 +146,8 @@ u32 amd_iommu_max_pasids __read_mostly = ~0;
 
 bool amd_iommu_v2_present __read_mostly;
 
+bool amd_iommu_force_isolation __read_mostly;
+
 /*
  * The ACPI table parsing functions set this variable on an error
  */
@@ -1642,6 +1644,8 @@ static int __init parse_amd_iommu_options(char *str)
 			amd_iommu_unmap_flush = true;
 		if (strncmp(str, "off", 3) == 0)
 			amd_iommu_disabled = true;
+		if (strncmp(str, "force_isolation", 15) == 0)
+			amd_iommu_force_isolation = true;
 	}
 
 	return 1;
diff --git a/drivers/iommu/amd_iommu_types.h b/drivers/iommu/amd_iommu_types.h
index 535cd07..6897645 100644
--- a/drivers/iommu/amd_iommu_types.h
+++ b/drivers/iommu/amd_iommu_types.h
@@ -331,6 +331,8 @@ struct iommu_dev_data {
 	struct protection_domain *domain; /* Domain the device is bound to */
 	atomic_t bind;			  /* Domain attach reverent count */
 	u16 devid;			  /* PCI Device ID */
+	bool iommu_v2;			  /* Device can make use of IOMMUv2 */
+	bool passthrough;		  /* Default for device is pt_domain */
 	struct {
 		bool enabled;
 		int qdep;
@@ -576,6 +578,8 @@ extern u32 amd_iommu_max_pasids;
 
 extern bool amd_iommu_v2_present;
 
+extern bool amd_iommu_force_isolation;
+
 /* takes bus and device/function and returns the device id
  * FIXME: should that be in generic PCI code? */
 static inline u16 calc_devid(u8 bus, u8 devfn)
-- 
1.7.5.4


