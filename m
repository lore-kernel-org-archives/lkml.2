Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615Ab0DSOoK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 10:44:10 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36623 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413Ab0DSOnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 10:43:52 -0400
Subject: Re: [RFC patch] CFS fix place entity spread issue (v2)
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg Kroah-Hartman <greg@kroah.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jarkko Nikula <jhnikula@gmail.com>, Tony Lindgren <tony@atomide.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100419140652.GA26853@Krystal>
References: <20100418131302.GA3614@Krystal>
	 <1271669135.1674.615.camel@laptop>  <20100419140652.GA26853@Krystal>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Apr 2010 16:43:46 +0200
Message-ID: <1271688226.1488.238.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-04-19 at 10:06 -0400, Mathieu Desnoyers wrote:

> place_entity(), when placing a sleeper on the runqueue, decrements its vruntime
> (derived from min_vruntime) from -= thresh (derived from load calculation). So
> if we end up with a task woken up that does not consume enough vruntime to pass
> the previous min_vruntime value, we effectively decrement min_vruntime.

No we don't, the next time it comes along it will at worst use the exact
same min_vruntime, but not a lower one.

> The other thing I am currently looking into is that, without even considering
> the question of going lower than min_vruntime, given that a woken up sleeper
> gets an extra share of vruntime (still because of place_entity), it might always
> run between -thresh to the previous min_runtime, therefore "stalling" the
> min_vruntime values at low values while other threads push the maximum vruntime
> higher, therefore increasing the spread. I'm currently doing some tests trying
> to cope with this by consuming woken up sleepers vruntime more quickly for a
> vruntime duration of "thresh".

But these things will break the wakeup-preemption, you cannot change
place_entity() without also considering
check_preempt_wakeup()->wakeup_preempt_entity().

> I am also testing alternatives ways to deal with the min_vruntime going backward

It doesn't go backwards!! Show me where min_vruntime actually decreases?
Sure can have entities that are left of min_vruntime, but that doesn't
mean min_vruntime decreases!

> problem, by keeping a "floor_vruntime", which ensures that place_entity() can
> never decrement min_vruntime below the floor value of its previous decrement.
> 
> Sorry for the missing changelog info, I was between planes this weekend.
> Hopefully my sleep-deprived explanation makes sense. ;)

None-what-so-ever ;-)


Now, theory says we should use the 0-lag point for task insertion, and I
have a patch that tracks that point, but it adds extra multiplications
to all the fast-paths, and I never really managed to make 0-lag
insertion work well with wakeup-preemption.


I've never really liked sleeper-fairness stuff from a theoretical pov.
but it does provide the 'interactive' stuff lots of things like (otoh it
also does cause some over-scheduling for some loads, and as you've seen
it rips the spread apart).


I also tried an avg_runtime based wakeup-preemption, where a task that
on average runs shorter than the currently running task will preempt
(within the wakeup_gran limits), but that also didn't work out --
although it did work for that one latency-tester app from Jens (IIRC)
that started that).

---
Subject: sched: avg_vruntime
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Fri, 24 Oct 2008 11:06:17 +0200

Renicing requires scaling the lag. Therefore we need a way to compute the it.
Lag is defined as the difference between the service time received from the
ideal model and the actual scheduler.

The defining property of a fair scheduler is that the sum of all lags is zero;
which can be seen is trivially true for the ideal case, as all lags are zero.

Therefore, the average of all virtual runtimes will be the point of zero lag.

We cannot prove fairness for CFS due to sleeper fairness (without it we can).
However since we can observe it does converge to fairness in stable operation,
we can say the zero lag point converges to the average.

We can't just take the average of vruntime - as it will use the full range
of its u64 and will wrap around. Instead we'll use the average of
(vruntime - min_vruntime)

\Sum_{i}^{n} 1/n (v_{i} - v) = 1/n (\Sum_{i}^{n} v_{i}) - vn

