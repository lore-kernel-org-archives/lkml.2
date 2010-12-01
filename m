Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093Ab0LAS3Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 13:29:24 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58699 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755437Ab0LAS3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 13:29:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gXM/rzHArbDRtiixVzwucjbwMHZ7sU5jfQb9uY1NQIpWFEH7Q9ugRA1bjKcWw4t7JM
         dcZ4az6Xc1Ul9oVMXNSbuoOWD0cck2QbVs17578yruITYqlxl2VzGbvH0Z3Q54INdHi2
         2KochszYu/lfH8B21rZQsZYBICXXfApwo/fNo=
Date: Wed, 1 Dec 2010 19:29:16 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [BUG(?)] perf_events: combining multiple tracepoint events
 into a group produces no counts on member events
Message-ID: <20101201182910.GC3438@nowhere>
References: <4CF59E20.1040301@linux.vnet.ibm.com>
 <1291203990.4023.16.camel@twins>
 <1291205078.32004.1381.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291205078.32004.1381.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 01, 2010 at 01:04:37PM +0100, Peter Zijlstra wrote:
> @@ -4833,7 +5101,8 @@ static int perf_event_set_filter(struct 
>  	char *filter_str;
>  	int ret;
>  
> -	if (event->attr.type != PERF_TYPE_TRACEPOINT)
> +	if (event->attr.type != PERF_TYPE_TRACEPOINT ||
> +	    event->attr.config == ~0ULL)
>  		return -EINVAL;
>  
>  	filter_str = strndup_user(arg, PAGE_SIZE);
> @@ -4851,6 +5120,74 @@ static void perf_event_free_filter(struc
>  	ftrace_profile_free_filter(event);
>  }
>  
> +static int perf_event_add_tp(struct perf_event *event, int tp_id)
> +{
> +	if (event->attr.type != PERF_TYPE_TRACEPOINT &&

Should it be || instead?

> +	    event->attr.config != ~0ULL)
> +		return -EINVAL;
> +
> +	return __perf_event_add_tp(event, tp_id);
> +}
> +
> +/*
> + * Called from the exit path, _after_ all events have been detached from it.
> + */
> +static void perf_tp_event_exit(struct task_struct *tsk)
> +{
> +	struct perf_tp_idr *idr = tsk->perf_tp_idr;
> +
> +	if (!idr)
> +		return;
> +
> +	idr_remove_all(&idr->idr);
> +	idr_destroy(&idr->idr);
> +}
> +
> +static void perf_tp_event_delayed_put(struct task_struct *tsk)
> +{
> +	struct perf_tp_idr *idr = tsk->perf_tp_idr;
> +
> +	tsk->perf_tp_idr = NULL;
> +	kfree(idr);
> +}
> +
> +static int perf_tp_inherit_idr(int id, void *p, void *data)
> +{
> +	struct perf_event *child = data;
> +
> +	return __perf_event_add_tp(child, id);
> +}
> +
> +static int perf_tp_event_inherit(struct perf_event *parent_event,
> +				 struct perf_event *child_event)
> +{
> +	int ret;
> +
> +	if (parent_event->attr.type != PERF_TYPE_TRACEPOINT ||
> +	    parent_event->attr.config != ~0ULL)
> +		return 0;
> +
> +	/*
> +	 * The child is not yet exposed, hence no need to serialize things
> +	 * on that side.
> +	 */
> +	mutex_lock(&parent_event->tp_idr.lock);
> +	ret = idr_for_each(&parent_event->tp_idr.idr,
> +			perf_tp_inherit_idr,
> +			child_event);
> +	mutex_unlock(&parent_event->tp_idr.lock);
> +
> +	return ret;
> +}
> +
> +static void perf_tp_event_init_task(struct task_struct *child)
> +{
> +	/*
> +	 * Clear the idr pointer copied from the parent.
> +	 */
> +	child->perf_tp_idr = NULL;
> +}
> +
>  #else
>  
>  static inline void perf_tp_register(void)
> @@ -4866,6 +5203,29 @@ static void perf_event_free_filter(struc
>  {
>  }
>  
> +static int perf_event_add_tp(struct perf_event *event, int tp_id)
> +{
> +	return -ENOENT;
> +}
> +
> +static void perf_tp_event_exit(struct task_struct *tsk)
> +{
> +}
> +
> +static void perf_tp_event_delayed_put(struct task_struct *tsk)
> +{
> +}
> +
> +static int perf_tp_event_inherit(struct perf_event *parent_event,
> +				 struct perf_event *child_event)
> +{
> +	return 0;
> +}
> +
> +static void perf_tp_event_init_task()(struct task_struct *child)
> +{
> +}
> +
>  #endif /* CONFIG_EVENT_TRACING */
>  
>  #ifdef CONFIG_HAVE_HW_BREAKPOINT
> @@ -5290,6 +5650,9 @@ perf_event_alloc(struct perf_event_attr 
>  	INIT_LIST_HEAD(&event->sibling_list);
>  	init_waitqueue_head(&event->waitq);
>  	init_irq_work(&event->pending, perf_pending_event);
> +#ifdef CONFIG_EVENT_TRACING
> +	perf_tp_idr_init(&event->tp_idr);
> +#endif
>  
>  	mutex_init(&event->mmap_mutex);
>  
> @@ -5308,6 +5671,7 @@ perf_event_alloc(struct perf_event_attr 
>  
>  	if (task) {
>  		event->attach_state = PERF_ATTACH_TASK;
> +		event->hw.event_target = task;
>  #ifdef CONFIG_HAVE_HW_BREAKPOINT
>  		/*
>  		 * hw_breakpoint is a bit difficult here..
> @@ -5353,7 +5717,7 @@ perf_event_alloc(struct perf_event_attr 
>  	if (err) {
>  		if (event->ns)
>  			put_pid_ns(event->ns);
> -		kfree(event);
> +		free_event(event);
>  		return ERR_PTR(err);
>  	}
>  
> @@ -5694,7 +6058,6 @@ SYSCALL_DEFINE5(perf_event_open,
>  	}
>  
>  	perf_install_in_context(ctx, event, cpu);
> -	++ctx->generation;
>  	mutex_unlock(&ctx->mutex);
>  
>  	event->owner = current;
> @@ -5763,7 +6126,6 @@ perf_event_create_kernel_counter(struct 
>  	WARN_ON_ONCE(ctx->parent_ctx);
>  	mutex_lock(&ctx->mutex);
>  	perf_install_in_context(ctx, event, cpu);
> -	++ctx->generation;
>  	mutex_unlock(&ctx->mutex);
>  
>  	return event;
> @@ -5936,6 +6298,8 @@ void perf_event_exit_task(struct task_st
>  
>  	for_each_task_context_nr(ctxn)
>  		perf_event_exit_task_context(child, ctxn);
> +
> +	perf_tp_event_exit(child);
>  }
>  
>  static void perf_free_event(struct perf_event *event,
> @@ -5998,6 +6362,8 @@ void perf_event_delayed_put(struct task_
>  
>  	for_each_task_context_nr(ctxn)
>  		WARN_ON_ONCE(task->perf_event_ctxp[ctxn]);
> +
> +	perf_tp_event_delayed_put(task);
>  }
>  
>  /*
> @@ -6013,6 +6379,7 @@ inherit_event(struct perf_event *parent_
>  {
>  	struct perf_event *child_event;
>  	unsigned long flags;
> +	int ret;
>  
>  	/*
>  	 * Instead of creating recursive hierarchies of events,
> @@ -6030,6 +6397,13 @@ inherit_event(struct perf_event *parent_
>  					   NULL);
>  	if (IS_ERR(child_event))
>  		return child_event;
> +
> +	ret = perf_tp_event_inherit(parent_event, child_event);
> +	if (ret) {
> +		free_event(child_event);
> +		return ERR_PTR(ret);
> +	}
> +
>  	get_ctx(child_ctx);
>  
>  	/*
> @@ -6134,9 +6508,7 @@ inherit_task_group(struct perf_event *ev
>  		child->perf_event_ctxp[ctxn] = child_ctx;
>  	}
>  
> -	ret = inherit_group(event, parent, parent_ctx,
> -			    child, child_ctx);
> -
> +	ret = inherit_group(event, parent, parent_ctx, child, child_ctx);
>  	if (ret)
>  		*inherited_all = 0;
>  
> @@ -6157,9 +6529,6 @@ int perf_event_init_context(struct task_
>  
>  	child->perf_event_ctxp[ctxn] = NULL;
>  
> -	mutex_init(&child->perf_event_mutex);
> -	INIT_LIST_HEAD(&child->perf_event_list);
> -
>  	if (likely(!parent->perf_event_ctxp[ctxn]))
>  		return 0;
>  
> @@ -6236,6 +6605,11 @@ int perf_event_init_task(struct task_str
>  {
>  	int ctxn, ret;
>  
> +	mutex_init(&child->perf_event_mutex);
> +	INIT_LIST_HEAD(&child->perf_event_list);
> +
> +	perf_tp_event_init_task(child);
> +
>  	for_each_task_context_nr(ctxn) {
>  		ret = perf_event_init_context(child, ctxn);
>  		if (ret)
> Index: linux-2.6/kernel/trace/trace_event_perf.c
> ===================================================================
> --- linux-2.6.orig/kernel/trace/trace_event_perf.c
> +++ linux-2.6/kernel/trace/trace_event_perf.c
> @@ -8,6 +8,7 @@
>  #include <linux/module.h>
>  #include <linux/kprobes.h>
>  #include "trace.h"
> +#include "trace_output.h"
>  
>  static char __percpu *perf_trace_buf[PERF_NR_CONTEXTS];
>  
> @@ -47,9 +48,7 @@ static int perf_trace_event_perm(struct 
>  static int perf_trace_event_init(struct ftrace_event_call *tp_event,
>  				 struct perf_event *p_event)
>  {
> -	struct hlist_head __percpu *list;
>  	int ret;
> -	int cpu;
>  
>  	ret = perf_trace_event_perm(tp_event, p_event);
>  	if (ret)
> @@ -61,15 +60,6 @@ static int perf_trace_event_init(struct 
>  
>  	ret = -ENOMEM;
>  
> -	list = alloc_percpu(struct hlist_head);
> -	if (!list)
> -		goto fail;
> -
> -	for_each_possible_cpu(cpu)
> -		INIT_HLIST_HEAD(per_cpu_ptr(list, cpu));
> -
> -	tp_event->perf_events = list;
> -
>  	if (!total_ref_count) {
>  		char __percpu *buf;
>  		int i;
> @@ -100,63 +90,40 @@ static int perf_trace_event_init(struct 
>  		}
>  	}
>  
> -	if (!--tp_event->perf_refcount) {
> -		free_percpu(tp_event->perf_events);
> -		tp_event->perf_events = NULL;
> -	}
> +	--tp_event->perf_refcount;
>  
>  	return ret;
>  }
>  
> -int perf_trace_init(struct perf_event *p_event)
> +int perf_trace_init(struct perf_event *p_event, int event_id)
>  {
>  	struct ftrace_event_call *tp_event;
> -	int event_id = p_event->attr.config;
> +	struct trace_event *t_event;
>  	int ret = -EINVAL;
>  
> +	trace_event_read_lock();
> +	t_event = ftrace_find_event(event_id);
> +	if (!t_event)
> +		goto out;
> +
> +	tp_event = container_of(t_event, struct ftrace_event_call, event);
> +
>  	mutex_lock(&event_mutex);
> -	list_for_each_entry(tp_event, &ftrace_events, list) {
> -		if (tp_event->event.type == event_id &&
> -		    tp_event->class && tp_event->class->reg &&
> -		    try_module_get(tp_event->mod)) {
> -			ret = perf_trace_event_init(tp_event, p_event);
> -			if (ret)
> -				module_put(tp_event->mod);
> -			break;
> -		}
> +	if (tp_event->class && tp_event->class->reg &&
> +			try_module_get(tp_event->mod)) {
> +		ret = perf_trace_event_init(tp_event, p_event);
> +		if (ret)
> +			module_put(tp_event->mod);
>  	}
>  	mutex_unlock(&event_mutex);
> +out:
> +	trace_event_read_unlock();
>  
>  	return ret;
>  }
>  
> -int perf_trace_add(struct perf_event *p_event, int flags)
> -{
> -	struct ftrace_event_call *tp_event = p_event->tp_event;
> -	struct hlist_head __percpu *pcpu_list;
> -	struct hlist_head *list;
> -
> -	pcpu_list = tp_event->perf_events;
> -	if (WARN_ON_ONCE(!pcpu_list))
> -		return -EINVAL;
> -
> -	if (!(flags & PERF_EF_START))
> -		p_event->hw.state = PERF_HES_STOPPED;
> -
> -	list = this_cpu_ptr(pcpu_list);
> -	hlist_add_head_rcu(&p_event->hlist_entry, list);
> -
> -	return 0;
> -}
> -
> -void perf_trace_del(struct perf_event *p_event, int flags)
> -{
> -	hlist_del_rcu(&p_event->hlist_entry);
> -}
> -
> -void perf_trace_destroy(struct perf_event *p_event)
> +static void __perf_trace_destroy(struct ftrace_event_call *tp_event)
>  {
> -	struct ftrace_event_call *tp_event = p_event->tp_event;
>  	int i;
>  
>  	mutex_lock(&event_mutex);
> @@ -171,9 +138,6 @@ void perf_trace_destroy(struct perf_even
>  	 */
>  	tracepoint_synchronize_unregister();
>  
> -	free_percpu(tp_event->perf_events);
> -	tp_event->perf_events = NULL;
> -
>  	if (!--total_ref_count) {
>  		for (i = 0; i < PERF_NR_CONTEXTS; i++) {
>  			free_percpu(perf_trace_buf[i]);
> @@ -185,6 +149,27 @@ void perf_trace_destroy(struct perf_even
>  	mutex_unlock(&event_mutex);
>  }
>  
> +void perf_trace_destroy(struct perf_event *p_event)
> +{
> +	__perf_trace_destroy(p_event->tp_event);
> +}

Is this a leftover? It doesn't seem to be used anymore.

Other than that, the whole looks good. May be I need to have
one more look at the trace_output.c changes, but the conversion
from hlist to idr seemed fine at a glance.

Adding Steve in Cc.
