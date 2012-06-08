Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761935Ab2FHFUq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 01:20:46 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43207 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761189Ab2FHFHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 01:07:23 -0400
Message-Id: <20120608041844.483684296@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 08 Jun 2012 05:19:07 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Eyal Shapira <eyal@wizery.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 27/82] mac80211: fix ADDBA declined after suspend with wowlan
In-Reply-To: <20120608041840.861504477@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/mac80211/util.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 22f2216..a44c680 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1371,6 +1371,12 @@ int ieee80211_reconfig(struct ieee80211_local *local)
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
@@ -1392,12 +1398,6 @@ int ieee80211_reconfig(struct ieee80211_local *local)
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
 


