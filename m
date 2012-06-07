Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933408Ab2FGEXE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 00:23:04 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63306 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933337Ab2FGEW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 00:22:58 -0400
Message-Id: <20120607041359.662647300@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 07 Jun 2012 13:14:08 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Eyal Shapira <eyal@wizery.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 10/47] mac80211: fix ADDBA declined after suspend with wowlan
In-Reply-To: <20120607041504.GA13819@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eyal Shapira <eyal@wizery.com>

commit 7b21aea04d084916ac4e0e8852dcc9cd60ec0d1d upstream.

WLAN_STA_BLOCK_BA is set while suspending but doesn't get cleared
when resuming in case of wowlan. This causes further ADDBA requests
received to be rejected. Fix it by clearing it in the wowlan path
as well.

Signed-off-by: Eyal Shapira <eyal@wizery.com>
Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/util.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1254,6 +1254,12 @@ int ieee80211_reconfig(struct ieee80211_
 		}
 	}
 
+	/* add back keys */
+	list_for_each_entry(sdata, &local->interfaces, list)
+		if (ieee80211_sdata_running(sdata))
+			ieee80211_enable_keys(sdata);
+
+ wake_up:
 	/*
 	 * Clear the WLAN_STA_BLOCK_BA flag so new aggregation
 	 * sessions can be established after a resume.
@@ -1275,12 +1281,6 @@ int ieee80211_reconfig(struct ieee80211_
 		mutex_unlock(&local->sta_mtx);
 	}
 
-	/* add back keys */
-	list_for_each_entry(sdata, &local->interfaces, list)
-		if (ieee80211_sdata_running(sdata))
-			ieee80211_enable_keys(sdata);
-
- wake_up:
 	ieee80211_wake_queues_by_reason(hw,
 			IEEE80211_QUEUE_STOP_REASON_SUSPEND);
 


