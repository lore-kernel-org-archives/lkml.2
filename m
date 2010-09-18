Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757632Ab0IRTny (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:43:54 -0400
Received: from kroah.org ([198.145.64.141]:51644 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755897Ab0IRTCD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:02:03 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 11:59:59 2010
Message-Id: <20100918185959.762346087@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:58:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Greg KH <greg@kroah.com>, Mike Galbraith <efault@gmx.de>
Subject: [081/123] sched: Fix sched_exec() balancing
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=sched-fix-sched_exec-balancing.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl>

commit 3802290628348674985d14914f9bfee7b9084548 upstream

sched: Fix sched_exec() balancing

Since we access ->cpus_allowed without holding rq->lock we need
a retry loop to validate the result, this comes for near free
when we merge sched_migrate_task() into sched_exec() since that
already does the needed check.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <20091216170517.884743662@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/sched.c |   45 +++++++++++++++++++++++----------------------
 1 file changed, 23 insertions(+), 22 deletions(-)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2322,7 +2322,7 @@ void task_oncpu_function_call(struct tas
  *
  *  - fork, @p is stable because it isn't on the tasklist yet
  *
- *  - exec, @p is unstable XXX
+ *  - exec, @p is unstable, retry loop
  *
  *  - wake-up, we serialize ->cpus_allowed against TASK_WAKING so
  *             we should be good.
@@ -3133,21 +3133,36 @@ static void double_rq_unlock(struct rq *
 }
 
 /*
- * If dest_cpu is allowed for this process, migrate the task to it.
- * This is accomplished by forcing the cpu_allowed mask to only
- * allow dest_cpu, which will force the cpu onto dest_cpu. Then
- * the cpu_allowed mask is restored.
+ * sched_exec - execve() is a valuable balancing opportunity, because at
+ * this point the task has the smallest effective memory and cache footprint.
  */
-static void sched_migrate_task(struct task_struct *p, int dest_cpu)
+void sched_exec(void)
 {
+	struct task_struct *p = current;
 	struct migration_req req;
+	int dest_cpu, this_cpu;
 	unsigned long flags;
 	struct rq *rq;
 
+again:
+	this_cpu = get_cpu();
+	dest_cpu = select_task_rq(p, SD_BALANCE_EXEC, 0);
+	if (dest_cpu == this_cpu) {
+		put_cpu();
+		return;
+	}
+
 	rq = task_rq_lock(p, &flags);
+	put_cpu();
+
+	/*
+	 * select_task_rq() can race against ->cpus_allowed
+	 */
 	if (!cpumask_test_cpu(dest_cpu, &p->cpus_allowed)
-	    || unlikely(!cpu_active(dest_cpu)))
-		goto out;
+	    || unlikely(!cpu_active(dest_cpu))) {
+		task_rq_unlock(rq, &flags);
+		goto again;
+	}
 
 	/* force the process onto the specified CPU */
 	if (migrate_task(p, dest_cpu, &req)) {
@@ -3162,24 +3177,10 @@ static void sched_migrate_task(struct ta
 
 		return;
 	}
-out:
 	task_rq_unlock(rq, &flags);
 }
 
 /*
- * sched_exec - execve() is a valuable balancing opportunity, because at
- * this point the task has the smallest effective memory and cache footprint.
- */
-void sched_exec(void)
-{
-	int new_cpu, this_cpu = get_cpu();
-	new_cpu = select_task_rq(current, SD_BALANCE_EXEC, 0);
-	put_cpu();
-	if (new_cpu != this_cpu)
-		sched_migrate_task(current, new_cpu);
-}
-
-/*
  * pull_task - move a task from a remote runqueue to the local runqueue.
  * Both runqueues must be locked.
  */


