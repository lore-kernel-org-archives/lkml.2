Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346Ab1KQXZi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 18:25:38 -0500
Received: from mail.openrapids.net ([64.15.138.104]:47055 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753241Ab1KQXZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 18:25:36 -0500
Date: Thu, 17 Nov 2011 18:25:34 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [RFC PATCH] Tracepoint: introduce tracepoint() API
Message-ID: <20111117232533.GA14356@Krystal>
References: <1321502104.3274.22.camel@edumazet-laptop> <1321543520.27735.67.camel@twins> <20111117155617.GA12665@Krystal> <20111117205053.GA26484@Krystal> <1321564014.3533.13.camel@frodo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321564014.3533.13.camel@frodo>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 18:21:19 up 359 days,  4:24,  6 users,  load average: 0.08, 0.03,
	0.01
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Thu, 2011-11-17 at 15:50 -0500, Mathieu Desnoyers wrote:
> > Introduce:
> > 
> >   tracepoint(event_name, arg1, arg2, ...)
> > 
> > while keeping the old tracepoint API in place, e.g.:
> > 
> >   trace_event_name(arg1, arg2, ...)
> > 
> > This allows skipping parameter side-effects (pointer dereference,
> > function calls, ...) when the tracepoint is not dynamically activated.
> > 
> > Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> > ---
> > diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
> > index d530a44..c9c73f7 100644
> > --- a/include/linux/tracepoint.h
> > +++ b/include/linux/tracepoint.h
> > @@ -107,6 +107,12 @@ void tracepoint_update_probe_range(struct tracepoint * const *begin,
> >  
> >  #ifdef CONFIG_TRACEPOINTS
> >  
> > +#define tracepoint(name, args...)					\
> > +	do {								\
> > +		if (static_branch(&__tracepoint_##name.key))		\
> > +			__trace_##name(args);				\
> > +	} while (0)
> > +
> >  /*
> >   * it_func[0] is never NULL because there is at least one element in the array
> >   * when the array itself is non NULL.
> > @@ -144,13 +150,17 @@ void tracepoint_update_probe_range(struct tracepoint * const *begin,
> >   */
> >  #define __DECLARE_TRACE(name, proto, args, cond, data_proto, data_args)	\
> >  	extern struct tracepoint __tracepoint_##name;			\
> > +	static inline void __trace_##name(proto)			\
> > +	{								\
> > +		__DO_TRACE(&__tracepoint_##name,			\
> > +			TP_PROTO(data_proto),				\
> > +			TP_ARGS(data_args),				\
> > +			TP_CONDITION(cond));				\
> > +	}								\
> 
> I wrote a patch earlier today that does almost the exact same thing, but
> I had more in macro part, which I would have cleaned up after the RFC. I
> didn't add another static inline, but I think this approach is a little
> cleaner (with the second static inline).

I'm glad you like it :)

> 
> I didn't post mine because I was still analyzing the assembly to make
> sure it did what I expected. But I got side tracked on other things (RT
> related) and didn't quite finish the analysis.
> 
> Did you do a compare of kmem_cache_alloc() to see if this fixes the
> reported problem?

I did not test it against this specific reported case, but I had this
exact same kind of issue a while back when moving from Kernel Markers
(which were macros) to the Tracepoint static inlines. Macros were
letting the compiler optimize away the side-effects, which was not
possible with static inlines only.

Eric, does it work better for you with this patch and by using
tracepoint() instead of trace_...() ?

Thanks,

Mathieu

> 
> -- Steve
> 
> >  	static inline void trace_##name(proto)				\
> >  	{								\
> >  		if (static_branch(&__tracepoint_##name.key))		\
> > -			__DO_TRACE(&__tracepoint_##name,		\
> > -				TP_PROTO(data_proto),			\
> > -				TP_ARGS(data_args),			\
> > -				TP_CONDITION(cond));			\
> > +			__trace_##name(args);				\
> >  	}								\
> >  	static inline int						\
> >  	register_trace_##name(void (*probe)(data_proto), void *data)	\
> > @@ -193,7 +203,12 @@ void tracepoint_update_probe_range(struct tracepoint * const *begin,
> >  	EXPORT_SYMBOL(__tracepoint_##name)
> >  
> >  #else /* !CONFIG_TRACEPOINTS */
> > +
> > +#define tracepoint(name, args...)	__trace_##name(args)
> > +
> >  #define __DECLARE_TRACE(name, proto, args, cond, data_proto, data_args)	\
> > +	static inline void __trace_##name(proto)			\
> > +	{ }								\
> >  	static inline void trace_##name(proto)				\
> >  	{ }								\
> >  	static inline int						\
> > 
> 
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
