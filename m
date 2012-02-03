Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757401Ab2BCRrM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 12:47:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7092 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755058Ab2BCRrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 12:47:08 -0500
Date: Fri, 3 Feb 2012 15:42:08 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Igor Mammedov <imammedo@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        kosaki.motohiro@jp.fujitsu.com, tj@kernel.org, x86@kernel.org,
        hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de,
        Rik van Riel <riel@redhat.com>, "avi@redhat.com" <avi@redhat.com>
Subject: Re: Need advice how to fix an access to uninitialized per_cpu clock
Message-ID: <20120203174208.GA4529@amt.cnet>
References: <4F2A76C4.2010601@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F2A76C4.2010601@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 02, 2012 at 12:43:00PM +0100, Igor Mammedov wrote:
> While playing with kvm cpu hot-plug, I've probably stumbled on general
> kernel bug. So I'm lookng for advice on approach to fix it.
> 
> When kvm guest uses kvmclock, it may hang on cpu hot-plug at
> 
>     BSP:
>      smp_apic_timer_interrupt
>        ...
>          -> do_timer
>            -> update_wall_time
> 
> and a being on-lined CPU at waiting on sync with BSP at:
>      start_secondary:
>        while (!cpumask_test_cpu(smp_processor_id(), cpu_active_mask))
>                     cpu_relax();
> 
> because of unusually big value returned by clock->read(clock) in
> update_wall_time.
> This happens due to overflow in pvclock_get_nsec_offset
> 
>         u64 delta = tsc - shadow->tsc_timestamp;
> 
> when shadow->tsc_timestamp is bigger than tsc.
> And since pvclock_clocksource_read remembers and returns largest
> value of any clock that ever was returned, clock for affected guest
> virtually freezes.
> 
> Overflow happens due to reading undefined values from uninitialized
> per_cpu variable hv_clock. In case of cpu hot-plug, clock is read at
> least once on being on-lined cpu before it is initialized for this
> cpu:
> 
>       start_secondary
>         |-> smp_callin
>         |  ->  smp_store_cpu_info
>         |    -> identify_secondary_cpu
>         |      -> mtrr_ap_init
>         |        -> mtrr_restore
>         |          -> stop_machine_from_inactive_cpu
>         |            -> queue_stop_cpus_work
>         |              ...
>         |                -> kvm_clock_read
>         |...
>         |x86_cpuinit.setup_percpu_clockev
> 
> full call chain is below:
> [    0.002999]  [<ffffffff8102fc74>] pvclock_clocksource_read+0x9f/0x275
> [    0.002999]  [<ffffffff81071f9e>] ? check_preempt_wakeup+0x11c/0x1c2
> [    0.002999]  [<ffffffff8102f05d>] kvm_clock_read+0x21/0xd3
> [    0.002999]  [<ffffffff810154b1>] sched_clock+0x9/0xd
> [    0.002999]  [<ffffffff81070509>] sched_clock_local+0x12/0x75
> [    0.002999]  [<ffffffff8107065e>] sched_clock_cpu+0x84/0xc6
> [    0.002999]  [<ffffffff8106bfd3>] update_rq_clock+0x28/0x108
> [    0.002999]  [<ffffffff8106c15e>] enqueue_task+0x1d/0x64
> [    0.002999]  [<ffffffff8106c500>] activate_task+0x22/0x24
> [    0.002999]  [<ffffffff8106c90c>] ttwu_do_activate.constprop.39+0x32/0x61
> [    0.002999]  [<ffffffff8106cd0c>] try_to_wake_up+0x17e/0x1e1
> [    0.002999]  [<ffffffff8106cd98>] wake_up_process+0x15/0x17
> [    0.002999]  [<ffffffff8109ebbf>] cpu_stop_queue_work+0x3d/0x5f
> [    0.002999]  [<ffffffff8109ec6c>] queue_stop_cpus_work+0x8b/0xb6
> [    0.002999]  [<ffffffff8109f0e3>] stop_machine_from_inactive_cpu+0xb4/0xed
> [    0.002999]  [<ffffffff81023896>] ? mtrr_restore+0x4a/0x4a
> [    0.002999]  [<ffffffff81023eb3>] mtrr_ap_init+0x5a/0x5c
> [    0.002999]  [<ffffffff814b95f7>] identify_secondary_cpu+0x19/0x1b
> [    0.002999]  [<ffffffff814bc0d3>] smp_store_cpu_info+0x3c/0x3e
> [    0.002999]  [<ffffffff814bc4ed>] start_secondary+0x122/0x263
> 
> Looking at native_smp_prepare_cpus in arch/x86/kernel/smpboot.c
> I see that it unconditionally calls set_mtrr_aps_delayed_init which
> in turn effectively converts calls to mtrr_ap_init to nop ops.
> And later call to native_smp_cpus_done -> mtrr_aps_init completes
> mtrr initialization.
> 
> The same pattern might be noticed in suspend/hibernate handlers, that
> call enable_nonboot_cpus.
> 
>   enable_nonboot_cpus
>     -> arch_enable_nonboot_cpus_begin
>          -> set_mtrr_aps_delayed_init
> 
>     -> boot secondary cpus
> 
>     -> arch_enable_nonboot_cpus_end
>          -> mtrr_aps_init
> 
> So question is if the calling mtrr_ap_init so early in
> identify_secondary_cpu is really necessary?
> From current code it looks like it is never called at normal smp
> boot/resume time. And only path that triggers it is cpu hot-plug one.
> 
> I see following possible solutions:
> 
> 1. Could the call to mtrr_ap_init be just moved from identify_secondary_cpu
> to start_secondary right after x86_cpuinit.setup_percpu_clockev call?
>
> This will prevent an access to uninitialized per_cpu clock. Or move
> x86_cpuinit.setup_percpu_clockev before smp_callin?
> 
> 2. Another way to prevent access to uninitialized per_cpu clock is to
> introduce hook.early_percpu_clock_init that will be called before
> smp_callin or right before mtrr_ap_init.
> 
> I hope to see opinions about this matter from a more experienced people than me.

It would be more robust to introduce x86_cpuinit.early_percpu_clock_init
and use it for KVM, replacing setup_percpu_clockev hook.

setup_percpu_clockev initializes the APIC timer, but clearly sched_clock
should be functional before that, for example for ftrace (in addition to
sched_clock from scheduler as in the trace above).

