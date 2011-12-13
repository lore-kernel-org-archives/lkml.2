Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664Ab1LMA7i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 19:59:38 -0500
Received: from www.linutronix.de ([62.245.132.108]:55707 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753890Ab1LMA7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 19:59:36 -0500
Date: Tue, 13 Dec 2011 01:59:30 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@elte.hu>
cc: Pekka Enberg <penberg@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Sasha Levin <levinsasha928@gmail.com>
Subject: Re: [patch 0/3] kvm tool: Serial emulation overhaul
In-Reply-To: <20111212192135.GA18876@elte.hu>
Message-ID: <alpine.LFD.2.02.1112130056370.3020@ionos>
References: <20111210132220.083204833@linutronix.de> <alpine.LFD.2.02.1112101715500.10936@tux.localdomain> <alpine.LFD.2.02.1112102144370.3020@ionos> <alpine.LFD.2.02.1112111014500.1663@tux.localdomain> <20111211103047.GA19299@elte.hu>
 <alpine.LFD.2.02.1112111459270.3020@ionos> <20111211155347.GA1297@elte.hu> <CAOJsxLHTuN43AGA7C02MtETzJU87y9cRaWRg6e9ER7NxOK2w-Q@mail.gmail.com> <20111212172059.GC23870@elte.hu> <CAOJsxLFk9Af+b4PAx_j+1QhApBsFdXyZY1aK08fb_6_dTiBEDQ@mail.gmail.com>
 <20111212192135.GA18876@elte.hu>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Dec 2011, Ingo Molnar wrote:
> * Pekka Enberg <penberg@kernel.org> wrote:
> 
> > So i'm pretty sure it's some bug in hw/serial.c that's 
> > limiting character output by interrupts.

No, that's not a bug. The current emulation has no fifo and it writes
every single character to the terminal. Go figure. The timer
limitation is due to the missing fifo and other details, which would
drive the serial driver into the "too much work for irq 4" case.

The approach I took was to keep the emulated device as close to the
real HW for obvious reasons. You simply cannot ignore the way how a HW
device works and how the corresponding kernel driver expects it to
work.

> Serial port control flow somehow being bound by timer frequency 
> [which is not really a necessity: both the host and the guest 
> could stream on full speed] was too my observation early on.

That simply does not work with the way the serial driver for the 8250
is written.

If you emulate hardware then don't expect that the shortcomings of the
real hardware and the clusterf*ck in the corresponding device drivers
go magically away.

If you want high performance virtualization then use virtual drivers
and stop whining about a 30 years old legacy device and its warts.

There is way bigger fish to fry in that virt stuff, which is more
important and way simpler to fix.

I just stumbled over this:

<idle>-0     [017] 316004.317563: hrtimer_cancel: hrtimer=ffff880130ad8610
<idle>-0     [017] 316004.317563: hrtimer_expire_entry: hrtimer=ffff880130ad8610 function=kvm_timer_fn now=316147662509905
<idle>-0     [017] 316004.317565: sched_wakeup: comm=qemu-system-x86 pid=77375 prio=19 success=1 target_cpu=017
<idle>-0     [017] 316004.317566: hrtimer_expire_exit: hrtimer=ffff880130ad8610
<idle>-0     [017] 316004.317567: power_end: cpu_id=17
<idle>-0     [017] 316004.317567: cpu_idle: state=4294967295 cpu_id=17
<idle>-0     [017] 316004.317568: sched_switch: prev_comm=swapper/17 prev_pid=0 prev_prio=120 prev_state=R ==> next_comm=qemu-system-x86 next_pid=77375 next_prio=19
 <...>-77375 [017] 316004.317570: hrtimer_cancel: hrtimer=ffff880125e67660
 <...>-77375 [017] 316004.317571: kvm_apic_accept_irq: apicid 1 vec 239 (Fixed|edge)
 <...>-77375 [017] 316004.317572: hrtimer_start: hrtimer=ffff880125e67660 function=kvm_idle_watchdog expires=316147712519668 softexpires=316147712519668
 <...>-77375 [017] 316004.317574: hrtimer_cancel: hrtimer=ffff880125e67660
 <...>-77375 [017] 316004.317575: kvm_inj_virq: irq 239
 <...>-77375 [017] 316004.317577: kvm_entry: vcpu 1
 <...>-77375 [017] 316004.317579: kvm_exit: reason APIC_ACCESS rip 0xffffffff8104d1cc info 10b0 0
 <...>-77375 [017] 316004.317581: kvm_mmu_pagetable_walk: addr ffffffff8104d1cc pferr 10 F
 <...>-77375 [017] 316004.317582: kvm_mmu_paging_element: pte 1c09067 level 4
 <...>-77375 [017] 316004.317582: kvm_mmu_paging_element: pte 1c0d063 level 3
 <...>-77375 [017] 316004.317583: kvm_mmu_paging_element: pte 10001e1 level 2
 <...>-77375 [017] 316004.317584: kvm_emulate_insn: 0:ffffffff8104d1cc: 89 b7 00 b0 5f ff (prot64)
 <...>-77375 [017] 316004.317585: kvm_mmu_pagetable_walk: addr ffffffffff5fb0b0 pferr 2 W
 <...>-77375 [017] 316004.317585: kvm_mmu_paging_element: pte 1c09067 level 4
 <...>-77375 [017] 316004.317586: kvm_mmu_paging_element: pte 1c0a067 level 3
 <...>-77375 [017] 316004.317586: kvm_mmu_paging_element: pte 1eae067 level 2
 <...>-77375 [017] 316004.317587: kvm_mmu_paging_element: pte 80000000fee0017b level 1
 <...>-77375 [017] 316004.317588: kvm_mmio: mmio write len 4 gpa 0xfee000b0 val 0x0
 <...>-77375 [017] 316004.317588: kvm_apic: apic_write APIC_EOI = 0x0
 <...>-77375 [017] 316004.317590: kvm_entry: vcpu 1
 <...>-77375 [017] 316004.317599: kvm_exit: reason APIC_ACCESS rip 0xffffffff8104d1cc info 1380 0
 <...>-77375 [017] 316004.317600: kvm_mmu_pagetable_walk: addr ffffffff8104d1cc pferr 10 F
 <...>-77375 [017] 316004.317601: kvm_mmu_paging_element: pte 1c09067 level 4
 <...>-77375 [017] 316004.317602: kvm_mmu_paging_element: pte 1c0d063 level 3
 <...>-77375 [017] 316004.317602: kvm_mmu_paging_element: pte 10001e1 level 2
 <...>-77375 [017] 316004.317603: kvm_emulate_insn: 0:ffffffff8104d1cc: 89 b7 00 b0 5f ff (prot64)
 <...>-77375 [017] 316004.317604: kvm_mmu_pagetable_walk: addr ffffffffff5fb380 pferr 2 W
 <...>-77375 [017] 316004.317604: kvm_mmu_paging_element: pte 1c09067 level 4
 <...>-77375 [017] 316004.317605: kvm_mmu_paging_element: pte 1c0a067 level 3
 <...>-77375 [017] 316004.317605: kvm_mmu_paging_element: pte 1eae067 level 2
 <...>-77375 [017] 316004.317605: kvm_mmu_paging_element: pte 80000000fee0017b level 1
 <...>-77375 [017] 316004.317606: kvm_mmio: mmio write len 4 gpa 0xfee00380 val 0x1798
 <...>-77375 [017] 316004.317606: kvm_apic: apic_write APIC_TMICT = 0x1798
 <...>-77375 [017] 316004.317607: hrtimer_start: hrtimer=ffff880130ad8610 function=kvm_timer_fn expires=316147662651030 softexpires=316147662651030
 <...>-77375 [017] 316004.317610: kvm_entry: vcpu 1
 <...>-77375 [017] 316004.317621: kvm_exit: reason HLT rip 0xffffffff81052214 info 0 0
 <...>-77375 [017] 316004.317626: sched_switch: prev_comm=qemu-system-x86 prev_pid=77375 prev_prio=19 prev_state=S ==> next_comm=swapper/17 next_pid=0 next_prio=120
<idle>-0     [017] 316004.317627: power_start: type=1 state=0 cpu_id=17

Why the heck is a paravirtualized guest using an local APIC timer
emulation, instead of a paravirtualized clock event device?

Just look at the trace. That's insane. We enter the guest for 2us to
come back and handle the APIC_EOI for 11us. Then we go back to the
guest for 9us and spend again 11us for handling a write to APIC_TMICT.

That's 11us guest vs. 22us host time.

Aside of that, when looking at the bootup, the guest "calibrates" the
local APIC timer emulation against an emulated legacy device to figure
out the APIC timer clock rate, which is totally irrelevant for a
paravirtualized guest, if done right.

Look how a guest timer is programmed:

     hrtimer_start();
        ...
	clock_events_programm_event(dev, expires, now);
	  ns_delta = expires - now;
	  delta = convert_ns_to_dev(ns_delta, dev);
	  dev->set_next_event(delta, dev);
	    lapic_next_event(delta, dev);
	      apic_write(APIC_TMICT, delta);
	        |
		---> traps into host
                  kvm_mmu_pagetable_walk();
                  kvm_mmio_emulation();
                    kvm_apic_emulation();
		      start_apic_timer();
		        now = get_host_time();
		        delta = convert_apic_to_ns(APIC_TMICT);
                        hrtimer_start(apic_timer, now + delta, HRTIMER_MODE_ABS);

Oh well, we 

   - convert from nsec to a "calibrated" APIC delta
   - "program" the APIC timer
   - trap into the host
   - convert the "calibrated" delta back to nsec
   - add it to the current host time
   - arm the timer

Why the heck don't we use a paravirt device, which just provides a
nsec based interface. The host knows the time delta between the guests
notion of CLOCK_MONOTONIC and its own. That would reduce the whole
procedure to:

     hrtimer_start();
        ...
	clock_events_programm_event(dev, expires, now);
	  dev->set_next_ktime(expires, dev);
	    kvm_clock_event_set_next(expires, dev);
	        |
		---> traps into host with a paravirt call
		kvm_handle_guest_clkev_dev();
                  hrtimer_start(apic_timer, expires + host_guest_delta, HRTIMER_MODE_ABS);

That would save tons of time on an hot path. Even if the
host_guest_delta approach does not work, a 1:1 nsec mapping as a
relative timer on the host would be way faster than the current
solution.

Thanks,

	tglx
