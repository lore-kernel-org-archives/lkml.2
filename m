Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271Ab0EJFvh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 01:51:37 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51990 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773Ab0EJFvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 01:51:35 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 10 May 2010 14:46:53 +0900
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
Subject: [BUGFIX][PATCH 1/2]  cgroup/cssid/memcg rcu fixes. (Was Re: [PATCH
 tip/core/urgent 08/10] memcg: css_id() must be called under rcu_read_lock()
Message-Id: <20100510144653.4dfabbc8.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100510091726.f9a0642f.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100503185253.GA17672@linux.vnet.ibm.com>
	<1272912799-17859-8-git-send-email-paulmck@linux.vnet.ibm.com>
	<20100507121138.cc37dbe4.akpm@linux-foundation.org>
	<20100510091726.f9a0642f.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Sorry for my lack of study...maybe this is an acceptable one.
This patch fixes css_id's RCU check and revert a patch already merged.
This is based on linux-2.6.34-rc7.

-Kame
==
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Commit ad4ba375373937817404fd92239ef4cadbded23b modifies memcontol.c
for fixing RCU check message. But Andrew Morton pointed out that
the fix doesn't seems sane and it was just for hidining lockdep
messages.

This is a patch for do proper things. Checking again, all places, accessing
without rcu_read_lock, that commit fixies was intentional....
all callers of css_id() has reference count on it. 
So, it's not necessary to be under rcu_read_lock().

Considering again, we can use rcu_dereference_check for css_id().
We know css->id is valid if css->refcnt > 0.
(css->id never changes and freed after css->refcnt going to be 0.)

This patch makes use of rcu_dereference_check() in css_id/depth and
remove unnecessary rcu-read-lock added by the commit.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 kernel/cgroup.c |   15 +++++++++++++--
 mm/memcontrol.c |   19 +++++--------------
 2 files changed, 18 insertions(+), 16 deletions(-)

Index: linux-2.6.34-rc7/kernel/cgroup.c
===================================================================
--- linux-2.6.34-rc7.orig/kernel/cgroup.c
+++ linux-2.6.34-rc7/kernel/cgroup.c
@@ -4435,7 +4435,15 @@ __setup("cgroup_disable=", cgroup_disabl
  */
 unsigned short css_id(struct cgroup_subsys_state *css)
 {
-	struct css_id *cssid = rcu_dereference(css->id);
+	struct css_id *cssid;
+
+	/*
+	 * This css_id() can return correct value when somone has refcnt
+	 * on this or this is under rcu_read_lock(). Once css->id is allocated,
+	 * it's unchanged until freed.
+	 */
+	cssid = rcu_dereference_check(css->id,
+			rcu_read_lock_held() || atomic_read(&css->refcnt));
 
 	if (cssid)
 		return cssid->id;
@@ -4445,7 +4453,10 @@ EXPORT_SYMBOL_GPL(css_id);
 
 unsigned short css_depth(struct cgroup_subsys_state *css)
 {
-	struct css_id *cssid = rcu_dereference(css->id);
+	struct css_id *cssid;
+
+	cssid = rcu_dereference_check(css->id,
+			rcu_read_lock_held() || atomic_read(&css->refcnt));
 
 	if (cssid)
 		return cssid->depth;
Index: linux-2.6.34-rc7/mm/memcontrol.c
===================================================================
--- linux-2.6.34-rc7.orig/mm/memcontrol.c
+++ linux-2.6.34-rc7/mm/memcontrol.c
@@ -2314,9 +2314,7 @@ mem_cgroup_uncharge_swapcache(struct pag
 
 	/* record memcg information */
 	if (do_swap_account && swapout && memcg) {
-		rcu_read_lock();
 		swap_cgroup_record(ent, css_id(&memcg->css));
-		rcu_read_unlock();
 		mem_cgroup_get(memcg);
 	}
 	if (swapout && memcg)
@@ -2373,10 +2371,8 @@ static int mem_cgroup_move_swap_account(
 {
 	unsigned short old_id, new_id;
 
-	rcu_read_lock();
 	old_id = css_id(&from->css);
 	new_id = css_id(&to->css);
-	rcu_read_unlock();
 
 	if (swap_cgroup_cmpxchg(entry, old_id, new_id) == old_id) {
 		mem_cgroup_swap_statistics(from, false);
@@ -4044,16 +4040,11 @@ static int is_target_pte_for_mc(struct v
 			put_page(page);
 	}
 	/* throught */
-	if (ent.val && do_swap_account && !ret) {
-		unsigned short id;
-		rcu_read_lock();
-		id = css_id(&mc.from->css);
-		rcu_read_unlock();
-		if (id == lookup_swap_cgroup(ent)) {
-			ret = MC_TARGET_SWAP;
-			if (target)
-				target->ent = ent;
-		}
+	if (ent.val && do_swap_account && !ret &&
+			css_id(&mc.from->css) == lookup_swap_cgroup(ent)) {
+		ret = MC_TARGET_SWAP;
+		if (target)
+			target->ent = ent;
 	}
 	return ret;
 }

