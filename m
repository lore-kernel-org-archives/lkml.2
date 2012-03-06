Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637Ab2CFQJ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 11:09:26 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38919 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793Ab2CFQJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 11:09:23 -0500
Date: Tue, 6 Mar 2012 08:08:22 -0800
From: tip-bot for Mike Travis <travis@sgi.com>
Message-ID: <tip-ixcmp0hfp0a3b2lfv3uo0p0x@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        joerg.roedel@amd.com, dwmw2@infradead.org, travis@sgi.com,
        akpm@linux-foundation.org, jbarnes@virtuousgeek.org, steiner@sgi.com,
        chrisw@sous-sol.org, drahn@suse.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        travis@sgi.com, dwmw2@infradead.org, joerg.roedel@amd.com,
        drahn@suse.com, chrisw@sous-sol.org, steiner@sgi.com,
        akpm@linux-foundation.org, jbarnes@virtuousgeek.org,
        tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/iommu] x86/iommu/intel:
  Increase the number of iommus supported to MAX_IO_APICS
Git-Commit-ID: 1b198bb04ad72669d4bd6575fc9945ed595bfee0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 06 Mar 2012 08:08:49 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1b198bb04ad72669d4bd6575fc9945ed595bfee0
Gitweb:     http://git.kernel.org/tip/1b198bb04ad72669d4bd6575fc9945ed595bfee0
Author:     Mike Travis <travis@sgi.com>
AuthorDate: Mon, 5 Mar 2012 15:05:16 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 6 Mar 2012 09:00:02 +0100

x86/iommu/intel: Increase the number of iommus supported to MAX_IO_APICS

The number of IOMMUs supported should be the same as the number
of IO APICS.  This limit comes into play when the IOMMUs are
identity mapped, thus the number of possible IOMMUs in the
"static identity" (si) domain should be this same number.

Signed-off-by: Mike Travis <travis@sgi.com>
Signed-off-by: Jack Steiner <steiner@sgi.com>
Cc: Jack Steiner <steiner@sgi.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Daniel Rahn <drahn@suse.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Joerg Roedel <joerg.roedel@amd.com>
[ Fixed printk format string, cleaned up the code ]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/n/tip-ixcmp0hfp0a3b2lfv3uo0p0x@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/iommu/intel-iommu.c |   39 ++++++++++++++++++++++++++-------------
 1 files changed, 26 insertions(+), 13 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 8aa580d..a08a534 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -354,10 +354,18 @@ static int hw_pass_through = 1;
 /* si_domain contains mulitple devices */
 #define DOMAIN_FLAG_STATIC_IDENTITY	(1 << 2)
 
