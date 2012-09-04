Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757995Ab2IDXqq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 19:46:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10964 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770Ab2IDXqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 19:46:45 -0400
X-Authority-Analysis: v=2.0 cv=Hsb06jvS c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=jUoZk2RAzk0A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=7zoRB9YQJIYA:10 a=imTROTZUkysA:10 a=RAM01ziftVcA:10 a=wFfiXLW5-aMA:10 a=56vLhSP8h14A:10 a=2eRPLDGB9N0A:10 a=5KFgGj9NFKLH70NJ8fUA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1346802402.27919.44.camel@gandalf.local.home>
Subject: Re: [PATCH tip/core/rcu 04/15] rcu: Permit RCU_NONIDLE() to be used
 from interrupt context
From: Steven Rostedt <rostedt@goodmis.org>
To: Josh Triplett <josh@joshtriplett.org>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
        laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        eric.dumazet@gmail.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Date: Tue, 04 Sep 2012 19:46:42 -0400
In-Reply-To: <20120904233344.GB11855@jtriplet-mobl1>
References: <20120830185607.GA32148@linux.vnet.ibm.com>
	 <1346352988-32444-1-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1346352988-32444-4-git-send-email-paulmck@linux.vnet.ibm.com>
	 <20120831180052.GB4259@jtriplet-mobl1>
	 <20120904223350.GQ2593@linux.vnet.ibm.com>
	 <1346799082.27919.31.camel@gandalf.local.home>
	 <20120904230834.GB11494@jtriplet-mobl1>
	 <1346801031.27919.39.camel@gandalf.local.home>
	 <20120904233344.GB11855@jtriplet-mobl1>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-09-04 at 16:33 -0700, Josh Triplett wrote:
>  
> > > +#ifdef MODULE
> > > +#define __DECLARE_TRACE_RCU(name, proto, args, cond, data_proto, data_args) \
> > > +	static inline void trace_##name##_rcuidle(proto)		\
> > > +	{								\
> > > +		if (static_key_false(&__tracepoint_##name.key))		\
> > > +			__DO_TRACE(&__tracepoint_##name,		\
> > > +				TP_PROTO(data_proto),			\
> > > +				TP_ARGS(data_args),			\
> > > +				TP_CONDITION(cond),			\
> > > +				rcu_idle_exit(),			\
> > > +				rcu_idle_enter());			\
> > > +	}
> > > +#else
> > > +#define __DECLARE_TRACE_RCU(name, proto, args, cond, data_proto, data_args)
> > > +#endif
> > > +
> > 
> > Egad! More macros on top of macros! Yeah I know I'm the most guilty of
> > this, but it just seems to add one more indirection that I would like to
> > avoid.
> 
> This doesn't seem to add a significant amount of complexity; it forwards
> exactly the same parameters to the helper macro, and just moves the one
> function definition there and makes it conditional.  This still seems
> more preferable than exporting functions just so they won't get called.

The change itself is not complex. But what is already there is complex
enough. I'm talking more about adding to:

$ grep '#define' include/linux/tracepoint.h
#define _LINUX_TRACEPOINT_H
#define PARAMS(args...) args
#define TP_PROTO(args...)       args
#define TP_ARGS(args...)        args
#define TP_CONDITION(args...)   args
#define __DO_TRACE(tp, proto, args, cond, prercu, postrcu)              \
#define __DECLARE_TRACE(name, proto, args, cond, data_proto, data_args) \
#define DEFINE_TRACE_FN(name, reg, unreg)                                \
#define DEFINE_TRACE(name)                                              \
#define EXPORT_TRACEPOINT_SYMBOL_GPL(name)                              \
#define EXPORT_TRACEPOINT_SYMBOL(name)                                  \
#define __DECLARE_TRACE(name, proto, args, cond, data_proto, data_args) \
#define DEFINE_TRACE_FN(name, reg, unreg)
#define DEFINE_TRACE(name)
#define EXPORT_TRACEPOINT_SYMBOL_GPL(name)
#define EXPORT_TRACEPOINT_SYMBOL(name)
#define DECLARE_TRACE_NOARGS(name)                                      \
#define DECLARE_TRACE(name, proto, args)                                \
#define DECLARE_TRACE_CONDITION(name, proto, args, cond)                \
#define TRACE_EVENT_FLAGS(event, flag)
#define DECLARE_EVENT_CLASS(name, proto, args, tstruct, assign, print)
#define DEFINE_EVENT(template, name, proto, args)               \
#define DEFINE_EVENT_PRINT(template, name, proto, args, print)  \
#define DEFINE_EVENT_CONDITION(template, name, proto,           \
#define TRACE_EVENT(name, proto, args, struct, assign, print)   \
#define TRACE_EVENT_FN(name, proto, args, struct,               \
#define TRACE_EVENT_CONDITION(name, proto, args, cond,          \
#define TRACE_EVENT_FLAGS(event, flag)


> 
> I could live with that; it seems preferable to unnecessary exports,
> though it still seems much uglier to me than the conditional definition
> of trace_*_rcuidle. :)

We could add either. Probably keep the ugliness of tracepoints inside
the tracepoint code than to start spreading it around to rcu. RCU has
its own ugliness features ;-)

Hence, I would be OK if you send me a patch that does what you proposed
and removes the EXPORT from RCU.

-- Steve


