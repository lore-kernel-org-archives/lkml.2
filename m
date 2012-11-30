Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992737Ab2K3S4d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 13:56:33 -0500
Received: from mail.kernel.org ([198.145.19.201]:58394 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992616Ab2K3S41 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 13:56:27 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Simon Wunderlich <siwu@hrz.tu-chemnitz.de>, Ignacy Gawedzki <i@lri.fr>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 29/56] mac80211: deinitialize ibss-internals after emptiness check
Date: Fri, 30 Nov 2012 10:55:21 -0800
Message-Id: <20121130185121.233810131@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121130185118.302752929@linuxfoundation.org>
References: <20121130185118.302752929@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Cc: Ignacy Gawedzki <i@lri.fr>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/ibss.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -1153,10 +1153,6 @@ int ieee80211_ibss_leave(struct ieee8021
 
 	mutex_lock(&sdata->u.ibss.mtx);
 
-	sdata->u.ibss.state = IEEE80211_IBSS_MLME_SEARCH;
-	memset(sdata->u.ibss.bssid, 0, ETH_ALEN);
-	sdata->u.ibss.ssid_len = 0;
-
 	active_ibss = ieee80211_sta_active_ibss(sdata);
 
 	if (!active_ibss && !is_zero_ether_addr(ifibss->bssid)) {
@@ -1177,6 +1173,10 @@ int ieee80211_ibss_leave(struct ieee8021
 		}
 	}
 
+	ifibss->state = IEEE80211_IBSS_MLME_SEARCH;
+	memset(ifibss->bssid, 0, ETH_ALEN);
+	ifibss->ssid_len = 0;
+
 	sta_info_flush(sdata->local, sdata);
 
 	spin_lock_bh(&ifibss->incomplete_lock);


