Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756913Ab2FOAAV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 20:00:21 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46571 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756895Ab2FOAAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 20:00:15 -0400
Message-Id: <20120614235626.284238506@linuxfoundation.org>
User-Agent: quilt/0.60-20.1
Date: Thu, 14 Jun 2012 16:56:50 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
        Johannes Berg <johannes.berg@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 27/42] cfg80211: fix interface combinations check
In-Reply-To: <20120614235636.GA5275@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/wireless/util.c |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -936,6 +936,7 @@ int cfg80211_can_change_interface(struct
 				  enum nl80211_iftype iftype)
 {
 	struct wireless_dev *wdev_iter;
+	u32 used_iftypes = BIT(iftype);
 	int num[NUM_NL80211_IFTYPES];
 	int total = 1;
 	int i, j;
@@ -969,12 +970,14 @@ int cfg80211_can_change_interface(struct
 
 		num[wdev_iter->iftype]++;
 		total++;
+		used_iftypes |= BIT(wdev_iter->iftype);
 	}
 	mutex_unlock(&rdev->devlist_mtx);
 
 	for (i = 0; i < rdev->wiphy.n_iface_combinations; i++) {
 		const struct ieee80211_iface_combination *c;
 		struct ieee80211_iface_limit *limits;
+		u32 all_iftypes = 0;
 
 		c = &rdev->wiphy.iface_combinations[i];
 
@@ -989,6 +992,7 @@ int cfg80211_can_change_interface(struct
 			if (rdev->wiphy.software_iftypes & BIT(iftype))
 				continue;
 			for (j = 0; j < c->n_limits; j++) {
+				all_iftypes |= limits[j].types;
 				if (!(limits[j].types & BIT(iftype)))
 					continue;
 				if (limits[j].max < num[iftype])
@@ -996,7 +1000,20 @@ int cfg80211_can_change_interface(struct
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


