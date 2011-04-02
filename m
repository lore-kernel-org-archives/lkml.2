Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573Ab1DBAdU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 20:33:20 -0400
Received: from sous-sol.org ([216.99.217.87]:54070 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756237Ab1DBAdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 20:33:15 -0400
Date: Fri, 1 Apr 2011 17:32:53 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Mike Travis <travis@sgi.com>, Mike Habeck <habeck@sgi.com>
Cc: David Woodhouse <dwmw2@infradead.org>, Chris Wright <chrisw@sous-sol.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4 v2] intel-iommu: don't cache iova above 32bit caching
 boundary
Message-ID: <20110402003253.GQ18712@sequoia.sous-sol.org>
References: <20110329233602.272459647@gulag1.americas.sgi.com>
 <20110329233602.735667875@gulag1.americas.sgi.com>
 <4D94FC21.6040601@sgi.com>
 <20110331225316.GC18712@sequoia.sous-sol.org>
 <4D950D52.8080100@sgi.com>
 <4D951109.1040707@sgi.com>
 <20110331235657.GG18712@sequoia.sous-sol.org>
 <4D9524DF.10405@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D9524DF.10405@sgi.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis and Mike Habeck reported an issue where iova allocation
would return a range that was larger than a device's dma mask.

https://lkml.org/lkml/2011/3/29/423

The dmar initialization code will reserve all PCI MMIO regions and copy
those reservations into a domain specific iova tree.  It is possible for
one of those regions to be above the dma mask of a device.  It is typical
to allocate iovas with a 32bit mask (despite device's dma mask possibly
being larger) and cache the result until it exhausts the lower 32bit
address space.  Freeing the iova range that is >= the last iova in the
lower 32bit range when there is still an iova above the 32bit range will
corrupt the cached iova by pointing it to a region that is above 32bit.
If that region is also larger than the device's dma mask, a subsequent
allocation will return an unusable iova and cause dma failure.

Simply don't cache an iova that is above the 32bit caching boundary.

Reported-by: Mike Travis <travis@sgi.com>
Reported-by: Mike Habeck <habeck@sgi.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: stable@kernel.org 
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
Mike or Mike, can you try this?  I was able to reproduce the failure
in a few different ways and successfully test this patch against those
failures, but w/out real hw.

 drivers/pci/iova.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/iova.c b/drivers/pci/iova.c
index 7914951..1690ca4 100644
--- a/drivers/pci/iova.c
+++ b/drivers/pci/iova.c
@@ -63,8 +63,16 @@ __cached_rbnode_delete_update(struct iova_domain *iovad, struct iova *free)
 	curr = iovad->cached32_node;
 	cached_iova = container_of(curr, struct iova, node);
 
-	if (free->pfn_lo >= cached_iova->pfn_lo)
-		iovad->cached32_node = rb_next(&free->node);
+	if (free->pfn_lo >= cached_iova->pfn_lo) {
+		struct rb_node *node = rb_next(&free->node);
+		struct iova *iova = container_of(node, struct iova, node);
+
+		/* only cache if it's below 32bit pfn */
+		if (iova->pfn_lo < iovad->dma_32bit_pfn)
+			iovad->cached32_node = node;
+		else
+			iovad->cached32_node = NULL;
+	}
 }
 
 /* Computes the padding size required, to make the
-- 
1.7.4
