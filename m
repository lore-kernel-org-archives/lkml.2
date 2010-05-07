Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934Ab0EGOjH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 10:39:07 -0400
Received: from mail.openrapids.net ([64.15.138.104]:41857 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753577Ab0EGOjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 10:39:06 -0400
Date: Fri, 7 May 2010 10:39:01 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/9 - v2][RFC] tracing: Let tracepoints have
	data?passed to tracepoint callbacks
Message-ID: <20100507143901.GA18408@Krystal>
References: <7a22ce9b-4c74-4818-9521-7fbccd1b8b1d@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7a22ce9b-4c74-4818-9521-7fbccd1b8b1d@email.android.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 10:34:23 up 104 days, 17:11,  8 users,  load average: 0.33, 0.22,
	0.17
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> 
> 
> "Frederic Weisbecker" <fweisbec@gmail.com> wrote:
> 
> >On Mon, May 03, 2010 at 11:40:47PM -0400, Steven Rostedt wrote:
[...]
> >> 
> >> diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
> >> index 78b4bd3..ee8059a 100644
> >> --- a/include/linux/tracepoint.h
> >> +++ b/include/linux/tracepoint.h
> >> @@ -20,12 +20,17 @@
> >>  struct module;
> >>  struct tracepoint;
> >>  
> >> +struct tracepoint_func {
> >> +	void *func;
> >> +	void *data;
> >> +};
> >> +
> >>  struct tracepoint {
> >>  	const char *name;		/* Tracepoint name */
> >>  	int state;			/* State. */
> >>  	void (*regfunc)(void);
> >>  	void (*unregfunc)(void);
> >> -	void **funcs;
> >> +	struct tracepoint_func *funcs;
> >>  } __attribute__((aligned(32)));		/*
> >>  					 * Aligned on 32 bytes because it is
> >>  					 * globally visible and gcc happily
> >> @@ -46,14 +51,18 @@ struct tracepoint {
> >>   */
> >>  #define __DO_TRACE(tp, proto, args)					\
> >>  	do {								\
> >> -		void **it_func;						\
> >> +		struct tracepoint_func *it_func_ptr;			\
> >> +		void *it_func;						\
> >> +		void *__data;						\
> >>  									\
> >>  		rcu_read_lock_sched_notrace();				\
> >> -		it_func = rcu_dereference_sched((tp)->funcs);		\
> >> -		if (it_func) {						\
> >> +		it_func_ptr = rcu_dereference_sched((tp)->funcs);	\
> >> +		if (it_func_ptr) {					\
> >>  			do {						\
> >> -				((void(*)(proto))(*it_func))(args);	\
> >> -			} while (*(++it_func));				\
> >> +				it_func = (it_func_ptr)->func;		\
> >> +				__data = (it_func_ptr)->data;		\
> >> +				((void(*)(proto))(it_func))(args);	\
> >
> >
> >So, we had a talk about this and we concluded that it is probably fine
> >on every archs to push one more argument than needed in a function.
> >
> 
> Yeah, I'm hoping it's fine.

How about changing the callback prototypes to match the call arguments (changing
the type expected in register/unregister_trace, as well as an additional "check
type" that I proposed for Ftrace) ?

Otherwise, you basically expect here that:

void fct(void *foo, void *bar, etc etc) (N parameters expected)
{

}

called by:

fct(foo, bar, etc etc, foobar) (N + 1 parameters)

will always work.

Can you show me where the C standard says it is safe to do so ?

Thanks,

Mathieu

> 
> >But I think it would be nice to add a comment about this. Firstly
> >because this line breaks all the self-explanation of the code, I mean
> >I tried hard to find how the non-data callback case was handled :)
> >Secondly to also to avoid people asking what happens here.
> >
> 
> OK I'll add a bit of comments to the macros. So much for my job security ;-)
> 
> >
> >
> >
> >> +			} while ((++it_func_ptr)->func);		\
> >>  		}							\
> >>  		rcu_read_unlock_sched_notrace();			\
> >>  	} while (0)
> >> @@ -63,23 +72,47 @@ struct tracepoint {
> >>   * not add unwanted padding between the beginning of the section and the
> >>   * structure. Force alignment to the same alignment as the section start.
> >>   */
> >> -#define DECLARE_TRACE(name, proto, args)				\
> >> +#define __DECLARE_TRACE(name, proto, args, data_proto, data_args)	\
> >>  	extern struct tracepoint __tracepoint_##name;			\
> >>  	static inline void trace_##name(proto)				\
> >>  	{								\
> >>  		if (unlikely(__tracepoint_##name.state))		\
> >>  			__DO_TRACE(&__tracepoint_##name,		\
> >> -				TP_PROTO(proto), TP_ARGS(args));	\
> >> +				TP_PROTO(data_proto),			\
> >> +				TP_ARGS(data_args));			\
> >>  	}								\
> >>  	static inline int register_trace_##name(void (*probe)(proto))	\
> >>  	{								\
> >> -		return tracepoint_probe_register(#name, (void *)probe);	\
> >> +		return tracepoint_probe_register(#name, (void *)probe,	\
> >> +						 NULL);			\
> >> +	}								\
> >> +	static inline int unregister_trace_##name(void (*probe)(proto)) \
> >> +	{								\
> >> +		return tracepoint_probe_unregister(#name, (void *)probe,\
> >> +						   NULL);		\
> >>  	}								\
> >> -	static inline int unregister_trace_##name(void (*probe)(proto))	\
> >> +	static inline int						\
> >> +	register_trace_##name##_data(void (*probe)(data_proto),		\
> >> +				     void *data)			\
> >>  	{								\
> >> -		return tracepoint_probe_unregister(#name, (void *)probe);\
> >> +		return tracepoint_probe_register(#name, (void *)probe,	\
> >> +						 data);			\
> >> +	}								\
> >> +	static inline int						\
> >> +	unregister_trace_##name##_data(void (*probe)(data_proto),	\
> >> +				       void *data)			\
> >> +	{								\
> >> +		return tracepoint_probe_unregister(#name, (void *)probe,\
> >> +						   data);		\
> >>  	}
> >>  
> >> +#define DECLARE_TRACE_NOARGS(name)					\
> >> +		__DECLARE_TRACE(name, void, , void *__data, __data)
> >
> >
> >
> >That too, may be, deserves a small comment :)
> 
> OK
> 
> >
> >
> >
> >> +
> >> +#define DECLARE_TRACE(name, proto, args)				\
> >> +		__DECLARE_TRACE(name, PARAMS(proto), PARAMS(args),	\
> >> +				PARAMS(proto, void *__data),		\
> >> +				PARAMS(args, __data))
> >>  
> >>  #define DEFINE_TRACE_FN(name, reg, unreg)				\
> >>  	static const char __tpstrtab_##name[]				\
> >> @@ -100,19 +133,37 @@ extern void tracepoint_update_probe_range(struct tracepoint *begin,
> >>  	struct tracepoint *end);
> >>  
[...]

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
