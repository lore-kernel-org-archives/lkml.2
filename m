Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189Ab1E1SQ0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 14:16:26 -0400
Received: from relay2.sgi.com ([192.48.179.30]:38235 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755312Ab1E1SPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 14:15:06 -0400
Message-Id: <20110528181502.345585019@gulag1.americas.sgi.com>
References: <20110528181501.896092225@gulag1.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Sat, 28 May 2011 13:15:04 -0500
From: Mike Travis <travis@sgi.com>
To: David Woodhouse <dwmw2@infradead.org>, Chris Wright <chrisw@sous-sol.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Cc: Mike Habeck <habeck@sgi.com>, Dimitri Sivanich <sivanich@sgi.com>,
        Derek Fults <dfults@sgi.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        stable@kernel.org, iommu@lists.linux-foundation.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] Intel pci: Dont cache iova above 32bit
Content-Disposition: inline; filename=dont-cache-iova-above-32bit.patch
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

From: Chris Wright <chrisw@sous-sol.org>
Reported-by: Mike Travis <travis@sgi.com>
Reported-by: Mike Habeck <habeck@sgi.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: stable@kernel.org
Acked-by: Mike Travis <travis@sgi.com>
Tested-by: Mike Habeck <habeck@sgi.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---

v3: rb_next() can return NULL, found when testing on my hw

David, Mike Travis will collect and resumbit full series when he's back.

 drivers/pci/iova.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- linux.orig/drivers/pci/iova.c
+++ linux/drivers/pci/iova.c
@@ -63,8 +63,16 @@ __cached_rbnode_delete_update(struct iov
 	curr = iovad->cached32_node;
 	cached_iova = container_of(curr, struct iova, node);
 
-	if (free->pfn_lo >= cached_iova->pfn_lo)
-		iovad->cached32_node = rb_next(&free->node);
+	if (free->pfn_lo >= cached_iova->pfn_lo) {
+		struct rb_node *node = rb_next(&free->node);
+		struct iova *iova = container_of(node, struct iova, node);
+
+		/* only cache if it's below 32bit pfn */
+		if (node && iova->pfn_lo < iovad->dma_32bit_pfn)
+			iovad->cached32_node = node;
+		else
+			iovad->cached32_node = NULL;
+	}
 }
 
 /* Computes the padding size required, to make the

-- 
