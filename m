Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751071Ab1ECHIo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 03:08:44 -0400
Received: from mga09.intel.com ([134.134.136.24]:44560 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750740Ab1ECHIn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 03:08:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,307,1301900400"; 
   d="scan'208";a="637055152"
Message-ID: <4DBFA9F5.40608@intel.com>
Date: Tue, 03 May 2011 00:08:37 -0700
From: Joseph Cihula <joseph.cihula@intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: dwmw2@infradead.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
CC: "Wei, Gang" <gang.wei@intel.com>, Chris Wright <chrisw@sous-sol.org>
Subject: [PATCH] intel_iommu: fix VT-d PMR disable for TXT on S3 resume
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is a follow on to https://lkml.org/lkml/2011/3/21/239, which
was merged as commit 51a63e67da6056c13b5b597dcc9e1b3bd7ceaa55.

This patch adds support for S3, as pointed out by Chris Wright.

Signed-off-by:  Joseph Cihula <joseph.cihula@intel.com>

 drivers/pci/intel-iommu.c |   31 +++++++++++++++++++++++++------
 1 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index d552d2c..6eeaebf 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -142,6 +142,12 @@ static void __init check_tylersburg_isoch(void);
 static int rwbf_quirk;

 /*
+ * set to 1 to panic kernel if can't successfully enable VT-d
+ * (used when kernel is launched w/ TXT)
+ */
+static int force_on = 0;
+
+/*
  * 0: Present
  * 1-11: Reserved
  * 12-63: Context Ptr (12 - (haw-1))
@@ -2217,7 +2223,7 @@ static int __init
iommu_prepare_static_identity_mapping(int hw)
 	return 0;
 }

-static int __init init_dmars(int force_on)
+static int __init init_dmars(void)
 {
 	struct dmar_drhd_unit *drhd;
 	struct dmar_rmrr_unit *rmrr;
@@ -3117,7 +3123,17 @@ static int init_iommu_hw(void)
 		if (iommu->qi)
 			dmar_reenable_qi(iommu);

-	for_each_active_iommu(iommu, drhd) {
+	for_each_iommu(iommu, drhd) {
+		if (drhd->ignored) {
+			/*
+			 * we always have to disable PMRs or DMA may fail on
+			 * this device
+			 */
+			if (force_on)
+				iommu_disable_protect_mem_regions(iommu);
+			continue;
+		}
+	
 		iommu_flush_write_buffer(iommu);

 		iommu_set_root_entry(iommu);
@@ -3126,7 +3142,8 @@ static int init_iommu_hw(void)
 					   DMA_CCMD_GLOBAL_INVL);
 		iommu->flush.flush_iotlb(iommu, 0, 0, 0,
 					 DMA_TLB_GLOBAL_FLUSH);
-		iommu_enable_translation(iommu);
+		if (iommu_enable_translation(iommu))
+			return 1;
 		iommu_disable_protect_mem_regions(iommu);
 	}

@@ -3193,7 +3210,10 @@ static void iommu_resume(void)
 	unsigned long flag;

 	if (init_iommu_hw()) {
-		WARN(1, "IOMMU setup failed, DMAR can not resume!\n");
+		if (force_on)
+			panic("tboot: IOMMU setup failed, DMAR can not resume!\n");
+		else
+			WARN(1, "IOMMU setup failed, DMAR can not resume!\n");
 		return;
 	}

@@ -3270,7 +3290,6 @@ static struct notifier_block device_nb = {
 int __init intel_iommu_init(void)
 {
 	int ret = 0;
-	int force_on = 0;

 	/* VT-d is required for a TXT/tboot launch, so enforce that */
 	force_on = tboot_force_iommu();
@@ -3308,7 +3327,7 @@ int __init intel_iommu_init(void)

 	init_no_remapping_devices();

-	ret = init_dmars(force_on);
+	ret = init_dmars();
 	if (ret) {
 		if (force_on)
 			panic("tboot: Failed to initialize DMARs\n");
