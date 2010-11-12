Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558Ab0KLDAV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 22:00:21 -0500
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:40001 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755400Ab0KLDAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 22:00:16 -0500
Subject: [PATCH v7 2/3] ath5k: Use generic EWMA library
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: randy.dunlap@oracle.com, br1@thinktube.com, peterz@infradead.org,
        blp@cs.stanford.edu, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lars_Ericsson@telia.com,
        stefanr@s5r6.in-berlin.de, kosaki.motohiro@jp.fujitsu.com,
        akpm@linux-foundation.org, kevin.granade@gmail.com
Date: Fri, 12 Nov 2010 12:00:30 +0900
Message-ID: <20101112030030.28522.76794.stgit@localhost6.localdomain6>
In-Reply-To: <20101112024901.28522.21895.stgit@localhost6.localdomain6>
References: <20101112024901.28522.21895.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-SF-Loop: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove ath5k's private moving average implementation in favour of the generic
library version.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/Kconfig |    1 +
 drivers/net/wireless/ath/ath5k/ani.c   |    4 ++--
 drivers/net/wireless/ath/ath5k/ath5k.h |   26 ++------------------------
 drivers/net/wireless/ath/ath5k/base.c  |    4 ++--
 drivers/net/wireless/ath/ath5k/debug.c |    2 +-
 5 files changed, 8 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/Kconfig b/drivers/net/wireless/ath/ath5k/Kconfig
index eb83b7b..4784457 100644
--- a/drivers/net/wireless/ath/ath5k/Kconfig
+++ b/drivers/net/wireless/ath/ath5k/Kconfig
@@ -4,6 +4,7 @@ config ATH5K
 	select MAC80211_LEDS
 	select LEDS_CLASS
 	select NEW_LEDS
+	select AVERAGE
 	---help---
 	  This module adds support for wireless adapters based on
 	  Atheros 5xxx chipset.
diff --git a/drivers/net/wireless/ath/ath5k/ani.c b/drivers/net/wireless/ath/ath5k/ani.c
index f141919..545e489 100644
--- a/drivers/net/wireless/ath/ath5k/ani.c
+++ b/drivers/net/wireless/ath/ath5k/ani.c
@@ -216,7 +216,7 @@ static void
 ath5k_ani_raise_immunity(struct ath5k_hw *ah, struct ath5k_ani_state *as,
 			 bool ofdm_trigger)
 {
-	int rssi = ah->ah_beacon_rssi_avg.avg;
+	int rssi = ewma_get(&ah->ah_beacon_rssi_avg);
 
 	ATH5K_DBG_UNLIMIT(ah->ah_sc, ATH5K_DEBUG_ANI, "raise immunity (%s)",
 		ofdm_trigger ? "ODFM" : "CCK");
@@ -301,7 +301,7 @@ ath5k_ani_raise_immunity(struct ath5k_hw *ah, struct ath5k_ani_state *as,
 static void
 ath5k_ani_lower_immunity(struct ath5k_hw *ah, struct ath5k_ani_state *as)
 {
-	int rssi = ah->ah_beacon_rssi_avg.avg;
+	int rssi = ewma_get(&ah->ah_beacon_rssi_avg);
 
 	ATH5K_DBG_UNLIMIT(ah->ah_sc, ATH5K_DEBUG_ANI, "lower immunity");
 
diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index 308b79e..2718136 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -25,6 +25,7 @@
 
 #include <linux/io.h>
 #include <linux/types.h>
+#include <linux/average.h>
 #include <net/mac80211.h>
 
 /* RX/TX descriptor hw structs
@@ -1102,7 +1103,7 @@ struct ath5k_hw {
 	struct ath5k_nfcal_hist ah_nfcal_hist;
 
 	/* average beacon RSSI in our BSS (used by ANI) */
-	struct ath5k_avg_val	ah_beacon_rssi_avg;
+	struct ewma		ah_beacon_rssi_avg;
 
 	/* noise floor from last periodic calibration */
 	s32			ah_noise_floor;
@@ -1315,27 +1316,4 @@ static inline u32 ath5k_hw_bitswap(u32 val, unsigned int bits)
 	return retval;
 }
 
-#define AVG_SAMPLES	8
-#define AVG_FACTOR	1000
-
-/**
- * ath5k_moving_average -  Exponentially weighted moving average
- * @avg: average structure
- * @val: current value
- *
- * This implementation make use of a struct ath5k_avg_val to prevent rounding
- * errors.
- */
-static inline struct ath5k_avg_val
-ath5k_moving_average(const struct ath5k_avg_val avg, const int val)
-{
-	struct ath5k_avg_val new;
-	new.avg_weight = avg.avg_weight  ?
-		(((avg.avg_weight * ((AVG_SAMPLES) - 1)) +
-			(val * (AVG_FACTOR))) / (AVG_SAMPLES)) :
-		(val * (AVG_FACTOR));
-	new.avg = new.avg_weight / (AVG_FACTOR);
-	return new;
-}
-
 #endif
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 4d21202..ae069b7 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1307,8 +1307,7 @@ ath5k_update_beacon_rssi(struct ath5k_softc *sc, struct sk_buff *skb, int rssi)
 	    memcmp(mgmt->bssid, common->curbssid, ETH_ALEN) != 0)
 		return;
 
-	ah->ah_beacon_rssi_avg = ath5k_moving_average(ah->ah_beacon_rssi_avg,
-						      rssi);
+	ewma_add(&ah->ah_beacon_rssi_avg, rssi);
 
 	/* in IBSS mode we should keep RSSI statistics per neighbour */
 	/* le16_to_cpu(mgmt->u.beacon.capab_info) & WLAN_CAPABILITY_IBSS */
@@ -2562,6 +2561,7 @@ ath5k_reset(struct ath5k_softc *sc, struct ieee80211_channel *chan)
 	ah->ah_cal_next_full = jiffies;
 	ah->ah_cal_next_ani = jiffies;
 	ah->ah_cal_next_nf = jiffies;
+	ewma_init(&ah->ah_beacon_rssi_avg, 1000, 8);
 
 	/*
 	 * Change channels and update the h/w rate map if we're switching;
diff --git a/drivers/net/wireless/ath/ath5k/debug.c b/drivers/net/wireless/ath/ath5k/debug.c
index 54dcf77..043cb15 100644
--- a/drivers/net/wireless/ath/ath5k/debug.c
+++ b/drivers/net/wireless/ath/ath5k/debug.c
@@ -719,7 +719,7 @@ static ssize_t read_file_ani(struct file *file, char __user *user_buf,
 			st->mib_intr);
 	len += snprintf(buf+len, sizeof(buf)-len,
 			"beacon RSSI average:\t%d\n",
-			sc->ah->ah_beacon_rssi_avg.avg);
+			(int)ewma_get(&sc->ah->ah_beacon_rssi_avg));
 
 #define CC_PRINT(_struct, _field) \
 	_struct._field, \

