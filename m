Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757490Ab0IRTfe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:35:34 -0400
Received: from kroah.org ([198.145.64.141]:43296 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756726Ab0IRTPB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:15:01 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:13:00 2010
Message-Id: <20100918191300.027424138@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 12:12:10 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Johannes Berg <johannes.berg@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [032/129] mac80211: delete work timer
In-Reply-To: <20100918191317.GA11386@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 071249b1d501b1f31a6b1af3fbcbe03158a84e5c upstream.

The new workqueue changes helped me find this bug
that's been lingering since the changes to the work
processing in mac80211 -- the work timer is never
deleted properly. Do that to avoid having it fire
after all data structures have been freed. It can't
be re-armed because all it will do, if running, is
schedule the work, but that gets flushed later and
won't have anything to do since all work items are
gone by now (by way of interface removal).

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/mac80211/main.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -659,6 +659,12 @@ void ieee80211_unregister_hw(struct ieee
 
 	rtnl_unlock();
 
+	/*
+	 * Now all work items will be gone, but the
+	 * timer might still be armed, so delete it
+	 */
+	del_timer_sync(&local->work_timer);
+
 	cancel_work_sync(&local->reconfig_filter);
 
 	ieee80211_clear_tx_pending(local);


