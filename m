Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932603Ab2GEMnb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 08:43:31 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:17387
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932526Ab2GEMhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 08:37:03 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah107ah)
X-WSS-ID: 0M6OTPK-01-2UY-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 05/28] iommu/amd: Split out PCI related parts of IOMMU initialization
Date: Thu, 5 Jul 2012 14:36:25 +0200
Message-ID: <1341491808-23083-6-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1341491808-23083-1-git-send-email-joerg.roedel@amd.com>
References: <1341491808-23083-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For interrupt remapping the relevant IOMMU initialization
needs to run earlier at boot when the PCI subsystem is not
yet initialized. To support that this patch splits the parts
of IOMMU initialization which need PCI accesses out of the
initial setup path so that this can be done later.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/amd_iommu_init.c  |  224 +++++++++++++++++++++------------------
 drivers/iommu/amd_iommu_types.h |    5 +-
 2 files changed, 121 insertions(+), 108 deletions(-)

diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index fb118bb..1354497 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -721,90 +721,6 @@ static void __init set_device_exclusion_range(u16 devid, struct ivmd_header *m)
 }
 
 /*
- * This function reads some important data from the IOMMU PCI space and
- * initializes the driver data structure with it. It reads the hardware
- * capabilities and the first/last device entries
- */
-static void __init init_iommu_from_pci(struct amd_iommu *iommu)
-{
-	int cap_ptr = iommu->cap_ptr;
-	u32 range, misc, low, high;
-	int i, j;
-
-	pci_read_config_dword(iommu->dev, cap_ptr + MMIO_CAP_HDR_OFFSET,
-			      &iommu->cap);
-	pci_read_config_dword(iommu->dev, cap_ptr + MMIO_RANGE_OFFSET,
-			      &range);
-	pci_read_config_dword(iommu->dev, cap_ptr + MMIO_MISC_OFFSET,
-			      &misc);
-
-	iommu->first_device = calc_devid(MMIO_GET_BUS(range),
-					 MMIO_GET_FD(range));
-	iommu->last_device = calc_devid(MMIO_GET_BUS(range),
-					MMIO_GET_LD(range));
-	iommu->evt_msi_num = MMIO_MSI_NUM(misc);
-
-	if (!(iommu->cap & (1 << IOMMU_CAP_IOTLB)))
-		amd_iommu_iotlb_sup = false;
-
-	/* read extended feature bits */
-	low  = readl(iommu->mmio_base + MMIO_EXT_FEATURES);
-	high = readl(iommu->mmio_base + MMIO_EXT_FEATURES + 4);
-
-	iommu->features = ((u64)high << 32) | low;
-
-	if (iommu_feature(iommu, FEATURE_GT)) {
-		int glxval;
-		u32 pasids;
-		u64 shift;
-
-		shift   = iommu->features & FEATURE_PASID_MASK;
-		shift >>= FEATURE_PASID_SHIFT;
-		pasids  = (1 << shift);
-
-		amd_iommu_max_pasids = min(amd_iommu_max_pasids, pasids);
-
-		glxval   = iommu->features & FEATURE_GLXVAL_MASK;
-		glxval >>= FEATURE_GLXVAL_SHIFT;
-
-		if (amd_iommu_max_glx_val == -1)
-			amd_iommu_max_glx_val = glxval;
-		else
-			amd_iommu_max_glx_val = min(amd_iommu_max_glx_val, glxval);
-	}
-
-	if (iommu_feature(iommu, FEATURE_GT) &&
-	    iommu_feature(iommu, FEATURE_PPR)) {
-		iommu->is_iommu_v2   = true;
-		amd_iommu_v2_present = true;
-	}
-
-	if (!is_rd890_iommu(iommu->dev))
-		return;
-
-	/*
-	 * Some rd890 systems may not be fully reconfigured by the BIOS, so
-	 * it's necessary for us to store this information so it can be
-	 * reprogrammed on resume
-	 */
-
-	pci_read_config_dword(iommu->dev, iommu->cap_ptr + 4,
-			      &iommu->stored_addr_lo);
-	pci_read_config_dword(iommu->dev, iommu->cap_ptr + 8,
-			      &iommu->stored_addr_hi);
-
-	/* Low bit locks writes to configuration space */
-	iommu->stored_addr_lo &= ~1;
-
-	for (i = 0; i < 6; i++)
-		for (j = 0; j < 0x12; j++)
-			iommu->stored_l1[i][j] = iommu_read_l1(iommu, i, j);
-
-	for (i = 0; i < 0x83; i++)
-		iommu->stored_l2[i] = iommu_read_l2(iommu, i);
-}
-
-/*
  * Takes a pointer to an AMD IOMMU entry in the ACPI table and
  * initializes the hardware and our data structures with it.
  */
