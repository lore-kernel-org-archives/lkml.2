Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932410Ab0C3XT1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:19:27 -0400
Received: from kroah.org ([198.145.64.141]:45443 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932328Ab0C3XS5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:18:57 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:57:07 2010
Message-Id: <20100330225706.766576956@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:56:19 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Senthil Balasubramanian <senthilkumar@atheros.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [101/116] ath9k: Enable TIM timer interrupt only when needed.
In-Reply-To: <20100330230600.GA28802@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Senthil Balasubramanian <senthilkumar@atheros.com>

commit 3f7c5c10e9dc6bf90179eb9f7c06151d508fb324 upstream.

The TIM timer interrupt is enabled even before the ACK of nullqos
is received which is unnecessary.

Also clean up the CONF_PS part of config callback properly for
better readability.

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/ath9k.h |    1 +
 drivers/net/wireless/ath/ath9k/main.c  |   25 ++++++++++++++-----------
 drivers/net/wireless/ath/ath9k/xmit.c  |    7 +++----
 3 files changed, 18 insertions(+), 15 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -368,6 +368,7 @@ void ath_tx_aggr_start(struct ath_softc
 		       u16 tid, u16 *ssn);
 void ath_tx_aggr_stop(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid);
 void ath_tx_aggr_resume(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid);
+void ath9k_enable_ps(struct ath_softc *sc);
 
 /********/
 /* VIFs */
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2305,6 +2305,19 @@ static void ath9k_remove_interface(struc
 	mutex_unlock(&sc->mutex);
 }
 
+void ath9k_enable_ps(struct ath_softc *sc)
+{
+	sc->ps_enabled = true;
+	if (!(sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_AUTOSLEEP)) {
+		if ((sc->imask & ATH9K_INT_TIM_TIMER) == 0) {
+			sc->imask |= ATH9K_INT_TIM_TIMER;
+			ath9k_hw_set_interrupts(sc->sc_ah,
+					sc->imask);
+		}
+	}
+	ath9k_hw_setrxabort(sc->sc_ah, 1);
+}
+
 static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 {
 	struct ath_wiphy *aphy = hw->priv;
@@ -2336,19 +2349,9 @@ static int ath9k_config(struct ieee80211
 	if (changed & IEEE80211_CONF_CHANGE_PS) {
 		if (conf->flags & IEEE80211_CONF_PS) {
 			sc->sc_flags |= SC_OP_PS_ENABLED;
-			if (!(ah->caps.hw_caps &
-			      ATH9K_HW_CAP_AUTOSLEEP)) {
-				if ((sc->imask & ATH9K_INT_TIM_TIMER) == 0) {
-					sc->imask |= ATH9K_INT_TIM_TIMER;
-					ath9k_hw_set_interrupts(sc->sc_ah,
-							sc->imask);
-				}
-			}
-			sc->ps_enabled = true;
 			if ((sc->sc_flags & SC_OP_NULLFUNC_COMPLETED)) {
 				sc->sc_flags &= ~SC_OP_NULLFUNC_COMPLETED;
-				sc->ps_enabled = true;
-				ath9k_hw_setrxabort(sc->sc_ah, 1);
+				ath9k_enable_ps(sc);
 			}
 		} else {
 			sc->ps_enabled = false;
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1979,10 +1979,9 @@ static void ath_tx_processq(struct ath_s
 
 		if (bf->bf_isnullfunc &&
 		    (ds->ds_txstat.ts_status & ATH9K_TX_ACKED)) {
-			if ((sc->sc_flags & SC_OP_PS_ENABLED)) {
-				sc->ps_enabled = true;
-				ath9k_hw_setrxabort(sc->sc_ah, 1);
-			} else
+			if ((sc->sc_flags & SC_OP_PS_ENABLED))
+				ath9k_enable_ps(sc);
+			else
 				sc->sc_flags |= SC_OP_NULLFUNC_COMPLETED;
 		}
 


