Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759530Ab0GAVyx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:54:53 -0400
Received: from kroah.org ([198.145.64.141]:60796 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758919Ab0GAVNa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:13:30 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:42:51 2010
Message-Id: <20100701174251.083681523@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:42:25 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Bruno Randolf <br1@einfach.org>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [055/200] ath5k: consistently use rx_bufsize for RX DMA
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1211,6 +1211,7 @@ ath5k_rxbuf_setup(struct ath5k_softc *sc
 	struct ath5k_hw *ah = sc->ah;
 	struct sk_buff *skb = bf->skb;
 	struct ath5k_desc *ds;
+	int ret;
 
 	if (!skb) {
 		skb = ath5k_rx_skb_alloc(sc, &bf->skbaddr);
@@ -1237,9 +1238,9 @@ ath5k_rxbuf_setup(struct ath5k_softc *sc
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


