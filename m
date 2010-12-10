Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631Ab0LJR5j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 12:57:39 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34749 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754873Ab0LJR5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 12:57:38 -0500
Date: Fri, 10 Dec 2010 17:56:45 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Venkatesh Pallipadi <venki@google.com>, Mikael Pettersson <mikpe@it.uu.se>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        John Stultz <johnstul@us.ibm.com>
Subject: Re: [BUG] 2.6.37-rc3 massive interactivity regression on ARM
Message-ID: <20101210175645.GB28263@n2100.arm.linux.org.uk>
References: <1291917330.6803.7.camel@twins> <AANLkTin+eO_jPceSOHL4e7vqd+tf0ZCMHJ-USoz8aZL1@mail.gmail.com> <1291920939.6803.38.camel@twins> <AANLkTim+v21RpWobdw6exEbazDJwm4JjemPVB2+3PuRJ@mail.gmail.com> <1291936593.13513.3.camel@laptop> <AANLkTi=_qf8NAgj2HHMP0qG-ibnH-726NzoXbxd-bS1N@mail.gmail.com> <1291975704.6803.59.camel@twins> <1291987065.6803.151.camel@twins> <1291987635.6803.161.camel@twins> <1291988866.6803.171.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291988866.6803.171.camel@twins>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 10, 2010 at 02:47:46PM +0100, Peter Zijlstra wrote:
>  inline void update_rq_clock(struct rq *rq)
>  {
> -	int cpu = cpu_of(rq);
> -	u64 irq_time;
> +	s64 delta;
>  
>  	if (rq->skip_clock_update)
>  		return;
>  
> -	rq->clock = sched_clock_cpu(cpu);
> -	irq_time = irq_time_cpu(cpu);
> -	if (rq->clock - irq_time > rq->clock_task)
> -		rq->clock_task = rq->clock - irq_time;
> +	delta = sched_clock_cpu(cpu_of(rq)) - rq->clock;
> +	rq->clock += delta;

Hmm.  Can you tell me how this is different to:

	new_clock = sched_clock_cpu(cpu_of(rq));
	delta = new_clock - rq->clock;
	rq->clock = new_clock;

which I think may be simpler in terms of 64-bit math for 32-bit compilers
to deal with?

In terms of the wrap-around, I don't see this as any different from the
above, as:

	rq->clock += sched_clock_cpu(cpu_of(rq)) - rq_clock;
	rq->clock = rq->clock + sched_clock_cpu(cpu_of(rq)) - rq_clock;
	rq->clock = sched_clock_cpu(cpu_of(rq));
