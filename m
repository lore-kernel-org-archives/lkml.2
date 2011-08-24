Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242Ab1HXAw2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 20:52:28 -0400
Received: from mga14.intel.com ([143.182.124.37]:40918 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755779Ab1HXAwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 20:52:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,272,1312182000"; 
   d="scan'208";a="41722872"
Message-Id: <20110824001456.229207526@sbsiddha-desk.sc.intel.com>
User-Agent: quilt/0.48-1
Date: Tue, 23 Aug 2011 17:05:19 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, dwmw2@infradead.org
Cc: yinghai@kernel.org, youquan.song@intel.com, joerg.roedel@amd.com,
        tony.luck@intel.com, linux-kernel@vger.kernel.org,
        andrew.vasquez@qlogic.com, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 2/8] intr_remap: call dmar_dev_scope_init() explicitly
References: <20110824000517.710353624@sbsiddha-desk.sc.intel.com>
Content-Disposition: inline; filename=init_dev_scope_from_intr_remap.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both DMA-remapping aswell as Interrupt-remapping depend on the dmar dev scope
to be initialized. When both DMA and IRQ-remapping are enabled, we depend
on DMA-remapping init code to call dmar_dev_scope_init(). This resulted
in not doing this init when DMA-remapping was turned off but
interrupt-remapping turned on in the kernel config.

This caused interrupt routing to break with CONFIG_INTR_REMAP=y
and CONFIG_DMAR=n.

This issue was introduced by this commit:

   commit 9d5ce73a64be2be8112147a3e0b551ad9cd1247b
   Author: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
   Date:   Tue Nov 10 19:46:16 2009 +0900
 
	x86: intel-iommu: Convert detect_intel_iommu to use iommu_init hook

Fix this by calling dmar_dev_scope_init() explicitly from the interrupt
remapping code too.

Reported-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 drivers/iommu/dmar.c           |   15 ++++++++++++---
 drivers/iommu/intel-iommu.c    |    6 +-----
 drivers/iommu/intr_remapping.c |    9 +++++++++
 3 files changed, 22 insertions(+), 8 deletions(-)

Index: tree/drivers/iommu/dmar.c
===================================================================
--- tree.orig/drivers/iommu/dmar.c
+++ tree/drivers/iommu/dmar.c
@@ -557,13 +557,17 @@ dmar_find_matched_drhd_unit(struct pci_d
 
 int __init dmar_dev_scope_init(void)
 {
+	static int dmar_dev_scope_initialized;
 	struct dmar_drhd_unit *drhd, *drhd_n;
 	int ret = -ENODEV;
 
+	if (dmar_dev_scope_initialized)
+		return dmar_dev_scope_initialized;
+
 	list_for_each_entry_safe(drhd, drhd_n, &dmar_drhd_units, list) {
 		ret = dmar_parse_dev(drhd);
 		if (ret)
-			return ret;
+			goto fail;
 	}
 
 #ifdef CONFIG_DMAR
@@ -574,17 +578,22 @@ int __init dmar_dev_scope_init(void)
 		list_for_each_entry_safe(rmrr, rmrr_n, &dmar_rmrr_units, list) {
 			ret = rmrr_parse_dev(rmrr);
 			if (ret)
-				return ret;
+				goto fail;
 		}
 
 		list_for_each_entry_safe(atsr, atsr_n, &dmar_atsr_units, list) {
 			ret = atsr_parse_dev(atsr);
 			if (ret)
-				return ret;
+				goto fail;
 		}
 	}
 #endif
 
+	dmar_dev_scope_initialized = 1;
+	return 0;
+
+fail:
+	dmar_dev_scope_initialized = ret;
 	return ret;
 }
 
Index: tree/drivers/iommu/intr_remapping.c
===================================================================
--- tree.orig/drivers/iommu/intr_remapping.c
+++ tree/drivers/iommu/intr_remapping.c
@@ -773,6 +773,15 @@ int __init parse_ioapics_under_ir(void)
 	return ir_supported;
 }
 
+int ir_dev_scope_init(void)
+{
+	if (!intr_remapping_enabled)
+		return 0;
+
+	return dmar_dev_scope_init();
+}
+rootfs_initcall(ir_dev_scope_init);
+
 void disable_intr_remapping(void)
 {
 	struct dmar_drhd_unit *drhd;
Index: tree/drivers/iommu/intel-iommu.c
===================================================================
--- tree.orig/drivers/iommu/intel-iommu.c
+++ tree/drivers/iommu/intel-iommu.c
@@ -3439,16 +3439,12 @@ int __init intel_iommu_init(void)
 		return 	-ENODEV;
 	}
 
-	if (dmar_dev_scope_init()) {
+	if (dmar_dev_scope_init() < 0) {
 		if (force_on)
 			panic("tboot: Failed to initialize DMAR device scope\n");
 		return 	-ENODEV;
 	}
 
-	/*
-	 * Check the need for DMA-remapping initialization now.
-	 * Above initialization will also be used by Interrupt-remapping.
-	 */
 	if (no_iommu || dmar_disabled)
 		return -ENODEV;
 


