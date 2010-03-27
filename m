Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751018Ab0C0EXY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 00:23:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:48792 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704Ab0C0EXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 00:23:23 -0400
X-Authority-Analysis: v=1.1 cv=wckZLekju2+u3kt9osT+oU4XGSlOYx61urhSnO42l8s= c=1 sm=0 a=Vn2jEp5yelMA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=omOdbC7AAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=yPCof4ZbAAAA:8 a=7d_E57ReAAAA:8 a=XR_9TKGRRUws91XV4XwA:9 a=vXGqdas6bqvtzyW1TUgA:7 a=fQrdPak9E0bGjI2T-Hy85LydVVIA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=7DSvI1NPTFQA:10 a=D6-X0JM3zdQA:10 a=LI9Vle30uBYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [tip:tracing/urgent] tracing: Remove side effect from module
 tracepoints that caused a GPF
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, tglx@linutronix.de, randy.dunlap@oracle.com,
       linux-tip-commits@vger.kernel.org
In-Reply-To: <20100327041026.GA21240@Krystal>
References: <4BA97FA7.6040406@cn.fujitsu.com>
	 <tip-3656d5431262ca25aba01d08a5b6e1295ab8feeb@git.kernel.org>
	 <20100327041026.GA21240@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Sat, 27 Mar 2010 00:23:19 -0400
Message-ID: <1269663799.19685.922.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-03-27 at 00:10 -0400, Mathieu Desnoyers wrote:
> Steven, how about also merging my patch that address the underlying bug in
> module.h that cause the GPF in the first place into 2.6.33.x ?
> 

I must have missed it, can you resend. I was under the impression that
this was the fix for the GPF. If it isn't and your patch is the true
fix, then perhaps this patch does not need to be applied to 34, and can
wait till 35. And we can push your patch instead.

Thanks,

-- Steve

> Thanks,
> 
> Mathieu
> 
> * tip-bot for Li Zefan (lizf@cn.fujitsu.com) wrote:
> > Commit-ID:  3656d5431262ca25aba01d08a5b6e1295ab8feeb
> > Gitweb:     http://git.kernel.org/tip/3656d5431262ca25aba01d08a5b6e1295ab8feeb
> > Author:     Li Zefan <lizf@cn.fujitsu.com>
> > AuthorDate: Wed, 24 Mar 2010 10:57:43 +0800
> > Committer:  Steven Rostedt <rostedt@goodmis.org>
> > CommitDate: Fri, 26 Mar 2010 15:30:21 -0400
> > 
> > tracing: Remove side effect from module tracepoints that caused a GPF
> > 
> > Remove the @refcnt argument, because it has side-effects, and arguments with
> > side-effects are not skipped by the jump over disabled instrumentation and are
> > executed even when the tracepoint is disabled.
> > 
> > This was also causing a GPF as found by Randy Dunlap:
> > 
> > Subject: 2.6.33 GP fault only when built with tracing
> > LKML-Reference: <4BA2B69D.3000309@oracle.com>
> > 
> > Tested-by: Randy Dunlap <randy.dunlap@oracle.com>
> > Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> > Cc: stable@kernel.org
> > Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> > LKML-Reference: <4BA97FA7.6040406@cn.fujitsu.com>
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > ---
> >  include/linux/module.h        |    6 ++----
> >  include/trace/events/module.h |   14 +++++++-------
> >  kernel/module.c               |    3 +--
> >  3 files changed, 10 insertions(+), 13 deletions(-)
> > 
> > diff --git a/include/linux/module.h b/include/linux/module.h
> > index 5e869ff..393ec39 100644
> > --- a/include/linux/module.h
> > +++ b/include/linux/module.h
> > @@ -460,8 +460,7 @@ static inline void __module_get(struct module *module)
> >  	if (module) {
> >  		preempt_disable();
> >  		__this_cpu_inc(module->refptr->count);
> > -		trace_module_get(module, _THIS_IP_,
> > -				 __this_cpu_read(module->refptr->count));
> > +		trace_module_get(module, _THIS_IP_);
> >  		preempt_enable();
> >  	}
> >  }
> > @@ -475,8 +474,7 @@ static inline int try_module_get(struct module *module)
> >  
> >  		if (likely(module_is_live(module))) {
> >  			__this_cpu_inc(module->refptr->count);
> > -			trace_module_get(module, _THIS_IP_,
> > -				__this_cpu_read(module->refptr->count));
> > +			trace_module_get(module, _THIS_IP_);
> >  		}
> >  		else
> >  			ret = 0;
> > diff --git a/include/trace/events/module.h b/include/trace/events/module.h
> > index 4b0f48b..a585f81 100644
> > --- a/include/trace/events/module.h
> > +++ b/include/trace/events/module.h
> > @@ -53,9 +53,9 @@ TRACE_EVENT(module_free,
> >  
> >  DECLARE_EVENT_CLASS(module_refcnt,
> >  
> > -	TP_PROTO(struct module *mod, unsigned long ip, int refcnt),
> > +	TP_PROTO(struct module *mod, unsigned long ip),
> >  
> > -	TP_ARGS(mod, ip, refcnt),
> > +	TP_ARGS(mod, ip),
> >  
> >  	TP_STRUCT__entry(
> >  		__field(	unsigned long,	ip		)
> > @@ -65,7 +65,7 @@ DECLARE_EVENT_CLASS(module_refcnt,
> >  
> >  	TP_fast_assign(
> >  		__entry->ip	= ip;
> > -		__entry->refcnt	= refcnt;
> > +		__entry->refcnt	= __this_cpu_read(mod->refptr->count);
> >  		__assign_str(name, mod->name);
> >  	),
> >  
> > @@ -75,16 +75,16 @@ DECLARE_EVENT_CLASS(module_refcnt,
> >  
> >  DEFINE_EVENT(module_refcnt, module_get,
> >  
> > -	TP_PROTO(struct module *mod, unsigned long ip, int refcnt),
> > +	TP_PROTO(struct module *mod, unsigned long ip),
> >  
> > -	TP_ARGS(mod, ip, refcnt)
> > +	TP_ARGS(mod, ip)
> >  );
> >  
> >  DEFINE_EVENT(module_refcnt, module_put,
> >  
> > -	TP_PROTO(struct module *mod, unsigned long ip, int refcnt),
> > +	TP_PROTO(struct module *mod, unsigned long ip),
> >  
> > -	TP_ARGS(mod, ip, refcnt)
> > +	TP_ARGS(mod, ip)
> >  );
> >  
> >  TRACE_EVENT(module_request,
> > diff --git a/kernel/module.c b/kernel/module.c
> > index c968d36..21591ad 100644
> > --- a/kernel/module.c
> > +++ b/kernel/module.c
> > @@ -800,8 +800,7 @@ void module_put(struct module *module)
> >  		preempt_disable();
> >  		__this_cpu_dec(module->refptr->count);
> >  
> > -		trace_module_put(module, _RET_IP_,
> > -				 __this_cpu_read(module->refptr->count));
> > +		trace_module_put(module, _RET_IP_);
> >  		/* Maybe they're waiting for us to drop reference? */
> >  		if (unlikely(!module_is_live(module)))
> >  			wake_up_process(module->waiter);
> 


