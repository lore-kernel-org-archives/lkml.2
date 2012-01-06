Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758656Ab2AFKX2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 05:23:28 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:34084 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758483Ab2AFKX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 05:23:26 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.4.0
Date: Fri, 06 Jan 2012 19:22:56 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [BUG] TASK_DEAD task is able to be woken up in special condition
Cc: Ingo Molnar <mingo@elte.hu>,
        Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>,
        Motohiro Kosaki <kosaki.motohiro@jp.fujitsu.com>,
        Linux Kernel ML <linux-kernel@vger.kernel.org>
In-Reply-To: <20111227154828.5120.E1E9C6FF@jp.fujitsu.com>
References: <20111226171151.GA4472@redhat.com> <20111227154828.5120.E1E9C6FF@jp.fujitsu.com>
Message-Id: <20120106192256.AB15.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I made a trial patch to change task state by cmpxchg to solve this problem.
Please comment.

I just confirmed booting up on my box, and I would like to get rough agreement
about this way to solve this issue at first.
If this way is roughly ok, I will test this patch more.

Thanks,

--------------------

try_to_wake_up() has a problem which may change status from TASK_DEAD to
TASK_RUNNING in race condition with SMI or guest environment of virtual
machine. (See: https://lkml.org/lkml/2011/12/21/523)
As a result, exited task is scheduled() again and panic occurs.

In addition, try_to_wake_up(TASK_INTERRUPTIBLE) can wakeup a
TASK_UNINTERRUPTIBLE task if it temporary sets INTERRUPTIBLE but
doesn't call schedule() in this state.

By this patch, kernel changes task state by cmpxchg when the task is
on run queue. If the task state does not fit required state,
kernel stops waking the task up.


Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>

---
 kernel/sched.c |   96 ++++++++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 79 insertions(+), 17 deletions(-)

Index: linux-3.2-rc7/kernel/sched.c
===================================================================
--- linux-3.2-rc7.orig/kernel/sched.c
+++ linux-3.2-rc7/kernel/sched.c
@@ -2650,16 +2650,31 @@ static void ttwu_activate(struct rq *rq,
 		wq_worker_waking_up(p, cpu_of(rq));
 }
 
-/*
- * Mark the task runnable and perform wakeup-preemption.
- */
-static void
-ttwu_do_wakeup(struct rq *rq, struct task_struct *p, int wake_flags)
+static int
+change_task_state_cmpxchg(struct task_struct *p, unsigned int target_state,
+			  unsigned int new)
 {
-	trace_sched_wakeup(p, true);
-	check_preempt_curr(rq, p, wake_flags);
+	unsigned int old, tmp;
 
-	p->state = TASK_RUNNING;
+	old = p->state;
+
+	while (1) {
+		if (old == new)
+			return 1;
+
+		if (unlikely(!(old & target_state)))
+			return 0;
+
+		tmp = cmpxchg(&p->state, old, new);
+		if (likely(tmp == old))
+			return 1;
+
+		old = tmp;
+	}
+}
+
+static void ttwu_do_woken(struct rq *rq, struct task_struct *p)
+{
 #ifdef CONFIG_SMP
 	if (p->sched_class->task_woken)
 		p->sched_class->task_woken(rq, p);
@@ -2677,6 +2692,45 @@ ttwu_do_wakeup(struct rq *rq, struct tas
 #endif
 }
 
+/*
+ * Mark the task runnable and perform wakeup-preemption.
+ */
+static void
+ttwu_do_wakeup(struct rq *rq, struct task_struct *p, int wake_flags)
+{
+	trace_sched_wakeup(p, true);
+	check_preempt_curr(rq, p, wake_flags);
+
+	p->state = TASK_RUNNING;
+
+	ttwu_do_woken(rq, p);
+}
+
+/*
+ * Mark the task runnable and perform wakeup-preemption with
+ * making sure the state of task. It might be changed due to
+ * race condition.
+ */
+static int
+ttwu_do_wakeup_state_check(struct rq *rq, struct task_struct *p,
+			   unsigned int target_state, int wake_flags)
+{
+	int ret;
+
+	ret = change_task_state_cmpxchg(p, target_state, TASK_RUNNING);
+	trace_sched_wakeup(p, ret);
+
+	/* faied to change state due to race? */
+	if (!ret)
+		return -EINVAL;
+
+	check_preempt_curr(rq, p, wake_flags);
+
+	ttwu_do_woken(rq, p);
+
+	return 1;
+}
+
 static void
 ttwu_do_activate(struct rq *rq, struct task_struct *p, int wake_flags)
 {
@@ -2695,16 +2749,16 @@ ttwu_do_activate(struct rq *rq, struct t
  * since all we need to do is flip p->state to TASK_RUNNING, since
  * the task is still ->on_rq.
  */
-static int ttwu_remote(struct task_struct *p, int wake_flags)
+static int
+ttwu_remote(struct task_struct *p, unsigned int state, int wake_flags)
 {
 	struct rq *rq;
 	int ret = 0;
 
 	rq = __task_rq_lock(p);
-	if (p->on_rq) {
-		ttwu_do_wakeup(rq, p, wake_flags);
-		ret = 1;
-	}
+	if (p->on_rq)
+		ret = ttwu_do_wakeup_state_check(rq, p, state, wake_flags);
+
 	__task_rq_unlock(rq);
 
 	return ret;
@@ -2766,7 +2820,8 @@ static void ttwu_queue_remote(struct tas
 }
 
 #ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
-static int ttwu_activate_remote(struct task_struct *p, int wake_flags)
+static int
+ttwu_activate_remote(struct task_struct *p, int wake_flags)
 {
 	struct rq *rq;
 	int ret = 0;
@@ -2828,11 +2883,18 @@ try_to_wake_up(struct task_struct *p, un
 	if (!(p->state & state))
 		goto out;
 
-	success = 1; /* we're going to change ->state */
 	cpu = task_cpu(p);
 
-	if (p->on_rq && ttwu_remote(p, wake_flags))
-		goto stat;
+	if (p->on_rq) {
+		int ret;
+		ret = ttwu_remote(p, state, wake_flags);
+		if (likely(ret == 1)) {
+			success = 1;
+			goto stat;
+		} else if (unlikely(ret < 0))
+			goto out;
+	}
+	success = 1; /* we're going to change ->state */
 
 #ifdef CONFIG_SMP
 	/*


-- 
Yasunori Goto 


