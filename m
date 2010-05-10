Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413Ab0EJFwl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 01:52:41 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52051 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942Ab0EJFwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 01:52:39 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 10 May 2010 14:48:26 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: [BUGFIX][PATCH 2/2]  cgroup/cssid/memcg rcu fixes. (Was Re: [PATCH
 tip/core/urgent 08/10] memcg: css_id() must be called under rcu_read_lock()
Message-Id: <20100510144826.fbe7875f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100510144653.4dfabbc8.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100503185253.GA17672@linux.vnet.ibm.com>
	<1272912799-17859-8-git-send-email-paulmck@linux.vnet.ibm.com>
	<20100507121138.cc37dbe4.akpm@linux-foundation.org>
	<20100510091726.f9a0642f.kamezawa.hiroyu@jp.fujitsu.com>
	<20100510144653.4dfabbc8.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Some callers (in memcontrol.c) calls css_is_ancestor() without
rcu_read_lock. Because css_is_ancestor() has to access RCU protected
data, it should be under rcu_read_lock().

This makes css_is_ancestor() itself does safe access to RCU protected
area. (At least, "root" can have refcnt==0 if it's not an ancestor of
"child". So, we need rcu_read_lock().)

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 kernel/cgroup.c |   31 ++++++++++++++++++++++++++-----
 mm/memcontrol.c |    4 ----
 2 files changed, 26 insertions(+), 9 deletions(-)

Index: linux-2.6.34-rc7/kernel/cgroup.c
===================================================================
--- linux-2.6.34-rc7.orig/kernel/cgroup.c
+++ linux-2.6.34-rc7/kernel/cgroup.c
@@ -4464,15 +4464,36 @@ unsigned short css_depth(struct cgroup_s
 }
 EXPORT_SYMBOL_GPL(css_depth);
 
+/**
+ *  css_is_ancestor - test "root" css is an ancestor of "child"
+ * @child: the css to be tested.
+ * @root: the css supporsed to be an ancestor of the child.
+ *
+ * Returns true if "root" is an ancestor of "child" in its hierarchy. Because
+ * this function reads css->id, this use rcu_dereference() and rcu_read_lock().
+ * But, considering usual usage, the csses should be valid objects after test.
+ * Assuming that the caller will do some action to the child if this returns
+ * returns true, the caller must take "child";s reference count.
+ * If "child" is valid object and this returns true, "root" is valid, too.
+ */
+
 bool css_is_ancestor(struct cgroup_subsys_state *child,
 		    const struct cgroup_subsys_state *root)
 {
-	struct css_id *child_id = rcu_dereference(child->id);
-	struct css_id *root_id = rcu_dereference(root->id);
+	struct css_id *child_id;
+	struct css_id *root_id;
+	bool ret = true;
 
-	if (!child_id || !root_id || (child_id->depth < root_id->depth))
-		return false;
-	return child_id->stack[root_id->depth] == root_id->id;
+	rcu_read_lock();
+	child_id  = rcu_dereference(child->id);
+	root_id = rcu_dereference(root->id);
+	if (!child_id
+	    || !root_id
+	    || (child_id->depth < root_id->depth)
+	    || (child_id->stack[root_id->depth] != root_id->id))
+		ret = false;
+	rcu_read_unlock();
+	return ret;
 }
 
 static void __free_css_id_cb(struct rcu_head *head)
Index: linux-2.6.34-rc7/mm/memcontrol.c
===================================================================
--- linux-2.6.34-rc7.orig/mm/memcontrol.c
+++ linux-2.6.34-rc7/mm/memcontrol.c
@@ -811,12 +811,10 @@ int task_in_mem_cgroup(struct task_struc
 	 * enabled in "curr" and "curr" is a child of "mem" in *cgroup*
 	 * hierarchy(even if use_hierarchy is disabled in "mem").
 	 */
-	rcu_read_lock();
 	if (mem->use_hierarchy)
 		ret = css_is_ancestor(&curr->css, &mem->css);
 	else
 		ret = (curr == mem);
-	rcu_read_unlock();
 	css_put(&curr->css);
 	return ret;
 }
@@ -1603,7 +1601,6 @@ static int __mem_cgroup_try_charge(struc
 			 * There is a small race that "from" or "to" can be
 			 * freed by rmdir, so we use css_tryget().
 			 */
-			rcu_read_lock();
 			from = mc.from;
 			to = mc.to;
 			if (from && css_tryget(&from->css)) {
@@ -1624,7 +1621,6 @@ static int __mem_cgroup_try_charge(struc
 					do_continue = (to == mem_over_limit);
 				css_put(&to->css);
 			}
-			rcu_read_unlock();
 			if (do_continue) {
 				DEFINE_WAIT(wait);
 				prepare_to_wait(&mc.waitq, &wait,

