Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553Ab0C3Xzi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:55:38 -0400
Received: from kroah.org ([198.145.64.141]:45608 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932378Ab0C3XTO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:19:14 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:47:23 2010
Message-Id: <20100330224723.327843553@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:40:38 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Sujith <Sujith.Manoharan@atheros.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [004/156] mac80211: Fix HT rate control configuration
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Sujith <Sujith.Manoharan@atheros.com>

commit 4fa004373133ece3d9b1c0a7e243b0e53760b165 upstream.

Handling HT configuration changes involved setting the channel
with the new HT parameters and then issuing a rate_update()
notification to the driver.

This behavior changed after the off-channel changes. Now, the channel
is not updated with the new HT params in enable_ht() - instead, it
is now done when the scan work terminates. This results in the driver
depending on stale information, defaulting to non-HT mode always.

Fix this by passing the new channel type to the driver.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/rc.c |    6 +++---
 include/net/mac80211.h              |    3 ++-
 net/mac80211/mlme.c                 |    3 ++-
 net/mac80211/rate.h                 |    5 +++--
 4 files changed, 10 insertions(+), 7 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -1323,7 +1323,7 @@ static void ath_rate_init(void *priv, st
 
 static void ath_rate_update(void *priv, struct ieee80211_supported_band *sband,
 			    struct ieee80211_sta *sta, void *priv_sta,
-			    u32 changed)
+			    u32 changed, enum nl80211_channel_type oper_chan_type)
 {
 	struct ath_softc *sc = priv;
 	struct ath_rate_priv *ath_rc_priv = priv_sta;
@@ -1340,8 +1340,8 @@ static void ath_rate_update(void *priv,
 		if (sc->sc_ah->opmode != NL80211_IFTYPE_STATION)
 			return;
 
-		if (sc->hw->conf.channel_type == NL80211_CHAN_HT40MINUS ||
-		    sc->hw->conf.channel_type == NL80211_CHAN_HT40PLUS)
+		if (oper_chan_type == NL80211_CHAN_HT40MINUS ||
+		    oper_chan_type == NL80211_CHAN_HT40PLUS)
 			oper_cw40 = true;
 
 		oper_sgi40 = (sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_40) ?
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2258,7 +2258,8 @@ struct rate_control_ops {
 			  struct ieee80211_sta *sta, void *priv_sta);
 	void (*rate_update)(void *priv, struct ieee80211_supported_band *sband,
 			    struct ieee80211_sta *sta,
-			    void *priv_sta, u32 changed);
+			    void *priv_sta, u32 changed,
+			    enum nl80211_channel_type oper_chan_type);
 	void (*free_sta)(void *priv, struct ieee80211_sta *sta,
 			 void *priv_sta);
 
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -205,7 +205,8 @@ static u32 ieee80211_enable_ht(struct ie
 		sta = sta_info_get(local, bssid);
 		if (sta)
 			rate_control_rate_update(local, sband, sta,
-						 IEEE80211_RC_HT_CHANGED);
+						 IEEE80211_RC_HT_CHANGED,
+						 local->oper_channel_type);
 		rcu_read_unlock();
         }
 
--- a/net/mac80211/rate.h
+++ b/net/mac80211/rate.h
@@ -69,7 +69,8 @@ static inline void rate_control_rate_ini
 
 static inline void rate_control_rate_update(struct ieee80211_local *local,
 				    struct ieee80211_supported_band *sband,
-				    struct sta_info *sta, u32 changed)
+				    struct sta_info *sta, u32 changed,
+				    enum nl80211_channel_type oper_chan_type)
 {
 	struct rate_control_ref *ref = local->rate_ctrl;
 	struct ieee80211_sta *ista = &sta->sta;
@@ -77,7 +78,7 @@ static inline void rate_control_rate_upd
 
 	if (ref && ref->ops->rate_update)
 		ref->ops->rate_update(ref->priv, sband, ista,
-				      priv_sta, changed);
+				      priv_sta, changed, oper_chan_type);
 }
 
 static inline void *rate_control_alloc_sta(struct rate_control_ref *ref,