By factoring out the 1/n (never storing that) we avoid rounding, which
would bring an accumulating error.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20081024091109.832347739@chello.nl>
---
 kernel/sched.c       |    4 +++
 kernel/sched_debug.c |    3 ++
 kernel/sched_fair.c  |   60 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 66 insertions(+), 1 deletion(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -349,6 +349,10 @@ struct cfs_rq {
 	struct load_weight load;
 	unsigned long nr_running;
 
+	long nr_queued;
+	long avg_load;
+	s64 avg_vruntime;
+
 	u64 exec_clock;
 	u64 min_vruntime;
 
Index: linux-2.6/kernel/sched_debug.c
===================================================================
--- linux-2.6.orig/kernel/sched_debug.c
+++ linux-2.6/kernel/sched_debug.c
@@ -202,6 +202,9 @@ void print_cfs_rq(struct seq_file *m, in
 			SPLIT_NS(spread0));
 	SEQ_printf(m, "  .%-30s: %ld\n", "nr_running", cfs_rq->nr_running);
 	SEQ_printf(m, "  .%-30s: %ld\n", "load", cfs_rq->load.weight);
+	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "avg_vruntime",
+			SPLIT_NS(avg_vruntime(cfs_rq)));
+
 
 	SEQ_printf(m, "  .%-30s: %d\n", "nr_spread_over",
 			cfs_rq->nr_spread_over);
Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -301,6 +301,60 @@ static inline s64 entity_key(struct cfs_
 	return se->vruntime - cfs_rq->min_vruntime;
 }
 
+static void
+avg_vruntime_add(struct cfs_rq *cfs_rq, struct sched_entity *se)
+{
+	s64 key = entity_key(cfs_rq, se);
+	cfs_rq->avg_load += se->load.weight;
+	cfs_rq->avg_vruntime += key * se->load.weight;
+	cfs_rq->nr_queued++;
+}
+
+static void
+avg_vruntime_sub(struct cfs_rq *cfs_rq, struct sched_entity *se)
+{
+	s64 key = entity_key(cfs_rq, se);
+	cfs_rq->avg_load -= se->load.weight;
+	cfs_rq->avg_vruntime -= key * se->load.weight;
+	cfs_rq->nr_queued--;
+}
+
+static inline
+void avg_vruntime_update(struct cfs_rq *cfs_rq, s64 delta)
+{
+	cfs_rq->avg_vruntime -= cfs_rq->nr_queued * cfs_rq->avg_load * delta;
+}
+
+static u64 avg_vruntime(struct cfs_rq *cfs_rq)
+{
+	s64 avg = cfs_rq->avg_vruntime;
+	long nr_queued = cfs_rq->nr_queued;
+	long load = cfs_rq->avg_load;
+
+	if (cfs_rq->curr) {
+		nr_queued++;
+		avg += entity_key(cfs_rq, cfs_rq->curr);
+		load += cfs_rq->curr->load.weight;
+	}
+
+	if (nr_queued)
+		avg = div_s64(avg, nr_queued);
+
+	return cfs_rq->min_vruntime + avg;
+}
+
+static void __update_min_vruntime(struct cfs_rq *cfs_rq, u64 vruntime)
+{
+	/*
+	 * open coded max_vruntime() to allow updating avg_vruntime
+	 */
+	s64 delta = (s64)(vruntime - cfs_rq->min_vruntime);
+	if (delta > 0) {
+		avg_vruntime_update(cfs_rq, delta);
+		cfs_rq->min_vruntime = vruntime;
+	}
+}
+
 static void update_min_vruntime(struct cfs_rq *cfs_rq)
 {
 	u64 vruntime = cfs_rq->min_vruntime;
@@ -319,7 +373,7 @@ static void update_min_vruntime(struct c
 			vruntime = min_vruntime(vruntime, se->vruntime);
 	}
 
-	cfs_rq->min_vruntime = max_vruntime(cfs_rq->min_vruntime, vruntime);
+	__update_min_vruntime(cfs_rq, vruntime);
 }
 
 /*
@@ -333,6 +387,8 @@ static void __enqueue_entity(struct cfs_
 	s64 key = entity_key(cfs_rq, se);
 	int leftmost = 1;
 
+	avg_vruntime_add(cfs_rq, se);
+
 	/*
 	 * Find the right place in the rbtree:
 	 */
@@ -372,6 +428,8 @@ static void __dequeue_entity(struct cfs_
 	}
 
 	rb_erase(&se->run_node, &cfs_rq->tasks_timeline);
+
+	avg_vruntime_sub(cfs_rq, se);
 }
 
 static struct sched_entity *__pick_next_entity(struct cfs_rq *cfs_rq)


