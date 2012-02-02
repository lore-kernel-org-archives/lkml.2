Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932924Ab2BBX5J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 18:57:09 -0500
Received: from relay2.sgi.com ([192.48.179.30]:47558 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756044Ab2BBX4w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 18:56:52 -0500
Message-Id: <20120202235650.884390443@gulag1.americas.sgi.com>
References: <20120202235650.563029146@gulag1.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 02 Feb 2012 17:56:52 -0600
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Jack Steiner <steiner@sgi.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] x86, pci: Increase the number of iommus supported to be MAX_IO_APICS
Content-Disposition: inline; filename=uv2-up-iommu-limit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The number of IOMMUs supported should be the same as the number of IO APICS.
This limit comes into play when the IOMMUs are identity mapped, thus the
number of possible IOMMUs in the "static identity" (si) domain should be
this same number.

Signed-off-by: Mike Travis <travis@sgi.com>
Signed-off-by: Jack Steiner <steiner@sgi.com>
---
 drivers/iommu/intel-iommu.c |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

--- linux.orig/drivers/iommu/intel-iommu.c
+++ linux/drivers/iommu/intel-iommu.c
@@ -357,7 +357,8 @@ static int hw_pass_through = 1;
 struct dmar_domain {
 	int	id;			/* domain id */
 	int	nid;			/* node id */
-	unsigned long iommu_bmp;	/* bitmap of iommus this domain uses*/
+	DECLARE_BITMAP(iommu_bmp, MAX_IO_APICS);
+					/* bitmap of iommus this domain uses*/
 
 	struct list_head devices; 	/* all devices' list */
 	struct iova_domain iovad;	/* iova's that belong to this domain */
@@ -569,7 +570,7 @@ static struct intel_iommu *domain_get_io
 	BUG_ON(domain->flags & DOMAIN_FLAG_VIRTUAL_MACHINE);
 	BUG_ON(domain->flags & DOMAIN_FLAG_STATIC_IDENTITY);
 
-	iommu_id = find_first_bit(&domain->iommu_bmp, g_num_of_iommus);
+	iommu_id = find_first_bit(domain->iommu_bmp, g_num_of_iommus);
 	if (iommu_id < 0 || iommu_id >= g_num_of_iommus)
 		return NULL;
 
@@ -582,7 +583,7 @@ static void domain_update_iommu_coherenc
 
 	domain->iommu_coherency = 1;
 
-	for_each_set_bit(i, &domain->iommu_bmp, g_num_of_iommus) {
+	for_each_set_bit(i, domain->iommu_bmp, g_num_of_iommus) {
 		if (!ecap_coherent(g_iommus[i]->ecap)) {
 			domain->iommu_coherency = 0;
 			break;
@@ -596,7 +597,7 @@ static void domain_update_iommu_snooping
 
 	domain->iommu_snooping = 1;
 
-	for_each_set_bit(i, &domain->iommu_bmp, g_num_of_iommus) {
+	for_each_set_bit(i, domain->iommu_bmp, g_num_of_iommus) {
 		if (!ecap_sc_support(g_iommus[i]->ecap)) {
 			domain->iommu_snooping = 0;
 			break;
@@ -1332,7 +1333,7 @@ static struct dmar_domain *alloc_domain(
 		return NULL;
 
 	domain->nid = -1;
-	memset(&domain->iommu_bmp, 0, sizeof(unsigned long));
+	memset(domain->iommu_bmp, 0, sizeof(domain->iommu_bmp));
 	domain->flags = 0;
 
 	return domain;
@@ -1358,7 +1359,7 @@ static int iommu_attach_domain(struct dm
 
 	domain->id = num;
 	set_bit(num, iommu->domain_ids);
-	set_bit(iommu->seq_id, &domain->iommu_bmp);
+	set_bit(iommu->seq_id, domain->iommu_bmp);
 	iommu->domains[num] = domain;
 	spin_unlock_irqrestore(&iommu->lock, flags);
 
@@ -1383,7 +1384,7 @@ static void iommu_detach_domain(struct d
 
 	if (found) {
 		clear_bit(num, iommu->domain_ids);
-		clear_bit(iommu->seq_id, &domain->iommu_bmp);
+		clear_bit(iommu->seq_id, domain->iommu_bmp);
 		iommu->domains[num] = NULL;
 	}
 	spin_unlock_irqrestore(&iommu->lock, flags);
@@ -1525,7 +1526,7 @@ static void domain_exit(struct dmar_doma
 	dma_pte_free_pagetable(domain, 0, DOMAIN_MAX_PFN(domain->gaw));
 
 	for_each_active_iommu(iommu, drhd)
-		if (test_bit(iommu->seq_id, &domain->iommu_bmp))
+		if (test_bit(iommu->seq_id, domain->iommu_bmp))
 			iommu_detach_domain(domain, iommu);
 
 	free_domain_mem(domain);
@@ -1651,7 +1652,7 @@ static int domain_context_mapping_one(st
 	spin_unlock_irqrestore(&iommu->lock, flags);
 
 	spin_lock_irqsave(&domain->iommu_lock, flags);
-	if (!test_and_set_bit(iommu->seq_id, &domain->iommu_bmp)) {
+	if (!test_and_set_bit(iommu->seq_id, domain->iommu_bmp)) {
 		domain->iommu_count++;
 		if (domain->iommu_count == 1)
 			domain->nid = iommu->node;
@@ -3746,7 +3747,7 @@ static void domain_remove_one_dev_info(s
 	if (found == 0) {
 		unsigned long tmp_flags;
 		spin_lock_irqsave(&domain->iommu_lock, tmp_flags);
-		clear_bit(iommu->seq_id, &domain->iommu_bmp);
+		clear_bit(iommu->seq_id, domain->iommu_bmp);
 		domain->iommu_count--;
 		domain_update_iommu_cap(domain);
 		spin_unlock_irqrestore(&domain->iommu_lock, tmp_flags);
@@ -3788,7 +3789,7 @@ static void vm_domain_remove_all_dev_inf
 		 */
 		spin_lock_irqsave(&domain->iommu_lock, flags2);
 		if (test_and_clear_bit(iommu->seq_id,
-				       &domain->iommu_bmp)) {
+				       domain->iommu_bmp)) {
 			domain->iommu_count--;
 			domain_update_iommu_cap(domain);
 		}
@@ -3813,7 +3814,7 @@ static struct dmar_domain *iommu_alloc_v
 
 	domain->id = vm_domid++;
 	domain->nid = -1;
-	memset(&domain->iommu_bmp, 0, sizeof(unsigned long));
+	memset(domain->iommu_bmp, 0, sizeof(domain->iommu_bmp));
 	domain->flags = DOMAIN_FLAG_VIRTUAL_MACHINE;
 
 	return domain;

-- 
