Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758494Ab0DVU31 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:29:27 -0400
Received: from kroah.org ([198.145.64.141]:59494 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757929Ab0DVT7v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:59:51 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:54:07 2010
Message-Id: <20100422195407.064611249@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:53:20 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Wey-Yi Guy <wey-yi.w.guy@intel.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [023/139] mac80211: tear down all agg queues when restart/reconfig hw
In-Reply-To: <20100422195715.GA25490@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

commit 74e2bd1fa3ae9695af566ad5a7a288898787b909 upstream.

When there is a need to restart/reconfig hw, tear down all the
aggregation queues and let the mac80211 and driver get in-sync to have
the opportunity to re-establish the aggregation queues again.

Need to wait until driver re-establish all the station information before tear
down the aggregation queues, driver(at least iwlwifi driver) will reject the
stop aggregation queue request if station is not ready. But also need to make
sure the aggregation queues are tear down before waking up the queues, so
mac80211 will not sending frames with aggregation bit set.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/mac80211/util.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1145,6 +1145,14 @@ int ieee80211_reconfig(struct ieee80211_
 		}
 	}
 
+	rcu_read_lock();
+	if (hw->flags & IEEE80211_HW_AMPDU_AGGREGATION) {
+		list_for_each_entry_rcu(sta, &local->sta_list, list) {
+			ieee80211_sta_tear_down_BA_sessions(sta);
+		}
+	}
+	rcu_read_unlock();
+
 	/* add back keys */
 	list_for_each_entry(sdata, &local->interfaces, list)
 		if (netif_running(sdata->dev))


