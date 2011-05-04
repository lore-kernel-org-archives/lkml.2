Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932128Ab1EDX35 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 19:29:57 -0400
Received: from www.linutronix.de ([62.245.132.108]:46973 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932111Ab1EDX34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 19:29:56 -0400
Date: Thu, 5 May 2011 01:29:49 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: Dave Kleikamp <dkleikamp@gmail.com>, Chris Mason <chris.mason@oracle.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Tim Chen <tim.c.chen@linux.intel.com>, linux-kernel@vger.kernel.org,
        lenb@kernel.org, paulmck@us.ibm.com
Subject: Re: idle issues running sembench on 128 cpus
In-Reply-To: <20110504230349.GC2925@one.firstfloor.org>
Message-ID: <alpine.LFD.2.02.1105050110440.3005@ionos>
References: <4DC1C95B.4040706@gmail.com> <m2pqnyyva8.fsf@firstfloor.org> <alpine.LFD.2.02.1105050023070.3005@ionos> <20110504230349.GC2925@one.firstfloor.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 May 2011, Andi Kleen wrote:
> > No, it does not even need refcounting. We can access it outside of the
> 
> Ok.
> 
> > lock as this is atomic context called on the cpu which is about to go
> > idle and therefor the device cannot go away. Easy and straightforward
> > fix.
> 
> Ok. Patch appended. Looks good?

Mostly. See below.
 
> BTW why must the lock be irqsave?

Good question. Probably safety frist paranoia :)

Indeed that code should only be called from irq disabled regions, so
we could avoid the irqsave there. Otherwise that needs to be irqsave
for obvious reasons.

> > > But yes it would be still good to fix Nehalem too.
> > > 
> > > One fix would be to make all the masks hierarchical,
> > > similar to what RCU does. Perhaps even some code 
> > > could be shared with RCU on that because it's a very
> > > similar problem.
> > 
> > In theory. It's not about the mask. The mask is uninteresting. It's
> > about the expiry time, which we have to protect. There is nothing
> > hierarchical about that. It all boils down on _ONE_ single functional
> 
> The mask can be used to see if another thread on this core is still
> running. If yes you don't need that. Right now Linux doesn't 
> know that, but it could be taught. The only problem is that once
> the other guy goes idle too their timeouts have to be merged.
> 
> This would cut contention in half.

That makes sense, but merging the timeouts race free will be a real
PITA.

> Also if it's HPET you could actually use multiple independent HPET channels.
> I remember us discussing this a long time ago... Not sure if it's worth
> it, but it may be a small relief.

Multiple broadcast devices. That sounds still horrible :)
 
> > device and you don't want to miss out your deadline just because you
> > decided to be extra clever. RCU does not care much whether you run the
> > callbacks a tick later on not. Time and timekeeping does.
> 
> You can at least check lockless if someone else has a <= timeout, right?

Might be worth a try. Need some sleep to remember why I discarded that
idea long ago.

> -Andi
> 
> ---
> 
> Move C3 stop test outside lock
> 
> Avoid taking locks in the idle path for systems where the timer
> doesn't stop in C3.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 
> diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
> index da800ff..9cf0415 100644
> --- a/kernel/time/tick-broadcast.c
> +++ b/kernel/time/tick-broadcast.c
> @@ -456,23 +456,22 @@ void tick_broadcast_oneshot_control(unsigned long reason)
>  	unsigned long flags;
>  	int cpu;
>  
> -	raw_spin_lock_irqsave(&tick_broadcast_lock, flags);
> -
>  	/*
>  	 * Periodic mode does not care about the enter/exit of power
>  	 * states
>  	 */
>  	if (tick_broadcast_device.mode == TICKDEV_MODE_PERIODIC)
> -		goto out;
> +		return;
>  
> +	cpu = raw_smp_processor_id();

Why raw_ ? As I said above this should always be called with irqs
disabled.

If that ever gets called from an irq enabled, preemptible and
migratable context then we just open up a very narrow but ugly to
debug race window as we can look at the wrong per cpu device.

>  	bc = tick_broadcast_device.evtdev;
> -	cpu = smp_processor_id();
>  	td = &per_cpu(tick_cpu_device, cpu);
>  	dev = td->evtdev;

Thanks,

	tglx
