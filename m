Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698Ab2DXQZn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 12:25:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:47645 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756681Ab2DXQZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 12:25:40 -0400
Message-Id: <20120424162224.454623618@chello.nl>
User-Agent: quilt/0.48-1
Date: Tue, 24 Apr 2012 18:10:40 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Juri Lelli <juri.lelli@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 1/3] kernel,sched,time: Clean up gcc work-arounds
References: <20120424161039.293018424@chello.nl>
Content-Disposition: inline; filename=kernel-vs-gcc-while.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've grown various copies of a particular gcc work-around,
consolidate them into one and add a larger comment.

Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/compiler.h |   12 ++++++++++++
 include/linux/math64.h   |    4 +---
 kernel/sched/core.c      |    8 ++------
 kernel/sched/fair.c      |    8 ++------
 kernel/time.c            |   11 ++++-------
 5 files changed, 21 insertions(+), 22 deletions(-)

--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -310,4 +310,16 @@ void ftrace_likely_update(struct ftrace_
  */
 #define ACCESS_ONCE(x) (*(volatile typeof(x) *)&(x))
 
+/*
+ * Avoid gcc loop optimization by clobbering a variable, forcing a reload
+ * and invalidating the optimization.
+ *
+ * The optimization in question transforms various loops into divisions/modulo
+ * operations, this is a problem when either the resulting operation generates
+ * unimplemented libgcc functions (u64 divisions for example) or the loop is
+ * known not to contain a lot of iterations and the division is in fact more
+ * expensive.
+ */
+#define __gcc_dont_optimize_loop(var) asm("" "+rm" (var))
+
 #endif /* __LINUX_COMPILER_H */
--- a/include/linux/math64.h
+++ b/include/linux/math64.h
@@ -105,9 +105,7 @@ __iter_div_u64_rem(u64 dividend, u32 div
 	u32 ret = 0;
 
 	while (dividend >= divisor) {
-		/* The following asm() prevents the compiler from
-		   optimising this loop into a modulo operation.  */
-		asm("" : "+rm"(dividend));
+		__gcc_dont_optimize_loop(dividend);
 
 		dividend -= divisor;
 		ret++;
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -628,12 +628,8 @@ void sched_avg_update(struct rq *rq)
 	s64 period = sched_avg_period();
 
 	while ((s64)(rq->clock - rq->age_stamp) > period) {
-		/*
-		 * Inline assembly required to prevent the compiler
-		 * optimising this loop into a divmod call.
-		 * See __iter_div_u64_rem() for another example of this.
-		 */
-		asm("" : "+rm" (rq->age_stamp));
+		__gcc_dont_optimize_loop(rq->age_stamp);
+
 		rq->age_stamp += period;
 		rq->rt_avg /= 2;
 	}
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -853,12 +853,8 @@ static void update_cfs_load(struct cfs_r
 		update_cfs_rq_load_contribution(cfs_rq, global_update);
 
 	while (cfs_rq->load_period > period) {
-		/*
-		 * Inline assembly required to prevent the compiler
-		 * optimising this loop into a divmod call.
-		 * See __iter_div_u64_rem() for another example of this.
-		 */
-		asm("" : "+rm" (cfs_rq->load_period));
+		__gcc_dont_optimize_loop(cfs_rq->load_period);
+
 		cfs_rq->load_period /= 2;
 		cfs_rq->load_avg /= 2;
 	}
--- a/kernel/time.c
+++ b/kernel/time.c
@@ -349,17 +349,14 @@ EXPORT_SYMBOL(mktime);
 void set_normalized_timespec(struct timespec *ts, time_t sec, s64 nsec)
 {
 	while (nsec >= NSEC_PER_SEC) {
-		/*
-		 * The following asm() prevents the compiler from
-		 * optimising this loop into a modulo operation. See
-		 * also __iter_div_u64_rem() in include/linux/time.h
-		 */
-		asm("" : "+rm"(nsec));
+		__gcc_dont_optimize_loop(nsec);
+
 		nsec -= NSEC_PER_SEC;
 		++sec;
 	}
 	while (nsec < 0) {
-		asm("" : "+rm"(nsec));
+		__gcc_dont_optimize_loop(nsec);
+
 		nsec += NSEC_PER_SEC;
 		--sec;
 	}


