Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504Ab2C2FvR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 01:51:17 -0400
Received: from ozlabs.org ([203.10.76.45]:55386 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159Ab2C2FvJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 01:51:09 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [RFC][PATCH] tracing/module: Move tracepoint out of module.h
In-Reply-To: <1332994964.3402.17.camel@edumazet-laptop>
References: <1327545664.22710.78.camel@gandalf.stny.rr.com> <20120126102836.GD3853@elte.hu> <1327585945.22710.87.camel@gandalf.stny.rr.com> <20120126135504.GA13107@elte.hu> <1327586669.22710.89.camel@gandalf.stny.rr.com> <1327588606.22710.100.camel@gandalf.stny.rr.com> <20120126183946.GA14709@elte.hu> <87ehuldf0m.fsf@rustcorp.com.au> <1327924333.22710.157.camel@gandalf.stny.rr.com> <87sjiwjzew.fsf@rustcorp.com.au> <20120131122016.GF32010@elte.hu> <1328014230.5882.29.camel@gandalf.stny.rr.com> <87y5snhwwd.fsf@rustcorp.com.au> <1332994964.3402.17.camel@edumazet-laptop>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 29 Mar 2012 15:54:34 +1030
Message-ID: <87limkx9m5.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Mar 2012 06:22:44 +0200, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le mercredi 01 février 2012 à 17:18 +1030, Rusty Russell a écrit :
> 
> >  
> > +void __module_get(struct module *module)
> > +{
> > +	if (module) {
> > +		preempt_disable();
> > +		__this_cpu_inc(module->refptr->incs);
> > +		trace_module_get(module, _RET_IP_);
> > +		preempt_enable();
> > +	}
> > +}
> > +EXPORT_SYMBOL(__module_get);
> > +
> 
> Hi Rusty
> 
> I am wondering why preempt_disable()/preempt_enable() is needed in this
> code.
> 
> this_cpu_inc(module->refptr->incs) is preempt safe...

I agree, it's overkill here:

> @@ -907,10 +907,8 @@ static struct module_attribute modinfo_refcnt =
>  void __module_get(struct module *module)
>  {
>  	if (module) {
> -		preempt_disable();
> -		__this_cpu_inc(module->refptr->incs);
> +		this_cpu_inc(module->refptr->incs);
>  		trace_module_get(module, _RET_IP_);
> -		preempt_enable();
>  	}
>  }
>  EXPORT_SYMBOL(__module_get);

But this one is required:

> @@ -920,15 +918,11 @@ bool try_module_get(struct module *module)
>  	bool ret = true;
>  
>  	if (module) {
> -		preempt_disable();
> -
>  		if (likely(module_is_live(module))) {
> -			__this_cpu_inc(module->refptr->incs);
> +			this_cpu_inc(module->refptr->incs);
>  			trace_module_get(module, _RET_IP_);
>  		} else
>  			ret = false;
> -
> -		preempt_enable();
>  	}
>  	return ret;
>  }

This is to protect against module removal's stop_machine.

> @@ -937,15 +931,13 @@ EXPORT_SYMBOL(try_module_get);
>  void module_put(struct module *module)
>  {
>  	if (module) {
> -		preempt_disable();
>  		smp_wmb(); /* see comment in module_refcount */
> -		__this_cpu_inc(module->refptr->decs);
> +		this_cpu_inc(module->refptr->decs);
>  
>  		trace_module_put(module, _RET_IP_);
>  		/* Maybe they're waiting for us to drop reference? */
>  		if (unlikely(!module_is_live(module)))
>  			wake_up_process(module->waiter);
> -		preempt_enable();
>  	}
>  }
>  EXPORT_SYMBOL(module_put);

Without the preempt disable, module can vanish immediately
after that increment.

Cheers,
Rusty.
-- 
  How could I marry someone with more hair than me?  http://baldalex.org
