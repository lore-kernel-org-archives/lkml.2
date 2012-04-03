Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467Ab2DCCWe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 22:22:34 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:21803 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754146Ab2DCCVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 22:21:07 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, Len Brown <len.brown@intel.com>,
        Jiang Liu <jiang.liu@huawei.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>, x86 <x86@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [RFC PATCH 11/14] IOMMU: Add init_dmar_one()
Date: Mon,  2 Apr 2012 19:19:38 -0700
Message-Id: <1333419581-7836-12-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1333419581-7836-1-git-send-email-yinghai@kernel.org>
References: <1333419581-7836-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A020204.4F7A5E4E.0082,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will need that for hot added intel iommu

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/iommu/dmar.c        |    4 +-
 drivers/iommu/intel-iommu.c |  123 +++++++++++++++++++++++++++++++++++++++----
 2 files changed, 115 insertions(+), 12 deletions(-)

diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
index ea9d210..cd5eee3 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -62,7 +62,7 @@ static void __init dmar_register_drhd_unit(struct dmar_drhd_unit *drhd)
 		list_add(&drhd->list, &dmar_drhd_units);
 }
 
-static int __init dmar_parse_one_dev_scope(struct acpi_dmar_device_scope *scope,
+static int dmar_parse_one_dev_scope(struct acpi_dmar_device_scope *scope,
 					   struct pci_dev **dev, u16 segment)
 {
 	struct pci_bus *bus;
@@ -119,7 +119,7 @@ static int __init dmar_parse_one_dev_scope(struct acpi_dmar_device_scope *scope,
 	return 0;
 }
 
-int __init dmar_parse_dev_scope(void *start, void *end, int *cnt,
+int dmar_parse_dev_scope(void *start, void *end, int *cnt,
 				struct pci_dev ***devices, u16 segment)
 {
 	struct acpi_dmar_device_scope *scope;
diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 662932f..56b886f 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -2407,19 +2407,12 @@ static int __init init_dmars(void)
 	 *    initialize and program root entry to not present
 	 * endfor
 	 */
-	for_each_drhd_unit(drhd) {
 		/*
 		 * lock not needed as this is only incremented in the single
 		 * threaded kernel __init code path all other access are read
 		 * only
 		 */
-		if (g_num_of_iommus < IOMMU_UNITS_SUPPORTED) {
-			g_num_of_iommus++;
-			continue;
-		}
-		printk_once(KERN_ERR "intel-iommu: exceeded %d IOMMUs\n",
-			  IOMMU_UNITS_SUPPORTED);
-	}
+	g_num_of_iommus = IOMMU_UNITS_SUPPORTED;
 
 	g_iommus = kcalloc(g_num_of_iommus, sizeof(struct intel_iommu *),
 			GFP_KERNEL);
@@ -2620,6 +2613,109 @@ error:
 	return ret;
 }
 
+int init_dmar_one(struct dmar_drhd_unit *drhd)
+{
+	struct intel_iommu *iommu;
+	int ret;
+
+	/*
+	 * for each drhd
+	 *    allocate root
+	 *    initialize and program root entry to not present
+	 * endfor
+	 */
+
+	if (drhd->ignored)
+		return 0;
+
+	iommu = drhd->iommu;
+	g_iommus[iommu->seq_id] = iommu;
+
+	ret = iommu_init_domains(iommu);
+	if (ret)
+		goto error;
+
+	/*
+	 * TBD:
+	 * we could share the same root & context tables
+	 * among all IOMMU's. Need to Split it later.
+	 */
+	ret = iommu_alloc_root_entry(iommu);
+	if (ret) {
+		printk(KERN_ERR "IOMMU: allocate root entry failed\n");
+		goto error;
+	}
+
+	/*
+	 * Start from the sane iommu hardware state.
+	 */
+	/*
+	 * If the queued invalidation is already initialized by us
+	 * (for example, while enabling interrupt-remapping) then
+	 * we got the things already rolling from a sane state.
+	 */
+	if (!iommu->qi) {
+		/*
+		 * Clear any previous faults.
+		 */
+		dmar_fault(-1, iommu);
+		/*
+		 * Disable queued invalidation if supported and already enabled
+		 * before OS handover.
+		 */
+		dmar_disable_qi(iommu);
+	}
+
+	if (dmar_enable_qi(iommu)) {
+		/*
+		 * Queued Invalidate not enabled, use Register Based
+		 * Invalidate
+		 */
+		iommu->flush.flush_context = __iommu_flush_context;
+		iommu->flush.flush_iotlb = __iommu_flush_iotlb;
+		printk(KERN_INFO
+		       "IOMMU %d 0x%Lx: using Register based invalidation\n",
+		       iommu->seq_id, (unsigned long long)drhd->reg_base_addr);
+	} else {
+		iommu->flush.flush_context = qi_flush_context;
+		iommu->flush.flush_iotlb = qi_flush_iotlb;
+		printk(KERN_INFO "IOMMU %d 0x%Lx: using Queued invalidation\n",
+		       iommu->seq_id, (unsigned long long)drhd->reg_base_addr);
+	}
+
+	/*
+	 * for each drhd
+	 *   enable fault log
+	 *   global invalidate context cache
+	 *   global invalidate iotlb
+	 *   enable translation
+	 */
+	iommu_flush_write_buffer(iommu);
+
+	ret = dmar_set_interrupt(iommu);
+	if (ret)
+		goto error;
+
+	iommu_set_root_entry(iommu);
+
+	iommu->flush.flush_context(iommu, 0, 0, 0, DMA_CCMD_GLOBAL_INVL);
+	iommu->flush.flush_iotlb(iommu, 0, 0, 0, DMA_TLB_GLOBAL_FLUSH);
+
+	ret = iommu_enable_translation(iommu);
+	if (ret)
+		goto error;
+
+	iommu_disable_protect_mem_regions(iommu);
+
+	return 0;
+error:
+	free_dmar_iommu(iommu);
+	free_iommu(iommu);
+	drhd->iommu = NULL;
+	return ret;
+}
+
+
 /* This takes a number of _MM_ pages, not VTD pages */
 static struct iova *intel_alloc_iova(struct device *dev,
 				     struct dmar_domain *domain,
@@ -3474,7 +3570,8 @@ rmrr_parse_dev(struct dmar_rmrr_unit *rmrru)
 
 LIST_HEAD(dmar_atsr_units);
 
-int __init dmar_parse_one_atsr(struct acpi_dmar_header *hdr)
+int __dmar_parse_one_atsr(struct acpi_dmar_header *hdr,
+			  struct dmar_atsr_unit **patsru)
 {
 	struct acpi_dmar_atsr *atsr;
 	struct dmar_atsr_unit *atsru;
@@ -3489,11 +3586,17 @@ int __init dmar_parse_one_atsr(struct acpi_dmar_header *hdr)
 	atsru->segment = atsr->segment;
 
 	list_add(&atsru->list, &dmar_atsr_units);
+	if (patsru)
+		*patsru = atsru;
 
 	return 0;
 }
+int __init dmar_parse_one_atsr(struct acpi_dmar_header *hdr)
+{
+	return __dmar_parse_one_atsr(hdr, NULL);
+}
 
-static int __init atsr_parse_dev(struct dmar_atsr_unit *atsru)
+int atsr_parse_dev(struct dmar_atsr_unit *atsru)
 {
 	int rc;
 	struct acpi_dmar_atsr *atsr;
-- 
1.7.7

