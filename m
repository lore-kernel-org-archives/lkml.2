Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585Ab2AJQdo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 11:33:44 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:62230 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756360Ab2AJQdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 11:33:42 -0500
Message-ID: <1326213210.19095.7.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: [BUG] kernel freezes with latest tree
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Tue, 10 Jan 2012 17:33:30 +0100
In-Reply-To: <CA+55aFwvGQjN42CqjmsUuFGPbPz3kKvasMwd9Sup3mp43KdNjA@mail.gmail.com>
References: <1326171444.6638.3.camel@edumazet-laptop>
	 <1326171798.6638.4.camel@edumazet-laptop>
	 <1326183371.6638.6.camel@edumazet-laptop>
	 <CA+55aFwvGQjN42CqjmsUuFGPbPz3kKvasMwd9Sup3mp43KdNjA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 10 janvier 2012 à 08:16 -0800, Linus Torvalds a écrit :

> 
> That's one of the merges this window that I sent out a query message
> for, because I wasn't happy with it, and stopped at that point waiting
> for people to validate the end result.
> 
> Nobody complained about it, but the first thing to try would be one of
> my questions about that merge: can you move the call to
> 
>   set_cpu_sd_state_idle();
> 
> (along with the comment above it) in tick_nohz_idle_enter()
> (kernel/time/tick-sched.c) to just *below* the "local_irq_disable()"?
> 
> I also questioned the interaction between the sparse cleanups and
> usecs_to_cputime64(), but people said they were fine.. But your report
> will probably make people double-check.
> 

Hmm, I tried your suggestion but still get a lockup.

(please ignore the bnx2 netpoll problem, I'll post a patch on net-next
later)

