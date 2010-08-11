Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933114Ab0HLAb3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:31:29 -0400
Received: from kroah.org ([198.145.64.141]:43629 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759254Ab0HKX7L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:59:11 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 16:55:03 2010
Message-Id: <20100811235503.660503940@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 16:55:09 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Fenghua Yu <fenghua.yu@intel.com>, Tony Luck <tony.luck@intel.com>,
        Leonardo Chiquitto <lchiquitto@novell.com>,
        Jeff Mahoney <jeffm@suse.com>
Subject: [088/111] [IA64] fix SBA IOMMU to handle allocation failure properly
In-Reply-To: <20100811235623.GA24440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

commit e2a465675dc089e9a56ba2fa2a5fbd9bd8844d18 upstream.

It's possible that SBA IOMMU might fail to find I/O space under heavy
I/Os.  SBA IOMMU panics on allocation failure but it shouldn't; drivers
can handle the failure.  The majority of other IOMMU drivers don't panic
on allocation failure.

This patch fixes SBA IOMMU path to handle allocation failure properly.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Acked-by: Leonardo Chiquitto <lchiquitto@novell.com>
Acked-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/ia64/hp/common/sba_iommu.c |   38 +++++++++++++++++++++++++++++---------
 1 file changed, 29 insertions(+), 9 deletions(-)

--- a/arch/ia64/hp/common/sba_iommu.c
+++ b/arch/ia64/hp/common/sba_iommu.c
@@ -677,12 +677,19 @@ sba_alloc_range(struct ioc *ioc, struct
 			spin_unlock_irqrestore(&ioc->saved_lock, flags);
 
 			pide = sba_search_bitmap(ioc, dev, pages_needed, 0);
-			if (unlikely(pide >= (ioc->res_size << 3)))
-				panic(__FILE__ ": I/O MMU @ %p is out of mapping resources\n",
-				      ioc->ioc_hpa);
+			if (unlikely(pide >= (ioc->res_size << 3))) {
+				printk(KERN_WARNING "%s: I/O MMU @ %p is"
+				       "out of mapping resources, %u %u %lx\n",
+				       __func__, ioc->ioc_hpa, ioc->res_size,
+				       pages_needed, dma_get_seg_boundary(dev));
+				return -1;
+			}
 #else
-			panic(__FILE__ ": I/O MMU @ %p is out of mapping resources\n",
-			      ioc->ioc_hpa);
+			printk(KERN_WARNING "%s: I/O MMU @ %p is"
+			       "out of mapping resources, %u %u %lx\n",
+			       __func__, ioc->ioc_hpa, ioc->res_size,
+			       pages_needed, dma_get_seg_boundary(dev));
+			return -1;
 #endif
 		}
 	}
@@ -965,6 +972,8 @@ static dma_addr_t sba_map_page(struct de
 #endif
 
 	pide = sba_alloc_range(ioc, dev, size);
+	if (pide < 0)
+		return 0;
 
 	iovp = (dma_addr_t) pide << iovp_shift;
 
@@ -1320,6 +1329,7 @@ sba_coalesce_chunks(struct ioc *ioc, str
 	unsigned long dma_offset, dma_len; /* start/len of DMA stream */
 	int n_mappings = 0;
 	unsigned int max_seg_size = dma_get_max_seg_size(dev);
+	int idx;
 
 	while (nents > 0) {
 		unsigned long vaddr = (unsigned long) sba_sg_address(startsg);
@@ -1418,16 +1428,22 @@ sba_coalesce_chunks(struct ioc *ioc, str
 		vcontig_sg->dma_length = vcontig_len;
 		dma_len = (dma_len + dma_offset + ~iovp_mask) & iovp_mask;
 		ASSERT(dma_len <= DMA_CHUNK_SIZE);
-		dma_sg->dma_address = (dma_addr_t) (PIDE_FLAG
-			| (sba_alloc_range(ioc, dev, dma_len) << iovp_shift)
-			| dma_offset);
+		idx = sba_alloc_range(ioc, dev, dma_len);
+		if (idx < 0) {
+			dma_sg->dma_length = 0;
+			return -1;
+		}
+		dma_sg->dma_address = (dma_addr_t)(PIDE_FLAG | (idx << iovp_shift)
+						   | dma_offset);
 		n_mappings++;
 	}
 
 	return n_mappings;
 }
 
-
+static void sba_unmap_sg_attrs(struct device *dev, struct scatterlist *sglist,
+			       int nents, enum dma_data_direction dir,
+			       struct dma_attrs *attrs);
 /**
  * sba_map_sg - map Scatter/Gather list
  * @dev: instance of PCI owned by the driver that's asking.
@@ -1493,6 +1509,10 @@ static int sba_map_sg_attrs(struct devic
 	** Access to the virtual address is what forces a two pass algorithm.
 	*/
 	coalesced = sba_coalesce_chunks(ioc, dev, sglist, nents);
+	if (coalesced < 0) {
+		sba_unmap_sg_attrs(dev, sglist, nents, dir, attrs);
+		return 0;
+	}
 
 	/*
 	** Program the I/O Pdir


