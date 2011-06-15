Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974Ab1FPHAO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:00:14 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:45661 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754831Ab1FPHAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:00:09 -0400
X-Sasl-enc: 1+XVxFeRDOPLP8o2mTtWChpRulEGAHUrabwFKvkBMe9c 1308207608
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:02:29 2011
Message-Id: <20110616000229.570606960@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 16:59:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mike Travis <travis@sgi.com>, Chris Wright <chrisw@sous-sol.org>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: [06/89] intel-iommu: Dont cache iova above 32bit
In-Reply-To: <20110616000258.GA14529@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Chris Wright <chrisw@sous-sol.org>

commit 1c9fc3d11b84fbd0c4f4aa7855702c2a1f098ebb upstream.

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
Acked-by: Mike Travis <travis@sgi.com>
Tested-by: Mike Habeck <habeck@sgi.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/iova.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/drivers/pci/iova.c
+++ b/drivers/pci/iova.c
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


