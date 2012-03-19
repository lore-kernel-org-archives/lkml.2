Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031848Ab2CSPNp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 11:13:45 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:38907 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758400Ab2CSPNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 11:13:43 -0400
Date: Mon, 19 Mar 2012 16:13:39 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] core/iommu changes for v3.4
Message-ID: <20120319151339.GA3253@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-iommu-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core-iommu-for-linus

   HEAD: 1b198bb04ad72669d4bd6575fc9945ed595bfee0 x86/iommu/intel: Increase the number of iommus supported to MAX_IO_APICS

 Thanks,

	Ingo

------------------>
Mike Travis (2):
      x86/iommu/intel: Fix identity mapping for sandy bridge
      x86/iommu/intel: Increase the number of iommus supported to MAX_IO_APICS


 drivers/iommu/intel-iommu.c |   59 +++++++++++++++++++++++++-----------------
 1 files changed, 35 insertions(+), 24 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index c9c6053..a08a534 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -48,8 +48,6 @@
 #define ROOT_SIZE		VTD_PAGE_SIZE
 #define CONTEXT_SIZE		VTD_PAGE_SIZE
 
-#define IS_BRIDGE_HOST_DEVICE(pdev) \
-			    ((pdev->class >> 8) == PCI_CLASS_BRIDGE_HOST)
 #define IS_GFX_DEVICE(pdev) ((pdev->class >> 16) == PCI_BASE_CLASS_DISPLAY)
 #define IS_ISA_DEVICE(pdev) ((pdev->class >> 8) == PCI_CLASS_BRIDGE_ISA)
 #define IS_AZALIA(pdev) ((pdev)->vendor == 0x8086 && (pdev)->device == 0x3a3e)
@@ -356,10 +354,18 @@ static int hw_pass_through = 1;
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
@@ -571,7 +577,7 @@ static struct intel_iommu *domain_get_iommu(struct dmar_domain *domain)
 	BUG_ON(domain->flags & DOMAIN_FLAG_VIRTUAL_MACHINE);
 	BUG_ON(domain->flags & DOMAIN_FLAG_STATIC_IDENTITY);
 
-	iommu_id = find_first_bit(&domain->iommu_bmp, g_num_of_iommus);
+	iommu_id = find_first_bit(domain->iommu_bmp, g_num_of_iommus);
 	if (iommu_id < 0 || iommu_id >= g_num_of_iommus)
 		return NULL;
 
@@ -584,7 +590,7 @@ static void domain_update_iommu_coherency(struct dmar_domain *domain)
 
 	domain->iommu_coherency = 1;
 
