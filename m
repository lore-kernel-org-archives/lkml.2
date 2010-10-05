Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757473Ab0JEAD7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 20:03:59 -0400
Received: from smtp-out.google.com ([74.125.121.35]:32576 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283Ab0JEAD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 20:03:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=evYiKMGnRMSQImiBodaNPnNXPPddDoo3h18lok7i6dirzSl37wOgVU4UiR7FLrDqET
         pFb/BT7IU46lIaIv/3Pw==
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Venkatesh Pallipadi <venki@google.com>
Subject: [PATCH 3/8] Add a PF flag for ksoftirqd identification
Date: Mon,  4 Oct 2010 17:03:18 -0700
Message-Id: <1286237003-12406-4-git-send-email-venki@google.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1286237003-12406-1-git-send-email-venki@google.com>
References: <1286237003-12406-1-git-send-email-venki@google.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To account softirq time cleanly in scheduler, we need to identify whether
softirq is invoked in ksoftirqd context or softirq at hardirq tail context.
Add PF_KSOFTIRQD for that purpose.

As all PF flag bits are currently taken, create space by moving one of the
infrequently used bits (PF_THREAD_BOUND) down in task_struct to be along
with some other state fields.

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
---
 include/linux/sched.h |    3 ++-
 kernel/cpuset.c       |    2 +-
 kernel/kthread.c      |    2 +-
 kernel/sched.c        |    2 +-
 kernel/softirq.c      |    1 +
 kernel/workqueue.c    |    6 +++---
 6 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 126457e..43064cd 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1234,6 +1234,7 @@ struct task_struct {
 
 	/* Revert to default priority/policy when forking */
 	unsigned sched_reset_on_fork:1;
+	unsigned sched_thread_bound:1;	/* Thread bound to specific cpu */
 
 	pid_t pid;
 	pid_t tgid;
@@ -1708,7 +1709,7 @@ extern void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *
 #define PF_SWAPWRITE	0x00800000	/* Allowed to write to swap */
 #define PF_SPREAD_PAGE	0x01000000	/* Spread page cache over cpuset */
 #define PF_SPREAD_SLAB	0x02000000	/* Spread some slab caches over cpuset */
-#define PF_THREAD_BOUND	0x04000000	/* Thread bound to specific cpu */
+#define PF_KSOFTIRQD	0x04000000	/* I am ksoftirqd */
 #define PF_MCE_EARLY    0x08000000      /* Early kill for mce process policy */
 #define PF_MEMPOLICY	0x10000000	/* Non-default NUMA mempolicy */
 #define PF_MUTEX_TESTER	0x20000000	/* Thread belongs to the rt mutex tester */
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index b23c097..8a2eb02 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1394,7 +1394,7 @@ static int cpuset_can_attach(struct cgroup_subsys *ss, struct cgroup *cont,
 	 * set_cpus_allowed_ptr() on all attached tasks before cpus_allowed may
 	 * be changed.
 	 */
-	if (tsk->flags & PF_THREAD_BOUND)
+	if (tsk->sched_thread_bound)
 		return -EINVAL;
 
 	ret = security_task_setscheduler(tsk, 0, NULL);
diff --git a/kernel/kthread.c b/kernel/kthread.c
index 2dc3786..6b51a4c 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -185,7 +185,7 @@ void kthread_bind(struct task_struct *p, unsigned int cpu)
 
 	p->cpus_allowed = cpumask_of_cpu(cpu);
 	p->rt.nr_cpus_allowed = 1;
-	p->flags |= PF_THREAD_BOUND;
+	p->sched_thread_bound = 1;
 }
 EXPORT_SYMBOL(kthread_bind);
 
diff --git a/kernel/sched.c b/kernel/sched.c
index b6e714b..c13fae6 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5464,7 +5464,7 @@ again:
 		goto out;
 	}
 
-	if (unlikely((p->flags & PF_THREAD_BOUND) && p != current &&
+	if (unlikely(p->sched_thread_bound && p != current &&
 		     !cpumask_equal(&p->cpus_allowed, new_mask))) {
 		ret = -EINVAL;
 		goto out;
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 988dfbe..267f7b7 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -713,6 +713,7 @@ static int run_ksoftirqd(void * __bind_cpu)
 {
 	set_current_state(TASK_INTERRUPTIBLE);
 
+	current->flags |= PF_KSOFTIRQD;
 	while (!kthread_should_stop()) {
 		preempt_disable();
 		if (!local_softirq_pending()) {
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index f77afd9..7146ee6 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1340,12 +1340,12 @@ static struct worker *create_worker(struct global_cwq *gcwq, bool bind)
 	/*
 	 * A rogue worker will become a regular one if CPU comes
 	 * online later on.  Make sure every worker has
-	 * PF_THREAD_BOUND set.
+	 * sched_thread_bound set.
 	 */
 	if (bind && !on_unbound_cpu)
 		kthread_bind(worker->task, gcwq->cpu);
 	else {
-		worker->task->flags |= PF_THREAD_BOUND;
+		worker->task->sched_thread_bound = 1;
 		if (on_unbound_cpu)
 			worker->flags |= WORKER_UNBOUND;
 	}
@@ -2817,7 +2817,7 @@ struct workqueue_struct *__alloc_workqueue_key(const char *name,
 		if (IS_ERR(rescuer->task))
 			goto err;
 
-		rescuer->task->flags |= PF_THREAD_BOUND;
+		rescuer->task->sched_thread_bound = 1;
 		wake_up_process(rescuer->task);
 	}
 
-- 
1.7.1

