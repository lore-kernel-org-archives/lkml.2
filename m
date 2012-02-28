Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966045Ab2B1SuK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 13:50:10 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:52370 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965988Ab2B1SuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 13:50:06 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>, linux-alpha@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH trivial next 2/9] alpha: Use vsprintf extention %pf with builtin_return_address
Date: Tue, 28 Feb 2012 10:49:31 -0800
Message-Id: <c215713a5361983d818f4cf11fda9292cfb3f5eb.1330454853.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1330454853.git.joe@perches.com>
References: <cover.1330454853.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Emit the function name not the address when possible.

builtin_return_address() gives an address.  When building
a kernel with CONFIG_KALLSYMS, emit the actual function
name not the address.

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/alpha/kernel/pci_iommu.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/alpha/kernel/pci_iommu.c b/arch/alpha/kernel/pci_iommu.c
index cd63479..3f844d2 100644
--- a/arch/alpha/kernel/pci_iommu.c
+++ b/arch/alpha/kernel/pci_iommu.c
@@ -236,7 +236,7 @@ static int pci_dac_dma_supported(struct pci_dev *dev, u64 mask)
 		ok = 0;
 
 	/* If both conditions above are met, we are fine. */
-	DBGA("pci_dac_dma_supported %s from %p\n",
+	DBGA("pci_dac_dma_supported %s from %pf\n",
 	     ok ? "yes" : "no", __builtin_return_address(0));
 
 	return ok;
@@ -268,7 +268,7 @@ pci_map_single_1(struct pci_dev *pdev, void *cpu_addr, size_t size,
 	    && paddr + size <= __direct_map_size) {
 		ret = paddr + __direct_map_base;
 
-		DBGA2("pci_map_single: [%p,%zx] -> direct %llx from %p\n",
+		DBGA2("pci_map_single: [%p,%zx] -> direct %llx from %pf\n",
 		      cpu_addr, size, ret, __builtin_return_address(0));
 
 		return ret;
@@ -279,7 +279,7 @@ pci_map_single_1(struct pci_dev *pdev, void *cpu_addr, size_t size,
 	if (dac_allowed) {
 		ret = paddr + alpha_mv.pci_dac_offset;
 
-		DBGA2("pci_map_single: [%p,%zx] -> DAC %llx from %p\n",
+		DBGA2("pci_map_single: [%p,%zx] -> DAC %llx from %pf\n",
 		      cpu_addr, size, ret, __builtin_return_address(0));
 
 		return ret;
@@ -316,7 +316,7 @@ pci_map_single_1(struct pci_dev *pdev, void *cpu_addr, size_t size,
 	ret = arena->dma_base + dma_ofs * PAGE_SIZE;
 	ret += (unsigned long)cpu_addr & ~PAGE_MASK;
 
-	DBGA2("pci_map_single: [%p,%zx] np %ld -> sg %llx from %p\n",
+	DBGA2("pci_map_single: [%p,%zx] np %ld -> sg %llx from %pf\n",
 	      cpu_addr, size, npages, ret, __builtin_return_address(0));
 
 	return ret;
@@ -385,14 +385,14 @@ static void alpha_pci_unmap_page(struct device *dev, dma_addr_t dma_addr,
 	    && dma_addr < __direct_map_base + __direct_map_size) {
 		/* Nothing to do.  */
 
-		DBGA2("pci_unmap_single: direct [%llx,%zx] from %p\n",
+		DBGA2("pci_unmap_single: direct [%llx,%zx] from %pf\n",
 		      dma_addr, size, __builtin_return_address(0));
 
 		return;
 	}
 
 	if (dma_addr > 0xffffffff) {
-		DBGA2("pci64_unmap_single: DAC [%llx,%zx] from %p\n",
+		DBGA2("pci64_unmap_single: DAC [%llx,%zx] from %pf\n",
 		      dma_addr, size, __builtin_return_address(0));
 		return;
 	}
@@ -424,7 +424,7 @@ static void alpha_pci_unmap_page(struct device *dev, dma_addr_t dma_addr,
 
 	spin_unlock_irqrestore(&arena->lock, flags);
 
-	DBGA2("pci_unmap_single: sg [%llx,%zx] np %ld from %p\n",
+	DBGA2("pci_unmap_single: sg [%llx,%zx] np %ld from %pf\n",
 	      dma_addr, size, npages, __builtin_return_address(0));
 }
 
@@ -447,7 +447,7 @@ try_again:
 	cpu_addr = (void *)__get_free_pages(gfp, order);
 	if (! cpu_addr) {
 		printk(KERN_INFO "pci_alloc_consistent: "
-		       "get_free_pages failed from %p\n",
+		       "get_free_pages failed from %pf\n",
 			__builtin_return_address(0));
 		/* ??? Really atomic allocation?  Otherwise we could play
 		   with vmalloc and sg if we can't find contiguous memory.  */
@@ -466,7 +466,7 @@ try_again:
 		goto try_again;
 	}
 
-	DBGA2("pci_alloc_consistent: %zx -> [%p,%llx] from %p\n",
+	DBGA2("pci_alloc_consistent: %zx -> [%p,%llx] from %pf\n",
 	      size, cpu_addr, *dma_addrp, __builtin_return_address(0));
 
 	return cpu_addr;
@@ -486,7 +486,7 @@ static void alpha_pci_free_coherent(struct device *dev, size_t size,
 	pci_unmap_single(pdev, dma_addr, size, PCI_DMA_BIDIRECTIONAL);
 	free_pages((unsigned long)cpu_addr, get_order(size));
 
-	DBGA2("pci_free_consistent: [%llx,%zx] from %p\n",
+	DBGA2("pci_free_consistent: [%llx,%zx] from %pf\n",
 	      dma_addr, size, __builtin_return_address(0));
 }
 
-- 
1.7.8.111.gad25c.dirty

