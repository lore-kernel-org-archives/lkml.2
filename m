Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422917Ab2CPOzb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 10:55:31 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45541 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422869Ab2CPOxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 10:53:33 -0400
Message-Id: <20120316144241.292638290@chello.nl>
User-Agent: quilt/0.48-1
Date: Fri, 16 Mar 2012 15:40:46 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Dan Smith <danms@us.ibm.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 18/26] srcu: revert2
References: <20120316144028.036474157@chello.nl>
Content-Disposition: inline; filename=srcu-revert-2.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    rcu: Add lockdep-RCU checks for simple self-deadlock

    It is illegal to have a grace period within a same-flavor RCU read-side
    critical section, so this commit adds lockdep-RCU checks to splat when
    such abuse is encountered.  This commit does not detect more elaborate
    RCU deadlock situations.  These situations might be a job for lockdep
    enhancements.

    Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/rcutiny.c        |    4 ----
 kernel/rcutiny_plugin.h |    5 -----
 kernel/rcutree.c        |    8 --------
 kernel/rcutree_plugin.h |    4 ----
 kernel/srcu.c           |    6 ------
 5 files changed, 27 deletions(-)

--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -329,10 +329,6 @@ static void rcu_process_callbacks(struct
  */
 void synchronize_sched(void)
 {
-	rcu_lockdep_assert(!lock_is_held(&rcu_bh_lock_map) &&
-			   !lock_is_held(&rcu_lock_map) &&
-			   !lock_is_held(&rcu_sched_lock_map),
-			   "Illegal synchronize_sched() in RCU read-side critical section");
 	cond_resched();
 }
 EXPORT_SYMBOL_GPL(synchronize_sched);
--- a/kernel/rcutiny_plugin.h
+++ b/kernel/rcutiny_plugin.h
@@ -735,11 +735,6 @@ EXPORT_SYMBOL_GPL(call_rcu);
  */
 void synchronize_rcu(void)
 {
-	rcu_lockdep_assert(!lock_is_held(&rcu_bh_lock_map) &&
-			   !lock_is_held(&rcu_lock_map) &&
-			   !lock_is_held(&rcu_sched_lock_map),
-			   "Illegal synchronize_rcu() in RCU read-side critical section");
-
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	if (!rcu_scheduler_active)
 		return;
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1919,10 +1919,6 @@ EXPORT_SYMBOL_GPL(call_rcu_bh);
  */
 void synchronize_sched(void)
 {
-	rcu_lockdep_assert(!lock_is_held(&rcu_bh_lock_map) &&
-			   !lock_is_held(&rcu_lock_map) &&
-			   !lock_is_held(&rcu_sched_lock_map),
-			   "Illegal synchronize_sched() in RCU-sched read-side critical section");
 	if (rcu_blocking_is_gp())
 		return;
 	wait_rcu_gp(call_rcu_sched);
@@ -1940,10 +1936,6 @@ EXPORT_SYMBOL_GPL(synchronize_sched);
  */
 void synchronize_rcu_bh(void)
 {
-	rcu_lockdep_assert(!lock_is_held(&rcu_bh_lock_map) &&
-			   !lock_is_held(&rcu_lock_map) &&
-			   !lock_is_held(&rcu_sched_lock_map),
-			   "Illegal synchronize_rcu_bh() in RCU-bh read-side critical section");
 	if (rcu_blocking_is_gp())
 		return;
 	wait_rcu_gp(call_rcu_bh);
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -731,10 +731,6 @@ EXPORT_SYMBOL_GPL(kfree_call_rcu);
  */
 void synchronize_rcu(void)
 {
-	rcu_lockdep_assert(!lock_is_held(&rcu_bh_lock_map) &&
-			   !lock_is_held(&rcu_lock_map) &&
-			   !lock_is_held(&rcu_sched_lock_map),
-			   "Illegal synchronize_rcu() in RCU read-side critical section");
 	if (!rcu_scheduler_active)
 		return;
 	wait_rcu_gp(call_rcu);
--- a/kernel/srcu.c
+++ b/kernel/srcu.c
@@ -172,12 +172,6 @@ static void __synchronize_srcu(struct sr
 {
 	int idx;
 
-	rcu_lockdep_assert(!lock_is_held(&sp->dep_map) &&
-			   !lock_is_held(&rcu_bh_lock_map) &&
-			   !lock_is_held(&rcu_lock_map) &&
-			   !lock_is_held(&rcu_sched_lock_map),
-			   "Illegal synchronize_srcu() in same-type SRCU (or RCU) read-side critical section");
-
 	idx = sp->completed;
 	mutex_lock(&sp->mutex);
 