@@ -1020,13 +936,7 @@ static int __init init_iommu_one(struct amd_iommu *iommu, struct ivhd_header *h)
 	/*
 	 * Copy data from ACPI table entry to the iommu struct
 	 */
-	iommu->dev = pci_get_bus_and_slot(PCI_BUS(h->devid), h->devid & 0xff);
-	if (!iommu->dev)
-		return 1;
-
-	iommu->root_pdev = pci_get_bus_and_slot(iommu->dev->bus->number,
-						PCI_DEVFN(0, 0));
-
+	iommu->devid   = h->devid;
 	iommu->cap_ptr = h->cap_ptr;
 	iommu->pci_seg = h->pci_seg;
 	iommu->mmio_phys = h->mmio_phys;
@@ -1044,20 +954,10 @@ static int __init init_iommu_one(struct amd_iommu *iommu, struct ivhd_header *h)
 
 	iommu->int_enabled = false;
 
-	init_iommu_from_pci(iommu);
 	init_iommu_from_acpi(iommu, h);
 	init_iommu_devices(iommu);
 
-	if (iommu_feature(iommu, FEATURE_PPR)) {
-		iommu->ppr_log = alloc_ppr_log(iommu);
-		if (!iommu->ppr_log)
-			return -ENOMEM;
-	}
-
-	if (iommu->cap & (1UL << IOMMU_CAP_NPCACHE))
-		amd_iommu_np_cache = true;
-
-	return pci_enable_device(iommu->dev);
+	return 0;
 }
 
 /*
@@ -1106,6 +1006,121 @@ static int __init init_iommu_all(struct acpi_table_header *table)
 	return 0;
 }
 
+static int iommu_init_pci(struct amd_iommu *iommu)
+{
+	int cap_ptr = iommu->cap_ptr;
+	u32 range, misc, low, high;
+
+	iommu->dev = pci_get_bus_and_slot(PCI_BUS(iommu->devid),
+					  iommu->devid & 0xff);
+	if (!iommu->dev)
+		return -ENODEV;
+
+	pci_read_config_dword(iommu->dev, cap_ptr + MMIO_CAP_HDR_OFFSET,
+			      &iommu->cap);
+	pci_read_config_dword(iommu->dev, cap_ptr + MMIO_RANGE_OFFSET,
+			      &range);
+	pci_read_config_dword(iommu->dev, cap_ptr + MMIO_MISC_OFFSET,
+			      &misc);
+
+	iommu->first_device = calc_devid(MMIO_GET_BUS(range),
+					 MMIO_GET_FD(range));
+	iommu->last_device = calc_devid(MMIO_GET_BUS(range),
+					MMIO_GET_LD(range));
+
+	if (!(iommu->cap & (1 << IOMMU_CAP_IOTLB)))
+		amd_iommu_iotlb_sup = false;
+
+	/* read extended feature bits */
+	low  = readl(iommu->mmio_base + MMIO_EXT_FEATURES);
+	high = readl(iommu->mmio_base + MMIO_EXT_FEATURES + 4);
+
+	iommu->features = ((u64)high << 32) | low;
+
+	if (iommu_feature(iommu, FEATURE_GT)) {
+		int glxval;
+		u32 pasids;
+		u64 shift;
+
+		shift   = iommu->features & FEATURE_PASID_MASK;
+		shift >>= FEATURE_PASID_SHIFT;
+		pasids  = (1 << shift);
+
+		amd_iommu_max_pasids = min(amd_iommu_max_pasids, pasids);
+
+		glxval   = iommu->features & FEATURE_GLXVAL_MASK;
+		glxval >>= FEATURE_GLXVAL_SHIFT;
+
+		if (amd_iommu_max_glx_val == -1)
+			amd_iommu_max_glx_val = glxval;
+		else
+			amd_iommu_max_glx_val = min(amd_iommu_max_glx_val, glxval);
+	}
+
+	if (iommu_feature(iommu, FEATURE_GT) &&
+	    iommu_feature(iommu, FEATURE_PPR)) {
+		iommu->is_iommu_v2   = true;
+		amd_iommu_v2_present = true;
+	}
+
+	if (iommu_feature(iommu, FEATURE_PPR)) {
+		iommu->ppr_log = alloc_ppr_log(iommu);
+		if (!iommu->ppr_log)
+			return -ENOMEM;
+	}
+
+	if (iommu->cap & (1UL << IOMMU_CAP_NPCACHE))
+		amd_iommu_np_cache = true;
+
+	if (is_rd890_iommu(iommu->dev)) {
+		int i, j;
+
+		iommu->root_pdev = pci_get_bus_and_slot(iommu->dev->bus->number,
+				PCI_DEVFN(0, 0));
+
+		/*
+		 * Some rd890 systems may not be fully reconfigured by the
+		 * BIOS, so it's necessary for us to store this information so
+		 * it can be reprogrammed on resume
+		 */
+		pci_read_config_dword(iommu->dev, iommu->cap_ptr + 4,
+				&iommu->stored_addr_lo);
+		pci_read_config_dword(iommu->dev, iommu->cap_ptr + 8,
+				&iommu->stored_addr_hi);
+
+		/* Low bit locks writes to configuration space */
+		iommu->stored_addr_lo &= ~1;
+
+		for (i = 0; i < 6; i++)
+			for (j = 0; j < 0x12; j++)
+				iommu->stored_l1[i][j] = iommu_read_l1(iommu, i, j);
+
+		for (i = 0; i < 0x83; i++)
+			iommu->stored_l2[i] = iommu_read_l2(iommu, i);
+	}
+
+	return pci_enable_device(iommu->dev);
+}
+
+static int amd_iommu_init_pci(void)
+{
+	struct amd_iommu *iommu;
+	int ret = 0;
+
+	for_each_iommu(iommu) {
+		ret = iommu_init_pci(iommu);
+		if (ret)
+			break;
+	}
+
+	/* Make sure ACS will be enabled */
+	pci_request_acs();
+
+	ret = amd_iommu_init_devices();
+
+	return ret;
+}
+
 /****************************************************************************
  *
  * The following functions initialize the MSI interrupts for all IOMMUs
@@ -1569,7 +1584,7 @@ int __init amd_iommu_init_hardware(void)
 	if (ret)
 		goto free;
 
-	ret = amd_iommu_init_devices();
+	ret = amd_iommu_init_pci();
 	if (ret)
 		goto free;
 
@@ -1702,9 +1717,6 @@ int __init amd_iommu_detect(void)
 	iommu_detected = 1;
 	x86_init.iommu.iommu_init = amd_iommu_init;
 
-	/* Make sure ACS will be enabled */
-	pci_request_acs();
-
 	return 0;
 }
 
diff --git a/drivers/iommu/amd_iommu_types.h b/drivers/iommu/amd_iommu_types.h
index 2435555..6f32d7b 100644
--- a/drivers/iommu/amd_iommu_types.h
+++ b/drivers/iommu/amd_iommu_types.h
@@ -501,6 +501,9 @@ struct amd_iommu {
 	/* IOMMUv2 */
 	bool is_iommu_v2;
 
+	/* PCI device id of the IOMMU device */
+	u16 devid;
+
 	/*
 	 * Capability pointer. There could be more than one IOMMU per PCI
 	 * device function if there are more than one AMD IOMMU capability
@@ -530,8 +533,6 @@ struct amd_iommu {
 	u32 evt_buf_size;
 	/* event buffer virtual address */
 	u8 *evt_buf;
-	/* MSI number for event interrupt */
-	u16 evt_msi_num;
 
 	/* Base of the PPR log, if present */
 	u8 *ppr_log;
-- 
1.7.9.5


