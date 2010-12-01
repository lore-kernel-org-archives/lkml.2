Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755140Ab0LAOAP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 09:00:15 -0500
Received: from canuck.infradead.org ([134.117.69.58]:41288 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754619Ab0LAOAO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 09:00:14 -0500
Subject: Re: [PATCH 4/5] perf_events: add cgroup support (v6)
From: Peter Zijlstra <peterz@infradead.org>
To: eranian@google.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
        davem@davemloft.net, fweisbec@gmail.com, perfmon2-devel@lists.sf.net,
        eranian@gmail.com, robert.richter@amd.com, acme@redhat.com,
        lizf@cn.fujitsu.com
In-Reply-To: <4cf540d1.5d1be30a.7c7b.577d@mx.google.com>
References: <4cf540d1.5d1be30a.7c7b.577d@mx.google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 01 Dec 2010 15:00:07 +0100
Message-ID: <1291212007.32004.1529.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-30 at 19:20 +0200, Stephane Eranian wrote:

> diff --git a/init/Kconfig b/init/Kconfig
> index b28dd23..10d408e 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -1066,6 +1066,17 @@ config PERF_COUNTERS
>  
>  	  Say N if unsure.
>  
> +config PERF_CGROUPS
> +	bool "Enable per-cpu per-container group (cgroup) monitoring"
> +	default y if CGROUPS
> +	depends on PERF_EVENTS
> +	help
> +	  This option extends the per-cpu mode to restrict monitoring to
> +	  threads which belong to the cgroup specificied and run on the
> +	  designated cpu.
> +
> +	  Say N if unsure.
> +
>  config DEBUG_PERF_USE_VMALLOC
>  	default n
>  	bool "Debug: use vmalloc to back perf mmap() buffers"

Usually the cgroup things live in: menuconfig CGROUPS.

> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 66a416b..1c8bee8 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -4790,6 +4790,29 @@ css_get_next(struct cgroup_subsys *ss, int id,
>  	return ret;
>  }
>  
> +/*
> + * get corresponding css from file open on cgroupfs directory
> + */
> +struct cgroup_subsys_state *cgroup_css_from_dir(struct file *f, int id)
> +{
> +	struct cgroup *cgrp;
> +	struct inode *inode;
> +	struct cgroup_subsys_state *css;
> +
> +	inode = f->f_dentry->d_inode;
> +	/* check in cgroup filesystem dir */
> +	if (inode->i_op != &cgroup_dir_inode_operations)
> +		return ERR_PTR(-EBADF);
> +
> +	if (id < 0 || id >= CGROUP_SUBSYS_COUNT)
> +		return ERR_PTR(-EINVAL);
> +
> +	/* get cgroup */
> +	cgrp = __d_cgrp(f->f_dentry);
> +	css = cgrp->subsys[id];
> +	return css ? css : ERR_PTR(-ENOENT);
> +}

Since this paradigm was already in use it surprises me you have to add
this function.. ?

>  #ifdef CONFIG_CGROUP_DEBUG
>  static struct cgroup_subsys_state *debug_create(struct cgroup_subsys *ss,
>  						   struct cgroup *cont)
> diff --git a/kernel/perf_event.c b/kernel/perf_event.c
> index f17fa83..60fe6f1 100644
> --- a/kernel/perf_event.c
> +++ b/kernel/perf_event.c
> @@ -35,13 +35,22 @@
>  
>  #include <asm/irq_regs.h>
>  
> +#define PERF_FLAG_ALL (PERF_FLAG_FD_NO_GROUP |\
> +		       PERF_FLAG_FD_OUTPUT  |\
> +		       PERF_FLAG_PID_CGROUP)
> +
>  enum event_type_t {
>  	EVENT_FLEXIBLE = 0x1,
>  	EVENT_PINNED = 0x2,
>  	EVENT_ALL = EVENT_FLEXIBLE | EVENT_PINNED,
>  };
>  
> -atomic_t perf_task_events __read_mostly;
> +/* perf_sched_events : >0 events exist
> + * perf_cgroup_events: >0 per-cpu cgroup events exist on this cpu
> + */

That wants to be:
/*
 * text goes here
 */

> +atomic_t perf_sched_events __read_mostly;
> +static DEFINE_PER_CPU(atomic_t, perf_cgroup_events);

If its per-cpu, do we really need atomic_t ?

