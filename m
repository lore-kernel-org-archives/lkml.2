Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342Ab0DXN6X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Apr 2010 09:58:23 -0400
Received: from mail.openrapids.net ([64.15.138.104]:49419 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751034Ab0DXN6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Apr 2010 09:58:20 -0400
Date: Sat, 24 Apr 2010 09:58:18 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: cpufreq <cpufreq@vger.kernel.org>,
       linux-arm-msm <linux-arm-msm@vger.kernel.org>,
       Dave Jones <davej@redhat.com>, Thomas Renninger <trenn@suse.de>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: CPUfreq - udelay() interaction issues
Message-ID: <20100424135817.GA27322@Krystal>
References: <4BCFC3D0.5080904@codeaurora.org> <4BD0D9E5.3020606@codeaurora.org> <20100423184042.GA16190@Krystal> <4BD25C37.4070005@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BD25C37.4070005@codeaurora.org>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 09:30:52 up 91 days, 16:08,  5 users,  load average: 0.23, 0.25,
	0.17
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Saravana Kannan (skannan@codeaurora.org) wrote:
[...]
>
> Seems a bit more complicated than what I had in mind. This is touching  
> the scheduler I think we can get away without having to. Also, there is  
> no simple implementation for the "slowpath" that can guarantee the delay  
> without starting over the loop and hoping not to get interrupted or just  
> giving up and doing a massively inaccurate delay (like msleep, etc).

Not necessarily. Another way to do it: we could keep the udelay loop counter in
the task struct. When ondemand changes frequency, and upon migration, this
counter would be adapted to the current cpu frequency.

>
> I was thinking of something along the lines of this:
>
> udelay()
> {
>   if (!is_atomic())

see hardirq.h:

/*
 * Are we running in atomic context?  WARNING: this macro cannot
 * always detect atomic context; in particular, it cannot know about
 * held spinlocks in non-preemptible kernels.  Thus it should not be
 * used in the general case to determine whether sleeping is possible.
 * Do not use in_atomic() in driver code.
 */
#define in_atomic()     ((preempt_count() & ~PREEMPT_ACTIVE) != PREEMPT_INATOMIC_BASE)

Sorry, your scheme is broken on !PREEMPT kernels.

> 	down_read(&freq_sem);
>   /* else
> 	do nothing since cpufreq can't interrupt you.
>   */

This comment seems broken. in_atomic() can return true because preemption is
disabled, thus letting cpufreq interrupts coming in.

>
>   call usual code since cpufreq is not going to preempt you.
>
>   if (!is_atomic())
> 	up_read(&freq_sem);
> }
>
> __cpufreq_driver_target(...)
> {
>   down_write(&freq_sem);
>   cpufreq_driver->target(...);
>   up_write(&freq_sem);
> }
>
> In the implementation of the cpufreq driver, they just need to make sure  
> they always increase the LPJ _before_ increasing the freq and decrease  
> the LPJ _after_ decreasing the freq. This is make sure that when an  
> interrupt handler preempts the cpufreq driver code (since atomic  
> contexts aren't looking at the r/w semaphore) the LPJ value will be good  
> enough to satisfy the _at least_ guarantee of udelay().
>
> For the CPU switching issue, I think the solution I proposed is quite  
> simple and should work.

You mean this ?

>>>> udelay(us)
>>>> {
>>>>    set cpu affinity to current CPU;
>>>>    Do the usual udelay code;
>>>>    restore cpu affinity status;
>>>> }

Things like lock scalability and performance degradations comes to my mind. We
can expect some drivers to make very heavy use of udelay(). This should not
bring a 4096-core box to its knees. sched_setaffinity() is very far from being
lightweight, as it locks cpu hotplug (that's a global mutex protecting a
refcount), allocates memory, manipulates cpumasks, etc...

>
> Does my better explained solution look palatable?

Nope, not on a multiprocessor system.

Thanks,

Mathieu



-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