[  106.499348] ------------[ cut here ]------------
[  106.499348] WARNING: at kernel/watchdog.c:241
watchdog_overflow_callback+0x9c/0xc0()
[  106.499348] Hardware name: ProLiant BL460c G1
[  106.499348] Watchdog detected hard LOCKUP on cpu 0
[  106.499348] Modules linked in: netconsole xt_hashlimit af_packet tg3
bonding
[  106.499348] Pid: 5727, comm: hackbench Not tainted
3.2.0-05066-g31ae26a-dirty #774
[  106.499348] Call Trace:
[  106.499348]  [<c022a212>] warn_slowpath_common+0x72/0xa0
[  106.499348]  [<c0281c4c>] ? watchdog_overflow_callback+0x9c/0xc0
[  106.499348]  [<c0281c4c>] ? watchdog_overflow_callback+0x9c/0xc0
[  106.499348] ------------[ cut here ]------------
[  106.499348] WARNING: at kernel/softirq.c:159 local_bh_enable_ip
+0x58/0x80()
[  106.499348] Hardware name: ProLiant BL460c G1
[  106.499348] Modules linked in: netconsole xt_hashlimit af_packet tg3
bonding
[  106.499348] Pid: 5727, comm: hackbench Not tainted
3.2.0-05066-g31ae26a-dirty #774
[  106.499348] Call Trace:
[  106.499348]  [<c06048f2>] ? printk+0x1d/0x23
[  106.499348]  [<c022a212>] warn_slowpath_common+0x72/0xa0
[  106.499348]  [<c022ffd8>] ? local_bh_enable_ip+0x58/0x80
[  106.499348]  [<c022ffd8>] ? local_bh_enable_ip+0x58/0x80
[  106.499348]  [<c022a262>] warn_slowpath_null+0x22/0x30
[  106.499348]  [<c022ffd8>] local_bh_enable_ip+0x58/0x80
[  106.499348]  [<c0606e03>] _raw_spin_unlock_bh+0x13/0x20
[  106.499348]  [<c047046b>] bnx2_reg_rd_ind+0x3b/0x50
[  106.499348]  [<c0470493>] bnx2_shmem_rd+0x13/0x20
[  106.499348]  [<c047af03>] bnx2_poll+0x103/0x200
[  106.499348]  [<c04f1c50>] netpoll_poll_dev+0x410/0x4c0
[  106.499348]  [<c02b21b4>] ? __probe_kernel_read+0x24/0x40
[  106.499348]  [<c02eb1d6>] ? __kmalloc_node_track_caller+0xf6/0x1b0
[  106.499348]  [<c04f1e18>] netpoll_send_skb_on_dev+0x118/0x1d0
[  106.499348]  [<c04d3d49>] ? __alloc_skb+0x69/0x110
[  106.499348]  [<c04f17ed>] ? find_skb.clone.30+0x3d/0x90
[  106.499348]  [<c04f209a>] netpoll_send_udp+0x1ca/0x1f0
[  106.499348]  [<f8716214>] write_msg+0x84/0xb0 [netconsole]
[  106.499348]  [<f8716190>] ? netconsole_netdev_event+0x190/0x190
[netconsole]
[  106.499348]  [<c022a38b>] __call_console_drivers+0x7b/0x90
[  106.499348]  [<c022a3ee>] _call_console_drivers+0x4e/0x80
[  106.499348]  [<c022a813>] console_unlock+0xf3/0x210
[  106.499348]  [<c022ad39>] vprintk+0x2d9/0x3d0
[  106.499348]  [<c02501f9>] ? up+0x29/0x40
[  106.499348]  [<c0281c4c>] ? watchdog_overflow_callback+0x9c/0xc0
[  106.499348]  [<c06048f2>] printk+0x1d/0x23
[  106.499348]  [<c0205772>] printk_address+0x32/0x40
[  106.499348]  [<c0281c4c>] ? watchdog_overflow_callback+0x9c/0xc0
[  106.499348]  [<c0281c4c>] ? watchdog_overflow_callback+0x9c/0xc0
[  106.499348]  [<c02057b0>] print_trace_address+0x30/0x40
[  106.499348]  [<c02056bc>] print_context_stack+0x7c/0x100
[  106.499348]  [<c0281c4c>] ? watchdog_overflow_callback+0x9c/0xc0
[  106.499348]  [<c020474f>] dump_trace+0x7f/0xf0
[  106.499348]  [<c020580c>] show_trace_log_lvl+0x4c/0x60
[  106.499348]  [<c020583f>] show_trace+0x1f/0x30
[  106.499348]  [<c0604778>] dump_stack+0x73/0x7a
[  106.499348]  [<c022a212>] warn_slowpath_common+0x72/0xa0
[  106.499348]  [<c0281c4c>] ? watchdog_overflow_callback+0x9c/0xc0
[  106.499348]  [<c0281c4c>] ? watchdog_overflow_callback+0x9c/0xc0
[  106.499348]  [<c0281bb0>] ? watchdog_timer_fn+0x170/0x170
[  106.499348]  [<c022a2e3>] warn_slowpath_fmt+0x33/0x40
[  106.499348]  [<c0281c4c>] watchdog_overflow_callback+0x9c/0xc0
[  106.499348]  [<c02a9f9a>] __perf_event_overflow+0x9a/0x240
[  106.499348]  [<c02ff240>] ? poll_freewait+0xb0/0xb0
[  106.499348]  [<c02100c8>] ? x86_perf_event_set_period+0x118/0x210
[  106.499348]  [<c02aa7f5>] perf_event_overflow+0x15/0x20
[  106.499348]  [<c0213639>] intel_pmu_handle_irq+0x129/0x250
[  106.499348]  [<c020ed80>] perf_event_nmi_handler+0x20/0x30
[  106.499348]  [<c0205d87>] do_nmi+0xb7/0x350
[  106.499348]  [<c0607a99>] nmi_stack_correct+0x28/0x2d
[  106.499348]  [<c0259d32>] ? try_to_wake_up+0xa2/0x220
[  106.499348]  [<c0259ec0>] default_wake_function+0x10/0x20
[  106.499348]  [<c024ac50>] autoremove_wake_function+0x20/0x40
[  106.499348]  [<c0252418>] __wake_up_common+0x48/0x70
[  106.499348]  [<c02558b3>] __wake_up_sync_key+0x43/0x60
[  106.499348]  [<c04cf4f8>] sock_def_readable+0x38/0x60
[  106.499348]  [<c0560065>] unix_stream_sendmsg+0x215/0x3a0
[  106.499348]  [<c04cb848>] sock_aio_write+0xf8/0x110
[  106.499348]  [<c02ee6bc>] do_sync_write+0xac/0xf0
[  106.499348]  [<c02ef1e6>] vfs_write+0x126/0x140
[  106.499348]  [<c02ef3e2>] sys_write+0x42/0x70
[  106.499348]  [<c0607c4c>] sysenter_do_call+0x12/0x22
[  106.499348] ---[ end trace 68da413eff30529e ]---
[  106.499348]  [<c0281bb0>] ? watchdog_timer_fn+0x170/0x170
[  106.499348]  [<c022a2e3>] warn_slowpath_fmt+0x33/0x40
[  106.499348]  [<c0281c4c>] watchdog_overflow_callback+0x9c/0xc0
[  106.499348]  [<c02a9f9a>] __perf_event_overflow+0x9a/0x240
[  106.499348]  [<c02ff240>] ? poll_freewait+0xb0/0xb0
[  106.499348]  [<c02100c8>] ? x86_perf_event_set_period+0x118/0x210
[  106.499348]  [<c02aa7f5>] perf_event_overflow+0x15/0x20
[  106.499348]  [<c0213639>] intel_pmu_handle_irq+0x129/0x250
[  106.499348]  [<c020ed80>] perf_event_nmi_handler+0x20/0x30
[  106.499348]  [<c0205d87>] do_nmi+0xb7/0x350
[  106.499348]  [<c0607a99>] nmi_stack_correct+0x28/0x2d
[  106.499348]  [<c0259d32>] ? try_to_wake_up+0xa2/0x220
[  106.499348]  [<c0259ec0>] default_wake_function+0x10/0x20
[  106.499348]  [<c024ac50>] autoremove_wake_function+0x20/0x40
[  106.499348]  [<c0252418>] __wake_up_common+0x48/0x70
[  106.499348]  [<c02558b3>] __wake_up_sync_key+0x43/0x60
[  106.499348]  [<c04cf4f8>] sock_def_readable+0x38/0x60
[  106.499348]  [<c0560065>] unix_stream_sendmsg+0x215/0x3a0
[  106.499348]  [<c04cb848>] sock_aio_write+0xf8/0x110
[  106.499348]  [<c02ee6bc>] do_sync_write+0xac/0xf0
[  106.499348]  [<c02ef1e6>] vfs_write+0x126/0x140
[  106.499348]  [<c02ef3e2>] sys_write+0x42/0x70
[  106.499348]  [<c0607c4c>] sysenter_do_call+0x12/0x22
[  106.499348] ---[ end trace 68da413eff30529f ]---
[  106.551612] ------------[ cut here ]------------
[  106.551612] WARNING: at kernel/watchdog.c:241
watchdog_overflow_callback+0x9c/0xc0()
[  106.551612] Hardware name: ProLiant BL460c G1
[  106.551612] Watchdog detected hard LOCKUP on cpu 4
[  106.551612] Modules linked in: netconsole xt_hashlimit af_packet tg3
bonding
[  106.551612] Pid: 5697, comm: hackbench Tainted: G        W
3.2.0-05066-g31ae26a-dirty #774
[  106.551612] Call Trace:
[  106.551612]  [<c022a212>] warn_slowpath_common+0x72/0xa0
[  106.551612]  [<c0281c4c>] ? watchdog_overflow_callback+0x9c/0xc0
[  106.551612]  [<c0281c4c>] ? watchdog_overflow_callback+0x9c/0xc0
[  106.551612]  [<c0281bb0>] ? watchdog_timer_fn+0x170/0x170
[  106.551612]  [<c022a2e3>] warn_slowpath_fmt+0x33/0x40
[  106.551612]  [<c0281c4c>] watchdog_overflow_callback+0x9c/0xc0
[  106.551612]  [<c02a9f9a>] __perf_event_overflow+0x9a/0x240
[  106.551612]  [<c02100c8>] ? x86_perf_event_set_period+0x118/0x210
[  106.551612]  [<c02aa7f5>] perf_event_overflow+0x15/0x20
[  106.551612]  [<c0213639>] intel_pmu_handle_irq+0x129/0x250
[  106.551612]  [<c025dee0>] ? find_busiest_group+0x150/0xae0
[  106.551612]  [<c020ed80>] perf_event_nmi_handler+0x20/0x30
[  106.551612]  [<c0205d87>] do_nmi+0xb7/0x350
[  106.551612]  [<c0607a99>] nmi_stack_correct+0x28/0x2d
[  106.551612]  [<c0606be4>] ? _raw_spin_lock+0x24/0x30
[  106.551612]  [<c025ebc8>] load_balance+0x358/0x500
[  106.551612]  [<c025f092>] idle_balance+0xc2/0x140
[  106.551612]  [<c06060ae>] __schedule+0x4be/0x650
[  106.551612]  [<c02e8485>] ? __slab_free+0x155/0x270
[  106.551612]  [<c06062f5>] schedule+0x35/0x50
[  106.551612]  [<c0604b0d>] schedule_timeout+0x1dd/0x250
[  106.551612]  [<c0560eb0>] ? unix_destruct_scm+0x80/0xa0
[  106.551612]  [<c02e8688>] ? kmem_cache_free+0xe8/0x100
[  106.551612]  [<c04d376d>] ? __kfree_skb+0x3d/0x90
[  106.551612]  [<c04d376d>] ? __kfree_skb+0x3d/0x90
[  106.551612]  [<c04d376d>] ? __kfree_skb+0x3d/0x90
[  106.551612]  [<c024ae88>] ? prepare_to_wait+0x48/0x70
[  106.551612]  [<c05612bd>] unix_stream_recvmsg+0x3ed/0x570
[  106.551612]  [<c024ac30>] ? wake_up_bit+0x30/0x30
[  106.551612]  [<c04cb967>] sock_aio_read+0x107/0x110
[  106.551612]  [<c02ee7ac>] do_sync_read+0xac/0xf0
[  106.551612]  [<c0230407>] ? irq_exit+0x67/0xa0
[  106.551612]  [<c0608349>] ? smp_apic_timer_interrupt+0x59/0x88
[  106.551612]  [<c025b829>] ? sched_clock_cpu+0x109/0x1a0
[  106.551612]  [<c02ef31f>] vfs_read+0x11f/0x130
[  106.551612]  [<c02ef372>] sys_read+0x42/0x70
[  106.551612]  [<c0607c4c>] sysenter_do_call+0x12/0x22
[  106.551612] ---[ end trace 68da413eff3052a0 ]---
[  106.642705] ------------[ cut here ]------------
[  106.642705] WARNING: at kernel/watchdog.c:241
watchdog_overflow_callback+0x9c/0xc0()
[  106.642705] Hardware name: ProLiant BL460c G1
[  106.642705] Watchdog detected hard LOCKUP on cpu 1
[  106.642705] Modules linked in: netconsole xt_hashlimit af_packet tg3
bonding
[  106.642705] Pid: 5607, comm: hackbench Tainted: G        W
3.2.0-05066-g31ae26a-dirty #774
[  106.642705] Call Trace:
[  106.642705]  [<c022a212>] warn_slowpath_common+0x72/0xa0
[  106.642705]  [<c0281c4c>] ? watchdog_overflow_callback+0x9c/0xc0
[  106.642705]  [<c0281c4c>] ? watchdog_overflow_callback+0x9c/0xc0
[  106.642705]  [<c0281bb0>] ? watchdog_timer_fn+0x170/0x170
[  106.642705]  [<c022a2e3>] warn_slowpath_fmt+0x33/0x40
[  106.642705]  [<c0281c4c>] watchdog_overflow_callback+0x9c/0xc0
[  106.642705]  [<c02a9f9a>] __perf_event_overflow+0x9a/0x240
[  106.642705]  [<c02100c8>] ? x86_perf_event_set_period+0x118/0x210
[  106.642705]  [<c02aa7f5>] perf_event_overflow+0x15/0x20
[  106.642705]  [<c0213639>] intel_pmu_handle_irq+0x129/0x250
[  106.642705]  [<c020ed80>] perf_event_nmi_handler+0x20/0x30
[  106.642705]  [<c0205d87>] do_nmi+0xb7/0x350
[  106.642705]  [<c02100c8>] ? x86_perf_event_set_period+0x118/0x210
[  106.642705]  [<c0607a99>] nmi_stack_correct+0x28/0x2d
[  106.642705]  [<c021007b>] ? x86_perf_event_set_period+0xcb/0x210
[  106.642705]  [<c0259d32>] ? try_to_wake_up+0xa2/0x220
[  106.642705]  [<c0259ec0>] default_wake_function+0x10/0x20
[  106.642705]  [<c024ac50>] autoremove_wake_function+0x20/0x40
[  106.642705]  [<c0252418>] __wake_up_common+0x48/0x70
[  106.642705]  [<c02558b3>] __wake_up_sync_key+0x43/0x60
[  106.642705]  [<c04cf4f8>] sock_def_readable+0x38/0x60
[  106.642705]  [<c0560065>] unix_stream_sendmsg+0x215/0x3a0
[  106.642705]  [<c04cb848>] sock_aio_write+0xf8/0x110
[  106.642705]  [<c02ee6bc>] do_sync_write+0xac/0xf0
[  106.642705]  [<c03ae78a>] ? rb_erase+0x16a/0x290
[  106.642705]  [<c0230407>] ? irq_exit+0x67/0xa0
[  106.642705]  [<c0608349>] ? smp_apic_timer_interrupt+0x59/0x88
[  106.642705]  [<c02ef1e6>] vfs_write+0x126/0x140
[  106.642705]  [<c02ef3e2>] sys_write+0x42/0x70
[  106.642705]  [<c0607c4c>] sysenter_do_call+0x12/0x22
[  106.642705] ---[ end trace 68da413eff3052a1 ]---
[  107.650001] ------------[ cut here ]------------
[  107.650001] WARNING: at kernel/watchdog.c:241
watchdog_overflow_callback+0x9c/0xc0()
[  107.650001] Hardware name: ProLiant BL460c G1
[  107.650001] Watchdog detected hard LOCKUP on cpu 5
[  107.650001] Modules linked in: netconsole xt_hashlimit af_packet tg3
bonding
[  107.650001] Pid: 5844, comm: hackbench Tainted: G        W
3.2.0-05066-g31ae26a-dirty #774
[  107.650001] Call Trace:
[  107.650001]  [<c022a212>] warn_slowpath_common+0x72/0xa0
[  107.650001]  [<c0281c4c>] ? watchdog_overflow_callback+0x9c/0xc0
[  107.650001]  [<c0281c4c>] ? watchdog_overflow_callback+0x9c/0xc0
[  107.650001]  [<c0281bb0>] ? watchdog_timer_fn+0x170/0x170
[  107.650001]  [<c022a2e3>] warn_slowpath_fmt+0x33/0x40
[  107.650001]  [<c0281c4c>] watchdog_overflow_callback+0x9c/0xc0
[  107.650001]  [<c02a9f9a>] __perf_event_overflow+0x9a/0x240
[  107.650001]  [<c02100c8>] ? x86_perf_event_set_period+0x118/0x210
[  107.650001]  [<c02aa7f5>] perf_event_overflow+0x15/0x20
[  107.650001]  [<c0213639>] intel_pmu_handle_irq+0x129/0x250
[  107.650001]  [<c02a80f0>] ? perf_event_update_userpage+0x10/0x150
[  107.650001]  [<c02a80f0>] ? perf_event_update_userpage+0x10/0x150
[  107.650001]  [<c020ed80>] perf_event_nmi_handler+0x20/0x30
[  107.650001]  [<c0205d87>] do_nmi+0xb7/0x350
[  107.650001]  [<c0607a99>] nmi_stack_correct+0x28/0x2d
[  107.650001]  [<c025de79>] ? find_busiest_group+0xe9/0xae0
[  107.650001]  [<c025e8df>] load_balance+0x6f/0x500
[  107.650001]  [<c025f092>] idle_balance+0xc2/0x140
[  107.650001]  [<c06060ae>] __schedule+0x4be/0x650
[  107.650001]  [<c030359d>] ? d_hash_and_lookup+0x5d/0x80
[  107.650001]  [<c02880f2>] ? call_rcu_sched+0x12/0x20
[  107.650001]  [<c02880f2>] ? call_rcu_sched+0x12/0x20
[  107.650001]  [<c022c4bd>] ? release_task+0x1dd/0x310
[  107.650001]  [<c06062f5>] schedule+0x35/0x50
[  107.650001]  [<c022d838>] do_exit+0x4f8/0x760
[  107.650001]  [<c02ef1bc>] ? vfs_write+0xfc/0x140
[  107.650001]  [<c022dc88>] sys_exit+0x18/0x20
[  107.650001]  [<c0606f9d>] syscall_call+0x7/0xb
[  107.650001] ---[ end trace 68da413eff3052a2 ]---
[  106.620008] ------------[ cut here ]------------
[  106.620008] WARNING: at kernel/watchdog.c:241
watchdog_overflow_callback+0x9c/0xc0()
[  106.620008] Hardware name: ProLiant BL460c G1
[  106.620008] Watchdog detected hard LOCKUP on cpu 2
[  106.620008] Modules linked in: netconsole xt_hashlimit af_packet tg3
bonding
[  106.620008] Pid: 5876, comm: hackbench Tainted: G        W
3.2.0-05066-g31ae26a-dirty #774
[  106.620008] Call Trace:
[  106.620008]  [<c022a212>] warn_slowpath_common+0x72/0xa0
[  106.620008]  [<c0281c4c>] ? watchdog_overflow_callback+0x9c/0xc0
[  106.620008]  [<c0281c4c>] ? watchdog_overflow_callback+0x9c/0xc0
[  106.620008]  [<c0281bb0>] ? watchdog_timer_fn+0x170/0x170
[  106.620008]  [<c022a2e3>] warn_slowpath_fmt+0x33/0x40
[  106.620008]  [<c0281c4c>] watchdog_overflow_callback+0x9c/0xc0
[  106.620008]  [<c02a9f9a>] __perf_event_overflow+0x9a/0x240
[  106.620008]  [<c02100c8>] ? x86_perf_event_set_period+0x118/0x210
[  106.620008]  [<c02aa7f5>] perf_event_overflow+0x15/0x20
[  106.620008]  [<c0213639>] intel_pmu_handle_irq+0x129/0x250
[  106.620008]  [<c0605de7>] ? __schedule+0x1f7/0x650
[  106.620008]  [<c020ed80>] perf_event_nmi_handler+0x20/0x30
[  106.620008]  [<c0205d87>] do_nmi+0xb7/0x350
[  106.620008]  [<c0560e30>] ? unix_seqpacket_recvmsg+0x50/0x50
[  106.620008]  [<c0607a99>] nmi_stack_correct+0x28/0x2d
[  106.620008]  [<c0606c14>] ? _raw_spin_lock_irqsave+0x24/0x30
[  106.620008]  [<c024ae62>] prepare_to_wait+0x22/0x70
[  106.620008]  [<c04cfb25>] sock_alloc_send_pskb+0x105/0x290
[  106.620008]  [<c024ac30>] ? wake_up_bit+0x30/0x30
[  106.620008]  [<c04cfccd>] sock_alloc_send_skb+0x1d/0x30
[  106.620008]  [<c05600bd>] unix_stream_sendmsg+0x26d/0x3a0
[  106.620008]  [<c04cb848>] sock_aio_write+0xf8/0x110
[  106.620008]  [<c02ee6bc>] do_sync_write+0xac/0xf0
[  106.620008]  [<c02ef1e6>] vfs_write+0x126/0x140
[  106.620008]  [<c02ef3e2>] sys_write+0x42/0x70
[  106.620008]  [<c0607c4c>] sysenter_do_call+0x12/0x22
[  106.620008] ---[ end trace 68da413eff3052a3 ]---
[  106.630004] ------------[ cut here ]------------
[  106.630004] WARNING: at kernel/watchdog.c:241
watchdog_overflow_callback+0x9c/0xc0()
[  106.630004] Hardware name: ProLiant BL460c G1
[  106.630004] Watchdog detected hard LOCKUP on cpu 7
[  106.630004] Modules linked in: netconsole xt_hashlimit af_packet tg3
bonding
[  106.630004] Pid: 5580, comm: hackbench Tainted: G        W
3.2.0-05066-g31ae26a-dirty #774
[  106.630004] Call Trace:
[  106.630004]  [<c022a212>] warn_slowpath_common+0x72/0xa0
[  106.630004]  [<c0281c4c>] ? watchdog_overflow_callback+0x9c/0xc0
[  106.630004]  [<c0281c4c>] ? watchdog_overflow_callback+0x9c/0xc0
[  106.630004]  [<c0281bb0>] ? watchdog_timer_fn+0x170/0x170
[  106.630004]  [<c022a2e3>] warn_slowpath_fmt+0x33/0x40
[  106.630004]  [<c0281c4c>] watchdog_overflow_callback+0x9c/0xc0
[  106.630004]  [<c02a9f9a>] __perf_event_overflow+0x9a/0x240
[  106.630004]  [<c02100c8>] ? x86_perf_event_set_period+0x118/0x210
[  106.630004]  [<c02aa7f5>] perf_event_overflow+0x15/0x20
[  106.630004]  [<c0213639>] intel_pmu_handle_irq+0x129/0x250
[  106.630004]  [<c025b829>] ? sched_clock_cpu+0x109/0x1a0
[  106.630004]  [<c025b829>] ? sched_clock_cpu+0x109/0x1a0
[  106.630004]  [<c02a80f0>] ? perf_event_update_userpage+0x10/0x150
[  106.630004]  [<c02a80f0>] ? perf_event_update_userpage+0x10/0x150
[  106.630004]  [<c020ed80>] perf_event_nmi_handler+0x20/0x30
[  106.630004]  [<c0205d87>] do_nmi+0xb7/0x350
[  106.630004]  [<c02100c8>] ? x86_perf_event_set_period+0x118/0x210
[  106.630004]  [<c0607a99>] nmi_stack_correct+0x28/0x2d
[  106.630004]  [<c025ddc8>] ? find_busiest_group+0x38/0xae0
[  106.630004]  [<c025e8df>] load_balance+0x6f/0x500
[  106.630004]  [<c025f092>] idle_balance+0xc2/0x140
[  106.630004]  [<c06060ae>] __schedule+0x4be/0x650
[  106.630004]  [<c02b4f8f>] ? __free_pages+0x1f/0x40
[  106.630004]  [<c02e65d7>] ? __free_slab+0xa7/0x130
[  106.630004]  [<c02e8485>] ? __slab_free+0x155/0x270
[  106.630004]  [<c02eb1d6>] ? __kmalloc_node_track_caller+0xf6/0x1b0
[  106.630004]  [<c06062f5>] schedule+0x35/0x50
[  106.630004]  [<c0604b0d>] schedule_timeout+0x1dd/0x250
[  106.630004]  [<c0560eb0>] ? unix_destruct_scm+0x80/0xa0
[  106.630004]  [<c02e8688>] ? kmem_cache_free+0xe8/0x100
[  106.630004]  [<c04d376d>] ? __kfree_skb+0x3d/0x90
[  106.630004]  [<c04d376d>] ? __kfree_skb+0x3d/0x90
[  106.630004]  [<c04d376d>] ? __kfree_skb+0x3d/0x90
[  106.630004]  [<c024ae88>] ? prepare_to_wait+0x48/0x70
[  106.630004]  [<c05612bd>] unix_stream_recvmsg+0x3ed/0x570
[  106.630004]  [<c024ac30>] ? wake_up_bit+0x30/0x30
[  106.630004]  [<c04cb967>] sock_aio_read+0x107/0x110
[  106.630004]  [<c02ee7ac>] do_sync_read+0xac/0xf0
[  106.630004]  [<c025b5b2>] ? sched_clock_local+0xe2/0x1e0
[  106.630004]  [<c025b829>] ? sched_clock_cpu+0x109/0x1a0
[  106.630004]  [<c02ef31f>] vfs_read+0x11f/0x130
[  106.630004]  [<c02ef372>] sys_read+0x42/0x70
[  106.630004]  [<c0607c4c>] sysenter_do_call+0x12/0x22
[  106.630004] ---[ end trace 68da413eff3052a4 ]---
[  106.755402] ------------[ cut here ]------------
[  106.755402] WARNING: at kernel/watchdog.c:241
watchdog_overflow_callback+0x9c/0xc0()
[  106.755402] Hardware name: ProLiant BL460c G1
[  106.755402] Watchdog detected hard LOCKUP on cpu 6
[  106.755402] Modules linked in: netconsole xt_hashlimit af_packet tg3
bonding
[  106.755402] Pid: 5863, comm: hackbench Tainted: G        W
3.2.0-05066-g31ae26a-dirty #774
[  106.755402] Call Trace:
[  106.755402]  [<c022a212>] warn_slowpath_common+0x72/0xa0
[  106.755402]  [<c0281c4c>] ? watchdog_overflow_callback+0x9c/0xc0
[  106.755402]  [<c0281c4c>] ? watchdog_overflow_callback+0x9c/0xc0
[  106.755402]  [<c0281bb0>] ? watchdog_timer_fn+0x170/0x170
[  106.755402]  [<c022a2e3>] warn_slowpath_fmt+0x33/0x40
[  106.755402]  [<c0281c4c>] watchdog_overflow_callback+0x9c/0xc0
[  106.755402]  [<c02a9f9a>] __perf_event_overflow+0x9a/0x240
[  106.755402]  [<c02100c8>] ? x86_perf_event_set_period+0x118/0x210
[  106.755402]  [<c02aa7f5>] perf_event_overflow+0x15/0x20
[  106.755402]  [<c0213639>] intel_pmu_handle_irq+0x129/0x250
[  106.755402]  [<c025b5b2>] ? sched_clock_local+0xe2/0x1e0
[  106.755402]  [<c025b784>] ? sched_clock_cpu+0x64/0x1a0
[  106.755402]  [<c020ed80>] perf_event_nmi_handler+0x20/0x30
[  106.755402]  [<c0205d87>] do_nmi+0xb7/0x350
[  106.755402]  [<c025ceb3>] ? check_preempt_wakeup+0xb3/0x180
[  106.755402]  [<c0607a99>] nmi_stack_correct+0x28/0x2d
[  106.755402]  [<c0259d30>] ? try_to_wake_up+0xa0/0x220
[  106.755402]  [<c0259ec0>] default_wake_function+0x10/0x20
[  106.755402]  [<c024ac50>] autoremove_wake_function+0x20/0x40
[  106.755402]  [<c0252418>] __wake_up_common+0x48/0x70
[  106.755402]  [<c02558b3>] __wake_up_sync_key+0x43/0x60
[  106.755402]  [<c0560399>] unix_write_space+0x49/0x80
[  106.755402]  [<c04cff58>] sock_wfree+0x48/0x50
[  106.755402]  [<c0560eb0>] unix_destruct_scm+0x80/0xa0
[  106.755402]  [<c04d396d>] skb_release_head_state+0x4d/0xe0
[  106.755402]  [<c04d3740>] __kfree_skb+0x10/0x90
[  106.755402]  [<c04d37e7>] consume_skb+0x27/0x70
[  106.755402]  [<c05610b6>] unix_stream_recvmsg+0x1e6/0x570
[  106.755402]  [<c024ac30>] ? wake_up_bit+0x30/0x30
[  106.755402]  [<c04cb967>] sock_aio_read+0x107/0x110
[  106.755402]  [<c02ee7ac>] do_sync_read+0xac/0xf0
[  106.755402]  [<c02ef31f>] vfs_read+0x11f/0x130
[  106.755402]  [<c02ef372>] sys_read+0x42/0x70
[  106.755402]  [<c0607c4c>] sysenter_do_call+0x12/0x22
[  106.755402] ---[ end trace 68da413eff3052a5 ]---
[  106.610006] ------------[ cut here ]------------
[  106.610006] WARNING: at kernel/watchdog.c:241
watchdog_overflow_callback+0x9c/0xc0()
[  106.610006] Hardware name: ProLiant BL460c G1
[  106.610006] Watchdog detected hard LOCKUP on cpu 3
[  106.610006] Modules linked in: netconsole xt_hashlimit af_packet tg3
bonding
[  106.610006] Pid: 5887, comm: hackbench Tainted: G        W
3.2.0-05066-g31ae26a-dirty #774
[  106.610006] Call Trace:
[  106.610006]  [<c022a212>] warn_slowpath_common+0x72/0xa0
[  106.610006]  [<c0281c4c>] ? watchdog_overflow_callback+0x9c/0xc0
[  106.610006]  [<c0281c4c>] ? watchdog_overflow_callback+0x9c/0xc0
[  106.610006]  [<c0281bb0>] ? watchdog_timer_fn+0x170/0x170
[  106.610006]  [<c022a2e3>] warn_slowpath_fmt+0x33/0x40
[  106.610006]  [<c0281c4c>] watchdog_overflow_callback+0x9c/0xc0
[  106.610006]  [<c02a9f9a>] __perf_event_overflow+0x9a/0x240
[  106.610006]  [<c02100c8>] ? x86_perf_event_set_period+0x118/0x210
[  106.610006]  [<c02aa7f5>] perf_event_overflow+0x15/0x20
[  106.610006]  [<c0213639>] intel_pmu_handle_irq+0x129/0x250
[  106.610006]  [<c03a90c8>] ? cpumask_next_and+0x28/0x40
[  106.610006]  [<c020ed80>] perf_event_nmi_handler+0x20/0x30
[  106.610006]  [<c0205d87>] do_nmi+0xb7/0x350
[  106.610006]  [<c0607a99>] nmi_stack_correct+0x28/0x2d
[  106.610006]  [<c025ea97>] ? load_balance+0x227/0x500
[  106.610006]  [<c025f092>] idle_balance+0xc2/0x140
[  106.610006]  [<c06060ae>] __schedule+0x4be/0x650
[  106.610006]  [<c025951e>] ? scheduler_ipi+0x7e/0xc0
[  106.610006]  [<c06070de>] ? reschedule_interrupt+0x2a/0x30
[  106.610006]  [<c03b48ba>] ? __copy_from_user_ll_nozero+0x4a/0x80
[  106.610006]  [<c06062f5>] schedule+0x35/0x50
[  106.610006]  [<c0604b0d>] schedule_timeout+0x1dd/0x250
[  106.610006]  [<c024ae88>] ? prepare_to_wait+0x48/0x70
[  106.610006]  [<c04cfb4c>] sock_alloc_send_pskb+0x12c/0x290
[  106.610006]  [<c024ac30>] ? wake_up_bit+0x30/0x30
[  106.610006]  [<c04cfccd>] sock_alloc_send_skb+0x1d/0x30
[  106.610006]  [<c05600bd>] unix_stream_sendmsg+0x26d/0x3a0
[  106.610006]  [<c04cb848>] sock_aio_write+0xf8/0x110
[  106.610006]  [<c02ee6bc>] do_sync_write+0xac/0xf0
[  106.610006]  [<c03ae5dc>] ? rb_insert_color+0xcc/0x110
[  106.610006]  [<c02ef1e6>] vfs_write+0x126/0x140
[  106.610006]  [<c02ef3e2>] sys_write+0x42/0x70
[  106.610006]  [<c0607c4c>] sysenter_do_call+0x12/0x22
[  106.610006] ---[ end trace 68da413eff3052a6 ]---


