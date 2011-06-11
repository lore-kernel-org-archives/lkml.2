Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758648Ab1FKPX3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jun 2011 11:23:29 -0400
Received: from higgs.elka.pw.edu.pl ([194.29.160.5]:37353 "EHLO
	higgs.elka.pw.edu.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758582Ab1FKPX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jun 2011 11:23:27 -0400
X-Comment: RFC 2476 MSA function at elektron.elka.pw.edu.pl logged sender identity as: wzabolot
Message-ID: <4DF3885B.2080900@ise.pw.edu.pl>
Date: Sat, 11 Jun 2011 17:23:07 +0200
From: wzab <wzab@ise.pw.edu.pl>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110516 Icedove/3.1.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: wzab@ise.pw.edu.pl
Subject: kmemcheck error and panic when booting 2.6.39.1 , however acpi=off
 allows to boot
References: <4DEA8FDD.1060905@elektron.elka.pw.edu.pl> <4DEAA677.2010404@elektron.elka.pw.edu.pl> <4DEAAB42.8070704@elektron.elka.pw.edu.pl> <4DEB4EF2.5050102@elektron.elka.pw.edu.pl> <4DEBE579.1070508@ise.pw.edu.pl>
In-Reply-To: <4DEBE579.1070508@ise.pw.edu.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Today I've tried to investigate more thoroughly why one of my machine 
doesn't boot with 2.6.39.1
I've performed four reboots with different parameters, recording serial 
console output to files:

crash6.txt - booting with HT in BIOS on, parameters: kmemleak=on
crash7.txt - booting with HT in BIOS on, parameters: slub_debug kmemleak=on
crash8.txt - booting with HT in BIOS off, parameters: slub_debug kmemleak=on
crash9.txt - booting with HT in BIOS on, parameters: slub_debug 
kmemleak=on acpi=off

In all cases there was a problem detected in kmemcheck:

crash6.txt:
[   69.689737] ------------[ cut here ]------------
[   69.690605] WARNING: at arch/x86/mm/kmemcheck/kmemcheck.c:634 
kmemcheck_fault+0xa5/0xc0()
[   69.690605] Hardware name:
[   69.690605] Modules linked in:
[   69.690605] Pid: 1, comm: swapper Not tainted 2.6.39.1 #3
[   69.690605] Call Trace:
[   69.690605]  [<c013de0d>] warn_slowpath_common+0x6d/0xa0
[   69.690605]  [<c0128ce5>] ? kmemcheck_fault+0xa5/0xc0
[   69.690605]  [<c0128ce5>] ? kmemcheck_fault+0xa5/0xc0
[   69.690605]  [<c013de5d>] warn_slowpath_null+0x1d/0x20
[   69.690605]  [<c0128ce5>] kmemcheck_fault+0xa5/0xc0
[   69.690605]  [<c0124480>] do_page_fault+0x270/0x440
[   69.690605]  [<c0128cad>] ? kmemcheck_fault+0x6d/0xc0
[   69.690605]  [<c0128e2e>] ? kmemcheck_pte_lookup+0xe/0x40
[   69.690605]  [<c0124210>] ? vmalloc_sync_all+0x100/0x100
[   69.690605]  [<c04663f3>] error_code+0x5f/0x64
[   69.690605]  [<c012007b>] ? io_apic_set_pci_routing+0x4b/0x60
[   69.690605]  [<c0124210>] ? vmalloc_sync_all+0x100/0x100
[   69.690605]  [<c0111dbf>] ? p4_pmu_handle_irq+0x7f/0x1b0
[   69.690605]  [<c0128e2e>] ? kmemcheck_pte_lookup+0xe/0x40
[   69.690605]  [<c0128469>] ? kmemcheck_save_addr+0x19/0x40
[   69.690605]  [<c012880b>] ? kmemcheck_show_addr+0xb/0x20
[   69.690605]  [<c012896e>] ? kmemcheck_show_all+0x2e/0x40
[   69.690605]  [<c010f098>] perf_event_nmi_handler+0x28/0xa0
[   69.690605]  [<c015f1c5>] notifier_call_chain+0x75/0xe0
[   69.690605]  [<c015f700>] __atomic_notifier_call_chain+0x60/0x90
[   69.690605]  [<c015f6a0>] ? register_reboot_notifier+0x20/0x20
[   69.690605]  [<c015f74a>] atomic_notifier_call_chain+0x1a/0x20
[   69.690605]  [<c015f86d>] notify_die+0x2d/0x30
[   69.690605]  [<c0102d72>] default_do_nmi+0x32/0x280
[   69.690605]  [<c010369f>] do_nmi+0x7f/0x90
[   69.690605]  [<c04664a5>] nmi_stack_correct+0x28/0x2d
[   69.690605]  [<c010378c>] ? do_debug+0xc/0x190
[   69.690605]  [<c0466446>] debug_stack_correct+0x2e/0x34
[   69.690605]  [<c028f6ef>] ? prio_tree_insert+0xdf/0x190
[   69.690605]  [<c01c68e0>] create_object+0x140/0x230
[   69.690605]  [<c04543a7>] kmemleak_alloc+0x27/0x50
[   69.690605]  [<c01c3b79>] kmem_cache_alloc+0xc9/0x110
[   69.690605]  [<c02ac306>] dma_debug_init+0x96/0x140
[   69.690605]  [<c061f75d>] ? start_kernel+0x322/0x322
[   69.690605]  [<c061f75d>] ? start_kernel+0x322/0x322
[   69.690605]  [<c0624d50>] pci_iommu_init+0x13/0x48
[   69.690605]  [<c01011f0>] do_one_initcall+0x30/0x170
[   69.690605]  [<c061f75d>] ? start_kernel+0x322/0x322
[   69.690605]  [<c0624d3d>] ? iommu_setup+0x1fd/0x1fd
[   69.690605]  [<c061f75d>] ? start_kernel+0x322/0x322
[   69.690605]  [<c061f7f8>] kernel_init+0x9b/0x12f
[   69.690605]  [<c0466bba>] kernel_thread_helper+0x6/0xd
[   69.690605] ---[ end trace 93d72a36b9146f22 ]---

crash7.txt:
[   69.687496] ------------[ cut here ]------------
[   69.690015] WARNING: at arch/x86/mm/kmemcheck/kmemcheck.c:634 
kmemcheck_fault+0xa5/0xc0()
[   69.690015] Hardware name:
[   69.690015] Modules linked in:
[   69.690015] Pid: 1, comm: swapper Not tainted 2.6.39.1 #3
[   69.690015] Call Trace:
[   69.690015]  [<c013de0d>] warn_slowpath_common+0x6d/0xa0
[   69.690015]  [<c0128ce5>] ? kmemcheck_fault+0xa5/0xc0
[   69.690015]  [<c0128ce5>] ? kmemcheck_fault+0xa5/0xc0
[   69.690015]  [<c013de5d>] warn_slowpath_null+0x1d/0x20
[   69.690015]  [<c0128ce5>] kmemcheck_fault+0xa5/0xc0
[   69.690015]  [<c0124480>] do_page_fault+0x270/0x440
[   69.690015]  [<c0128e2e>] ? kmemcheck_pte_lookup+0xe/0x40
[   69.690015]  [<c0128469>] ? kmemcheck_save_addr+0x19/0x40
[   69.690015]  [<c0128e2e>] ? kmemcheck_pte_lookup+0xe/0x40
[   69.690015]  [<c0128469>] ? kmemcheck_save_addr+0x19/0x40
[   69.690015]  [<c0128713>] ? kmemcheck_read_strict+0x33/0x80
[   69.690015]  [<c0124210>] ? vmalloc_sync_all+0x100/0x100
[   69.690015]  [<c04663f3>] error_code+0x5f/0x64
[   69.690015]  [<c0124210>] ? vmalloc_sync_all+0x100/0x100
[   69.690015]  [<c0111dbf>] ? p4_pmu_handle_irq+0x7f/0x1b0
[   69.690015]  [<c0128e2e>] ? kmemcheck_pte_lookup+0xe/0x40
[   69.690015]  [<c0128e2e>] ? kmemcheck_pte_lookup+0xe/0x40
[   69.690015]  [<c010f098>] perf_event_nmi_handler+0x28/0xa0
[   69.690015]  [<c015f1c5>] notifier_call_chain+0x75/0xe0
[   69.690015]  [<c015f700>] __atomic_notifier_call_chain+0x60/0x90
[   69.690015]  [<c015f6a0>] ? register_reboot_notifier+0x20/0x20
[   69.690015]  [<c015f74a>] atomic_notifier_call_chain+0x1a/0x20
[   69.690015]  [<c015f86d>] notify_die+0x2d/0x30
[   69.690015]  [<c0102d72>] default_do_nmi+0x32/0x280
[   69.690015]  [<c010369f>] do_nmi+0x7f/0x90
[   69.690015]  [<c04664a5>] nmi_stack_correct+0x28/0x2d
[   69.690015]  [<c012007b>] ? io_apic_set_pci_routing+0x4b/0x60
[   69.690015]  [<c016ce46>] ? trace_hardirqs_off_caller+0xa6/0xf0
[   69.690015]  [<c0295b64>] trace_hardirqs_off_thunk+0xc/0x18
[   69.690015]  [<c0465de6>] ? ret_from_exception+0x6/0x6
[   69.690015]  [<c01c007b>] ? unuse_pte+0xfb/0x120
[   69.690015]  [<c01c67f2>] ? create_object+0x52/0x230
[   69.690015]  [<c04543a7>] kmemleak_alloc+0x27/0x50
[   69.690015]  [<c01c3b79>] kmem_cache_alloc+0xc9/0x110
[   69.690015]  [<c02ac306>] dma_debug_init+0x96/0x140
[   69.690015]  [<c061f75d>] ? start_kernel+0x322/0x322
[   69.690015]  [<c061f75d>] ? start_kernel+0x322/0x322
[   69.690015]  [<c0624d50>] pci_iommu_init+0x13/0x48
[   69.690015]  [<c01011f0>] do_one_initcall+0x30/0x170
[   69.690015]  [<c061f75d>] ? start_kernel+0x322/0x322
[   69.690015]  [<c0624d3d>] ? iommu_setup+0x1fd/0x1fd
[   69.690015]  [<c061f75d>] ? start_kernel+0x322/0x322
[   69.690015]  [<c061f7f8>] kernel_init+0x9b/0x12f
[   69.690015]  [<c0466bba>] kernel_thread_helper+0x6/0xd
[   69.690015] ---[ end trace 93d72a36b9146f22 ]---

crash8.txt:
[   69.663411] ------------[ cut here ]------------
[   69.663411] WARNING: at arch/x86/mm/kmemcheck/kmemcheck.c:634 
kmemcheck_fault+0xa5/0xc0()
[   69.663411] Hardware name:
[   69.663411] Modules linked in:
[   69.663411] Pid: 1, comm: swapper Not tainted 2.6.39.1 #3
[   69.663411] Call Trace:
[   69.663411]  [<c013de0d>] warn_slowpath_common+0x6d/0xa0
[   69.663411]  [<c0128ce5>] ? kmemcheck_fault+0xa5/0xc0
[   69.663411]  [<c0128ce5>] ? kmemcheck_fault+0xa5/0xc0
[   69.663411]  [<c013de5d>] warn_slowpath_null+0x1d/0x20
[   69.663411]  [<c0128ce5>] kmemcheck_fault+0xa5/0xc0
[   69.663411]  [<c0124480>] do_page_fault+0x270/0x440
[   69.663411]  [<c0128e2e>] ? kmemcheck_pte_lookup+0xe/0x40
[   69.663411]  [<c01093f6>] ? native_sched_clock+0x26/0x90
[   69.663411]  [<c015ffc3>] ? sched_clock_local+0xd3/0x1c0
[   69.663411]  [<c0124210>] ? vmalloc_sync_all+0x100/0x100
[   69.663411]  [<c04663f3>] error_code+0x5f/0x64
[   69.663411]  [<c0124210>] ? vmalloc_sync_all+0x100/0x100
[   69.663411]  [<c0111dbf>] ? p4_pmu_handle_irq+0x7f/0x1b0
[   69.663411]  [<c012896e>] ? kmemcheck_show_all+0x2e/0x40
[   69.663411]  [<c0128469>] ? kmemcheck_save_addr+0x19/0x40
[   69.663411]  [<c0128713>] ? kmemcheck_read_strict+0x33/0x80
[   69.663411]  [<c010f098>] perf_event_nmi_handler+0x28/0xa0
[   69.663411]  [<c015f1c5>] notifier_call_chain+0x75/0xe0
[   69.663411]  [<c012896e>] ? kmemcheck_show_all+0x2e/0x40
[   69.663411]  [<c015f700>] __atomic_notifier_call_chain+0x60/0x90
[   69.663411]  [<c015f6a0>] ? register_reboot_notifier+0x20/0x20
[   69.663411]  [<c015f74a>] atomic_notifier_call_chain+0x1a/0x20
[   69.663411]  [<c015f86d>] notify_die+0x2d/0x30
[   69.663411]  [<c0102d72>] default_do_nmi+0x32/0x280
[   69.663411]  [<c010369f>] do_nmi+0x7f/0x90
[   69.663411]  [<c04664a5>] nmi_stack_correct+0x28/0x2d
[   69.663411]  [<c046638c>] ? spurious_interrupt_bug+0xc/0xc
[   69.663411]  [<c028f42c>] ? prio_tree_replace+0x4c/0x60
[   69.663411]  [<c028f739>] prio_tree_insert+0x129/0x190
[   69.663411]  [<c01c68e0>] create_object+0x140/0x230
[   69.663411]  [<c04543a7>] kmemleak_alloc+0x27/0x50
[   69.663411]  [<c01c3b79>] kmem_cache_alloc+0xc9/0x110
[   69.663411]  [<c02ac306>] dma_debug_init+0x96/0x140
[   69.663411]  [<c061f75d>] ? start_kernel+0x322/0x322
[   69.663411]  [<c061f75d>] ? start_kernel+0x322/0x322
[   69.663411]  [<c0624d50>] pci_iommu_init+0x13/0x48
[   69.663411]  [<c01011f0>] do_one_initcall+0x30/0x170
[   69.663411]  [<c061f75d>] ? start_kernel+0x322/0x322
[   69.663411]  [<c0624d3d>] ? iommu_setup+0x1fd/0x1fd
[   69.663411]  [<c061f75d>] ? start_kernel+0x322/0x322
[   69.663411]  [<c061f7f8>] kernel_init+0x9b/0x12f
[   69.663411]  [<c0466bba>] kernel_thread_helper+0x6/0xd
[   69.663411] ---[ end trace 93d72a36b9146f22 ]---

crash9.txt:
[   61.373342] ------------[ cut here ]------------
[   61.373348] WARNING: at arch/x86/mm/kmemcheck/kmemcheck.c:634 
kmemcheck_fault+0xa5/0xc0()
[   61.373348] Hardware name:
[   61.373348] Modules linked in:
[   61.373348] Pid: 1, comm: swapper Not tainted 2.6.39.1 #3
[   61.373348] Call Trace:
[   61.373348]  [<c013de0d>] warn_slowpath_common+0x6d/0xa0
[   61.373348]  [<c0128ce5>] ? kmemcheck_fault+0xa5/0xc0
[   61.373348]  [<c0128ce5>] ? kmemcheck_fault+0xa5/0xc0
[   61.373348]  [<c013de5d>] warn_slowpath_null+0x1d/0x20
[   61.373348]  [<c0128ce5>] kmemcheck_fault+0xa5/0xc0
[   61.373348]  [<c0124480>] do_page_fault+0x270/0x440
[   61.373348]  [<c0128713>] ? kmemcheck_read_strict+0x33/0x80
[   61.373348]  [<c0128469>] ? kmemcheck_save_addr+0x19/0x40
[   61.373348]  [<c0128713>] ? kmemcheck_read_strict+0x33/0x80
[   61.373348]  [<c0128e2e>] ? kmemcheck_pte_lookup+0xe/0x40
[   61.373348]  [<c0124210>] ? vmalloc_sync_all+0x100/0x100
[   61.373348]  [<c04663f3>] error_code+0x5f/0x64
[   61.373348]  [<c0124210>] ? vmalloc_sync_all+0x100/0x100
[   61.373348]  [<c0111dbf>] ? p4_pmu_handle_irq+0x7f/0x1b0
[   61.373348]  [<c0128713>] ? kmemcheck_read_strict+0x33/0x80
[   61.373348]  [<c0128e2e>] ? kmemcheck_pte_lookup+0xe/0x40
[   61.373348]  [<c0128e2e>] ? kmemcheck_pte_lookup+0xe/0x40
[   61.373348]  [<c010f098>] perf_event_nmi_handler+0x28/0xa0
[   61.373348]  [<c015f1c5>] notifier_call_chain+0x75/0xe0
[   61.373348]  [<c015f700>] __atomic_notifier_call_chain+0x60/0x90
[   61.373348]  [<c015f6a0>] ? register_reboot_notifier+0x20/0x20
[   61.373348]  [<c015f74a>] atomic_notifier_call_chain+0x1a/0x20
[   61.373348]  [<c015f86d>] notify_die+0x2d/0x30
[   61.373348]  [<c0102d72>] default_do_nmi+0x32/0x280
[   61.373348]  [<c0128cad>] ? kmemcheck_fault+0x6d/0xc0
[   61.373348]  [<c010369f>] do_nmi+0x7f/0x90
[   61.373348]  [<c04664a5>] nmi_stack_correct+0x28/0x2d
[   61.373348]  [<c012007b>] ? io_apic_set_pci_routing+0x4b/0x60
[   61.373348]  [<c01093d0>] ? time_cpufreq_notifier+0x140/0x140
[   61.373348]  [<c015ffc3>] ? sched_clock_local+0xd3/0x1c0
[   61.373348]  [<c012880b>] ? kmemcheck_show_addr+0xb/0x20
[   61.373348]  [<c012896e>] ? kmemcheck_show_all+0x2e/0x40
[   61.373348]  [<c0128cad>] ? kmemcheck_fault+0x6d/0xc0
[   61.373348]  [<c0160259>] sched_clock_cpu+0xf9/0x190
[   61.373348]  [<c0128e2e>] ? kmemcheck_pte_lookup+0xe/0x40
[   61.373348]  [<c0160309>] local_clock+0x19/0x60
[   61.373348]  [<c016d33d>] lock_release_holdtime+0x2d/0x160
[   61.373348]  [<c0128d1a>] ? kmemcheck_trap+0x1a/0x30
[   61.373348]  [<c01728dc>] lock_release_nested+0x8c/0x110
[   61.373348]  [<c02a60da>] ? debug_object_deactivate+0x8a/0xf0
[   61.373348]  [<c01729ab>] __lock_release+0x4b/0xe0
[   61.373348]  [<c0172a89>] lock_release+0x49/0x70
[   61.373348]  [<c02a60da>] ? debug_object_deactivate+0x8a/0xf0
[   61.373348]  [<c0465cb9>] _raw_spin_unlock_irqrestore+0x19/0x70
[   61.373348]  [<c02a60da>] debug_object_deactivate+0x8a/0xf0
[   61.373348]  [<c015d4ed>] __run_hrtimer.clone.22+0x2d/0x120
[   61.373348]  [<c0465116>] ? _raw_spin_lock+0x66/0x70
[   61.373348]  [<c015dffd>] hrtimer_interrupt+0x17d/0x260
[   61.373348]  [<c012898b>] ? kmemcheck_hide_addr+0xb/0x20
[   61.373348]  [<c011c370>] smp_apic_timer_interrupt+0x50/0x90
[   61.373348]  [<c0295b64>] ? trace_hardirqs_off_thunk+0xc/0x18
[   61.373348]  [<c04661b7>] apic_timer_interrupt+0x2f/0x34
[   61.373348]  [<c029007b>] ? radix_tree_callback+0x4b/0x60
[   61.373348]  [<c0225eda>] ? sysfs_find_dirent+0x2a/0x50
[   61.373348]  [<c0226077>] __sysfs_add_one+0x27/0x90
[   61.373348]  [<c02260f8>] sysfs_add_one+0x18/0xb0
[   61.373348]  [<c022695a>] sysfs_do_create_link+0xea/0x1f0
[   61.373348]  [<c0226a72>] sysfs_create_link+0x12/0x20
[   61.373348]  [<c0341a44>] device_add+0x154/0x350
[   61.373348]  [<c0341c52>] device_register+0x12/0x20
[   61.373348]  [<c0341d01>] device_create_vargs+0xa1/0xc0
[   61.373348]  [<c0341d48>] device_create+0x28/0x30
[   61.373348]  [<c030386f>] tty_register_device+0x7f/0x100
[   61.373348]  [<c0290035>] ? radix_tree_callback+0x5/0x60
[   61.373348]  [<c0465ec8>] ? restore_all+0xf/0xf
[   61.373348]  [<c028da00>] ? kobject_cleanup+0x100/0x110
[   61.373348]  [<c0303d73>] tty_register_driver+0xf3/0x240
[   61.373348]  [<c0640a11>] legacy_pty_init+0x159/0x188
[   61.373348]  [<c061f75d>] ? start_kernel+0x322/0x322
[   61.373348]  [<c0640c6c>] pty_init+0x8/0x11
[   61.373348]  [<c01011f0>] do_one_initcall+0x30/0x170
[   61.373348]  [<c061f75d>] ? start_kernel+0x322/0x322
[   61.373348]  [<c0640c64>] ? unix98_pty_init+0x224/0x224
[   61.373348]  [<c061f75d>] ? start_kernel+0x322/0x322
[   61.373348]  [<c061f7f8>] kernel_init+0x9b/0x12f
[   61.373348]  [<c0466bba>] kernel_thread_helper+0x6/0xd
[   61.373348] ---[ end trace 93d72a36b9146f22 ]---

All above errors look very similar, however further operation of the kernel
depends on boot parameters.
Only with "acpi=off" the system started completely, and I was able to log in
into gdm, and later switch it off in normal way (crash8.txt).
With other parameters kernel panicked during the boot.

I attach the crashes.tar.z2 file containing logs (crash?.txt) and 
configuration
of my kernel (config). Hardware details of my machine were already provided
in previous messages in this thread.
-- 
Regards,
Wojtek

