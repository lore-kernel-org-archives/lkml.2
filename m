Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760077Ab1EANZ2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 09:25:28 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:53977 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754653Ab1EANWk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 09:22:40 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH tip/core/rcu 71/86] net,rcu: convert call_rcu(kfree_tid_tx) to kfree_rcu()
Date: Sun,  1 May 2011 06:21:51 -0700
Message-Id: <1304256126-26015-71-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110501132142.GA25494@linux.vnet.ibm.com>
References: <20110501132142.GA25494@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

The rcu callback kfree_tid_tx() just calls a kfree(),
so we use kfree_rcu() instead of the call_rcu(kfree_tid_tx).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: "David S. Miller" <davem@davemloft.net>
---
 net/mac80211/agg-tx.c |   14 +++-----------
 1 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index 63d852c..53defaf 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -136,14 +136,6 @@ void ieee80211_send_bar(struct ieee80211_sub_if_data *sdata, u8 *ra, u16 tid, u1
 	ieee80211_tx_skb(sdata, skb);
 }
 
-static void kfree_tid_tx(struct rcu_head *rcu_head)
-{
-	struct tid_ampdu_tx *tid_tx =
-	    container_of(rcu_head, struct tid_ampdu_tx, rcu_head);
-
-	kfree(tid_tx);
-}
-
 int ___ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
 				    enum ieee80211_back_parties initiator,
 				    bool tx)
@@ -163,7 +155,7 @@ int ___ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
 		/* not even started yet! */
 		rcu_assign_pointer(sta->ampdu_mlme.tid_tx[tid], NULL);
 		spin_unlock_bh(&sta->lock);
-		call_rcu(&tid_tx->rcu_head, kfree_tid_tx);
+		kfree_rcu(tid_tx, rcu_head);
 		return 0;
 	}
 
@@ -322,7 +314,7 @@ void ieee80211_tx_ba_session_handle_start(struct sta_info *sta, int tid)
 		spin_unlock_bh(&sta->lock);
 
 		ieee80211_wake_queue_agg(local, tid);
-		call_rcu(&tid_tx->rcu_head, kfree_tid_tx);
+		kfree_rcu(tid_tx, rcu_head);
 		return;
 	}
 
@@ -701,7 +693,7 @@ void ieee80211_stop_tx_ba_cb(struct ieee80211_vif *vif, u8 *ra, u8 tid)
 
 	ieee80211_agg_splice_finish(local, tid);
 
-	call_rcu(&tid_tx->rcu_head, kfree_tid_tx);
+	kfree_rcu(tid_tx, rcu_head);
 
  unlock_sta:
 	spin_unlock_bh(&sta->lock);
-- 
1.7.3.2

