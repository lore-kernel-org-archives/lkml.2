Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266Ab0IRTBp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:01:45 -0400
Received: from kroah.org ([198.145.64.141]:51125 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754364Ab0IRTBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:01:15 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 11:59:53 2010
Message-Id: <20100918185953.670620754@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:57:34 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Greg KH <greg@kroah.com>, Mike Galbraith <efault@gmx.de>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [010/123] sched: revert stable c6fc81a sched: Fix a race between ttwu() and migrate_task()
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=sched-revert-stable-c6fc81a-sched-fix-a-race-between-ttwu-and-migrate_task.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Galbraith <efault@gmx.de>

This commit does not appear to have been meant for 32-stable, and causes ltp's
cpusets testcases to fail, revert it.

Original commit text:

sched: Fix a race between ttwu() and migrate_task()

Based on commit e2912009fb7b715728311b0d8fe327a1432b3f79 upstream, but
done differently as this issue is not present in .33 or .34 kernels due
to rework in this area.

If a task is in the TASK_WAITING state, then try_to_wake_up() is working
on it, and it will place it on the correct cpu.

This commit ensures that neither migrate_task() nor __migrate_task()
calls set_task_cpu(p) while p is in the TASK_WAKING state.  Otherwise,
there could be two concurrent calls to set_task_cpu(p), resulting in
the task's cfs_rq being inconsistent with its cpu.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/sched.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2123,10 +2123,12 @@ migrate_task(struct task_struct *p, int
 
 	/*
 	 * If the task is not on a runqueue (and not running), then
-	 * the next wake-up will properly place the task.
+	 * it is sufficient to simply update the task's cpu field.
 	 */
-	if (!p->se.on_rq && !task_running(rq, p))
+	if (!p->se.on_rq && !task_running(rq, p)) {
+		set_task_cpu(p, dest_cpu);
 		return 0;
+	}
 
 	init_completion(&req->done);
 	req->task = p;
@@ -7217,9 +7219,6 @@ static int __migrate_task(struct task_st
 	/* Already moved. */
 	if (task_cpu(p) != src_cpu)
 		goto done;
-	/* Waking up, don't get in the way of try_to_wake_up(). */
-	if (p->state == TASK_WAKING)
-		goto fail;
 	/* Affinity changed (again). */
 	if (!cpumask_test_cpu(dest_cpu, &p->cpus_allowed))
 		goto fail;


