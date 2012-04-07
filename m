Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846Ab2DGJyz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2012 05:54:55 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:55101 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752463Ab2DGJyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2012 05:54:54 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19CREwtBkhCsFvfxVcJcDTUJPYxiZnudlCKdNNZUt
	vmJl8A2ldJqpCP
Message-ID: <1333792489.12677.58.camel@marge.simpson.net>
Subject: RFC [patch] sched,cgroup_sched: convince RT_GROUP_SCHED throttle to
 work
From: Mike Galbraith <efault@gmx.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>
Date: Sat, 07 Apr 2012 11:54:49 +0200
In-Reply-To: <1333789124.12677.15.camel@marge.simpson.net>
References: <1333444106.9072.4.camel@marge.simpson.net>
	 <1333444788.9072.9.camel@marge.simpson.net>
	 <1333789124.12677.15.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

I'm having trouble with RT_GROUP_SCHED throttle kicking in and staying
engaged (timer troubles).  Either groups execute one after the other
(frob timer above you), or bandwidth is wrong, or the reason I started
squabbling with this thing in the first place happens, one or the other
group gets stuck, even with only two groups, with the root task group
throttled, and the victim is marooned until I kill the cgroup setup.  If
(say) grp1 starts first, grp2 is screwed, or the other way around.

With this patch, the thing appears to work perfectly, but it doesn't
look correct, since I'm futzing with ->rt_time where I should not.

Not so pretty ascii-art:

/----------/system cpu 0-2, rt 300000-----/foo cpu 2, rt 100000
    \
     \
      \----/rtcpus cpu 3, rt 300000---\---/bar cpu 3, rt 100000
                                       \
                                        \-/baz cpu 3, rt 100000

It only needs to be two groups, grp1 containing most of the system, the
other rt only.  With the patch, the above setup works (last setup I
prodded box with), and bandwidth looked fine, twiddle budgets or not.

I just happened to notice the throttle wasn't doing it's thing right
after discovering that isolcpus is busted with RT_GROUP_SCHED.  Thought
I should probably beat on it a little.  The darn thing beat me back :)

---
 kernel/sched/rt.c |   76 +++++++++++++++++++++++++++++++-----------------------
 1 file changed, 45 insertions(+), 31 deletions(-)

--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -776,55 +776,69 @@ static inline int balance_runtime(struct
 }
 #endif /* CONFIG_SMP */
 
+#ifdef CONFIG_RT_GROUP_SCHED
+#define for_each_rt_rq_up_from(rt_rq, iter, rq)			\
+	for (iter = rt_rq->tg; iter; iter = iter->parent,	\
+		rt_rq = iter ? iter->rt_rq[cpu_of(rq)] : NULL)
+#else
+#define for_each_rt_rq_up_from(rt_rq, iter, rq)			\
+	for (iter = rt_rq; iter; iter = NULL)
+#endif
+
 static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun)
 {
 	int i, idle = 1, throttled = 0;
 	const struct cpumask *span;
+	rt_rq_iter_t iter;
 
 	span = sched_rt_period_mask();
 	for_each_cpu(i, span) {
-		int enqueue = 0;
+		int enqueue = 0, depth = 0;
 		struct rt_rq *rt_rq = sched_rt_period_rt_rq(rt_b, i);
-		struct rq *rq = rq_of_rt_rq(rt_rq);
+		struct rq *rq = cpu_rq(i);
 
 		raw_spin_lock(&rq->lock);
-		if (rt_rq->rt_time) {
-			u64 runtime;
-
-			raw_spin_lock(&rt_rq->rt_runtime_lock);
-			if (rt_rq->rt_throttled)
-				balance_runtime(rt_rq);
-			runtime = rt_rq->rt_runtime;
-			rt_rq->rt_time -= min(rt_rq->rt_time, overrun*runtime);
-			if (rt_rq->rt_throttled && rt_rq->rt_time < runtime) {
-				rt_rq->rt_throttled = 0;
+		for_each_rt_rq_up_from(rt_rq, iter, rq) {
+			if (rt_rq->rt_time) {
+				u64 runtime;
+
+				raw_spin_lock(&rt_rq->rt_runtime_lock);
+				if (rt_rq->rt_throttled)
+					balance_runtime(rt_rq);
+				runtime = rt_rq->rt_runtime;
+				rt_rq->rt_time -= min(rt_rq->rt_time, overrun*runtime);
+				if (rt_rq->rt_throttled && rt_rq->rt_time < runtime) {
+					rt_rq->rt_throttled = 0;
+					enqueue = 1;
+
+					/*
+					 * Force a clock update if the CPU was idle,
+					 * lest wakeup -> unthrottle time accumulate.
+					 */
+					if (rt_rq->rt_nr_running && rq->curr == rq->idle)
+						rq->skip_clock_update = -1;
+				}
+				raw_spin_unlock(&rt_rq->rt_runtime_lock);
+			} else if (!rt_rq_throttled(rt_rq))
 				enqueue = 1;
 
-				/*
-				 * Force a clock update if the CPU was idle,
-				 * lest wakeup -> unthrottle time accumulate.
-				 */
-				if (rt_rq->rt_nr_running && rq->curr == rq->idle)
-					rq->skip_clock_update = -1;
+			if (enqueue)
+				sched_rt_rq_enqueue(rt_rq);
+
+			if (!depth++) {
+				if (rt_rq->rt_throttled) {
+					throttled = 1;
+					idle = 0;
+				} else if (rt_rq->rt_time || rt_rq->rt_nr_running)
+					idle = 0;
 			}
-			if (rt_rq->rt_time || rt_rq->rt_nr_running)
-				idle = 0;
-			raw_spin_unlock(&rt_rq->rt_runtime_lock);
-		} else if (rt_rq->rt_nr_running) {
-			idle = 0;
-			if (!rt_rq_throttled(rt_rq))
-				enqueue = 1;
-		}
-		if (rt_rq->rt_throttled)
-			throttled = 1;
 
-		if (enqueue)
-			sched_rt_rq_enqueue(rt_rq);
+		}
 		raw_spin_unlock(&rq->lock);
 	}
 
 	if (!throttled && (!rt_bandwidth_enabled() || rt_b->rt_runtime == RUNTIME_INF))
-		return 1;
+		idle = 1;
 
 	return idle;
 }


