Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061Ab2IQIrR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 04:47:17 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:37507 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754032Ab2IQIrM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 04:47:12 -0400
MIME-Version: 1.0
In-Reply-To: <201209170118.25955.andres@anarazel.de>
References: <201209170118.25955.andres@anarazel.de>
Date: Mon, 17 Sep 2012 04:47:10 -0400
Message-ID: <CAH3drwZ-Wc=PViwuj=PgcOrsZBfvozdZRK=Q2Q-uJFktSbGQcw@mail.gmail.com>
Subject: Re: Excessive kernel time inside ttm when scrolling on a r700 in a
 multimonitor setup
From: Jerome Glisse <j.glisse@gmail.com>
To: Andres Freund <andres@anarazel.de>
Cc: LKML <linux-kernel@vger.kernel.org>, David Airlie <airlied@linux.ie>,
        Jerome Glisse <jglisse@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 16, 2012 at 7:18 PM, Andres Freund <andres@anarazel.de> wrote:
> Hi everyone,
>
> In several gui programs, most notably and reproducably, I can trivially make
> Xorg spend the whole cpu time in the kernel. It might be an Xorg bug, but
> from my untrained gut feeling it doesn't look that way.
>
> Anything more you need than whats already in the email?
>
> Here are some details:

Is it an AGP card ? It looks like it's the PAT update that kills perf
for you, not much we can do, the pool allocator is probably starve.

Cheers,
Jerome

