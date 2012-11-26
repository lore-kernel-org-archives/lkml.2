Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000Ab2KZRjS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:39:18 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47883 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755396Ab2KZRLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:11:22 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 183/270] cfg80211/mac80211: avoid state mishmash on deauth
Date: Mon, 26 Nov 2012 14:57:53 -0200
Message-Id: <1353949160-26803-184-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit 6863255bd0e48bc41ae5a066d5c771801e92735a upstream.

Avoid situation when we are on associate state in mac80211 and
on disassociate state in cfg80211. This can results on crash
during modules unload (like showed on this thread:
http://marc.info/?t=134373976300001&r=1&w=2) and possibly other
problems.

Reported-by: Pedro Francisco <pedrogfrancisco@gmail.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[herton: use the patch for 3.6 stable]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 include/net/cfg80211.h |    1 +
 net/mac80211/mlme.c    |    5 +++--
 net/wireless/mlme.c    |   12 +++---------
 3 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 0289d4c..e225dcc 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1130,6 +1130,7 @@ struct cfg80211_deauth_request {
 	const u8 *ie;
 	size_t ie_len;
 	u16 reason_code;
+	bool local_state_change;
 };
 
 /**
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 92028de..6d79367 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3467,6 +3467,7 @@ int ieee80211_mgd_deauth(struct ieee80211_sub_if_data *sdata,
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	u8 frame_buf[DEAUTH_DISASSOC_LEN];
+	bool tx = !req->local_state_change;
 
 	mutex_lock(&ifmgd->mtx);
 
@@ -3483,11 +3484,11 @@ int ieee80211_mgd_deauth(struct ieee80211_sub_if_data *sdata,
 	if (ifmgd->associated &&
 	    ether_addr_equal(ifmgd->associated->bssid, req->bssid))
 		ieee80211_set_disassoc(sdata, IEEE80211_STYPE_DEAUTH,
-				       req->reason_code, true, frame_buf);
+				       req->reason_code, tx, frame_buf);
 	else
 		ieee80211_send_deauth_disassoc(sdata, req->bssid,
 					       IEEE80211_STYPE_DEAUTH,
-					       req->reason_code, true,
+					       req->reason_code, tx,
 					       frame_buf);
 	mutex_unlock(&ifmgd->mtx);
 
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index eb90988..b6626d9 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -441,20 +441,14 @@ int __cfg80211_mlme_deauth(struct cfg80211_registered_device *rdev,
 		.reason_code = reason,
 		.ie = ie,
 		.ie_len = ie_len,
+		.local_state_change = local_state_change,
 	};
 
 	ASSERT_WDEV_LOCK(wdev);
 
-	if (local_state_change) {
-		if (wdev->current_bss &&
-		    ether_addr_equal(wdev->current_bss->pub.bssid, bssid)) {
-			cfg80211_unhold_bss(wdev->current_bss);
-			cfg80211_put_bss(&wdev->current_bss->pub);
-			wdev->current_bss = NULL;
-		}
-
+	if (local_state_change && (!wdev->current_bss ||
+	    !ether_addr_equal(wdev->current_bss->pub.bssid, bssid)))
 		return 0;
-	}
 
 	return rdev->ops->deauth(&rdev->wiphy, dev, &req);
 }
-- 
1.7.9.5

