Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758140Ab1EANWo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 09:22:44 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:44575 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756313Ab1EANWa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 09:22:30 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 36/86] cgroup,rcu: convert call_rcu(__free_css_id_cb) to kfree_rcu()
Date: Sun,  1 May 2011 06:21:16 -0700
Message-Id: <1304256126-26015-36-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110501132142.GA25494@linux.vnet.ibm.com>
References: <20110501132142.GA25494@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

The rcu callback __free_css_id_cb() just calls a kfree(),
so we use kfree_rcu() instead of the call_rcu(__free_css_id_cb).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: Paul Menage <menage@google.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/cgroup.c |   10 +---------
 1 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 20451ce..909a355 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4610,14 +4610,6 @@ bool css_is_ancestor(struct cgroup_subsys_state *child,
 	return ret;
 }
 
-static void __free_css_id_cb(struct rcu_head *head)
-{
-	struct css_id *id;
-
-	id = container_of(head, struct css_id, rcu_head);
-	kfree(id);
-}
-
 void free_css_id(struct cgroup_subsys *ss, struct cgroup_subsys_state *css)
 {
 	struct css_id *id = css->id;
@@ -4632,7 +4624,7 @@ void free_css_id(struct cgroup_subsys *ss, struct cgroup_subsys_state *css)
 	spin_lock(&ss->id_lock);
 	idr_remove(&ss->idr, id->id);
 	spin_unlock(&ss->id_lock);
-	call_rcu(&id->rcu_head, __free_css_id_cb);
+	kfree_rcu(id, rcu_head);
 }
 EXPORT_SYMBOL_GPL(free_css_id);
 
-- 
1.7.3.2

