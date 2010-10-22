Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759325Ab0JVTTb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:19:31 -0400
Received: from kroah.org ([198.145.64.141]:34023 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759274Ab0JVS4K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:56:10 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:52:29 2010
Message-Id: <20101022185229.762456257@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:51:01 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [027/103] x86/amd-iommu: Fix rounding-bug in __unmap_single
In-Reply-To: <20101022185455.GA9114@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Joerg Roedel <joerg.roedel@amd.com>

commit 04e0463e088b41060c08c255eb0d3278a504f094 upstream.

In the __unmap_single function the dma_addr is rounded down
to a page boundary before the dma pages are unmapped. The
address is later also used to flush the TLB entries for that
mapping. But without the offset into the dma page the amount
of pages to flush might be miscalculated in the TLB flushing
path. This patch fixes this bug by using the original
address to flush the TLB.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/amd_iommu.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1953,6 +1953,7 @@ static void __unmap_single(struct dma_op
 			   size_t size,
 			   int dir)
 {
+	dma_addr_t flush_addr;
 	dma_addr_t i, start;
 	unsigned int pages;
 
@@ -1960,6 +1961,7 @@ static void __unmap_single(struct dma_op
 	    (dma_addr + size > dma_dom->aperture_size))
 		return;
 
+	flush_addr = dma_addr;
 	pages = iommu_num_pages(dma_addr, size, PAGE_SIZE);
 	dma_addr &= PAGE_MASK;
 	start = dma_addr;
@@ -1974,7 +1976,7 @@ static void __unmap_single(struct dma_op
 	dma_ops_free_addresses(dma_dom, dma_addr, pages);
 
 	if (amd_iommu_unmap_flush || dma_dom->need_flush) {
-		iommu_flush_pages(&dma_dom->domain, dma_addr, size);
+		iommu_flush_pages(&dma_dom->domain, flush_addr, size);
 		dma_dom->need_flush = false;
 	}
 }


