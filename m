Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819Ab2DWOBh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 10:01:37 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43693 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577Ab2DWOBg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 10:01:36 -0400
Message-ID: <1335189664.28150.142.camel@twins>
Subject: Re: [PATCH 05/16] sched: SCHED_DEADLINE policy implementation.
From: Peter Zijlstra <peterz@infradead.org>
To: Juri Lelli <juri.lelli@gmail.com>
Cc: tglx@linutronix.de, mingo@redhat.com, rostedt@goodmis.org,
        cfriesen@nortel.com, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@ericsson.com,
        liming.wang@windriver.com, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 23 Apr 2012 16:01:04 +0200
In-Reply-To: <4F955B02.7040304@gmail.com>
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>
	   <1333696481-3433-6-git-send-email-juri.lelli@gmail.com>
	  <1335180743.28150.119.camel@twins> <4F954757.3020003@gmail.com>
	 <1335183740.28150.135.camel@twins> <4F955B02.7040304@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-23 at 15:37 +0200, Juri Lelli wrote:
> 
> This is what I got for that snippet:
> 
> ffffffff81062826 <enqueue_task_dl>:
> [...]
> ffffffff81062885:       49 03 44 24 20          add    0x20(%r12),%rax
> ffffffff8106288a:       49 8b 54 24 28          mov    0x28(%r12),%rdx
> ffffffff8106288f:       49 01 54 24 38          add    %rdx,0x38(%r12)
> ffffffff81062894:       49 89 44 24 30          mov    %rax,0x30(%r12)
> ffffffff81062899:       49 8b 44 24 30          mov    0x30(%r12),%rax
> ffffffff8106289e:       48 85 c0                test   %rax,%rax
> ffffffff810628a1:       7e e2                   jle    ffffffff81062885 <enqueue_task_dl+0x5f>
> 
> So it seems we are fine in this case, right?

Yep.

> It is anyway better to enforce this Gcc behaviour, just to be
> on the safe side? 

Dunno, the 'fix' is somewhat hideous (although we could make it suck
less), we've only ever bothered with it if caused problems, so I guess
we'll just wait and see until it breaks.


---
Subject: kernel,sched,time: Clean up gcc work-arounds
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Mon Apr 23 15:55:48 CEST 2012

We've grown various copies of a particular gcc work-around, consolidate
them into one and add a larger comment.

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

