Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932754Ab1BPB54 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:57:56 -0500
Received: from kroah.org ([198.145.64.141]:49257 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758390Ab1BPBvb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 20:51:31 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 17:47:03 2011
Message-Id: <20110216014703.347831921@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 17:45:57 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Gregory Haskins <ghaskins@novell.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>
Subject: [091/115] sched: Give CPU bound RT tasks preference
In-Reply-To: <20110216014741.GA24678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From:: Steven Rostedt <srostedt@redhat.com>

Commit: b3bc211cfe7d5fe94b310480d78e00bea96fbf2a upstream

If a high priority task is waking up on a CPU that is running a
lower priority task that is bound to a CPU, see if we can move the
high RT task to another CPU first. Note, if all other CPUs are
running higher priority tasks than the CPU bounded current task,
then it will be preempted regardless.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Gregory Haskins <ghaskins@novell.com>
LKML-Reference: <20100921024138.888922071@goodmis.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/sched_rt.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -965,7 +965,8 @@ select_task_rq_rt(struct rq *rq, struct
 	 * For equal prio tasks, we just let the scheduler sort it out.
 	 */
 	if (unlikely(rt_task(rq->curr)) &&
-	    rq->curr->prio < p->prio &&
+	    (rq->curr->rt.nr_cpus_allowed < 2 ||
+	     rq->curr->prio < p->prio) &&
 	    (p->rt.nr_cpus_allowed > 1)) {
 		int cpu = find_lowest_rq(p);
 
@@ -1493,9 +1494,10 @@ static void task_woken_rt(struct rq *rq,
 	if (!task_running(rq, p) &&
 	    !test_tsk_need_resched(rq->curr) &&
 	    has_pushable_tasks(rq) &&
+	    p->rt.nr_cpus_allowed > 1 &&
 	    rt_task(rq->curr) &&
-	    rq->curr->prio < p->prio &&
-	    p->rt.nr_cpus_allowed > 1)
+	    (rq->curr->rt.nr_cpus_allowed < 2 ||
+	     rq->curr->prio < p->prio))
 		push_rt_tasks(rq);
 }
 


