Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759372Ab0EMSvm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 14:51:42 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:35615 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755840Ab0EMSvl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 14:51:41 -0400
Subject: RE: Weird timer handler used with LAPIC selected
From: john stultz <johnstul@us.ibm.com>
To: limp <johnkyr83@hotmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <SNT111-DS6290E10B4DF4E25B7054FA7FC0@phx.gbl>
References: <SNT111-DS115B558E5855C0FAEA860CA7F60@phx.gbl>
	 <AANLkTin7itFVRzywm9g776bpE5IaFNsGVVW_PUbv0RKm@mail.gmail.com>
	 <SNT111-DS6290E10B4DF4E25B7054FA7FC0@phx.gbl>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 May 2010 11:51:34 -0700
Message-ID: <1273776694.2826.12.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-13 at 11:42 +0100, limp wrote:
> >> I have put some printks inside "local_apic_timer_interrupt" handler which
> >> should never be executed as the handler selected for the timer is
> >> "hrtimer_interrupt" and not "local_apic_timer_interrupt" as verified.
> >
> >Nope. Again, local_apic_timer_interrupt is the actual irq hook. It
> >then calls the lapic clockevent device's event_handler() method, which
> >is hrtimer_interrupt.
> 
> Hmm, I am quite sure that hrtimer_interrupt() event_handler is called from
> timer_interrupt() and not from local_apic_timer_interrupt()..

It can actually be called from both. From your earlier mail:
	Tick Device: mode:     1
	Per CPU device: 0
	Clock Event Device: lapic
	event_handler:  hrtimer_interrupt

That means when local_apic_timer_interrupt calls the lapic clockevent
device's event_handler() method, it will call hrtimer_interrupt.


> The reason for not getting any printks from the "local_apic_timer_interrupt"
> irq hook was because I was getting about 318-360 LOC (Local timer
> interrupts)
> - the number was varied at every system boot - and then they were stopped
> and the
> LOC number was not incremented!!!! I've put a printk in lapic_timer_setup
> and it
> seems that LAPIC was going to shutdown mode after a while. 
> 
> 01[14:43] <limp> ...
> 01[14:43] <limp> [    0.046999] LIMP: lapic_timer_setup: the mode used is 1
> 01[14:43] <limp> [    0.046999] LIMP: lapic_timer_setup: the mode used is 2
> 01[14:43] <limp> ...
> 01[14:43] <limp> [    0.699077] LIMP: lapic_timer_setup: the mode used is 1
> 
> This solved by disabling ACPI from the kernel command line. After that, I
> was
> Getting LOCs at HZ rate and irq0_timer were stalled at boot time after some
> initial ones (I guess there is no sense of getting LOCs and irq0_timer ticks
> simultaneously on a uniprocessor target).  

Right, depending on the system and the configuration, we try to not have
duplicate irqs landing on the same cpu. So either the irq0 will be
shutdown once the lapic is up, or the lapic will be stopped if we're in
broadcast mode.

> It seems that the system were entering a deep sleep state and was never
> waking
> up. Again, this seems a bit weird as the irq0 timer interrupt was still
> triggered
> periodically at HZ rate and should have not let ACPI to put LAPIC timer into
> sleep...

Right. So on this system, its likely the LAPIC halts in deep idle states
(normally C3). So there will be another tick device (hpet or pit
usually) which is configured in broadcast mode and will trigger
frequently to wake the specified idled cpus up. If you look at your
timer_list in detail it should provide some info to that effect.


> Another question is this: Is there a way to know when my target enters an
> ACPI
> power state? Also, is there a way to prevent my target for entering into
> power
> states, without having to disable the whole ACPI support (something like 
> acpi_sleep=false)? 

There's a couple of ways. idle=poll will keep the system from going into
deep sleep modes, but at the cost of burning energy when there's nothing
to do. You might read over the idle= options in
Documentation/kernel-parameters.txt

Good luck!

thanks
-john


