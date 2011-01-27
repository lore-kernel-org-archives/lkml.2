Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994Ab1A0V7d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 16:59:33 -0500
Received: from mail4.comsite.net ([205.238.176.238]:63435 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512Ab1A0V7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 16:59:32 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=71.22.127.106;
Subject: Re: [PATCH 2/2] consolidate writes in smp_call_funtion_interrupt
From: Milton Miller <miltonm@bga.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Anton Blanchard <anton@samba.org>, xiaoguangrong@cn.fujitsu.com,
        mingo@elte.hu, jaxboe@fusionio.com, npiggin@gmail.com,
        rusty@rustcorp.com.au, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, paulmck@linux.vnet.ibm.com,
        benh@kernel.crashing.org, linux-kernel@vger.kernel.org
References: <20110112150740.77dde58c@kryten>
	 <1295288253.30950.280.camel@laptop>
	 <smp-call-function-peter-reply@mdm.bga.com>
	 <smp-call-function-move-writes@mdm.bga.com>
	 <1296145360.15234.234.camel@laptop>
In-Reply-To: <1296145360.15234.234.camel@laptop>
Message-ID: <smp-call-function-list-race@mdm.bga.com>
Date: Thu, 27 Jan 2011 15:59:31 -0600
X-Originating-IP: 71.22.127.106
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Jan 2011 about 17:22:40 +0100, Peter Zijlstra wrote:
> On Tue, 2011-01-18 at 15:06 -0600, Milton Miller wrote:
> > Index: common/kernel/smp.c
> > =====================================================================
> > --- common.orig/kernel/smp.c	2011-01-17 20:16:18.000000000 -0600
> > +++ common/kernel/smp.c	2011-01-17 20:17:50.000000000 -0600
> > @@ -193,6 +193,7 @@ void generic_smp_call_function_interrupt
> >  	 */
> >  	list_for_each_entry_rcu(data, &call_function.queue, csd.list) {
> >  		int refs;
> > +		void (*func) (void *info);
> >  
> >  		/*
> >  		 * Since we walk the list without any locks, we might
> > @@ -212,24 +213,32 @@ void generic_smp_call_function_interrupt
> >  		if (atomic_read(&data->refs) == 0)
> >  			continue;
> >  
> > +		func = data->csd.func;			/* for later warn */
> >  		data->csd.func(data->csd.info);
> >  
> > +		/*
> > +		 * If the cpu mask is not still set then it enabled interrupts,
> > +		 * we took another smp interrupt, and executed the function
> > +		 * twice on this cpu.  In theory that copy decremented refs.
> > +		 */
> > +		if (!cpumask_test_and_clear_cpu(cpu, data->cpumask)) {
> > +			WARN(1, "%pS enabled interrupts and double executed\n",
> > +			     func);
> > +			continue;
> > +		}
> > +
> >  		refs = atomic_dec_return(&data->refs);
> >  		WARN_ON(refs < 0);
> >  
> >  		if (refs)
> >  			continue;
> >  
> > +		WARN_ON(!cpumask_empty(data->cpumask));
> > +
> > +		raw_spin_lock(&call_function.lock);
> > +		list_del_rcu(&data->csd.list);
> > +		raw_spin_unlock(&call_function.lock);
> > +
> >  		csd_unlock(&data->csd);
> >  	}
> >  
> 
> 
> So after this we have:
> 
> list_for_each_entry_rcu()
> rbd
>   !->cpumask			  ->cpumask = 
> rmb				wmb
>   !->refs			  ->refs =
>   ->func()			wmb
> mb				  list_add_rcu()
>   ->refs--
>   if (!->refs)
>     list_del_rcu()
> 
> So even if we see it as an old-ref, when we see a valid cpumask, valid
> ref, we execute the function clear our cpumask bit and decrement the ref
> and delete the entry, even though it might not yet be added?
> 
> 
> (old-ref)
> 				->cpumask =
>   if (!->cpumask)
> 				->refs = 
>   if (!->refs)
> 
>   ->func()
>   ->refs--
>   if (!->refs)
>     list_del_rcu()
> 				list_add_rcu()
> 
> Then what happens?

The item remains on the queue unlocked.  If we are lucky all entries
after it are serviced before we try to reuse it.  If not, when we
do the list_add_rcu while still in the list all entries after it
get lost from the service queue and will hang.

This is a further scenerio exposed by the lock removal.  Good spotting.

A simple fix would be to add to the queue before setting refs.  I can
try to work on that tomorrow, hopefully the test machine is available.

The next question is can/should we use the lock & unlock to put the
entry on the queue in place of the wmb() between setting cpu mask and
setting refs?  We still need the rmb() in _interrupt.

milton
