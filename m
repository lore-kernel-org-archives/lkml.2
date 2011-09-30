Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756522Ab1I3VV5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 17:21:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:41524 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884Ab1I3VVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 17:21:54 -0400
X-Authority-Analysis: v=1.1 cv=lfM0d0QHaVz67dfwwr9cyIw6NbaGR/pZhMD6XWNi0kk= c=1 sm=0 a=TSkoyBCu-xgA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=ZfRw4ET0AAAA:8 a=D19gQVrFAAAA:8 a=o-WXjYBuCzO-IE7p3iQA:9 a=BZZ1aKRl4e_VOMZ-tdoA:7 a=PUjeQqilurYA:10 a=KciULlu47koA:10 a=4M_uD3yqGU4o8pbi:21 a=fII8uHvYTjbdbi54:21 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Subject: Re: [PATCH RFC] stop_machine: make stop_machine safe and efficient
 to call early
From: Steven Rostedt <rostedt@goodmis.org>
To: Andrew Morton <akpm00@gmail.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <htejun@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Date: Fri, 30 Sep 2011 17:21:51 -0400
In-Reply-To: <20110930140625.c7faad28.akpm00@gmail.com>
References: <4E85EE1F.7050508@goop.org>
	 <1317400496.4588.54.camel@gandalf.stny.rr.com> <4E85F596.4050704@goop.org>
	 <20110930140625.c7faad28.akpm00@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1317417713.4588.57.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-30 at 14:06 -0700, Andrew Morton wrote:
> On Fri, 30 Sep 2011 10:00:06 -0700
> Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> 
> > On 09/30/2011 09:34 AM, Steven Rostedt wrote:
> > > Doesn't interrupts need to be disabled here too? As stop machine
> > > functions also guarantee that they will not be interrupted by
> > > interrupts. -- Steve
> > 
> > Good point.
> > 
> >     J
> > 
> > Make stop_machine() safe to call early in boot, before SMP has been
> > set up, by simply calling the callback function directly if there's
> > only one CPU online.
> 
> Being a trusting soul, I shall assume that you presently have or soon
> will have some code which requires this change?

Yeah, it has to do with these patches:

https://lkml.org/lkml/2011/9/29/509

> 
> >
> > ...
> >
> > --- a/kernel/stop_machine.c
> > +++ b/kernel/stop_machine.c
> > @@ -485,6 +485,17 @@ int __stop_machine(int (*fn)(void *), void *data, const struct cpumask *cpus)
> >  					    .num_threads = num_online_cpus(),
> >  					    .active_cpus = cpus };
> >  
> > +	if (smdata.num_threads == 1) {
> > +		unsigned long flags;
> > +		int ret;
> > +
> > +		local_save_flags(flags);
> > +		ret = (*fn)(data);
> > +		local_irq_restore(flags);
> > +
> > +		return ret;
> > +	}
> 
> It is quite unobvious to readers why this code exists.  Therefore, we
> should tell them.
> 
> Also, bug.  local_save_flags() is used to read the irq flags - it does
> not actually disable interrupts.  We want local_irq_save() here.  None
> of these interfaces are documented and their naming system is crappy. 
> Cause, effect.
> 
> 
> --- a/kernel/stop_machine.c~stop_machine-make-stop_machine-safe-and-efficient-to-call-early-fix
> +++ a/kernel/stop_machine.c
> @@ -486,10 +486,14 @@ int __stop_machine(int (*fn)(void *), vo
>  					    .active_cpus = cpus };
>  
>  	if (smdata.num_threads == 1) {
> +		/*
> +		 * Handle the case where stop_machine() is called early in boot
> +		 * before SMP startup.
> +		 */
>  		unsigned long flags;
>  		int ret;
>  
> -		local_save_flags(flags);
> +		local_irq_save(flags);

Nice catch. Yeah, the naming convention is not too nice. They probably
should have been named: local_irq_disable_save() and
local_irq_enable_restore(). But that's too much to type ;)

-- Steve


>  		ret = (*fn)(data);
>  		local_irq_restore(flags);
>  
> _
> 


