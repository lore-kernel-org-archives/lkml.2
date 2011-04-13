Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932897Ab1DMQNL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 12:13:11 -0400
Received: from kroah.org ([198.145.64.141]:52870 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932867Ab1DMQNF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 12:13:05 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Apr 13 09:10:46 2011
Message-Id: <20110413161046.078022774@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 13 Apr 2011 09:09:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "John W. Linville" <linville@tuxdriver.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [34/71] b43: allocate receive buffers big enough for max frame len + offset
In-Reply-To: <20110413161106.GA20405@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: John W. Linville <linville@tuxdriver.com>

commit c85ce65ecac078ab1a1835c87c4a6319cf74660a upstream.

Otherwise, skb_put inside of dma_rx can fail...

	https://bugzilla.kernel.org/show_bug.cgi?id=32042

Signed-off-by: John W. Linville <linville@tuxdriver.com>
Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/b43/dma.c |    2 +-
 drivers/net/wireless/b43/dma.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/b43/dma.c
+++ b/drivers/net/wireless/b43/dma.c
@@ -1554,7 +1554,7 @@ static void dma_rx(struct b43_dmaring *r
 		dmaaddr = meta->dmaaddr;
 		goto drop_recycle_buffer;
 	}
-	if (unlikely(len > ring->rx_buffersize)) {
+	if (unlikely(len + ring->frameoffset > ring->rx_buffersize)) {
 		/* The data did not fit into one descriptor buffer
 		 * and is split over multiple buffers.
 		 * This should never happen, as we try to allocate buffers
--- a/drivers/net/wireless/b43/dma.h
+++ b/drivers/net/wireless/b43/dma.h
@@ -163,7 +163,7 @@ struct b43_dmadesc_generic {
 /* DMA engine tuning knobs */
 #define B43_TXRING_SLOTS		256
 #define B43_RXRING_SLOTS		64
-#define B43_DMA0_RX_BUFFERSIZE		IEEE80211_MAX_FRAME_LEN
+#define B43_DMA0_RX_BUFFERSIZE		(B43_DMA0_RX_FRAMEOFFSET + IEEE80211_MAX_FRAME_LEN)
 
 /* Pointer poison */
 #define B43_DMA_PTR_POISON		((void *)ERR_PTR(-ENOMEM))


