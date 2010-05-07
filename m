Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817Ab0EGDwf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 23:52:35 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46152 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693Ab0EGDwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 23:52:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Azd4fuz7BdaZqjwzP1QM3vHZV1ijK3gZvJbQj80CB+zawFP/mJg6T2eHhu4XMmwW7e
         TUc1v8EefEpsVTOQJIsdlLr1XWO+BsnOnuZlskDCi+2+HjPWfHNo65Ry4lzOxp3H7Kr9
         PTl5SMC3/ROf3cNvgH/xUTpMLc+L4XfcgCDvk=
Date: Fri, 7 May 2010 05:52:32 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Christoph Hellwig <hch@lst.de>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH 2/9 - v2][RFC] tracing: Let tracepoints have data
	passed to tracepoint callbacks
Message-ID: <20100507035230.GB8069@nowhere>
References: <20100504034045.085822814@goodmis.org> <20100504034201.896240097@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100504034201.896240097@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 03, 2010 at 11:40:47PM -0400, Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> This patch allows data to be passed to the tracepoint callbacks
> if the tracepoint was created to do so.
> 
> The DECLARE_TRACE() now adds two new functions:
> 
> 	register_trace_mytracepoint_data()
> 	unregister_trace_mytracepoint_data()
> 
> These two are the same as the original
> 
> 	register_trace_mytracepoint()
> 	unregister_trace_mytracepoint()
> 
> But now allow you to pass a private data pointer that will
> be passed to the callback handle. For example:
> 
> DECLARE_TRACE(mytracepoint, int value, value);
> 
> will create a function called trace_mytracepoint()
> 
> 	void trace_mytracepoint(int value);
> 
> If the user wants to pass data to register a function to this tracepoint
> and have data also passed to this callback, they can use:
> 
> 	int mycallback(int value, void *data);
> 
> 	register_trace_mytracepoint_data(mycallback, mydata);
> 
> Then the mycallback() will receive the "mydata" as the parameter after
> the args.
> 
> A more detailed example:
> 
>   DECLARE_TRACE(mytracepoint, TP_PROTO(int status), TP_ARGS(status));
> 
>   /* In the C file */
> 
>   DEFINE_TRACE(mytracepoint, TP_PROTO(int status), TP_ARGS(status));
> 
>   [...]
> 
>        trace_mytacepoint(status);
> 
>   /* In a file registering this tracepoint */
> 
>   int my_callback(int status, void *data)
>   {
> 	struct my_struct my_data = data;
> 	[...]
>   }
> 
>   [...]
> 	my_data = kmalloc(sizeof(*my_data), GFP_KERNEL);
> 	init_my_data(my_data);
> 	register_trace_mytracepoint_data(my_callback, my_data);
> 
> The same callback can also be registered to the same tracepoint as long
> as the data registered is the different. Note, the data must also be used
> to unregister the callback:
> 
> 	unregister_trace_mytracepoint_data(my_callback, my_data);
> 
> Because of the data parameter, tracepoints declared this way can not have
> no args. That is:
> 
>   DECLARE_TRACE(mytracepoint, TP_PROTO(void), TP_ARGS());
> 
> will cause an error.
> 
> If no arguments are needed, a new macro can be used instead:
> 
>   DECLARE_TRACE_NOARGS(mytracepoint);
> 
> Since there are no arguments, the proto and args fields are left out.
> 
> This is part of a series to make the tracepoint footprint smaller:
> 
>    text	   data	    bss	    dec	    hex	filename
> 5788186	1337252	9351592	16477030	 fb6b66	vmlinux.orig
> 5792282	1333796	9351592	16477670	 fb6de6	vmlinux.class
> 5793448	1333780	9351592	16478820	 fb7264	vmlinux.tracepoint
> 
> Again, this patch also increases the size of the kernel, but
> lays the ground work for decreasing it.
> 
>  v2: Made the DECLARE_TRACE() have the ability to pass arguments
>      and added a new DECLARE_TRACE_NOARGS() for tracepoints that
>      do not need any arguments.
> 
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  include/linux/tracepoint.h             |   94 +++++++++++++++++++++++++-------
>  kernel/tracepoint.c                    |   91 +++++++++++++++++--------------
>  samples/tracepoints/tp-samples-trace.h |    4 +-
>  3 files changed, 126 insertions(+), 63 deletions(-)
> 
> diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
> index 78b4bd3..ee8059a 100644
> --- a/include/linux/tracepoint.h
> +++ b/include/linux/tracepoint.h
> @@ -20,12 +20,17 @@
>  struct module;
>  struct tracepoint;
>  
> +struct tracepoint_func {
> +	void *func;
> +	void *data;
> +};
> +
>  struct tracepoint {
>  	const char *name;		/* Tracepoint name */
>  	int state;			/* State. */
>  	void (*regfunc)(void);
>  	void (*unregfunc)(void);
> -	void **funcs;
> +	struct tracepoint_func *funcs;
>  } __attribute__((aligned(32)));		/*
>  					 * Aligned on 32 bytes because it is
>  					 * globally visible and gcc happily
> @@ -46,14 +51,18 @@ struct tracepoint {
>   */
>  #define __DO_TRACE(tp, proto, args)					\
>  	do {								\
> -		void **it_func;						\
> +		struct tracepoint_func *it_func_ptr;			\
> +		void *it_func;						\
> +		void *__data;						\
>  									\
>  		rcu_read_lock_sched_notrace();				\
> -		it_func = rcu_dereference_sched((tp)->funcs);		\
> -		if (it_func) {						\
> +		it_func_ptr = rcu_dereference_sched((tp)->funcs);	\
> +		if (it_func_ptr) {					\
>  			do {						\
> -				((void(*)(proto))(*it_func))(args);	\
> -			} while (*(++it_func));				\
> +				it_func = (it_func_ptr)->func;		\
> +				__data = (it_func_ptr)->data;		\
> +				((void(*)(proto))(it_func))(args);	\


So, we had a talk about this and we concluded that it is probably fine
on every archs to push one more argument than needed in a function.

But I think it would be nice to add a comment about this. Firstly
because this line breaks all the self-explanation of the code, I mean
I tried hard to find how the non-data callback case was handled :)
Secondly to also to avoid people asking what happens here.




> +			} while ((++it_func_ptr)->func);		\
>  		}							\
>  		rcu_read_unlock_sched_notrace();			\
>  	} while (0)
> @@ -63,23 +72,47 @@ struct tracepoint {
>   * not add unwanted padding between the beginning of the section and the
>   * structure. Force alignment to the same alignment as the section start.
>   */
> -#define DECLARE_TRACE(name, proto, args)				\
> +#define __DECLARE_TRACE(name, proto, args, data_proto, data_args)	\
>  	extern struct tracepoint __tracepoint_##name;			\
>  	static inline void trace_##name(proto)				\
>  	{								\
>  		if (unlikely(__tracepoint_##name.state))		\
>  			__DO_TRACE(&__tracepoint_##name,		\
> -				TP_PROTO(proto), TP_ARGS(args));	\
> +				TP_PROTO(data_proto),			\
> +				TP_ARGS(data_args));			\
>  	}								\
>  	static inline int register_trace_##name(void (*probe)(proto))	\
>  	{								\
> -		return tracepoint_probe_register(#name, (void *)probe);	\
> +		return tracepoint_probe_register(#name, (void *)probe,	\
> +						 NULL);			\
> +	}								\
> +	static inline int unregister_trace_##name(void (*probe)(proto)) \
> +	{								\
> +		return tracepoint_probe_unregister(#name, (void *)probe,\
> +						   NULL);		\
>  	}								\
> -	static inline int unregister_trace_##name(void (*probe)(proto))	\
> +	static inline int						\
> +	register_trace_##name##_data(void (*probe)(data_proto),		\
> +				     void *data)			\
>  	{								\
> -		return tracepoint_probe_unregister(#name, (void *)probe);\
> +		return tracepoint_probe_register(#name, (void *)probe,	\
> +						 data);			\
> +	}								\
> +	static inline int						\
> +	unregister_trace_##name##_data(void (*probe)(data_proto),	\
> +				       void *data)			\
> +	{								\
> +		return tracepoint_probe_unregister(#name, (void *)probe,\
> +						   data);		\
>  	}
>  
> +#define DECLARE_TRACE_NOARGS(name)					\
> +		__DECLARE_TRACE(name, void, , void *__data, __data)



That too, may be, deserves a small comment :)



> +
> +#define DECLARE_TRACE(name, proto, args)				\
> +		__DECLARE_TRACE(name, PARAMS(proto), PARAMS(args),	\
> +				PARAMS(proto, void *__data),		\
> +				PARAMS(args, __data))
>  
>  #define DEFINE_TRACE_FN(name, reg, unreg)				\
>  	static const char __tpstrtab_##name[]				\
> @@ -100,19 +133,37 @@ extern void tracepoint_update_probe_range(struct tracepoint *begin,
>  	struct tracepoint *end);
>  
>  #else /* !CONFIG_TRACEPOINTS */
> -#define DECLARE_TRACE(name, proto, args)				\
> -	static inline void _do_trace_##name(struct tracepoint *tp, proto) \
> -	{ }								\
> +#define __DECLARE_TRACE(name, proto, args, data_proto, data_args)	\
>  	static inline void trace_##name(proto)				\
> -	{ }								\
> +	{								\
> +	}								\
>  	static inline int register_trace_##name(void (*probe)(proto))	\
>  	{								\
>  		return -ENOSYS;						\
>  	}								\
> -	static inline int unregister_trace_##name(void (*probe)(proto))	\
> +	static inline int unregister_trace_##name(void (*probe)(proto)) \
> +	{								\
> +		return -ENOSYS;						\
> +	}								\
> +	static inline int						\
> +	register_trace_##name##_data(void (*probe)(data_proto),		\
> +				     void *data)			\
> +	{								\
> +		return -ENOSYS;						\
> +	}								\
> +	static inline int						\
> +	unregister_trace_##name##_data(void (*probe)(data_proto),	\
> +				       void *data)			\
>  	{								\
>  		return -ENOSYS;						\
>  	}
> +#define DECLARE_TRACE_NOARGS(name)					\
> +		__DECLARE_TRACE(name, void, , void *__data, __data)
> +
> +#define DECLARE_TRACE(name, proto, args)				\
> +		__DECLARE_TRACE(name, PARAMS(proto), PARAMS(args),	\
> +				PARAMS(proto, void *__data),		\
> +				PARAMS(args, __data))




It seems that the on and off cases are exactly the same for DECLARE_TRACE*(),
you could provide a single version and let the __DECLARE_TRACE() do
the on/off trick.

Thanks.

