Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464Ab0EREnJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 00:43:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:61067 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654Ab0EREnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 00:43:08 -0400
X-Authority-Analysis: v=1.1 cv=MoOeBCR3UCSroT7bBzr0mtJUqJhHyBWzyNa37ex1qNU= c=1 sm=0 a=K0ThpunADJEA:10 a=UBIxAjGgU1YA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=xeu_cWMkryoJN9DYUz0A:9 a=XPvuniaStivQEWuSSoQA:7 a=wXpD4jcDwZA18I7RZ7lrx44_N_UA:4 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: [GIT PULL] tracing: merge with conflict resolution between
 perf/core and tracing/core
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Masami Hiramatsu <mhiramat@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Tue, 18 May 2010 00:43:02 -0400
Message-ID: <1274157782.26328.737.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

I pulled perf/core into tracing core and resolved the conflicts. Both
Masami and Frederic gave their Acks. Frederic also pointed out that the
returns in the perf probe need to handle the get_cpu_var, which I fixed.

Please pull the latest tip/tracing/core-6 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/core-6



commit f0218b3e9974f06014b61be8987159f4a20e011e
Merge: 1eaa478 9d192e1
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Mon May 17 22:26:53 2010 -0400

    Merge branch 'perf/core' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip into trace/tip/tracing/core-6
    
    Conflicts:
    	include/trace/ftrace.h
    	kernel/trace/trace_kprobe.c
    
    Acked-by: Masami Hiramatsu <mhiramat@redhat.com>
    Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --cc include/trace/ftrace.h
index 4866c10,882c648..e0e8daa
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@@ -690,18 -757,17 +690,20 @@@ __attribute__((section("_ftrace_events"
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
++	struct pt_regs *__regs = &get_cpu_var(perf_trace_regs);		\
  	u64 __addr = 0, __count = 1;					\
  	unsigned long irq_flags;					\
- 	struct pt_regs *__regs;						\
  	int __entry_size;						\
  	int __data_size;						\
  	int rctx;							\
  									\
++	perf_fetch_caller_regs(__regs, 1);				\
++									\
  	__data_size = ftrace_get_offsets_##call(&__data_offsets, args); \
  	__entry_size = ALIGN(__data_size + sizeof(*entry) + sizeof(u32),\
  			     sizeof(u64));				\
@@@ -709,36 -775,33 +711,35 @@@
  									\
  	if (WARN_ONCE(__entry_size > PERF_MAX_TRACE_SIZE,		\
  		      "profile buffer not large enough"))		\
--		return;							\
++		goto out;						\
  	entry = (struct ftrace_raw_##call *)perf_trace_buf_prepare(	\
 -		__entry_size, event_call->id, &rctx, &irq_flags);	\
 +		__entry_size, event_call->event.type, &rctx, &irq_flags); \
  	if (!entry)							\
--		return;							\
++		goto out;						\
  	tstruct								\
  									\
  	{ assign; }							\
  									\
- 	__regs = &__get_cpu_var(perf_trace_regs);			\
- 	perf_fetch_caller_regs(__regs, 2);				\
- 									\
  	perf_trace_buf_submit(entry, __entry_size, rctx, __addr,	\
  			       __count, irq_flags, __regs);		\
++ out:									\
++	put_cpu_var(perf_trace_regs);					\
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
 -	struct pt_regs *__regs = &get_cpu_var(perf_trace_regs);		\
 -									\
 -	perf_fetch_caller_regs(__regs, 1);				\
 +	check_trace_callback_type_##call(perf_trace_##template);	\
  									\
 -	perf_trace_templ_##template(event_call, __regs, args);		\
 -									\
 -	put_cpu_var(perf_trace_regs);					\
  }
  
 +
  #undef DEFINE_EVENT_PRINT
  #define DEFINE_EVENT_PRINT(template, name, proto, args, print)	\
  	DEFINE_EVENT(template, name, PARAMS(proto), PARAMS(args))
diff --cc kernel/trace/trace_kprobe.c
index 0e3ded6,a751432..9a082bb
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@@ -202,8 -324,9 +324,9 @@@ struct trace_probe 
  	unsigned long 		nhit;
  	unsigned int		flags;	/* For TP_FLAG_* */
  	const char		*symbol;	/* symbol name */
 +	struct ftrace_event_class	class;
  	struct ftrace_event_call	call;
 -	struct trace_event		event;
+ 	ssize_t			size;		/* trace entry size */
  	unsigned int		nr_args;
  	struct probe_arg	args[];
  };
