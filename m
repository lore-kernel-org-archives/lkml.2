Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481Ab2ACWg3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 17:36:29 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39545 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755442Ab2ACWgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:36:25 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan  3 14:30:32 2012
Message-Id: <20120103223032.235859136@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 03 Jan 2012 14:29:29 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Johannes Berg <johannes.berg@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [11/67] mac80211: fix another race in aggregation start
In-Reply-To: <20120103223043.GA26738@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 15062e6a8524f5977f2cbdf6e3eb2f144262f74e upstream.

Emmanuel noticed that when mac80211 stops the queues
for aggregation that can leave a packet pending. This
packet will be given to the driver after the AMPDU
callback, but as a non-aggregated packet which messes
up the sequence number etc.

I also noticed by looking at the code that if packets
are being processed while we clear the WANT_START bit,
they might see it cleared already and queue up on
tid_tx->pending. If the driver then rejects the new
aggregation session we leak the packet.

Fix both of these issues by changing this code to not
stop the queues at all. Instead, let packets queue up
on the tid_tx->pending queue instead of letting them
get to the driver, and add code to recover properly
in case the driver rejects the session.

(The patch looks large because it has to move two
functions to before their new use.)

Reported-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/mac80211/agg-tx.c |   86 +++++++++++++++++++++++---------------------------
 1 file changed, 41 insertions(+), 45 deletions(-)

--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -304,6 +304,38 @@ ieee80211_wake_queue_agg(struct ieee8021
 	__release(agg_queue);
 }
 
+/*
+ * splice packets from the STA's pending to the local pending,
+ * requires a call to ieee80211_agg_splice_finish later
+ */
+static void __acquires(agg_queue)
+ieee80211_agg_splice_packets(struct ieee80211_local *local,
+			     struct tid_ampdu_tx *tid_tx, u16 tid)
+{
+	int queue = ieee80211_ac_from_tid(tid);
+	unsigned long flags;
+
+	ieee80211_stop_queue_agg(local, tid);
+
+	if (WARN(!tid_tx, "TID %d gone but expected when splicing aggregates"
+			  " from the pending queue\n", tid))
+		return;
+
+	if (!skb_queue_empty(&tid_tx->pending)) {
+		spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
+		/* copy over remaining packets */
+		skb_queue_splice_tail_init(&tid_tx->pending,
+					   &local->pending[queue]);
+		spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
+	}
+}
+
+static void __releases(agg_queue)
+ieee80211_agg_splice_finish(struct ieee80211_local *local, u16 tid)
+{
+	ieee80211_wake_queue_agg(local, tid);
+}
+
 void ieee80211_tx_ba_session_handle_start(struct sta_info *sta, int tid)
 {
 	struct tid_ampdu_tx *tid_tx;
@@ -315,19 +347,17 @@ void ieee80211_tx_ba_session_handle_star
 	tid_tx = rcu_dereference_protected_tid_tx(sta, tid);
 
 	/*
-	 * While we're asking the driver about the aggregation,
-	 * stop the AC queue so that we don't have to worry
-	 * about frames that came in while we were doing that,
-	 * which would require us to put them to the AC pending
-	 * afterwards which just makes the code more complex.
+	 * Start queuing up packets for this aggregation session.
+	 * We're going to release them once the driver is OK with
+	 * that.
 	 */
-	ieee80211_stop_queue_agg(local, tid);
-
 	clear_bit(HT_AGG_STATE_WANT_START, &tid_tx->state);
 
 	/*
-	 * make sure no packets are being processed to get
-	 * valid starting sequence number
+	 * Make sure no packets are being processed. This ensures that
+	 * we have a valid starting sequence number and that in-flight
+	 * packets have been flushed out and no packets for this TID
+	 * will go into the driver during the ampdu_action call.
 	 */
 	synchronize_net();
 
@@ -341,17 +371,15 @@ void ieee80211_tx_ba_session_handle_star
 					" tid %d\n", tid);
 #endif
 		spin_lock_bh(&sta->lock);
+		ieee80211_agg_splice_packets(local, tid_tx, tid);
 		ieee80211_assign_tid_tx(sta, tid, NULL);
+		ieee80211_agg_splice_finish(local, tid);
 		spin_unlock_bh(&sta->lock);
 
-		ieee80211_wake_queue_agg(local, tid);
 		kfree_rcu(tid_tx, rcu_head);
 		return;
 	}
 
-	/* we can take packets again now */
-	ieee80211_wake_queue_agg(local, tid);
-
 	/* activate the timer for the recipient's addBA response */
 	mod_timer(&tid_tx->addba_resp_timer, jiffies + ADDBA_RESP_INTERVAL);
 #ifdef CONFIG_MAC80211_HT_DEBUG
@@ -471,38 +499,6 @@ int ieee80211_start_tx_ba_session(struct
 }
 EXPORT_SYMBOL(ieee80211_start_tx_ba_session);
 
-/*
- * splice packets from the STA's pending to the local pending,
- * requires a call to ieee80211_agg_splice_finish later
- */
-static void __acquires(agg_queue)
-ieee80211_agg_splice_packets(struct ieee80211_local *local,
-			     struct tid_ampdu_tx *tid_tx, u16 tid)
-{
-	int queue = ieee80211_ac_from_tid(tid);
-	unsigned long flags;
-
-	ieee80211_stop_queue_agg(local, tid);
-
-	if (WARN(!tid_tx, "TID %d gone but expected when splicing aggregates"
-			  " from the pending queue\n", tid))
-		return;
-
-	if (!skb_queue_empty(&tid_tx->pending)) {
-		spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
-		/* copy over remaining packets */
-		skb_queue_splice_tail_init(&tid_tx->pending,
-					   &local->pending[queue]);
-		spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
-	}
-}
-
-static void __releases(agg_queue)
-ieee80211_agg_splice_finish(struct ieee80211_local *local, u16 tid)
-{
-	ieee80211_wake_queue_agg(local, tid);
-}
-
 static void ieee80211_agg_tx_operational(struct ieee80211_local *local,
 					 struct sta_info *sta, u16 tid)
 {


