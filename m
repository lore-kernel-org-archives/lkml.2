Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666Ab0CXDHK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 23:07:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:53191 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177Ab0CXDHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 23:07:08 -0400
X-Authority-Analysis: v=1.0 c=1 a=vFe4eJBBAFkA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=omOdbC7AAAAA:8 a=0BlDLu3bFE9dba-2CVUA:9 a=NyXHIoZzeo5pkLYlyTwA:7 a=d2a9a-SVMvpuHNgDmSF2OZS_GOoA:4 a=PUjeQqilurYA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 3/3] tracing: Update comments
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4BA97FD0.7090202@cn.fujitsu.com>
References: <4BA97FA7.6040406@cn.fujitsu.com>
	 <4BA97FD0.7090202@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Tue, 23 Mar 2010 23:07:06 -0400
Message-ID: <1269400026.2957.1940.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-24 at 10:58 +0800, Li Zefan wrote:
> Make some comments consistent with the code.
> 

Thanks, I'll queue this for 35.

-- Steve

> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  include/trace/ftrace.h |   33 +++++++++++++++++++--------------
>  1 files changed, 19 insertions(+), 14 deletions(-)
> 
> diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
> index ea6f9d4..75dd778 100644
> --- a/include/trace/ftrace.h
> +++ b/include/trace/ftrace.h
> @@ -154,9 +154,11 @@
>   *
>   *	field = (typeof(field))entry;
>   *
> - *	p = get_cpu_var(ftrace_event_seq);
> + *	p = &get_cpu_var(ftrace_event_seq);
>   *	trace_seq_init(p);
> - *	ret = trace_seq_printf(s, <TP_printk> "\n");
> + *	ret = trace_seq_printf(s, "%s: ", <call>);
> + *	if (ret)
> + *		ret = trace_seq_printf(s, <TP_printk> "\n");
>   *	put_cpu();
>   *	if (!ret)
>   *		return TRACE_TYPE_PARTIAL_LINE;
> @@ -450,38 +452,38 @@ perf_trace_disable_##name(struct ftrace_event_call *unused)		\
>   *
>   * static void ftrace_raw_event_<call>(proto)
>   * {
> + *	struct ftrace_data_offsets_<call> __maybe_unused __data_offsets;
>   *	struct ring_buffer_event *event;
>   *	struct ftrace_raw_<call> *entry; <-- defined in stage 1
>   *	struct ring_buffer *buffer;
>   *	unsigned long irq_flags;
> + *	int __data_size;
>   *	int pc;
>   *
>   *	local_save_flags(irq_flags);
>   *	pc = preempt_count();
>   *
> + *	__data_size = ftrace_get_offsets_<call>(&__data_offsets, args);
> + *
>   *	event = trace_current_buffer_lock_reserve(&buffer,
>   *				  event_<call>.id,
> - *				  sizeof(struct ftrace_raw_<call>),
> + *				  sizeof(*entry) + __data_size,
>   *				  irq_flags, pc);
>   *	if (!event)
>   *		return;
>   *	entry	= ring_buffer_event_data(event);
>   *
> - *	<assign>;  <-- Here we assign the entries by the __field and
> - *			__array macros.
> + *	{ <assign>; }  <-- Here we assign the entries by the __field and
> + *			   __array macros.
>   *
> - *	trace_current_buffer_unlock_commit(buffer, event, irq_flags, pc);
> + *	if (!filter_current_check_discard(buffer, event_call, entry, event))
> + *		trace_current_buffer_unlock_commit(buffer,
> + *						   event, irq_flags, pc);
>   * }
>   *
>   * static int ftrace_raw_reg_event_<call>(struct ftrace_event_call *unused)
>   * {
> - *	int ret;
> - *
> - *	ret = register_trace_<call>(ftrace_raw_event_<call>);
> - *	if (!ret)
> - *		pr_info("event trace: Could not activate trace point "
> - *			"probe to <call>");
> - *	return ret;
> + *	return register_trace_<call>(ftrace_raw_event_<call>);
>   * }
>   *
>   * static void ftrace_unreg_event_<call>(struct ftrace_event_call *unused)
> @@ -493,6 +495,8 @@ perf_trace_disable_##name(struct ftrace_event_call *unused)		\
>   *	.trace			= ftrace_raw_output_<call>, <-- stage 2
>   * };
>   *
> + * static const char print_fmt_<call>[] = <TP_printk>;
> + *
>   * static struct ftrace_event_call __used
>   * __attribute__((__aligned__(4)))
>   * __attribute__((section("_ftrace_events"))) event_<call> = {
> @@ -501,6 +505,8 @@ perf_trace_disable_##name(struct ftrace_event_call *unused)		\
>   *	.raw_init		= trace_event_raw_init,
>   *	.regfunc		= ftrace_reg_event_<call>,
>   *	.unregfunc		= ftrace_unreg_event_<call>,
> + *	.print_fmt		= print_fmt_<call>,
> + *	.define_fields		= ftrace_define_fields_<call>,
>   * }
>   *
>   */
> @@ -569,7 +575,6 @@ ftrace_raw_event_id_##call(struct ftrace_event_call *event_call,	\
>  		return;							\
>  	entry	= ring_buffer_event_data(event);			\
>  									\
> -									\
>  	tstruct								\
>  									\
>  	{ assign; }							\


