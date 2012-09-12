Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958Ab2ILDsJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 23:48:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18624 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961Ab2ILDsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 23:48:07 -0400
X-Authority-Analysis: v=2.0 cv=Hsb06jvS c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=1Hyl1JrvWn0A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=fyrVzdcL7noA:10 a=1XWaLZrsAAAA:8 a=rHC3xS6RNNlwCVeF0joA:9 a=PUjeQqilurYA:10 a=UTB_XpHje0EA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1347421685.10751.34.camel@gandalf.local.home>
Subject: Re: [PATCH 1/3] tracing,x86: add a TSC trace_clock; reset buffer on
 clock change
From: Steven Rostedt <rostedt@goodmis.org>
To: David Sharp <dhsharp@google.com>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Date: Tue, 11 Sep 2012 23:48:05 -0400
In-Reply-To: <1347417671-22998-2-git-send-email-dhsharp@google.com>
References: <1347417671-22998-1-git-send-email-dhsharp@google.com>
	 <1347417671-22998-2-git-send-email-dhsharp@google.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-09-11 at 19:41 -0700, David Sharp wrote:
> In order to promote interoperability between userspace tracers and ftrace,
> add a trace_clock that reports raw TSC values which will then be recorded
> in the ring buffer. Userspace tracers that also record TSCs are then on
> exactly the same time base as the kernel and events can be unambiguously
> interlaced.
> 
> Tested: Enabled a tracepoint and the "tsc" trace_clock and saw very large
> timestamp values.
> 
> Google-Bug-Id: 6980623
> Signed-off-by: David Sharp <dhsharp@google.com>
> ---
>  include/linux/trace_clock.h |    3 +++
>  kernel/trace/trace.c        |    3 +++
>  kernel/trace/trace_clock.c  |   16 ++++++++++++++++
>  3 files changed, 22 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/trace_clock.h b/include/linux/trace_clock.h
> index 4eb4902..b86c7363 100644
> --- a/include/linux/trace_clock.h
> +++ b/include/linux/trace_clock.h
> @@ -16,5 +16,8 @@ extern u64 notrace trace_clock_local(void);
>  extern u64 notrace trace_clock(void);
>  extern u64 notrace trace_clock_global(void);
>  extern u64 notrace trace_clock_counter(void);
> +#ifdef CONFIG_X86_TSC
> +extern u64 notrace trace_clock_tsc(void);
> +#endif
>  
>  #endif /* _LINUX_TRACE_CLOCK_H */
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 5c38c81..dc1f1fa 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -480,6 +480,9 @@ static struct {
>  	{ trace_clock_local,	"local" },
>  	{ trace_clock_global,	"global" },
>  	{ trace_clock_counter,	"counter" },
> +#ifdef CONFIG_X86_TSC
> +	{ trace_clock_tsc,	"tsc" },
> +#endif
>  };

I really hate adding arch defs in generic code. Perhaps what we could do
is add a define here. Something like:

#ifndef ARCH_TRACE_CLOCKS
# define ARCH_TRACE_CLOCKS
#endif

[...]
	{ trace_clock_counter, "counter" },
	ARCH_TRACE_CLOCKS
};

and have ARCH_TRACE_CLOCKS defined somewhere in an arch specific header.
Not sure what header we could use though :-/

That is, in a header have:

#define ARCH_TRACE_CLOCKS \
	{ trace_clock_x86_tsc,	"tsc" },

and also define trace_clock_x86_tsc in arch/x86/kernel...

-- Steve


>  
>  int trace_clock_id;
> diff --git a/kernel/trace/trace_clock.c b/kernel/trace/trace_clock.c
> index 3947835..1770737 100644
> --- a/kernel/trace/trace_clock.c
> +++ b/kernel/trace/trace_clock.c
> @@ -125,3 +125,19 @@ u64 notrace trace_clock_counter(void)
>  {
>  	return atomic64_add_return(1, &trace_counter);
>  }
> +
> +#ifdef CONFIG_X86_TSC
> +/*
> + * trace_clock_tsc(): A clock that is just the cycle counter.
> + *
> + * Unlike the other clocks, this is not in nanoseconds.
> + */
> +u64 notrace trace_clock_tsc(void)
> +{
> +	u64 ret;
> +	rdtsc_barrier();
> +	rdtscll(ret);
> +
> +	return ret;
> +}
> +#endif


