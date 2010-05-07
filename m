Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720Ab0EGOJh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 10:09:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:62922 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040Ab0EGOJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 10:09:35 -0400
X-Authority-Analysis: v=1.1 cv=nrqrmdtKPnrEe5McJVoaEKFzY/lexCxOe+Stj/aSkNs= c=1 sm=0 a=KHh1y0iU_6MA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=0KvIw-CUSIVuRVBsPRkA:9 a=a_4MfP1GYHoiR9lSeWkA:7 a=aja9hQaGcz5QT1B5q8smWNaWkfUA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 2/9 - v2][RFC] tracing: Let tracepoints have data
 passed to tracepoint callbacks
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Christoph Hellwig <hch@lst.de>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <20100507035230.GB8069@nowhere>
References: <20100504034045.085822814@goodmis.org>
	 <20100504034201.896240097@goodmis.org>  <20100507035230.GB8069@nowhere>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Fri, 07 May 2010 10:09:31 -0400
Message-ID: <1273241371.22438.81.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmm, I replied originally from my Google phone, but I don't see it in
LKML. So apologies if this is duplicate.


On Fri, 2010-05-07 at 05:52 +0200, Frederic Weisbecker wrote:
> On Mon, May 03, 2010 at 11:40:47PM -0400, Steven Rostedt wrote:

> >  #define __DO_TRACE(tp, proto, args)					\
> >  	do {								\
> > -		void **it_func;						\
> > +		struct tracepoint_func *it_func_ptr;			\
> > +		void *it_func;						\
> > +		void *__data;						\
> >  									\
> >  		rcu_read_lock_sched_notrace();				\
> > -		it_func = rcu_dereference_sched((tp)->funcs);		\
> > -		if (it_func) {						\
> > +		it_func_ptr = rcu_dereference_sched((tp)->funcs);	\
> > +		if (it_func_ptr) {					\
> >  			do {						\
> > -				((void(*)(proto))(*it_func))(args);	\
> > -			} while (*(++it_func));				\
> > +				it_func = (it_func_ptr)->func;		\
> > +				__data = (it_func_ptr)->data;		\
> > +				((void(*)(proto))(it_func))(args);	\
> 
> 
> So, we had a talk about this and we concluded that it is probably fine
> on every archs to push one more argument than needed in a function.

Yep, I'm hoping this is the case.

> 
> But I think it would be nice to add a comment about this. Firstly
> because this line breaks all the self-explanation of the code, I mean
> I tried hard to find how the non-data callback case was handled :)
> Secondly to also to avoid people asking what happens here.

OK, I'll add documentation here. So much for my job security ;-)

> 
> 
> 
> 
> > +			} while ((++it_func_ptr)->func);		\
> >  		}							\
> >  		rcu_read_unlock_sched_notrace();			\
> >  	} while (0)
> > @@ -63,23 +72,47 @@ struct tracepoint {
> >   * not add unwanted padding between the beginning of the section and the
> >   * structure. Force alignment to the same alignment as the section start.
> >   */
> > -#define DECLARE_TRACE(name, proto, args)				\
> > +#define __DECLARE_TRACE(name, proto, args, data_proto, data_args)	\
> >  	extern struct tracepoint __tracepoint_##name;			\
> >  	static inline void trace_##name(proto)				\
> >  	{								\
> >  		if (unlikely(__tracepoint_##name.state))		\
> >  			__DO_TRACE(&__tracepoint_##name,		\
> > -				TP_PROTO(proto), TP_ARGS(args));	\
> > +				TP_PROTO(data_proto),			\
> > +				TP_ARGS(data_args));			\
> >  	}								\
> >  	static inline int register_trace_##name(void (*probe)(proto))	\
> >  	{								\
> > -		return tracepoint_probe_register(#name, (void *)probe);	\
> > +		return tracepoint_probe_register(#name, (void *)probe,	\
> > +						 NULL);			\
> > +	}								\
> > +	static inline int unregister_trace_##name(void (*probe)(proto)) \
> > +	{								\
> > +		return tracepoint_probe_unregister(#name, (void *)probe,\
> > +						   NULL);		\
> >  	}								\
> > -	static inline int unregister_trace_##name(void (*probe)(proto))	\
> > +	static inline int						\
> > +	register_trace_##name##_data(void (*probe)(data_proto),		\
> > +				     void *data)			\
> >  	{								\
> > -		return tracepoint_probe_unregister(#name, (void *)probe);\
> > +		return tracepoint_probe_register(#name, (void *)probe,	\
> > +						 data);			\
> > +	}								\
> > +	static inline int						\
> > +	unregister_trace_##name##_data(void (*probe)(data_proto),	\
> > +				       void *data)			\
> > +	{								\
> > +		return tracepoint_probe_unregister(#name, (void *)probe,\
> > +						   data);		\
> >  	}
> >  
> > +#define DECLARE_TRACE_NOARGS(name)					\
> > +		__DECLARE_TRACE(name, void, , void *__data, __data)
> 
> 
> 
> That too, may be, deserves a small comment :)

OK

> 
> 
> 
> > +
> > +#define DECLARE_TRACE(name, proto, args)				\
> > +		__DECLARE_TRACE(name, PARAMS(proto), PARAMS(args),	\
> > +				PARAMS(proto, void *__data),		\
> > +				PARAMS(args, __data))
> >  
> >  #define DEFINE_TRACE_FN(name, reg, unreg)				\
> >  	static const char __tpstrtab_##name[]				\
> > @@ -100,19 +133,37 @@ extern void tracepoint_update_probe_range(struct tracepoint *begin,
> >  	struct tracepoint *end);
> >  
> >  #else /* !CONFIG_TRACEPOINTS */
> > -#define DECLARE_TRACE(name, proto, args)				\
> > -	static inline void _do_trace_##name(struct tracepoint *tp, proto) \
> > -	{ }								\
> > +#define __DECLARE_TRACE(name, proto, args, data_proto, data_args)	\
> >  	static inline void trace_##name(proto)				\
> > -	{ }								\
> > +	{								\
> > +	}								\
> >  	static inline int register_trace_##name(void (*probe)(proto))	\
> >  	{								\
> >  		return -ENOSYS;						\
> >  	}								\
> > -	static inline int unregister_trace_##name(void (*probe)(proto))	\
> > +	static inline int unregister_trace_##name(void (*probe)(proto)) \
> > +	{								\
> > +		return -ENOSYS;						\
> > +	}								\
> > +	static inline int						\
> > +	register_trace_##name##_data(void (*probe)(data_proto),		\
> > +				     void *data)			\
> > +	{								\
> > +		return -ENOSYS;						\
> > +	}								\
> > +	static inline int						\
> > +	unregister_trace_##name##_data(void (*probe)(data_proto),	\
> > +				       void *data)			\
> >  	{								\
> >  		return -ENOSYS;						\
> >  	}
> > +#define DECLARE_TRACE_NOARGS(name)					\
> > +		__DECLARE_TRACE(name, void, , void *__data, __data)
> > +
> > +#define DECLARE_TRACE(name, proto, args)				\
> > +		__DECLARE_TRACE(name, PARAMS(proto), PARAMS(args),	\
> > +				PARAMS(proto, void *__data),		\
> > +				PARAMS(args, __data))
> 
> 
> 
> 
> It seems that the on and off cases are exactly the same for DECLARE_TRACE*(),
> you could provide a single version and let the __DECLARE_TRACE() do
> the on/off trick.


I don't know what you mean here. How would __DECLARE_TRACE() do what
both DECLARE_TRACE() and DECLARE_TRACE_NOARGS() do? It will fail the
compile if proto is "void".

-- Steve


