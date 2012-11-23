Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808Ab2KWOVk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 09:21:40 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:51463 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754285Ab2KWOVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 09:21:37 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 3/3] cputime: Consolidate cputime adjustment code
Date: Fri, 23 Nov 2012 15:21:24 +0100
Message-Id: <1353680484-7302-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1353680484-7302-1-git-send-email-fweisbec@gmail.com>
References: <1353680484-7302-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

task_cputime_adjusted() and thread_group_cputime_adjusted()
essentially share the same code. They just don't use the same
source:

* The first function uses the cputime in the task struct and the
previous adjusted snapshot that ensures monotonicity.

* The second adds the cputime of all tasks in the group and the
previous adjusted snapshot of the whole group from the signal
structure.

Just consolidate the common code that does the adjustment. These
functions just need to fetch the values from the appropriate
source.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/sched.h  |    9 +++++++--
 kernel/fork.c          |    2 +-
 kernel/sched/cputime.c |   46 +++++++++++++++++++++++-----------------------
 3 files changed, 31 insertions(+), 26 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index e75cab5..d23204f 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -433,6 +433,11 @@ struct cpu_itimer {
 	u32 incr_error;
 };
 
+struct cputime {
+	cputime_t utime;
+	cputime_t stime;
+};
+
 /**
  * struct task_cputime - collected CPU time counts
  * @utime:		time spent in user mode, in &cputime_t units
@@ -581,7 +586,7 @@ struct signal_struct {
 	cputime_t gtime;
 	cputime_t cgtime;
 #ifndef CONFIG_VIRT_CPU_ACCOUNTING
-	cputime_t prev_utime, prev_stime;
+	struct cputime prev_cputime;
 #endif
 	unsigned long nvcsw, nivcsw, cnvcsw, cnivcsw;
 	unsigned long min_flt, maj_flt, cmin_flt, cmaj_flt;
@@ -1340,7 +1345,7 @@ struct task_struct {
 	cputime_t utime, stime, utimescaled, stimescaled;
 	cputime_t gtime;
 #ifndef CONFIG_VIRT_CPU_ACCOUNTING
-	cputime_t prev_utime, prev_stime;
+	struct cputime prev_cputime;
 #endif
 	unsigned long nvcsw, nivcsw; /* context switch counts */
 	struct timespec start_time; 		/* monotonic time */
diff --git a/kernel/fork.c b/kernel/fork.c
index 8b20ab7..0e7cdb9 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1222,7 +1222,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	p->utime = p->stime = p->gtime = 0;
 	p->utimescaled = p->stimescaled = 0;
 #ifndef CONFIG_VIRT_CPU_ACCOUNTING
-	p->prev_utime = p->prev_stime = 0;
+	p->prev_cputime.utime = p->prev_cputime.stime = 0;
 #endif
 #if defined(SPLIT_RSS_COUNTING)
 	memset(&p->rss_stat, 0, sizeof(p->rss_stat));
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 7dc1553..220fdc4 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -516,14 +516,18 @@ static cputime_t scale_utime(cputime_t utime, cputime_t rtime, cputime_t total)
 	return (__force cputime_t) temp;
 }
 
-void task_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime_t *st)
+static void cputime_adjust(struct task_cputime *curr,
+			   struct cputime *prev,
+			   cputime_t *ut, cputime_t *st)
 {
-	cputime_t rtime, utime = p->utime, total = utime + p->stime;
+	cputime_t rtime, utime, total;
 
+	utime = curr->utime;
+	total = utime + curr->stime;
 	/*
 	 * Use CFS's precise accounting:
 	 */
-	rtime = nsecs_to_cputime(p->se.sum_exec_runtime);
+	rtime = nsecs_to_cputime(curr->sum_exec_runtime);
 
 	if (total)
 		utime = scale_utime(utime, rtime, total);
@@ -533,11 +537,22 @@ void task_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime_t *st)
 	/*
 	 * Compare with previous values, to keep monotonicity:
 	 */
-	p->prev_utime = max(p->prev_utime, utime);
-	p->prev_stime = max(p->prev_stime, rtime - p->prev_utime);
+	prev->utime = max(prev->utime, utime);
+	prev->stime = max(prev->stime, rtime - prev->utime);
+
+	*ut = prev->utime;
+	*st = prev->stime;
+}
 
-	*ut = p->prev_utime;
-	*st = p->prev_stime;
+void task_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime_t *st)
+{
+	struct task_cputime cputime = {
+		.utime = p->utime,
+		.stime = p->stime,
+		.sum_exec_runtime = p->se.sum_exec_runtime,
+	};
+
+	cputime_adjust(&cputime, &p->prev_cputime, ut, st);
 }
 
 /*
@@ -545,24 +560,9 @@ void task_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime_t *st)
  */
 void thread_group_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime_t *st)
 {
-	struct signal_struct *sig = p->signal;
 	struct task_cputime cputime;
-	cputime_t rtime, utime, total;
 
 	thread_group_cputime(p, &cputime);
-
-	total = cputime.utime + cputime.stime;
-	rtime = nsecs_to_cputime(cputime.sum_exec_runtime);
-
-	if (total)
-		utime = scale_utime(cputime.utime, rtime, total);
-	else
-		utime = rtime;
-
-	sig->prev_utime = max(sig->prev_utime, utime);
-	sig->prev_stime = max(sig->prev_stime, rtime - sig->prev_utime);
-
-	*ut = sig->prev_utime;
-	*st = sig->prev_stime;
+	cputime_adjust(&cputime, &p->signal->prev_cputime, ut, st);
 }
 #endif
-- 
1.7.5.4

