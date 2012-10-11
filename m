Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933771Ab2JKBPy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 21:15:54 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:49922 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933752Ab2JKBPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 21:15:20 -0400
X-Sasl-enc: SyZlE/bwzUqvU0AIznayD6T2KL35fPOcx3lXTW4s1IMi 1349918118
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Mike Galbraith <mgalbraith@suse.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [ 120/120] sched: Fix migration thread runtime bogosity
Date: Thu, 11 Oct 2012 10:01:12 +0900
Message-Id: <20121011005849.725606407@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121011005825.364610894@linuxfoundation.org>
References: <20121011005825.364610894@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Galbraith <mgalbraith@suse.de>

commit 8f6189684eb4e85e6c593cd710693f09c944450a upstream.

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
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/sched/stop_task.c |   22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

--- a/kernel/sched/stop_task.c
+++ b/kernel/sched/stop_task.c
@@ -27,8 +27,10 @@ static struct task_struct *pick_next_tas
 {
 	struct task_struct *stop = rq->stop;
 
-	if (stop && stop->on_rq)
+	if (stop && stop->on_rq) {
+		stop->se.exec_start = rq->clock_task;
 		return stop;
+	}
 
 	return NULL;
 }
@@ -52,6 +54,21 @@ static void yield_task_stop(struct rq *r
 
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
@@ -60,6 +77,9 @@ static void task_tick_stop(struct rq *rq
 
 static void set_curr_task_stop(struct rq *rq)
 {
+	struct task_struct *stop = rq->stop;
+
+	stop->se.exec_start = rq->clock_task;
 }
 
 static void switched_to_stop(struct rq *rq, struct task_struct *p)


