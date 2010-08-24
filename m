Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934059Ab0HXXWR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:22:17 -0400
Received: from kroah.org ([198.145.64.141]:40892 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933319Ab0HXXBg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 19:01:36 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:45:03 2010
Message-Id: <20100824224503.194972293@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:44:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Johannes Berg <johannes.berg@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [022/114] cfg80211: fix locking in action frame TX
In-Reply-To: <20100824224610.GA5424@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit fe100acddf438591ecf3582cb57241e560da70b7 upstream.

Accesses to "wdev->current_bss" must be
locked with the wdev lock, which action
frame transmission is missing.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/wireless/mlme.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -842,12 +842,18 @@ int cfg80211_mlme_action(struct cfg80211
 		return -EINVAL;
 	if (mgmt->u.action.category != WLAN_CATEGORY_PUBLIC) {
 		/* Verify that we are associated with the destination AP */
+		wdev_lock(wdev);
+
 		if (!wdev->current_bss ||
 		    memcmp(wdev->current_bss->pub.bssid, mgmt->bssid,
 			   ETH_ALEN) != 0 ||
 		    memcmp(wdev->current_bss->pub.bssid, mgmt->da,
-			   ETH_ALEN) != 0)
+			    ETH_ALEN) != 0) {
+			wdev_unlock(wdev);
 			return -ENOTCONN;
+		}
+		wdev_unlock(wdev);
+
 	}
 
 	if (memcmp(mgmt->sa, dev->dev_addr, ETH_ALEN) != 0)


