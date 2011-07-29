Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334Ab1G2BCP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 21:02:15 -0400
Received: from smtp6.oregonstate.edu ([128.193.15.46]:52878 "EHLO
	smtp6.oregonstate.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730Ab1G2BCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 21:02:14 -0400
X-Greylist: delayed 348 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Jul 2011 21:02:14 EDT
Message-ID: <20110728175625.1595581wucy2hvr4@webmail.oregonstate.edu>
Date: Thu, 28 Jul 2011 17:56:25 -0700
From: uberj@onid.orst.edu
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Fix to excess pre-schedule migrating during Real Time 
 overload on multiple CPUs.
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Internet Messaging Program (IMP) H3 (4.3.7)
X-Originating-IP: 128.193.37.146
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 From cf87d70969357f46e5c28804ac39c2139652af8f Mon Sep 17 00:00:00 2001
From: Jacques Uber <uberj@onid.orst.edu>
Date: Thu, 28 Jul 2011 17:49:38 -0700
Subject: [PATCH] Fix to excess pre-schedule migrating during Real Time
  overload on multiple CPUs.

If multiple processors are under real time overload there are situations where
a processor will pull multiple tasks from multiple CPU's while trying to
schedule the highest priority task within it's root domain. As an example, if
there are four CPU's all under overload and the highest priority task on CPU3
yields its time slice, CPU3 will try to pull the next highest priority  
task onto
its the runqueue. Without the patch, if tasks were ordered in ascending order
on CPU[0-2], CPU3 would pull all the tasks, ruining any possibility of using
cached data.

The simple solution to this scenario is to maintain a "best choice"  
for CPU3 to
pull to it's run queue. Only after checking all the queued tasks and choosing
which one should be ran, will it deactivate, set_task, and reactivate the task
onto it's runqueue.

This patch was inspired by a Linux Journal article about the Real Time  
Scheduler.
http://www.linuxjournal.com/magazine/real-time-linux-kernel-scheduler?page=0,3

Signed-off-by: Jacques Uber <uberj@onid.orst.edu>
Signed-off-by: Kevin Strasser <strassek@onid.orst.edu>
---
  kernel/sched_rt.c |   11 ++++++++---
  1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 97540f0..067f159 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1482,6 +1482,7 @@ static int pull_rt_task(struct rq *this_rq)
  {
         int this_cpu = this_rq->cpu, ret = 0, cpu;
         struct task_struct *p;
+       struct task_struct *best = NULL;
         struct rq *src_rq;

         if (likely(!rt_overloaded(this_rq)))
@@ -1540,9 +1541,10 @@ static int pull_rt_task(struct rq *this_rq)

                         ret = 1;

-                       deactivate_task(src_rq, p, 0);
-                       set_task_cpu(p, this_cpu);
-                       activate_task(this_rq, p, 0);
+            if(!best)
+                best = p;
+            else if(p->prio > best->prio)
+                best = p;
                         /*
                          * We continue with the search, just in
                          * case there's an even higher prio task
@@ -1550,6 +1552,9 @@ static int pull_rt_task(struct rq *this_rq)
                          * but possible)
                          */
                 }
+        deactivate_task(src_rq, p, 0);
+        set_task_cpu(p, this_cpu);
+        activate_task(this_rq, p, 0);
  skip:
                 double_unlock_balance(this_rq, src_rq);
         }
-- 
1.7.5.4

