Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035Ab1GUK62 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 06:58:28 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34167 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973Ab1GUK60 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 06:58:26 -0400
Subject: [RFC][PATCH] perf: Cure the context switch optimization
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, Paul Turner <pjt@google.com>,
        Lin Ming <minggr@gmail.com>, Stephane Eranian <eranian@google.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, paulus <paulus@samba.org>,
        Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 21 Jul 2011 12:57:49 +0200
Message-ID: <1311245869.29152.121.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Aside from the very cheery changelog on the below patch, it does
something very weird indeed, I've been staring at it on and off for the
past months but can't seem to spot the (probably trivial) mistake.

A kernel with the patch applied offers the following 'feature':

$ taskset 1 perf stat --repeat 10 make kernel -j128

 Performance counter stats for 'make O=westmere-build kernel -j128' (10 runs):

        154.128844 task-clock                #    0.101 CPUs utilized            ( +- 97.87% )
               100 context-switches          #    0.001 M/sec                    ( +- 92.92% )
                 0 CPU-migrations            #    0.000 M/sec                    ( +-100.00% )
            17,315 page-faults               #    0.112 M/sec                    ( +- 95.25% )
       449,946,976 cycles                    #    2.919 GHz                      ( +- 97.92% )
       158,294,954 stalled-cycles-frontend   #   35.18% frontend cycles idle     ( +- 97.09% )
        81,976,126 stalled-cycles-backend    #   18.22% backend  cycles idle     ( +- 96.40% )
       607,676,028 instructions              #    1.35  insns per cycle        
                                             #    0.26  stalled cycles per insn  ( +- 98.56% )
       126,479,710 branches                  #  820.610 M/sec                    ( +- 98.49% )
         3,381,265 branch-misses             #    2.67% of all branches          ( +- 97.92% )

       1.522814732 seconds time elapsed                                          ( +-  0.19% )

See those totally ridiculous stdev numbers, these are caused by
(obtained from perf stat -v output):

$ grep task-clock stat.log
task-clock: 3556075 3556075 3556075
task-clock: 3247072 3247072 3247072
task-clock: 3224954 3224954 3224954
task-clock: 3300664 3300664 3300664
task-clock: 3246115 3246115 3246115
task-clock: 3250695 3250695 3250695
task-clock: 3279908 3279908 3279908
task-clock: 3235312 3235312 3235312
task-clock: 1511715951 1511715951 1511715951
task-clock: 3231690 3231690 3231690

Which suggests there's something going going wrong with the folding back
the inherited counter value into the parent counter.

It takes a bit to reproduce on my machine, but Ingo is king at
reproducing this and gets results like:

task-clock: 11511929686 11511929686 11511929686
task-clock: 11558456160 11558456160 11558456160
task-clock: 96314987 96314987 96314987
task-clock: 11626224609 11626224609 11626224609
task-clock: 11617826792 11617826792 11617826792
task-clock: 108555025 108555025 108555025
task-clock: 11394346454 11394346454 11394346454
task-clock: 61045813 61045813 61045813
task-clock: 11555885469 11555885469 11555885469
task-clock: 11542959135 11542959135 11542959135

On a very regular basis.

---
Subject: perf: Cure the context switch optimization
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Sat May 21 09:20:36 2011 +0200

The generation counts were mismanaged, this caused us to not
do the lazy PMU context switch optimization in many cases.

This caused overhead in heavily context switching workloads.

For example:

$ perf stat perf bench sched pipe
# Running sched/pipe benchmark...
# Executed 1000000 pipe operations between two tasks

 Total time: 17.724 [sec]

  17.724428 usecs/op
      56419 ops/sec

Performance counter stats for 'perf bench sched pipe':

   9395.469517 task-clock                #    0.530 CPUs utilized
     2,000,043 context-switches          #    0.213 M/sec

Baseline scheduling overhead (without PMU overhead) is:

$ perf bench sched pipe
# Running sched/pipe benchmark...
# Executed 1000000 pipe operations between two tasks

 Total time: 6.908 [sec]

   6.908246 usecs/op
     144754 ops/sec

With the fix applied the overhead goes away and we are fast again:

$ perf stat perf bench sched pipe
# Running sched/pipe benchmark...
# Executed 1000000 pipe operations between two tasks

 Total time: 6.909 [sec]

   6.909234 usecs/op
     144733 ops/sec

Performance counter stats for 'perf bench sched pipe':

   9438.132883 task-clock                #    0.531 CPUs utilized
     2,000,042 context-switches          #    0.213 M/sec

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-6fro8jq09u38u8jplzowhlgl@git.kernel.org
---
 include/linux/perf_event.h |    5 ++
 kernel/events/core.c       |   78 +++++++++++++++++++++++++++++++++++++++------
 2 files changed, 73 insertions(+), 10 deletions(-)

