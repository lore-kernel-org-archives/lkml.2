Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989Ab1BGINH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 03:13:07 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:51781 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752694Ab1BGINF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 03:13:05 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+zBisKkJSzGsSn8hzBB2l8Fdzikg9Lp+DG+iADVp
	YiuuLtwKLuKJMG
Subject: Re: [PATCH 1/3 v2] call_function_many: fix list delete vs add race
From: Mike Galbraith <efault@gmx.de>
To: paulmck@linux.vnet.ibm.com
Cc: Milton Miller <miltonm@bga.com>, Peter Zijlstra <peterz@infradead.org>,
        akpm@linux-foundation.org, Anton Blanchard <anton@samba.org>,
        xiaoguangrong@cn.fujitsu.com, mingo@elte.hu, jaxboe@fusionio.com,
        npiggin@gmail.com, JBeulich@novell.com, rusty@rustcorp.com.au,
        torvalds@linux-foundation.org, benh@kernel.crashing.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110202041740.GB2129@linux.vnet.ibm.com>
References: <1295288253.30950.280.camel@laptop>
	 <smp-call-function-peter-reply@mdm.bga.com>
	 <smp-call-function-move-writes@mdm.bga.com>
	 <1296145360.15234.234.camel@laptop>
	 <smp-call-function-list-race@mdm.bga.com>
	 <smp-call-function-list-race-fix@mdm.bga.com> <ipi-list-reply@mdm.bga.com>
	 <smp-call-function-list-race-fix-v2@mdm.bga.com>
	 <20110201220026.GD2142@linux.vnet.ibm.com> <ipi-paul-reply@mdm.bga.com>
	 <20110202041740.GB2129@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Feb 2011 09:12:54 +0100
Message-ID: <1297066374.5739.38.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-01 at 20:17 -0800, Paul E. McKenney wrote:

FWIW, my red headed stepchild (.32 xen cluster beast) with..
   smp-smp_call_function_many-fix-SMP-race (6dc1989)
   smp-consolidate-writes-in-smp_call_function_interrupt (225c8e0)
   smp-smp_call_function_many-fix-list-delete-vs-add-race (V2)
   smp-smp_call_function_many-handle-concurrent-clearing-of-mask (V2)
   smp-generic_smp_call_function_interrupt-additional-memory-order-tightening (below)
..has not experienced any IPI problems lately, nor have I been able to
trigger anything beating up my box running normal x64_64 kernels.

That's not saying much since my IPI woes were only the concurrent
clearing variety, just letting you know that these patches have received
(and are receiving) hefty thumpage.

> ------------------------------------------------------------------------
> 
> smp_call_function: additional memory-order tightening.
> 
> The csd_lock() and csd_unlock() interaction guarantees that the
> smp_call_function_many() function sees the results of interactions
> with prior incarnations of the callback, so the check is not needed.
> Instead, tighter memory ordering is required in the companion
> generic_smp_call_function_interrupt() function to ensure proper
> interaction with partially initialized callbacks.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> diff --git a/kernel/smp.c b/kernel/smp.c
> index 064bb6e..e091905 100644
> --- a/kernel/smp.c
> +++ b/kernel/smp.c
> @@ -182,7 +182,7 @@ void generic_smp_call_function_interrupt(void)
>  
>  	/*
>  	 * Ensure entry is visible on call_function_queue after we have
> -	 * entered the IPI. See comment in smp_call_function_many.
> +	 * entered the IPI. See comment in smp_call_function_many
>  	 * If we don't have this, then we may miss an entry on the list
>  	 * and never get another IPI to process it.
>  	 */
> @@ -209,13 +209,18 @@ void generic_smp_call_function_interrupt(void)
>  		if (!cpumask_test_cpu(cpu, data->cpumask))
>  			continue;
>  
> -		smp_rmb();
> +		smp_mb(); /* If we see our bit set above, we need to see */
> +			  /* all the processing associated with the prior */
> +			  /* incarnation of this callback. */
>  
>  		if (atomic_read(&data->refs) == 0)
>  			continue;
>  
> +		smp_rmb(); /* We need to read ->refs before we read either */
> +			   /* ->csd.func and ->csd.info. */
> +
>  		func = data->csd.func;			/* for later warn */
> -		data->csd.func(data->csd.info);
> +		func(data->csd.info);
>  
>  		/*
>  		 * If the cpu mask is not still set then func enabled


