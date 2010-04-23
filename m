Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756277Ab0DWTnu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 15:43:50 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:59560 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756069Ab0DWTnh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 15:43:37 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH v2.6.34-rc5 12/12] memcg: css_id() must be called under rcu_read_lock()
Date: Fri, 23 Apr 2010 12:43:30 -0700
Message-Id: <1272051810-11249-12-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <20100423194255.GE2589@linux.vnet.ibm.com>
References: <20100423194255.GE2589@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes task_in_mem_cgroup(), mem_cgroup_uncharge_swapcache(),
mem_cgroup_move_swap_account(), and is_target_pte_for_mc() to protect
calls to css_id().  An additional RCU lockdep splat was reported for
memcg_oom_wake_function(), however, this function is not yet in
mainline as of 2.6.34-rc5.

Reported-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Tested-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 mm/memcontrol.c |   21 ++++++++++++++++-----
 1 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index f4ede99..e06490d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -811,10 +811,12 @@ int task_in_mem_cgroup(struct task_struct *task, const struct mem_cgroup *mem)
 	 * enabled in "curr" and "curr" is a child of "mem" in *cgroup*
 	 * hierarchy(even if use_hierarchy is disabled in "mem").
 	 */
+	rcu_read_lock();
 	if (mem->use_hierarchy)
 		ret = css_is_ancestor(&curr->css, &mem->css);
 	else
 		ret = (curr == mem);
+	rcu_read_unlock();
 	css_put(&curr->css);
 	return ret;
 }
@@ -2312,7 +2314,9 @@ mem_cgroup_uncharge_swapcache(struct page *page, swp_entry_t ent, bool swapout)
 
 	/* record memcg information */
 	if (do_swap_account && swapout && memcg) {
+		rcu_read_lock();
 		swap_cgroup_record(ent, css_id(&memcg->css));
+		rcu_read_unlock();
 		mem_cgroup_get(memcg);
 	}
 	if (swapout && memcg)
@@ -2369,8 +2373,10 @@ static int mem_cgroup_move_swap_account(swp_entry_t entry,
 {
 	unsigned short old_id, new_id;
 
+	rcu_read_lock();
 	old_id = css_id(&from->css);
 	new_id = css_id(&to->css);
+	rcu_read_unlock();
 
 	if (swap_cgroup_cmpxchg(entry, old_id, new_id) == old_id) {
 		mem_cgroup_swap_statistics(from, false);
@@ -4038,11 +4044,16 @@ static int is_target_pte_for_mc(struct vm_area_struct *vma,
 			put_page(page);
 	}
 	/* throught */
-	if (ent.val && do_swap_account && !ret &&
-			css_id(&mc.from->css) == lookup_swap_cgroup(ent)) {
-		ret = MC_TARGET_SWAP;
-		if (target)
-			target->ent = ent;
+	if (ent.val && do_swap_account && !ret) {
+		unsigned short id;
+		rcu_read_lock();
+		id = css_id(&mc.from->css);
+		rcu_read_unlock();
+		if (id == lookup_swap_cgroup(ent)) {
+			ret = MC_TARGET_SWAP;
+			if (target)
+				target->ent = ent;
+		}
 	}
 	return ret;
 }
-- 
1.7.0

