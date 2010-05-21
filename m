Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756293Ab0EUJkN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 05:40:13 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39877 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754198Ab0EUJkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 05:40:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TZrfeH24ANLvHIiMud/NhkJme8ipfsYxLHPnx8jCwVNqpLREUFt58JLXw3fSfMXxjh
         hiHRXSV2ybZFx+2nnXA4Yub3wrt6mL57jiLoqbh/jUczByxPp3MKB/dEr4YzMGcaKTNk
         2fDYNiT5Ar0EJ7dfR0C/gBEBLQqib+X/mswdE=
Date: Fri, 21 May 2010 11:40:16 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/10] perf, trace: Use per-tracepoint-per-cpu hlist to
	track events
Message-ID: <20100521094014.GA30108@nowhere>
References: <20100521090201.326791353@chello.nl> <20100521090710.473188012@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100521090710.473188012@chello.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 21, 2010 at 11:02:03AM +0200, Peter Zijlstra wrote:
> Avoid the swevent hash-table by using per-tracepoint hlists.
> 
> Also, avoid conditionals on the fast path by ordering with probe unregister
> so that we should never get on the callback path without the data being there.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  include/linux/ftrace_event.h    |   16 ++---
>  include/linux/perf_event.h      |    6 +
>  include/trace/ftrace.h          |    4 -
>  kernel/perf_event.c             |   94 +++++++++++++++--------------
>  kernel/trace/trace_event_perf.c |  127 +++++++++++++++++++++-------------------
>  kernel/trace/trace_kprobe.c     |    9 +-
>  kernel/trace/trace_syscalls.c   |   11 ++-
>  7 files changed, 143 insertions(+), 124 deletions(-)
> 
> Index: linux-2.6/include/linux/ftrace_event.h
> ===================================================================
> --- linux-2.6.orig/include/linux/ftrace_event.h
> +++ linux-2.6/include/linux/ftrace_event.h
> @@ -133,7 +133,7 @@ struct ftrace_event_call {
>  	void			*data;
>  
>  	int			perf_refcount;
> -	void			*perf_data;
> +	struct hlist_head	*perf_events;
>  	int			(*perf_event_enable)(struct ftrace_event_call *);
>  	void			(*perf_event_disable)(struct ftrace_event_call *);
>  };
> @@ -192,9 +192,11 @@ struct perf_event;
>  
>  DECLARE_PER_CPU(struct pt_regs, perf_trace_regs);
>  
> -extern int perf_trace_enable(int event_id, void *data);
> -extern void perf_trace_disable(int event_id);
> -extern int ftrace_profile_set_filter(struct perf_event *event, int event_id,
> +extern int  perf_trace_init(struct perf_event *event);
> +extern void perf_trace_destroy(struct perf_event *event);
> +extern int  perf_trace_enable(struct perf_event *event);
> +extern void perf_trace_disable(struct perf_event *event);
> +extern int  ftrace_profile_set_filter(struct perf_event *event, int event_id,
>  				     char *filter_str);
>  extern void ftrace_profile_free_filter(struct perf_event *event);
>  extern void *perf_trace_buf_prepare(int size, unsigned short type,
> @@ -202,11 +204,9 @@ extern void *perf_trace_buf_prepare(int 
>  
>  static inline void
>  perf_trace_buf_submit(void *raw_data, int size, int rctx, u64 addr,
> -		       u64 count, struct pt_regs *regs, void *event)
> +		       u64 count, struct pt_regs *regs, void *head)
>  {
> -	struct trace_entry *entry = raw_data;
> -
> -	perf_tp_event(entry->type, addr, count, raw_data, size, regs, event);
> +	perf_tp_event(addr, count, raw_data, size, regs, head);
>  	perf_swevent_put_recursion_context(rctx);
>  }
>  #endif
> Index: linux-2.6/include/trace/ftrace.h
> ===================================================================
> --- linux-2.6.orig/include/trace/ftrace.h
> +++ linux-2.6/include/trace/ftrace.h
> @@ -768,6 +768,7 @@ perf_trace_templ_##call(struct ftrace_ev
>  	struct ftrace_data_offsets_##call __maybe_unused __data_offsets;\
>  	struct ftrace_raw_##call *entry;				\
>  	u64 __addr = 0, __count = 1;					\
> +	struct hlist_head *head;					\
>  	int __entry_size;						\
>  	int __data_size;						\
>  	int rctx;							\
> @@ -790,8 +791,9 @@ perf_trace_templ_##call(struct ftrace_ev
>  									\
>  	{ assign; }							\
>  									\
> +	head = per_cpu_ptr(event_call->perf_events, smp_processor_id());\



Should be rcu_dereference_sched ?



>  	perf_trace_buf_submit(entry, __entry_size, rctx, __addr,	\
> -			       __count, __regs, event_call->perf_data);	\
> +		__count, __regs, head);					\
>  }
>  
>  #undef DEFINE_EVENT
> Index: linux-2.6/kernel/trace/trace_event_perf.c
> ===================================================================
> --- linux-2.6.orig/kernel/trace/trace_event_perf.c
> +++ linux-2.6/kernel/trace/trace_event_perf.c
> @@ -23,14 +23,25 @@ typedef typeof(unsigned long [PERF_MAX_T
>  /* Count the events in use (per event id, not per instance) */
>  static int	total_ref_count;
>  
> -static int perf_trace_event_enable(struct ftrace_event_call *event, void *data)
> +static int perf_trace_event_init(struct ftrace_event_call *tp_event,
> +				 struct perf_event *p_event)
>  {
> +	struct hlist_head *list;
>  	int ret = -ENOMEM;
> +	int cpu;
>  
> -	if (event->perf_refcount++ > 0) {
> -		event->perf_data = NULL;
> +	p_event->tp_event = tp_event;
> +	if (tp_event->perf_refcount++ > 0)
>  		return 0;
> -	}
> +
> +	list = alloc_percpu(struct hlist_head);
> +	if (!list)
> +		goto fail;
> +
> +	for_each_possible_cpu(cpu)
> +		INIT_HLIST_HEAD(per_cpu_ptr(list, cpu));
> +
> +	tp_event->perf_events = list;



I suspect this must be rcu_assign_pointer.




>  
>  	if (!total_ref_count) {
>  		char *buf;
> @@ -39,20 +50,20 @@ static int perf_trace_event_enable(struc
>  		for (i = 0; i < 4; i++) {
>  			buf = (char *)alloc_percpu(perf_trace_t);
>  			if (!buf)
> -				goto fail_buf;
> +				goto fail;
>  
> -			rcu_assign_pointer(perf_trace_buf[i], buf);
> +			perf_trace_buf[i] = buf;
>  		}
>  	}
>  
> -	ret = event->perf_event_enable(event);
> -	if (!ret) {
> -		event->perf_data = data;
> -		total_ref_count++;
> -		return 0;
> -	}
> +	ret = tp_event->perf_event_enable(tp_event);
> +	if (ret)
> +		goto fail;
>  
> -fail_buf:
> +	total_ref_count++;
> +	return 0;
> +
> +fail:
>  	if (!total_ref_count) {
>  		int i;
>  
> @@ -61,21 +72,26 @@ fail_buf:
>  			perf_trace_buf[i] = NULL;
>  		}
>  	}
> -	event->perf_refcount--;
> +
> +	if (!--tp_event->perf_refcount) {
> +		free_percpu(tp_event->perf_events);
> +		tp_event->perf_events = NULL;
> +	}
>  
>  	return ret;
>  }
>  
> -int perf_trace_enable(int event_id, void *data)
> +int perf_trace_init(struct perf_event *p_event)
>  {
> -	struct ftrace_event_call *event;
> +	struct ftrace_event_call *tp_event;
> +	int event_id = p_event->attr.config;
>  	int ret = -EINVAL;
>  
>  	mutex_lock(&event_mutex);
> -	list_for_each_entry(event, &ftrace_events, list) {
> -		if (event->id == event_id && event->perf_event_enable &&
> -		    try_module_get(event->mod)) {
> -			ret = perf_trace_event_enable(event, data);
> +	list_for_each_entry(tp_event, &ftrace_events, list) {
> +		if (tp_event->id == event_id && tp_event->perf_event_enable &&
> +		    try_module_get(tp_event->mod)) {
> +			ret = perf_trace_event_init(tp_event, p_event);
>  			break;
>  		}
>  	}
> @@ -84,53 +100,52 @@ int perf_trace_enable(int event_id, void
>  	return ret;
>  }
>  
> -static void perf_trace_event_disable(struct ftrace_event_call *event)
> +int perf_trace_enable(struct perf_event *p_event)
>  {
> -	if (--event->perf_refcount > 0)
> -		return;
> +	struct ftrace_event_call *tp_event = p_event->tp_event;
> +	struct hlist_head *list;
>  
> -	event->perf_event_disable(event);
> +	list = tp_event->perf_events;
> +	if (WARN_ON_ONCE(!list))
> +		return -EINVAL;
>  
> -	if (!--total_ref_count) {
> -		char *buf[4];
> -		int i;
> -
> -		for (i = 0; i < 4; i++) {
> -			buf[i] = perf_trace_buf[i];
> -			rcu_assign_pointer(perf_trace_buf[i], NULL);
> -		}
> +	list = per_cpu_ptr(list, smp_processor_id());
> +	hlist_add_head_rcu(&p_event->hlist_entry, list);



Ah and may be small comment, because using the hlist api here
may puzzle more people than just me ;)



> -		/*
> -		 * Ensure every events in profiling have finished before
> -		 * releasing the buffers
> -		 */
> -		synchronize_sched();
> +	return 0;
> +}
>  
> -		for (i = 0; i < 4; i++)
> -			free_percpu(buf[i]);
> -	}
> +void perf_trace_disable(struct perf_event *p_event)
> +{
> +	hlist_del_rcu(&p_event->hlist_entry);
>  }
>  
> -void perf_trace_disable(int event_id)
> +void perf_trace_destroy(struct perf_event *p_event)
>  {
> -	struct ftrace_event_call *event;
> +	struct ftrace_event_call *tp_event = p_event->tp_event;
> +	int i;
>  
> -	mutex_lock(&event_mutex);
> -	list_for_each_entry(event, &ftrace_events, list) {
> -		if (event->id == event_id) {
> -			perf_trace_event_disable(event);
> -			module_put(event->mod);
> -			break;
> +	if (--tp_event->perf_refcount > 0)
> +		return;
> +
> +	tp_event->perf_event_disable(tp_event);



Don't we need a rcu_synchronize_sched() here?



> +	free_percpu(tp_event->perf_events);
> +	tp_event->perf_events = NULL;



And rcu_assign?



> +
> +	if (!--total_ref_count) {
> +		for (i = 0; i < 4; i++) {
> +			free_percpu(perf_trace_buf[i]);
> +			perf_trace_buf[i] = NULL;
>  		}
>  	}
> -	mutex_unlock(&event_mutex);
>  }
>  
>  __kprobes void *perf_trace_buf_prepare(int size, unsigned short type,
>  				       struct pt_regs *regs, int *rctxp)
>  {
>  	struct trace_entry *entry;
> -	char *trace_buf, *raw_data;
> +	char *raw_data;
>  	int pc;
>  
>  	BUILD_BUG_ON(PERF_MAX_TRACE_SIZE % sizeof(unsigned long));
> @@ -139,13 +154,9 @@ __kprobes void *perf_trace_buf_prepare(i
>  
>  	*rctxp = perf_swevent_get_recursion_context();
>  	if (*rctxp < 0)
> -		goto err_recursion;
> -
> -	trace_buf = rcu_dereference_sched(perf_trace_buf[*rctxp]);
> -	if (!trace_buf)
> -		goto err;
> +		return NULL;
>  
> -	raw_data = per_cpu_ptr(trace_buf, smp_processor_id());
> +	raw_data = per_cpu_ptr(perf_trace_buf[*rctxp], smp_processor_id());



Needs rcu_dereference_sched too. And this could be __this_cpu_var()




>  
>  	/* zero the dead bytes from align to not leak stack to user */
>  	memset(&raw_data[size - sizeof(u64)], 0, sizeof(u64));
> @@ -155,9 +166,5 @@ __kprobes void *perf_trace_buf_prepare(i
>  	entry->type = type;
>  
>  	return raw_data;
> -err:
> -	perf_swevent_put_recursion_context(*rctxp);
> -err_recursion:
> -	return NULL;
>  }
>  EXPORT_SYMBOL_GPL(perf_trace_buf_prepare);
> Index: linux-2.6/kernel/trace/trace_kprobe.c
> ===================================================================
> --- linux-2.6.orig/kernel/trace/trace_kprobe.c
> +++ linux-2.6/kernel/trace/trace_kprobe.c
> @@ -1341,6 +1341,7 @@ static __kprobes void kprobe_perf_func(s
>  	struct trace_probe *tp = container_of(kp, struct trace_probe, rp.kp);
>  	struct ftrace_event_call *call = &tp->call;
>  	struct kprobe_trace_entry_head *entry;
> +	struct hlist_head *head;
>  	u8 *data;
>  	int size, __size, i;
>  	int rctx;
> @@ -1361,7 +1362,8 @@ static __kprobes void kprobe_perf_func(s
>  	for (i = 0; i < tp->nr_args; i++)
>  		call_fetch(&tp->args[i].fetch, regs, data + tp->args[i].offset);
>  
> -	perf_trace_buf_submit(entry, size, rctx, entry->ip, 1, regs, call->perf_data);
> +	head = per_cpu_ptr(call->perf_events, smp_processor_id());



Same



> +	perf_trace_buf_submit(entry, size, rctx, entry->ip, 1, regs, head);
>  }
>  
>  /* Kretprobe profile handler */
> @@ -1371,6 +1373,7 @@ static __kprobes void kretprobe_perf_fun
>  	struct trace_probe *tp = container_of(ri->rp, struct trace_probe, rp);
>  	struct ftrace_event_call *call = &tp->call;
>  	struct kretprobe_trace_entry_head *entry;
> +	struct hlist_head *head;
>  	u8 *data;
>  	int size, __size, i;
>  	int rctx;
> @@ -1392,8 +1395,8 @@ static __kprobes void kretprobe_perf_fun
>  	for (i = 0; i < tp->nr_args; i++)
>  		call_fetch(&tp->args[i].fetch, regs, data + tp->args[i].offset);
>  
> -	perf_trace_buf_submit(entry, size, rctx, entry->ret_ip, 1,
> -			      regs, call->perf_data);
> +	head = per_cpu_ptr(call->perf_events, smp_processor_id());



ditto



> +	perf_trace_buf_submit(entry, size, rctx, entry->ret_ip, 1, regs, head);
>  }
>  
>  static int probe_perf_enable(struct ftrace_event_call *call)
> Index: linux-2.6/kernel/trace/trace_syscalls.c
> ===================================================================
> --- linux-2.6.orig/kernel/trace/trace_syscalls.c
> +++ linux-2.6/kernel/trace/trace_syscalls.c
> @@ -438,6 +438,7 @@ static void perf_syscall_enter(struct pt
>  {
>  	struct syscall_metadata *sys_data;
>  	struct syscall_trace_enter *rec;
> +	struct hlist_head *head;
>  	int syscall_nr;
>  	int rctx;
>  	int size;
> @@ -467,8 +468,9 @@ static void perf_syscall_enter(struct pt
>  	rec->nr = syscall_nr;
>  	syscall_get_arguments(current, regs, 0, sys_data->nb_args,
>  			       (unsigned long *)&rec->args);
> -	perf_trace_buf_submit(rec, size, rctx, 0, 1, regs,
> -			sys_data->enter_event->perf_data);
> +
> +	head = per_cpu_ptr(sys_data->enter_event->perf_events, smp_processor_id());



ditto



> +	perf_trace_buf_submit(rec, size, rctx, 0, 1, regs, head);
>  }
>  
>  int perf_sysenter_enable(struct ftrace_event_call *call)
> @@ -510,6 +512,7 @@ static void perf_syscall_exit(struct pt_
>  {
>  	struct syscall_metadata *sys_data;
>  	struct syscall_trace_exit *rec;
> +	struct hlist_head *head;
>  	int syscall_nr;
>  	int rctx;
>  	int size;
> @@ -542,8 +545,8 @@ static void perf_syscall_exit(struct pt_
>  	rec->nr = syscall_nr;
>  	rec->ret = syscall_get_return_value(current, regs);
>  
> -	perf_trace_buf_submit(rec, size, rctx, 0, 1, regs,
> -			sys_data->exit_event->perf_data);
> +	head = per_cpu_ptr(sys_data->exit_event->perf_events, smp_processor_id());



and ditto :)



> +	perf_trace_buf_submit(rec, size, rctx, 0, 1, regs, head);
>  }
>  
>  int perf_sysexit_enable(struct ftrace_event_call *call)
> Index: linux-2.6/kernel/perf_event.c
> ===================================================================
> --- linux-2.6.orig/kernel/perf_event.c
> +++ linux-2.6/kernel/perf_event.c
> @@ -4004,9 +4004,6 @@ static void perf_swevent_add(struct perf
>  	perf_swevent_overflow(event, 0, nmi, data, regs);
>  }
>  
> -static int perf_tp_event_match(struct perf_event *event,
> -				struct perf_sample_data *data);
> -
>  static int perf_exclude_event(struct perf_event *event,
>  			      struct pt_regs *regs)
>  {
> @@ -4036,10 +4033,6 @@ static int perf_swevent_match(struct per
>  	if (perf_exclude_event(event, regs))
>  		return 0;
>  
> -	if (event->attr.type == PERF_TYPE_TRACEPOINT &&
> -	    !perf_tp_event_match(event, data))
> -		return 0;
> -
>  	return 1;
>  }
>  
> @@ -4094,7 +4087,7 @@ end:
>  
>  int perf_swevent_get_recursion_context(void)
>  {
> -	struct perf_cpu_context *cpuctx = &get_cpu_var(perf_cpu_context);
> +	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
>  	int rctx;
>  
>  	if (in_nmi())
> @@ -4106,10 +4099,8 @@ int perf_swevent_get_recursion_context(v
>  	else
>  		rctx = 0;
>  
> -	if (cpuctx->recursion[rctx]) {
> -		put_cpu_var(perf_cpu_context);
> +	if (cpuctx->recursion[rctx])
>  		return -1;
> -	}
>  
>  	cpuctx->recursion[rctx]++;
>  	barrier();
> @@ -4123,7 +4114,6 @@ void perf_swevent_put_recursion_context(
>  	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
>  	barrier();
>  	cpuctx->recursion[rctx]--;
> -	put_cpu_var(perf_cpu_context);
>  }
>  EXPORT_SYMBOL_GPL(perf_swevent_put_recursion_context);
>  
> @@ -4134,6 +4124,7 @@ void __perf_sw_event(u32 event_id, u64 n
>  	struct perf_sample_data data;
>  	int rctx;
>  
> +	preempt_disable_notrace();


Why is this needed. We have the recursion context protection already.


Ok, otherwise looks good.