> 08:00.0 VGA compatible controller: Advanced Micro Devices [AMD] nee ATI Barts XT [Radeon HD 6800 Series] (prog-if 00 [VGA controller])
>         Subsystem: PC Partner Limited Device 174b
>         Flags: bus master, fast devsel, latency 0, IRQ 76
>         Memory at d0000000 (64-bit, prefetchable) [size=256M]
>         Memory at fbec0000 (64-bit, non-prefetchable) [size=128K]
>         I/O ports at e000 [size=256]
>         Expansion ROM at fbea0000 [disabled] [size=128K]
>         Capabilities: [50] Power Management version 3
>         Capabilities: [58] Express Legacy Endpoint, MSI 00
>         Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit+
>         Capabilities: [100] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>
>         Capabilities: [150] Advanced Error Reporting
>         Kernel driver in use: radeon
>
> Perf HW Details:
>
> # ========
> # captured on: Mon Sep 17 00:58:11 2012
> # hostname : awork2
> # os release : 3.6.0-rc4-andres-00001-ga7ab0ca
> # perf version : 3.5.7078.gf7da9c
> # arch : x86_64
> # nrcpus online : 16
> # nrcpus avail : 16
> # cpudesc : Intel(R) Xeon(R) CPU E5520 @ 2.27GHz
> # cpuid : GenuineIntel,6,26,5
> # total memory : 24676596 kB
> # cmdline : /home/andres/bin/perf record -ag
> # event : name = cycles, type = 0, config = 0x0, config1 = 0x0, config2 = 0x0, excl_usr = 0, excl_kern = 0, id = { 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80 }
> # sibling cores   : 0-3,8-11
> # sibling cores   : 4-7,12-15
> # sibling threads : 0,8
> # sibling threads : 1,9
> # sibling threads : 2,10
> # sibling threads : 3,11
> # sibling threads : 4,12
> # sibling threads : 5,13
> # sibling threads : 6,14
> # sibling threads : 7,15
> # node0 meminfo  : total = 12573680 kB, free = 5583760 kB
> # node0 cpu list : 0-3,8-11
> # node1 meminfo  : total = 12582912 kB, free = 9097668 kB
> # node1 cpu list : 4-7,12-15
>
> This is on debian unstable with their xserver et al.
>
> $ apt-cache policy xserver-xorg-core|grep Installed
>   Installed: 2:1.12.3.902-1
>
> $ apt-cache policy xserver-xorg-video-radeon|grep Installed
>   Installed: 1:6.14.4-5
>
> Note that I profiled this on a 3 monitor setup:
> $ xrandr|grep -E 'Screen|connected'
> Screen 0: minimum 320 x 200, current 4960 x 1920, maximum 16384 x 16384
> DVI-1 connected 2560x1600+1200+0 (normal left inverted right x axis y axis) 641mm x 401mm
> DisplayPort-0 connected 1200x1920+0+0 left (normal left inverted right x axis y axis) 518mm x 324mm
> HDMI-0 disconnected (normal left inverted right x axis y axis)
> DVI-0 connected 1200x1920+3760+0 left (normal left inverted right x axis y axis) 518mm x 324mm
>
>
> The profile:
>
> # Overhead          Command                    Shared Object                                                                                                                                                                                                               Symbol
> # ........  ...............  ...............................  ...................................................................................................................................................................................................................
> #
>     42.27%             Xorg  [kernel.kallsyms]                [k] default_send_IPI_mask_allbutself_phys
>                        |
>                        --- default_send_IPI_mask_allbutself_phys
>                           |
>                           |--100.00%-- physflat_send_IPI_allbutself
>                           |          native_send_call_func_ipi
>                           |          smp_call_function_many
>                           |          smp_call_function
>                           |          on_each_cpu
>                           |          |
>                           |          |--99.97%-- change_page_attr_set_clr
>                           |          |          _set_pages_array
>                           |          |          set_pages_array_wc
>                           |          |          ttm_set_pages_caching
>                           |          |          ttm_dma_populate
>                           |          |          radeon_ttm_tt_populate
>                           |          |          ttm_tt_bind
>                           |          |          ttm_bo_handle_move_mem
>                           |          |          ttm_bo_evict
>                           |          |          ttm_mem_evict_first
>                           |          |          ttm_bo_mem_space
>                           |          |          ttm_bo_move_buffer
>                           |          |          ttm_bo_validate
>                           |          |          |
>                           |          |          |--55.15%-- radeon_bo_list_validate
>                           |          |          |          radeon_cs_parser_relocs
>                           |          |          |          radeon_cs_ioctl
>                           |          |          |          drm_ioctl
>                           |          |          |          do_vfs_ioctl
>                           |          |          |          sys_ioctl
>                           |          |          |          system_call_fastpath
>                           |          |          |          __GI___ioctl
>                           |          |          |          0x7fff79e10b60
>                           |          |          |
>                           |          |           --44.85%-- ttm_bo_init
>                           |          |                     radeon_bo_create
>                           |          |                     radeon_gem_object_create
>                           |          |                     radeon_gem_create_ioctl
>                           |          |                     drm_ioctl
>                           |          |                     do_vfs_ioctl
>                           |          |                     sys_ioctl
>                           |          |                     system_call_fastpath
>                           |          |                     __GI___ioctl
>                           |          |                     0x0
>                           |           --0.03%-- [...]
>                            --0.00%-- [...]
>     19.77%          swapper  [kernel.kallsyms]                [k] read_hpet
>                     |
>                     --- read_hpet
>                        |
>                        |--55.44%-- ktime_get
>                        |          |
>                        |          |--42.84%-- tick_check_idle
>                        |          |          irq_enter
>                        |          |          |
>                        |          |          |--97.87%-- smp_call_function_interrupt
>                        |          |          |          call_function_interrupt
>                        |          |          |          |
>                        |          |          |          |--99.97%-- cpuidle_enter
>                        |          |          |          |          cpuidle_idle_call
>                        |          |          |          |          cpu_idle
>                        |          |          |          |          |
>                        |          |          |          |          |--96.83%-- start_secondary
>                        |          |          |          |          |
>                        |          |          |          |           --3.17%-- rest_init
>                        |          |          |          |                     start_kernel
>                        |          |          |          |                     x86_64_start_reservations
>                        |          |          |          |                     x86_64_start_kernel
>                        |          |          |           --0.03%-- [...]
>                        |          |          |
>                        |          |          |--0.92%-- scheduler_ipi
>                        |          |          |          smp_reschedule_interrupt
>                        |          |          |          reschedule_interrupt
>                        |          |          |          cpuidle_enter
>                        |          |          |          cpuidle_idle_call
>                        |          |          |          cpu_idle
>                        |          |          |          |
>                        |          |          |          |--81.42%-- start_secondary
>                        |          |          |          |
>                        |          |          |           --18.58%-- rest_init
>                        |          |          |                     start_kernel
>                        |          |          |                     x86_64_start_reservations
>                        |          |          |                     x86_64_start_kernel
>                        |          |          |
>                        |          |          |--0.67%-- smp_apic_timer_interrupt
>                        |          |          |          apic_timer_interrupt
>                        |          |          |          |
>                        |          |          |          |--99.64%-- cpuidle_enter
>                        |          |          |          |          cpuidle_idle_call
>                        |          |          |          |          cpu_idle
>                        |          |          |          |          start_secondary
>                        |          |          |           --0.36%-- [...]
>                        |          |          |
>                        |          |          |--0.54%-- do_IRQ
>                        |          |          |          ret_from_intr
>                        |          |          |          |
>                        |          |          |          |--96.93%-- cpuidle_enter
>                        |          |          |          |          cpuidle_idle_call
>                        |          |          |          |          cpu_idle
>                        |          |          |          |          rest_init
>                        |          |          |          |          start_kernel
>                        |          |          |          |          x86_64_start_reservations
>                        |          |          |          |          x86_64_start_kernel
>                        |          |          |          |
>                        |          |          |           --3.07%-- rest_init
>                        |          |          |                     start_kernel
>                        |          |          |                     x86_64_start_reservations
>                        |          |          |                     x86_64_start_kernel
>                        |          |           --0.01%-- [...]
>                        |          |
>                        |          |--37.64%-- __tick_nohz_idle_enter
>                        |          |          |
>                        |          |          |--97.66%-- tick_nohz_irq_exit
>                        |          |          |          irq_exit
>                        |          |          |          |
>                        |          |          |          |--98.26%-- smp_call_function_interrupt
>                        |          |          |          |          call_function_interrupt
>                        |          |          |          |          |
>                        |          |          |          |          |--99.90%-- cpuidle_enter
>                        |          |          |          |          |          cpuidle_idle_call
>                        |          |          |          |          |          cpu_idle
>                        |          |          |          |          |          |
>                        |          |          |          |          |          |--96.37%-- start_secondary
>                        |          |          |          |          |          |
>                        |          |          |          |          |           --3.63%-- rest_init
>                        |          |          |          |          |                     start_kernel
>                        |          |          |          |          |                     x86_64_start_reservations
>                        |          |          |          |          |                     x86_64_start_kernel
>                        |          |          |          |           --0.10%-- [...]
>                        |          |          |          |
>                        |          |          |          |--1.30%-- scheduler_ipi
>                        |          |          |          |          smp_reschedule_interrupt
>                        |          |          |          |          reschedule_interrupt
>                        |          |          |          |          cpuidle_enter
>                        |          |          |          |          cpuidle_idle_call
>                        |          |          |          |          cpu_idle
>                        |          |          |          |          |
>                        |          |          |          |          |--72.51%-- start_secondary
>                        |          |          |          |          |
>                        |          |          |          |           --27.49%-- rest_init
>                        |          |          |          |                     start_kernel
>                        |          |          |          |                     x86_64_start_reservations
>                        |          |          |          |                     x86_64_start_kernel
>                        |          |          |           --0.44%-- [...]
>                        |          |          |
>                        |          |           --2.34%-- tick_nohz_idle_enter
>                        |          |                     cpu_idle
>                        |          |                     |
>                        |          |                     |--80.43%-- start_secondary
>                        |          |                     |
>                        |          |                      --19.57%-- rest_init
>                        |          |                                start_kernel
>                        |          |                                x86_64_start_reservations
>                        |          |                                x86_64_start_kernel
>                        |          |
>                        |          |--18.88%-- clockevents_program_event
>                        |          |          |
>                        |          |          |--97.54%-- tick_program_event
>                        |          |          |          |
>                        |          |          |          |--91.60%-- tick_broadcast_oneshot_control
>                        |          |          |          |          tick_notify
>                        |          |          |          |          notifier_call_chain
>                        |          |          |          |          __raw_notifier_call_chain
>                        |          |          |          |          raw_notifier_call_chain
>                        |          |          |          |          clockevents_notify
>                        |          |          |          |          intel_idle
>                        |          |          |          |          cpuidle_enter
>                        |          |          |          |          cpuidle_idle_call
>                        |          |          |          |          cpu_idle
>                        |          |          |          |          |
>                        |          |          |          |          |--95.69%-- start_secondary
>                        |          |          |          |          |
>                        |          |          |          |           --4.31%-- rest_init
>                        |          |          |          |                     start_kernel
>                        |          |          |          |                     x86_64_start_reservations
>                        |          |          |          |                     x86_64_start_kernel
>                        |          |          |          |
>                        |          |          |          |--3.75%-- hrtimer_force_reprogram
>                        |          |          |          |          __remove_hrtimer
>                        |          |          |          |          |
>                        |          |          |          |          |--81.61%-- __hrtimer_start_range_ns
>                        |          |          |          |          |          hrtimer_start
>                        |          |          |          |          |          __tick_nohz_idle_enter
>                        |          |          |          |          |          |
>                        |          |          |          |          |          |--97.88%-- tick_nohz_idle_enter
>                        |          |          |          |          |          |          cpu_idle
>                        |          |          |          |          |          |          |
>                        |          |          |          |          |          |          |--90.49%-- start_secondary
>                        |          |          |          |          |          |          |
>                        |          |          |          |          |          |           --9.51%-- rest_init
>                        |          |          |          |          |          |                     start_kernel
>                        |          |          |          |          |          |                     x86_64_start_reservations
>                        |          |          |          |          |          |                     x86_64_start_kernel
>                        |          |          |          |          |          |
>                        |          |          |          |          |           --2.12%-- tick_nohz_irq_exit
>                        |          |          |          |          |                     irq_exit
>                        |          |          |          |          |                     smp_apic_timer_interrupt
>                        |          |          |          |          |                     apic_timer_interrupt
>                        |          |          |          |          |                     cpuidle_enter
>                        |          |          |          |          |                     cpuidle_idle_call
>                        |          |          |          |          |                     cpu_idle
>                        |          |          |          |          |                     start_secondary
>                        |          |          |          |          |
>                        |          |          |          |           --18.39%-- hrtimer_try_to_cancel
>                        |          |          |          |                     hrtimer_cancel
>                        |          |          |          |                     tick_nohz_idle_exit
>                        |          |          |          |                     cpu_idle
>                        |          |          |          |                     |
>                        |          |          |          |                     |--79.37%-- start_secondary
>                        |          |          |          |                     |
>                        |          |          |          |                      --20.63%-- rest_init
>                        |          |          |          |                                start_kernel
>                        |          |          |          |                                x86_64_start_reservations
>                        |          |          |          |                                x86_64_start_kernel
>                        |          |          |          |
>                        |          |          |          |--2.50%-- __hrtimer_start_range_ns
>                        |          |          |          |          |
>                        |          |          |          |          |--97.44%-- hrtimer_start_range_ns
>                        |          |          |          |          |          tick_nohz_idle_exit
>                        |          |          |          |          |          cpu_idle
>                        |          |          |          |          |          |
>                        |          |          |          |          |          |--88.11%-- start_secondary
>                        |          |          |          |          |          |
>                        |          |          |          |          |           --11.89%-- rest_init
>                        |          |          |          |          |                     start_kernel
>                        |          |          |          |          |                     x86_64_start_reservations
>                        |          |          |          |          |                     x86_64_start_kernel
>                        |          |          |          |          |
>                        |          |          |          |           --2.56%-- hrtimer_start
>                        |          |          |          |                     __tick_nohz_idle_enter
>                        |          |          |          |                     tick_nohz_idle_enter
>                        |          |          |          |                     cpu_idle
>                        |          |          |          |                     |
>                        |          |          |          |                     |--71.51%-- rest_init
>                        |          |          |          |                     |          start_kernel
>                        |          |          |          |                     |          x86_64_start_reservations
>                        |          |          |          |                     |          x86_64_start_kernel
>                        |          |          |          |                     |
>                        |          |          |          |                      --28.49%-- start_secondary
>                        |          |          |          |
>                        |          |          |           --2.16%-- hrtimer_interrupt
>                        |          |          |                     |
>                        |          |          |                     |--94.36%-- smp_apic_timer_interrupt
>                        |          |          |                     |          apic_timer_interrupt
>                        |          |          |                     |          |
>                        |          |          |                     |          |--98.67%-- cpuidle_enter
>                        |          |          |                     |          |          cpuidle_idle_call
>                        |          |          |                     |          |          cpu_idle
>                        |          |          |                     |          |          |
>                        |          |          |                     |          |          |--98.84%-- start_secondary
>                        |          |          |                     |          |          |
>                        |          |          |                     |          |           --1.16%-- rest_init
>                        |          |          |                     |          |                     start_kernel
>                        |          |          |                     |          |                     x86_64_start_reservations
>                        |          |          |                     |          |                     x86_64_start_kernel
>                        |          |          |                     |          |
>                        |          |          |                     |           --1.33%-- call_softirq
>                        |          |          |                     |                     do_softirq
>                        |          |          |                     |                     irq_exit
>                        |          |          |                     |                     scheduler_ipi
>                        |          |          |                     |                     smp_reschedule_interrupt
>                        |          |          |                     |                     reschedule_interrupt
>                        |          |          |                     |                     cpuidle_enter
>                        |          |          |                     |                     cpuidle_idle_call
>                        |          |          |                     |                     cpu_idle
>                        |          |          |                     |                     start_secondary
>                        |          |          |                     |
>                        |          |          |                      --5.64%-- tick_do_broadcast.constprop.3
>                        |          |          |                                tick_handle_oneshot_broadcast
>                        |          |          |                                timer_interrupt
>                        |          |          |                                handle_irq_event_percpu
>                        |          |          |                                handle_irq_event
>                        |          |          |                                handle_edge_irq
>                        |          |          |                                handle_irq
>                        |          |          |                                do_IRQ
>                        |          |          |                                ret_from_intr
>                        |          |          |                                cpuidle_enter
>                        |          |          |                                cpuidle_idle_call
>                        |          |          |                                cpu_idle
>                        |          |          |                                rest_init
>                        |          |          |                                start_kernel
>                        |          |          |                                x86_64_start_reservations
>                        |          |          |                                x86_64_start_kernel
>                        |          |          |
>                        |          |           --2.46%-- tick_broadcast_set_event
>                        |          |                     |
>                        |          |                     |--79.48%-- tick_handle_oneshot_broadcast
>                        |          |                     |          timer_interrupt
>                        |          |                     |          handle_irq_event_percpu
>                        |          |                     |          handle_irq_event
>                        |          |                     |          handle_edge_irq
>                        |          |                     |          handle_irq
>                        |          |                     |          do_IRQ
>                        |          |                     |          ret_from_intr
>                        |          |                     |          |
>                        |          |                     |          |--99.51%-- cpuidle_enter
>                        |          |                     |          |          cpuidle_idle_call
>                        |          |                     |          |          cpu_idle
>                        |          |                     |          |          rest_init
>                        |          |                     |          |          start_kernel
>                        |          |                     |          |          x86_64_start_reservations
>                        |          |                     |          |          x86_64_start_kernel
>                        |          |                     |           --0.49%-- [...]
>                        |          |                     |
>                        |          |                      --20.52%-- tick_broadcast_oneshot_control
>                        |          |                                tick_notify
>                        |          |                                notifier_call_chain
>                        |          |                                __raw_notifier_call_chain
>                        |          |                                raw_notifier_call_chain
>                        |          |                                clockevents_notify
>                        |          |                                intel_idle
>                        |          |                                cpuidle_enter
>                        |          |                                cpuidle_idle_call
>                        |          |                                cpu_idle
>                        |          |                                |
>                        |          |                                |--86.53%-- start_secondary
>                        |          |                                |
>                        |          |                                 --13.47%-- rest_init
>                        |          |                                           start_kernel
>                        |          |                                           x86_64_start_reservations
>                        |          |                                           x86_64_start_kernel
>                        |           --0.64%-- [...]
>                        |
>                        |--44.04%-- getnstimeofday
>                        |          ktime_get_real
>                        |          |
>                        |          |--99.99%-- intel_idle
>                        |          |          cpuidle_enter
>                        |          |          cpuidle_idle_call
>                        |          |          cpu_idle
>                        |          |          |
>                        |          |          |--95.13%-- start_secondary
>                        |          |          |
>                        |          |           --4.87%-- rest_init
>                        |          |                     start_kernel
>                        |          |                     x86_64_start_reservations
>                        |          |                     x86_64_start_kernel
>                        |           --0.01%-- [...]
>                         --0.52%-- [...]
>      7.83%             Xorg  [kernel.kallsyms]                [k] smp_call_function_many
>                        |
>                        --- smp_call_function_many
>                           |
>                           |--99.99%-- smp_call_function
>                           |          on_each_cpu
>                           |          |
>                           |          |--99.98%-- change_page_attr_set_clr
>                           |          |          _set_pages_array
>                           |          |          set_pages_array_wc
>                           |          |          ttm_set_pages_caching
>                           |          |          ttm_dma_populate
>                           |          |          radeon_ttm_tt_populate
>                           |          |          ttm_tt_bind
>                           |          |          ttm_bo_handle_move_mem
>                           |          |          ttm_bo_evict
>                           |          |          ttm_mem_evict_first
>                           |          |          ttm_bo_mem_space
>                           |          |          ttm_bo_move_buffer
>                           |          |          ttm_bo_validate
>                           |          |          |
>                           |          |          |--53.06%-- ttm_bo_init
>                           |          |          |          radeon_bo_create
>                           |          |          |          radeon_gem_object_create
>                           |          |          |          radeon_gem_create_ioctl
>                           |          |          |          drm_ioctl
>                           |          |          |          do_vfs_ioctl
>                           |          |          |          sys_ioctl
>                           |          |          |          system_call_fastpath
>                           |          |          |          __GI___ioctl
>                           |          |          |          0x0
>                           |          |          |
>                           |          |           --46.94%-- radeon_bo_list_validate
>                           |          |                     radeon_cs_parser_relocs
>                           |          |                     radeon_cs_ioctl
>                           |          |                     drm_ioctl
>                           |          |                     do_vfs_ioctl
>                           |          |                     sys_ioctl
>                           |          |                     system_call_fastpath
>                           |          |                     __GI___ioctl
>                           |          |                     0x7fff79e10b60
>                           |           --0.02%-- [...]
>                            --0.01%-- [...]
>      7.82%          swapper  [kernel.kallsyms]                [k] intel_idle
>                     |
>                     --- intel_idle
>                        |
>                        |--99.92%-- cpuidle_enter
>                        |          cpuidle_idle_call
>                        |          cpu_idle
>                        |          |
>                        |          |--91.66%-- start_secondary
>                        |          |
>                        |           --8.34%-- rest_init
>                        |                     start_kernel
>                        |                     x86_64_start_reservations
>                        |                     x86_64_start_kernel
>                         --0.08%-- [...]
>      5.85%             Xorg  [kernel.kallsyms]                [k] change_page_attr_set_clr
>                        |
>                        --- change_page_attr_set_clr
>                           |
>                           |--99.99%-- _set_pages_array
>                           |          set_pages_array_wc
>                           |          ttm_set_pages_caching
>                           |          ttm_dma_populate
>                           |          radeon_ttm_tt_populate
>                           |          ttm_tt_bind
>                           |          ttm_bo_handle_move_mem
>                           |          ttm_bo_evict
>                           |          ttm_mem_evict_first
>                           |          ttm_bo_mem_space
>                           |          ttm_bo_move_buffer
>                           |          ttm_bo_validate
>                           |          |
>                           |          |--56.21%-- ttm_bo_init
>                           |          |          radeon_bo_create
>                           |          |          radeon_gem_object_create
>                           |          |          radeon_gem_create_ioctl
>                           |          |          drm_ioctl
>                           |          |          do_vfs_ioctl
>                           |          |          sys_ioctl
>                           |          |          system_call_fastpath
>                           |          |          __GI___ioctl
>                           |          |          0x0
>                           |          |
>                           |           --43.79%-- radeon_bo_list_validate
>                           |                     radeon_cs_parser_relocs
>                           |                     radeon_cs_ioctl
>                           |                     drm_ioctl
>                           |                     do_vfs_ioctl
>                           |                     sys_ioctl
>                           |                     system_call_fastpath
>                           |                     __GI___ioctl
>                           |                     0x7fff79e10b60
>                            --0.01%-- [...]
>      0.64%             Xorg  [kernel.kallsyms]                [k] apic_timer_interrupt
>                        |
>                        --- apic_timer_interrupt
>                           |
>                           |--94.99%-- physflat_send_IPI_allbutself
>                           |          native_send_call_func_ipi
>                           |          smp_call_function_many
>                           |          smp_call_function
>                           |          on_each_cpu
>                           |          change_page_attr_set_clr
>                           |          _set_pages_array
>                           |          set_pages_array_wc
>                           |          ttm_set_pages_caching
>                           |          ttm_dma_populate
>                           |          radeon_ttm_tt_populate
>                           |          ttm_tt_bind
>                           |          ttm_bo_handle_move_mem
>                           |          ttm_bo_evict
>                           |          ttm_mem_evict_first
>                           |          ttm_bo_mem_space
>                           |          ttm_bo_move_buffer
>                           |          ttm_bo_validate
>                           |          |
>                           |          |--56.82%-- radeon_bo_list_validate
>                           |          |          radeon_cs_parser_relocs
>                           |          |          radeon_cs_ioctl
>                           |          |          drm_ioctl
>                           |          |          do_vfs_ioctl
>                           |          |          sys_ioctl
>                           |          |          system_call_fastpath
>                           |          |          __GI___ioctl
>                           |          |          0x7fff79e10b60
>                           |          |
>                           |           --43.18%-- ttm_bo_init
>                           |                     radeon_bo_create
>                           |                     radeon_gem_object_create
>                           |                     radeon_gem_create_ioctl
>                           |                     drm_ioctl
>                           |                     do_vfs_ioctl
>                           |                     sys_ioctl
>                           |                     system_call_fastpath
>                           |                     __GI___ioctl
>                           |                     0x0
>                           |
>                           |--4.04%-- smp_call_function
>                           |          on_each_cpu
>                           |          change_page_attr_set_clr
>                           |          _set_pages_array
>                           |          set_pages_array_wc
>                           |          ttm_set_pages_caching
>                           |          ttm_dma_populate
>                           |          radeon_ttm_tt_populate
>                           |          ttm_tt_bind
>                           |          ttm_bo_handle_move_mem
>                           |          ttm_bo_evict
>                           |          ttm_mem_evict_first
>                           |          ttm_bo_mem_space
>                           |          ttm_bo_move_buffer
>                           |          ttm_bo_validate
>                           |          |
>                           |          |--61.23%-- ttm_bo_init
>                           |          |          radeon_bo_create
>                           |          |          radeon_gem_object_create
>                           |          |          radeon_gem_create_ioctl
>                           |          |          drm_ioctl
>                           |          |          do_vfs_ioctl
>                           |          |          sys_ioctl
>                           |          |          system_call_fastpath
>                           |          |          __GI___ioctl
>                           |          |          0x0
>                           |          |
>                           |           --38.77%-- radeon_bo_list_validate
>                           |                     radeon_cs_parser_relocs
>                           |                     radeon_cs_ioctl
>                           |                     drm_ioctl
>                           |                     do_vfs_ioctl
>                           |                     sys_ioctl
>                           |                     system_call_fastpath
>                           |                     __GI___ioctl
>                           |                     0x7fff79e10b60
>                           |
>                           |--0.77%-- _set_pages_array
>                           |          set_pages_array_wc
>                           |          ttm_set_pages_caching
>                           |          ttm_dma_populate
>                           |          radeon_ttm_tt_populate
>                           |          ttm_tt_bind
>                           |          ttm_bo_handle_move_mem
>                           |          ttm_bo_evict
>                           |          ttm_mem_evict_first
>                           |          ttm_bo_mem_space
>                           |          ttm_bo_move_buffer
>                           |          ttm_bo_validate
>                           |          |
>                           |          |--66.81%-- ttm_bo_init
>                           |          |          radeon_bo_create
>                           |          |          radeon_gem_object_create
>                           |          |          radeon_gem_create_ioctl
>                           |          |          drm_ioctl
>                           |          |          do_vfs_ioctl
>                           |          |          sys_ioctl
>                           |          |          system_call_fastpath
>                           |          |          __GI___ioctl
>                           |          |          0x0
>                           |          |
>                           |           --33.19%-- radeon_bo_list_validate
>                           |                     radeon_cs_parser_relocs
>                           |                     radeon_cs_ioctl
>                           |                     drm_ioctl
>                           |                     do_vfs_ioctl
>                           |                     sys_ioctl
>                           |                     system_call_fastpath
>                           |                     __GI___ioctl
>                           |                     0x7fff79e10b60
>                            --0.21%-- [...]
>      0.60%             Xorg  [kernel.kallsyms]                [k] __purge_vmap_area_lazy
>                        |
>                        --- __purge_vmap_area_lazy
>                            vm_unmap_aliases
>                            change_page_attr_set_clr
>                            _set_pages_array
>                            set_pages_array_wc
>                            ttm_set_pages_caching
>                            ttm_dma_populate
>                            radeon_ttm_tt_populate
>                            ttm_tt_bind
>                            ttm_bo_handle_move_mem
>                            ttm_bo_evict
>                            ttm_mem_evict_first
>                            ttm_bo_mem_space
>                            ttm_bo_move_buffer
>                            ttm_bo_validate
>                           |
>                           |--56.35%-- ttm_bo_init
>                           |          radeon_bo_create
>                           |          radeon_gem_object_create
>                           |          radeon_gem_create_ioctl
>                           |          drm_ioctl
>                           |          do_vfs_ioctl
>                           |          sys_ioctl
>                           |          system_call_fastpath
>                           |          __GI___ioctl
>                           |          0x0
>                           |
>                            --43.65%-- radeon_bo_list_validate
>                                      radeon_cs_parser_relocs
>                                      radeon_cs_ioctl
>                                      drm_ioctl
>                                      do_vfs_ioctl
>                                      sys_ioctl
>                                      system_call_fastpath
>                                      __GI___ioctl
>                                      0x7fff79e10b60
>      0.42%          swapper  [kernel.kallsyms]                [k] getnstimeofday
>                     |
>                     --- getnstimeofday
>                        |
>                        |--95.17%-- ktime_get_real
>                        |          intel_idle
>                        |          cpuidle_enter
>                        |          cpuidle_idle_call
>                        |          cpu_idle
>                        |          |
>                        |          |--96.68%-- start_secondary
>                        |          |
>                        |           --3.32%-- rest_init
>                        |                     start_kernel
>                        |                     x86_64_start_reservations
>                        |                     x86_64_start_kernel
>                        |
>                         --4.83%-- intel_idle
>                                   cpuidle_enter
>                                   cpuidle_idle_call
>                                   cpu_idle
>                                   |
>                                   |--95.26%-- start_secondary
>                                   |
>                                    --4.74%-- rest_init
>                                              start_kernel
>                                              x86_64_start_reservations
>                                              x86_64_start_kernel
