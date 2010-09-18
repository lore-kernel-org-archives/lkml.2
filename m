Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567Ab0IRTNq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:13:46 -0400
Received: from kroah.org ([198.145.64.141]:51713 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755967Ab0IRTCL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:02:11 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:00:00 2010
Message-Id: <20100918190000.605894814@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:58:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Greg KH <greg@kroah.com>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>
Subject: [091/123] sched: Queue a deboosted task to the head of the RT prio queue
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=sched-queue-a-deboosted-task-to-the-head-of-the-rt-prio-queue.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit 60db48cacb9b253d5607a5ff206112a59cd09e34 upstream

rtmutex_set_prio() is used to implement priority inheritance for
futexes. When a task is deboosted it gets enqueued at the tail of its
RT priority list. This is violating the POSIX scheduling semantics:

rt priority list X contains two runnable tasks A and B

task A	 runs with priority X and holds mutex M
task C	 preempts A and is blocked on mutex M
     	 -> task A is boosted to priority of task C (Y)
task A	 unlocks the mutex M and deboosts itself
     	 -> A is dequeued from rt priority list Y
	 -> A is enqueued to the tail of rt priority list X
task C	 schedules away
task B	 runs

This is wrong as task A did not schedule away and therefor violates
the POSIX scheduling semantics.

Enqueue the task to the head of the priority list instead.

Reported-by: Mathias Weber <mathias.weber.mw1@roche.com>
Reported-by: Carsten Emde <cbe@osadl.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Tested-by: Carsten Emde <cbe@osadl.org>
Tested-by: Mathias Weber <mathias.weber.mw1@roche.com>
LKML-Reference: <20100120171629.809074113@linutronix.de>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/sched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6184,7 +6184,7 @@ void rt_mutex_setprio(struct task_struct
 	if (running)
 		p->sched_class->set_curr_task(rq);
 	if (on_rq) {
-		enqueue_task(rq, p, 0, false);
+		enqueue_task(rq, p, 0, oldprio < prio);
 
 		check_class_changed(rq, p, prev_class, oldprio, running);
 	}


