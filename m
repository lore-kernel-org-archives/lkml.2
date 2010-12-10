Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812Ab0LJSLP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 13:11:15 -0500
Received: from canuck.infradead.org ([134.117.69.58]:40491 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129Ab0LJSLO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 13:11:14 -0500
Subject: Re: [BUG] 2.6.37-rc3 massive interactivity regression on ARM
From: Peter Zijlstra <peterz@infradead.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Venkatesh Pallipadi <venki@google.com>, Mikael Pettersson <mikpe@it.uu.se>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        John Stultz <johnstul@us.ibm.com>
In-Reply-To: <20101210175645.GB28263@n2100.arm.linux.org.uk>
References: <1291917330.6803.7.camel@twins>
	 <AANLkTin+eO_jPceSOHL4e7vqd+tf0ZCMHJ-USoz8aZL1@mail.gmail.com>
	 <1291920939.6803.38.camel@twins>
	 <AANLkTim+v21RpWobdw6exEbazDJwm4JjemPVB2+3PuRJ@mail.gmail.com>
	 <1291936593.13513.3.camel@laptop>
	 <AANLkTi=_qf8NAgj2HHMP0qG-ibnH-726NzoXbxd-bS1N@mail.gmail.com>
	 <1291975704.6803.59.camel@twins> <1291987065.6803.151.camel@twins>
	 <1291987635.6803.161.camel@twins> <1291988866.6803.171.camel@twins>
	 <20101210175645.GB28263@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 10 Dec 2010 19:10:54 +0100
Message-ID: <1292004654.13513.38.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-10 at 17:56 +0000, Russell King - ARM Linux wrote:
> On Fri, Dec 10, 2010 at 02:47:46PM +0100, Peter Zijlstra wrote:
> >  inline void update_rq_clock(struct rq *rq)
> >  {
> > -	int cpu = cpu_of(rq);
> > -	u64 irq_time;
> > +	s64 delta;
> >  
> >  	if (rq->skip_clock_update)
> >  		return;
> >  
> > -	rq->clock = sched_clock_cpu(cpu);
> > -	irq_time = irq_time_cpu(cpu);
> > -	if (rq->clock - irq_time > rq->clock_task)
> > -		rq->clock_task = rq->clock - irq_time;
> > +	delta = sched_clock_cpu(cpu_of(rq)) - rq->clock;
> > +	rq->clock += delta;
> 
> Hmm.  Can you tell me how this is different to:
> 
> 	new_clock = sched_clock_cpu(cpu_of(rq));
> 	delta = new_clock - rq->clock;
> 	rq->clock = new_clock;
> 
> which I think may be simpler in terms of 64-bit math for 32-bit compilers
> to deal with?

Its not, I could write it like that, the only reason I didn't is because
it uses an extra variable. If gcc on 32bit targets really generates
hideous code for it I'll happily change it.

> In terms of the wrap-around, I don't see this as any different from the
> above, as:
> 
> 	rq->clock += sched_clock_cpu(cpu_of(rq)) - rq_clock;
> 	rq->clock = rq->clock + sched_clock_cpu(cpu_of(rq)) - rq_clock;
> 	rq->clock = sched_clock_cpu(cpu_of(rq));

Correct, its not different. Nor was it meant to be. The only problem it
solves is the u64 wrap failure in:

  if (rq->clock - irq_time > rq->clock_task)

There are lots of places in the scheduler that rely on u64 wrap, for now
the easiest thing for ARM would be to select HAVE_UNSTABLE_SCHED_CLOCK
for those platforms that implement a short sched_clock().

While that isn't ideal it is something that makes it work, we can work
on something more suitable for future kernels.
