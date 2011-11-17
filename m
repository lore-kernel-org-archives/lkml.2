Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049Ab1KQVG6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 16:06:58 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:45657 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322Ab1KQVG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 16:06:57 -0500
X-Authority-Analysis: v=2.0 cv=KcRQQHkD c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=hsUE5kq4_wEA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=7d_E57ReAAAA:8 a=zu7syDHqWfYUN45_3dAA:9 a=zyn-aM1LaKYMgSWNsF4A:7 a=QEXdDO2ut3YA:10 a=D6-X0JM3zdQA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [RFC PATCH] Tracepoint: introduce tracepoint() API
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        Christoph Lameter <cl@linux-foundation.org>
In-Reply-To: <20111117205053.GA26484@Krystal>
References: <1321502104.3274.22.camel@edumazet-laptop>
	 <1321543520.27735.67.camel@twins> <20111117155617.GA12665@Krystal>
	 <20111117205053.GA26484@Krystal>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Nov 2011 16:06:54 -0500
Message-ID: <1321564014.3533.13.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-17 at 15:50 -0500, Mathieu Desnoyers wrote:
> Introduce:
> 
>   tracepoint(event_name, arg1, arg2, ...)
> 
> while keeping the old tracepoint API in place, e.g.:
> 
>   trace_event_name(arg1, arg2, ...)
> 
> This allows skipping parameter side-effects (pointer dereference,
> function calls, ...) when the tracepoint is not dynamically activated.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> ---
> diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
> index d530a44..c9c73f7 100644
> --- a/include/linux/tracepoint.h
> +++ b/include/linux/tracepoint.h
> @@ -107,6 +107,12 @@ void tracepoint_update_probe_range(struct tracepoint * const *begin,
>  
>  #ifdef CONFIG_TRACEPOINTS
>  
> +#define tracepoint(name, args...)					\
> +	do {								\
> +		if (static_branch(&__tracepoint_##name.key))		\
> +			__trace_##name(args);				\
> +	} while (0)
> +
>  /*
>   * it_func[0] is never NULL because there is at least one element in the array
>   * when the array itself is non NULL.
> @@ -144,13 +150,17 @@ void tracepoint_update_probe_range(struct tracepoint * const *begin,
>   */
>  #define __DECLARE_TRACE(name, proto, args, cond, data_proto, data_args)	\
>  	extern struct tracepoint __tracepoint_##name;			\
> +	static inline void __trace_##name(proto)			\
> +	{								\
> +		__DO_TRACE(&__tracepoint_##name,			\
> +			TP_PROTO(data_proto),				\
> +			TP_ARGS(data_args),				\
> +			TP_CONDITION(cond));				\
> +	}								\

I wrote a patch earlier today that does almost the exact same thing, but
I had more in macro part, which I would have cleaned up after the RFC. I
didn't add another static inline, but I think this approach is a little
cleaner (with the second static inline).

I didn't post mine because I was still analyzing the assembly to make
sure it did what I expected. But I got side tracked on other things (RT
related) and didn't quite finish the analysis.

Did you do a compare of kmem_cache_alloc() to see if this fixes the
reported problem?

-- Steve

>  	static inline void trace_##name(proto)				\
>  	{								\
>  		if (static_branch(&__tracepoint_##name.key))		\
> -			__DO_TRACE(&__tracepoint_##name,		\
> -				TP_PROTO(data_proto),			\
> -				TP_ARGS(data_args),			\
> -				TP_CONDITION(cond));			\
> +			__trace_##name(args);				\
>  	}								\
>  	static inline int						\
>  	register_trace_##name(void (*probe)(data_proto), void *data)	\
> @@ -193,7 +203,12 @@ void tracepoint_update_probe_range(struct tracepoint * const *begin,
>  	EXPORT_SYMBOL(__tracepoint_##name)
>  
>  #else /* !CONFIG_TRACEPOINTS */
> +
> +#define tracepoint(name, args...)	__trace_##name(args)
> +
>  #define __DECLARE_TRACE(name, proto, args, cond, data_proto, data_args)	\
> +	static inline void __trace_##name(proto)			\
> +	{ }								\
>  	static inline void trace_##name(proto)				\
>  	{ }								\
>  	static inline int						\
> 


