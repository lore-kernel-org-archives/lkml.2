Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639Ab0FHP57 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 11:57:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:60198 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424Ab0FHP55 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 11:57:57 -0400
Subject: Re: [PATCH][RFC] tracing: Use class->reg() for all registering of
 events
From: Peter Zijlstra <peterz@infradead.org>
To: rostedt@goodmis.org
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>
In-Reply-To: <1276011215.15884.96.camel@gandalf.stny.rr.com>
References: <1276011215.15884.96.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 08 Jun 2010 17:57:41 +0200
Message-ID: <1276012661.2046.120.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-08 at 11:33 -0400, Steven Rostedt wrote:
> I'm pushing this as an RFC first. This probably should be something that
> makes it into 2.6.35.
> 
> Acks and perhaps a little testing from the perf and kprobe angle?

I'll have a look soon, but lets add Srikar to CC, he actually reported
the problem :-)

> Steven Rostedt (1):
>       tracing: Use class->reg() for all registering of events
> 
> ----
>  include/linux/ftrace_event.h    |    3 ++
>  include/trace/ftrace.h          |    2 +
>  kernel/trace/trace_event_perf.c |   17 ++----------
>  kernel/trace/trace_events.c     |   55 +++++++++++++++++++++++++-------------
>  4 files changed, 44 insertions(+), 33 deletions(-)
> ---------------------------
> commit 0ab320dbe5894d7b4eec7d7da3a270abc68e4992
> Author: Steven Rostedt <srostedt@redhat.com>
> Date:   Tue Jun 8 11:22:06 2010 -0400
> 
>     tracing: Use class->reg() for all registering of events
>     
>     Because kprobes and syscalls need special processing to register
>     events, the class->reg() method was created to handle the differences.
>     
>     But instead of creating a default ->reg for perf and ftrace events,
>     the code was scattered with:
>     
>     	if (class->reg)
>     		class->reg();
>     	else
>     		default_reg();
>     
>     This is messy and can also lead to bugs.
>     
>     This patch cleans up this code and creates a default reg() entry for
>     the events allowing for the code to directly call the class->reg()
>     without the condition.
>     
>     Reported-by: Peter Zijlstra <peterz@infradead.org>
>     Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
> index 3167f2d..a69bd32 100644
> --- a/include/linux/ftrace_event.h
> +++ b/include/linux/ftrace_event.h
> @@ -146,6 +146,9 @@ struct ftrace_event_class {
>  	int			(*raw_init)(struct ftrace_event_call *);
>  };
>  
> +extern int ftrace_event_reg(struct ftrace_event_call *event,
> +			    enum trace_reg type);
> +
>  enum {
>  	TRACE_EVENT_FL_ENABLED_BIT,
>  	TRACE_EVENT_FL_FILTERED_BIT,
> diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
> index 5a64905..8815e27 100644
> --- a/include/trace/ftrace.h
> +++ b/include/trace/ftrace.h
> @@ -439,6 +439,7 @@ static inline notrace int ftrace_get_offsets_##call(			\
>   *	.fields			= LIST_HEAD_INIT(event_class_##call.fields),
>   *	.raw_init		= trace_event_raw_init,
>   *	.probe			= ftrace_raw_event_##call,
> + *	.reg			= ftrace_event_reg,
>   * };
>   *
>   * static struct ftrace_event_call __used
> @@ -567,6 +568,7 @@ static struct ftrace_event_class __used event_class_##call = {		\
>  	.fields			= LIST_HEAD_INIT(event_class_##call.fields),\
>  	.raw_init		= trace_event_raw_init,			\
>  	.probe			= ftrace_raw_event_##call,		\
> +	.reg			= ftrace_event_reg,			\
>  	_TRACE_PERF_INIT(call)						\
>  };
>  
> diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
> index e6f6588..de2f170 100644
> --- a/kernel/trace/trace_event_perf.c
> +++ b/kernel/trace/trace_event_perf.c
> @@ -56,13 +56,7 @@ static int perf_trace_event_init(struct ftrace_event_call *tp_event,
>  		}
>  	}
>  
> -	if (tp_event->class->reg)
> -		ret = tp_event->class->reg(tp_event, TRACE_REG_PERF_REGISTER);
> -	else
> -		ret = tracepoint_probe_register(tp_event->name,
> -						tp_event->class->perf_probe,
> -						tp_event);
> -
> +	ret = tp_event->class->reg(tp_event, TRACE_REG_PERF_REGISTER);
>  	if (ret)
>  		goto fail;
>  
> @@ -96,7 +90,7 @@ int perf_trace_init(struct perf_event *p_event)
>  	mutex_lock(&event_mutex);
>  	list_for_each_entry(tp_event, &ftrace_events, list) {
>  		if (tp_event->event.type == event_id &&
> -		    tp_event->class && tp_event->class->perf_probe &&
> +		    tp_event->class && tp_event->class->reg &&
>  		    try_module_get(tp_event->mod)) {
>  			ret = perf_trace_event_init(tp_event, p_event);
>  			break;
> @@ -136,12 +130,7 @@ void perf_trace_destroy(struct perf_event *p_event)
>  	if (--tp_event->perf_refcount > 0)
>  		goto out;
>  
> -	if (tp_event->class->reg)
> -		tp_event->class->reg(tp_event, TRACE_REG_PERF_UNREGISTER);
> -	else
> -		tracepoint_probe_unregister(tp_event->name,
> -					    tp_event->class->perf_probe,
> -					    tp_event);
> +	tp_event->class->reg(tp_event, TRACE_REG_PERF_UNREGISTER);
>  
>  	/*
>  	 * Ensure our callback won't be called anymore. See
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index 45a8968..b353639 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -132,6 +132,35 @@ int trace_event_raw_init(struct ftrace_event_call *call)
>  }
>  EXPORT_SYMBOL_GPL(trace_event_raw_init);
>  
> +int ftrace_event_reg(struct ftrace_event_call *call, enum trace_reg type)
> +{
> +	switch (type) {
> +	case TRACE_REG_REGISTER:
> +		return tracepoint_probe_register(call->name,
> +						 call->class->probe,
> +						 call);
> +	case TRACE_REG_UNREGISTER:
> +		tracepoint_probe_unregister(call->name,
> +					    call->class->probe,
> +					    call);
> +		return 0;
> +
> +#ifdef CONFIG_PERF_EVENTS
> +	case TRACE_REG_PERF_REGISTER:
> +		return tracepoint_probe_register(call->name,
> +						 call->class->perf_probe,
> +						 call);
> +	case TRACE_REG_PERF_UNREGISTER:
> +		tracepoint_probe_unregister(call->name,
> +					    call->class->perf_probe,
> +					    call);
> +		return 0;
> +#endif
> +	}
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(ftrace_event_reg);
> +
>  static int ftrace_event_enable_disable(struct ftrace_event_call *call,
>  					int enable)
>  {
> @@ -142,23 +171,13 @@ static int ftrace_event_enable_disable(struct ftrace_event_call *call,
>  		if (call->flags & TRACE_EVENT_FL_ENABLED) {
>  			call->flags &= ~TRACE_EVENT_FL_ENABLED;
>  			tracing_stop_cmdline_record();
> -			if (call->class->reg)
> -				call->class->reg(call, TRACE_REG_UNREGISTER);
> -			else
> -				tracepoint_probe_unregister(call->name,
> -							    call->class->probe,
> -							    call);
> +			call->class->reg(call, TRACE_REG_UNREGISTER);
>  		}
>  		break;
>  	case 1:
>  		if (!(call->flags & TRACE_EVENT_FL_ENABLED)) {
>  			tracing_start_cmdline_record();
> -			if (call->class->reg)
> -				ret = call->class->reg(call, TRACE_REG_REGISTER);
> -			else
> -				ret = tracepoint_probe_register(call->name,
> -								call->class->probe,
> -								call);
> +			ret = call->class->reg(call, TRACE_REG_REGISTER);
>  			if (ret) {
>  				tracing_stop_cmdline_record();
>  				pr_info("event trace: Could not enable event "
> @@ -196,8 +215,7 @@ static int __ftrace_set_clr_event(const char *match, const char *sub,
>  	mutex_lock(&event_mutex);
>  	list_for_each_entry(call, &ftrace_events, list) {
>  
> -		if (!call->name || !call->class ||
> -		    (!call->class->probe && !call->class->reg))
> +		if (!call->name || !call->class || !call->class->reg)
>  			continue;
>  
>  		if (match &&
> @@ -323,7 +341,7 @@ t_next(struct seq_file *m, void *v, loff_t *pos)
>  		 * The ftrace subsystem is for showing formats only.
>  		 * They can not be enabled or disabled via the event files.
>  		 */
> -		if (call->class && (call->class->probe || call->class->reg))
> +		if (call->class && call->class->reg)
>  			return call;
>  	}
>  
> @@ -476,8 +494,7 @@ system_enable_read(struct file *filp, char __user *ubuf, size_t cnt,
>  
>  	mutex_lock(&event_mutex);
>  	list_for_each_entry(call, &ftrace_events, list) {
> -		if (!call->name || !call->class ||
> -		    (!call->class->probe && !call->class->reg))
> +		if (!call->name || !call->class || !call->class->reg)
>  			continue;
>  
>  		if (system && strcmp(call->class->system, system) != 0)
> @@ -1037,12 +1054,12 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events,
>  		return -1;
>  	}
>  
> -	if (call->class->probe || call->class->reg)
> +	if (call->class->reg)
>  		trace_create_file("enable", 0644, call->dir, call,
>  				  enable);
>  
>  #ifdef CONFIG_PERF_EVENTS
> -	if (call->event.type && (call->class->perf_probe || call->class->reg))
> +	if (call->event.type && call->class->reg)
>  		trace_create_file("id", 0444, call->dir, call,
>  		 		  id);
>  #endif
> 
> 

