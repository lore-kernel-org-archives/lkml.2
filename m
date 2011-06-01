Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161407Ab1FAIJb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:09:31 -0400
Received: from cantor.suse.de ([195.135.220.2]:43311 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161398Ab1FAIJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:09:28 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:03:01 2011
Message-Id: <20110601080301.167791767@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 16:59:32 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Johannes Berg <johannes.berg@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [036/146] mac80211: fix a few RCU issues
In-Reply-To: <20110601080606.GA522@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit a3836e02ba4c50db958d32d710b226f2408623dc upstream.

A few configuration functions correctly do
rcu_read_lock() but don't correctly reference
some pointers protected by RCU. Fix that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/mac80211/cfg.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -228,11 +228,11 @@ static int ieee80211_get_key(struct wiph
 			goto out;
 
 		if (pairwise)
-			key = sta->ptk;
+			key = rcu_dereference(sta->ptk);
 		else if (key_idx < NUM_DEFAULT_KEYS)
-			key = sta->gtk[key_idx];
+			key = rcu_dereference(sta->gtk[key_idx]);
 	} else
-		key = sdata->keys[key_idx];
+		key = rcu_dereference(sdata->keys[key_idx]);
 
 	if (!key)
 		goto out;
@@ -904,8 +904,10 @@ static int ieee80211_change_mpath(struct
 static void mpath_set_pinfo(struct mesh_path *mpath, u8 *next_hop,
 			    struct mpath_info *pinfo)
 {
-	if (mpath->next_hop)
-		memcpy(next_hop, mpath->next_hop->sta.addr, ETH_ALEN);
+	struct sta_info *next_hop_sta = rcu_dereference(mpath->next_hop);
+
+	if (next_hop_sta)
+		memcpy(next_hop, next_hop_sta->sta.addr, ETH_ALEN);
 	else
 		memset(next_hop, 0, ETH_ALEN);
 


