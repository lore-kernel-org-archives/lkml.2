Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056Ab1CYNXH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 09:23:07 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49180 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753025Ab1CYNXC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 09:23:02 -0400
Date: Fri, 25 Mar 2011 14:22:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler fixes
Message-ID: <20110325132247.GA18215@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-fixes-for-linus

 Thanks,

	Ingo

------------------>
Borislav Petkov (1):
      sched, doc: Update sched-design-CFS.txt

Jonathan Neuschäfer (1):
      sched.h: Fix a typo ("its")

Randy Dunlap (1):
      sched: Fix yield_to kernel-doc

Sergey Senozhatsky (1):
      sched: Remove unused 'rq' variable and cpu_rq() call from alloc_fair_sched_group()


 Documentation/scheduler/sched-design-CFS.txt |    7 +------
 include/linux/sched.h                        |    2 +-
 kernel/sched.c                               |    5 ++---
 kernel/sched_idletask.c                      |    2 --
 kernel/sched_stoptask.c                      |    2 --
 5 files changed, 4 insertions(+), 14 deletions(-)

diff --git a/Documentation/scheduler/sched-design-CFS.txt b/Documentation/scheduler/sched-design-CFS.txt
index 8239ebb..9996199 100644
--- a/Documentation/scheduler/sched-design-CFS.txt
+++ b/Documentation/scheduler/sched-design-CFS.txt
@@ -164,7 +164,7 @@ This is the (partial) list of the hooks:
    It puts the scheduling entity (task) into the red-black tree and
    increments the nr_running variable.
 
- - dequeue_tree(...)
+ - dequeue_task(...)
 
    When a task is no longer runnable, this function is called to keep the
    corresponding scheduling entity out of the red-black tree.  It decrements
@@ -195,11 +195,6 @@ This is the (partial) list of the hooks:
    This function is mostly called from time tick functions; it might lead to
    process switch.  This drives the running preemption.
 
- - task_new(...)
-
-   The core scheduler gives the scheduling module an opportunity to manage new
-   task startup.  The CFS scheduling module uses it for group scheduling, while
-   the scheduling module for a real-time task does not use it.
 
 
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index c15936f..e89f129 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -516,7 +516,7 @@ struct thread_group_cputimer {
 struct autogroup;
 
 /*
- * NOTE! "signal_struct" does not have it's own
+ * NOTE! "signal_struct" does not have its own
  * locking, because a shared signal_struct always
  * implies a shared sighand_struct, so locking
  * sighand_struct is always a proper superset of
diff --git a/kernel/sched.c b/kernel/sched.c
index 58d66ea..a361e20 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5467,6 +5467,8 @@ EXPORT_SYMBOL(yield);
  * yield_to - yield the current processor to another thread in
  * your thread group, or accelerate that thread toward the
  * processor it's on.
+ * @p: target task
+ * @preempt: whether task preemption is allowed or not
  *
  * It's the caller's job to ensure that the target task struct
  * can't go away on us before we can do any checks.
@@ -8441,7 +8443,6 @@ int alloc_fair_sched_group(struct task_group *tg, struct task_group *parent)
 {
 	struct cfs_rq *cfs_rq;
 	struct sched_entity *se;
-	struct rq *rq;
 	int i;
 
 	tg->cfs_rq = kzalloc(sizeof(cfs_rq) * nr_cpu_ids, GFP_KERNEL);
@@ -8454,8 +8455,6 @@ int alloc_fair_sched_group(struct task_group *tg, struct task_group *parent)
 	tg->shares = NICE_0_LOAD;
 
 	for_each_possible_cpu(i) {
-		rq = cpu_rq(i);
-
 		cfs_rq = kzalloc_node(sizeof(struct cfs_rq),
 				      GFP_KERNEL, cpu_to_node(i));
 		if (!cfs_rq)
diff --git a/kernel/sched_idletask.c b/kernel/sched_idletask.c
index c82f26c..a776a63 100644
--- a/kernel/sched_idletask.c
+++ b/kernel/sched_idletask.c
@@ -94,6 +94,4 @@ static const struct sched_class idle_sched_class = {
 
 	.prio_changed		= prio_changed_idle,
 	.switched_to		= switched_to_idle,
-
-	/* no .task_new for idle tasks */
 };
diff --git a/kernel/sched_stoptask.c b/kernel/sched_stoptask.c
index 84ec9bc..1ba2bd4 100644
--- a/kernel/sched_stoptask.c
+++ b/kernel/sched_stoptask.c
@@ -102,6 +102,4 @@ static const struct sched_class stop_sched_class = {
 
 	.prio_changed		= prio_changed_stop,
 	.switched_to		= switched_to_stop,
-
-	/* no .task_new for stop tasks */
 };
