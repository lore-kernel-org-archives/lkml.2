Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757445Ab2BAV3n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:29:43 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:60693 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757463Ab2BAVTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:19:20 -0500
X-Sasl-enc: 8e4jLlt6gqfhnIj/mx40GcduuqAr9oOen5ZRYANKF2B0 1328131159
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 13:00:45 2012
Message-Id: <20120201210045.477095805@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 12:59:42 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Pontus Fuchs <pontus.fuchs@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [18/89] mac80211: fix work removal on deauth request
In-Reply-To: <20120201210505.GA26028@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit bc4934bc61d0a11fd62c5187ff83645628f8be8b upstream.

When deauth is requested while an auth or assoc
work item is in progress, we currently delete it
without regard for any state it might need to
clean up. Fix it by cleaning up for those items.

In the case Pontus found, the problem manifested
itself as such:

authenticate with 00:23:69:aa:dd:7b (try 1)
authenticated
failed to insert Dummy STA entry for the AP (error -17)
deauthenticating from 00:23:69:aa:dd:7b by local choice (reason=2)

It could also happen differently if the driver
uses the tx_sync callback.

We can't just call the ->done() method of the work
items because that will lock up due to the locking
in cfg80211. This fix isn't very clean, but that
seems acceptable since I have patches pending to
remove this code completely.

Reported-by: Pontus Fuchs <pontus.fuchs@gmail.com>
Tested-by: Pontus Fuchs <pontus.fuchs@gmail.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/mlme.c |   38 +++++++++++++++++++++++++++-----------
 1 file changed, 27 insertions(+), 11 deletions(-)

--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2719,7 +2719,6 @@ int ieee80211_mgd_deauth(struct ieee8021
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
-	struct ieee80211_work *wk;
 	u8 bssid[ETH_ALEN];
 	bool assoc_bss = false;
 
@@ -2732,30 +2731,47 @@ int ieee80211_mgd_deauth(struct ieee8021
 		assoc_bss = true;
 	} else {
 		bool not_auth_yet = false;
+		struct ieee80211_work *tmp, *wk = NULL;
 
 		mutex_unlock(&ifmgd->mtx);
 
 		mutex_lock(&local->mtx);
-		list_for_each_entry(wk, &local->work_list, list) {
-			if (wk->sdata != sdata)
+		list_for_each_entry(tmp, &local->work_list, list) {
+			if (tmp->sdata != sdata)
 				continue;
 
-			if (wk->type != IEEE80211_WORK_DIRECT_PROBE &&
-			    wk->type != IEEE80211_WORK_AUTH &&
-			    wk->type != IEEE80211_WORK_ASSOC &&
-			    wk->type != IEEE80211_WORK_ASSOC_BEACON_WAIT)
+			if (tmp->type != IEEE80211_WORK_DIRECT_PROBE &&
+			    tmp->type != IEEE80211_WORK_AUTH &&
+			    tmp->type != IEEE80211_WORK_ASSOC &&
+			    tmp->type != IEEE80211_WORK_ASSOC_BEACON_WAIT)
 				continue;
 
-			if (memcmp(req->bss->bssid, wk->filter_ta, ETH_ALEN))
+			if (memcmp(req->bss->bssid, tmp->filter_ta, ETH_ALEN))
 				continue;
 
-			not_auth_yet = wk->type == IEEE80211_WORK_DIRECT_PROBE;
-			list_del_rcu(&wk->list);
-			free_work(wk);
+			not_auth_yet = tmp->type == IEEE80211_WORK_DIRECT_PROBE;
+			list_del_rcu(&tmp->list);
+			synchronize_rcu();
+			wk = tmp;
 			break;
 		}
 		mutex_unlock(&local->mtx);
 
+		if (wk && wk->type == IEEE80211_WORK_ASSOC) {
+			/* clean up dummy sta & TX sync */
+			sta_info_destroy_addr(wk->sdata, wk->filter_ta);
+			if (wk->assoc.synced)
+				drv_finish_tx_sync(local, wk->sdata,
+						   wk->filter_ta,
+						   IEEE80211_TX_SYNC_ASSOC);
+		} else if (wk && wk->type == IEEE80211_WORK_AUTH) {
+			if (wk->probe_auth.synced)
+				drv_finish_tx_sync(local, wk->sdata,
+						   wk->filter_ta,
+						   IEEE80211_TX_SYNC_AUTH);
+		}
+		kfree(wk);
+
 		/*
 		 * If somebody requests authentication and we haven't
 		 * sent out an auth frame yet there's no need to send


