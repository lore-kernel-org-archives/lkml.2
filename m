Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758982Ab2FQS1o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 14:27:44 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50363 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758508Ab2FQSW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 14:22:57 -0400
Message-Id: <20120617175945.852510901@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Jun 2012 19:00:13 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Johannes Berg <johannes.berg@intel.com>,
        Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 32/69] cfg80211: fix interface combinations check
In-Reply-To: <20120617175941.281333656@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 463454b5dbd8dbab6e2fc6c557329e5b811b9c32 upstream.

If a given interface combination doesn't contain
a required interface type then we missed checking
that and erroneously allowed it even though iface
type wasn't there at all. Add a check that makes
sure that all interface types are accounted for.

Reported-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/wireless/util.c |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index 55d9946..8f2d68f 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -935,6 +935,7 @@ int cfg80211_can_change_interface(struct cfg80211_registered_device *rdev,
 				  enum nl80211_iftype iftype)
 {
 	struct wireless_dev *wdev_iter;
+	u32 used_iftypes = BIT(iftype);
 	int num[NUM_NL80211_IFTYPES];
 	int total = 1;
 	int i, j;
@@ -961,6 +962,7 @@ int cfg80211_can_change_interface(struct cfg80211_registered_device *rdev,
 
 		num[wdev_iter->iftype]++;
 		total++;
+		used_iftypes |= BIT(wdev_iter->iftype);
 	}
 	mutex_unlock(&rdev->devlist_mtx);
 
@@ -970,6 +972,7 @@ int cfg80211_can_change_interface(struct cfg80211_registered_device *rdev,
 	for (i = 0; i < rdev->wiphy.n_iface_combinations; i++) {
 		const struct ieee80211_iface_combination *c;
 		struct ieee80211_iface_limit *limits;
+		u32 all_iftypes = 0;
 
 		c = &rdev->wiphy.iface_combinations[i];
 
@@ -984,6 +987,7 @@ int cfg80211_can_change_interface(struct cfg80211_registered_device *rdev,
 			if (rdev->wiphy.software_iftypes & BIT(iftype))
 				continue;
 			for (j = 0; j < c->n_limits; j++) {
+				all_iftypes |= limits[j].types;
 				if (!(limits[j].types & BIT(iftype)))
 					continue;
 				if (limits[j].max < num[iftype])
@@ -991,7 +995,20 @@ int cfg80211_can_change_interface(struct cfg80211_registered_device *rdev,
 				limits[j].max -= num[iftype];
 			}
 		}
-		/* yay, it fits */
+
+		/*
+		 * Finally check that all iftypes that we're currently
+		 * using are actually part of this combination. If they
+		 * aren't then we can't use this combination and have
+		 * to continue to the next.
+		 */
+		if ((all_iftypes & used_iftypes) != used_iftypes)
+			goto cont;
+
+		/*
+		 * This combination covered all interface types and
+		 * supported the requested numbers, so we're good.
+		 */
 		kfree(limits);
 		return 0;
  cont:


