Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421Ab1LMK6l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 05:58:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51161 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754320Ab1LMK6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 05:58:40 -0500
Message-ID: <4EE72FCB.3070109@redhat.com>
Date: Tue, 13 Dec 2011 12:58:19 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sasha Levin <levinsasha928@gmail.com>
Subject: Re: [patch 0/3] kvm tool: Serial emulation overhaul
References: <20111210132220.083204833@linutronix.de> <alpine.LFD.2.02.1112101715500.10936@tux.localdomain> <alpine.LFD.2.02.1112102144370.3020@ionos> <alpine.LFD.2.02.1112111014500.1663@tux.localdomain> <20111211103047.GA19299@elte.hu> <alpine.LFD.2.02.1112111459270.3020@ionos> <20111211155347.GA1297@elte.hu> <CAOJsxLHTuN43AGA7C02MtETzJU87y9cRaWRg6e9ER7NxOK2w-Q@mail.gmail.com> <20111212172059.GC23870@elte.hu> <CAOJsxLFk9Af+b4PAx_j+1QhApBsFdXyZY1aK08fb_6_dTiBEDQ@mail.gmail.com> <20111212192135.GA18876@elte.hu> <alpine.LFD.2.02.1112130056370.3020@ionos>
In-Reply-To: <alpine.LFD.2.02.1112130056370.3020@ionos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2011 02:59 AM, Thomas Gleixner wrote:

<snip trace>
> Why the heck is a paravirtualized guest using an local APIC timer
> emulation, instead of a paravirtualized clock event device?
>
> Just look at the trace. That's insane. We enter the guest for 2us to
> come back and handle the APIC_EOI for 11us. Then we go back to the
> guest for 9us and spend again 11us for handling a write to APIC_TMICT.
>
> That's 11us guest vs. 22us host time.

Run your guest with x2apic enabled, the timing will be very different. 
You'll still have an exit for APIC_TMICT and APIC_EOI, but they'll be
much faster.  It's possible to avoid the EOI exit with some paravirt
magic, but that has its own issues.

> Aside of that, when looking at the bootup, the guest "calibrates" the
> local APIC timer emulation against an emulated legacy device to figure
> out the APIC timer clock rate, which is totally irrelevant for a
> paravirtualized guest, if done right.
>
> Look how a guest timer is programmed:
>
>      hrtimer_start();
>         ...
> 	clock_events_programm_event(dev, expires, now);
> 	  ns_delta = expires - now;
> 	  delta = convert_ns_to_dev(ns_delta, dev);
> 	  dev->set_next_event(delta, dev);
> 	    lapic_next_event(delta, dev);
> 	      apic_write(APIC_TMICT, delta);
> 	        |
> 		---> traps into host
>                   kvm_mmu_pagetable_walk();
>                   kvm_mmio_emulation();
>                     kvm_apic_emulation();
> 		      start_apic_timer();
> 		        now = get_host_time();
> 		        delta = convert_apic_to_ns(APIC_TMICT);
>                         hrtimer_start(apic_timer, now + delta, HRTIMER_MODE_ABS);
>
> Oh well, we 
>
>    - convert from nsec to a "calibrated" APIC delta
>    - "program" the APIC timer
>    - trap into the host
>    - convert the "calibrated" delta back to nsec
>    - add it to the current host time
>    - arm the timer
>
> Why the heck don't we use a paravirt device, which just provides a
> nsec based interface. The host knows the time delta between the guests
> notion of CLOCK_MONOTONIC and its own.

We do have a paravirt clocksource, just not clockevents.

>  That would reduce the whole
> procedure to:
>
>      hrtimer_start();
>         ...
> 	clock_events_programm_event(dev, expires, now);
> 	  dev->set_next_ktime(expires, dev);
> 	    kvm_clock_event_set_next(expires, dev);
> 	        |
> 		---> traps into host with a paravirt call
> 		kvm_handle_guest_clkev_dev();
>                   hrtimer_start(apic_timer, expires + host_guest_delta, HRTIMER_MODE_ABS);
>
> That would save tons of time on an hot path. Even if the
> host_guest_delta approach does not work, a 1:1 nsec mapping as a
> relative timer on the host would be way faster than the current
> solution.
>

The problem with paravirt clockevents is that if/when the APIC becomes
virtualized, then guests which were started with the paravirt
clockevents don't get accelerated when they are migrated onto newer
hardware.  This problem has bitten us several times in the past; if you
want to see how it looks when applied on a large scale look at Xen -
they have a paravirt-the-fsck-out-of-everything mode and a full virt
mode (which should be way faster these days); the two aren't
compatible.  Of course back when they started, they didn't have a
choice, but we do.

-- 
error compiling committee.c: too many arguments to function

