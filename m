Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293Ab0LLXpm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:45:42 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44626 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254Ab0LLXpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:45:12 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: lrodriguez@atheros.com, pstew@google.com, amod.bodas@atheros.com,
        linville@tuxdriver.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [16/223] mac80211: add helper for reseting the connection monitor
Message-Id: <20101212234511.A1EE6B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:45:11 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Luis R. Rodriguez <lrodriguez@atheros.com>

commit be099e82e9cf6d5d65d044e9ef6fc8bee3c7a113 upstream.

This will be used in another place later. The connection
monitor was added as of 2.6.35 so these fixes will be
applicable to >= 2.6.35.

Cc: Paul Stewart <pstew@google.com>
Cc: Amod Bodas <amod.bodas@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/mlme.c        |   15 ++++++++++-----
 2 files changed, 11 insertions(+), 5 deletions(-)

Index: linux/net/mac80211/ieee80211_i.h
===================================================================
--- linux.orig/net/mac80211/ieee80211_i.h
+++ linux/net/mac80211/ieee80211_i.h
@@ -1002,6 +1002,7 @@ void ieee80211_sta_process_chanswitch(st
 				      u64 timestamp);
 void ieee80211_sta_quiesce(struct ieee80211_sub_if_data *sdata);
 void ieee80211_sta_restart(struct ieee80211_sub_if_data *sdata);
+void ieee80211_sta_reset_conn_monitor(struct ieee80211_sub_if_data *sdata);
 
 /* IBSS code */
 void ieee80211_ibss_notify_scan_completed(struct ieee80211_local *local);
Index: linux/net/mac80211/mlme.c
===================================================================
--- linux.orig/net/mac80211/mlme.c
+++ linux/net/mac80211/mlme.c
@@ -118,6 +118,15 @@ static void mod_beacon_timer(struct ieee
 		  round_jiffies_up(jiffies + IEEE80211_BEACON_LOSS_TIME));
 }
 
+void ieee80211_sta_reset_conn_monitor(struct ieee80211_sub_if_data *sdata)
+{
+	if (sdata->local->hw.flags & IEEE80211_HW_CONNECTION_MONITOR)
+		return;
+
+	mod_timer(&sdata->u.mgd.conn_mon_timer,
+		  round_jiffies_up(jiffies + IEEE80211_CONNECTION_IDLE_TIME));
+}
+
 static int ecw2cw(int ecw)
 {
 	return (1 << ecw) - 1;
@@ -954,11 +963,7 @@ void ieee80211_sta_rx_notify(struct ieee
 	if (is_multicast_ether_addr(hdr->addr1))
 		return;
 
-	if (sdata->local->hw.flags & IEEE80211_HW_CONNECTION_MONITOR)
-		return;
-
-	mod_timer(&sdata->u.mgd.conn_mon_timer,
-		  round_jiffies_up(jiffies + IEEE80211_CONNECTION_IDLE_TIME));
+	ieee80211_sta_reset_conn_monitor(sdata);
 }
 
 static void ieee80211_mgd_probe_ap_send(struct ieee80211_sub_if_data *sdata)
