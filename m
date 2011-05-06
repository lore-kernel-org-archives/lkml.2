Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755067Ab1EFBlv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 21:41:51 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48430 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754647Ab1EFBlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 21:41:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=aMWRpJm8j40v3oDnKzXE117l4MVFV4JfOd5QaDcPTi6R2U56rcVuFHWoQ6YvmH6PCU
         8P7coSoVmAg0BfsDq+ldfnZZHzsDimn2qA7GNKTU83eA+2A+rN0+h/heaSW0LS+ymjRs
         FjEqj1Vsm89+dIPEWbWOXS7R617i8Q0aCnbT8=
Subject: Re: [RFC] time: xtime_lock is held too long
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
        lkml <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Anton Blanchard <anton@samba.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20110505210118.GI2925@one.firstfloor.org>
References: <1304478708-1273-1-git-send-email-john.stultz@linaro.org>
	 <m2oc3jxgtt.fsf@firstfloor.org> <1304564090.2943.36.camel@work-vm>
	 <1304574244.32152.666.camel@edumazet-laptop>
	 <1304576495.2943.40.camel@work-vm>
	 <1304604284.3032.78.camel@edumazet-laptop>
	 <alpine.LFD.2.02.1105051630390.3005@ionos>
	 <1304608095.3032.95.camel@edumazet-laptop>
	 <alpine.LFD.2.02.1105051750540.3005@ionos>
	 <20110505210118.GI2925@one.firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 06 May 2011 03:41:43 +0200
Message-ID: <1304646103.3131.3.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 05 mai 2011 à 23:01 +0200, Andi Kleen a écrit :
> > > Another idea would be to prime cache lines to be dirtied in cpu cache
> > > before taking locks, and better pack variables to reduce number of cache
> > > lines.
> > 
> > Most variables are packed already in struct timekeeper, which should
> > be pretty cache hot anyway, so I don't know whether we gain much.
> 
> There's actually some potential here. I got a moderate speedup in a
> database benchmark with this patch recently. The biggest win
> was in the timer interrupt.
> 
> All those variables are on separate cache lines.
> 
> (needs some cleanups, just for illustration)
> 
> -Andi
> 
> From: Andi Kleen <ak@linux.intel.com>
> Subject: [PATCH] do prefetches for timer state in timer interrupt
> 
> diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
> index 76b96d7..2704267 100644
> --- a/arch/x86/kernel/apic/apic.c
> +++ b/arch/x86/kernel/apic/apic.c
> @@ -856,6 +856,17 @@ void __irq_entry smp_apic_timer_interrupt(struct pt_regs *regs)
>  {
>  	struct pt_regs *old_regs = set_irq_regs(regs);
>  
> +	extern struct timespec xtime;
> +	extern struct timespec wall_to_monotonic;
> +
> +
> +	/* Prefetch here to make the ktime_get later faster.
> + 	 * XXX move them all on the same cache line.
> + 	 */
> +	prefetch(&xtime_lock);
> +	prefetch(&xtime);
> +	prefetch(&wall_to_monotonic);
> +
>  	/*
>  	 * NOTE! We'd better ACK the irq immediately,
>  	 * because timer handling can be slow.
> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index d27c756..0002e9e 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -157,8 +157,8 @@ __cacheline_aligned_in_smp DEFINE_SEQLOCK(xtime_lock);
>   * - wall_to_monotonic is no longer the boot time, getboottime must be
>   * used instead.
>   */
> -static struct timespec xtime __attribute__ ((aligned (16)));
> -static struct timespec wall_to_monotonic __attribute__ ((aligned (16)));
> +struct timespec xtime __attribute__ ((aligned (16)));
> +struct timespec wall_to_monotonic __attribute__ ((aligned (16)));
>  static struct timespec total_sleep_time;
>  
>  /*
> 


Did you tried prefetchw() by any chance ?



