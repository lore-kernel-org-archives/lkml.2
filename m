Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673Ab1GPLLP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 07:11:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:48164 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997Ab1GPLLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 07:11:14 -0400
X-Authority-Analysis: v=1.1 cv=5asQ6euaRPJxDdFxwvXsn6JDb7fmFbz8qWDLMfa45gU= c=1 sm=0 a=ON99fBoUYPsA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=3nbZYyFuAAAA:8 a=meVymXHHAAAA:8 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=-TLkxdQCdBZjBqNEBr4A:9 a=hG1mX66-JhdNCUnWGJcA:7 a=PUjeQqilurYA:10 a=EvKJbDF4Ut8A:10 a=jeBq3FmKZ4MA:10 a=MSl-tDqOz04A:10 a=jEp0ucaQiEUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH -tip v2] [CLEANUP]tracing/kprobes: merge trace probe
 enable/disable functions
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@elte.hu>, yrl.pp-manager.tt@hitachi.com,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
In-Reply-To: <20110716103331.24432.98638.stgit@fedora15>
References: <1310750862.27864.71.camel@gandalf.stny.rr.com>
	 <20110716103331.24432.98638.stgit@fedora15>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Sat, 16 Jul 2011 07:11:11 -0400
Message-ID: <1310814671.27864.79.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-07-16 at 19:33 +0900, Masami Hiramatsu wrote:
> Merge redundant enable/disable functions into enable_trace_probe()
> and disable_trace_probe().
> 
> Changes from v1:
> - replace probe_event_enable() with enable_trace_probe()
>   in self-test code too.

Ah, I already fixed it and ran it through all my tests. I'll send it out
in a minute. I'll make sure I fixed it the same way first.

Thanks!

-- Steve

