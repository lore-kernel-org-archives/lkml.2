Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649Ab1DFAkJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 20:40:09 -0400
Received: from sous-sol.org ([216.99.217.87]:50936 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751996Ab1DFAkH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 20:40:07 -0400
Date: Tue, 5 Apr 2011 17:39:19 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Mike Travis <travis@sgi.com>, Mike Habeck <habeck@sgi.com>
Cc: David Woodhouse <dwmw2@infradead.org>, Chris Wright <chrisw@sous-sol.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4 v3] intel-iommu: don't cache iova above 32bit caching
 boundary
Message-ID: <20110406003919.GL2068@sequoia.sous-sol.org>
References: <20110329233602.272459647@gulag1.americas.sgi.com>
 <20110329233602.735667875@gulag1.americas.sgi.com>
 <4D94FC21.6040601@sgi.com>
 <20110331225316.GC18712@sequoia.sous-sol.org>
 <4D950D52.8080100@sgi.com>
 <4D951109.1040707@sgi.com>
 <20110331235657.GG18712@sequoia.sous-sol.org>
 <4D9524DF.10405@sgi.com>
 <20110402003253.GQ18712@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110402003253.GQ18712@sequoia.sous-sol.org>
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
Acked-by: Mike Travis <travis@sgi.com>
Tested-by: Mike Habeck <habeck@sgi.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---

v3: rb_next() can return NULL, found when testing on my hw

David, Mike Travis will collect and resumbit full series when he's back.

 drivers/pci/iova.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/iova.c b/drivers/pci/iova.c
index 7914951..10f995a 100644
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
+		if (node && iova->pfn_lo < iovad->dma_32bit_pfn)
+			iovad->cached32_node = node;
+		else
+			iovad->cached32_node = NULL;
+	}
 }
 
 /* Computes the padding size required, to make the
-- 
1.7.4
