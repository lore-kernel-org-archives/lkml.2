Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424Ab2LMIoi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 03:44:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60307 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753353Ab2LMIoh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 03:44:37 -0500
Date: Thu, 13 Dec 2012 09:44:31 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH] sched: cputime: avoid multiplication overflow (in common
 cases)
Message-ID: <20121213084430.GA2297@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We scale stime, utime values based on rtime (sum_exec_runtime converted
to jiffies). During scaling we multiple rtime * utime, what seems to be
fine, since both values are converted to u64, but is not.

Let assume HZ is 1000 - 1ms tick. Process consist of 64 threads, run
for 1 day, threads utilize 100% cpu on user space. Machine has 64 CPUs.

Process rtime = utime will be 64 * 24 * 60 * 60 * 1000 jiffies, what is
0x149970000. Multiplication rtime * utime result is 0x1a855771100000000,
which can not be covered in 64 bits.

Result of overflow is stall of utime values visible in user space
(prev_utime in kernel), even if application still consume lot of CPU
time.

Probably good fix for the problem, will be using 128 bit variable and
proper mul128 and div_u128_u64 primitives. While mul128 is on it's
way to kernel, there is no 128 bit division yet. I'm not sure, if we
want to add it to kernel. Perhaps we could also change the way how
stime and utime are calculated, but I don't know how, so I come with
the below solution for the problem.

To avoid overflow patch change value we scale to min(stime, utime). This
is more like workaround, but will work for processes, which perform
mostly on user space or mostly on kernel space. Unfortunately processes,
which perform on kernel and user space equally, and additionally utilize
lot of CPU time, still will hit this overflow pretty quickly. However
such processes seems to be uncommon.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 kernel/sched/cputime.c |   92 +++++++++++++++++++++++++++++------------------
 1 files changed, 57 insertions(+), 35 deletions(-)

diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 81b763b..6e23daf 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -463,40 +463,72 @@ EXPORT_SYMBOL_GPL(vtime_account);
 #ifndef nsecs_to_cputime
 # define nsecs_to_cputime(__nsecs)	nsecs_to_jiffies(__nsecs)
 #endif
-
-static cputime_t scale_utime(cputime_t utime, cputime_t rtime, cputime_t total)
+/*
+ * Scale utime and stime values to reflect sum_exec_runtime accounted precisely
+ * by CFS's. We use the following proportion:
+ *
+ *	Xtime / total = scaled_Xtime / rtime
+ *
+ * where total is stime + utime, rtime is sum_exec_runtime converted to
+ * cputime_t units. To avoid overflow in Xtime * rtime multiplication, we chose
+ * Xtime as smaller from {utime, stime} pair. Scaled value of second entry from
+ * the pair is calculated by simple subtraction from rtime.
+ */
+static void scale_cputimes(struct task_cputime *cputime, cputime_t *prev_ut,
+			   cputime_t *prev_st)
 {
-	u64 temp = (__force u64) rtime;
+	cputime_t rtime = nsecs_to_cputime(cputime->sum_exec_runtime);
+	cputime_t utime = cputime->utime;
+	cputime_t stime = cputime->stime;
+	cputime_t scaled_time, total;
+	bool utime_scale;
+	u64 tmp;
+
+	if (utime == stime) {
+		utime_scale = true;
+		scaled_time = rtime / 2;
+	} else {
+		tmp = (__force u64) rtime;
 
-	temp *= (__force u64) utime;
+		if (utime < stime) {
+			tmp *= utime;
+			utime_scale = true;
+		} else {
+			tmp *= stime;
+			utime_scale = false;
+		}
 
-	if (sizeof(cputime_t) == 4)
-		temp = div_u64(temp, (__force u32) total);
-	else
-		temp = div64_u64(temp, (__force u64) total);
+		total = utime + stime;
 
-	return (__force cputime_t) temp;
-}
+		if (sizeof(cputime_t) == 4)
+			tmp = div_u64(tmp, (__force u32) total);
+		else
+			tmp = div64_u64(tmp, (__force u64) total);
 
-void task_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
-{
-	cputime_t rtime, utime = p->utime, total = utime + p->stime;
+		scaled_time = (__force cputime_t) tmp;
+	}
 
 	/*
-	 * Use CFS's precise accounting:
+	 * Compare with previous values, to keep monotonicity:
 	 */
-	rtime = nsecs_to_cputime(p->se.sum_exec_runtime);
+	if (utime_scale) {
+		*prev_ut = max(*prev_ut, scaled_time);
+		*prev_st = max(*prev_st, rtime - *prev_ut);
+	} else {
+		*prev_st = max(*prev_st, scaled_time);
+		*prev_ut = max(*prev_ut, rtime - *prev_st);
+	}
+}
 
-	if (total)
-		utime = scale_utime(utime, rtime, total);
-	else
-		utime = rtime;
+void task_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
+{
+	struct task_cputime cputime = {
+		.utime = p->utime,
+		.stime = p->stime,
+		.sum_exec_runtime = p->se.sum_exec_runtime,
+	};
 
-	/*
-	 * Compare with previous values, to keep monotonicity:
-	 */
-	p->prev_utime = max(p->prev_utime, utime);
-	p->prev_stime = max(p->prev_stime, rtime - p->prev_utime);
+	scale_cputimes(&cputime, &p->prev_utime, &p->prev_stime);
 
 	*ut = p->prev_utime;
 	*st = p->prev_stime;
@@ -509,20 +541,10 @@ void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
 {
 	struct signal_struct *sig = p->signal;
 	struct task_cputime cputime;
-	cputime_t rtime, utime, total;
 
 	thread_group_cputime(p, &cputime);
 
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
+	scale_cputimes(&cputime, &sig->prev_utime, &sig->prev_stime);
 
 	*ut = sig->prev_utime;
 	*st = sig->prev_stime;
-- 
1.7.1

