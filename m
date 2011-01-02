Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550Ab1ABHXE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:23:04 -0500
Received: from mail.windriver.com ([147.11.1.11]:35182 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753490Ab1ABHW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:22:56 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 085/260] sched: sched_exec(): Remove the select_fallback_rq() logic
Date: Sun,  2 Jan 2011 02:16:21 -0500
Message-Id: <1293952756-15010-86-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:21:42.0883 (UTC) FILETIME=[B4918330:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

commit 30da688ef6b76e01969b00608202fff1eed2accc upstream.

sched_exec()->select_task_rq() reads/updates ->cpus_allowed lockless.
This can race with other CPUs updating our ->cpus_allowed, and this
looks meaningless to me.

The task is current and running, it must have online cpus in ->cpus_allowed,
the fallback mode is bogus. And, if ->sched_class returns the "wrong" cpu,
this likely means we raced with set_cpus_allowed() which was called
for reason, why should sched_exec() retry and call ->select_task_rq()
again?

Change the code to call sched_class->select_task_rq() directly and do
nothing if the returned cpu is wrong after re-checking under rq->lock.

>From now task_struct->cpus_allowed is always stable under TASK_WAKING,
select_fallback_rq() is always called under rq-lock or the caller or
the caller owns TASK_WAKING (select_task_rq).

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20100315091019.GA9141@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 kernel/sched.c |   25 ++++++++-----------------
 1 files changed, 8 insertions(+), 17 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 59ef8a1..5ec7687 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2286,6 +2286,9 @@ void task_oncpu_function_call(struct task_struct *p,
 }
 
 #ifdef CONFIG_SMP
+/*
+ * ->cpus_allowed is protected by either TASK_WAKING or rq->lock held.
+ */
 static int select_fallback_rq(int cpu, struct task_struct *p)
 {
 	int dest_cpu;
@@ -2322,12 +2325,7 @@ static int select_fallback_rq(int cpu, struct task_struct *p)
 }
 
 /*
- * Gets called from 3 sites (exec, fork, wakeup), since it is called without
- * holding rq->lock we need to ensure ->cpus_allowed is stable, this is done
- * by:
- *
- *  exec:           is unstable, retry loop
- *  fork & wake-up: serialize ->cpus_allowed against TASK_WAKING
+ * The caller (fork, wakeup) owns TASK_WAKING, ->cpus_allowed is stable.
  */
 static inline
 int select_task_rq(struct task_struct *p, int sd_flags, int wake_flags)
@@ -3137,9 +3135,8 @@ void sched_exec(void)
 	unsigned long flags;
 	struct rq *rq;
 
-again:
 	this_cpu = get_cpu();
-	dest_cpu = select_task_rq(p, SD_BALANCE_EXEC, 0);
+	dest_cpu = p->sched_class->select_task_rq(p, SD_BALANCE_EXEC, 0);
 	if (dest_cpu == this_cpu) {
 		put_cpu();
 		return;
@@ -3147,18 +3144,12 @@ again:
 
 	rq = task_rq_lock(p, &flags);
 	put_cpu();
-
 	/*
 	 * select_task_rq() can race against ->cpus_allowed
 	 */
-	if (!cpumask_test_cpu(dest_cpu, &p->cpus_allowed)
-	    || unlikely(!cpu_active(dest_cpu))) {
-		task_rq_unlock(rq, &flags);
-		goto again;
-	}
-
-	/* force the process onto the specified CPU */
-	if (migrate_task(p, dest_cpu, &req)) {
+	if (cpumask_test_cpu(dest_cpu, &p->cpus_allowed) &&
+	    likely(cpu_active(dest_cpu)) &&
+	    migrate_task(p, dest_cpu, &req)) {
 		/* Need to wait for migration thread (might exit: take ref). */
 		struct task_struct *mt = rq->migration_thread;
 
-- 
1.7.3.3

