Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757004Ab0LHCBU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 21:01:20 -0500
Received: from kroah.org ([198.145.64.141]:48368 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756274Ab0LHA7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:59:13 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:23 2010
Message-Id: <20101208005723.206678156@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:56:35 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [018/289] ath9k: fix an aggregation start related race condition
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 231c3a1f0630c07a584905507a1cb7b705a56ab7 upstream.

A new aggregation session start can be issued by mac80211, even when the
cleanup of the previous session has not completed yet. Since the data structure
for the session is not recreated, this could corrupt the block ack window
and lock up the aggregation session. Fix this by delaying the new session
until the old one has been cleaned up.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/ath9k.h |    4 ++--
 drivers/net/wireless/ath/ath9k/main.c  |    5 +++--
 drivers/net/wireless/ath/ath9k/xmit.c  |   10 ++++++++--
 3 files changed, 13 insertions(+), 6 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -346,8 +346,8 @@ void ath_tx_tasklet(struct ath_softc *sc
 void ath_tx_edma_tasklet(struct ath_softc *sc);
 void ath_tx_cabq(struct ieee80211_hw *hw, struct sk_buff *skb);
 bool ath_tx_aggr_check(struct ath_softc *sc, struct ath_node *an, u8 tidno);
-void ath_tx_aggr_start(struct ath_softc *sc, struct ieee80211_sta *sta,
-		       u16 tid, u16 *ssn);
+int ath_tx_aggr_start(struct ath_softc *sc, struct ieee80211_sta *sta,
+		      u16 tid, u16 *ssn);
 void ath_tx_aggr_stop(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid);
 void ath_tx_aggr_resume(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid);
 void ath9k_enable_ps(struct ath_softc *sc);
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1973,8 +1973,9 @@ static int ath9k_ampdu_action(struct iee
 		break;
 	case IEEE80211_AMPDU_TX_START:
 		ath9k_ps_wakeup(sc);
-		ath_tx_aggr_start(sc, sta, tid, ssn);
-		ieee80211_start_tx_ba_cb_irqsafe(vif, sta->addr, tid);
+		ret = ath_tx_aggr_start(sc, sta, tid, ssn);
+		if (!ret)
+			ieee80211_start_tx_ba_cb_irqsafe(vif, sta->addr, tid);
 		ath9k_ps_restore(sc);
 		break;
 	case IEEE80211_AMPDU_TX_STOP:
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -792,17 +792,23 @@ static void ath_tx_sched_aggr(struct ath
 		 status != ATH_AGGR_BAW_CLOSED);
 }
 
-void ath_tx_aggr_start(struct ath_softc *sc, struct ieee80211_sta *sta,
-		       u16 tid, u16 *ssn)
+int ath_tx_aggr_start(struct ath_softc *sc, struct ieee80211_sta *sta,
+		      u16 tid, u16 *ssn)
 {
 	struct ath_atx_tid *txtid;
 	struct ath_node *an;
 
 	an = (struct ath_node *)sta->drv_priv;
 	txtid = ATH_AN_2_TID(an, tid);
+
+	if (txtid->state & (AGGR_CLEANUP | AGGR_ADDBA_COMPLETE))
+		return -EAGAIN;
+
 	txtid->state |= AGGR_ADDBA_PROGRESS;
 	txtid->paused = true;
 	*ssn = txtid->seq_start;
+
+	return 0;
 }
 
 void ath_tx_aggr_stop(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid)