>  static atomic_t nr_mmap_events __read_mostly;
>  static atomic_t nr_comm_events __read_mostly;
>  static atomic_t nr_task_events __read_mostly;
> @@ -72,7 +81,10 @@ static void cpu_ctx_sched_out(struct perf_cpu_context *cpuctx,
>  			      enum event_type_t event_type);
>  
>  static void cpu_ctx_sched_in(struct perf_cpu_context *cpuctx,
> -			     enum event_type_t event_type);
> +			     enum event_type_t event_type,
> +			     struct task_struct *task, int css_sw);
> +
> +static u64 perf_event_time(struct perf_event *event);
>  
>  void __weak perf_event_print_debug(void)	{ }
>  
> @@ -86,6 +98,329 @@ static inline u64 perf_clock(void)
>  	return local_clock();
>  }
>  
> +#ifdef CONFIG_PERF_CGROUPS
> +static inline struct perf_cgroup *
> +perf_cgroup_from_task(struct task_struct *task)
> +{
> +	if (!task)
> +		return NULL;
> +	return container_of(task_subsys_state(task, perf_subsys_id),
> +			struct perf_cgroup, css);
> +}

Wouldn't it be nicer if the caller ensured to not call it for !task?


> +static struct perf_cgroup *perf_get_cgroup(int fd)
> +{
> +	struct cgroup_subsys_state *css;
> +	struct file *file;
> +	int fput_needed;
> +
> +	file = fget_light(fd, &fput_needed);
> +	if (!file)
> +		return ERR_PTR(-EBADF);
> +
> +	css = cgroup_css_from_dir(file, perf_subsys_id);
> +	if (!IS_ERR(css))
> +		css_get(css);
> +
> +	fput_light(file, fput_needed);
> +
> +	return container_of(css, struct perf_cgroup, css);
> +}
> +
> +static inline void perf_put_cgroup(struct perf_event *event)
> +{
> +	if (event->cgrp)
> +		css_put(&event->cgrp->css);
> +}

Bit asymmetric, you get a perf_cgroup, but you put a perf_event.


> +static inline void __update_css_time(struct perf_cgroup *cgrp)
> +{
> +	struct perf_cgroup_info *t;
> +	u64 now;
> +	int cpu = smp_processor_id();
> +
> +	if (!cgrp)
> +		return;
> +
> +	now = perf_clock();
> +
> +	t = per_cpu_ptr(cgrp->info, cpu);
> +
> +	t->time += now - t->timestamp;
> +	t->timestamp = now;
> +}

Most callers seem to already check for !cgrp, make that all and avoid
the second conditional?

