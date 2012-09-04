Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932925Ab2IDXXz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 19:23:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14502 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932852Ab2IDXXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 19:23:53 -0400
X-Authority-Analysis: v=2.0 cv=C49rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=jUoZk2RAzk0A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=7zoRB9YQJIYA:10 a=imTROTZUkysA:10 a=RAM01ziftVcA:10 a=wFfiXLW5-aMA:10 a=56vLhSP8h14A:10 a=2eRPLDGB9N0A:10 a=KKAkSRfTAAAA:8 a=VnNF1IyMAAAA:8 a=Fi82Y59vGp6yMpx_A38A:9 a=PUjeQqilurYA:10 a=WwgC8nHKvroA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1346801031.27919.39.camel@gandalf.local.home>
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
Date: Tue, 04 Sep 2012 19:23:51 -0400
In-Reply-To: <20120904230834.GB11494@jtriplet-mobl1>
References: <20120830185607.GA32148@linux.vnet.ibm.com>
	 <1346352988-32444-1-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1346352988-32444-4-git-send-email-paulmck@linux.vnet.ibm.com>
	 <20120831180052.GB4259@jtriplet-mobl1>
	 <20120904223350.GQ2593@linux.vnet.ibm.com>
	 <1346799082.27919.31.camel@gandalf.local.home>
	 <20120904230834.GB11494@jtriplet-mobl1>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-09-04 at 16:08 -0700, Josh Triplett wrote:
> On Tue, Sep 04, 2012 at 06:51:22PM -0400, Steven Rostedt wrote:
> > On Tue, 2012-09-04 at 15:33 -0700, Paul E. McKenney wrote:
> > > On Fri, Aug 31, 2012 at 11:00:52AM -0700, Josh Triplett wrote:
> > > > On Thu, Aug 30, 2012 at 11:56:17AM -0700, Paul E. McKenney wrote:
> > > > > From: "Paul E. McKenney" <paul.mckenney@linaro.org>
> > > > > 
> > > > > There is a need to use RCU from interrupt context, but either before
> > > > > rcu_irq_enter() is called or after rcu_irq_exit() is called.  If the
> > > > > interrupt occurs from idle, then lockdep-RCU will complain about such
> > > > > uses, as they appear to be illegal uses of RCU from the idle loop.
> > > > > In other environments, RCU_NONIDLE() could be used to properly protect
> > > > > the use of RCU, but RCU_NONIDLE() currently cannot be invoked except
> > > > > from process context.
> > > > > 
> > > > > This commit therefore modifies RCU_NONIDLE() to permit its use more
> > > > > globally.
> > > > > 
> > > > > Reported-by: Steven Rostedt <rostedt@goodmis.org>
> > > > > Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> > > > > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > > 
> > > > Something seems wrong about this.  The addition of EXPORT_SYMBOL_GPL
> > > > suggests that such interrupt handlers might live in modules.  In what
> > > > situation might a module interrupt handler get called from the idle
> > > > loop, before rcu_irq_enter or after rcu_irq_exit, and need to know that
> > > > when using RCU?
> > > 
> > > Drivers can be in modules, in which case their interrupt handlers will
> > > also be in the corresponding module.  I do agree that in most cases,
> > > the irq_enter() and irq_exit() hooks would be invoked by non-module code,
> > > but I do believe that I had to add those exports due to build failures.
> > > 
> > > Steven will let me know if I am confused on this point.
> > > 
> > 
> > You're not confused, the situation is confusing :-/
> > 
> > Because some trace events happen inside the idle loop after rcu has
> > "shutdown", we needed to create "trace_foo_rcuidle()" handlers that can
> > handle this condition. That is, for every trace_foo() static inline
> > (used at the tracepoint location), there exists a static inline
> > trace_foo_rcuidle(), that looks something like this:
> > 
> > static inline void trace_##name##_rcuidle(proto) {
> > 	if (static_key_false(&__tracepoint_##name.key)) { 
> > 		rcu_idle_exit();
> > 		__DO_TRACE();
> > 		rcu_idle_enter();
> > 	}
> > }
> > 
> > Although these calls are never used by module code, because they are
> > static inlines, they are still defined for all tracepoints, kernel
> > tracepoints as well as module tracepoints. And thus, need the export :-(
> 
> Fair enough.
> 
> What about having the tracepoint code generation detect when building as
> part of a module via defined(MODULE), and omit the unused _rcuidle
> versions in those cases?  That would avoid the need to export those
> functions at all.  Strawman patch (not tested):
> 
> diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
> index 802de56..41e1ef2 100644
> --- a/include/linux/tracepoint.h
> +++ b/include/linux/tracepoint.h
> @@ -136,6 +136,22 @@ static inline void tracepoint_synchronize_unregister(void)
>  		postrcu;						\
>  	} while (0)
>  
> +#ifdef MODULE
> +#define __DECLARE_TRACE_RCU(name, proto, args, cond, data_proto, data_args) \
> +	static inline void trace_##name##_rcuidle(proto)		\
> +	{								\
> +		if (static_key_false(&__tracepoint_##name.key))		\
> +			__DO_TRACE(&__tracepoint_##name,		\
> +				TP_PROTO(data_proto),			\
> +				TP_ARGS(data_args),			\
> +				TP_CONDITION(cond),			\
> +				rcu_idle_exit(),			\
> +				rcu_idle_enter());			\
> +	}
> +#else
> +#define __DECLARE_TRACE_RCU(name, proto, args, cond, data_proto, data_args)
> +#endif
> +

Egad! More macros on top of macros! Yeah I know I'm the most guilty of
this, but it just seems to add one more indirection that I would like to
avoid.

>  /*
>   * Make sure the alignment of the structure in the __tracepoints section will
>   * not add unwanted padding between the beginning of the section and the
> @@ -151,16 +167,7 @@ static inline void tracepoint_synchronize_unregister(void)
>  				TP_ARGS(data_args),			\
>  				TP_CONDITION(cond),,);			\
>  	}								\
> -	static inline void trace_##name##_rcuidle(proto)		\
> -	{								\
> -		if (static_key_false(&__tracepoint_##name.key))		\
> -			__DO_TRACE(&__tracepoint_##name,		\
> -				TP_PROTO(data_proto),			\
> -				TP_ARGS(data_args),			\
> -				TP_CONDITION(cond),			\
> -				rcu_idle_exit(),			\
> -				rcu_idle_enter());			\
> -	}								\
> +	__DECLARE_TRACE_RCU(name, proto, args, cond, data_proto, data_args) \
>  	static inline int						\
>  	register_trace_##name(void (*probe)(data_proto), void *data)	\
>  	{								\
> 
> 
> If that doesn't work out, please consider adding an explicit comment
> saying why you exported the functions.
> 

Or, we could also add in include/linux/rcupdate.h:

#ifdef MODULE
static inline void rcu_idle_enter(void) {
	panic("Don't call me from modules");
}
static inline void rcu_idle_exit(void) {
	panic("Don't call me from modules");
}
#else
extern void rcu_idle_enter(void);
extern void rcu_idle_exit(void);
#endif



Hmm, if there ever happens to be a governor that can be loaded as a
module, and if it has a tracepoint, then it would require this too.

But the first time someone tries that, it will panic with the above
code ;-)

-- Steve


