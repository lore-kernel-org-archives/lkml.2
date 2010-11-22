Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630Ab0KVE32 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 23:29:28 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:39551 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756511Ab0KVE31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 23:29:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=k8ATcIB0bdpdLRu2BXSuCqUOnrMPi0fCOHSKb38xRiJ9iHBR9OUvysOZFFLjn3dReh
         vzlE8tLnHVqeohcp1w+Ex5N9HL4j8X36B9aBTiKXdQlC2WsDN4cW4J+gTTxi4YDpDgPi
         JUtxZ6rAE3rPlUBV7/Lhp91WqdHVY/jnhdBGc=
Date: Sun, 21 Nov 2010 23:29:23 -0500 (EST)
From: "Bjoern B. Brandenburg" <bbb.lst@gmail.com>
X-X-Sender: bbb@jupiter-cs.cs.unc.edu
To: Mike Galbraith <efault@gmx.de>
cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Andrea Bastoni <bastoni@sprg.uniroma2.it>,
        "James H. Anderson" <anderson@cs.unc.edu>,
        linux-kernel@vger.kernel.org
Subject: Re: Scheduler bug related to rq->skip_clock_update?
In-Reply-To: <1290359641.4816.69.camel@maggy.simson.net>
Message-ID: <alpine.LNX.2.00.1011212327250.8927@jupiter-cs.cs.unc.edu>
References: <alpine.LNX.2.00.1011202315290.8927@jupiter-cs.cs.unc.edu> <1290359641.4816.69.camel@maggy.simson.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Nov 2010, Mike Galbraith wrote:

> On Sat, 2010-11-20 at 23:22 -0500, Bjoern B. Brandenburg wrote:
>
> > I was under the impression that, as an invariant, tasks should not have
> > TIF_NEED_RESCHED set after they've blocked. In this case, the idle load
> > balancer should not mark the task that's on its way out with
> > set_tsk_need_resched().
>
> Nice find.
>
> > In any case, check_preempt_curr() seems to assume that a resuming task cannot
> > have TIF_NEED_RESCHED already set. Setting skip_clock_update on a remote CPU
> > that hasn't even been notified via IPI seems wrong.
>
> Yes. Does the below fix it up for you?

The patch definitely changes the behavior, but it doesn't seem to solve (all
of) the root cause(s). The failsafe kicks in and clears the flag the next
time that update_rq_clock() is called, but there can still be a significant
delay between setting and clearing the flag. Right after boot, I'm now seeing
values that go up to ~21ms.

> bbb@district10:~$ egrep 'cpu#|skip' /proc/sched_debug
> cpu#0
>   .skip_clock_max                : 18279250
> cpu#1
>   .skip_clock_max                : 17190250
> cpu#2
>   .skip_clock_max                : 9292875
> cpu#3
>   .skip_clock_max                : 21760250

Resetting the values in a (mostly) idle system yields delays up to ~8.4ms.

> rq CPU0 skip_clock_max=8403000 skip_clock_count=465
> rq CPU1 skip_clock_max=3605375 skip_clock_count=90
> rq CPU2 skip_clock_max=1007375 skip_clock_count=529
> rq CPU3 skip_clock_max=6248500 skip_clock_count=197

If I let it run for a while with a couple 'find /' and 'top' processes in the
background, I'm seeing delays close to 10ms.

> rq CPU0 skip_clock_max=9893500 skip_clock_count=56779
> rq CPU1 skip_clock_max=9916750 skip_clock_count=48852
> rq CPU2 skip_clock_max=9915500 skip_clock_count=49279
> rq CPU3 skip_clock_max=9920500 skip_clock_count=53311

It makes sense for the maximum skip time to converge to 10ms since
HZ=100 on the ARM test system, so after at most 10ms scheduler_tick() should
kick in and call update_rq_clock().

I'm also seeing similar delays on an 8-core x86_64 system with HZ=1000. With
a workload of 'make clean && make -j8 bzImage' and 'top' I get stable delays
after boot in the range of 1ms and a max delay of ~53ms during boot (the
field skip_clock_recent_max resets to zero every 10000 samples;
skip_clock_max tracks the all-time max since the processor came online).

