Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127Ab0LLXpe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:45:34 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44599 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200Ab0LLXpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:45:07 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: johannes.berg@intel.com, linville@tuxdriver.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [11/223] cfg80211: fix locking
Message-Id: <20101212234506.5E4DCB27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:45:06 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Johannes Berg <johannes.berg@intel.com>

commit 2234362c427e2ef667595b9b81c0125003ac5607 upstream.

Add missing unlocking of the wiphy in set_channel,
and don't try to unlock a non-existing wiphy in
set_cqm.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 net/wireless/nl80211.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

Index: linux/net/wireless/nl80211.c
===================================================================
--- linux.orig/net/wireless/nl80211.c
+++ linux/net/wireless/nl80211.c
@@ -758,11 +758,13 @@ static int nl80211_set_channel(struct sk
 
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
@@ -4909,7 +4911,7 @@ static int nl80211_set_cqm_rssi(struct g
 
 	err = get_rdev_dev_by_info_ifindex(info, &rdev, &dev);
 	if (err)
-		goto unlock_rdev;
+		goto unlock_rtnl;
 
 	wdev = dev->ieee80211_ptr;
 
@@ -4926,9 +4928,10 @@ static int nl80211_set_cqm_rssi(struct g
 	err = rdev->ops->set_cqm_rssi_config(wdev->wiphy, dev,
 					     threshold, hysteresis);
 
-unlock_rdev:
+ unlock_rdev:
 	cfg80211_unlock_rdev(rdev);
 	dev_put(dev);
+ unlock_rtnl:
 	rtnl_unlock();
 
 	return err;
