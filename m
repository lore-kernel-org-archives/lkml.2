Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160Ab3AGLcF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 06:32:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30378 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753680Ab3AGLcC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 06:32:02 -0500
Date: Mon, 7 Jan 2013 12:31:45 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, akpm@linux-foundation.org
Subject: [PATCH v2 repost] sched: cputime: avoid multiplication overflow (in
 common cases)
Message-ID: <20130107113144.GA7544@redhat.com>
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
for 1 day, threads utilize 100% cpu on user space. Machine has 64 cpus.

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
v1 -> v2: rebase to current Linus source

 kernel/sched/cputime.c |   61 +++++++++++++++++++++++++++++-------------------
 1 files changed, 37 insertions(+), 24 deletions(-)

diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 293b202..5e2309a 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -509,20 +509,6 @@ EXPORT_SYMBOL_GPL(vtime_account);
 # define nsecs_to_cputime(__nsecs)	nsecs_to_jiffies(__nsecs)
 #endif
 
-static cputime_t scale_utime(cputime_t utime, cputime_t rtime, cputime_t total)
-{
-	u64 temp = (__force u64) rtime;
-
-	temp *= (__force u64) utime;
-
-	if (sizeof(cputime_t) == 4)
-		temp = div_u64(temp, (__force u32) total);
-	else
-		temp = div64_u64(temp, (__force u64) total);
-
-	return (__force cputime_t) temp;
-}
-
 /*
  * Adjust tick based cputime random precision against scheduler
  * runtime accounting.
@@ -531,10 +517,11 @@ static void cputime_adjust(struct task_cputime *curr,
 			   struct cputime *prev,
 			   cputime_t *ut, cputime_t *st)
 {
-	cputime_t rtime, utime, total;
-
-	utime = curr->utime;
-	total = utime + curr->stime;
+	cputime_t utime = curr->utime;
+	cputime_t stime = curr->stime;
+	cputime_t rtime, total, scaled_time;
+	bool utime_scale = false;
+	u64 tmp;
 
 	/*
 	 * Tick based cputime accounting depend on random scheduling
@@ -548,18 +535,44 @@ static void cputime_adjust(struct task_cputime *curr,
 	 */
 	rtime = nsecs_to_cputime(curr->sum_exec_runtime);
 
-	if (total)
-		utime = scale_utime(utime, rtime, total);
-	else
-		utime = rtime;
+	if (utime == stime) {
+		scaled_time = rtime / 2;
+	} else {
+		tmp = (__force u64) rtime;
+
+		/*
+		 * Choose smaller value to avoid possible overflow during
+		 * multiplication.
+		 */
+		if (utime < stime) {
+			tmp *= utime;
+			utime_scale = true;
+		} else {
+			tmp *= stime;
+		}
+
+		total = utime + stime;
+
+		if (sizeof(cputime_t) == 4)
+			tmp = div_u64(tmp, (__force u32) total);
+		else
+			tmp = div64_u64(tmp, (__force u64) total);
+
+		scaled_time = (__force cputime_t) tmp;
+	}
 
 	/*
 	 * If the tick based count grows faster than the scheduler one,
 	 * the result of the scaling may go backward.
 	 * Let's enforce monotonicity.
 	 */
-	prev->utime = max(prev->utime, utime);
-	prev->stime = max(prev->stime, rtime - prev->utime);
+	if (utime_scale) {
+		prev->utime = max(prev->utime, scaled_time);
+		prev->stime = max(prev->stime, rtime - prev->utime);
+	} else {
+		prev->stime = max(prev->stime, scaled_time);
+		prev->utime = max(prev->utime, rtime - prev->stime);
+	}
 
 	*ut = prev->utime;
 	*st = prev->stime;
-- 
1.7.1


