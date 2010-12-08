Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932436Ab0LHBw5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:52:57 -0500
Received: from kroah.org ([198.145.64.141]:48596 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756975Ab0LHA7q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:59:46 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:26 2010
Message-Id: <20101208005726.539262212@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:57:09 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Paul Stewart <pstew@google.com>, Amod Bodas <amod.bodas@atheros.com>,
        "Luis R. Rodriguez" <lrodriguez@atheros.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [052/289] mac80211: make the beacon monitor available externally
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

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

---
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/mlme.c        |    8 ++++----
 2 files changed, 5 insertions(+), 4 deletions(-)

--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1003,6 +1003,7 @@ void ieee80211_sta_restart(struct ieee80
 void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata);
 void ieee80211_sta_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 				  struct sk_buff *skb);
+void ieee80211_sta_reset_beacon_monitor(struct ieee80211_sub_if_data *sdata);
 void ieee80211_sta_reset_conn_monitor(struct ieee80211_sub_if_data *sdata);
 
 /* IBSS code */
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -109,7 +109,7 @@ static void run_again(struct ieee80211_i
 		mod_timer(&ifmgd->timer, timeout);
 }
 
-static void mod_beacon_timer(struct ieee80211_sub_if_data *sdata)
+void ieee80211_sta_reset_beacon_monitor(struct ieee80211_sub_if_data *sdata)
 {
 	if (sdata->local->hw.flags & IEEE80211_HW_BEACON_FILTER)
 		return;
@@ -1367,7 +1367,7 @@ static bool ieee80211_assoc_success(stru
 	 * Also start the timer that will detect beacon loss.
 	 */
 	ieee80211_sta_rx_notify(sdata, (struct ieee80211_hdr *)mgmt);
-	mod_beacon_timer(sdata);
+	ieee80211_sta_reset_beacon_monitor(sdata);
 
 	return true;
 }
@@ -1470,7 +1470,7 @@ static void ieee80211_rx_mgmt_probe_resp
 		 * we have or will be receiving any beacons or data, so let's
 		 * schedule the timers again, just in case.
 		 */
-		mod_beacon_timer(sdata);
+		ieee80211_sta_reset_beacon_monitor(sdata);
 
 		mod_timer(&ifmgd->conn_mon_timer,
 			  round_jiffies_up(jiffies +
@@ -1593,7 +1593,7 @@ static void ieee80211_rx_mgmt_beacon(str
 	 * Push the beacon loss detection into the future since
 	 * we are processing a beacon from the AP just now.
 	 */
-	mod_beacon_timer(sdata);
+	ieee80211_sta_reset_beacon_monitor(sdata);
 
 	ncrc = crc32_be(0, (void *)&mgmt->u.beacon.beacon_int, 4);
 	ncrc = ieee802_11_parse_elems_crc(mgmt->u.beacon.variable,


