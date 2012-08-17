Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030716Ab2HQD2K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 23:28:10 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46866 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030688Ab2HQD1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 23:27:09 -0400
Message-Id: <20120817030247.226443279@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 17 Aug 2012 04:03:05 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Daniel Drake <dsd@laptop.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 22/37] cfg80211: process pending events when unregistering net device
In-Reply-To: <20120817030243.807605523@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Drake <dsd@laptop.org>

commit 1f6fc43e621167492ed4b7f3b4269c584c3d6ccc upstream.

libertas currently calls cfg80211_disconnected() when it is being
brought down. This causes an event to be allocated, but since the
wdev is already removed from the rdev by the time that the event
processing work executes, the event is never processed or freed.
http://article.gmane.org/gmane.linux.kernel.wireless.general/95666

Fix this leak, and other possible situations, by processing the event
queue when a device is being unregistered. Thanks to Johannes Berg for
the suggestion.

Signed-off-by: Daniel Drake <dsd@laptop.org>
Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/wireless/core.c |    5 +++++
 net/wireless/core.h |    1 +
 net/wireless/util.c |    2 +-
 3 files changed, 7 insertions(+), 1 deletion(-)

--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -971,6 +971,11 @@ static int cfg80211_netdev_notifier_call
 		 */
 		synchronize_rcu();
 		INIT_LIST_HEAD(&wdev->list);
+		/*
+		 * Ensure that all events have been processed and
+		 * freed.
+		 */
+		cfg80211_process_wdev_events(wdev);
 		break;
 	case NETDEV_PRE_UP:
 		if (!(wdev->wiphy->interface_modes & BIT(wdev->iftype)))
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -426,6 +426,7 @@ int cfg80211_change_iface(struct cfg8021
 			  struct net_device *dev, enum nl80211_iftype ntype,
 			  u32 *flags, struct vif_params *params);
 void cfg80211_process_rdev_events(struct cfg80211_registered_device *rdev);
+void cfg80211_process_wdev_events(struct wireless_dev *wdev);
 
 int cfg80211_can_change_interface(struct cfg80211_registered_device *rdev,
 				  struct wireless_dev *wdev,
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -725,7 +725,7 @@ void cfg80211_upload_connect_keys(struct
 	wdev->connect_keys = NULL;
 }
 
-static void cfg80211_process_wdev_events(struct wireless_dev *wdev)
+void cfg80211_process_wdev_events(struct wireless_dev *wdev)
 {
 	struct cfg80211_event *ev;
 	unsigned long flags;