> +/*
> + * called from perf_event_ask_sched_out() conditional to jump label
> + */
> +void
> +perf_cgroup_switch(struct task_struct *task, struct task_struct *next)
> +{
> +	struct perf_cgroup *cgrp_out = perf_cgroup_from_task(task);
> +	struct perf_cgroup *cgrp_in = perf_cgroup_from_task(next);
> +	struct perf_cpu_context *cpuctx;
> +	struct pmu *pmu;
> +	/*
> +	 * if task is DEAD, then css_out is irrelevant, it has
> +	 * been changed to init_css in cgroup_exit() from do_exit().
> +	 * Furthermore, perf_cgroup_exit_task(), has scheduled out
> +	 * all css constrained events, only unconstrained events
> +	 * remain. Therefore we need to reschedule based on css_in.
> +	 */
> +	if (task->state != TASK_DEAD && cgrp_out == cgrp_in)
> +		return;
> +
> +	rcu_read_lock();
> +
> +	list_for_each_entry_rcu(pmu, &pmus, entry) {
> +
> +		cpuctx = get_cpu_ptr(pmu->pmu_cpu_context);
> +
> +		perf_pmu_disable(cpuctx->ctx.pmu);
> +
> +		/*
> +		 * perf_cgroup_events says at least one
> +		 * context on this CPU has cgroup events.
> +		 *
> +		 * ctx->nr_cgroups reports the number of cgroup
> +		 * events for a context. Given there can be multiple
> +		 * PMUs, there can be multiple contexts.
> +		 */
> +		if (cpuctx->ctx.nr_cgroups > 0) {
> +			/*
> +			 * schedule out everything we have
> +			 * task == DEAD: only unconstrained events
> +			 * task != DEAD: css constrained + unconstrained events
> +			 *
> +			 * We kick out all events (even if unconstrained)
> +			 * to allow the constrained events to be scheduled
> +			 * based on their position in the event list (fairness)
> +			 */
> +			cpu_ctx_sched_out(cpuctx, EVENT_ALL);
> +			/*
> +			 * reschedule css_in constrained + unconstrained events
> +			 */
> +			cpu_ctx_sched_in(cpuctx, EVENT_ALL, next, 1);
> +		}
> +
> +		perf_pmu_enable(cpuctx->ctx.pmu);

Do you leak a preemption count here? No matching put_cpu_ptr().

Since we're in the middle of a context switch, preemption is already
disabled and it might be best to use this_cpu_ptr() instead of
get_cpu_ptr(). That avoids the preemption bits.

> +	}
> +
> +	rcu_read_unlock();
> +}
> +
> +static inline void
> +perf_cgroup_exit_task(struct task_struct *task)
> +{
> +	struct perf_cpu_context *cpuctx;
> +	struct pmu *pmu;
> +	unsigned long flags;
> +
> +	local_irq_save(flags);
> +
> +	rcu_read_lock();
> +
> +	list_for_each_entry_rcu(pmu, &pmus, entry) {
> +
> +		cpuctx = get_cpu_ptr(pmu->pmu_cpu_context);
> +
> +		perf_pmu_disable(cpuctx->ctx.pmu);
> +
> +		if (cpuctx->ctx.nr_cgroups > 0) {
> +			/*
> +			 * task is going to be detached from css.
> +			 * We cannot keep a reference on the css
> +			 * as it may disappear before we get to
> +			 * perf_cgroup_switch(). Thus, we remove
> +			 * all css constrained events.
> +			 *
> +			 * We do this by scheduling out everything
> +			 * we have, and then only rescheduling only
> +			 * the unconstrained events. Those can keep
> +			 * on counting.
> +			 *
> +			 * We re-examine the situation in the final
> +			 * perf_cgroup_switch() call for this task
> +			 * once we know the next task.
> +			 */
> +			cpu_ctx_sched_out(cpuctx, EVENT_ALL);
> +			/*
> +			 * task = NULL causes perf_cgroup_match()
> +			 * to match only unconstrained events
> +			 */
> +			cpu_ctx_sched_in(cpuctx, EVENT_ALL, NULL, 1);
> +		}
> +
> +		perf_pmu_enable(cpuctx->ctx.pmu);

Another preemption leak?

> +	}
> +	rcu_read_unlock();
> +
> +	local_irq_restore(flags);
> +}

> @@ -246,6 +581,10 @@ static void update_context_time(struct perf_event_context *ctx)
>  static u64 perf_event_time(struct perf_event *event)
>  {
>  	struct perf_event_context *ctx = event->ctx;
> +
> +	if (is_cgroup_event(event))
> +		return perf_cgroup_event_css_time(event);
> +
>  	return ctx ? ctx->time : 0;
>  }
>  
> @@ -261,8 +600,10 @@ static void update_event_times(struct perf_event *event)
>  	    event->group_leader->state < PERF_EVENT_STATE_INACTIVE)
>  		return;
>  
> -	if (ctx->is_active)
> -		run_end = perf_event_time(event);
> +	if (is_cgroup_event(event))
> +		run_end = perf_cgroup_event_css_time(event);
> +	else if (ctx->is_active)
> +		run_end = ctx->time;
>  	else
>  		run_end = event->tstamp_stopped;

So I guess the difference is that we want perf_cgroup_event_css_time()
even when !active?

I'm afraid all this time accounting stuff is going to make my head
explode.. could a comment help?

> @@ -322,6 +663,17 @@ list_add_event(struct perf_event *event, struct perf_event_context *ctx)
>  		list_add_tail(&event->group_entry, list);
>  	}
>  
> +	if (is_cgroup_event(event)) {
> +		ctx->nr_cgroups++;
> +		/*
> +		 * one more event:
> +		 * - that has cgroup constraint on event->cpu
> +		 * - that may need work on context switch
> +		 */
> +		atomic_inc(&per_cpu(perf_cgroup_events, event->cpu));
> +		jump_label_inc(&perf_sched_events);
> +	}

Ah, I guess this is why you're still using atomics, since another cpu
can install the counters on the target cpu,. ok I guess that makes
sense.

