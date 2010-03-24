Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692Ab0CXDHx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 23:07:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:53507 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177Ab0CXDHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 23:07:52 -0400
X-Authority-Analysis: v=1.0 c=1 a=74gassf11ccA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=omOdbC7AAAAA:8 a=1DKbB3l2vW0IH0Qv6awA:9 a=asvUOAc4f_Cf1-FQMW8A:7 a=Y7p_WIPWWbXf68JL_7Bft-kFOs0A:4 a=PUjeQqilurYA:10 a=w1m42tfKHOd8HYuV:21 a=AMeWSlbCXVSNC_qX:21
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 2/3] tracing: Convert some signal events to DEFINE_TRACE
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>
In-Reply-To: <4BA97FBD.8070703@cn.fujitsu.com>
References: <4BA97FA7.6040406@cn.fujitsu.com>
	 <4BA97FBD.8070703@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Tue, 23 Mar 2010 23:07:50 -0400
Message-ID: <1269400070.2957.1943.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-24 at 10:58 +0800, Li Zefan wrote:
> Use DECLARE_EVENT_CLASS to remove duplicate code:
> 
> text    data     bss     dec     hex filename
>   23639    6084       8   29731    7423 kernel/signal.o.orig
>   22727    6084       8   28819    7093 kernel/signal.o
> 
> 2 events are converted:
> 
>   signal_queue_overflow: signal_overflow_fail, signal_lose_info
> 

Masami,

Can I get your Acked-by for this.

Thanks,

-- Steve

> No functional change.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  include/trace/events/signal.h |   52 +++++++++++++++++-----------------------
>  1 files changed, 22 insertions(+), 30 deletions(-)
> 
> diff --git a/include/trace/events/signal.h b/include/trace/events/signal.h
> index a510b75..814566c 100644
> --- a/include/trace/events/signal.h
> +++ b/include/trace/events/signal.h
> @@ -100,18 +100,7 @@ TRACE_EVENT(signal_deliver,
>  		  __entry->sa_handler, __entry->sa_flags)
>  );
>  
> -/**
> - * signal_overflow_fail - called when signal queue is overflow
> - * @sig: signal number
> - * @group: signal to process group or not (bool)
> - * @info: pointer to struct siginfo
> - *
> - * Kernel fails to generate 'sig' signal with 'info' siginfo, because
> - * siginfo queue is overflow, and the signal is dropped.
> - * 'group' is not 0 if the signal will be sent to a process group.
> - * 'sig' is always one of RT signals.
> - */
> -TRACE_EVENT(signal_overflow_fail,
> +DECLARE_EVENT_CLASS(signal_queue_overflow,
>  
>  	TP_PROTO(int sig, int group, struct siginfo *info),
>  
> @@ -135,6 +124,24 @@ TRACE_EVENT(signal_overflow_fail,
>  );
>  
>  /**
> + * signal_overflow_fail - called when signal queue is overflow
> + * @sig: signal number
> + * @group: signal to process group or not (bool)
> + * @info: pointer to struct siginfo
> + *
> + * Kernel fails to generate 'sig' signal with 'info' siginfo, because
> + * siginfo queue is overflow, and the signal is dropped.
> + * 'group' is not 0 if the signal will be sent to a process group.
> + * 'sig' is always one of RT signals.
> + */
> +DEFINE_EVENT(signal_queue_overflow, signal_overflow_fail,
> +
> +	TP_PROTO(int sig, int group, struct siginfo *info),
> +
> +	TP_ARGS(sig, group, info)
> +);
> +
> +/**
>   * signal_lose_info - called when siginfo is lost
>   * @sig: signal number
>   * @group: signal to process group or not (bool)
> @@ -145,28 +152,13 @@ TRACE_EVENT(signal_overflow_fail,
>   * 'group' is not 0 if the signal will be sent to a process group.
>   * 'sig' is always one of non-RT signals.
>   */
> -TRACE_EVENT(signal_lose_info,
> +DEFINE_EVENT(signal_queue_overflow, signal_lose_info,
>  
>  	TP_PROTO(int sig, int group, struct siginfo *info),
>  
> -	TP_ARGS(sig, group, info),
> -
> -	TP_STRUCT__entry(
> -		__field(	int,	sig	)
> -		__field(	int,	group	)
> -		__field(	int,	errno	)
> -		__field(	int,	code	)
> -	),
> -
> -	TP_fast_assign(
> -		__entry->sig	= sig;
> -		__entry->group	= group;
> -		TP_STORE_SIGINFO(__entry, info);
> -	),
> -
> -	TP_printk("sig=%d group=%d errno=%d code=%d",
> -		  __entry->sig, __entry->group, __entry->errno, __entry->code)
> +	TP_ARGS(sig, group, info)
>  );
> +
>  #endif /* _TRACE_SIGNAL_H */
>  
>  /* This part must be outside protection */


