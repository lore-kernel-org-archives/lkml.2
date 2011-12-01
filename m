Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108Ab1LASSS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 13:18:18 -0500
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:14999 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755626Ab1LASSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 13:18:17 -0500
Message-Id: <201112011815.pB1IFD2t004910@farm-0002.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Thu, 1 Dec 2011 12:56:03 -0500
Subject: [PATCH] drivers/net/ethernet/tile: use skb_frag_page() API
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
X-OriginalArrivalTime: 01 Dec 2011 18:15:13.0518 (UTC) FILETIME=[2B7C58E0:01CCB055]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This replaces raw access to the "page" field of the skb_frag_t.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 drivers/net/ethernet/tile/tilepro.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/tile/tilepro.c b/drivers/net/ethernet/tile/tilepro.c
index 10826d8..1c0f9fa 100644
--- a/drivers/net/ethernet/tile/tilepro.c
+++ b/drivers/net/ethernet/tile/tilepro.c
@@ -1697,7 +1697,7 @@ static unsigned int tile_net_tx_frags(lepp_frag_t *frags,
 	for (i = 0; i < sh->nr_frags; i++) {
 
 		skb_frag_t *f = &sh->frags[i];
-		unsigned long pfn = page_to_pfn(f->page);
+		unsigned long pfn = page_to_pfn(skb_frag_page(f));
 
 		/* FIXME: Compute "hash_for_home" properly. */
 		/* ISSUE: The hypervisor checks CHIP_HAS_REV1_DMA_PACKETS(). */
@@ -1706,7 +1706,7 @@ static unsigned int tile_net_tx_frags(lepp_frag_t *frags,
 		/* FIXME: Hmmm. */
 		if (!hash_default) {
 			void *va = pfn_to_kaddr(pfn) + f->page_offset;
-			BUG_ON(PageHighMem(f->page));
+			BUG_ON(PageHighMem(skb_frag_page(f)));
 			finv_buffer_remote(va, f->size, 0);
 		}
 
-- 
1.6.5.2

