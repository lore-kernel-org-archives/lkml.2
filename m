Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546Ab1DVIVl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 04:21:41 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:55016 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752380Ab1DVIVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 04:21:36 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18r/7clkBkr0+hXPvs1W+oinkB2cefUKsq0FXaYtE
	TUA7mxhyn+C0Lf
Subject: Re: rt scheduler may calculate wrong rt_time
From: Mike Galbraith <efault@gmx.de>
To: Thomas Giesel <skoe@directbox.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <20110421145510.28cb7b78@skoe.de>
References: <20110421145510.28cb7b78@skoe.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Apr 2011 10:21:31 +0200
Message-ID: <1303460491.28545.12.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-21 at 14:55 +0200, Thomas Giesel wrote:
> Friends of the scheduler,
> 
> I found that the current (well, at least 2.6.38) scheduler calculates a
> wrong rt_time for realtime tasks in certain situations.
> 
> Example scenario:
> - HZ = 1000, rt_runtime = 95 ms, rt_period = 100 ms (similar with other
>   setups, but that's what I did)
> - a high priority rt task (A) gets packets from Ethernet about every 10
>   ms
> - a low priority rt task (B) unfortunately runs for a longer time
>   (here: endlessly :)
> - no other tasks running (i.e. about 5 ms idle left per period)
> 
> When the runtime of the realtime tasks is exceeded (e.g. by (B)), they
> are throttled. During this time idle is scheduled. When in idle,
> tick_nohz_stop_sched_tick() will stop the scheduler tick, which causes
> update_rq_clock() _not_ to be called for a while. When a realtime task
> is woken up during this time (e.g. (A) by network traffic),
> update_rq_clock() is called from enqueue_task(). The task is not picked
> yet, because it is still throttled. After a while
> sched_rt_period_timer() unthrottles the realtime tasks and cpu_idle
> will call schedule().
> 
> schedule() picks (A) which has been woken up a while ago.
> _pick_next_task_rt() sets exec_start to rq->clock_task. But this has
> been updated last time when the task was woken up, which could have
> been up to 5 ms ago in my example. So exec_start contains a time
> _before_ the task was actually started. As a result of this, rt_time is
> calculated too large which makes the rt tasks being throttled even
> earlier in the next period. This error may even increase from interval
> to interval, because the throttle-window (initially 5 ms) also
> increases.
> 
> IMHO the best place to update clock_task would be to call a function
> from tick_nohz_restart_sched_tick(). But currently I don't see a
> suitable interface to the scheduler to do this. Currently I call
> update_rq_clock(rq) just before put_prev_task() in schedule(). This
> solves the issue and causes rt_runtime to be kept quite accurately.
> (Well, same result would be to remove "if (...)" in put_prev_task())

Hm.  Does forcing a clock update if we're idle when we release the
throttle do the trick?

diff --git a/kernel/sched.c b/kernel/sched.c
index 8cb0a57..97245ef 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -464,7 +464,7 @@ struct rq {
 	u64 nohz_stamp;
 	unsigned char nohz_balance_kick;
 #endif
-	unsigned int skip_clock_update;
+	int skip_clock_update;
 
 	/* capture load from *all* tasks on this cpu: */
 	struct load_weight load;
@@ -650,7 +650,7 @@ static void update_rq_clock(struct rq *rq)
 {
 	s64 delta;
 
-	if (rq->skip_clock_update)
+	if (rq->skip_clock_update > 0)
 		return;
 
 	delta = sched_clock_cpu(cpu_of(rq)) - rq->clock;
@@ -4131,7 +4131,7 @@ static inline void schedule_debug(struct task_struct *prev)
 
 static void put_prev_task(struct rq *rq, struct task_struct *prev)
 {
-	if (prev->on_rq)
+	if (prev->on_rq || rq->skip_clock_update < 0)
 		update_rq_clock(rq);
 	prev->sched_class->put_prev_task(rq, prev);
 }
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 19ecb31..3276b94 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -572,8 +572,15 @@ static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun)
 				enqueue = 1;
 		}
 
-		if (enqueue)
+		if (enqueue) {
+			/*
+			 * Tag a forced clock update if we're coming out of idle
+			 * so rq->clock_task will be updated when we schedule().
+			 */
+			if (rq->curr == rq->idle)
+				rq->skip_clock_update = -1;
 			sched_rt_rq_enqueue(rt_rq);
+		}
 		raw_spin_unlock(&rq->lock);
 	}
 



