Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755160Ab1EFAPr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:15:47 -0400
Received: from kroah.org ([198.145.64.141]:32931 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754866Ab1EFANf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:13:35 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:12:10 2011
Message-Id: <20110506001210.154922389@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:11:01 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Johannes Berg <johannes.berg@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 29/38] mac80211: fix SMPS debugfs locking
In-Reply-To: <20110506001225.GA10547@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 243e6df4ed919880d079d717641ad699c6530a03 upstream.

The locking with SMPS requests means that the
debugs file should lock the mgd mutex, not the
iflist mutex. Calls to __ieee80211_request_smps()
need to hold that mutex, so add an assertion.

This has always been wrong, but for some reason
never been noticed, probably because the locking
error only happens while unassociated.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/mac80211/cfg.c            |    2 ++
 net/mac80211/debugfs_netdev.c |    4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1471,6 +1471,8 @@ int __ieee80211_request_smps(struct ieee
 	enum ieee80211_smps_mode old_req;
 	int err;
 
+	lockdep_assert_held(&sdata->u.mgd.mtx);
+
 	old_req = sdata->u.mgd.req_smps;
 	sdata->u.mgd.req_smps = smps_mode;
 
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -172,9 +172,9 @@ static int ieee80211_set_smps(struct iee
 	if (sdata->vif.type != NL80211_IFTYPE_STATION)
 		return -EOPNOTSUPP;
 
-	mutex_lock(&local->iflist_mtx);
+	mutex_lock(&sdata->u.mgd.mtx);
 	err = __ieee80211_request_smps(sdata, smps_mode);
-	mutex_unlock(&local->iflist_mtx);
+	mutex_unlock(&sdata->u.mgd.mtx);
 
 	return err;
 }


