Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755800Ab0EUOau (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 10:30:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:42531 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687Ab0EUOas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 10:30:48 -0400
X-Authority-Analysis: v=1.1 cv=ThiPuEJrAfM5PTlEgIT3cJp8+3pkHBIG3CaogqDGxqo= c=1 sm=0 a=ImvbqTOSoUQA:10 a=yQWWgrYGNuUA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=lO3uoPcO44IGqXHf9LcA:9 a=7bMcPuIkef6tXU3zCR0A:7 a=r3pxIeYYp_WK11E1b7lG6I68MgMA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: [GIT] merge conflicts of tip/tracing/core and latest perf/core
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Fri, 21 May 2010 10:30:46 -0400
Message-ID: <1274452246.26328.3782.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Once again I resolved the conflicts between tracing/core and the new
changes of perf/core.

Here's the diff, can you please give acks.

Thanks,

-- Steve

After this I'll start basing my changes on perf/core.

diff --cc include/linux/ftrace_event.h
index dc7fc64,7024b7d..0000000
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@@ -164,23 -132,10 +164,26 @@@ struct ftrace_event_call 
  	void			*mod;
  	void			*data;
  
 +	/*
 +	 * 32 bit flags:
 +	 *   bit 1:		enabled
 +	 *   bit 2:		filter_active
 +	 *
 +	 * Changes to flags must hold the event_mutex.
 +	 *
 +	 * Note: Reads of flags do not hold the event_mutex since
 +	 * they occur in critical sections. But the way flags
 +	 * is currently used, these changes do no affect the code
 +	 * except that when a change is made, it may have a slight
 +	 * delay in propagating the changes to other CPUs due to
 +	 * caching and such.
 +	 */
 +	unsigned int		flags;
 +
++#ifdef CONFIG_PERF_EVENTS
  	int			perf_refcount;
+ 	struct hlist_head	*perf_events;
 -	int			(*perf_event_enable)(struct ftrace_event_call *);
 -	void			(*perf_event_disable)(struct ftrace_event_call *);
++#endif
  };
  
  #define PERF_MAX_TRACE_SIZE	2048
diff --cc include/trace/ftrace.h
index e0e8daa,4eb2148..0000000
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@@ -690,20 -762,17 +690,20 @@@ __attribute__((section("_ftrace_events"
  #undef DECLARE_EVENT_CLASS
  #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
  static notrace void							\
 -perf_trace_templ_##call(struct ftrace_event_call *event_call,		\
 -			struct pt_regs *__regs, proto)			\
 +perf_trace_##call(void *__data, proto)					\
  {									\
 +	struct ftrace_event_call *event_call = __data;			\
  	struct ftrace_data_offsets_##call __maybe_unused __data_offsets;\
  	struct ftrace_raw_##call *entry;				\
- 	struct pt_regs *__regs = &get_cpu_var(perf_trace_regs);		\
++	struct pt_regs __regs;						\
  	u64 __addr = 0, __count = 1;					\
- 	unsigned long irq_flags;					\
+ 	struct hlist_head *head;					\
  	int __entry_size;						\
  	int __data_size;						\
  	int rctx;							\
  									\
- 	perf_fetch_caller_regs(__regs, 1);				\
++	perf_fetch_caller_regs(&__regs, 1);				\
 +									\
  	__data_size = ftrace_get_offsets_##call(&__data_offsets, args); \
  	__entry_size = ALIGN(__data_size + sizeof(*entry) + sizeof(u32),\
  			     sizeof(u64));				\
@@@ -711,35 -780,33 +711,35 @@@
  									\
  	if (WARN_ONCE(__entry_size > PERF_MAX_TRACE_SIZE,		\
  		      "profile buffer not large enough"))		\
- 		goto out;						\
+ 		return;							\
+ 									\
  	entry = (struct ftrace_raw_##call *)perf_trace_buf_prepare(	\
- 		__entry_size, event_call->event.type, &rctx, &irq_flags); \
 -		__entry_size, event_call->id, __regs, &rctx);		\
++		__entry_size, event_call->event.type, &__regs, &rctx);	\
  	if (!entry)							\
- 		goto out;						\
+ 		return;							\
+ 									\
  	tstruct								\
  									\
  	{ assign; }							\
  									\
+ 	head = per_cpu_ptr(event_call->perf_events, smp_processor_id());\
  	perf_trace_buf_submit(entry, __entry_size, rctx, __addr,	\
- 			       __count, irq_flags, __regs);		\
-  out:									\
- 	put_cpu_var(perf_trace_regs);					\
 -		__count, __regs, head);					\
