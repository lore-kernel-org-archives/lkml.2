Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932737Ab1DMUrI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 16:47:08 -0400
Received: from mga02.intel.com ([134.134.136.20]:58750 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932320Ab1DMUrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 16:47:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,206,1301900400"; 
   d="scan'208";a="628155117"
Message-ID: <4DA60BBE.6000500@intel.com>
Date: Wed, 13 Apr 2011 13:46:54 -0700
From: Joseph Cihula <joseph.cihula@intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Wei, Gang" <gang.wei@intel.com>
Subject: [PATCH RESEND] intel_iommu: disable all VT-d PMRs when TXT launched
References: <4D879328.1080006@intel.com>
In-Reply-To: <4D879328.1080006@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Intel VT-d Protected Memory Regions (PMRs) are supposed to be disabled,
on each VT-d engine, after DMA remapping is enabled on the engines.
This is because the behavior of having both enabled is not deterministic
and because, if TXT has been used to launch the kernel, the PMRs may be
programmed to cover memory regions that will be used for DMA.

Under some circumstances (certain quirks detected, lack of multiple
devices, etc.), the current code does not set up DMA remapping on some
VT-d engines.  In such cases it also skips disabling the PMRs.  This
causes failures when the kernel is launched with TXT (most often this
occurs on the graphics engine and results in colored vertical bars on
the display).

This patch detects when the kernel has been launched with TXT and then
disables the PMRs on all VT-d engines.  In some cases where the reason
that remapping is not being enabled is due to possible ACPI DMAR table
errors, the VT-d engine addresses may not be correct and thus not able
to be safely programmed even to disable PMRs.  Because part of the TXT
launch process is the verification of these addresses, it will always be
safe to disable PMRs if the TXT launch has succeeded and hence only
doing this in such cases.

Signed-off-by: Joseph Cihula <joseph.cihula@intel.com>

diff -uprN -X linux-2.6.38-rc3/Documentation/dontdiff
linux-2.6.38-rc3/drivers/pci/intel-iommu.c
linux-2.6.38-rc3-vtd/drivers/pci/intel-iommu.c
--- linux-2.6.38-rc3/drivers/pci/intel-iommu.c	2011-01-31
19:05:49.000000000 -0800
+++ linux-2.6.38-rc3-vtd/drivers/pci/intel-iommu.c	2011-02-18
15:42:36.778301210 -0800
@@ -1299,7 +1299,7 @@ static void iommu_detach_domain(struct d
 static struct iova_domain reserved_iova_list;
 static struct lock_class_key reserved_rbtree_key;

-static void dmar_init_reserved_ranges(void)
+static int dmar_init_reserved_ranges(void)
 {
 	struct pci_dev *pdev = NULL;
 	struct iova *iova;
@@ -1313,8 +1313,10 @@ static void dmar_init_reserved_ranges(vo
 	/* IOAPIC ranges shouldn't be accessed by DMA */
 	iova = reserve_iova(&reserved_iova_list, IOVA_PFN(IOAPIC_RANGE_START),
 		IOVA_PFN(IOAPIC_RANGE_END));
-	if (!iova)
+	if (!iova) {
 		printk(KERN_ERR "Reserve IOAPIC range failed\n");
+		return -ENODEV;
+	}

 	/* Reserve all PCI MMIO to avoid peer-to-peer access */
 	for_each_pci_dev(pdev) {
@@ -1327,11 +1329,13 @@ static void dmar_init_reserved_ranges(vo
 			iova = reserve_iova(&reserved_iova_list,
 					    IOVA_PFN(r->start),
 					    IOVA_PFN(r->end));
-			if (!iova)
+			if (!iova) {
 				printk(KERN_ERR "Reserve iova failed\n");
+				return -ENODEV;
+			}
 		}
 	}
-
+	return 0;
 }

 static void domain_reserve_special_ranges(struct dmar_domain *domain)
@@ -2213,7 +2217,7 @@ static int __init iommu_prepare_static_i
 	return 0;
 }

-int __init init_dmars(void)
+static int __init init_dmars(int force_on)
 {
 	struct dmar_drhd_unit *drhd;
 	struct dmar_rmrr_unit *rmrr;
@@ -2393,8 +2397,15 @@ int __init init_dmars(void)
 	 *   enable translation
 	 */
 	for_each_drhd_unit(drhd) {
-		if (drhd->ignored)
+		if (drhd->ignored) {
+			/*
+			 * we always have to disable PMRs or DMA may fail on
+			 * this device
+			 */
+			if (force_on)
+				iommu_disable_protect_mem_regions(drhd->iommu);
 			continue;
+		}
 		iommu = drhd->iommu;

 		iommu_flush_write_buffer(iommu);
@@ -3297,12 +3308,21 @@ int __init intel_iommu_init(void)
 	if (no_iommu || dmar_disabled)
 		return -ENODEV;

-	iommu_init_mempool();
-	dmar_init_reserved_ranges();
+	if (iommu_init_mempool()) {
+		if (force_on)
+			panic("tboot: Failed to initialize iommu memory\n");
+		return 	-ENODEV;
+	}
+
+	if (dmar_init_reserved_ranges()) {
+		if (force_on)
+			panic("tboot: Failed to reserve iommu ranges\n");
+		return 	-ENODEV;
+	}

 	init_no_remapping_devices();

-	ret = init_dmars();
+	ret = init_dmars(force_on);
 	if (ret) {
 		if (force_on)
 			panic("tboot: Failed to initialize DMARs\n");
