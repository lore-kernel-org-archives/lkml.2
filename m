Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758746Ab0LNAsh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 19:48:37 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:34426 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758717Ab0LNAsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 19:48:36 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=lW1XFx4uH24A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=y46Gznpf7Y2xR-B52ugA:9 a=yjb8XoNwUZ_lbfraVu8A:7 a=S3tbrTqfpVZl0ympuvMKgnBdX3wA:4 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=LI9Vle30uBYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: [PATCH][GIT PULL] workqueue: It is likely that WORKER_NOT_RUNNING
 is true
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 13 Dec 2010 19:48:35 -0500
Message-ID: <1292287715.5015.1782.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

You can either just take this patch out directly, or pull it from my
repo.

The following patch is in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: unlikely/workqueue


Steven Rostedt (1):
      workqueue: It is likely that WORKER_NOT_RUNNING is true

----
 kernel/workqueue.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)
---------------------------
commit deed625e5fc7a3abfd18cdb44edf2d5197982a74
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Fri Dec 3 23:12:33 2010 -0500

    workqueue: It is likely that WORKER_NOT_RUNNING is true
    
    Running the annotate branch profiler on three boxes, including my
    main box that runs firefox, evolution, xchat, and is part of the distcc farm,
    showed this with the likelys in the workqueue code:
    
     correct incorrect  %        Function                  File              Line
     ------- ---------  -        --------                  ----              ----
          96   996253  99 wq_worker_sleeping             workqueue.c          703
          96   996247  99 wq_worker_waking_up            workqueue.c          677
    
    The likely()s in this case were assuming that WORKER_NOT_RUNNING will
    most likely be false. But this is not the case. The reason is
    (and shown by adding trace_printks and testing it) that most of the time
    WORKER_PREP is set.
    
    In worker_thread() we have:
    
    	worker_clr_flags(worker, WORKER_PREP);
    
    	[ do work stuff ]
    
    	worker_set_flags(worker, WORKER_PREP, false);
    
    (that 'false' means not to wake up an idle worker)
    
    The wq_worker_sleeping() is called from schedule when a worker thread
    is putting itself to sleep. Which happens most of the time outside
    of that [ do work stuff ].
    
    The wq_worker_waking_up is called by the wakeup worker code, which
    is also callod outside that [ do work stuff ].
    
    Thus, the likely and unlikely used by those two functions are actually
    backwards.
    
    Remove the annotation and let gcc figure it out.
    
    Acked-by: Tejun Heo <tj@kernel.org>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 90db1bd..98ce2ea 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -661,7 +661,7 @@ void wq_worker_waking_up(struct task_struct *task, unsigned int cpu)
 {
 	struct worker *worker = kthread_data(task);
 
-	if (likely(!(worker->flags & WORKER_NOT_RUNNING)))
+	if (!(worker->flags & WORKER_NOT_RUNNING))
 		atomic_inc(get_gcwq_nr_running(cpu));
 }
 
@@ -687,7 +687,7 @@ struct task_struct *wq_worker_sleeping(struct task_struct *task,
 	struct global_cwq *gcwq = get_gcwq(cpu);
 	atomic_t *nr_running = get_gcwq_nr_running(cpu);
 
-	if (unlikely(worker->flags & WORKER_NOT_RUNNING))
+	if (worker->flags & WORKER_NOT_RUNNING)
 		return NULL;
 
 	/* this can only happen on the local cpu */


