Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371Ab2FNIpA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 04:45:00 -0400
Received: from www.linutronix.de ([62.245.132.108]:54626 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754743Ab2FNIo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 04:44:58 -0400
Date: Thu, 14 Jun 2012 10:44:55 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [RFC patch 2/5] smpboot: Provide infrastructure for percpu
 hotplug threads
In-Reply-To: <4FD9A176.7080806@linux.vnet.ibm.com>
Message-ID: <alpine.LFD.2.02.1206141039010.3086@ionos>
References: <20120613102823.373180763@linutronix.de> <20120613105815.206105518@linutronix.de> <4FD9A176.7080806@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jun 2012, Srivatsa S. Bhat wrote:
> On 06/13/2012 04:30 PM, Thomas Gleixner wrote:
> > @@ -280,6 +280,7 @@ static int __ref _cpu_down(unsigned int 
> >  				__func__, cpu);
> >  		goto out_release;
> >  	}
> > +	smpboot_park_threads(cpu);
> > 
> 
> 
> If cpu_down fails further down, don't we want to unpark these threads
> as part of error recovery?

Right.

> >  	err = __stop_machine(take_cpu_down, &tcd_param, cpumask_of(cpu));
> >  	if (err) {
> > @@ -354,6 +355,10 @@ static int __cpuinit _cpu_up(unsigned in
> >  		goto out;
> >  	}
> > 
> > +	ret = smpboot_create_threads(cpu);
> > +	if (ret)
> > +		goto out;
> > +
> 
> 
> Here also, we might want to clean up on error right?

Good question. If we failed to create a thread, we can't online the
cpu, but we might try again later. So now the question is whether we
really need to completely destroy the already created and parked ones
or just leave them around. No real opinion on that, I just picked the
lazy way :)

Thanks,

	tglx
