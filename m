Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759794Ab0GAWO6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 18:14:58 -0400
Received: from kroah.org ([198.145.64.141]:47313 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932599Ab0GAUt4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 16:49:56 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:34:30 2010
Message-Id: <20100701173430.475436551@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:33:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Bruno Randolf <br1@einfach.org>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 043/164] ath5k: consistently use rx_bufsize for RX DMA
In-Reply-To: <20100701175152.GA2135@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bruno Randolf <br1@einfach.org>

commit b5eae9ff5ba6d76de19286dd6429acd7cde3f79d upstream.

We should use the same buffer size we set up for DMA also in the hardware
descriptor. Previously we used common->rx_bufsize for setting up the DMA
mapping, but used skb_tailroom(skb) for the size we tell to the hardware in the
descriptor itself. The problem is that skb_tailroom(skb) can give us a larger
value than the size we set up for DMA before. This allows the hardware to write
into memory locations not set up for DMA. In practice this should rarely happen
because all packets should be smaller than the maximum 802.11 packet size.

On the tested platform rx_bufsize is 2528, and we allocated an skb of 2559
bytes length (including padding for cache alignment) but sbk_tailroom() was
2592. Just consistently use rx_bufsize for all RX DMA memory sizes.

Also use the return value of the descriptor setup function.

Signed-off-by: Bruno Randolf <br1@einfach.org>
Reviewed-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath5k/base.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1210,6 +1210,7 @@ ath5k_rxbuf_setup(struct ath5k_softc *sc
 	struct ath5k_hw *ah = sc->ah;
 	struct sk_buff *skb = bf->skb;
 	struct ath5k_desc *ds;
+	int ret;
 
 	if (!skb) {
 		skb = ath5k_rx_skb_alloc(sc, &bf->skbaddr);
@@ -1236,9 +1237,9 @@ ath5k_rxbuf_setup(struct ath5k_softc *sc
 	ds = bf->desc;
 	ds->ds_link = bf->daddr;	/* link to self */
 	ds->ds_data = bf->skbaddr;
-	ah->ah_setup_rx_desc(ah, ds,
-		skb_tailroom(skb),	/* buffer size */
-		0);
+	ret = ah->ah_setup_rx_desc(ah, ds, ah->common.rx_bufsize, 0);
+	if (ret)
+		return ret;
 
 	if (sc->rxlink != NULL)
 		*sc->rxlink = bf->daddr;


