Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932292Ab2BATna (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 14:43:30 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:50713 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756759Ab2BATnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 14:43:24 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH RFC tip/core/rcu 11/41] mac80211: Convert call_rcu() to kfree_rcu()
Date: Wed,  1 Feb 2012 11:41:29 -0800
Message-Id: <1328125319-5205-11-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120201194131.GA10028@linux.vnet.ibm.com>
 <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020119-2398-0000-0000-000003DD0DF2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

The call_rcu() in mesh_gate_del() invokes mesh_gate_node_reclaim(),
which simply calls kfree().  So convert the call_rcu() to kfree_rcu(),
allowing mesh_gate_node_reclaim() to be eliminated.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
---
 net/mac80211/mesh_pathtbl.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index edf167e..30420bc 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -413,12 +413,6 @@ struct mesh_path *mesh_path_lookup_by_idx(int idx, struct ieee80211_sub_if_data
 	return NULL;
 }
 
-static void mesh_gate_node_reclaim(struct rcu_head *rp)
-{
-	struct mpath_node *node = container_of(rp, struct mpath_node, rcu);
-	kfree(node);
-}
-
 /**
  * mesh_path_add_gate - add the given mpath to a mesh gate to our path table
  * @mpath: gate path to add to table
@@ -479,7 +473,7 @@ static int mesh_gate_del(struct mesh_table *tbl, struct mesh_path *mpath)
 		if (gate->mpath == mpath) {
 			spin_lock_bh(&tbl->gates_lock);
 			hlist_del_rcu(&gate->list);
-			call_rcu(&gate->rcu, mesh_gate_node_reclaim);
+			kfree_rcu(gate, rcu);
 			spin_unlock_bh(&tbl->gates_lock);
 			mpath->sdata->u.mesh.num_gates--;
 			mpath->is_gate = false;
-- 
1.7.8

