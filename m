Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919Ab1D2Ggz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 02:36:55 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:56696 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754245Ab1D2Ggy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 02:36:54 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18s7BEqM4EspBi6TjA89cSW83WIF+vPME1t24obtP
	AL73p4b/caLi3e
Subject: [patch] Re: rt scheduler may calculate wrong rt_time
From: Mike Galbraith <efault@gmx.de>
To: Thomas Giesel <skoe@directbox.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <20110427195113.4e0064bb@acer>
References: <20110421145510.28cb7b78@skoe.de>
	 <1303460491.28545.12.camel@marge.simson.net> <20110427195113.4e0064bb@acer>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Apr 2011 08:36:50 +0200
Message-ID: <1304059010.7472.1.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-27 at 19:51 +0200, Thomas Giesel wrote:
> > Hm.  Does forcing a clock update if we're idle when we release the
> > throttle do the trick?
> 
> It does. I tested it today and it works as expected. Even with ftrace I
> couldn't see any suspicious behaviour anymore.
> 
> Mike: Can you send the patch to the right people to get it into the
> kernel or should I do it? Or is Peter the right one already?

Peter is the right one.  Below is an ever so slightly different version.

sched, rt: update rq clock when unthrottling of an otherwise idle CPU

If an RT task is awakened while it's rt_rq is throttled, the time between
wakeup/enqueue and unthrottle/selection may be accounted as rt_time
if the CPU is idle.  Set rq->skip_clock_update negative upon throttle
release to tell put_prev_task() that we need a clock update.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Reported-by: Thomas Giesel <skoe@directbox.com>

---
 kernel/sched.c    |    6 +++---
 kernel/sched_rt.c |    7 +++++++
 2 files changed, 10 insertions(+), 3 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -464,7 +464,7 @@ struct rq {
 	u64 nohz_stamp;
 	unsigned char nohz_balance_kick;
 #endif
-	unsigned int skip_clock_update;
+	int skip_clock_update;
 
 	/* capture load from *all* tasks on this cpu: */
 	struct load_weight load;
@@ -650,7 +650,7 @@ static void update_rq_clock(struct rq *r
 {
 	s64 delta;
 
-	if (rq->skip_clock_update)
+	if (rq->skip_clock_update > 0)
 		return;
 
 	delta = sched_clock_cpu(cpu_of(rq)) - rq->clock;
@@ -4125,7 +4125,7 @@ static inline void schedule_debug(struct
 
 static void put_prev_task(struct rq *rq, struct task_struct *prev)
 {
-	if (prev->on_rq)
+	if (prev->on_rq || rq->skip_clock_update < 0)
 		update_rq_clock(rq);
 	prev->sched_class->put_prev_task(rq, prev);
 }
Index: linux-2.6/kernel/sched_rt.c
===================================================================
--- linux-2.6.orig/kernel/sched_rt.c
+++ linux-2.6/kernel/sched_rt.c
@@ -562,6 +562,13 @@ static int do_sched_rt_period_timer(stru
 			if (rt_rq->rt_throttled && rt_rq->rt_time < runtime) {
 				rt_rq->rt_throttled = 0;
 				enqueue = 1;
+
+				/*
+				 * Force a clock update if the CPU was idle,
+				 * lest wakeup -> unthrottle time accumulate.
+				 */
+				if (rt_rq->rt_nr_running && rq->curr == rq->idle)
+					rq->skip_clock_update = -1;
 			}
 			if (rt_rq->rt_time || rt_rq->rt_nr_running)
 				idle = 0;


