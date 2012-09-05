Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755803Ab2IEO0t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 10:26:49 -0400
Received: from ironport2-out.teksavvy.com ([206.248.154.182]:49727 "EHLO
	ironport2-out.teksavvy.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753787Ab2IEO0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 10:26:46 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAG6Zu0/O+Ip3/2dsb2JhbABEtBGBCIIVAQEFOhsBIxALGC4UJSQTiA66CYsIhFpiA5UaiR+EeoFYgwU
X-IronPort-AV: E=Sophos;i="4.75,637,1330923600"; 
   d="scan'208";a="197563416"
Date: Wed, 5 Sep 2012 10:26:24 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH] trace: Don't declare trace_*_rcuidle functions in modules
Message-ID: <20120905142623.GA19713@Krystal>
References: <1346352988-32444-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346352988-32444-4-git-send-email-paulmck@linux.vnet.ibm.com>
 <20120831180052.GB4259@jtriplet-mobl1>
 <20120904223350.GQ2593@linux.vnet.ibm.com>
 <1346799082.27919.31.camel@gandalf.local.home>
 <20120904230834.GB11494@jtriplet-mobl1>
 <1346801031.27919.39.camel@gandalf.local.home>
 <20120904233344.GB11855@jtriplet-mobl1>
 <1346802402.27919.44.camel@gandalf.local.home>
 <20120905062306.GA14756@leaf>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20120905062306.GA14756@leaf>
X-Editor: vi
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Josh Triplett (josh@joshtriplett.org) wrote:
> Tracepoints declare a static inline trace_*_rcuidle variant of the trace
> function, to support safely generating trace events from the idle loop.
> Module code never actually uses that variant of trace functions, because
> modules don't run code that needs tracing with RCU idled.  However, the
> declaration of those otherwise unused functions causes the module to
> reference rcu_idle_exit and rcu_idle_enter, which RCU does not export to
> modules.
> 
> To avoid this, don't generate trace_*_rcuidle functions for tracepoints
> declared in module code.
> 
> Reported-by: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Josh Triplett <josh@joshtriplett.org>

Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

Thanks Josh!

Mathieu

> ---
> On Tue, Sep 04, 2012 at 07:46:42PM -0400, Steven Rostedt wrote:
> > We could add either. Probably keep the ugliness of tracepoints inside
> > the tracepoint code than to start spreading it around to rcu. RCU has
> > its own ugliness features ;-)
> > 
> > Hence, I would be OK if you send me a patch that does what you proposed
> > and removes the EXPORT from RCU.
> 
>  include/linux/tracepoint.h |   28 ++++++++++++++++++----------
>  1 file changed, 18 insertions(+), 10 deletions(-)
> 
> diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
> index 802de56..2f322c3 100644
> --- a/include/linux/tracepoint.h
> +++ b/include/linux/tracepoint.h
> @@ -136,6 +136,22 @@ static inline void tracepoint_synchronize_unregister(void)
>  		postrcu;						\
>  	} while (0)
>  
> +#ifndef MODULE
> +#define __DECLARE_TRACE_RCU(name, proto, args, cond, data_proto, data_args)	\
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
>  /*
>   * Make sure the alignment of the structure in the __tracepoints section will
>   * not add unwanted padding between the beginning of the section and the
> @@ -151,16 +167,8 @@ static inline void tracepoint_synchronize_unregister(void)
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
> +	__DECLARE_TRACE_RCU(name, PARAMS(proto), PARAMS(args),		\
> +		PARAMS(cond), PARAMS(data_proto), PARAMS(data_args))	\
>  	static inline int						\
>  	register_trace_##name(void (*probe)(data_proto), void *data)	\
>  	{								\
> -- 
> 1.7.10.4
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
