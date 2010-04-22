Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758699Ab0DVUmY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:42:24 -0400
Received: from kroah.org ([198.145.64.141]:37344 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756091Ab0DVT1y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:27:54 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:10 2010
Message-Id: <20100422190910.592643044@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:08:07 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Johannes Berg <johannes.berg@intel.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [036/197] mac80211: move netdev queue enabling to correct spot
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 7236fe29fd72d17074574ba312e7f1bb9d10abaa upstream.

"mac80211: fix skb buffering issue" still left a race
between enabling the hardware queues and the virtual
interface queues. In hindsight it's totally obvious
that enabling the netdev queues for a hardware queue
when the hardware queue is enabled is wrong, because
it could well possible that we can fill the hw queue
with packets we already have pending. Thus, we must
only enable the netdev queues once all the pending
packets have been processed and sent off to the device.

In testing, I haven't been able to trigger this race
condition, but it's clearly there, possibly only when
aggregation is being enabled.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/mac80211/tx.c   |    6 ++++++
 net/mac80211/util.c |   12 ++++++------
 2 files changed, 12 insertions(+), 6 deletions(-)

--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1881,6 +1881,7 @@ static bool ieee80211_tx_pending_skb(str
 void ieee80211_tx_pending(unsigned long data)
 {
 	struct ieee80211_local *local = (struct ieee80211_local *)data;
+	struct ieee80211_sub_if_data *sdata;
 	unsigned long flags;
 	int i;
 	bool txok;
@@ -1921,6 +1922,11 @@ void ieee80211_tx_pending(unsigned long
 			if (!txok)
 				break;
 		}
+
+		if (skb_queue_empty(&local->pending[i]))
+			list_for_each_entry_rcu(sdata, &local->interfaces, list)
+				netif_tx_wake_queue(
+					netdev_get_tx_queue(sdata->dev, i));
 	}
 	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
 
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -280,13 +280,13 @@ static void __ieee80211_wake_queue(struc
 		/* someone still has this queue stopped */
 		return;
 
-	if (!skb_queue_empty(&local->pending[queue]))
+	if (skb_queue_empty(&local->pending[queue])) {
+		rcu_read_lock();
+		list_for_each_entry_rcu(sdata, &local->interfaces, list)
+			netif_tx_wake_queue(netdev_get_tx_queue(sdata->dev, queue));
+		rcu_read_unlock();
+	} else
 		tasklet_schedule(&local->tx_pending_tasklet);
-
-	rcu_read_lock();
-	list_for_each_entry_rcu(sdata, &local->interfaces, list)
-		netif_tx_wake_queue(netdev_get_tx_queue(sdata->dev, queue));
-	rcu_read_unlock();
 }
 
 void ieee80211_wake_queue_by_reason(struct ieee80211_hw *hw, int queue,


