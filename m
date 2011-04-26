Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758764Ab1DZVOA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:14:00 -0400
Received: from mga14.intel.com ([143.182.124.37]:19974 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758710Ab1DZVNv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:13:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="425950952"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: linville@tuxdriver.com, Larry.Finger@lwfinger.net, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [23/106] b43: allocate receive buffers big enough for max frame len + offset
Message-Id: <20110426211301.F01243E1886@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:13:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: John W. Linville <linville@tuxdriver.com>

commit c85ce65ecac078ab1a1835c87c4a6319cf74660a upstream.

Otherwise, skb_put inside of dma_rx can fail...

	https://bugzilla.kernel.org/show_bug.cgi?id=32042

Signed-off-by: John W. Linville <linville@tuxdriver.com>
Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/net/wireless/b43/dma.c |    2 +-
 drivers/net/wireless/b43/dma.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.35.y/drivers/net/wireless/b43/dma.c
===================================================================
--- linux-2.6.35.y.orig/drivers/net/wireless/b43/dma.c
+++ linux-2.6.35.y/drivers/net/wireless/b43/dma.c
@@ -1538,7 +1538,7 @@ static void dma_rx(struct b43_dmaring *r
 		dmaaddr = meta->dmaaddr;
 		goto drop_recycle_buffer;
 	}
-	if (unlikely(len > ring->rx_buffersize)) {
+	if (unlikely(len + ring->frameoffset > ring->rx_buffersize)) {
 		/* The data did not fit into one descriptor buffer
 		 * and is split over multiple buffers.
 		 * This should never happen, as we try to allocate buffers
Index: linux-2.6.35.y/drivers/net/wireless/b43/dma.h
===================================================================
--- linux-2.6.35.y.orig/drivers/net/wireless/b43/dma.h
+++ linux-2.6.35.y/drivers/net/wireless/b43/dma.h
@@ -163,7 +163,7 @@ struct b43_dmadesc_generic {
 /* DMA engine tuning knobs */
 #define B43_TXRING_SLOTS		256
 #define B43_RXRING_SLOTS		64
-#define B43_DMA0_RX_BUFFERSIZE		IEEE80211_MAX_FRAME_LEN
+#define B43_DMA0_RX_BUFFERSIZE		(B43_DMA0_RX_FRAMEOFFSET + IEEE80211_MAX_FRAME_LEN)
 
 /* Pointer poison */
 #define B43_DMA_PTR_POISON		((void *)ERR_PTR(-ENOMEM))
