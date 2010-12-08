Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097Ab0LHByr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:54:47 -0500
Received: from kroah.org ([198.145.64.141]:48545 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756918Ab0LHA7h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:59:37 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:25 2010
Message-Id: <20101208005725.644025106@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:57:00 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Johannes Berg <johannes.berg@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [043/289] cfg80211: fix locking
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 2234362c427e2ef667595b9b81c0125003ac5607 upstream.

Add missing unlocking of the wiphy in set_channel,
and don't try to unlock a non-existing wiphy in
set_cqm.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/wireless/nl80211.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -761,11 +761,13 @@ static int nl80211_set_channel(struct sk
 
 	result = get_rdev_dev_by_info_ifindex(info, &rdev, &netdev);
 	if (result)
-		goto unlock;
+		goto unlock_rtnl;
 
 	result = __nl80211_set_channel(rdev, netdev->ieee80211_ptr, info);
 
- unlock:
+	dev_put(netdev);
+	cfg80211_unlock_rdev(rdev);
+ unlock_rtnl:
 	rtnl_unlock();
 
 	return result;
@@ -4996,7 +4998,7 @@ static int nl80211_set_cqm_rssi(struct g
 
 	err = get_rdev_dev_by_info_ifindex(info, &rdev, &dev);
 	if (err)
-		goto unlock_rdev;
+		goto unlock_rtnl;
 
 	wdev = dev->ieee80211_ptr;
 
@@ -5013,9 +5015,10 @@ static int nl80211_set_cqm_rssi(struct g
 	err = rdev->ops->set_cqm_rssi_config(wdev->wiphy, dev,
 					     threshold, hysteresis);
 
-unlock_rdev:
+ unlock_rdev:
 	cfg80211_unlock_rdev(rdev);
 	dev_put(dev);
+ unlock_rtnl:
 	rtnl_unlock();
 
 	return err;


