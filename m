Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162011Ab2GLWm0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 18:42:26 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:34801 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162001Ab2GLWmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:42:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ido Yariv <ido@wizery.com>, Eliad Peller <eliad@wizery.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 115/187] mac80211: clear ifmgd->bssid only after building DELBA
Date: Thu, 12 Jul 2012 15:34:31 -0700
Message-Id: <20120712191533.029845013@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eliad Peller <eliad@wizery.com>

commit 88a9e31c506c00c8b7a2f1611406d0e38dcb33b3 upstream.

ieee80211_set_disassoc() clears ifmgd->bssid before
building DELBA frames, resulting in frames with invalid
bssid ("00:00:00:00:00:00").

Fix it by clearing ifmgd->bssid only after building
all the needed frames.

After this change, we no longer need to save the
bssid (before clearing it), so remove the local array.

Reported-by: Ido Yariv <ido@wizery.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/mlme.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1375,7 +1375,6 @@ static void ieee80211_set_disassoc(struc
 	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta;
 	u32 changed = 0;
-	u8 bssid[ETH_ALEN];
 
 	ASSERT_MGD_MTX(ifmgd);
 
@@ -1385,10 +1384,7 @@ static void ieee80211_set_disassoc(struc
 	if (WARN_ON(!ifmgd->associated))
 		return;
 
-	memcpy(bssid, ifmgd->associated->bssid, ETH_ALEN);
-
 	ifmgd->associated = NULL;
-	memset(ifmgd->bssid, 0, ETH_ALEN);
 
 	/*
 	 * we need to commit the associated = NULL change because the
@@ -1408,7 +1404,7 @@ static void ieee80211_set_disassoc(struc
 	netif_carrier_off(sdata->dev);
 
 	mutex_lock(&local->sta_mtx);
-	sta = sta_info_get(sdata, bssid);
+	sta = sta_info_get(sdata, ifmgd->bssid);
 	if (sta) {
 		set_sta_flag(sta, WLAN_STA_BLOCK_BA);
 		ieee80211_sta_tear_down_BA_sessions(sta, tx);
@@ -1417,13 +1413,16 @@ static void ieee80211_set_disassoc(struc
 
 	/* deauthenticate/disassociate now */
 	if (tx || frame_buf)
-		ieee80211_send_deauth_disassoc(sdata, bssid, stype, reason,
-					       tx, frame_buf);
+		ieee80211_send_deauth_disassoc(sdata, ifmgd->bssid, stype,
+					       reason, tx, frame_buf);
 
 	/* flush out frame */
 	if (tx)
 		drv_flush(local, false);
 
+	/* clear bssid only after building the needed mgmt frames */
+	memset(ifmgd->bssid, 0, ETH_ALEN);
+
 	/* remove AP and TDLS peers */
 	sta_info_flush(local, sdata);
 


