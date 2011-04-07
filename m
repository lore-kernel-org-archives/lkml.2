Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771Ab1DGNa3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 09:30:29 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:46252
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751702Ab1DGNaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 09:30:19 -0400
X-SpamScore: -2
X-BigFish: VPS-2(zzbb2cKzz1202hzz8275bhz32i668h839h63h)
X-Spam-TCS-SCL: 2:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LJAAU9-02-JOR-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6/9] x86/amd-iommu: Rename iommu_flush* to domain_flush*
Date: Thu, 7 Apr 2011 15:30:01 +0200
Message-ID: <1302183004-4081-7-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1302183004-4081-1-git-send-email-joerg.roedel@amd.com>
References: <1302183004-4081-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These functions all operate on protection domains and not on
singe IOMMUs. Represent that in their name.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   87 ++++++++++++++++++++++---------------------
 1 files changed, 44 insertions(+), 43 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 0147c5c..9d66b20 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -488,22 +488,6 @@ static int iommu_completion_wait(struct amd_iommu *iommu)
 	return 0;
 }
 
-static void iommu_flush_complete(struct protection_domain *domain)
-{
-	int i;
-
-	for (i = 0; i < amd_iommus_present; ++i) {
-		if (!domain->dev_iommu[i])
-			continue;
-
-		/*
-		 * Devices of this domain are behind this IOMMU
-		 * We need to wait for completion of all commands.
-		 */
-		iommu_completion_wait(amd_iommus[i]);
-	}
-}
-
 /*
  * Command send function for invalidating a device table entry
  */
@@ -526,8 +510,8 @@ static int iommu_flush_device(struct device *dev)
  * It invalidates a single PTE if the range to flush is within a single
  * page. Otherwise it flushes the whole TLB of the IOMMU.
  */
