Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191Ab2JJTYI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 15:24:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4056 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755632Ab2JJTYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 15:24:06 -0400
X-Authority-Analysis: v=2.0 cv=YP4dOG6x c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=zYwCYAMbQIkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=1UqZbzc3nZ0A:10 a=VwQbUJbxAAAA:8 a=4M0vJZQeAAAA:8 a=fSm92gvxgDq1-3xaEzUA:9 a=PUjeQqilurYA:10 a=0kPLrQdw3YYA:10 a=Zh68SRI7RUMA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1349897043.24256.63.camel@gandalf.local.home>
Subject: stable backport: sched: Fix migration thread runtime bogosity
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ben Hutchings <ben@decadent.org.uk>,
        Mike Galbraith <mgalbraith@suse.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 10 Oct 2012 15:24:03 -0400
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg, Ben,

Can you add this commit to the stable branches. Without it, the
migration thread's accounting is just totally screwed up:

By running a simple shell while loop along with a ps loop, top shows:

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND            
   17 root      RT   0     0    0    0 S 9999.0  0.0   9:27.50 migration/3    
   13 root      RT   0     0    0    0 S 128.2  0.0   9:50.23 migration/2       
 2805 root      20   0  105m 1904 1416 S 13.9  0.1   0:06.69 bash               
 4090 root      20   0  105m 1904 1416 S  2.0  0.1   0:00.90 bash               
 2773 root      20   0 85484 3372 2620 S  0.3  0.2   0:00.03 sshd               


For 3.4, the commit can be directly cherry picked:

commit 8f6189684eb4e85e6c593cd710693f09c944450a
Author: Mike Galbraith <mgalbraith@suse.de>
Date:   Sat Aug 4 05:44:14 2012 +0200

    sched: Fix migration thread runtime bogosity

Below is a backport for 3.2.

Thanks! 

-- Steve

>From 8f6189684eb4e85e6c593cd710693f09c944450a Mon Sep 17 00:00:00 2001
From: Mike Galbraith <mgalbraith@suse.de>
Date: Sat, 4 Aug 2012 05:44:14 +0200
Subject: [PATCH] sched: Fix migration thread runtime bogosity

Make stop scheduler class do the same accounting as other classes,

Migration threads can be caught in the act while doing exec balancing,
leading to the below due to use of unmaintained ->se.exec_start.  The
load that triggered this particular instance was an apparently out of
control heavily threaded application that does system monitoring in
what equated to an exec bomb, with one of the VERY frequently migrated
tasks being ps.

%CPU   PID USER     CMD
99.3    45 root     [migration/10]
97.7    53 root     [migration/12]
97.0    57 root     [migration/13]
90.1    49 root     [migration/11]
89.6    65 root     [migration/15]
88.7    17 root     [migration/3]
80.4    37 root     [migration/8]
78.1    41 root     [migration/9]
44.2    13 root     [migration/2]

Signed-off-by: Mike Galbraith <mgalbraith@suse.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1344051854.6739.19.camel@marge.simpson.net
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/sched_stoptask.c |   22 +++++++++++++++++++++-
 1 files changed, 21 insertions(+), 1 deletions(-)

Index: linux-trace.git/kernel/sched_stoptask.c
===================================================================
--- linux-trace.git.orig/kernel/sched_stoptask.c
+++ linux-trace.git/kernel/sched_stoptask.c
@@ -25,8 +25,10 @@ static struct task_struct *pick_next_tas
 {
 	struct task_struct *stop = rq->stop;
 
-	if (stop && stop->on_rq)
+	if (stop && stop->on_rq) {
+		stop->se.exec_start = rq->clock_task;
 		return stop;
+	}
 
 	return NULL;
 }
@@ -50,6 +52,21 @@ static void yield_task_stop(struct rq *r
 
 static void put_prev_task_stop(struct rq *rq, struct task_struct *prev)
 {
+	struct task_struct *curr = rq->curr;
+	u64 delta_exec;
+
+	delta_exec = rq->clock_task - curr->se.exec_start;
+	if (unlikely((s64)delta_exec < 0))
+		delta_exec = 0;
+
+	schedstat_set(curr->se.statistics.exec_max,
+			max(curr->se.statistics.exec_max, delta_exec));
+
+	curr->se.sum_exec_runtime += delta_exec;
+	account_group_exec_runtime(curr, delta_exec);
+
+	curr->se.exec_start = rq->clock_task;
+	cpuacct_charge(curr, delta_exec);
 }
 
 static void task_tick_stop(struct rq *rq, struct task_struct *curr, int queued)
@@ -58,6 +75,9 @@ static void task_tick_stop(struct rq *rq
 
 static void set_curr_task_stop(struct rq *rq)
 {
+	struct task_struct *stop = rq->stop;
+
+	stop->se.exec_start = rq->clock_task;
 }
 
 static void switched_to_stop(struct rq *rq, struct task_struct *p)