> 
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
> 
>  kernel/trace/trace_kprobe.c |   92 +++++++++++++++++--------------------------
>  1 files changed, 36 insertions(+), 56 deletions(-)
> 
> diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
> index 14b88ed..3be50c5 100644
> --- a/kernel/trace/trace_kprobe.c
> +++ b/kernel/trace/trace_kprobe.c
> @@ -683,6 +683,34 @@ static struct trace_probe *find_trace_probe(const char *event,
>  	return NULL;
>  }
>  
> +/* Enable trace_probe - @flag must be TP_FLAG_TRACE or TP_FLAG_PROFILE */
> +static int enable_trace_probe(struct trace_probe *tp, int flag)
> +{
> +	int ret = 0;
> +
> +	tp->flags |= flag;
> +	if (tp->flags & (TP_FLAG_TRACE | TP_FLAG_PROFILE)) {
> +		if (trace_probe_is_return(tp))
> +			ret = enable_kretprobe(&tp->rp);
> +		else
> +			ret = enable_kprobe(&tp->rp.kp);
> +	}
> +
> +	return ret;
> +}
> +
> +/* Disable trace_probe - @flag must be TP_FLAG_TRACE or TP_FLAG_PROFILE */
> +static void disable_trace_probe(struct trace_probe *tp, int flag)
> +{
> +	tp->flags &= ~flag;
> +	if (!(tp->flags & (TP_FLAG_TRACE | TP_FLAG_PROFILE))) {
> +		if (trace_probe_is_return(tp))
> +			disable_kretprobe(&tp->rp);
> +		else
> +			disable_kprobe(&tp->rp.kp);
> +	}
> +}
> +
>  /* Unregister a trace_probe and probe_event: call with locking probe_lock */
>  static void unregister_trace_probe(struct trace_probe *tp)
>  {
> @@ -1514,30 +1542,6 @@ partial:
>  	return TRACE_TYPE_PARTIAL_LINE;
>  }
>  
> -static int probe_event_enable(struct ftrace_event_call *call)
> -{
> -	struct trace_probe *tp = (struct trace_probe *)call->data;
> -
> -	tp->flags |= TP_FLAG_TRACE;
> -	if (trace_probe_is_return(tp))
> -		return enable_kretprobe(&tp->rp);
> -	else
> -		return enable_kprobe(&tp->rp.kp);
> -}
> -
> -static void probe_event_disable(struct ftrace_event_call *call)
> -{
> -	struct trace_probe *tp = (struct trace_probe *)call->data;
> -
> -	tp->flags &= ~TP_FLAG_TRACE;
> -	if (!(tp->flags & (TP_FLAG_TRACE | TP_FLAG_PROFILE))) {
> -		if (trace_probe_is_return(tp))
> -			disable_kretprobe(&tp->rp);
> -		else
> -			disable_kprobe(&tp->rp.kp);
> -	}
> -}
> -
>  #undef DEFINE_FIELD
>  #define DEFINE_FIELD(type, item, name, is_signed)			\
>  	do {								\
> @@ -1716,49 +1720,25 @@ static __kprobes void kretprobe_perf_func(struct kretprobe_instance *ri,
>  	head = this_cpu_ptr(call->perf_events);
>  	perf_trace_buf_submit(entry, size, rctx, entry->ret_ip, 1, regs, head);
>  }
> -
> -static int probe_perf_enable(struct ftrace_event_call *call)
> -{
> -	struct trace_probe *tp = (struct trace_probe *)call->data;
> -
> -	tp->flags |= TP_FLAG_PROFILE;
> -
> -	if (trace_probe_is_return(tp))
> -		return enable_kretprobe(&tp->rp);
> -	else
> -		return enable_kprobe(&tp->rp.kp);
> -}
> -
> -static void probe_perf_disable(struct ftrace_event_call *call)
> -{
> -	struct trace_probe *tp = (struct trace_probe *)call->data;
> -
> -	tp->flags &= ~TP_FLAG_PROFILE;
> -
> -	if (!(tp->flags & TP_FLAG_TRACE)) {
> -		if (trace_probe_is_return(tp))
> -			disable_kretprobe(&tp->rp);
> -		else
> -			disable_kprobe(&tp->rp.kp);
> -	}
> -}
>  #endif	/* CONFIG_PERF_EVENTS */
>  
>  static __kprobes
>  int kprobe_register(struct ftrace_event_call *event, enum trace_reg type)
>  {
> +	struct trace_probe *tp = (struct trace_probe *)event->data;
> +
>  	switch (type) {
>  	case TRACE_REG_REGISTER:
> -		return probe_event_enable(event);
> +		return enable_trace_probe(tp, TP_FLAG_TRACE);
>  	case TRACE_REG_UNREGISTER:
> -		probe_event_disable(event);
> +		disable_trace_probe(tp, TP_FLAG_TRACE);
>  		return 0;
>  
>  #ifdef CONFIG_PERF_EVENTS
>  	case TRACE_REG_PERF_REGISTER:
> -		return probe_perf_enable(event);
> +		return enable_trace_probe(tp, TP_FLAG_PROFILE);
>  	case TRACE_REG_PERF_UNREGISTER:
> -		probe_perf_disable(event);
> +		disable_trace_probe(tp, TP_FLAG_PROFILE);
>  		return 0;
>  #endif
>  	}
> @@ -1905,7 +1885,7 @@ static __init int kprobe_trace_self_tests_init(void)
>  			pr_warning("error on getting new probe.\n");
>  			warn++;
>  		} else
> -			probe_event_enable(&tp->call);
> +			enable_trace_probe(tp, TP_FLAG_TRACE);
>  	}
>  
>  	ret = command_trace_probe("r:testprobe2 kprobe_trace_selftest_target "
> @@ -1920,7 +1900,7 @@ static __init int kprobe_trace_self_tests_init(void)
>  			pr_warning("error on getting new probe.\n");
>  			warn++;
>  		} else
> -			probe_event_enable(&tp->call);
> +			enable_trace_probe(tp, TP_FLAG_TRACE);
>  	}
>  
>  	if (warn)


