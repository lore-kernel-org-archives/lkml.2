Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518Ab0LGCOF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 21:14:05 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:57095 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070Ab0LGCNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 21:13:31 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=3SsVLSEfDhQA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=4udJDCj5BvCdUewwzm4A:9 a=012h0UowTXV--fpLgnqJ_SMATqgA:4 a=jEp0ucaQiEUA:10 a=LI9Vle30uBYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101207021328.847976021@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 06 Dec 2010 20:58:37 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>
Subject: [RFC][PATCH 03/10] workqueue: It is likely that WORKER_NOT_RUNNING is true
References: <20101207015834.196176991@goodmis.org>
Content-Disposition: inline; filename=0003-workqueue-It-is-likely-that-WORKER_NOT_RUNNING-is-tr.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

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

Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/workqueue.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 90db1bd..b3afcce 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -661,7 +661,7 @@ void wq_worker_waking_up(struct task_struct *task, unsigned int cpu)
 {
 	struct worker *worker = kthread_data(task);
 
-	if (likely(!(worker->flags & WORKER_NOT_RUNNING)))
+	if (unlikely(!(worker->flags & WORKER_NOT_RUNNING)))
 		atomic_inc(get_gcwq_nr_running(cpu));
 }
 
@@ -687,7 +687,7 @@ struct task_struct *wq_worker_sleeping(struct task_struct *task,
 	struct global_cwq *gcwq = get_gcwq(cpu);
 	atomic_t *nr_running = get_gcwq_nr_running(cpu);
 
-	if (unlikely(worker->flags & WORKER_NOT_RUNNING))
+	if (likely(worker->flags & WORKER_NOT_RUNNING))
 		return NULL;
 
 	/* this can only happen on the local cpu */
-- 
1.7.2.3