>  	list_add_rcu(&event->event_entry, &ctx->event_list);
>  	if (!ctx->nr_events)
>  		perf_pmu_rotate_start(ctx->pmu);
> @@ -368,6 +720,12 @@ list_del_event(struct perf_event *event, struct perf_event_context *ctx)
>  
>  	event->attach_state &= ~PERF_ATTACH_CONTEXT;
>  
> +	if (is_cgroup_event(event)) {
> +		ctx->nr_cgroups--;
> +		atomic_dec(&per_cpu(perf_cgroup_events, event->cpu));
> +		jump_label_dec(&perf_sched_events);
> +	}
> +
>  	ctx->nr_events--;
>  	if (event->attr.inherit_stat)
>  		ctx->nr_stat--;
> @@ -431,9 +789,10 @@ static void perf_group_detach(struct perf_event *event)
>  }
>  
>  static inline int
> -event_filter_match(struct perf_event *event)
> +event_filter_match(struct perf_event *event, struct task_struct *task)
>  {
> -	return event->cpu == -1 || event->cpu == smp_processor_id();
> +	return (event->cpu == -1 || event->cpu == smp_processor_id())
> +	    && perf_cgroup_match(event, task);
>  }
>  
>  static void
> @@ -450,8 +809,8 @@ event_sched_out(struct perf_event *event,
>  	 * via read() for time_enabled, time_running:
>  	 */
>  	if (event->state == PERF_EVENT_STATE_INACTIVE
> -	    && !event_filter_match(event)) {
> -		delta = ctx->time - event->tstamp_stopped;
> +	    && !event_filter_match(event, current)) {
> +		delta = tstamp - event->tstamp_stopped;
>  		event->tstamp_running += delta;
>  		event->tstamp_stopped = tstamp;
>  	}

Is that s/ctx->time/tstamp/ a missing hunk from patch 3?

> @@ -609,6 +968,7 @@ static void __perf_event_disable(void *info)
>  	 */
>  	if (event->state >= PERF_EVENT_STATE_INACTIVE) {
>  		update_context_time(ctx);
> +		update_css_time_from_event(event);
>  		update_group_times(event);
>  		if (event == event->group_leader)
>  			group_sched_out(event, cpuctx, ctx);
> @@ -696,7 +1056,35 @@ event_sched_in(struct perf_event *event,
>  
>  	event->tstamp_running += tstamp - event->tstamp_stopped;
>  
> -	event->shadow_ctx_time = tstamp - ctx->timestamp;
> +	/*
> +	 * use the correct time source for the time snapshot
> +	 *
> +	 * We could get by without this by leveraging the
> +	 * fact that to get to this function, the caller
> +	 * has most likely already called update_context_time()
> +	 * and update_css_time_xx() and thus both timestamp
> +	 * are identical (or very close). Given that tstamp is,
> +	 * already adjusted for cgroup, we could say that:
> +	 *    tstamp - ctx->timestamp
> +	 * is equivalent to
> +	 *    tstamp - cgrp->timestamp.
> +	 *
> +	 * Then, in perf_output_read(), the calculation would
> +	 * work with no changes because:
> +	 * - event is guaranteed scheduled in
> +	 * - no scheduled out in between
> +	 * - thus the timestamp would be the same
> +	 *
> +	 * But this is a bit hairy.
> +	 *
> +	 * So instead, we have an explicit cgroup call to remain
> +	 * within the time time source all along. We believe it
> +	 * is cleaner and simpler to understand.
> +	 */
> +	if (is_cgroup_event(event))
> +		perf_cgroup_set_shadow_time(event, tstamp);
> +	else
> +		event->shadow_ctx_time = tstamp - ctx->timestamp;

How about we make perf_set_shadow_time() and hide all this in there?


> @@ -5289,6 +5719,7 @@ unlock:
>  static struct perf_event *
>  perf_event_alloc(struct perf_event_attr *attr, int cpu,
>  		 struct task_struct *task,
> +		 int cgrp_fd, int flags,
>  		 struct perf_event *group_leader,
>  		 struct perf_event *parent_event,
>  		 perf_overflow_handler_t overflow_handler)
> @@ -5302,6 +5733,14 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
>  	if (!event)
>  		return ERR_PTR(-ENOMEM);
>  
> +	if (flags & PERF_FLAG_PID_CGROUP) {
> +		err = perf_connect_cgroup(cgrp_fd, event, attr, group_leader);
> +		if (err) {
> +			kfree(event);
> +			return ERR_PTR(err);
> +		}
> +	}
> +
>  	/*
>  	 * Single events are their own group leaders, with an
>  	 * empty sibling list:


Hrm,. that isn't particularly pretty,.. why do we have to do this in
perf_event_alloc()? Can't we do this in the syscall after
perf_event_alloc() returns?
