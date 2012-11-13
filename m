Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755698Ab2KMUOW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 15:14:22 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3772 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754864Ab2KMUOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 15:14:21 -0500
X-Authority-Analysis: v=2.0 cv=RoZH3VaK c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=5Xtx3q0f4H0A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=_FLLeQT4LzsA:10 a=GvQkQWPkAAAA:8 a=pGLkceISAAAA:8 a=Dm5ff2XOCjhLPtTZpxkA:9 a=PUjeQqilurYA:10 a=Wwjp7rKQgkIA:10 a=MSl-tDqOz04A:10 a=NWVoK91CQyQA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1352837659.18025.37.camel@gandalf.local.home>
Subject: Re: [PATCH cleanup RFC] ftrace: kill unused and puzzled sample code
 in ftrace.h
From: Steven Rostedt <rostedt@goodmis.org>
To: Shan Wei <asweisun@gmail.com>
Cc: fweisbec@gmail.com, mingo@redhat.com, Shan Wei <shanwei88@gmail.com>,
        Kernel-Maillist <linux-kernel@vger.kernel.org>
Date: Tue, 13 Nov 2012 15:14:19 -0500
In-Reply-To: <50949FC9.6050202@gmail.com>
References: <50949FC9.6050202@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-11-03 at 12:38 +0800, Shan Wei wrote:
> From: Shan Wei <davidshan@tencent.com>
> 
> When doing per-cpu helper optimizing work, find that this code is so puzzled.
> 1. It's mark as comment text, maybe a sample function for guidelines 
>    or a todo work.
> 2. But, this sample code is odd where struct perf_trace_buf is nonexistent.
>    commit ce71b9 delete struct perf_trace_buf definition.
> 
>    Author: Frederic Weisbecker <fweisbec@gmail.com>
>    Date:   Sun Nov 22 05:26:55 2009 +0100
> 
>    tracing: Use the perf recursion protection from trace event
> 
> Is it necessary to keep there?
> just compile test. 
> 

I have no problem with this. I can take a look later. If it it's just
dead comments then I'll apply it.

Thanks,

-- Steve

> 
> 
> Signed-off-by: Shan Wei <davidshan@tencent.com>
> ---
>  include/trace/ftrace.h |   73 ------------------------------------------------
>  1 files changed, 0 insertions(+), 73 deletions(-)
> 
> diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
> index a763888..4f993c2 100644
> --- a/include/trace/ftrace.h
> +++ b/include/trace/ftrace.h
> @@ -620,79 +620,6 @@ __attribute__((section("_ftrace_events"))) *__event_##call = &event_##call
>  
>  #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
>  
> -/*
> - * Define the insertion callback to perf events
> - *
> - * The job is very similar to ftrace_raw_event_<call> except that we don't
> - * insert in the ring buffer but in a perf counter.
> - *
> - * static void ftrace_perf_<call>(proto)
> - * {
> - *	struct ftrace_data_offsets_<call> __maybe_unused __data_offsets;
> - *	struct ftrace_event_call *event_call = &event_<call>;
> - *	extern void perf_tp_event(int, u64, u64, void *, int);
> - *	struct ftrace_raw_##call *entry;
> - *	struct perf_trace_buf *trace_buf;
> - *	u64 __addr = 0, __count = 1;
> - *	unsigned long irq_flags;
> - *	struct trace_entry *ent;
> - *	int __entry_size;
> - *	int __data_size;
> - *	int __cpu
> - *	int pc;
> - *
> - *	pc = preempt_count();
> - *
> - *	__data_size = ftrace_get_offsets_<call>(&__data_offsets, args);
> - *
> - *	// Below we want to get the aligned size by taking into account
> - *	// the u32 field that will later store the buffer size
> - *	__entry_size = ALIGN(__data_size + sizeof(*entry) + sizeof(u32),
> - *			     sizeof(u64));
> - *	__entry_size -= sizeof(u32);
> - *
> - *	// Protect the non nmi buffer
> - *	// This also protects the rcu read side
> - *	local_irq_save(irq_flags);
> - *	__cpu = smp_processor_id();
> - *
> - *	if (in_nmi())
> - *		trace_buf = rcu_dereference_sched(perf_trace_buf_nmi);
> - *	else
> - *		trace_buf = rcu_dereference_sched(perf_trace_buf);
> - *
> - *	if (!trace_buf)
> - *		goto end;
> - *
> - *	trace_buf = per_cpu_ptr(trace_buf, __cpu);
> - *
> - * 	// Avoid recursion from perf that could mess up the buffer
> - * 	if (trace_buf->recursion++)
> - *		goto end_recursion;
> - *
> - * 	raw_data = trace_buf->buf;
> - *
> - *	// Make recursion update visible before entering perf_tp_event
> - *	// so that we protect from perf recursions.
> - *
> - *	barrier();
> - *
> - *	//zero dead bytes from alignment to avoid stack leak to userspace:
> - *	*(u64 *)(&raw_data[__entry_size - sizeof(u64)]) = 0ULL;
> - *	entry = (struct ftrace_raw_<call> *)raw_data;
> - *	ent = &entry->ent;
> - *	tracing_generic_entry_update(ent, irq_flags, pc);
> - *	ent->type = event_call->id;
> - *
> - *	<tstruct> <- do some jobs with dynamic arrays
> - *
> - *	<assign>  <- affect our values
> - *
> - *	perf_tp_event(event_call->id, __addr, __count, entry,
> - *		     __entry_size);  <- submit them to perf counter
> - *
> - * }
> - */
>  
>  #ifdef CONFIG_PERF_EVENTS
>  


