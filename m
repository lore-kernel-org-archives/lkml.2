Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761427Ab2J2ViO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 17:38:14 -0400
Received: from mail.kernel.org ([198.145.19.201]:48085 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761412Ab2J2ViL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:38:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Pedro Francisco <pedrogfrancisco@gmail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 096/101] cfg80211/mac80211: avoid state mishmash on deauth
Date: Mon, 29 Oct 2012 14:35:49 -0700
Message-Id: <20121029213250.980820237@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121029213240.128426598@linuxfoundation.org>
References: <20121029213240.128426598@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit 6863255bd0e48bc41ae5a066d5c771801e92735a upstream.

Avoid situation when we are on associate state in mac80211 and
on disassociate state in cfg80211. This can results on crash
during modules unload (like showed on this thread:
http://marc.info/?t=134373976300001&r=1&w=2) and possibly other
problems.

Reported-by: Pedro Francisco <pedrogfrancisco@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/net/cfg80211.h |    1 +
 net/mac80211/mlme.c    |    5 +++--
 net/wireless/mlme.c    |   12 +++---------
 3 files changed, 7 insertions(+), 11 deletions(-)

--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1217,6 +1217,7 @@ struct cfg80211_deauth_request {
 	const u8 *ie;
 	size_t ie_len;
 	u16 reason_code;
+	bool local_state_change;
 };
 
 /**
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3467,6 +3467,7 @@ int ieee80211_mgd_deauth(struct ieee8021
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	u8 frame_buf[DEAUTH_DISASSOC_LEN];
+	bool tx = !req->local_state_change;
 
 	mutex_lock(&ifmgd->mtx);
 
@@ -3483,11 +3484,11 @@ int ieee80211_mgd_deauth(struct ieee8021
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
 
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -457,20 +457,14 @@ int __cfg80211_mlme_deauth(struct cfg802
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