Index: linux-2.6/include/linux/perf_event.h
===================================================================
--- linux-2.6.orig/include/linux/perf_event.h
+++ linux-2.6/include/linux/perf_event.h
@@ -729,6 +729,11 @@ struct swevent_hlist {
 #define PERF_ATTACH_GROUP	0x02
 #define PERF_ATTACH_TASK	0x04
 
+#define PERF_INHERITED_EVENT	0x08
+#define PERF_COLLECTED_EVENT	0x10
+#define PERF_READ_EVENT		0x20
+
+
 #ifdef CONFIG_CGROUP_PERF
 /*
  * perf_cgroup_info keeps track of time_enabled for a cgroup.
Index: linux-2.6/kernel/events/core.c
===================================================================
--- linux-2.6.orig/kernel/events/core.c
+++ linux-2.6/kernel/events/core.c
@@ -599,10 +599,13 @@ static void put_ctx(struct perf_event_co
 
 static void unclone_ctx(struct perf_event_context *ctx)
 {
+	trace_printk("ctx-unclone: %p\n", ctx);
+
 	if (ctx->parent_ctx) {
 		put_ctx(ctx->parent_ctx);
 		ctx->parent_ctx = NULL;
-	}
+	} else
+		ctx->generation++;
 }
 
 static u32 perf_event_pid(struct perf_event *event, struct task_struct *p)
@@ -823,6 +826,8 @@ list_add_event(struct perf_event *event,
 	ctx->nr_events++;
 	if (event->attr.inherit_stat)
 		ctx->nr_stat++;
+
+	ctx->generation++;
 }
 
 /*
@@ -976,6 +981,8 @@ list_del_event(struct perf_event *event,
 	 */
 	if (event->state > PERF_EVENT_STATE_OFF)
 		event->state = PERF_EVENT_STATE_OFF;
+
+	ctx->generation++;
 }
 
 static void perf_group_detach(struct perf_event *event)