> bbb@koruna:~$ egrep 'cpu#|skip' /proc/sched_debug
> cpu#0, 2493.662 MHz
>   .skip_clock_count              : 32302
>   .skip_clock_recent_max         : 997011
>   .skip_clock_max                : 40643460
> cpu#1, 2493.662 MHz
>   .skip_clock_count              : 32798
>   .skip_clock_recent_max         : 1000658
>   .skip_clock_max                : 35074109
> cpu#2, 2493.662 MHz
>   .skip_clock_count              : 27984
>   .skip_clock_recent_max         : 1001603
>   .skip_clock_max                : 16167011
> cpu#3, 2493.662 MHz
>   .skip_clock_count              : 28153
>   .skip_clock_recent_max         : 1000482
>   .skip_clock_max                : 19163454
> cpu#4, 2493.662 MHz
>   .skip_clock_count              : 29903
>   .skip_clock_recent_max         : 995757
>   .skip_clock_max                : 14243617
> cpu#5, 2493.662 MHz
>   .skip_clock_count              : 28690
>   .skip_clock_recent_max         : 1001300
>   .skip_clock_max                : 46856516
> cpu#6, 2493.662 MHz
>   .skip_clock_count              : 28011
>   .skip_clock_recent_max         : 994878
>   .skip_clock_max                : 53438801
> cpu#7, 2493.662 MHz
>   .skip_clock_count              : 26531
>   .skip_clock_recent_max         : 997352
>   .skip_clock_max                : 19271672

The patch below applies on top of yours and should reproduce the behavior.

Please let me know if there is something else that I should test.

Thanks,
Bjoern

---
sched: show length of runqueue clock deactivation in /proc/sched_debug

The runqueue clock update should obviously not be skipped for
prolonged times (otherwise the consumed time is not correctly kept
track of). This patch measures the time between setting and clearing
the rq->skip_clock_update flag. The maximum observed value is exported
in /proc/sched_debug.
---
 kernel/sched.c       |   21 ++++++++++++++++++++-
 kernel/sched_debug.c |    4 ++++
 2 files changed, 24 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 996ed5c..21c1525 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -541,6 +541,11 @@ struct rq {
 	unsigned long long rq_cpu_time;
 	/* could above be rq->cfs_rq.exec_clock + rq->rt_rq.rt_runtime ? */

+	u64 skip_clock_max;
+	u64 skip_clock_recent_max;
+	u64 skip_clock_set;
+	unsigned int skip_clock_count;
+
 	/* sys_sched_yield() stats */
 	unsigned int yld_count;

@@ -653,6 +658,17 @@ inline void update_rq_clock(struct rq *rq)
 		sched_irq_time_avg_update(rq, irq_time);
 	}

+#ifdef CONFIG_SCHEDSTATS
+	if (unlikely(rq->skip_clock_update)) {
+		u64 skipped = sched_clock_cpu(cpu_of(rq)) - rq->skip_clock_set;
+		rq->skip_clock_max = max(rq->skip_clock_max, skipped);
+		/* reset infrequently to expose changes */
+		if (!(++rq->skip_clock_count % 10000))
+			rq->skip_clock_recent_max = 0;
+		rq->skip_clock_recent_max = max(rq->skip_clock_recent_max,
+						skipped);
+	}
+#endif
 	rq->skip_clock_update = 0;
 }

@@ -2131,8 +2147,11 @@ static void check_preempt_curr(struct rq *rq, struct task_struct *p, int flags)
 	 * A queue event has occurred, and we're going to schedule.  In
 	 * this case, we can save a useless back to back clock update.
 	 */
-	if (test_tsk_need_resched(rq->curr))
+	if (test_tsk_need_resched(rq->curr)) {
+		schedstat_set(rq->skip_clock_set,
+			      sched_clock_cpu(cpu_of(rq)));
 		rq->skip_clock_update = 1;
+	}
 }

 #ifdef CONFIG_SMP
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index 2e1b0d1..8924be2 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -298,6 +298,10 @@ static void print_cpu(struct seq_file *m, int cpu)

 	P(bkl_count);

+	P(skip_clock_count);
+	P64(skip_clock_recent_max);
+	P64(skip_clock_max);
+
 #undef P
 #endif
 	print_cfs_stats(m, cpu);
-- 
1.7.3.1

