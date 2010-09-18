Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756273Ab0IRTMN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:12:13 -0400
Received: from kroah.org ([198.145.64.141]:51743 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756015Ab0IRTCO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:02:14 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:00:01 2010
Message-Id: <20100918190001.054442254@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:59:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>
Subject: [096/123] sched: sched_exec(): Remove the select_fallback_rq() logic
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=sched-sched_exec-remove-the-select_fallback_rq-logic.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
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
Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/sched.c |   25 ++++++++-----------------
 1 file changed, 8 insertions(+), 17 deletions(-)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2333,6 +2333,9 @@ void task_oncpu_function_call(struct tas
 }
 
 #ifdef CONFIG_SMP
+/*
+ * ->cpus_allowed is protected by either TASK_WAKING or rq->lock held.
+ */
 static int select_fallback_rq(int cpu, struct task_struct *p)
 {
 	int dest_cpu;
@@ -2369,12 +2372,7 @@ static int select_fallback_rq(int cpu, s
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
@@ -3223,9 +3221,8 @@ void sched_exec(void)
 	unsigned long flags;
 	struct rq *rq;
 
-again:
 	this_cpu = get_cpu();
-	dest_cpu = select_task_rq(p, SD_BALANCE_EXEC, 0);
+	dest_cpu = p->sched_class->select_task_rq(p, SD_BALANCE_EXEC, 0);
 	if (dest_cpu == this_cpu) {
 		put_cpu();
 		return;
@@ -3233,18 +3230,12 @@ again:
 
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
 


