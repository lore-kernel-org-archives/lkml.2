Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756852Ab1FGRuw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 13:50:52 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:42925 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754063Ab1FGRuu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 13:50:50 -0400
Subject: Re: /proc/stat btime accuracy problem
From: john stultz <johnstul@us.ibm.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-serial@vger.kernel.org, Alan Cox <alan@linux.intel.com>
In-Reply-To: <BANLkTimGfwqvhOKXCGqJUvMU7jozqQT8=g@mail.gmail.com>
References: <BANLkTiniq6GVMJPO_-efKrWHQg9V9Dod9g@mail.gmail.com>
	 <1306967733.11492.11.camel@work-vm>
	 <BANLkTi=yEMDLEo99WZm2Bt4pi_pog5igww@mail.gmail.com>
	 <1306972711.11492.23.camel@work-vm>
	 <BANLkTimuPrqN1euyOqAGm2m4Ea1PdbrzDQ@mail.gmail.com>
	 <1306975745.11492.30.camel@work-vm>
	 <BANLkTikR4HNnFsYm2ymm1+FTbeeXtvH51g@mail.gmail.com>
	 <BANLkTimGfwqvhOKXCGqJUvMU7jozqQT8=g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Jun 2011 10:50:17 -0700
Message-ID: <1307469017.3163.37.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-06 at 23:20 -0600, Bjorn Helgaas wrote:
> I'm still spinning my wheels on this, so I guess the only thing left
> is to ask even more stupid questions :)
> 
> I'm only concerned about the early boot sequence, and I think only
> about the period when we're using the jiffies clocksource.  My
> understanding is:
> 
>   - I'm using the jiffies clocksource during early boot.
>   - Jiffies depends on a periodic (1000 HZ in my case) interrupt that
> updates xtime via the tick_periodic -> do_timer -> update_wall_time
> path.
Yep.

>   - If those periodic interrupts are lost, those xtime updates are forever lost.

Yep.

>   - An interrupt would be lost if interrupts are disabled for an
> interval that covers two or more ticks (my guess ... I'm thinking that
> if interrupts were re-enabled before the second tick, the first one
> would be delayed but not lost).

Yep.  There's also some possibly connected issues here to irq starvation
related to the irq priorities (so even if irqs were disabled, if the irq
is getting hammered, and that irq is higher priority then the tick, you
can lose ticks that way as well).

>   - The RTC runs independently of CPU interrupts being disabled, so
> its time is not lost.

Yep.

>   - User-space will typically reset xtime to match the RTC

Not really sure about this one. I think most systems will set the system
time via NTP and then after we're considered in-sync with ntpd we'll set
the RTC to system time every 11 minutes. 

But regardless, the issue that if we lose ticks, the btime won't seem to
be correct remains.

> And my sequence of events is:
> 
>   - xtime = RTC reading #1
>   - wall_to_monotonic = -xtime
>   - periodic tick increments xtime
>   -  some ticks are lost while interrupts are disabled
>   - by the time we switch from jiffies to hpet and eventually tsc
> clock source, the RTC is ahead of xtime by several seconds (1-2 in a
> normal boot, 30+ in more extreme cases)
>   - user-space resets xtime to RTC ("hwclock -hctosys" in my case),
> which adds the delta to xtime and subtracts it from wall_to_monotonic
>   - getboottime() returns -wall_to_monotonic (should be RTC reading
> #1, but now "reading #1 + delta")
> 
> It seems like we're throwing away information here at the time we
> switch from jiffies to a more capable clocksource -- at that point, we
> know the RTC - xtime delta, and we know that delta represents time
> when interrupts were disabled.  (Obviously this only applies during
> early boot, before we do any RTC updates.)

But I think you're focusing on trying to solve the symptom instead of
the problem. The really big issue here is that irqs are apparently being
disabled for 30 seconds at a time.

Sure, once a real clocksource is registered, maybe you don't see
timekeeping problems, but if the serial console gets more output, but
then you might see strange scheduling issues, or very late timers.
Further, you could hit other strange problems like OOM issues if you're
doing lots of RCU and the grace periods don't get to run.

Further, even if we did use the RTC to correct for lost ticks that
happened while using the jiffies clocksource, you have the fact that the
RTC resolution is so coarse, you couldn't account for lost ticks of less
then a second anyway (which I suspect is much more common then the 30
second intervals you're seeing).


> My naive thought was "well, what if we just use the RTC directly as a
> clocksource."  It's crappy resolution, but at least it doesn't lose
> time, so I tried the following, which didn't work at all (hangs during
> boot).  But I don't know enough to know *why* this isn't feasible.

It wouldn't be impossible to use the RTC as a clocksource (I think old
601 ppc macs use this). However, its not really a generic solution, as
systems have a number of different types of RTCs, some which go over i2c
buses or require interrupts in order to be read. read_persistent_clock
is safe, but it doesn't solve the issue for systems that don't provide a
read_persistent_clock hook.

> Seems like jiffies can be different sizes, so why not 1 Hz?

Hmm. That is interesting. I'm guessing it probably hits an edge case
where the timekeeping code expects there to be a non-zero shift value.
But again, I don't think this approach is going to solve all the issues
that might be caused by 30-seconds of irqs being off.


Maybe to get this back on coarse, could you provide some additional
details about the machine where you're seeing this? Is there one
specific driver that is putting out tons of output over the serial
console? Or is there anything unique about the serial port or its
settings (is it configured at 300 baud :)? What is the /proc/interrupts
count after boot on one of these systems?

thanks
-john

