Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591Ab1CHXXF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 18:23:05 -0500
Received: from mail.openrapids.net ([64.15.138.104]:35653 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756392Ab1CHXXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 18:23:03 -0500
Date: Tue, 8 Mar 2011 18:22:58 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        chris <chris@chris-wilson.co.uk>
Subject: Re: [PATCH][RFC] tracing: Enable tracepoints via module parameters
Message-ID: <20110308232258.GA25987@Krystal>
References: <1299622684.20306.77.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299622684.20306.77.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 18:16:44 up 105 days,  4:19,  3 users,  load average: 0.20, 0.16,
	0.13
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> A few months ago it was suggested to have a way to enable tracepoints in
> a module when it is loaded. I tried various methods, but this one seems
> to be the least intrusive. In fact, it requires no modification to the
> module code.
> 
> The trace event now adds its own MODULE_INFO() and kernel_param_ops that
> and links the information about a tracepoint into the module's __param
> section. A module can be loaded with a tracepoint active by adding
> trace_<tracepoint>=1 as one of the parameters.

Hi Steven,

Can you walk me through the expected sequence someone wanting to enable a few
specific module tracepoints would have to go through ? I'm thinking here about
the context of a distro which has on-demand module loading. The scenario I am
thinking about is a distro specifying a basic set of tracepoints to enable in a
"standard catch-all tracing configuration", which includes some tracepoints in
yet-unloaded modules. I'm trying to figure out what the end user experience will
look like if we go for the solution you propose here.

Thanks,

Mathieu

> 
> The following patch is in:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> 
>     branch: rfc/trace
> 
> 
> Steven Rostedt (1):
>       tracing: Enable tracepoints via module parameters
> 
> ----
>  include/linux/ftrace_event.h |    4 +++
>  include/trace/ftrace.h       |   22 ++++++++++++++++-
>  kernel/trace/trace_events.c  |   52 ++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 76 insertions(+), 2 deletions(-)
> ---------------------------
> commit b514aa1b59148994a47086cdd46db7f994b4789e
> Author: Steven Rostedt <srostedt@redhat.com>
> Date:   Tue Mar 8 17:06:14 2011 -0500
> 
>     tracing: Enable tracepoints via module parameters
>     
>     Add the tracepoints within the module to the module info section
>     and allow the tracepoints to be enabled when the module is loaded.
>     
>     For example:
>     
>     [root]# modinfo samples/trace_events/trace-events-sample.ko
>     filename:       samples/trace_events/trace-events-sample.ko
>     license:        GPL
>     description:    trace-events-sample
>     author:         Steven Rostedt
>     tracepoint:     foo_bar
>     srcversion:     F6AC4B8D911A5C5B9CCDD7B
>     depends:
>     vermagic:       2.6.38-rc5+ SMP preempt mod_unload
>     
>     Notice that the trace-events-sample tracepoint "foo_bar" shows
>     up in the modinfo. When loading the module with:
>     
>      # insmod trace-events-sample.ko trace_foo_bar=1
>     
>     The tracepoint "foo_bar" will be enabled.
>     
>     Cc: Yuanhan Liu <yuanhan.liu@linux.intel.com>
>     Cc: Chris Wilson <chris@chris-wilson.co.uk>
>     Cc: Rusty Russell <rusty@rustycorp.com.au>
>     Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
> index 47e3997..b672889 100644
> --- a/include/linux/ftrace_event.h
> +++ b/include/linux/ftrace_event.h
> @@ -124,6 +124,8 @@ void tracing_record_cmdline(struct task_struct *tsk);
>  
>  struct event_filter;
>  
> +extern struct kernel_param_ops ftrace_mod_ops;
> +
>  enum trace_reg {
>  	TRACE_REG_REGISTER,
>  	TRACE_REG_UNREGISTER,
> @@ -155,6 +157,7 @@ enum {
>  	TRACE_EVENT_FL_FILTERED_BIT,
>  	TRACE_EVENT_FL_RECORDED_CMD_BIT,
>  	TRACE_EVENT_FL_CAP_ANY_BIT,
> +	TRACE_EVENT_FL_MOD_ENABLE_BIT,
>  };
>  
>  enum {
> @@ -162,6 +165,7 @@ enum {
>  	TRACE_EVENT_FL_FILTERED		= (1 << TRACE_EVENT_FL_FILTERED_BIT),
>  	TRACE_EVENT_FL_RECORDED_CMD	= (1 << TRACE_EVENT_FL_RECORDED_CMD_BIT),
>  	TRACE_EVENT_FL_CAP_ANY		= (1 << TRACE_EVENT_FL_CAP_ANY_BIT),
> +	TRACE_EVENT_FL_MOD_ENABLE	= (1 << TRACE_EVENT_FL_MOD_ENABLE_BIT),
>  };
>  
>  struct ftrace_event_call {
> diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
> index 3e68366..3d4a6ee 100644
> --- a/include/trace/ftrace.h
> +++ b/include/trace/ftrace.h
> @@ -561,6 +561,22 @@ static inline void ftrace_test_probe_##call(void)			\
>  #undef __get_dynamic_array
>  #undef __get_str
>  
> +/*
> + * Add ftrace trace points in modules to be set by module
> + * parameters. This adds "trace_##call" as a module parameter.
> + * The user could enable trace points on module load with:
> + *  trace_##call=1 as a module parameter.
> + */
> +#undef ftrace_mod_params
> +#ifdef MODULE
> +#define ftrace_mod_params(call)				\
> +	module_param_cb(trace_##call, &ftrace_mod_ops,	\
> +			&event_##call, 0644);		\
> +	MODULE_INFO(tracepoint, #call)
> +#else
> +#define ftrace_mod_params(call)
> +#endif
> +
>  #undef TP_printk
>  #define TP_printk(fmt, args...) "\"" fmt "\", "  __stringify(args)
>  
> @@ -588,7 +604,8 @@ static struct ftrace_event_call __used event_##call = {			\
>  	.print_fmt		= print_fmt_##template,			\
>  };									\
>  static struct ftrace_event_call __used					\
> -__attribute__((section("_ftrace_events"))) *__event_##call = &event_##call
> +__attribute__((section("_ftrace_events"))) *__event_##call = &event_##call;\
> +ftrace_mod_params(call)
>  
>  #undef DEFINE_EVENT_PRINT
>  #define DEFINE_EVENT_PRINT(template, call, proto, args, print)		\
> @@ -602,7 +619,8 @@ static struct ftrace_event_call __used event_##call = {			\
>  	.print_fmt		= print_fmt_##call,			\
>  };									\
>  static struct ftrace_event_call __used					\
> -__attribute__((section("_ftrace_events"))) *__event_##call = &event_##call
> +__attribute__((section("_ftrace_events"))) *__event_##call = &event_##call; \
> +ftrace_mod_params(call)
>  
>  #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
>  
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index 5f499e0..5223751 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -1285,6 +1285,7 @@ static void trace_module_add_events(struct module *mod)
>  {
>  	struct ftrace_module_file_ops *file_ops = NULL;
>  	struct ftrace_event_call **call, **start, **end;
> +	int ret;
>  
>  	start = mod->trace_events;
>  	end = mod->trace_events + mod->num_trace_events;
> @@ -1300,6 +1301,14 @@ static void trace_module_add_events(struct module *mod)
>  		__trace_add_event_call(*call, mod,
>  				       &file_ops->id, &file_ops->enable,
>  				       &file_ops->filter, &file_ops->format);
> +		/* If the module tracepoint parameter was set */
> +		if ((*call)->flags & TRACE_EVENT_FL_MOD_ENABLE) {
> +			(*call)->flags = 0;
> +			ret = ftrace_event_enable_disable(*call, 1);
> +			if (ret < 0)
> +				pr_warning("unable to enable tracepoint %s",
> +					   (*call)->name);
> +		}
>  	}
>  }
>  
> @@ -1457,6 +1466,49 @@ static __init int event_trace_init(void)
>  }
>  fs_initcall(event_trace_init);
>  
> +/* Allow modules to load with enabled trace points */
> +int ftrace_mod_param_set(const char *val, const struct kernel_param *kp)
> +{
> +	struct ftrace_event_call *call = kp->arg;
> +
> +	/* This is set like param_set_bool() */
> +
> +	/* No equals means "set"... */
> +	if (!val)
> +		val = "1";
> +
> +	/* One of =[yYnN01] */
> +	switch (val[0]) {
> +	case 'y': case 'Y': case '1':
> +		break;
> +	case 'n': case 'N': case '0':
> +		/* Do nothing */
> +		return 0;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	/* Set flag to tell ftrace to enable this event on init */
> +	call->flags = TRACE_EVENT_FL_MOD_ENABLE;
> +
> +	return 0;
> +}
> +
> +int ftrace_mod_param_get(char *buffer, const struct kernel_param *kp)
> +{
> +	struct ftrace_event_call *call = kp->arg;
> +
> +	return sprintf(buffer, "%d",
> +		   !!(call->flags &
> +		     (TRACE_EVENT_FL_MOD_ENABLE | TRACE_EVENT_FL_ENABLED)));
> +}
> +
> +struct kernel_param_ops ftrace_mod_ops = {
> +	.set = ftrace_mod_param_set,
> +	.get = ftrace_mod_param_get,
> +};
> +EXPORT_SYMBOL(ftrace_mod_ops);
> +
>  #ifdef CONFIG_FTRACE_STARTUP_TEST
>  
>  static DEFINE_SPINLOCK(test_spinlock);
> 
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
