Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820Ab1C2XgI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 19:36:08 -0400
Received: from relay3.sgi.com ([192.48.152.1]:49718 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752112Ab1C2XgE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 19:36:04 -0400
Message-Id: <20110329233602.735667875@gulag1.americas.sgi.com>
References: <20110329233602.272459647@gulag1.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 29 Mar 2011 18:36:05 -0500
From: Mike Travis <travis@sgi.com>
To: David Woodhouse <dwmw2@infradead.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Mike Habeck <habeck@sgi.com>, iommu@lists.linux-foundation.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] Intel pci: Limit dmar_init_reserved_ranges
Content-Disposition: inline; filename=limit-dmar_init_reserved_ranges
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    dmar_init_reserved_ranges() reserves the card's MMIO ranges to
    prevent handing out a DMA map that would overlap with the MMIO range.
    The problem while the Nvidia GPU has 64bit BARs, it's capable of
    receiving > 40bit PIOs, but can't generate > 40bit DMAs.

    So when the iommu code reserves these MMIO ranges a > 40bit
    entry ends up getting in the rbtree.  On a UV test system with
    the Nvidia cards, the BARs are:

      0001:36:00.0 VGA compatible controller: nVidia Corporation GT200GL 
	  Region 0: Memory at 92000000 (32-bit, non-prefetchable) [size=16M]
	  Region 1: Memory at f8200000000 (64-bit, prefetchable) [size=256M]
	  Region 3: Memory at 90000000 (64-bit, non-prefetchable) [size=32M]

    So this 44bit MMIO address 0xf8200000000 ends up in the rbtree.  As DMA
    maps get added and deleted from the rbtree we can end up getting a cached
    entry to this 0xf8200000000 entry... this is what results in the code
    handing out the invalid DMA map of 0xf81fffff000:

	    [ 0xf8200000000-1 >> PAGE_SIZE << PAGE_SIZE ]

    The IOVA code needs to better honor the "limit_pfn" when allocating
    these maps.

Signed-off-by: Mike Travis <travis@sgi.com>
Reviewed-by: Mike Habeck <habeck@sgi.com>
---
 drivers/pci/intel-iommu.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux.orig/drivers/pci/intel-iommu.c
+++ linux/drivers/pci/intel-iommu.c
@@ -1323,7 +1323,8 @@ static void dmar_init_reserved_ranges(vo
 
 		for (i = 0; i < PCI_NUM_RESOURCES; i++) {
 			r = &pdev->resource[i];
-			if (!r->flags || !(r->flags & IORESOURCE_MEM))
+			if (!r->flags || !(r->flags & IORESOURCE_MEM) ||
+			    r->start > pdev->dma_mask)
 				continue;
 			iova = reserve_iova(&reserved_iova_list,
 					    IOVA_PFN(r->start),

-- 
