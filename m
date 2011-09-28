Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932980Ab1I1XIV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 19:08:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54486 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932913Ab1I1WqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:46:00 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:39 2011
Message-Id: <20110928220139.143919696@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:01:35 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Anton Blanchard <anton@samba.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [131/244] ibmveth: Fix issue with DMA mapping failure
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Anton Blanchard <anton@samba.org>

commit b93da27f5234198433345e40b39ff59797bc6f6e upstream.

descs[].fields.address is 32bit which truncates any dma mapping
errors so dma_mapping_error() fails to catch it.

Use a dma_addr_t to do the comparison. With this patch I was able
to transfer many gigabytes of data with IOMMU fault injection set
at 10% probability.

Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/ibmveth.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/net/ibmveth.c
+++ b/drivers/net/ibmveth.c
@@ -929,6 +929,7 @@ static netdev_tx_t ibmveth_start_xmit(st
 	union ibmveth_buf_desc descs[6];
 	int last, i;
 	int force_bounce = 0;
+	dma_addr_t dma_addr;
 
 	/*
 	 * veth handles a maximum of 6 segments including the header, so
@@ -993,17 +994,16 @@ retry_bounce:
 	}
 
 	/* Map the header */
-	descs[0].fields.address = dma_map_single(&adapter->vdev->dev, skb->data,
-						 skb_headlen(skb),
-						 DMA_TO_DEVICE);
-	if (dma_mapping_error(&adapter->vdev->dev, descs[0].fields.address))
+	dma_addr = dma_map_single(&adapter->vdev->dev, skb->data,
+				  skb_headlen(skb), DMA_TO_DEVICE);
+	if (dma_mapping_error(&adapter->vdev->dev, dma_addr))
 		goto map_failed;
 
 	descs[0].fields.flags_len = desc_flags | skb_headlen(skb);
+	descs[0].fields.address = dma_addr;
 
 	/* Map the frags */
 	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
-		unsigned long dma_addr;
 		skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 
 		dma_addr = dma_map_page(&adapter->vdev->dev, frag->page,