@@ -1129,6 +1136,8 @@ static void perf_remove_from_context(str
 	struct perf_event_context *ctx = event->ctx;
 	struct task_struct *task = ctx->task;
 
+	trace_printk("event: %p from: %p\n", event, ctx);
+
 	lockdep_assert_held(&ctx->mutex);
 
 	if (!task) {
@@ -1552,6 +1561,8 @@ perf_install_in_context(struct perf_even
 
 	event->ctx = ctx;
 
+	trace_printk("event: %p in: %p\n", event, ctx);
+
 	if (!task) {
 		/*
 		 * Per cpu events are installed via an smp call and
@@ -1798,9 +1809,20 @@ static void ctx_sched_out(struct perf_ev
 static int context_equiv(struct perf_event_context *ctx1,
 			 struct perf_event_context *ctx2)
 {
-	return ctx1->parent_ctx && ctx1->parent_ctx == ctx2->parent_ctx
-		&& ctx1->parent_gen == ctx2->parent_gen
-		&& !ctx1->pin_count && !ctx2->pin_count;
+	if (ctx1->pin_count || ctx2->pin_count)
+		return 0;
+
+	if (ctx1 == ctx2->parent_ctx && ctx1->generation == ctx2->parent_gen)
+		return 1;
+
+	if (ctx1->parent_ctx == ctx2 && ctx1->parent_gen == ctx2->generation)
+		return 1;
+
+	if (ctx1->parent_ctx && ctx1->parent_ctx == ctx2->parent_ctx &&
+			ctx1->parent_gen == ctx2->parent_gen)
+		return 1;
+
+	return 0;
 }
 
 static void __perf_event_sync_stat(struct perf_event *event,
@@ -1883,7 +1905,7 @@ static void perf_event_context_sched_out
 {
 	struct perf_event_context *ctx = task->perf_event_ctxp[ctxn];
 	struct perf_event_context *next_ctx;
-	struct perf_event_context *parent;
+	struct perf_event_context *parent, *next_parent;
 	struct perf_cpu_context *cpuctx;
 	int do_switch = 1;
 
@@ -1895,10 +1917,14 @@ static void perf_event_context_sched_out
 		return;
 
 	rcu_read_lock();
-	parent = rcu_dereference(ctx->parent_ctx);
 	next_ctx = next->perf_event_ctxp[ctxn];
-	if (parent && next_ctx &&
-	    rcu_dereference(next_ctx->parent_ctx) == parent) {
+	if (!next_ctx)
+		goto unlock;
+
+	parent = rcu_dereference(ctx->parent_ctx);
+	next_parent = rcu_dereference(next_ctx->parent_ctx);
+
+	if (next_parent == ctx || next_ctx == parent || next_parent == parent) {
 		/*
 		 * Looks like the two contexts are clones, so we might be
 		 * able to optimize the context switch.  We lock both
@@ -1911,6 +1937,11 @@ static void perf_event_context_sched_out
 		raw_spin_lock(&ctx->lock);
 		raw_spin_lock_nested(&next_ctx->lock, SINGLE_DEPTH_NESTING);
 		if (context_equiv(ctx, next_ctx)) {
+
+			trace_printk("flipping: %d:%p <-> %d:%p\n",
+					task->pid, ctx,
+					next->pid, next_ctx);
+
 			/*
 			 * XXX do we need a memory barrier of sorts
 			 * wrt to rcu_dereference() of perf_event_ctxp
@@ -1926,9 +1957,11 @@ static void perf_event_context_sched_out
 		raw_spin_unlock(&next_ctx->lock);
 		raw_spin_unlock(&ctx->lock);
 	}
+unlock:
 	rcu_read_unlock();
 
 	if (do_switch) {
+		trace_printk("sched_out: %d:%p\n", task->pid, ctx);
 		ctx_sched_out(ctx, cpuctx, EVENT_ALL);
 		cpuctx->task_ctx = NULL;
 	}
@@ -2927,6 +2960,11 @@ static void free_event(struct perf_event
 	if (event->ctx)
 		put_ctx(event->ctx);
 
+	WARN_ON((event->attach_state & PERF_INHERITED_EVENT) &&
+	    !(event->attach_state & PERF_COLLECTED_EVENT));
+
+	trace_printk("free: %p\n", event);
+
 	call_rcu(&event->rcu_head, free_event_rcu);
 }
 
@@ -3034,6 +3072,8 @@ u64 perf_event_read_value(struct perf_ev
 	}
 	mutex_unlock(&event->child_mutex);
 
+	trace_printk("event: %p total: %llu\n", event, total);
+
 	return total;
 }
 EXPORT_SYMBOL_GPL(perf_event_read_value);
@@ -3135,6 +3175,8 @@ perf_read_hw(struct perf_event *event, c
 	else
 		ret = perf_event_read_one(event, read_format, buf);
 
+	event->attach_state |= PERF_READ_EVENT;
+
 	return ret;
 }
 
@@ -6612,7 +6654,6 @@ SYSCALL_DEFINE5(perf_event_open,
 	}
 
 	perf_install_in_context(ctx, event, cpu);
-	++ctx->generation;
 	perf_unpin_context(ctx);
 	mutex_unlock(&ctx->mutex);
 
@@ -6628,6 +6669,8 @@ SYSCALL_DEFINE5(perf_event_open,
 	perf_event__header_size(event);
 	perf_event__id_header_size(event);
 
+	trace_printk("create: %p\n", event);
+
 	/*
 	 * Drop the reference on the group_event after placing the
 	 * new event on the sibling_list. This ensures destruction
@@ -6689,7 +6732,6 @@ perf_event_create_kernel_counter(struct 
 	WARN_ON_ONCE(ctx->parent_ctx);
 	mutex_lock(&ctx->mutex);
 	perf_install_in_context(ctx, event, cpu);
-	++ctx->generation;
 	perf_unpin_context(ctx);
 	mutex_unlock(&ctx->mutex);
 
@@ -6717,11 +6759,18 @@ static void sync_child_event(struct perf
 	 * Add back the child's count to the parent's count:
 	 */
 	atomic64_add(child_val, &parent_event->child_count);
+
+	trace_printk("adding: %lu from %p to %p\n", child_val, child_event, parent_event);
+
 	atomic64_add(child_event->total_time_enabled,
 		     &parent_event->child_total_time_enabled);
 	atomic64_add(child_event->total_time_running,
 		     &parent_event->child_total_time_running);
 
+	child_event->attach_state |= PERF_COLLECTED_EVENT;
+
+	WARN_ON(parent_event->attach_state & PERF_READ_EVENT);
+
 	/*
 	 * Remove this event from the parent's list
 	 */
@@ -6734,6 +6783,7 @@ static void sync_child_event(struct perf
 	 * Release the parent event, if this was the last
 	 * reference to it.
 	 */
+	WARN_ON(atomic_long_read(&parent_event->filp->f_count) <= 0);
 	fput(parent_event->filp);
 }
 
@@ -6880,6 +6930,7 @@ static void perf_free_event(struct perf_
 	list_del_init(&event->child_list);
 	mutex_unlock(&parent->child_mutex);
 
+	WARN_ON(atomic_long_read(&parent->filp->f_count) <= 0);
 	fput(parent->filp);
 
 	perf_group_detach(event);
@@ -7014,6 +7065,12 @@ inherit_event(struct perf_event *parent_
 	list_add_tail(&child_event->child_list, &parent_event->child_list);
 	mutex_unlock(&parent_event->child_mutex);
 
+	child_event->attach_state |= PERF_INHERITED_EVENT;
+
+	trace_printk("clone: %d:%p:%p -> %d:%p:%p\n",
+			parent->pid, parent_ctx, parent_event,
+			child->pid, child_ctx, child_event);
+
 	return child_event;
 }
 
@@ -7163,6 +7220,7 @@ int perf_event_init_context(struct task_
 			child_ctx->parent_gen = parent_ctx->generation;
 		}
 		get_ctx(child_ctx->parent_ctx);
+		trace_printk("ctx-clone: %p <- %p\n", child_ctx, child_ctx->parent_ctx);
 	}
 
 	raw_spin_unlock_irqrestore(&parent_ctx->lock, flags);