@@@ -795,11 -901,10 +902,10 @@@ static void probes_seq_stop(struct seq_
  static int probes_seq_show(struct seq_file *m, void *v)
  {
  	struct trace_probe *tp = v;
- 	int i, ret;
- 	char buf[MAX_ARGSTR_LEN + 1];
+ 	int i;
  
  	seq_printf(m, "%c", probe_is_return(tp) ? 'r' : 'p');
 -	seq_printf(m, ":%s/%s", tp->call.system, tp->call.name);
 +	seq_printf(m, ":%s/%s", tp->call.class->system, tp->call.name);
  
  	if (!tp->symbol)
  		seq_printf(m, " 0x%p", tp->rp.kp.addr);
@@@ -958,10 -1059,10 +1060,10 @@@ static __kprobes void kprobe_trace_func
  	local_save_flags(irq_flags);
  	pc = preempt_count();
  
- 	size = SIZEOF_KPROBE_TRACE_ENTRY(tp->nr_args);
+ 	size = sizeof(*entry) + tp->size;
  
 -	event = trace_current_buffer_lock_reserve(&buffer, call->id, size,
 -						  irq_flags, pc);
 +	event = trace_current_buffer_lock_reserve(&buffer, call->event.type,
 +						  size, irq_flags, pc);
  	if (!event)
  		return;
  
@@@ -990,10 -1092,10 +1093,10 @@@ static __kprobes void kretprobe_trace_f
  	local_save_flags(irq_flags);
  	pc = preempt_count();
  
- 	size = SIZEOF_KRETPROBE_TRACE_ENTRY(tp->nr_args);
+ 	size = sizeof(*entry) + tp->size;
  
 -	event = trace_current_buffer_lock_reserve(&buffer, call->id, size,
 -						  irq_flags, pc);
 +	event = trace_current_buffer_lock_reserve(&buffer, call->event.type,
 +						  size, irq_flags, pc);
  	if (!event)
  		return;
  
@@@ -1010,16 -1112,18 +1113,17 @@@
  
  /* Event entry printers */
  enum print_line_t
 -print_kprobe_event(struct trace_iterator *iter, int flags)
 +print_kprobe_event(struct trace_iterator *iter, int flags,
 +		   struct trace_event *event)
  {
- 	struct kprobe_trace_entry *field;
+ 	struct kprobe_trace_entry_head *field;
  	struct trace_seq *s = &iter->seq;
 -	struct trace_event *event;
  	struct trace_probe *tp;
+ 	u8 *data;
  	int i;
  
- 	field = (struct kprobe_trace_entry *)iter->ent;
+ 	field = (struct kprobe_trace_entry_head *)iter->ent;
 -	event = ftrace_find_event(field->ent.type);
 -	tp = container_of(event, struct trace_probe, event);
 +	tp = container_of(event, struct trace_probe, call.event);
  
  	if (!trace_seq_printf(s, "%s: (", tp->call.name))
  		goto partial;
@@@ -1044,16 -1149,18 +1149,17 @@@ partial
  }
  
  enum print_line_t
 -print_kretprobe_event(struct trace_iterator *iter, int flags)
 +print_kretprobe_event(struct trace_iterator *iter, int flags,
 +		      struct trace_event *event)
  {
- 	struct kretprobe_trace_entry *field;
+ 	struct kretprobe_trace_entry_head *field;
  	struct trace_seq *s = &iter->seq;
 -	struct trace_event *event;
  	struct trace_probe *tp;
+ 	u8 *data;
  	int i;
  
- 	field = (struct kretprobe_trace_entry *)iter->ent;
+ 	field = (struct kretprobe_trace_entry_head *)iter->ent;
 -	event = ftrace_find_event(field->ent.type);
 -	tp = container_of(event, struct trace_probe, event);
 +	tp = container_of(event, struct trace_probe, call.event);
  
  	if (!trace_seq_printf(s, "%s: (", tp->call.name))
  		goto partial;


