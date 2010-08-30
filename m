Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513Ab0H3XcW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 19:32:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:54366 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421Ab0H3XcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 19:32:21 -0400
X-Authority-Analysis: v=1.1 cv=u9yrfc8dX8+D+pHqGYUzxVYM/oVXAp/JCIDMGESp0LA= c=1 sm=0 a=AYXAra_8yX0A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=omOdbC7AAAAA:8 a=-DOvqGfya218eARkalQA:9 a=uSVmx391JH4S5LWGd1UA:7 a=5MC1Gi9qIzdk6dGYEpCPyXnsdM0A:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] tracing: Fix a race in function profile
From: Steven Rostedt <rostedt@goodmis.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4C723644.4040708@cn.fujitsu.com>
References: <4C723644.4040708@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 30 Aug 2010 19:32:18 -0400
Message-ID: <1283211138.3656.65.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-23 at 16:50 +0800, Li Zefan wrote:
> While we are reading trace_stat/functionX and someone just
> disabled function_profile at that time, we can trigger this:
> 
> 	divide error: 0000 [#1] PREEMPT SMP
> 	...
> 	EIP is at function_stat_show+0x90/0x230
> 	...
> 
> This fix just takes the ftrace_profile_lock and checks if
> rec->counter is 0. If it's 0, we know the profile buffer
> has been reset.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Thanks Li!

I'll add this to my queue, test it, and then push it up as a -rc and
stable fix.

-- Steve

> ---
>  kernel/trace/ftrace.c |   15 +++++++++++----
>  1 files changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 0d88ce9..7cb1f45 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -381,12 +381,19 @@ static int function_stat_show(struct seq_file *m, void *v)
>  {
>  	struct ftrace_profile *rec = v;
>  	char str[KSYM_SYMBOL_LEN];
> +	int ret = 0;
>  #ifdef CONFIG_FUNCTION_GRAPH_TRACER
> -	static DEFINE_MUTEX(mutex);
>  	static struct trace_seq s;
>  	unsigned long long avg;
>  	unsigned long long stddev;
>  #endif
> +	mutex_lock(&ftrace_profile_lock);
> +
> +	/* we raced with function_profile_reset() */
> +	if (unlikely(rec->counter == 0)) {
> +		ret = -EBUSY;
> +		goto out;
> +	}
>  
>  	kallsyms_lookup(rec->ip, NULL, NULL, NULL, str);
>  	seq_printf(m, "  %-30.30s  %10lu", str, rec->counter);
> @@ -408,7 +415,6 @@ static int function_stat_show(struct seq_file *m, void *v)
>  		do_div(stddev, (rec->counter - 1) * 1000);
>  	}
>  
> -	mutex_lock(&mutex);
>  	trace_seq_init(&s);
>  	trace_print_graph_duration(rec->time, &s);
>  	trace_seq_puts(&s, "    ");
> @@ -416,11 +422,12 @@ static int function_stat_show(struct seq_file *m, void *v)
>  	trace_seq_puts(&s, "    ");
>  	trace_print_graph_duration(stddev, &s);
>  	trace_print_seq(m, &s);
> -	mutex_unlock(&mutex);
>  #endif
>  	seq_putc(m, '\n');
> +out:
> +	mutex_unlock(&ftrace_profile_lock);
>  
> -	return 0;
> +	return ret;
>  }
>  
>  static void ftrace_profile_reset(struct ftrace_profile_stat *stat)


