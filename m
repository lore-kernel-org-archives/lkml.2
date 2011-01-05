Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053Ab1AELXY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 06:23:24 -0500
Received: from canuck.infradead.org ([134.117.69.58]:41058 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676Ab1AELXX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 06:23:23 -0500
Subject: Re: [PATCH 4/5] perf_events: add cgroup support (v7)
From: Peter Zijlstra <peterz@infradead.org>
To: eranian@google.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
        davem@davemloft.net, fweisbec@gmail.com, perfmon2-devel@lists.sf.net,
        eranian@gmail.com, robert.richter@amd.com, acme@redhat.com,
        lizf@cn.fujitsu.com
In-Reply-To: <4d2205a1.8b02e30a.3541.ffff8aee@mx.google.com>
References: <4d2205a1.8b02e30a.3541.ffff8aee@mx.google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 05 Jan 2011 12:23:38 +0100
Message-ID: <1294226618.2016.259.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-03 at 18:20 +0200, Stephane Eranian wrote:

> +#ifdef CONFIG_CGROUP_PERF
> +/*
> + * perf_cgroup_info keeps track of time_enabled for a cgroup.
> + * This is a per-cpu dynamically allocated data structure.
> + */
> +struct perf_cgroup_info {
> +	u64 time;
> +	u64 timestamp;
> +};
> +
> +struct perf_cgroup {
> +	struct cgroup_subsys_state css;
> +	struct perf_cgroup_info *info;	/* timing info, one per cpu */

I think 'they' want a __percpu annotation there.

> +};
> +#endif


> diff --git a/kernel/perf_event.c b/kernel/perf_event.c
> index b782b7a..905b91a 100644
> --- a/kernel/perf_event.c
> +++ b/kernel/perf_event.c


> +static inline void __update_cgrp_time(struct perf_cgroup *cgrp)
> +{
> +	struct perf_cgroup_info *t;
> +	u64 now;
> +
> +	now = perf_clock();
> +
> +	t = per_cpu_ptr(cgrp->info, smp_processor_id());

  this_cpu_ptr(cgrp->info);

> +
> +	t->time += now - t->timestamp;
> +	t->timestamp = now;
> +}


> +static inline void
> +perf_cgroup_set_timestamp(struct task_struct *task, u64 now)
> +{
> +	struct perf_cgroup *cgrp;
> +	struct perf_cgroup_info *info;
> +
> +	if (!task)
> +		return;
> +
> +	cgrp = perf_cgroup_from_task(task);
> +	info = per_cpu_ptr(cgrp->info, smp_processor_id());

 this_cpu_ptr();

> +	info->timestamp = now;
> +}
> +

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
> +	 * been changed to init_cgrp in cgroup_exit() from do_exit().
> +	 * Furthermore, perf_cgroup_exit_task(), has scheduled out
> +	 * all css constrained events, only unconstrained events
> +	 * remain. Therefore we need to reschedule based on css_in.
> +	 */
> +	if (task->state != TASK_DEAD && cgrp_out == cgrp_in)
> +		return;

I think that check is broken, TASK_DEAD is set way after calling
cgroup_exit(), so if we get preempted in between there you'll still go
funny.

We do set PF_EXITING before calling cgroup_exit() though.

> +	rcu_read_lock();
> +
> +	list_for_each_entry_rcu(pmu, &pmus, entry) {
> +
> +		cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
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

Does this comment want an update? As per the above (broken) check, we
should never get here for DEAD tasks, hmm?

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
> +	}
> +
> +	rcu_read_unlock();
> +}
> +
> +static inline void

Copy/paste fail?

> +perf_cgroup_exit_task(struct task_struct *task)
> +{

> +}
> +
> +static inline int perf_cgroup_connect(int fd, struct perf_event *event,
> +				      struct perf_event_attr *attr,
> +				      struct perf_event *group_leader)

Again, do we really need this 'inline' ?

> +{
> +	struct perf_cgroup *cgrp;
> +	struct cgroup_subsys_state *css;
> +	struct file *file;
> +	int ret = 0, fput_needed;
> +
> +	file = fget_light(fd, &fput_needed);
> +	if (!file)
> +		return -EBADF;
> +
> +	css = cgroup_css_from_dir(file, perf_subsys_id);
> +	if (IS_ERR(css))
> +		return PTR_ERR(css);
> +
> +	cgrp = container_of(css, struct perf_cgroup, css);
> +	event->cgrp = cgrp;


If we do that perf_get_cgroup() here (unconditional).

> +	/*
> +	 * all events in a group must monitor
> +	 * the same cgroup because a thread belongs
> +	 * to only one perf cgroup at a time
> +	 */
> +	if (group_leader && group_leader->cgrp != cgrp) {
> +		perf_detach_cgroup(event);
> +		ret = -EINVAL;
> +	} else {
> +		/* must be done before we fput() the file */
> +		perf_get_cgroup(event);
> +	}

Then you can have that conditional perf_detach_cgroup() here, right?

> +	fput_light(file, fput_needed);
> +	return ret;
> +}

 


