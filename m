Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666Ab2BATso (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 14:48:44 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:60437 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932261Ab2BATsl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 14:48:41 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 03/41] rcu: Add lockdep-RCU checks for simple self-deadlock
Date: Wed,  1 Feb 2012 11:41:21 -0800
Message-Id: <1328125319-5205-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120201194131.GA10028@linux.vnet.ibm.com>
 <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020119-8974-0000-0000-000005C72D87
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

It is illegal to have a grace period within a same-flavor RCU read-side
critical section, so this commit adds lockdep-RCU checks to splat when
such abuse is encountered.  This commit does not detect more elaborate
RCU deadlock situations.  These situations might be a job for lockdep
enhancements.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutiny.c        |    3 +++
 kernel/rcutiny_plugin.h |    4 ++++
 kernel/rcutree.c        |    6 ++++++
 kernel/rcutree_plugin.h |    3 +++
 kernel/srcu.c           |    4 ++++
 5 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index 977296d..904cda9 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -319,6 +319,9 @@ static void rcu_process_callbacks(struct softirq_action *unused)
  */
 void synchronize_sched(void)
 {
+	rcu_lockdep_assert(!lock_is_held(&rcu_sched_lock_map),
+			   "Illegal grace period in RCU read-side "
+			   "critical section");
 	cond_resched();
 }
 EXPORT_SYMBOL_GPL(synchronize_sched);
diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
index 9cb1ae4..dd672e7 100644
--- a/kernel/rcutiny_plugin.h
+++ b/kernel/rcutiny_plugin.h
@@ -706,6 +706,10 @@ EXPORT_SYMBOL_GPL(call_rcu);
  */
 void synchronize_rcu(void)
 {
+	rcu_lockdep_assert(!lock_is_held(&rcu_lock_map),
+			   "Illegal synchronize_rcu() in RCU read-side "
+			   "critical section");
+
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	if (!rcu_scheduler_active)
 		return;
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 6c4a672..d0f8e64 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1816,6 +1816,9 @@ EXPORT_SYMBOL_GPL(call_rcu_bh);
  */
 void synchronize_sched(void)
 {
+	rcu_lockdep_assert(!lock_is_held(&rcu_sched_lock_map),
+			   "Illegal synchronize_sched() in RCU-sched "
+			   "read-side critical section");
 	if (rcu_blocking_is_gp())
 		return;
 	wait_rcu_gp(call_rcu_sched);
@@ -1833,6 +1836,9 @@ EXPORT_SYMBOL_GPL(synchronize_sched);
  */
 void synchronize_rcu_bh(void)
 {
+	rcu_lockdep_assert(!lock_is_held(&rcu_bh_lock_map),
+			   "Illegal synchronize_sched() in RCU-bh "
+			   "read-side critical section");
 	if (rcu_blocking_is_gp())
 		return;
 	wait_rcu_gp(call_rcu_bh);
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 8bb35d7..cc07bce 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -688,6 +688,9 @@ EXPORT_SYMBOL_GPL(call_rcu);
  */
 void synchronize_rcu(void)
 {
+	rcu_lockdep_assert(!lock_is_held(&rcu_lock_map),
+			   "Illegal synchronize_rcu() in RCU read-side "
+			   "critical section");
 	if (!rcu_scheduler_active)
 		return;
 	wait_rcu_gp(call_rcu);
diff --git a/kernel/srcu.c b/kernel/srcu.c
index 0febf61..1959763 100644
--- a/kernel/srcu.c
+++ b/kernel/srcu.c
@@ -172,6 +172,10 @@ static void __synchronize_srcu(struct srcu_struct *sp, void (*sync_func)(void))
 {
 	int idx;
 
+	rcu_lockdep_assert(!lock_is_held(&sp->dep_map),
+			   "Illegal SRCU grace period in same-type "
+			   "SRCU read-side critical section");
+
 	idx = sp->completed;
 	mutex_lock(&sp->mutex);
 
-- 
1.7.8

