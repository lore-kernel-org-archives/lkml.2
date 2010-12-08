Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932110Ab0LHBxX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:53:23 -0500
Received: from kroah.org ([198.145.64.141]:48589 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756712Ab0LHA7p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:59:45 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:26 2010
Message-Id: <20101208005726.443282272@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:57:08 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Paul Stewart <pstew@google.com>, Amod Bodas <amod.bodas@atheros.com>,
        "Luis R. Rodriguez" <lrodriguez@atheros.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [051/289] mac80211: add helper for reseting the connection monitor
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

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

---
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/mlme.c        |   15 ++++++++++-----
 2 files changed, 11 insertions(+), 5 deletions(-)

--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1003,6 +1003,7 @@ void ieee80211_sta_restart(struct ieee80
 void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata);
 void ieee80211_sta_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 				  struct sk_buff *skb);
+void ieee80211_sta_reset_conn_monitor(struct ieee80211_sub_if_data *sdata);
 
 /* IBSS code */
 void ieee80211_ibss_notify_scan_completed(struct ieee80211_local *local);
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
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
@@ -1006,11 +1015,7 @@ void ieee80211_sta_rx_notify(struct ieee
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


