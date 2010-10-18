Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017Ab0JRS3J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 14:29:09 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:57582 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753507Ab0JRS3I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 14:29:08 -0400
From: Nishanth Aravamudan <nacc@us.ibm.com>
To: nacc@us.ibm.com
Cc: miltonm@bga.com, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Anton Blanchard <anton@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: [PATCH 6/7] ppc/pseries: iommu cleanup
Date: Mon, 18 Oct 2010 10:27:03 -0700
Message-Id: <1287422825-14999-7-git-send-email-nacc@us.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287422825-14999-1-git-send-email-nacc@us.ibm.com>
References: <1287422825-14999-1-git-send-email-nacc@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to initialize per-cpu pointer to NULL, it is the default.

Direct dma ops and no setup are the defaults, no need to set for
iommu-off.

Signed-off-by: Milton Miller <miltonm@bga.com>
Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Reviewed-by: Grant Likely <grant.likely@secretlab.ca>
---
 arch/powerpc/platforms/pseries/iommu.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/iommu.c b/arch/powerpc/platforms/pseries/iommu.c
index a77bcae..9184db3 100644
--- a/arch/powerpc/platforms/pseries/iommu.c
+++ b/arch/powerpc/platforms/pseries/iommu.c
@@ -140,7 +140,7 @@ static int tce_build_pSeriesLP(struct iommu_table *tbl, long tcenum,
 	return ret;
 }
 
-static DEFINE_PER_CPU(u64 *, tce_page) = NULL;
+static DEFINE_PER_CPU(u64 *, tce_page);
 
 static int tce_buildmulti_pSeriesLP(struct iommu_table *tbl, long tcenum,
 				     long npages, unsigned long uaddr,
@@ -589,13 +589,8 @@ static struct notifier_block iommu_reconfig_nb = {
 /* These are called very early. */
 void iommu_init_early_pSeries(void)
 {
-	if (of_chosen && of_get_property(of_chosen, "linux,iommu-off", NULL)) {
-		/* Direct I/O, IOMMU off */
-		ppc_md.pci_dma_dev_setup = NULL;
-		ppc_md.pci_dma_bus_setup = NULL;
-		set_pci_dma_ops(&dma_direct_ops);
+	if (of_chosen && of_get_property(of_chosen, "linux,iommu-off", NULL))
 		return;
-	}
 
 	if (firmware_has_feature(FW_FEATURE_LPAR)) {
 		if (firmware_has_feature(FW_FEATURE_MULTITCE)) {
-- 
1.7.1

