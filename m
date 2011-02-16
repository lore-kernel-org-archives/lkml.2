Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555Ab1BPBPz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:15:55 -0500
Received: from kroah.org ([198.145.64.141]:45502 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932968Ab1BPAsm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:48:42 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:21:04 2011
Message-Id: <20110216002104.406928581@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:20:21 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Kyungwan Nam <kyungwan.nam@atheros.com>,
        "Luis R. Rodriguez" <lrodriguez@atheros.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 053/176] ath9k: simplify hw reset locking
In-Reply-To: <20110216002212.GA9246@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Luis R. Rodriguez <lrodriguez@atheros.com>

commit 9d94674ab754be0e275120a183670ead435f9c0d upstream.

The new PCU lock is better placed so we can just contend
against that when trying to reset hardware.

This is part of a series of patches which fix stopping
TX DMA completley when requested on the driver.
For more details about this issue refer to this thread:

http://marc.info/?l=linux-wireless&m=128629803703756&w=2

Tested-by:  Ben Greear <greearb@candelatech.com>
Cc: Kyungwan Nam <kyungwan.nam@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>

---
 drivers/net/wireless/ath/ath9k/ath9k.h |    1 -
 drivers/net/wireless/ath/ath9k/init.c  |    1 -
 drivers/net/wireless/ath/ath9k/main.c  |   22 ++++++----------------
 drivers/net/wireless/ath/ath9k/xmit.c  |    4 ++--
 4 files changed, 8 insertions(+), 20 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -557,7 +557,6 @@ struct ath_softc {
 	struct ath_hw *sc_ah;
 	void __iomem *mem;
 	int irq;
-	spinlock_t sc_resetlock;
 	spinlock_t sc_serial_rw;
 	spinlock_t sc_pm_lock;
 	struct mutex mutex;
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -574,7 +574,6 @@ static int ath9k_init_softc(u16 devid, s
 	common->debug_mask = ath9k_debug;
 
 	spin_lock_init(&sc->wiphy_lock);
-	spin_lock_init(&sc->sc_resetlock);
 	spin_lock_init(&sc->sc_serial_rw);
 	spin_lock_init(&sc->sc_pm_lock);
 	mutex_init(&sc->mutex);
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -233,19 +233,15 @@ int ath_set_channel(struct ath_softc *sc
 		  sc->sc_ah->curchan->channel,
 		  channel->center_freq, conf_is_ht40(conf));
 
-	spin_lock_bh(&sc->sc_resetlock);
-
 	r = ath9k_hw_reset(ah, hchan, caldata, fastcc);
 	if (r) {
 		ath_print(common, ATH_DBG_FATAL,
 			  "Unable to reset channel (%u MHz), "
 			  "reset status %d\n",
 			  channel->center_freq, r);
-		spin_unlock_bh(&sc->sc_resetlock);
 		spin_unlock_bh(&sc->rx.pcu_lock);
 		goto ps_restore;
 	}
-	spin_unlock_bh(&sc->sc_resetlock);
 
 	if (ath_startrecv(sc) != 0) {
 		ath_print(common, ATH_DBG_FATAL,
@@ -848,7 +844,6 @@ void ath_radio_enable(struct ath_softc *
 		ah->curchan = ath_get_curchannel(sc, sc->hw);
 
 	spin_lock_bh(&sc->rx.pcu_lock);
-	spin_lock_bh(&sc->sc_resetlock);
 	r = ath9k_hw_reset(ah, ah->curchan, ah->caldata, false);
 	if (r) {
 		ath_print(common, ATH_DBG_FATAL,
@@ -856,7 +851,6 @@ void ath_radio_enable(struct ath_softc *
 			  "reset status %d\n",
 			  channel->center_freq, r);
 	}
-	spin_unlock_bh(&sc->sc_resetlock);
 
 	ath_update_txpow(sc);
 	if (ath_startrecv(sc) != 0) {
@@ -913,7 +907,6 @@ void ath_radio_disable(struct ath_softc
 	if (!ah->curchan)
 		ah->curchan = ath_get_curchannel(sc, hw);
 
-	spin_lock_bh(&sc->sc_resetlock);
 	r = ath9k_hw_reset(ah, ah->curchan, ah->caldata, false);
 	if (r) {
 		ath_print(ath9k_hw_common(sc->sc_ah), ATH_DBG_FATAL,
@@ -921,7 +914,6 @@ void ath_radio_disable(struct ath_softc
 			  "reset status %d\n",
 			  channel->center_freq, r);
 	}
-	spin_unlock_bh(&sc->sc_resetlock);
 
 	ath9k_hw_phy_disable(ah);
 
@@ -952,12 +944,10 @@ int ath_reset(struct ath_softc *sc, bool
 	ath_stoprecv(sc);
 	ath_flushrecv(sc);
 
-	spin_lock_bh(&sc->sc_resetlock);
 	r = ath9k_hw_reset(ah, sc->sc_ah->curchan, ah->caldata, false);
 	if (r)
 		ath_print(common, ATH_DBG_FATAL,
 			  "Unable to reset hardware; reset status %d\n", r);
-	spin_unlock_bh(&sc->sc_resetlock);
 
 	if (ath_startrecv(sc) != 0)
 		ath_print(common, ATH_DBG_FATAL,
@@ -1130,18 +1120,15 @@ static int ath9k_start(struct ieee80211_
 	 * and then setup of the interrupt mask.
 	 */
 	spin_lock_bh(&sc->rx.pcu_lock);
-	spin_lock_bh(&sc->sc_resetlock);
 	r = ath9k_hw_reset(ah, init_channel, ah->caldata, false);
 	if (r) {
 		ath_print(common, ATH_DBG_FATAL,
 			  "Unable to reset hardware; reset status %d "
 			  "(freq %u MHz)\n", r,
 			  curchan->center_freq);
-		spin_unlock_bh(&sc->sc_resetlock);
 		spin_unlock_bh(&sc->rx.pcu_lock);
 		goto mutex_unlock;
 	}
-	spin_unlock_bh(&sc->sc_resetlock);
 
 	/*
 	 * This is needed only to setup initial state
@@ -1365,14 +1352,17 @@ static void ath9k_stop(struct ieee80211_
 	 * before setting the invalid flag. */
 	ath9k_hw_set_interrupts(ah, 0);
 
-	spin_lock_bh(&sc->rx.pcu_lock);
 	if (!(sc->sc_flags & SC_OP_INVALID)) {
 		ath_drain_all_txq(sc, false);
+		spin_lock_bh(&sc->rx.pcu_lock);
 		ath_stoprecv(sc);
 		ath9k_hw_phy_disable(ah);
-	} else
+		spin_unlock_bh(&sc->rx.pcu_lock);
+	} else {
+		spin_lock_bh(&sc->rx.pcu_lock);
 		sc->rx.rxlink = NULL;
-	spin_unlock_bh(&sc->rx.pcu_lock);
+		spin_unlock_bh(&sc->rx.pcu_lock);
+	}
 
 	/* disable HAL and put h/w to sleep */
 	ath9k_hw_disable(ah);
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1160,13 +1160,13 @@ void ath_drain_all_txq(struct ath_softc
 		ath_print(common, ATH_DBG_FATAL,
 			  "Failed to stop TX DMA. Resetting hardware!\n");
 
-		spin_lock_bh(&sc->sc_resetlock);
+		spin_lock_bh(&sc->rx.pcu_lock);
 		r = ath9k_hw_reset(ah, sc->sc_ah->curchan, ah->caldata, false);
 		if (r)
 			ath_print(common, ATH_DBG_FATAL,
 				  "Unable to reset hardware; reset status %d\n",
 				  r);
-		spin_unlock_bh(&sc->sc_resetlock);
+		spin_unlock_bh(&sc->rx.pcu_lock);
 	}
 
 	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++) {


