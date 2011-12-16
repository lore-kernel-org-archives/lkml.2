Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964924Ab1LPTxg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 14:53:36 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45248 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932820Ab1LPTvl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 14:51:41 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Dec 16 11:42:09 2011
Message-Id: <20111216194209.714921888@clark.kroah.org>
User-Agent: quilt/0.50-24.1
Date: Fri, 16 Dec 2011 11:40:25 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Allen Kay <allen.m.kay@intel.com>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Youquan Song <youquan.song@intel.com>
Subject: [18/45] intel-iommu: set iommu_superpage on VM domains to lowest common denominator
In-Reply-To: <20111216194603.GA15028@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Allen Kay <allen.m.kay@intel.com>

commit 8140a95d228efbcd64d84150e794761a32463947 upstream.

set dmar->iommu_superpage field to the smallest common denominator
of super page sizes supported by all active VT-d engines.  Initialize
this field in intel_iommu_domain_init() API so intel_iommu_map() API
will be able to use iommu_superpage field to determine the appropriate
super page size to use.

Signed-off-by: Allen Kay <allen.m.kay@intel.com>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Youquan Song <youquan.song@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/intel-iommu.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -578,17 +578,18 @@ static void domain_update_iommu_snooping
 
 static void domain_update_iommu_superpage(struct dmar_domain *domain)
 {
-	int i, mask = 0xf;
+	struct dmar_drhd_unit *drhd;
+	struct intel_iommu *iommu = NULL;
+	int mask = 0xf;
 
 	if (!intel_iommu_superpage) {
 		domain->iommu_superpage = 0;
 		return;
 	}
 
-	domain->iommu_superpage = 4; /* 1TiB */
-
-	for_each_set_bit(i, &domain->iommu_bmp, g_num_of_iommus) {
-		mask |= cap_super_page_val(g_iommus[i]->cap);
+	/* set iommu_superpage to the smallest common denominator */
+	for_each_active_iommu(iommu, drhd) {
+		mask &= cap_super_page_val(iommu->cap);
 		if (!mask) {
 			break;
 		}
@@ -3744,6 +3745,7 @@ static int intel_iommu_domain_init(struc
 		vm_domain_exit(dmar_domain);
 		return -ENOMEM;
 	}
+	domain_update_iommu_cap(dmar_domain);
 	domain->priv = dmar_domain;
 
 	return 0;


