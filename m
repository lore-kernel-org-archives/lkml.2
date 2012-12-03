Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932406Ab2LCOgo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 09:36:44 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43832 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932367Ab2LCOgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 09:36:40 -0500
Message-Id: <20121203143154.892151833@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 03 Dec 2012 14:32:39 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
        Ignacy Gawedzki <i@lri.fr>, Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 53/89] mac80211: deinitialize ibss-internals after emptiness check
In-Reply-To: <20121203143146.549859007@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>

commit b78a4932f5fb11fadf41e69c606a33fa6787574c upstream.

The check whether the IBSS is active and can be removed should be
performed before deinitializing the fields used for the check/search.
Otherwise, the configured BSS will not be found and removed properly.

To make it more clear for the future, rename sdata->u.ibss to the
local pointer ifibss which is used within the checks.

This behaviour was introduced by
f3209bea110cade12e2b133da8b8499689cb0e2e
("mac80211: fix IBSS teardown race")

Cc: Ignacy Gawedzki <i@lri.fr>
Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/mac80211/ibss.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -965,10 +965,6 @@ int ieee80211_ibss_leave(struct ieee8021
 
 	mutex_lock(&sdata->u.ibss.mtx);
 
-	sdata->u.ibss.state = IEEE80211_IBSS_MLME_SEARCH;
-	memset(sdata->u.ibss.bssid, 0, ETH_ALEN);
-	sdata->u.ibss.ssid_len = 0;
-
 	active_ibss = ieee80211_sta_active_ibss(sdata);
 
 	if (!active_ibss && !is_zero_ether_addr(ifibss->bssid)) {
@@ -989,6 +985,10 @@ int ieee80211_ibss_leave(struct ieee8021
 		}
 	}
 
+	ifibss->state = IEEE80211_IBSS_MLME_SEARCH;
+	memset(ifibss->bssid, 0, ETH_ALEN);
+	ifibss->ssid_len = 0;
+
 	sta_info_flush(sdata->local, sdata);
 
 	/* remove beacon */