-static void __iommu_flush_pages(struct protection_domain *domain,
-				u64 address, size_t size, int pde)
+static void __domain_flush_pages(struct protection_domain *domain,
+				 u64 address, size_t size, int pde)
 {
 	struct iommu_cmd cmd;
 	int ret = 0, i;
@@ -548,29 +532,45 @@ static void __iommu_flush_pages(struct protection_domain *domain,
 	WARN_ON(ret);
 }
 
-static void iommu_flush_pages(struct protection_domain *domain,
-			     u64 address, size_t size)
+static void domain_flush_pages(struct protection_domain *domain,
+			       u64 address, size_t size)
 {
-	__iommu_flush_pages(domain, address, size, 0);
+	__domain_flush_pages(domain, address, size, 0);
 }
 
 /* Flush the whole IO/TLB for a given protection domain */
-static void iommu_flush_tlb(struct protection_domain *domain)
+static void domain_flush_tlb(struct protection_domain *domain)
 {
-	__iommu_flush_pages(domain, 0, CMD_INV_IOMMU_ALL_PAGES_ADDRESS, 0);
+	__domain_flush_pages(domain, 0, CMD_INV_IOMMU_ALL_PAGES_ADDRESS, 0);
 }
 
 /* Flush the whole IO/TLB for a given protection domain - including PDE */
-static void iommu_flush_tlb_pde(struct protection_domain *domain)
+static void domain_flush_tlb_pde(struct protection_domain *domain)
 {
-	__iommu_flush_pages(domain, 0, CMD_INV_IOMMU_ALL_PAGES_ADDRESS, 1);
+	__domain_flush_pages(domain, 0, CMD_INV_IOMMU_ALL_PAGES_ADDRESS, 1);
+}
+
+static void domain_flush_complete(struct protection_domain *domain)
+{
+	int i;
+
+	for (i = 0; i < amd_iommus_present; ++i) {
+		if (!domain->dev_iommu[i])
+			continue;
+
+		/*
+		 * Devices of this domain are behind this IOMMU
+		 * We need to wait for completion of all commands.
+		 */
+		iommu_completion_wait(amd_iommus[i]);
+	}
 }
 
 
 /*
  * This function flushes the DTEs for all devices in domain
  */
-static void iommu_flush_domain_devices(struct protection_domain *domain)
+static void domain_flush_devices(struct protection_domain *domain)
 {
 	struct iommu_dev_data *dev_data;
 	unsigned long flags;
@@ -591,8 +591,8 @@ static void iommu_flush_all_domain_devices(void)
 	spin_lock_irqsave(&amd_iommu_pd_lock, flags);
 
 	list_for_each_entry(domain, &amd_iommu_pd_list, list) {
-		iommu_flush_domain_devices(domain);
-		iommu_flush_complete(domain);
+		domain_flush_devices(domain);
+		domain_flush_complete(domain);
 	}
 
 	spin_unlock_irqrestore(&amd_iommu_pd_lock, flags);
@@ -616,8 +616,8 @@ void amd_iommu_flush_all_domains(void)
 
 	list_for_each_entry(domain, &amd_iommu_pd_list, list) {
 		spin_lock(&domain->lock);
-		iommu_flush_tlb_pde(domain);
-		iommu_flush_complete(domain);
+		domain_flush_tlb_pde(domain);
+		domain_flush_complete(domain);
 		spin_unlock(&domain->lock);
 	}
 
@@ -1480,7 +1480,7 @@ static int attach_device(struct device *dev,
 	 * left the caches in the IOMMU dirty. So we have to flush
 	 * here to evict all dirty stuff.
 	 */
-	iommu_flush_tlb_pde(domain);
+	domain_flush_tlb_pde(domain);
 
 	return ret;
 }
@@ -1693,8 +1693,9 @@ static void update_domain(struct protection_domain *domain)
 		return;
 
 	update_device_table(domain);
-	iommu_flush_domain_devices(domain);
-	iommu_flush_tlb_pde(domain);
+
+	domain_flush_devices(domain);
+	domain_flush_tlb_pde(domain);
 
 	domain->updated = false;
 }
@@ -1853,10 +1854,10 @@ retry:
 	ADD_STATS_COUNTER(alloced_io_mem, size);
 
 	if (unlikely(dma_dom->need_flush && !amd_iommu_unmap_flush)) {
-		iommu_flush_tlb(&dma_dom->domain);
+		domain_flush_tlb(&dma_dom->domain);
 		dma_dom->need_flush = false;
 	} else if (unlikely(amd_iommu_np_cache))
-		iommu_flush_pages(&dma_dom->domain, address, size);
+		domain_flush_pages(&dma_dom->domain, address, size);
 
 out:
 	return address;
@@ -1905,7 +1906,7 @@ static void __unmap_single(struct dma_ops_domain *dma_dom,
 	dma_ops_free_addresses(dma_dom, dma_addr, pages);
 
 	if (amd_iommu_unmap_flush || dma_dom->need_flush) {
-		iommu_flush_pages(&dma_dom->domain, flush_addr, size);
+		domain_flush_pages(&dma_dom->domain, flush_addr, size);
 		dma_dom->need_flush = false;
 	}
 }
@@ -1941,7 +1942,7 @@ static dma_addr_t map_page(struct device *dev, struct page *page,
 	if (addr == DMA_ERROR_CODE)
 		goto out;
 
-	iommu_flush_complete(domain);
+	domain_flush_complete(domain);
 
 out:
 	spin_unlock_irqrestore(&domain->lock, flags);
@@ -1968,7 +1969,7 @@ static void unmap_page(struct device *dev, dma_addr_t dma_addr, size_t size,
 
 	__unmap_single(domain->priv, dma_addr, size, dir);
 
-	iommu_flush_complete(domain);
+	domain_flush_complete(domain);
 
 	spin_unlock_irqrestore(&domain->lock, flags);
 }
@@ -2033,7 +2034,7 @@ static int map_sg(struct device *dev, struct scatterlist *sglist,
 			goto unmap;
 	}
 
-	iommu_flush_complete(domain);
+	domain_flush_complete(domain);
 
 out:
 	spin_unlock_irqrestore(&domain->lock, flags);
@@ -2079,7 +2080,7 @@ static void unmap_sg(struct device *dev, struct scatterlist *sglist,
 		s->dma_address = s->dma_length = 0;
 	}
 
-	iommu_flush_complete(domain);
+	domain_flush_complete(domain);
 
 	spin_unlock_irqrestore(&domain->lock, flags);
 }
@@ -2129,7 +2130,7 @@ static void *alloc_coherent(struct device *dev, size_t size,
 		goto out_free;
 	}
 
-	iommu_flush_complete(domain);
+	domain_flush_complete(domain);
 
 	spin_unlock_irqrestore(&domain->lock, flags);
 
@@ -2161,7 +2162,7 @@ static void free_coherent(struct device *dev, size_t size,
 
 	__unmap_single(domain->priv, dma_addr, size, DMA_BIDIRECTIONAL);
 
-	iommu_flush_complete(domain);
+	domain_flush_complete(domain);
 
 	spin_unlock_irqrestore(&domain->lock, flags);
 
@@ -2471,7 +2472,7 @@ static int amd_iommu_unmap(struct iommu_domain *dom, unsigned long iova,
 	unmap_size = iommu_unmap_page(domain, iova, page_size);
 	mutex_unlock(&domain->api_lock);
 
-	iommu_flush_tlb_pde(domain);
+	domain_flush_tlb_pde(domain);
 
 	return get_order(unmap_size);
 }
-- 
1.7.1


