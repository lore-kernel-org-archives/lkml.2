Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518Ab1BPBP1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:15:27 -0500
Received: from kroah.org ([198.145.64.141]:45513 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932917Ab1BPAsp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:48:45 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:21:04 2011
Message-Id: <20110216002104.503542966@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:20:22 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Kyungwan Nam <kyungwan.nam@atheros.com>,
        "Luis R. Rodriguez" <lrodriguez@atheros.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 054/176] ath9k: move the PCU lock to the sc structure
In-Reply-To: <20110216002212.GA9246@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Luis R. Rodriguez <lrodriguez@atheros.com>

commit 4bdd1e978ede034c1211957eb17eaf50de00d234 upstream.

The PCU lock should be used to contend TX DMA as well,
this will be done next.

This is part of a series of patches which fix stopping
TX DMA completley when requested on the driver.
For more details about this issue refer to this thread:

http://marc.info/?l=linux-wireless&m=128629803703756&w=2

Tested-by:  Ben Greear <greearb@candelatech.com>
Cc: Kyungwan Nam <kyungwan.nam@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/ath9k.h |    2 -
 drivers/net/wireless/ath/ath9k/main.c  |   42 ++++++++++++++++-----------------
 drivers/net/wireless/ath/ath9k/recv.c  |    2 -
 drivers/net/wireless/ath/ath9k/xmit.c  |    4 +--
 4 files changed, 25 insertions(+), 25 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -312,7 +312,6 @@ struct ath_rx {
 	u8 rxotherant;
 	u32 *rxlink;
 	unsigned int rxfilter;
-	spinlock_t pcu_lock;
 	spinlock_t rxbuflock;
 	struct list_head rxbuf;
 	struct ath_descdma rxdma;
@@ -559,6 +558,7 @@ struct ath_softc {
 	int irq;
 	spinlock_t sc_serial_rw;
 	spinlock_t sc_pm_lock;
+	spinlock_t sc_pcu_lock;
 	struct mutex mutex;
 	struct work_struct paprd_work;
 	struct work_struct hw_check_work;
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -214,7 +214,7 @@ int ath_set_channel(struct ath_softc *sc
 	ath9k_hw_set_interrupts(ah, 0);
 	ath_drain_all_txq(sc, false);
 
-	spin_lock_bh(&sc->rx.pcu_lock);
+	spin_lock_bh(&sc->sc_pcu_lock);
 
 	stopped = ath_stoprecv(sc);
 
@@ -239,7 +239,7 @@ int ath_set_channel(struct ath_softc *sc
 			  "Unable to reset channel (%u MHz), "
 			  "reset status %d\n",
 			  channel->center_freq, r);
-		spin_unlock_bh(&sc->rx.pcu_lock);
+		spin_unlock_bh(&sc->sc_pcu_lock);
 		goto ps_restore;
 	}
 
@@ -247,11 +247,11 @@ int ath_set_channel(struct ath_softc *sc
 		ath_print(common, ATH_DBG_FATAL,
 			  "Unable to restart recv logic\n");
 		r = -EIO;
-		spin_unlock_bh(&sc->rx.pcu_lock);
+		spin_unlock_bh(&sc->sc_pcu_lock);
 		goto ps_restore;
 	}
 
-	spin_unlock_bh(&sc->rx.pcu_lock);
+	spin_unlock_bh(&sc->sc_pcu_lock);
 
 	ath_cache_conf_rate(sc, &hw->conf);
 	ath_update_txpow(sc);
@@ -588,7 +588,7 @@ void ath9k_tasklet(unsigned long data)
 		rxmask = (ATH9K_INT_RX | ATH9K_INT_RXEOL | ATH9K_INT_RXORN);
 
 	if (status & rxmask) {
-		spin_lock_bh(&sc->rx.pcu_lock);
+		spin_lock_bh(&sc->sc_pcu_lock);
 
 		/* Check for high priority Rx first */
 		if ((ah->caps.hw_caps & ATH9K_HW_CAP_EDMA) &&
@@ -596,7 +596,7 @@ void ath9k_tasklet(unsigned long data)
 			ath_rx_tasklet(sc, 0, true);
 
 		ath_rx_tasklet(sc, 0, false);
-		spin_unlock_bh(&sc->rx.pcu_lock);
+		spin_unlock_bh(&sc->sc_pcu_lock);
 	}
 
 	if (status & ATH9K_INT_TX) {
@@ -843,7 +843,7 @@ void ath_radio_enable(struct ath_softc *
 	if (!ah->curchan)
 		ah->curchan = ath_get_curchannel(sc, sc->hw);
 
-	spin_lock_bh(&sc->rx.pcu_lock);
+	spin_lock_bh(&sc->sc_pcu_lock);
 	r = ath9k_hw_reset(ah, ah->curchan, ah->caldata, false);
 	if (r) {
 		ath_print(common, ATH_DBG_FATAL,
@@ -856,10 +856,10 @@ void ath_radio_enable(struct ath_softc *
 	if (ath_startrecv(sc) != 0) {
 		ath_print(common, ATH_DBG_FATAL,
 			  "Unable to restart recv logic\n");
-		spin_unlock_bh(&sc->rx.pcu_lock);
+		spin_unlock_bh(&sc->sc_pcu_lock);
 		return;
 	}
-	spin_unlock_bh(&sc->rx.pcu_lock);
+	spin_unlock_bh(&sc->sc_pcu_lock);
 
 	if (sc->sc_flags & SC_OP_BEACONS)
 		ath_beacon_config(sc, NULL);	/* restart beacons */
@@ -899,7 +899,7 @@ void ath_radio_disable(struct ath_softc
 
 	ath_drain_all_txq(sc, false);	/* clear pending tx frames */
 
-	spin_lock_bh(&sc->rx.pcu_lock);
+	spin_lock_bh(&sc->sc_pcu_lock);
 
 	ath_stoprecv(sc);		/* turn off frame recv */
 	ath_flushrecv(sc);		/* flush recv queue */
@@ -917,7 +917,7 @@ void ath_radio_disable(struct ath_softc
 
 	ath9k_hw_phy_disable(ah);
 
-	spin_unlock_bh(&sc->rx.pcu_lock);
+	spin_unlock_bh(&sc->sc_pcu_lock);
 
 	ath9k_hw_configpcipowersave(ah, 1, 1);
 	ath9k_ps_restore(sc);
@@ -939,7 +939,7 @@ int ath_reset(struct ath_softc *sc, bool
 	ath9k_hw_set_interrupts(ah, 0);
 	ath_drain_all_txq(sc, retry_tx);
 
-	spin_lock_bh(&sc->rx.pcu_lock);
+	spin_lock_bh(&sc->sc_pcu_lock);
 
 	ath_stoprecv(sc);
 	ath_flushrecv(sc);
@@ -953,7 +953,7 @@ int ath_reset(struct ath_softc *sc, bool
 		ath_print(common, ATH_DBG_FATAL,
 			  "Unable to start recv logic\n");
 
-	spin_unlock_bh(&sc->rx.pcu_lock);
+	spin_unlock_bh(&sc->sc_pcu_lock);
 
 	/*
 	 * We may be doing a reset in response to a request
@@ -1119,14 +1119,14 @@ static int ath9k_start(struct ieee80211_
 	 * be followed by initialization of the appropriate bits
 	 * and then setup of the interrupt mask.
 	 */
-	spin_lock_bh(&sc->rx.pcu_lock);
+	spin_lock_bh(&sc->sc_pcu_lock);
 	r = ath9k_hw_reset(ah, init_channel, ah->caldata, false);
 	if (r) {
 		ath_print(common, ATH_DBG_FATAL,
 			  "Unable to reset hardware; reset status %d "
 			  "(freq %u MHz)\n", r,
 			  curchan->center_freq);
-		spin_unlock_bh(&sc->rx.pcu_lock);
+		spin_unlock_bh(&sc->sc_pcu_lock);
 		goto mutex_unlock;
 	}
 
@@ -1147,10 +1147,10 @@ static int ath9k_start(struct ieee80211_
 		ath_print(common, ATH_DBG_FATAL,
 			  "Unable to start recv logic\n");
 		r = -EIO;
-		spin_unlock_bh(&sc->rx.pcu_lock);
+		spin_unlock_bh(&sc->sc_pcu_lock);
 		goto mutex_unlock;
 	}
-	spin_unlock_bh(&sc->rx.pcu_lock);
+	spin_unlock_bh(&sc->sc_pcu_lock);
 
 	/* Setup our intr mask. */
 	ah->imask = ATH9K_INT_TX | ATH9K_INT_RXEOL |
@@ -1354,14 +1354,14 @@ static void ath9k_stop(struct ieee80211_
 
 	if (!(sc->sc_flags & SC_OP_INVALID)) {
 		ath_drain_all_txq(sc, false);
-		spin_lock_bh(&sc->rx.pcu_lock);
+		spin_lock_bh(&sc->sc_pcu_lock);
 		ath_stoprecv(sc);
 		ath9k_hw_phy_disable(ah);
-		spin_unlock_bh(&sc->rx.pcu_lock);
+		spin_unlock_bh(&sc->sc_pcu_lock);
 	} else {
-		spin_lock_bh(&sc->rx.pcu_lock);
+		spin_lock_bh(&sc->sc_pcu_lock);
 		sc->rx.rxlink = NULL;
-		spin_unlock_bh(&sc->rx.pcu_lock);
+		spin_unlock_bh(&sc->sc_pcu_lock);
 	}
 
 	/* disable HAL and put h/w to sleep */
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -308,7 +308,7 @@ int ath_rx_init(struct ath_softc *sc, in
 	struct ath_buf *bf;
 	int error = 0;
 
-	spin_lock_init(&sc->rx.pcu_lock);
+	spin_lock_init(&sc->sc_pcu_lock);
 	sc->sc_flags &= ~SC_OP_RXFLUSH;
 	spin_lock_init(&sc->rx.rxbuflock);
 
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1160,13 +1160,13 @@ void ath_drain_all_txq(struct ath_softc
 		ath_print(common, ATH_DBG_FATAL,
 			  "Failed to stop TX DMA. Resetting hardware!\n");
 
-		spin_lock_bh(&sc->rx.pcu_lock);
+		spin_lock_bh(&sc->sc_pcu_lock);
 		r = ath9k_hw_reset(ah, sc->sc_ah->curchan, ah->caldata, false);
 		if (r)
 			ath_print(common, ATH_DBG_FATAL,
 				  "Unable to reset hardware; reset status %d\n",
 				  r);
-		spin_unlock_bh(&sc->rx.pcu_lock);
+		spin_unlock_bh(&sc->sc_pcu_lock);
 	}
 
 	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++) {


