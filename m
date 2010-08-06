Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965139Ab0HFTLo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 15:11:44 -0400
Received: from kroah.org ([198.145.64.141]:58586 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965097Ab0HFTAS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 15:00:18 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Aug  6 11:58:35 2010
Message-Id: <20100806185835.644376474@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 06 Aug 2010 11:57:15 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Johannes Berg <johannes.berg@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [20/34] cfg80211: dont get expired BSSes
In-Reply-To: <20100806185853.GA28270@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit ccb6c1360f8dd43303c659db718e7e0b24175db5 upstream.

When kernel-internal users use cfg80211_get_bss()
to get a reference to a BSS struct, they may end
up getting one that would have been removed from
the list if there had been any userspace access
to the list. This leads to inconsistencies and
problems.

Fix it by making cfg80211_get_bss() ignore BSSes
that cfg80211_bss_expire() would remove.

Fixes http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2180

Reported-by: Jiajia Zheng <jiajia.zheng@intel.com>
Tested-by: Jiajia Zheng <jiajia.zheng@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/wireless/scan.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -270,6 +270,7 @@ struct cfg80211_bss *cfg80211_get_bss(st
 {
 	struct cfg80211_registered_device *dev = wiphy_to_dev(wiphy);
 	struct cfg80211_internal_bss *bss, *res = NULL;
+	unsigned long now = jiffies;
 
 	spin_lock_bh(&dev->bss_lock);
 
@@ -278,6 +279,10 @@ struct cfg80211_bss *cfg80211_get_bss(st
 			continue;
 		if (channel && bss->pub.channel != channel)
 			continue;
+		/* Don't get expired BSS structs */
+		if (time_after(now, bss->ts + IEEE80211_SCAN_RESULT_EXPIRE) &&
+		    !atomic_read(&bss->hold))
+			continue;
 		if (is_bss(&bss->pub, bssid, ssid, ssid_len)) {
 			res = bss;
 			kref_get(&res->ref);


