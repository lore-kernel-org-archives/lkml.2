Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757358Ab0DVTjx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:39:53 -0400
Received: from kroah.org ([198.145.64.141]:41400 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756799Ab0DVT3f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:29:35 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:21 2010
Message-Id: <20100422190921.352381029@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:10:07 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       John Wright <john.wright@hp.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [156/197] sched: Fix a race between ttwu() and migrate_task()
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

Based on commit e2912009fb7b715728311b0d8fe327a1432b3f79 upstream, but
done differently as this issue is not present in .33 or .34 kernels due
to rework in this area.

If a task is in the TASK_WAITING state, then try_to_wake_up() is working
on it, and it will place it on the correct cpu.

This commit ensures that neither migrate_task() nor __migrate_task()
calls set_task_cpu(p) while p is in the TASK_WAKING state.  Otherwise,
there could be two concurrent calls to set_task_cpu(p), resulting in
the task's cfs_rq being inconsistent with its cpu.

Signed-off-by: John Wright <john.wright@hp.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/sched.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2116,12 +2116,10 @@ migrate_task(struct task_struct *p, int
 
 	/*
 	 * If the task is not on a runqueue (and not running), then
-	 * it is sufficient to simply update the task's cpu field.
+	 * the next wake-up will properly place the task.
 	 */
-	if (!p->se.on_rq && !task_running(rq, p)) {
-		set_task_cpu(p, dest_cpu);
+	if (!p->se.on_rq && !task_running(rq, p))
 		return 0;
-	}
 
 	init_completion(&req->done);
 	req->task = p;
@@ -7167,6 +7165,9 @@ static int __migrate_task(struct task_st
 	/* Already moved. */
 	if (task_cpu(p) != src_cpu)
 		goto done;
+	/* Waking up, don't get in the way of try_to_wake_up(). */
+	if (p->state == TASK_WAKING)
+		goto fail;
 	/* Affinity changed (again). */
 	if (!cpumask_test_cpu(dest_cpu, &p->cpus_allowed))
 		goto fail;


