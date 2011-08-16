Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838Ab1HPCvR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 22:51:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35735 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753476Ab1HPCvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 22:51:14 -0400
X-Mailbox-Line: From gregkh@pistachio.kroah.org Mon Aug 15 19:44:55 2011
Message-Id: <20110816024455.118844840@pistachio.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 15 Aug 2011 19:43:03 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Bob Copeland <me@bobcopeland.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [20/26] ath5k: fix error handling in ath5k_beacon_send
In-Reply-To: <20110816024553.GA5631@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Bob Copeland <me@bobcopeland.com>

commit bdc71bc59231f5542af13b5061b9ab124d093050 upstream.

This cleans up error handling for the beacon in case of dma mapping
failure.  We need to free the skb when dma mapping fails instead of
nulling and leaking the pointer, and we should bail out to avoid
giving the hardware the bad descriptor.

Finally, we need to perform the null check after trying to update
the beacon, or else beacons will never be sent after a single
mapping failure.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath5k/base.c |   23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1748,6 +1748,8 @@ ath5k_beacon_setup(struct ath5k_softc *s
 
 	if (dma_mapping_error(sc->dev, bf->skbaddr)) {
 		ATH5K_ERR(sc, "beacon DMA mapping failed\n");
+		dev_kfree_skb_any(skb);
+		bf->skb = NULL;
 		return -EIO;
 	}
 
@@ -1832,8 +1834,6 @@ ath5k_beacon_update(struct ieee80211_hw
 	ath5k_txbuf_free_skb(sc, avf->bbuf);
 	avf->bbuf->skb = skb;
 	ret = ath5k_beacon_setup(sc, avf->bbuf);
-	if (ret)
-		avf->bbuf->skb = NULL;
 out:
 	return ret;
 }
@@ -1854,6 +1854,7 @@ ath5k_beacon_send(struct ath5k_softc *sc
 	struct ath5k_vif *avf;
 	struct ath5k_buf *bf;
 	struct sk_buff *skb;
+	int err;
 
 	ATH5K_DBG_UNLIMIT(sc, ATH5K_DEBUG_BEACON, "in beacon_send\n");
 
@@ -1902,11 +1903,6 @@ ath5k_beacon_send(struct ath5k_softc *sc
 
 	avf = (void *)vif->drv_priv;
 	bf = avf->bbuf;
-	if (unlikely(bf->skb == NULL || sc->opmode == NL80211_IFTYPE_STATION ||
-			sc->opmode == NL80211_IFTYPE_MONITOR)) {
-		ATH5K_WARN(sc, "bf=%p bf_skb=%p\n", bf, bf ? bf->skb : NULL);
-		return;
-	}
 
 	/*
 	 * Stop any current dma and put the new frame on the queue.
@@ -1920,8 +1916,17 @@ ath5k_beacon_send(struct ath5k_softc *sc
 
 	/* refresh the beacon for AP or MESH mode */
 	if (sc->opmode == NL80211_IFTYPE_AP ||
-			sc->opmode == NL80211_IFTYPE_MESH_POINT)
-		ath5k_beacon_update(sc->hw, vif);
+			sc->opmode == NL80211_IFTYPE_MESH_POINT) {
+		err = ath5k_beacon_update(sc->hw, vif);
+		if (err)
+			return;
+	}
+
+	if (unlikely(bf->skb == NULL || sc->opmode == NL80211_IFTYPE_STATION ||
+			sc->opmode == NL80211_IFTYPE_MONITOR)) {
+		ATH5K_WARN(sc, "bf=%p bf_skb=%p\n", bf, bf->skb);
+		return;
+	}
 
 	trace_ath5k_tx(sc, bf->skb, &sc->txqs[sc->bhalq]);
 