+/* define the limit of IOMMUs supported in each domain */
+#ifdef	CONFIG_X86
+# define	IOMMU_UNITS_SUPPORTED	MAX_IO_APICS
+#else
+# define	IOMMU_UNITS_SUPPORTED	64
+#endif
+
 struct dmar_domain {
 	int	id;			/* domain id */
 	int	nid;			/* node id */
-	unsigned long iommu_bmp;	/* bitmap of iommus this domain uses*/
+	DECLARE_BITMAP(iommu_bmp, IOMMU_UNITS_SUPPORTED);
+					/* bitmap of iommus this domain uses*/
 
 	struct list_head devices; 	/* all devices' list */
 	struct iova_domain iovad;	/* iova's that belong to this domain */
@@ -569,7 +577,7 @@ static struct intel_iommu *domain_get_iommu(struct dmar_domain *domain)
 	BUG_ON(domain->flags & DOMAIN_FLAG_VIRTUAL_MACHINE);
 	BUG_ON(domain->flags & DOMAIN_FLAG_STATIC_IDENTITY);
 
-	iommu_id = find_first_bit(&domain->iommu_bmp, g_num_of_iommus);
+	iommu_id = find_first_bit(domain->iommu_bmp, g_num_of_iommus);
 	if (iommu_id < 0 || iommu_id >= g_num_of_iommus)
 		return NULL;
 
@@ -582,7 +590,7 @@ static void domain_update_iommu_coherency(struct dmar_domain *domain)
 
 	domain->iommu_coherency = 1;
 
-	for_each_set_bit(i, &domain->iommu_bmp, g_num_of_iommus) {
+	for_each_set_bit(i, domain->iommu_bmp, g_num_of_iommus) {
 		if (!ecap_coherent(g_iommus[i]->ecap)) {
 			domain->iommu_coherency = 0;
 			break;
@@ -596,7 +604,7 @@ static void domain_update_iommu_snooping(struct dmar_domain *domain)
 
 	domain->iommu_snooping = 1;
 
-	for_each_set_bit(i, &domain->iommu_bmp, g_num_of_iommus) {
+	for_each_set_bit(i, domain->iommu_bmp, g_num_of_iommus) {
 		if (!ecap_sc_support(g_iommus[i]->ecap)) {
 			domain->iommu_snooping = 0;
 			break;
@@ -1332,7 +1340,7 @@ static struct dmar_domain *alloc_domain(void)
 		return NULL;
 
 	domain->nid = -1;
-	memset(&domain->iommu_bmp, 0, sizeof(unsigned long));
+	memset(domain->iommu_bmp, 0, sizeof(domain->iommu_bmp));
 	domain->flags = 0;
 
 	return domain;
@@ -1358,7 +1366,7 @@ static int iommu_attach_domain(struct dmar_domain *domain,
 
 	domain->id = num;
 	set_bit(num, iommu->domain_ids);
-	set_bit(iommu->seq_id, &domain->iommu_bmp);
+	set_bit(iommu->seq_id, domain->iommu_bmp);
 	iommu->domains[num] = domain;
 	spin_unlock_irqrestore(&iommu->lock, flags);
 
@@ -1383,7 +1391,7 @@ static void iommu_detach_domain(struct dmar_domain *domain,
 
 	if (found) {
 		clear_bit(num, iommu->domain_ids);
-		clear_bit(iommu->seq_id, &domain->iommu_bmp);
+		clear_bit(iommu->seq_id, domain->iommu_bmp);
 		iommu->domains[num] = NULL;
 	}
 	spin_unlock_irqrestore(&iommu->lock, flags);
@@ -1525,7 +1533,7 @@ static void domain_exit(struct dmar_domain *domain)
 	dma_pte_free_pagetable(domain, 0, DOMAIN_MAX_PFN(domain->gaw));
 
 	for_each_active_iommu(iommu, drhd)
-		if (test_bit(iommu->seq_id, &domain->iommu_bmp))
+		if (test_bit(iommu->seq_id, domain->iommu_bmp))
 			iommu_detach_domain(domain, iommu);
 
 	free_domain_mem(domain);
@@ -1651,7 +1659,7 @@ static int domain_context_mapping_one(struct dmar_domain *domain, int segment,
 	spin_unlock_irqrestore(&iommu->lock, flags);
 
 	spin_lock_irqsave(&domain->iommu_lock, flags);
-	if (!test_and_set_bit(iommu->seq_id, &domain->iommu_bmp)) {
+	if (!test_and_set_bit(iommu->seq_id, domain->iommu_bmp)) {
 		domain->iommu_count++;
 		if (domain->iommu_count == 1)
 			domain->nid = iommu->node;
@@ -2400,12 +2408,17 @@ static int __init init_dmars(void)
 	 * endfor
 	 */
 	for_each_drhd_unit(drhd) {
-		g_num_of_iommus++;
 		/*
 		 * lock not needed as this is only incremented in the single
 		 * threaded kernel __init code path all other access are read
 		 * only
 		 */
+		if (g_num_of_iommus < IOMMU_UNITS_SUPPORTED) {
+			g_num_of_iommus++;
+			continue;
+		}
+		printk_once(KERN_ERR "intel-iommu: exceeded %d IOMMUs\n",
+			  IOMMU_UNITS_SUPPORTED);
 	}
 
 	g_iommus = kcalloc(g_num_of_iommus, sizeof(struct intel_iommu *),
@@ -3746,7 +3759,7 @@ static void domain_remove_one_dev_info(struct dmar_domain *domain,
 	if (found == 0) {
 		unsigned long tmp_flags;
 		spin_lock_irqsave(&domain->iommu_lock, tmp_flags);
-		clear_bit(iommu->seq_id, &domain->iommu_bmp);
+		clear_bit(iommu->seq_id, domain->iommu_bmp);
 		domain->iommu_count--;
 		domain_update_iommu_cap(domain);
 		spin_unlock_irqrestore(&domain->iommu_lock, tmp_flags);
@@ -3788,7 +3801,7 @@ static void vm_domain_remove_all_dev_info(struct dmar_domain *domain)
 		 */
 		spin_lock_irqsave(&domain->iommu_lock, flags2);
 		if (test_and_clear_bit(iommu->seq_id,
-				       &domain->iommu_bmp)) {
+				       domain->iommu_bmp)) {
 			domain->iommu_count--;
 			domain_update_iommu_cap(domain);
 		}
@@ -3813,7 +3826,7 @@ static struct dmar_domain *iommu_alloc_vm_domain(void)
 
 	domain->id = vm_domid++;
 	domain->nid = -1;
-	memset(&domain->iommu_bmp, 0, sizeof(unsigned long));
+	memset(domain->iommu_bmp, 0, sizeof(domain->iommu_bmp));
 	domain->flags = DOMAIN_FLAG_VIRTUAL_MACHINE;
 
 	return domain;