++		__count, &__regs, head);				\
  }
  
 +/*
 + * This part is compiled out, it is only here as a build time check
 + * to make sure that if the tracepoint handling changes, the
 + * perf probe will fail to compile unless it too is updated.
 + */
  #undef DEFINE_EVENT
  #define DEFINE_EVENT(template, call, proto, args)			\
 -static notrace void perf_trace_##call(proto)				\
 +static inline void perf_test_probe_##call(void)				\
  {									\
 -	struct ftrace_event_call *event_call = &event_##call;		\
 -	struct pt_regs __regs;						\
 -									\
 -	perf_fetch_caller_regs(&__regs, 1);				\
 -	perf_trace_templ_##template(event_call, &__regs, args);		\
 +	check_trace_callback_type_##call(perf_trace_##template);	\
- 									\
  }
  
 +
  #undef DEFINE_EVENT_PRINT
  #define DEFINE_EVENT_PRINT(template, name, proto, args, print)	\
  	DEFINE_EVENT(template, name, PARAMS(proto), PARAMS(args))
diff --cc kernel/trace/trace_event_perf.c
index 0a47e8d,39d5ea7..0000000
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@@ -27,48 -23,60 +23,66 @@@ typedef typeof(unsigned long [PERF_MAX_
  /* Count the events in use (per event id, not per instance) */
  static int	total_ref_count;
  
- static int perf_trace_event_enable(struct ftrace_event_call *event)
+ static int perf_trace_event_init(struct ftrace_event_call *tp_event,
+ 				 struct perf_event *p_event)
  {
- 	char *buf;
+ 	struct hlist_head *list;
  	int ret = -ENOMEM;
+ 	int cpu;
  
- 	if (event->perf_refcount++ > 0)
+ 	p_event->tp_event = tp_event;
+ 	if (tp_event->perf_refcount++ > 0)
  		return 0;
  
- 	if (!total_ref_count) {
- 		buf = (char *)alloc_percpu(perf_trace_t);
- 		if (!buf)
- 			goto fail_buf;
+ 	list = alloc_percpu(struct hlist_head);
+ 	if (!list)
+ 		goto fail;
+ 
+ 	for_each_possible_cpu(cpu)
+ 		INIT_HLIST_HEAD(per_cpu_ptr(list, cpu));
  
- 		rcu_assign_pointer(perf_trace_buf, buf);
+ 	tp_event->perf_events = list;
+ 
+ 	if (!total_ref_count) {
+ 		char *buf;
+ 		int i;
  
- 		buf = (char *)alloc_percpu(perf_trace_t);
- 		if (!buf)
- 			goto fail_buf_nmi;
+ 		for (i = 0; i < 4; i++) {
+ 			buf = (char *)alloc_percpu(perf_trace_t);
+ 			if (!buf)
+ 				goto fail;
  
- 		rcu_assign_pointer(perf_trace_buf_nmi, buf);
+ 			perf_trace_buf[i] = buf;
+ 		}
  	}
  
- 	if (event->class->reg)
- 		ret = event->class->reg(event, TRACE_REG_PERF_REGISTER);
 -	ret = tp_event->perf_event_enable(tp_event);
++	if (tp_event->class->reg)
++		ret = tp_event->class->reg(tp_event, TRACE_REG_PERF_REGISTER);
 +	else
- 		ret = tracepoint_probe_register(event->name,
- 						event->class->perf_probe,
- 						event);
- 	if (!ret) {
- 		total_ref_count++;
- 		return 0;
- 	}
++		ret = tracepoint_probe_register(tp_event->name,
++						tp_event->class->perf_probe,
++						tp_event);
++
+ 	if (ret)
+ 		goto fail;
  
- fail_buf_nmi:
+ 	total_ref_count++;
+ 	return 0;
+ 
+ fail:
  	if (!total_ref_count) {
- 		free_percpu(perf_trace_buf_nmi);
- 		free_percpu(perf_trace_buf);
- 		perf_trace_buf_nmi = NULL;
- 		perf_trace_buf = NULL;
+ 		int i;
+ 
+ 		for (i = 0; i < 4; i++) {
+ 			free_percpu(perf_trace_buf[i]);
+ 			perf_trace_buf[i] = NULL;
+ 		}
+ 	}
+ 
+ 	if (!--tp_event->perf_refcount) {
+ 		free_percpu(tp_event->perf_events);
+ 		tp_event->perf_events = NULL;
  	}
- fail_buf:
- 	event->perf_refcount--;
  
  	return ret;
  }
@@@ -79,11 -88,10 +94,11 @@@ int perf_trace_init(struct perf_event *
  	int ret = -EINVAL;
  
  	mutex_lock(&event_mutex);
- 	list_for_each_entry(event, &ftrace_events, list) {
- 		if (event->event.type == event_id &&
- 		    event->class && event->class->perf_probe &&
- 		    try_module_get(event->mod)) {
- 			ret = perf_trace_event_enable(event);
+ 	list_for_each_entry(tp_event, &ftrace_events, list) {
 -		if (tp_event->id == event_id && tp_event->perf_event_enable &&
++		if (tp_event->event.type == event_id &&
++		    tp_event->class && tp_event->class->perf_probe &&
+ 		    try_module_get(tp_event->mod)) {
+ 			ret = perf_trace_event_init(tp_event, p_event);
  			break;
  		}
  	}
@@@ -92,49 -100,45 +107,50 @@@
  	return ret;
  }
  
- static void perf_trace_event_disable(struct ftrace_event_call *event)
+ int perf_trace_enable(struct perf_event *p_event)
  {
- 	char *buf, *nmi_buf;
- 
- 	if (--event->perf_refcount > 0)
- 		return;
- 
- 	if (event->class->reg)
- 		event->class->reg(event, TRACE_REG_PERF_UNREGISTER);
- 	else
- 		tracepoint_probe_unregister(event->name, event->class->perf_probe, event);
+ 	struct ftrace_event_call *tp_event = p_event->tp_event;
+ 	struct hlist_head *list;
  
- 	if (!--total_ref_count) {
- 		buf = perf_trace_buf;
- 		rcu_assign_pointer(perf_trace_buf, NULL);
+ 	list = tp_event->perf_events;
+ 	if (WARN_ON_ONCE(!list))
+ 		return -EINVAL;
  
- 		nmi_buf = perf_trace_buf_nmi;
- 		rcu_assign_pointer(perf_trace_buf_nmi, NULL);
+ 	list = per_cpu_ptr(list, smp_processor_id());
+ 	hlist_add_head_rcu(&p_event->hlist_entry, list);
  
- 		/*
- 		 * Ensure every events in profiling have finished before
- 		 * releasing the buffers
- 		 */
- 		synchronize_sched();
+ 	return 0;
+ }
  
- 		free_percpu(buf);
- 		free_percpu(nmi_buf);
- 	}
+ void perf_trace_disable(struct perf_event *p_event)
+ {
+ 	hlist_del_rcu(&p_event->hlist_entry);
  }
  
- void perf_trace_disable(int event_id)
+ void perf_trace_destroy(struct perf_event *p_event)
  {
- 	struct ftrace_event_call *event;
+ 	struct ftrace_event_call *tp_event = p_event->tp_event;
+ 	int i;
  
- 	mutex_lock(&event_mutex);
- 	list_for_each_entry(event, &ftrace_events, list) {
- 		if (event->event.type == event_id) {
- 			perf_trace_event_disable(event);
- 			module_put(event->mod);
- 			break;
+ 	if (--tp_event->perf_refcount > 0)
+ 		return;
+ 
 -	tp_event->perf_event_disable(tp_event);
++	if (tp_event->class->reg)
++		tp_event->class->reg(tp_event, TRACE_REG_PERF_UNREGISTER);
++	else
++		tracepoint_probe_unregister(tp_event->name,
++					    tp_event->class->perf_probe,
++					    tp_event);
+ 
+ 	free_percpu(tp_event->perf_events);
+ 	tp_event->perf_events = NULL;
+ 
+ 	if (!--total_ref_count) {
+ 		for (i = 0; i < 4; i++) {
+ 			free_percpu(perf_trace_buf[i]);
+ 			perf_trace_buf[i] = NULL;
  		}
  	}
- 	mutex_unlock(&event_mutex);
  }
  
  __kprobes void *perf_trace_buf_prepare(int size, unsigned short type,
diff --cc kernel/trace/trace_kprobe.c
index 9a082bb,4681f60..0000000
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@@ -1350,8 -1353,7 +1350,7 @@@ static __kprobes void kprobe_perf_func(
  		     "profile buffer not large enough"))
  		return;
  
- 	entry = perf_trace_buf_prepare(size, call->event.type,
- 				       &rctx, &irq_flags);
 -	entry = perf_trace_buf_prepare(size, call->id, regs, &rctx);
++	entry = perf_trace_buf_prepare(size, call->event.type, regs, &rctx);
  	if (!entry)
  		return;
  
@@@ -1382,8 -1385,7 +1382,7 @@@ static __kprobes void kretprobe_perf_fu
  		     "profile buffer not large enough"))
  		return;
  
- 	entry = perf_trace_buf_prepare(size, call->event.type,
- 				       &rctx, &irq_flags);
 -	entry = perf_trace_buf_prepare(size, call->id, regs, &rctx);
++	entry = perf_trace_buf_prepare(size, call->event.type, regs, &rctx);
  	if (!entry)
  		return;
  
diff --cc kernel/trace/trace_syscalls.c
index 9d35830,eb769f2..0000000
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@@ -511,8 -461,7 +511,7 @@@ static void perf_syscall_enter(void *ig
  		return;
  
  	rec = (struct syscall_trace_enter *)perf_trace_buf_prepare(size,
- 				sys_data->enter_event->event.type,
- 				&rctx, &flags);
 -				sys_data->enter_event->id, regs, &rctx);
++				sys_data->enter_event->event.type, regs, &rctx);
  	if (!rec)
  		return;
  
@@@ -587,8 -538,7 +588,7 @@@ static void perf_syscall_exit(void *ign
  		return;
  
  	rec = (struct syscall_trace_exit *)perf_trace_buf_prepare(size,
- 				sys_data->exit_event->event.type,
- 				&rctx, &flags);
 -				sys_data->exit_event->id, regs, &rctx);
++				sys_data->exit_event->event.type, regs, &rctx);
  	if (!rec)
  		return;
  



