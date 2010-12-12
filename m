Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754383Ab0LLXps (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:45:48 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44642 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272Ab0LLXpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:45:15 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: lrodriguez@atheros.com, pstew@google.com, amod.bodas@atheros.com,
        linville@tuxdriver.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [18/223] mac80211: make the beacon monitor available externally
Message-Id: <20101212234513.BCECDB27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:45:13 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Luis R. Rodriguez <lrodriguez@atheros.com>

commit d3a910a8e4e846b9a767d35483f4dc7c6de7af82 upstream.

This will be used by other components next. The beacon
monitor was added as of 2.6.34 so these fixes are applicable
only to kernels >= 2.6.34.

Cc: Paul Stewart <pstew@google.com>
Cc: Amod Bodas <amod.bodas@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/mlme.c        |    8 ++++----
 2 files changed, 5 insertions(+), 4 deletions(-)

Index: linux/net/mac80211/ieee80211_i.h
===================================================================
--- linux.orig/net/mac80211/ieee80211_i.h
+++ linux/net/mac80211/ieee80211_i.h
@@ -1003,6 +1003,7 @@ void ieee80211_sta_process_chanswitch(st
 void ieee80211_sta_quiesce(struct ieee80211_sub_if_data *sdata);
 void ieee80211_sta_restart(struct ieee80211_sub_if_data *sdata);
 void ieee80211_sta_reset_conn_monitor(struct ieee80211_sub_if_data *sdata);
+void ieee80211_sta_reset_beacon_monitor(struct ieee80211_sub_if_data *sdata);
 
 /* IBSS code */
 void ieee80211_ibss_notify_scan_completed(struct ieee80211_local *local);
Index: linux/net/mac80211/mlme.c
===================================================================
--- linux.orig/net/mac80211/mlme.c
+++ linux/net/mac80211/mlme.c
@@ -109,7 +109,7 @@ static void run_again(struct ieee80211_i
 		mod_timer(&ifmgd->timer, timeout);
 }
 
-static void mod_beacon_timer(struct ieee80211_sub_if_data *sdata)
+void ieee80211_sta_reset_beacon_monitor(struct ieee80211_sub_if_data *sdata)
 {
 	if (sdata->local->hw.flags & IEEE80211_HW_BEACON_FILTER)
 		return;
@@ -1315,7 +1315,7 @@ static bool ieee80211_assoc_success(stru
 	 * Also start the timer that will detect beacon loss.
 	 */
 	ieee80211_sta_rx_notify(sdata, (struct ieee80211_hdr *)mgmt);
-	mod_beacon_timer(sdata);
+	ieee80211_sta_reset_beacon_monitor(sdata);
 
 	return true;
 }
@@ -1418,7 +1418,7 @@ static void ieee80211_rx_mgmt_probe_resp
 		 * we have or will be receiving any beacons or data, so let's
 		 * schedule the timers again, just in case.
 		 */
-		mod_beacon_timer(sdata);
+		ieee80211_sta_reset_beacon_monitor(sdata);
 
 		mod_timer(&ifmgd->conn_mon_timer,
 			  round_jiffies_up(jiffies +
@@ -1541,7 +1541,7 @@ static void ieee80211_rx_mgmt_beacon(str
 	 * Push the beacon loss detection into the future since
 	 * we are processing a beacon from the AP just now.
 	 */
-	mod_beacon_timer(sdata);
+	ieee80211_sta_reset_beacon_monitor(sdata);
 
 	ncrc = crc32_be(0, (void *)&mgmt->u.beacon.beacon_int, 4);
 	ncrc = ieee802_11_parse_elems_crc(mgmt->u.beacon.variable,
