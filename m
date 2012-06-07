Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761414Ab2FGTdi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 15:33:38 -0400
Received: from mail.skyhub.de ([78.46.96.112]:39885 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754129Ab2FGTdg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 15:33:36 -0400
Date: Thu, 7 Jun 2012 21:33:31 +0200
From: Borislav Petkov <bp@alien8.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Rus <rus@sfinxsoft.com>, linux-kernel@vger.kernel.org
Subject: lockdep and kmemcheck
Message-ID: <20120607193331.GA20723@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Peter Zijlstra <peterz@infradead.org>, Rus <rus@sfinxsoft.com>,
	linux-kernel@vger.kernel.org
References: <CAKgfjTktMLc5bfqhCOKy0evssxggofNQqLT-gQqBkHcBvOgF0g@mail.gmail.com>
 <CAKgfjTnvCAT=3JFxmDTsui_hguiiBfHQfMmErv9wt6QG_30hKA@mail.gmail.com>
 <20120607142459.GB5053@x1.osrc.amd.com>
 <CAKgfjTn3KXmDio0F0M3syeHnDc=ByKZu1ipe7S+75KRcCBy0QA@mail.gmail.com>
 <20120607151352.GA8261@x1.osrc.amd.com>
 <CAKgfjTn67KwR7-+icNZm7e5ZRfjqt1159kWMYD6S83WuhNfprQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAKgfjTn67KwR7-+icNZm7e5ZRfjqt1159kWMYD6S83WuhNfprQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter, does it ring a bell?

This is LOCKDEP with CONFIG_KMEMCHECK.

On Thu, Jun 07, 2012 at 10:02:33PM +0300, Rus wrote:
> > Do you have CONFIG_DETECT_HUNG_TASK enabled? Also CONFIG_PROVE_LOCKING,
> > CONFIG_KMEMCHECK, CONFIG_DEBUG_PREEMPT. These are just a couple of debug
> > options to enable right now which could tell us more.
> 
> Kmemcheck setting is prevented the booting of the 3.5-rc1 with the
> following messages :
> 
> kmemcheck: Limiting number of CPUs to 1.
> kmemcheck: Initialized
> ------------[ cut here ]------------
> WARNING: at kernel/lockdep.c:2739 lockdep_trace_alloc+0xcd/0xd0()
> Hardware name: To be filled by O.E.M.
> Modules linked in:
> Pid: 1, comm: swapper/0 Not tainted 3.5.0-rc1 #3
> Call Trace:
>  [<ffffffff8104123a>] warn_slowpath_common+0x7a/0xb0
>  [<ffffffff81041285>] warn_slowpath_null+0x15/0x20
>  [<ffffffff81096f2d>] lockdep_trace_alloc+0xcd/0xd0
>  [<ffffffff810ee48e>] __alloc_pages_nodemask+0x7e/0x890
>  [<ffffffff810ee599>] ? __alloc_pages_nodemask+0x189/0x890
>  [<ffffffff81278f3d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
>  [<ffffffff81278f3d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
>  [<ffffffff815c07d0>] ? error_exit+0x30/0xb0
>  [<ffffffff811260c9>] kmemcheck_alloc_shadow+0x29/0xb0
>  [<ffffffff8112409a>] new_slab+0x1fa/0x2e0
>  [<ffffffff815b70ec>] __slab_alloc.isra.51.constprop.55+0x3e8/0x40e
>  [<ffffffff815c07d0>] ? error_exit+0x30/0xb0
>  [<ffffffff811251f7>] kmem_cache_alloc+0x87/0xb0
>  [<ffffffff8126d7c0>] idr_pre_get+0x60/0x90
>  [<ffffffff8126dd8b>] ida_pre_get+0x1b/0x90
>  [<ffffffff810593b2>] create_worker+0x42/0x170
>  [<ffffffff81ae441d>] init_workqueues+0x1f2/0x393
>  [<ffffffff81ae422b>] ? usermodehelper_init+0x36/0x36
>  [<ffffffff81ae422b>] ? usermodehelper_init+0x36/0x36
>  [<ffffffff81002122>] do_one_initcall+0x122/0x180
>  [<ffffffff81acbc7a>] kernel_init+0x9b/0x1f6
>  [<ffffffff815c1f74>] kernel_thread_helper+0x4/0x10
>  [<ffffffff815c0274>] ? retint_restore_args+0x13/0x13
>  [<ffffffff81acbbdf>] ? start_kernel+0x3d2/0x3d2
>  [<ffffffff815c1f70>] ? gs_change+0x13/0x13
> ---[ end trace 6d450e935ee1897c ]---
> MCE: In-kernel MCE decoding enabled.
> NMI watchdog: enabled, takes one hw-pmu counter.
> Brought up 1 CPUs
> ----------------
> | NMI testsuite:
> --------------------
>   remote IPI:  ok  |
>    local IPI:
> ------------[ cut here ]------------
> ------------[ cut here ]------------
> WARNING: at arch/x86/mm/kmemcheck/kmemcheck.c:634 kmemcheck_fault+0xb1/0xc0()
> Hardware name: To be filled by O.E.M.
> Modules linked in:
> Pid: 1, comm: swapper/0 Tainted: G        W    3.5.0-rc1 #3
> Call Trace:
>  <NMI>  [<ffffffff8104123a>] warn_slowpath_common+0x7a/0xb0
>  [<ffffffff81041285>] warn_slowpath_null+0x15/0x20
>  [<ffffffff8103a1f1>] kmemcheck_fault+0xb1/0xc0
>  [<ffffffff81033d48>] do_page_fault+0x3f8/0x480
>  [<ffffffff81278f3d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
>  [<ffffffff815c0525>] page_fault+0x25/0x30
>  [<ffffffff8131fe2d>] ? vt_console_print+0xad/0x3b0
>  [<ffffffff8131fdea>] ? vt_console_print+0x6a/0x3b0
>  [<ffffffff8127ebbd>] ? do_raw_spin_unlock+0x5d/0xb0
>  [<ffffffff81042484>] console_unlock+0x174/0x280
>  [<ffffffff810427fc>] vprintk_emit+0x16c/0x580
>  [<ffffffff8103a1f1>] ? kmemcheck_fault+0xb1/0xc0
>  [<ffffffff815b451b>] printk+0x5c/0x5e
>  [<ffffffff8103a1f1>] ? kmemcheck_fault+0xb1/0xc0
>  [<ffffffff810411f9>] warn_slowpath_common+0x39/0xb0
>  [<ffffffff81041285>] warn_slowpath_null+0x15/0x20
>  [<ffffffff8103a1f1>] kmemcheck_fault+0xb1/0xc0
>  [<ffffffff81033d48>] do_page_fault+0x3f8/0x480
>  [<ffffffff81278f3d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
>  [<ffffffff815c0525>] page_fault+0x25/0x30
>  [<ffffffff8101ca8a>] ? x86_perf_event_update+0x2a/0xb0
>  [<ffffffff8101dc66>] x86_pmu_handle_irq+0x96/0x130
>  [<ffffffff8101c45d>] perf_event_nmi_handler+0x1d/0x20
>  [<ffffffff81010891>] nmi_handle.isra.0+0x81/0xd0
>  [<ffffffff81010810>] ? __register_nmi_handler+0x190/0x190
>  [<ffffffff810109e8>] do_nmi+0x108/0x380
>  [<ffffffff815c090c>] end_repeat_nmi+0x1a/0x1e
>  [<ffffffff81278879>] ? delay_tsc+0x29/0xf0
>  [<ffffffff81278879>] ? delay_tsc+0x29/0xf0
>  [<ffffffff81278879>] ? delay_tsc+0x29/0xf0
>  <<EOE>>  [<ffffffff812787ba>] __delay+0xa/0x10
>  [<ffffffff812787eb>] __const_udelay+0x2b/0x30
>  [<ffffffff81adf398>] test_nmi_ipi.constprop.2+0x51/0x84
>  [<ffffffff81adf41e>] local_ipi+0x21/0x23
>  [<ffffffff81adf2d2>] dotest.constprop.1+0x6/0x7b
>  [<ffffffff81adf4af>] nmi_selftest+0x8f/0x185
>  [<ffffffff81ada69b>] native_smp_cpus_done+0x2d/0x11e
>  [<ffffffff81ae6199>] smp_init+0x97/0x9f
>  [<ffffffff81acbc9e>] kernel_init+0xbf/0x1f6
>  [<ffffffff815c1f74>] kernel_thread_helper+0x4/0x10
>  [<ffffffff815c0274>] ? retint_restore_args+0x13/0x13
>  [<ffffffff81acbbdf>] ? start_kernel+0x3d2/0x3d2
>  [<ffffffff815c1f70>] ? gs_change+0x13/0x13
> ---[ end trace 6d450e935ee1897d ]---
> WARNING: at arch/x86/mm/kmemcheck/kmemcheck.c:634 kmemcheck_fault+0xb1/0xc0()
> Hardware name: To be filled by O.E.M.
> Modules linked in:
> Pid: 1, comm: swapper/0 Tainted: G        W    3.5.0-rc1 #3
> Call Trace:
>  <NMI>  [<ffffffff8104123a>] warn_slowpath_common+0x7a/0xb0
>  [<ffffffff81041285>] warn_slowpath_null+0x15/0x20
>  [<ffffffff8103a1f1>] kmemcheck_fault+0xb1/0xc0
>  [<ffffffff81033d48>] do_page_fault+0x3f8/0x480
>  [<ffffffff81278f3d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
>  [<ffffffff815c0525>] page_fault+0x25/0x30
>  [<ffffffff8101ca8a>] ? x86_perf_event_update+0x2a/0xb0
>  [<ffffffff8101dc66>] x86_pmu_handle_irq+0x96/0x130
>  [<ffffffff8101c45d>] perf_event_nmi_handler+0x1d/0x20
>  [<ffffffff81010891>] nmi_handle.isra.0+0x81/0xd0
>  [<ffffffff81010810>] ? __register_nmi_handler+0x190/0x190
>  [<ffffffff810109e8>] do_nmi+0x108/0x380
>  [<ffffffff815c090c>] end_repeat_nmi+0x1a/0x1e
>  [<ffffffff81278879>] ? delay_tsc+0x29/0xf0
>  [<ffffffff81278879>] ? delay_tsc+0x29/0xf0
>  [<ffffffff81278879>] ? delay_tsc+0x29/0xf0
>  <<EOE>>  [<ffffffff812787ba>] __delay+0xa/0x10
>  [<ffffffff812787eb>] __const_udelay+0x2b/0x30
>  [<ffffffff81adf398>] test_nmi_ipi.constprop.2+0x51/0x84
>  [<ffffffff81adf41e>] local_ipi+0x21/0x23
>  [<ffffffff81adf2d2>] dotest.constprop.1+0x6/0x7b
>  [<ffffffff81adf4af>] nmi_selftest+0x8f/0x185
>  [<ffffffff81ada69b>] native_smp_cpus_done+0x2d/0x11e
>  [<ffffffff81ae6199>] smp_init+0x97/0x9f
>  [<ffffffff81acbc9e>] kernel_init+0xbf/0x1f6
>  [<ffffffff815c1f74>] kernel_thread_helper+0x4/0x10
>  [<ffffffff815c0274>] ? retint_restore_args+0x13/0x13
>  [<ffffffff81acbbdf>] ? start_kernel+0x3d2/0x3d2
>  [<ffffffff815c1f70>] ? gs_change+0x13/0x13
> ---[ end trace 6d450e935ee1897e ]---
>   ok  |
> --------------------
> Good, all   2 testcases passed! |
> ....................
> Freeing unused kernel memory: 228k freed
> Freeing unused kernel memory: 1388k freed
> init (1) used greatest stack depth: 3256 bytes left
> Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000005
> 
> Pid: 1, comm: init Tainted: G        W    3.5.0-rc1 #3
> Call Trace:
>  [<ffffffff815b43ae>] panic+0xb5/0x1c6
>  [<ffffffff810464d9>] ? do_exit+0x749/0x920
>  [<ffffffff81046581>] do_exit+0x7f1/0x920
>  [<ffffffff81046944>] do_group_exit+0x44/0xb0
>  [<ffffffff81053211>] get_signal_to_deliver+0x1e1/0x5f0
>  [<ffffffff8105168f>] ? __send_signal+0x16f/0x2f0
>  [<ffffffff8100c26a>] do_signal+0x3a/0x920
>  [<ffffffff815bfd65>] ? _raw_spin_unlock_irqrestore+0x45/0x80
>  [<ffffffff8105214c>] ? force_sig_info+0xdc/0x100
>  [<ffffffff81019f82>] ? syscall_trace_leave+0x122/0x130
>  [<ffffffff8100cbdd>] do_notify_resume+0x6d/0xa0
>  [<ffffffff81278efe>] ? trace_hardirqs_on_thunk+0x3a/0x3f
>  [<ffffffff815c0e7a>] int_signal+0x12/0x17
>  [<ffffffff815b290b>] ? run_init_process+0x1e/0x20
>  [<ffffffff815b2952>] ? init_post+0x45/0xbe
>  [<ffffffff81acbdd5>] ? kernel_init+0x1f6/0x1f6
>  [<ffffffff81acb5ae>] ? do_early_param+0x8c/0x8c
>  [<ffffffff815c1f74>] ? kernel_thread_helper+0x4/0x10
>  [<ffffffff815c0274>] ? retint_restore_args+0x13/0x13
>  [<ffffffff81acbbdf>] ? start_kernel+0x3d2/0x3d2
>  [<ffffffff815c1f70>] ? gs_change+0x13/0x13
> .........
> 
> After disabling kmemcheck the box is able to boot again.
> 
> Rus
> 
> -- 
> SfinxSoft
> http://sfinxsoft.com
> 

-- 
Regards/Gruss,
    Boris.
