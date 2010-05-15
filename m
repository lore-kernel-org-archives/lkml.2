Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137Ab0EOVUf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 17:20:35 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:41762 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753029Ab0EOVUb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 17:20:31 -0400
Date: Sat, 15 May 2010 23:20:26 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Stefano Brivio <stefano.brivio@polimi.it>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 24/37] drivers/net/wireless/b43: Use kmemdup
Message-ID: <Pine.LNX.4.64.1005152320070.21345@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Use kmemdup when some other buffer is immediately copied into the
allocated region.

A simplified version of the semantic patch that makes this change is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression from,to,size,flag;
statement S;
@@

-  to = \(kmalloc\|kzalloc\)(size,flag);
+  to = kmemdup(from,size,flag);
   if (to==NULL || ...) S
-  memcpy(to, from, size);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/net/wireless/b43/dma.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -u -p a/drivers/net/wireless/b43/dma.c b/drivers/net/wireless/b43/dma.c
--- a/drivers/net/wireless/b43/dma.c
+++ b/drivers/net/wireless/b43/dma.c
@@ -1221,14 +1221,14 @@ static int dma_tx_fragment(struct b43_dm
 	meta->dmaaddr = map_descbuffer(ring, skb->data, skb->len, 1);
 	/* create a bounce buffer in zone_dma on mapping failure. */
 	if (b43_dma_mapping_error(ring, meta->dmaaddr, skb->len, 1)) {
-		priv_info->bouncebuffer = kmalloc(skb->len, GFP_ATOMIC | GFP_DMA);
+		priv_info->bouncebuffer = kmemdup(skb->data, skb->len,
+						  GFP_ATOMIC | GFP_DMA);
 		if (!priv_info->bouncebuffer) {
 			ring->current_slot = old_top_slot;
 			ring->used_slots = old_used_slots;
 			err = -ENOMEM;
 			goto out_unmap_hdr;
 		}
-		memcpy(priv_info->bouncebuffer, skb->data, skb->len);
 
 		meta->dmaaddr = map_descbuffer(ring, priv_info->bouncebuffer, skb->len, 1);
 		if (b43_dma_mapping_error(ring, meta->dmaaddr, skb->len, 1)) {
