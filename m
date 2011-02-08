Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877Ab1BHTg6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 14:36:58 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:44153 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755867Ab1BHTg4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 14:36:56 -0500
Date: Tue, 8 Feb 2011 11:36:50 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Milton Miller <miltonm@bga.com>, Peter Zijlstra <peterz@infradead.org>,
        akpm@linux-foundation.org, Anton Blanchard <anton@samba.org>,
        xiaoguangrong@cn.fujitsu.com, mingo@elte.hu, jaxboe@fusionio.com,
        npiggin@gmail.com, JBeulich@novell.com, rusty@rustcorp.com.au,
        torvalds@linux-foundation.org, benh@kernel.crashing.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3 v2] call_function_many: fix list delete vs add race
Message-ID: <20110208193650.GG2146@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <smp-call-function-move-writes@mdm.bga.com>
 <1296145360.15234.234.camel@laptop>
 <smp-call-function-list-race@mdm.bga.com>
 <smp-call-function-list-race-fix@mdm.bga.com>
 <ipi-list-reply@mdm.bga.com>
 <smp-call-function-list-race-fix-v2@mdm.bga.com>
 <20110201220026.GD2142@linux.vnet.ibm.com>
 <ipi-paul-reply@mdm.bga.com>
 <20110202041740.GB2129@linux.vnet.ibm.com>
 <1297066374.5739.38.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297066374.5739.38.camel@marge.simson.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 07, 2011 at 09:12:54AM +0100, Mike Galbraith wrote:
> On Tue, 2011-02-01 at 20:17 -0800, Paul E. McKenney wrote:
> 
> FWIW, my red headed stepchild (.32 xen cluster beast) with..
>    smp-smp_call_function_many-fix-SMP-race (6dc1989)
>    smp-consolidate-writes-in-smp_call_function_interrupt (225c8e0)
>    smp-smp_call_function_many-fix-list-delete-vs-add-race (V2)
>    smp-smp_call_function_many-handle-concurrent-clearing-of-mask (V2)
>    smp-generic_smp_call_function_interrupt-additional-memory-order-tightening (below)
> ..has not experienced any IPI problems lately, nor have I been able to
> trigger anything beating up my box running normal x64_64 kernels.
> 
> That's not saying much since my IPI woes were only the concurrent
> clearing variety, just letting you know that these patches have received
> (and are receiving) hefty thumpage.

Very good, I have added your Tested-by to my patch.

							Thanx, Paul

> > ------------------------------------------------------------------------
> > 
> > smp_call_function: additional memory-order tightening.
> > 
> > The csd_lock() and csd_unlock() interaction guarantees that the
> > smp_call_function_many() function sees the results of interactions
> > with prior incarnations of the callback, so the check is not needed.
> > Instead, tighter memory ordering is required in the companion
> > generic_smp_call_function_interrupt() function to ensure proper
> > interaction with partially initialized callbacks.
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > 
> > diff --git a/kernel/smp.c b/kernel/smp.c
> > index 064bb6e..e091905 100644
> > --- a/kernel/smp.c
> > +++ b/kernel/smp.c
> > @@ -182,7 +182,7 @@ void generic_smp_call_function_interrupt(void)
> >  
> >  	/*
> >  	 * Ensure entry is visible on call_function_queue after we have
> > -	 * entered the IPI. See comment in smp_call_function_many.
> > +	 * entered the IPI. See comment in smp_call_function_many
> >  	 * If we don't have this, then we may miss an entry on the list
> >  	 * and never get another IPI to process it.
> >  	 */
> > @@ -209,13 +209,18 @@ void generic_smp_call_function_interrupt(void)
> >  		if (!cpumask_test_cpu(cpu, data->cpumask))
> >  			continue;
> >  
> > -		smp_rmb();
> > +		smp_mb(); /* If we see our bit set above, we need to see */
> > +			  /* all the processing associated with the prior */
> > +			  /* incarnation of this callback. */
> >  
> >  		if (atomic_read(&data->refs) == 0)
> >  			continue;
> >  
> > +		smp_rmb(); /* We need to read ->refs before we read either */
> > +			   /* ->csd.func and ->csd.info. */
> > +
> >  		func = data->csd.func;			/* for later warn */
> > -		data->csd.func(data->csd.info);
> > +		func(data->csd.info);
> >  
> >  		/*
> >  		 * If the cpu mask is not still set then func enabled
> 
> 
