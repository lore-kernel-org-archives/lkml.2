Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756468Ab0JVNtj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 09:49:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:50597 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180Ab0JVNti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 09:49:38 -0400
X-Authority-Analysis: v=1.1 cv=NFUeGz0loTdi/T6hXKngYYtckjed7x3pKvNOqmBBK18= c=1 sm=0 a=A6yVOXcETFUA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=Uc76PqOG9uPNVy1IMfsA:9 a=-VW120tuk57w22jXuwRSsWzOUfMA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH v2][GIT PULL] tracing: Prevent unloadable modules from
 using trace_bprintk()
From: Steven Rostedt <rostedt@goodmis.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <4CC1218E.9090104@cn.fujitsu.com>
References: <1287668742.16971.585.camel@gandalf.stny.rr.com>
	 <201010221413.28588.rusty@rustcorp.com.au>
	 <1287719918.16971.615.camel@gandalf.stny.rr.com>
	 <201010221504.51535.rusty@rustcorp.com.au>
	 <4CC1218E.9090104@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 22 Oct 2010 09:49:33 -0400
Message-ID: <1287755374.16971.629.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-22 at 13:30 +0800, Li Zefan wrote:

> In fact tracepoint is free from this bug, because we'll empty the ring
> buffer if the unloading module has tracepoints in it.

Hehe, and I should know, I wrote that code :-)


> 
> So for trace_bprintk, why can't we do the same thing? If a module has
> trace_bprintk calls in it, just empty the ring buffer when unloading
> module.
> 
> And that's as simple as something like this:
> 
> diff --git a/kernel/trace/trace_printk.c b/kernel/trace/trace_printk.c
> index 2547d88..103987f 100644
> --- a/kernel/trace/trace_printk.c
> +++ b/kernel/trace/trace_printk.c
> @@ -80,6 +80,13 @@ static int module_trace_bprintk_format_notify(struct notifier_block *self,
>  
>  		if (val == MODULE_STATE_COMING)
>  			hold_module_trace_bprintk_format(start, end);
> +		else if (val == MODULE_STATE_GOING) {
> +			/*
> +			 * It is safest to reset the ring buffer if the
> +			 * module being unloaded uses trace_bprintk.
> +			 */
> +			tracing_reset_current_online_cpus();
> +		}
>  	}
>  	return 0;
>  }

This could definitely work.

But this prevents developers using trace_printk() in their exit() code.
We should probably add a trace_mod_printk() or something that just
forces the slow version that does not require flushing the ring buffer
on removal. As long as there's not a single trace_printk() in the
module, and it only uses the alternative, then this should work.

-- Steve


