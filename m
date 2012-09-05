Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932858Ab2IEAnA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 20:43:00 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:34255 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086Ab2IEAm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 20:42:59 -0400
X-Originating-IP: 217.70.178.136
X-Originating-IP: 173.246.103.110
Date: Tue, 4 Sep 2012 17:42:49 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
        laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        eric.dumazet@gmail.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 04/15] rcu: Permit RCU_NONIDLE() to be used
 from interrupt context
Message-ID: <20120905004248.GA12373@jtriplet-mobl1>
References: <20120830185607.GA32148@linux.vnet.ibm.com>
 <1346352988-32444-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346352988-32444-4-git-send-email-paulmck@linux.vnet.ibm.com>
 <20120831180052.GB4259@jtriplet-mobl1>
 <20120904223350.GQ2593@linux.vnet.ibm.com>
 <1346799082.27919.31.camel@gandalf.local.home>
 <20120904230834.GB11494@jtriplet-mobl1>
 <1346801031.27919.39.camel@gandalf.local.home>
 <20120904233344.GB11855@jtriplet-mobl1>
 <1346802402.27919.44.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346802402.27919.44.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 04, 2012 at 07:46:42PM -0400, Steven Rostedt wrote:
> On Tue, 2012-09-04 at 16:33 -0700, Josh Triplett wrote:
> >  
> > > > +#ifdef MODULE
> > > > +#define __DECLARE_TRACE_RCU(name, proto, args, cond, data_proto, data_args) \
> > > > +	static inline void trace_##name##_rcuidle(proto)		\
> > > > +	{								\
> > > > +		if (static_key_false(&__tracepoint_##name.key))		\
> > > > +			__DO_TRACE(&__tracepoint_##name,		\
> > > > +				TP_PROTO(data_proto),			\
> > > > +				TP_ARGS(data_args),			\
> > > > +				TP_CONDITION(cond),			\
> > > > +				rcu_idle_exit(),			\
> > > > +				rcu_idle_enter());			\
> > > > +	}
> > > > +#else
> > > > +#define __DECLARE_TRACE_RCU(name, proto, args, cond, data_proto, data_args)
> > > > +#endif
> > > > +
> > > 
> > > Egad! More macros on top of macros! Yeah I know I'm the most guilty of
> > > this, but it just seems to add one more indirection that I would like to
> > > avoid.
> > 
> > This doesn't seem to add a significant amount of complexity; it forwards
> > exactly the same parameters to the helper macro, and just moves the one
> > function definition there and makes it conditional.  This still seems
> > more preferable than exporting functions just so they won't get called.
> 
> The change itself is not complex. But what is already there is complex
> enough. I'm talking more about adding to:
> 
> $ grep '#define' include/linux/tracepoint.h
> #define _LINUX_TRACEPOINT_H
> #define PARAMS(args...) args
> #define TP_PROTO(args...)       args
> #define TP_ARGS(args...)        args
> #define TP_CONDITION(args...)   args
> #define __DO_TRACE(tp, proto, args, cond, prercu, postrcu)              \
> #define __DECLARE_TRACE(name, proto, args, cond, data_proto, data_args) \
> #define DEFINE_TRACE_FN(name, reg, unreg)                                \
> #define DEFINE_TRACE(name)                                              \
> #define EXPORT_TRACEPOINT_SYMBOL_GPL(name)                              \
> #define EXPORT_TRACEPOINT_SYMBOL(name)                                  \
> #define __DECLARE_TRACE(name, proto, args, cond, data_proto, data_args) \
> #define DEFINE_TRACE_FN(name, reg, unreg)
> #define DEFINE_TRACE(name)
> #define EXPORT_TRACEPOINT_SYMBOL_GPL(name)
> #define EXPORT_TRACEPOINT_SYMBOL(name)
> #define DECLARE_TRACE_NOARGS(name)                                      \
> #define DECLARE_TRACE(name, proto, args)                                \
> #define DECLARE_TRACE_CONDITION(name, proto, args, cond)                \
> #define TRACE_EVENT_FLAGS(event, flag)
> #define DECLARE_EVENT_CLASS(name, proto, args, tstruct, assign, print)
> #define DEFINE_EVENT(template, name, proto, args)               \
> #define DEFINE_EVENT_PRINT(template, name, proto, args, print)  \
> #define DEFINE_EVENT_CONDITION(template, name, proto,           \
> #define TRACE_EVENT(name, proto, args, struct, assign, print)   \
> #define TRACE_EVENT_FN(name, proto, args, struct,               \
> #define TRACE_EVENT_CONDITION(name, proto, args, cond,          \
> #define TRACE_EVENT_FLAGS(event, flag)

Yeah, I've had the adventure of hand-tracing through most of those in
the past myself. :)  At least they have a fairly clear hierarchy,
without particularly complex conditionals.

Ah, for a language with decent code generation facilities. :)

> > I could live with that; it seems preferable to unnecessary exports,
> > though it still seems much uglier to me than the conditional definition
> > of trace_*_rcuidle. :)
> 
> We could add either. Probably keep the ugliness of tracepoints inside
> the tracepoint code than to start spreading it around to rcu. RCU has
> its own ugliness features ;-)
> 
> Hence, I would be OK if you send me a patch that does what you proposed
> and removes the EXPORT from RCU.

To clarify: does what I proposed as in the macro change to avoid
defining trace_*_rcuidle in modules, or makes the change to define panicy
versions of the two functions trace_*_rcuidle needs?

- Josh Triplett
