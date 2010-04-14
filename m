Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130Ab0DNAX4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 20:23:56 -0400
Received: from rtp-iport-2.cisco.com ([64.102.122.149]:32402 "EHLO
	rtp-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597Ab0DNAXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 20:23:54 -0400
Authentication-Results: rtp-iport-2.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-AV: E=Sophos;i="4.52,200,1270425600"; 
   d="scan'208";a="101516947"
Date: Tue, 13 Apr 2010 17:21:07 -0700
From: "Tom Lyon" <pugs@cisco.com>
To: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       joerg.roedel@amd.com, chrisw@sous-sol.org, dwmw2@infradead.org
Subject: [BUG & PATCH V2] drivers/pci/intel-iommu.c: errors with smaller
 iommu widths
Message-ID: <4bc50a73.W5KDZtQwtbzOEe0g%pugs@cisco.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using iommu_domain_alloc with the Intel iommu, the domain address width
is always initialized to 48 bits (agaw 2).  This domain->agaw value is then
used by pfn_to_dma_pte to (always) build a 4 level page table.  However, not
all systems support iommu width of 48 or 4 level page tables.  In particular,
the Core i5-660 and i5-670 support an address width of 36 bits (not 39!), an
agaw of only 1, and only 3 level page tables.

This version of the patch simply lops off extra levels of the page tables if
the agaw value of the iommu is less than what is currently allocated for the
domain (in intel_iommu_attach_device). If there were already allocated
addresses above what the new iommu can handle, EFAULT is returned.

A related bug in intel_iommu_map_range didn't allow allocation at the very
end of the address space, that code has been simplified and corrected.

--- linux-2.6.33/drivers/pci/intel-iommu.c	2010-02-24 10:52:17.000000000 -0800
+++ mylinux-2.6.33/drivers/pci/intel-iommu.c	2010-04-13 16:51:55.000000000 -0700
@@ -3436,22 +3436,6 @@
 /* domain id for virtual machine, it won't be set in context */
 static unsigned long vm_domid;
 
-static int vm_domain_min_agaw(struct dmar_domain *domain)
-{
-	int i;
-	int min_agaw = domain->agaw;
-
-	i = find_first_bit(&domain->iommu_bmp, g_num_of_iommus);
-	for (; i < g_num_of_iommus; ) {
-		if (min_agaw > g_iommus[i]->agaw)
-			min_agaw = g_iommus[i]->agaw;
-
-		i = find_next_bit(&domain->iommu_bmp, g_num_of_iommus, i+1);
-	}
-
-	return min_agaw;
-}
-
 static struct dmar_domain *iommu_alloc_vm_domain(void)
 {
 	struct dmar_domain *domain;
@@ -3582,7 +3566,6 @@
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct intel_iommu *iommu;
 	int addr_width;
-	u64 end;
 
 	/* normally pdev is not mapped */
 	if (unlikely(domain_context_mapped(pdev))) {
@@ -3605,14 +3588,30 @@
 
 	/* check if this iommu agaw is sufficient for max mapped address */
 	addr_width = agaw_to_width(iommu->agaw);
-	end = DOMAIN_MAX_ADDR(addr_width);
-	end = end & VTD_PAGE_MASK;
-	if (end < dmar_domain->max_addr) {
-		printk(KERN_ERR "%s: iommu agaw (%d) is not "
+	if (addr_width > cap_mgaw(iommu->cap))
+		addr_width = cap_mgaw(iommu->cap);
+
+	if (dmar_domain->max_addr > (1LL << addr_width)) {
+		printk(KERN_ERR "%s: iommu width (%d) is not "
 		       "sufficient for the mapped address (%llx)\n",
-		       __func__, iommu->agaw, dmar_domain->max_addr);
+		       __func__, addr_width, dmar_domain->max_addr);
 		return -EFAULT;
 	}
+	dmar_domain->gaw = addr_width;
+
+	/*
+	 * Knock out extra levels of page tables if necessary
+	 */
+	while (iommu->agaw < dmar_domain->agaw) {
+		struct dma_pte *pte;
+
+		pte = dmar_domain->pgd;
+		if (dma_pte_present(pte)) {
+			free_pgtable_page(dmar_domain->pgd);
+			dmar_domain->pgd = (struct dma_pte *)dma_pte_addr(pte);
+		}
+		dmar_domain->agaw--;
+	}
 
 	return domain_add_dev_info(dmar_domain, pdev, CONTEXT_TT_MULTI_LEVEL);
 }
@@ -3632,7 +3631,6 @@
 {
 	struct dmar_domain *dmar_domain = domain->priv;
 	u64 max_addr;
-	int addr_width;
 	int prot = 0;
 	int ret;
 
@@ -3645,18 +3643,14 @@
 
 	max_addr = iova + size;
 	if (dmar_domain->max_addr < max_addr) {
-		int min_agaw;
 		u64 end;
 
 		/* check if minimum agaw is sufficient for mapped address */
-		min_agaw = vm_domain_min_agaw(dmar_domain);
-		addr_width = agaw_to_width(min_agaw);
-		end = DOMAIN_MAX_ADDR(addr_width);
-		end = end & VTD_PAGE_MASK;
+		end = __DOMAIN_MAX_ADDR(dmar_domain->gaw) + 1;
 		if (end < max_addr) {
-			printk(KERN_ERR "%s: iommu agaw (%d) is not "
+			printk(KERN_ERR "%s: iommu width (%d) is not "
 			       "sufficient for the mapped address (%llx)\n",
-			       __func__, min_agaw, max_addr);
+			       __func__, dmar_domain->gaw, max_addr);
 			return -EFAULT;
 		}
 		dmar_domain->max_addr = max_addr;
