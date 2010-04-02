Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755079Ab0DBTNK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 15:13:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:38839 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754871Ab0DBTM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 15:12:58 -0400
Date: Fri, 2 Apr 2010 19:12:34 GMT
From: tip-bot for Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, oleg@redhat.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, oleg@redhat.com,
       mingo@elte.hu
In-Reply-To: <20100315091019.GA9141@redhat.com>
References: <20100315091019.GA9141@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: sched_exec(): Remove the select_fallback_rq() logic
Message-ID: <tip-30da688ef6b76e01969b00608202fff1eed2accc@git.kernel.org>
Git-Commit-ID: 30da688ef6b76e01969b00608202fff1eed2accc
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 02 Apr 2010 19:12:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  30da688ef6b76e01969b00608202fff1eed2accc
Gitweb:     http://git.kernel.org/tip/30da688ef6b76e01969b00608202fff1eed2accc
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Mon, 15 Mar 2010 10:10:19 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 2 Apr 2010 20:12:02 +0200

sched: sched_exec(): Remove the select_fallback_rq() logic

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
---
 kernel/sched.c |   25 ++++++++-----------------
 1 files changed, 8 insertions(+), 17 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index f475c60..165b532 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2280,6 +2280,9 @@ void task_oncpu_function_call(struct task_struct *p,
 }
 
 #ifdef CONFIG_SMP
+/*
+ * ->cpus_allowed is protected by either TASK_WAKING or rq->lock held.
+ */
 static int select_fallback_rq(int cpu, struct task_struct *p)
 {
 	int dest_cpu;
@@ -2316,12 +2319,7 @@ static int select_fallback_rq(int cpu, struct task_struct *p)
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
@@ -3076,9 +3074,8 @@ void sched_exec(void)
 	unsigned long flags;
 	struct rq *rq;
 
-again:
 	this_cpu = get_cpu();
-	dest_cpu = select_task_rq(p, SD_BALANCE_EXEC, 0);
+	dest_cpu = p->sched_class->select_task_rq(p, SD_BALANCE_EXEC, 0);
 	if (dest_cpu == this_cpu) {
 		put_cpu();
 		return;
@@ -3086,18 +3083,12 @@ again:
 
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
 