-	for_each_set_bit(i, &domain->iommu_bmp, g_num_of_iommus) {
+	for_each_set_bit(i, domain->iommu_bmp, g_num_of_iommus) {
 		if (!ecap_coherent(g_iommus[i]->ecap)) {
 			domain->iommu_coherency = 0;
 			break;
@@ -598,7 +604,7 @@ static void domain_update_iommu_snooping(struct dmar_domain *domain)
 
 	domain->iommu_snooping = 1;
 
-	for_each_set_bit(i, &domain->iommu_bmp, g_num_of_iommus) {
+	for_each_set_bit(i, domain->iommu_bmp, g_num_of_iommus) {
 		if (!ecap_sc_support(g_iommus[i]->ecap)) {
 			domain->iommu_snooping = 0;
 			break;
@@ -1334,7 +1340,7 @@ static struct dmar_domain *alloc_domain(void)
 		return NULL;
 
 	domain->nid = -1;
-	memset(&domain->iommu_bmp, 0, sizeof(unsigned long));
+	memset(domain->iommu_bmp, 0, sizeof(domain->iommu_bmp));
 	domain->flags = 0;
 
 	return domain;
@@ -1360,7 +1366,7 @@ static int iommu_attach_domain(struct dmar_domain *domain,
 
 	domain->id = num;
 	set_bit(num, iommu->domain_ids);
-	set_bit(iommu->seq_id, &domain->iommu_bmp);
+	set_bit(iommu->seq_id, domain->iommu_bmp);
 	iommu->domains[num] = domain;
 	spin_unlock_irqrestore(&iommu->lock, flags);
 
@@ -1385,7 +1391,7 @@ static void iommu_detach_domain(struct dmar_domain *domain,
 
 	if (found) {
 		clear_bit(num, iommu->domain_ids);
-		clear_bit(iommu->seq_id, &domain->iommu_bmp);
+		clear_bit(iommu->seq_id, domain->iommu_bmp);
 		iommu->domains[num] = NULL;
 	}
 	spin_unlock_irqrestore(&iommu->lock, flags);
@@ -1527,7 +1533,7 @@ static void domain_exit(struct dmar_domain *domain)
 	dma_pte_free_pagetable(domain, 0, DOMAIN_MAX_PFN(domain->gaw));
 
 	for_each_active_iommu(iommu, drhd)
-		if (test_bit(iommu->seq_id, &domain->iommu_bmp))
+		if (test_bit(iommu->seq_id, domain->iommu_bmp))
 			iommu_detach_domain(domain, iommu);
 
 	free_domain_mem(domain);
@@ -1653,7 +1659,7 @@ static int domain_context_mapping_one(struct dmar_domain *domain, int segment,
 	spin_unlock_irqrestore(&iommu->lock, flags);
 
 	spin_lock_irqsave(&domain->iommu_lock, flags);
-	if (!test_and_set_bit(iommu->seq_id, &domain->iommu_bmp)) {
+	if (!test_and_set_bit(iommu->seq_id, domain->iommu_bmp)) {
 		domain->iommu_count++;
 		if (domain->iommu_count == 1)
 			domain->nid = iommu->node;
@@ -2369,18 +2375,18 @@ static int __init iommu_prepare_static_identity_mapping(int hw)
 		return -EFAULT;
 
 	for_each_pci_dev(pdev) {
-		/* Skip Host/PCI Bridge devices */
-		if (IS_BRIDGE_HOST_DEVICE(pdev))
-			continue;
 		if (iommu_should_identity_map(pdev, 1)) {
-			printk(KERN_INFO "IOMMU: %s identity mapping for device %s\n",
-			       hw ? "hardware" : "software", pci_name(pdev));
-
 			ret = domain_add_dev_info(si_domain, pdev,
-						     hw ? CONTEXT_TT_PASS_THROUGH :
-						     CONTEXT_TT_MULTI_LEVEL);
-			if (ret)
+					     hw ? CONTEXT_TT_PASS_THROUGH :
+						  CONTEXT_TT_MULTI_LEVEL);
+			if (ret) {
+				/* device not associated with an iommu */
+				if (ret == -ENODEV)
+					continue;
 				return ret;
+			}
+			pr_info("IOMMU: %s identity mapping for device %s\n",
+				hw ? "hardware" : "software", pci_name(pdev));
 		}
 	}
 
@@ -2402,12 +2408,17 @@ static int __init init_dmars(void)
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
@@ -3748,7 +3759,7 @@ static void domain_remove_one_dev_info(struct dmar_domain *domain,
 	if (found == 0) {
 		unsigned long tmp_flags;
 		spin_lock_irqsave(&domain->iommu_lock, tmp_flags);
-		clear_bit(iommu->seq_id, &domain->iommu_bmp);
+		clear_bit(iommu->seq_id, domain->iommu_bmp);
 		domain->iommu_count--;
 		domain_update_iommu_cap(domain);
 		spin_unlock_irqrestore(&domain->iommu_lock, tmp_flags);
@@ -3790,7 +3801,7 @@ static void vm_domain_remove_all_dev_info(struct dmar_domain *domain)
 		 */
 		spin_lock_irqsave(&domain->iommu_lock, flags2);
 		if (test_and_clear_bit(iommu->seq_id,
-				       &domain->iommu_bmp)) {
+				       domain->iommu_bmp)) {
 			domain->iommu_count--;
 			domain_update_iommu_cap(domain);
 		}
@@ -3815,7 +3826,7 @@ static struct dmar_domain *iommu_alloc_vm_domain(void)
 
 	domain->id = vm_domid++;
 	domain->nid = -1;
-	memset(&domain->iommu_bmp, 0, sizeof(unsigned long));
+	memset(domain->iommu_bmp, 0, sizeof(domain->iommu_bmp));
 	domain->flags = DOMAIN_FLAG_VIRTUAL_MACHINE;
 
 	return domain;
