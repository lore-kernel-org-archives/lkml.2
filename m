Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758640Ab1FQCAR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 22:00:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:56323 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758135Ab1FQB7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 21:59:22 -0400
X-Authority-Analysis: v=1.1 cv=5asQ6euaRPJxDdFxwvXsn6JDb7fmFbz8qWDLMfa45gU= c=1 sm=0 a=vhdKIqpQuCYA:10 a=Rqclsr7QXWAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=Yp8NKwvwDKWBoq94IugA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110617015919.832743148@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 16 Jun 2011 21:55:22 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [RFC][PATCH 6/7] sched: Balance RT tasks when forked as well
References: <20110617015516.301117218@goodmis.org>
Content-Disposition: inline; filename=0006-sched-Balance-RT-tasks-when-forked-as-well.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

When a new task is woken, the code to balance the RT task is currently
skipped in the select_task_rq() call. But it will be pushed if the rq
is currently overloaded with RT tasks anyway. The issue is that we
already queued the task, and if it does get pushed, it will have to
be dequeued and requeued on the new run queue. The advantage with
pushing it first is that we avoid this requeuing as we are pushing it
off before the task is ever queued.

See commit: 318e0893ce3f524ca045f9fd9dfd567c0a6f9446 for more details.
    (sched: pre-route RT tasks on wakeup)

The return of select_task_rq() when it is not a wake up has also been
changed to return task_cpu() instead of smp_processor_id(). This is more
of a sanity because the current only other user of select_task_rq()
besides wake ups, is an exec, where task_cpu() should also be the same
as smp_processor_id(). But if it is used for other purposes, lets keep
the task on the same CPU. Why would we mant to migrate it to the current
CPU?

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/sched_rt.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 1546c1c..33636d2 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1005,10 +1005,12 @@ select_task_rq_rt(struct task_struct *p, int sd_flag, int flags)
 	struct rq *rq;
 	int cpu;
 
-	if (sd_flag != SD_BALANCE_WAKE)
-		return smp_processor_id();
-
 	cpu = task_cpu(p);
+
+	/* For anything but wake ups, just return the task_cpu */
+	if (sd_flag != SD_BALANCE_WAKE || sd_flag != SD_BALANCE_FORK)
+		goto out;
+
 	rq = cpu_rq(cpu);
 
 	rcu_read_lock();
@@ -1047,6 +1049,7 @@ select_task_rq_rt(struct task_struct *p, int sd_flag, int flags)
 	}
 	rcu_read_unlock();
 
+out:
 	return cpu;
 }
 
-- 
1.7.4.4


