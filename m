Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932421Ab2LMOHa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:07:30 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44483 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932254Ab2LMOHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:07:24 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ignacy Gawedzki <i@lri.fr>, Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
        Johannes Berg <johannes.berg@intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 107/241] mac80211: deinitialize ibss-internals after emptiness check
Date: Thu, 13 Dec 2012 11:57:52 -0200
Message-Id: <1355407206-17100-108-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/mac80211/ibss.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index ebf6425..980b4f4 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -1154,10 +1154,6 @@ int ieee80211_ibss_leave(struct ieee80211_sub_if_data *sdata)
 
 	mutex_lock(&sdata->u.ibss.mtx);
 
-	sdata->u.ibss.state = IEEE80211_IBSS_MLME_SEARCH;
-	memset(sdata->u.ibss.bssid, 0, ETH_ALEN);
-	sdata->u.ibss.ssid_len = 0;
-
 	active_ibss = ieee80211_sta_active_ibss(sdata);
 
 	if (!active_ibss && !is_zero_ether_addr(ifibss->bssid)) {
@@ -1178,6 +1174,10 @@ int ieee80211_ibss_leave(struct ieee80211_sub_if_data *sdata)
 		}
 	}
 
+	ifibss->state = IEEE80211_IBSS_MLME_SEARCH;
+	memset(ifibss->bssid, 0, ETH_ALEN);
+	ifibss->ssid_len = 0;
+
 	sta_info_flush(sdata->local, sdata);
 
 	spin_lock_bh(&ifibss->incomplete_lock);
-- 
1.7.9.5

