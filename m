Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932886Ab2AKL3d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 06:29:33 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:39724 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756275Ab2AKL3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 06:29:31 -0500
Message-ID: <1326281367.2767.17.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: [BUG] kernel freezes with latest tree
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: David Ahern <dsahern@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Date: Wed, 11 Jan 2012 12:29:27 +0100
In-Reply-To: <1326277729.2767.5.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
References: <1326171444.6638.3.camel@edumazet-laptop>
	 <1326171798.6638.4.camel@edumazet-laptop>
	 <1326183371.6638.6.camel@edumazet-laptop>
	 <1326212033.19095.3.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <CA+55aFwNVutn=Z8N9k3CHLri=EKWX2UcN8skZvMfJ9Tg1LHCpg@mail.gmail.com>
	 <1326213442.19095.9.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <CA+55aFyyZUJHELdbKfk2Gzpx9np7Ov74idttCo6+wi2+MAVG=g@mail.gmail.com>
	 <1326214407.19095.11.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <CA+55aFzUSMVD84acwDGC_mqBUWg-6rdy6n_BfP6up+_V3oGx7A@mail.gmail.com>
	 <1326234230.2614.15.camel@edumazet-laptop>
	 <CA+55aFwYmX7q4MZc-xOStZB2ZQjVt_Jca6qDP+0cPKekz8yL+A@mail.gmail.com>
	 <4F0D2D9B.8030501@gmail.com> <1326272685.2442.120.camel@twins>
	 <1326277729.2767.5.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 11 janvier 2012 à 11:28 +0100, Eric Dumazet a écrit :

> I let my machine run 3.2 kernel for 37 minutes with no hang, so at least
> we know there is no hardware glitch.
> 
> $ uptime
>  11:26:45 up 37 min,  2 users,  load average: 201.80, 206.06, 170.68
> 
> I'll try now latest tree with a195f004 reverted.

So the revert of a195f004 seems to solve the problem here.

$ uptime
 12:19:55 up 39 min,  2 users,  load average: 191.05, 200.91, 183.59


While vanilla current tree freezes in less than 15 seconds.

$ while :; do hackbench 10 thread 1000; done
Running with 10*40 (== 400) tasks.
Time: 3.035
Running with 10*40 (== 400) tasks.
Time: 3.045
Running with 10*40 (== 400) tasks.
Time: 3.089
Running with 10*40 (== 400) tasks.
Time: 2.995
Running with 10*40 (== 400) tasks.
<hang>


[   79.182001] ------------[ cut here ]------------
[   79.182001] WARNING: at kernel/watchdog.c:241 watchdog_overflow_callback+0x9c/0xc0()
[   79.182001] Hardware name: ProLiant BL460c G1
[   79.182001] Watchdog detected hard LOCKUP on cpu 0
[   79.182001] Modules linked in: netconsole xt_hashlimit af_packet tg3 bonding
[   79.182001] Pid: 6948, comm: hackbench Not tainted 3.2.0-06100-ge343a89 #12
[   79.182001] Call Trace:
[   79.182001]  [<c0229c42>] warn_slowpath_common+0x72/0xa0
[   79.182001]  [<c027f31c>] ? watchdog_overflow_callback+0x9c/0xc0
[   79.182001]  [<c027f31c>] ? watchdog_overflow_callback+0x9c/0xc0
[   79.182001]  [<c027f280>] ? touch_nmi_watchdog+0x70/0x70
[   79.182001]  [<c0229d13>] warn_slowpath_fmt+0x33/0x40
[   79.182001]  [<c027f31c>] watchdog_overflow_callback+0x9c/0xc0
[   79.182001]  [<c02a72d5>] __perf_event_overflow+0x95/0x220
[   79.182001]  [<c0210039>] ? x86_perf_event_set_period+0x119/0x210
[   79.182001]  [<c02a7b25>] perf_event_overflow+0x15/0x20
[   79.182001]  [<c0213545>] intel_pmu_handle_irq+0x125/0x260
[   79.182001]  [<c025d1a0>] ? find_busiest_group+0x150/0xaa0
[   79.182001] ------------[ cut here ]------------
[   79.182001] WARNING: at kernel/softirq.c:159 local_bh_enable_ip+0x60/0x90()
[   79.182001] Hardware name: ProLiant BL460c G1
[   79.182001] Modules linked in: netconsole xt_hashlimit af_packet tg3 bonding
[   79.182001] Pid: 6948, comm: hackbench Not tainted 3.2.0-06100-ge343a89 #12
[   79.182001] Call Trace:
[   79.182001]  [<c05ffeba>] ? printk+0x1d/0x1f
[   79.182001]  [<c0229c42>] warn_slowpath_common+0x72/0xa0
[   79.182001]  [<c022f8c0>] ? local_bh_enable_ip+0x60/0x90
[   79.182001]  [<c022f8c0>] ? local_bh_enable_ip+0x60/0x90
[   79.182001]  [<c0229c92>] warn_slowpath_null+0x22/0x30
[   79.182001]  [<c022f8c0>] local_bh_enable_ip+0x60/0x90
[   79.182001]  [<c0606683>] _raw_spin_unlock_bh+0x13/0x20
[   79.182001]  [<c046cc29>] bnx2_reg_rd_ind+0x39/0x50
[   79.182001]  [<c046cc53>] bnx2_shmem_rd+0x13/0x20
[   79.182001]  [<c0477a53>] bnx2_poll+0x103/0x1f0
[   79.182001]  [<c046ff33>] ? poll_bnx2+0x73/0x90
[   79.182001]  [<c04e9ee1>] netpoll_poll_dev.part.26+0x3d1/0x4d0
[   79.182001]  [<c02e7cdd>] ? __kmalloc_node_track_caller+0x2d/0x1f0
[   79.182001]  [<c04cbec1>] ? __alloc_skb+0x31/0x220
[   79.182001]  [<c04ea195>] netpoll_send_skb_on_dev+0x1b5/0x200
[   79.182001]  [<c04cbef9>] ? __alloc_skb+0x69/0x220
[   79.182001]  [<c04e9aad>] ? find_skb.isra.27+0x3d/0xa0
[   79.182001]  [<c04ea3a3>] netpoll_send_udp+0x1c3/0x1e0
[   79.182001]  [<f868321c>] write_msg+0x8c/0xb4 [netconsole]
[   79.182001]  [<f8683190>] ? netconsole_netdev_event+0x190/0x190 [netconsole]
[   79.182001]  [<c0229dcd>] __call_console_drivers+0x7d/0x90
[   79.182001]  [<c0229ffd>] _call_console_drivers+0x4d/0x90
[   79.182001]  [<c022a2c3>] console_unlock+0xf3/0x230
[   79.182001]  [<c022a7bb>] vprintk+0x2db/0x3f0
[   79.182001]  [<c024fb9a>] ? up+0x2a/0x40
[   79.182001]  [<c025d1a0>] ? find_busiest_group+0x150/0xaa0
[   79.182001]  [<c05ffeba>] printk+0x1d/0x1f
[   79.182001]  [<c02055e2>] printk_address+0x32/0x40
[   79.182001]  [<c025d1a0>] ? find_busiest_group+0x150/0xaa0
[   79.182001]  [<c025d1a0>] ? find_busiest_group+0x150/0xaa0
[   79.182001]  [<c0205620>] print_trace_address+0x30/0x40
[   79.182001]  [<c020552c>] print_context_stack+0x7c/0x100
[   79.182001]  [<c025d1a0>] ? find_busiest_group+0x150/0xaa0
[   79.182001]  [<c02045cf>] dump_trace+0x7f/0xf0
[   79.182001]  [<c020567c>] show_trace_log_lvl+0x4c/0x60
[   79.182001]  [<c02056af>] show_trace+0x1f/0x30
[   79.182001]  [<c05feebb>] dump_stack+0x73/0x7a
[   79.182001]  [<c0229c42>] warn_slowpath_common+0x72/0xa0
[   79.182001]  [<c027f31c>] ? watchdog_overflow_callback+0x9c/0xc0
[   79.182001]  [<c027f31c>] ? watchdog_overflow_callback+0x9c/0xc0
[   79.182001]  [<c027f280>] ? touch_nmi_watchdog+0x70/0x70
[   79.182001]  [<c0229d13>] warn_slowpath_fmt+0x33/0x40
[   79.182001]  [<c027f31c>] watchdog_overflow_callback+0x9c/0xc0
[   79.182001]  [<c02a72d5>] __perf_event_overflow+0x95/0x220
[   79.182001]  [<c0210039>] ? x86_perf_event_set_period+0x119/0x210
[   79.182001]  [<c02a7b25>] perf_event_overflow+0x15/0x20
[   79.182001]  [<c0213545>] intel_pmu_handle_irq+0x125/0x260
[   79.182001]  [<c025d1a0>] ? find_busiest_group+0x150/0xaa0
[   79.182001]  [<c020f330>] perf_event_nmi_handler+0x20/0x30
[   79.182001]  [<c0205bf7>] do_nmi+0xc7/0x380
[   79.182001]  [<c0607359>] nmi_stack_correct+0x28/0x2d
[   79.182001]  [<c06064a2>] ? _raw_spin_lock+0x22/0x30
[   79.182001]  [<c025dc90>] load_balance+0x1a0/0x510
[   79.182001]  [<c025e21a>] idle_balance+0xca/0x140
[   79.182001]  [<c0605ae4>] __schedule+0x4c4/0x640
[   79.182001]  [<c033b5db>] ? proc_flush_task+0xcb/0x1a0
[   79.182001]  [<c02857d2>] ? call_rcu_sched+0x12/0x20
[   79.182001]  [<c022bae0>] ? allow_signal+0x70/0x70
[   79.182001]  [<c02857d2>] ? call_rcu_sched+0x12/0x20
[   79.182001]  [<c022be31>] ? release_task+0x1e1/0x320
[   79.182001]  [<c0605d15>] schedule+0x35/0x50
[   79.182001]  [<c022d14f>] do_exit+0x4ef/0x750
[   79.182001]  [<c02ebdc7>] ? vfs_write+0xf7/0x150
[   79.182001]  [<c022d608>] sys_exit+0x18/0x20
[   79.182001]  [<c060685d>] syscall_call+0x7/0xb
[   79.182001] ---[ end trace 3d1cedd589a9a5c3 ]---
[   79.182001]  [<c020f330>] perf_event_nmi_handler+0x20/0x30
[   79.182001]  [<c0205bf7>] do_nmi+0xc7/0x380
[   79.182001]  [<c0607359>] nmi_stack_correct+0x28/0x2d
[   79.182001]  [<c06064a2>] ? _raw_spin_lock+0x22/0x30
[   79.182001]  [<c025dc90>] load_balance+0x1a0/0x510
[   79.182001]  [<c025e21a>] idle_balance+0xca/0x140
[   79.182001]  [<c0605ae4>] __schedule+0x4c4/0x640
[   79.182001]  [<c033b5db>] ? proc_flush_task+0xcb/0x1a0
[   79.182001]  [<c02857d2>] ? call_rcu_sched+0x12/0x20
[   79.182001]  [<c022bae0>] ? allow_signal+0x70/0x70
[   79.182001]  [<c02857d2>] ? call_rcu_sched+0x12/0x20
[   79.182001]  [<c022be31>] ? release_task+0x1e1/0x320
[   79.182001]  [<c0605d15>] schedule+0x35/0x50
[   79.182001]  [<c022d14f>] do_exit+0x4ef/0x750
[   79.182001]  [<c02ebdc7>] ? vfs_write+0xf7/0x150
[   79.182001]  [<c022d608>] sys_exit+0x18/0x20
[   79.182001]  [<c060685d>] syscall_call+0x7/0xb
[   79.182001] ---[ end trace 3d1cedd589a9a5c4 ]---
[   79.089368] ------------[ cut here ]------------
[   79.089368] WARNING: at kernel/watchdog.c:241 watchdog_overflow_callback+0x9c/0xc0()
[   79.089368] Hardware name: ProLiant BL460c G1
[   79.089368] Watchdog detected hard LOCKUP on cpu 1
[   79.089368] Modules linked in: netconsole xt_hashlimit af_packet tg3 bonding
[   79.089368] Pid: 4211, comm: Com Tainted: G        W    3.2.0-06100-ge343a89 #12
[   79.089368] Call Trace:
[   79.089368]  [<c0229c42>] warn_slowpath_common+0x72/0xa0
[   79.089368]  [<c027f31c>] ? watchdog_overflow_callback+0x9c/0xc0
[   79.089368]  [<c027f31c>] ? watchdog_overflow_callback+0x9c/0xc0
[   79.089368]  [<c027f280>] ? touch_nmi_watchdog+0x70/0x70
[   79.089368]  [<c0229d13>] warn_slowpath_fmt+0x33/0x40
[   79.089368]  [<c027f31c>] watchdog_overflow_callback+0x9c/0xc0
[   79.089368]  [<c02a72d5>] __perf_event_overflow+0x95/0x220
[   79.089368]  [<c0210039>] ? x86_perf_event_set_period+0x119/0x210
[   79.089368]  [<c02a7b25>] perf_event_overflow+0x15/0x20
[   79.089368]  [<c0213545>] intel_pmu_handle_irq+0x125/0x260
[   79.089368]  [<c025d1a0>] ? find_busiest_group+0x150/0xaa0
[   79.089368]  [<c020f330>] perf_event_nmi_handler+0x20/0x30
[   79.089368]  [<c0205bf7>] do_nmi+0xc7/0x380
[   79.089368]  [<c0607359>] nmi_stack_correct+0x28/0x2d
[   79.089368]  [<c06064a0>] ? _raw_spin_lock+0x20/0x30
[   79.089368]  [<c025dc90>] load_balance+0x1a0/0x510
[   79.089368]  [<c025e21a>] idle_balance+0xca/0x140
[   79.089368]  [<c0605ae4>] __schedule+0x4c4/0x640
[   79.089368]  [<c03ae010>] ? timerqueue_add+0x60/0xc0
[   79.089368]  [<c024e990>] ? __hrtimer_start_range_ns+0x160/0x3f0
[   79.089368]  [<c0605d15>] schedule+0x35/0x50
[   79.089368]  [<c0604f67>] schedule_hrtimeout_range_clock+0xc7/0x180
[   79.089368]  [<c024df10>] ? update_rmtp+0x80/0x80
[   79.089368]  [<c024ec76>] ? hrtimer_start_range_ns+0x26/0x30
[   79.089368]  [<c0605037>] schedule_hrtimeout_range+0x17/0x20
[   79.089368]  [<c02fbe8e>] poll_schedule_timeout+0x3e/0x60
[   79.089368]  [<c02fc796>] do_select+0x566/0x680
[   79.089368]  [<c02fbf70>] ? poll_freewait+0xc0/0xc0
[   79.089368]  [<c02fc040>] ? __pollwait+0xd0/0xd0
[   79.089368]  [<c025ab5b>] ? sched_clock_local+0xcb/0x1d0
[   79.089368]  [<c025c13c>] ? sched_slice.isra.47+0x5c/0xb0
[   79.089368]  [<c025ab5b>] ? sched_clock_local+0xcb/0x1d0
[   79.089368]  [<c025ab5b>] ? sched_clock_local+0xcb/0x1d0
[   79.089368]  [<c025ab5b>] ? sched_clock_local+0xcb/0x1d0
[   79.089368]  [<c025ada7>] ? sched_clock_cpu+0xd7/0x160
[   79.089368]  [<c0256c42>] ? activate_task+0x42/0x50
[   79.089368]  [<c022ffb2>] ? irq_exit+0x62/0x80
[   79.089368]  [<c02573cd>] ? scheduler_ipi+0x2d/0x40
[   79.089368]  [<c021ad87>] ? smp_reschedule_interrupt+0x27/0x30
[   79.089368]  [<c060699e>] ? reschedule_interrupt+0x2a/0x30
[   79.089368]  [<c02fca35>] core_sys_select+0x185/0x260
[   79.089368]  [<c025ab5b>] ? sched_clock_local+0xcb/0x1d0
[   79.089368]  [<c025ab5b>] ? sched_clock_local+0xcb/0x1d0
[   79.089368]  [<c0263332>] ? ktime_get_ts+0xe2/0x110
[   79.089368]  [<c0263332>] ? ktime_get_ts+0xe2/0x110
[   79.089368]  [<c02fcb94>] sys_select+0x84/0xb0
[   79.089368]  [<c060750c>] sysenter_do_call+0x12/0x22
[   79.089368] ---[ end trace 3d1cedd589a9a5c5 ]---
[   79.604813] ------------[ cut here ]------------
[   79.604813] WARNING: at kernel/watchdog.c:241 watchdog_overflow_callback+0x9c/0xc0()
[   79.604813] Hardware name: ProLiant BL460c G1
[   79.604813] Watchdog detected hard LOCKUP on cpu 5
[   79.604813] Modules linked in: netconsole xt_hashlimit af_packet tg3 bonding
[   79.604813] Pid: 7117, comm: hackbench Tainted: G        W    3.2.0-06100-ge343a89 #12
[   79.604813] Call Trace:
[   79.604813]  [<c0229c42>] warn_slowpath_common+0x72/0xa0
[   79.604813]  [<c027f31c>] ? watchdog_overflow_callback+0x9c/0xc0
[   79.604813]  [<c027f31c>] ? watchdog_overflow_callback+0x9c/0xc0
[   79.604813]  [<c027f280>] ? touch_nmi_watchdog+0x70/0x70
[   79.604813]  [<c0229d13>] warn_slowpath_fmt+0x33/0x40
[   79.604813]  [<c027f31c>] watchdog_overflow_callback+0x9c/0xc0
[   79.604813]  [<c02a72d5>] __perf_event_overflow+0x95/0x220
[   79.604813]  [<c025c13c>] ? sched_slice.isra.47+0x5c/0xb0
[   79.604813]  [<c0210039>] ? x86_perf_event_set_period+0x119/0x210
[   79.604813]  [<c02a7b25>] perf_event_overflow+0x15/0x20
[   79.604813]  [<c0213545>] intel_pmu_handle_irq+0x125/0x260
[   79.604813]  [<c03ae010>] ? timerqueue_add+0x60/0xc0
[   79.604813]  [<c025ab5b>] ? sched_clock_local+0xcb/0x1d0
[   79.604813]  [<c020f330>] perf_event_nmi_handler+0x20/0x30
[   79.604813]  [<c0205bf7>] do_nmi+0xc7/0x380
[   79.604813]  [<c025ada7>] ? sched_clock_cpu+0xd7/0x160
[   79.604813]  [<c0607359>] nmi_stack_correct+0x28/0x2d
[   79.604813]  [<c02591fa>] ? try_to_wake_up+0x9a/0x210
[   79.604813]  [<c0259380>] default_wake_function+0x10/0x20
[   79.604813]  [<c024a950>] autoremove_wake_function+0x20/0x50
[   79.604813]  [<c0251df7>] __wake_up_common+0x47/0x70
[   79.604813]  [<c0252d63>] __wake_up_sync_key+0x43/0x60
[   79.604813]  [<c05589b9>] unix_write_space+0x49/0x80
[   79.604813]  [<c04c7d6a>] sock_wfree+0x4a/0x60
[   79.604813]  [<c0558eba>] unix_destruct_scm+0x7a/0x90
[   79.604813]  [<c04cc88d>] skb_release_head_state+0x4d/0xe0
[   79.604813]  [<c04cc690>] __kfree_skb+0x10/0x90
[   79.604813]  [<c04cc73b>] consume_skb+0x2b/0x90
[   79.604813]  [<c05590b9>] unix_stream_recvmsg+0x1e9/0x590
[   79.604813]  [<c04c4ffc>] sock_aio_read+0xec/0x100
[   79.604813]  [<c02eb42c>] do_sync_read+0xac/0xe0
[   79.604813]  [<c033b5db>] ? proc_flush_task+0xcb/0x1a0
[   79.604813]  [<c02857d2>] ? call_rcu_sched+0x12/0x20
[   79.604813]  [<c02ebf51>] vfs_read+0x131/0x150
[   79.604813]  [<c02ebfad>] sys_read+0x3d/0x70
[   79.604813]  [<c060750c>] sysenter_do_call+0x12/0x22
[   79.604813] ---[ end trace 3d1cedd589a9a5c6 ]---
[   79.101000] ------------[ cut here ]------------
[   79.101000] WARNING: at kernel/watchdog.c:241 watchdog_overflow_callback+0x9c/0xc0()
[   79.101000] Hardware name: ProLiant BL460c G1
[   79.101000] Watchdog detected hard LOCKUP on cpu 2
[   79.101000] Modules linked in: netconsole xt_hashlimit af_packet tg3 bonding
[   79.101000] Pid: 7152, comm: hackbench Tainted: G        W    3.2.0-06100-ge343a89 #12
[   79.101000] Call Trace:
[   79.101000]  [<c0229c42>] warn_slowpath_common+0x72/0xa0
[   79.101000]  [<c027f31c>] ? watchdog_overflow_callback+0x9c/0xc0
[   79.101000]  [<c027f31c>] ? watchdog_overflow_callback+0x9c/0xc0
[   79.101000]  [<c027f280>] ? touch_nmi_watchdog+0x70/0x70
[   79.101000]  [<c0229d13>] warn_slowpath_fmt+0x33/0x40
[   79.101000]  [<c027f31c>] watchdog_overflow_callback+0x9c/0xc0
[   79.101000]  [<c02a72d5>] __perf_event_overflow+0x95/0x220
[   79.101000]  [<c0210039>] ? x86_perf_event_set_period+0x119/0x210
[   79.101000]  [<c02a7b25>] perf_event_overflow+0x15/0x20
[   79.101000]  [<c0213545>] intel_pmu_handle_irq+0x125/0x260
[   79.101000]  [<c025d1a0>] ? find_busiest_group+0x150/0xaa0
[   79.101000]  [<c020f330>] perf_event_nmi_handler+0x20/0x30
[   79.101000]  [<c0205bf7>] do_nmi+0xc7/0x380
[   79.101000]  [<c0607359>] nmi_stack_correct+0x28/0x2d
[   79.101000]  [<c06064a5>] ? _raw_spin_lock+0x25/0x30
[   79.101000]  [<c025dc90>] load_balance+0x1a0/0x510
[   79.101000]  [<c025e21a>] idle_balance+0xca/0x140
[   79.101000]  [<c0605ae4>] __schedule+0x4c4/0x640
[   79.101000]  [<c025ada7>] ? sched_clock_cpu+0xd7/0x160
[   79.101000]  [<c0605d15>] schedule+0x35/0x50
[   79.101000]  [<c0604615>] schedule_timeout+0x1e5/0x260
[   79.101000]  [<c04c79a4>] ? sock_alloc_send_pskb+0x164/0x280
[   79.101000]  [<c0607c09>] ? smp_apic_timer_interrupt+0x59/0x88
[   79.101000]  [<c024a798>] ? prepare_to_wait+0x48/0x70
[   79.101000]  [<c04c795d>] sock_alloc_send_pskb+0x11d/0x280
[   79.101000]  [<c024a930>] ? abort_exclusive_wait+0x80/0x80
[   79.101000]  [<c04c7add>] sock_alloc_send_skb+0x1d/0x30
[   79.101000]  [<c0559def>] unix_stream_sendmsg+0x31f/0x420
[   79.101000]  [<c04c50ed>] sock_aio_write+0xdd/0xf0
[   79.101000]  [<c03ae010>] ? timerqueue_add+0x60/0xc0
[   79.101000]  [<c02eb34c>] do_sync_write+0xac/0xe0
[   79.101000]  [<c02ebe01>] vfs_write+0x131/0x150
[   79.101000]  [<c02ec01d>] sys_write+0x3d/0x70
[   79.101000]  [<c060750c>] sysenter_do_call+0x12/0x22
[   79.101000] ---[ end trace 3d1cedd589a9a5c7 ]---

[   79.185336] ------------[ cut here ]------------
[   79.185336] WARNING: at kernel/watchdog.c:241 watchdog_overflow_callback+0x9c/0xc0()
[   79.185336] Hardware name: ProLiant BL460c G1
[   79.185336] Watchdog detected hard LOCKUP on cpu 4
[   79.185336] Modules linked in: netconsole xt_hashlimit af_packet tg3 bonding
[   79.185336] Pid: 4915, comm: IVR Tainted: G        W    3.2.0-06100-ge343a89 #12
[   79.185336] Call Trace:
[   79.185336]  [<c0229c42>] warn_slowpath_common+0x72/0xa0
[   79.185336]  [<c027f31c>] ? watchdog_overflow_callback+0x9c/0xc0
[   79.185336]  [<c027f31c>] ? watchdog_overflow_callback+0x9c/0xc0
[   79.185336]  [<c027f280>] ? touch_nmi_watchdog+0x70/0x70
[   79.185336]  [<c0229d13>] warn_slowpath_fmt+0x33/0x40
[   79.185336]  [<c027f31c>] watchdog_overflow_callback+0x9c/0xc0
[   79.185336]  [<c02a72d5>] __perf_event_overflow+0x95/0x220
[   79.185336]  [<c0210039>] ? x86_perf_event_set_period+0x119/0x210
[   79.185336]  [<c02a7b25>] perf_event_overflow+0x15/0x20
[   79.185336]  [<c0213545>] intel_pmu_handle_irq+0x125/0x260
[   79.185336]  [<c025d1a0>] ? find_busiest_group+0x150/0xaa0
[   79.185336]  [<c020f330>] perf_event_nmi_handler+0x20/0x30
[   79.185336]  [<c0205bf7>] do_nmi+0xc7/0x380
[   79.185336]  [<c0607359>] nmi_stack_correct+0x28/0x2d
[   79.185336]  [<c06064a5>] ? _raw_spin_lock+0x25/0x30
[   79.185336]  [<c025dc90>] load_balance+0x1a0/0x510
[   79.185336]  [<c025e21a>] idle_balance+0xca/0x140
[   79.185336]  [<c0605ae4>] __schedule+0x4c4/0x640
[   79.185336]  [<c03ae010>] ? timerqueue_add+0x60/0xc0
[   79.185336]  [<c024e990>] ? __hrtimer_start_range_ns+0x160/0x3f0
[   79.185336]  [<c022ffb2>] ? irq_exit+0x62/0x80
[   79.185336]  [<c0605d15>] schedule+0x35/0x50
[   79.185336]  [<c0604f67>] schedule_hrtimeout_range_clock+0xc7/0x180
[   79.185336]  [<c024df10>] ? update_rmtp+0x80/0x80
[   79.185336]  [<c024ec76>] ? hrtimer_start_range_ns+0x26/0x30
[   79.185336]  [<c0605037>] schedule_hrtimeout_range+0x17/0x20
[   79.185336]  [<c02fbe8e>] poll_schedule_timeout+0x3e/0x60
[   79.185336]  [<c02fc796>] do_select+0x566/0x680
[   79.185336]  [<c02fbf70>] ? poll_freewait+0xc0/0xc0
[   79.185336]  [<c02fc040>] ? __pollwait+0xd0/0xd0
[   79.185336]  [<c025ab5b>] ? sched_clock_local+0xcb/0x1d0
[   79.185336]  [<c025ada7>] ? sched_clock_cpu+0xd7/0x160
[   79.185336]  [<c025c13c>] ? sched_slice.isra.47+0x5c/0xb0
[   79.185336]  [<c025ab5b>] ? sched_clock_local+0xcb/0x1d0
[   79.185336]  [<c025ab5b>] ? sched_clock_local+0xcb/0x1d0
[   79.185336]  [<c025ada7>] ? sched_clock_cpu+0xd7/0x160
[   79.185336]  [<c025bfaf>] ? check_preempt_wakeup+0xaf/0x1e0
[   79.185336]  [<c0256d82>] ? check_preempt_curr+0x72/0x90
[   79.185336]  [<c0256dc8>] ? ttwu_do_wakeup+0x28/0x130
[   79.185336]  [<c0256c42>] ? activate_task+0x42/0x50
[   79.185336]  [<c02fca35>] core_sys_select+0x185/0x260
[   79.185336]  [<c025ab5b>] ? sched_clock_local+0xcb/0x1d0
[   79.185336]  [<c0263332>] ? ktime_get_ts+0xe2/0x110
[   79.185336]  [<c0263332>] ? ktime_get_ts+0xe2/0x110
[   79.185336]  [<c02fcb94>] sys_select+0x84/0xb0
[   79.185336]  [<c060750c>] sysenter_do_call+0x12/0x22
[   79.185336]  [<c0600000>] ? retarget_shared_pending+0x10/0xa1
[   79.185336] ---[ end trace 3d1cedd589a9a5c8 ]---
[   80.035202] ------------[ cut here ]------------
[   80.035202] WARNING: at kernel/watchdog.c:241 watchdog_overflow_callback+0x9c/0xc0()
[   80.035202] Hardware name: ProLiant BL460c G1
[   80.035202] Watchdog detected hard LOCKUP on cpu 3
[   80.035202] Modules linked in: netconsole xt_hashlimit af_packet tg3 bonding
[   80.035202] Pid: 6858, comm: hackbench Tainted: G        W    3.2.0-06100-ge343a89 #12
[   80.035202] Call Trace:
[   80.035202]  [<c0229c42>] warn_slowpath_common+0x72/0xa0
[   80.035202]  [<c027f31c>] ? watchdog_overflow_callback+0x9c/0xc0
[   80.035202]  [<c027f31c>] ? watchdog_overflow_callback+0x9c/0xc0
[   80.035202]  [<c027f280>] ? touch_nmi_watchdog+0x70/0x70
[   80.035202]  [<c0229d13>] warn_slowpath_fmt+0x33/0x40
[   80.035202]  [<c027f31c>] watchdog_overflow_callback+0x9c/0xc0
[   80.035202]  [<c02a72d5>] __perf_event_overflow+0x95/0x220
[   80.035202]  [<c0210039>] ? x86_perf_event_set_period+0x119/0x210
[   80.035202]  [<c02a7b25>] perf_event_overflow+0x15/0x20
[   80.035202]  [<c0213545>] intel_pmu_handle_irq+0x125/0x260
[   80.035202]  [<c025d1a0>] ? find_busiest_group+0x150/0xaa0
[   80.035202]  [<c020f330>] perf_event_nmi_handler+0x20/0x30
[   80.035202]  [<c0205bf7>] do_nmi+0xc7/0x380
[   80.035202]  [<c0607359>] nmi_stack_correct+0x28/0x2d
[   80.035202]  [<c06064a5>] ? _raw_spin_lock+0x25/0x30
[   80.035202]  [<c025dc90>] load_balance+0x1a0/0x510
[   80.035202]  [<c025e21a>] idle_balance+0xca/0x140
[   80.035202]  [<c0605ae4>] __schedule+0x4c4/0x640
[   80.035202]  [<c033b5db>] ? proc_flush_task+0xcb/0x1a0
[   80.035202]  [<c02857d2>] ? call_rcu_sched+0x12/0x20
[   80.035202]  [<c022bae0>] ? allow_signal+0x70/0x70
[   80.035202]  [<c02857d2>] ? call_rcu_sched+0x12/0x20
[   80.035202]  [<c022be31>] ? release_task+0x1e1/0x320
[   80.035202]  [<c0605d15>] schedule+0x35/0x50
[   80.035202]  [<c022d14f>] do_exit+0x4ef/0x750
[   80.035202]  [<c02ebdc7>] ? vfs_write+0xf7/0x150
[   80.035202]  [<c022d608>] sys_exit+0x18/0x20
[   80.035202]  [<c060685d>] syscall_call+0x7/0xb
[   80.035202] ---[ end trace 3d1cedd589a9a5c9 ]---
[   80.040000] ------------[ cut here ]------------
[   80.040000] WARNING: at kernel/watchdog.c:241 watchdog_overflow_callback+0x9c/0xc0()
[   80.040000] Hardware name: ProLiant BL460c G1
[   80.040000] Watchdog detected hard LOCKUP on cpu 7
[   80.040000] Modules linked in: netconsole xt_hashlimit af_packet tg3 bonding
[   80.040000] Pid: 6799, comm: hackbench Tainted: G        W    3.2.0-06100-ge343a89 #12
[   80.040000] Call Trace:
[   80.040000]  [<c0229c42>] warn_slowpath_common+0x72/0xa0
[   80.040000]  [<c027f31c>] ? watchdog_overflow_callback+0x9c/0xc0
[   80.040000]  [<c027f31c>] ? watchdog_overflow_callback+0x9c/0xc0
[   80.040000]  [<c027f280>] ? touch_nmi_watchdog+0x70/0x70
[   80.040000]  [<c0229d13>] warn_slowpath_fmt+0x33/0x40
[   80.040000]  [<c027f31c>] watchdog_overflow_callback+0x9c/0xc0
[   80.040000]  [<c02a72d5>] __perf_event_overflow+0x95/0x220
[   80.040000]  [<c0210039>] ? x86_perf_event_set_period+0x119/0x210
[   80.040000]  [<c02a7b25>] perf_event_overflow+0x15/0x20
[   80.040000]  [<c0213545>] intel_pmu_handle_irq+0x125/0x260
[   80.040000]  [<c025d1a0>] ? find_busiest_group+0x150/0xaa0
[   80.040000]  [<c020f330>] perf_event_nmi_handler+0x20/0x30
[   80.040000]  [<c0205bf7>] do_nmi+0xc7/0x380
[   80.040000]  [<c0607359>] nmi_stack_correct+0x28/0x2d
[   80.040000]  [<c06064a2>] ? _raw_spin_lock+0x22/0x30
[   80.040000]  [<c025de4c>] load_balance+0x35c/0x510
[   80.040000]  [<c025e21a>] idle_balance+0xca/0x140
[   80.040000]  [<c0605ae4>] __schedule+0x4c4/0x640
[   80.040000]  [<c06023ee>] ? __slab_free+0x162/0x23a
[   80.040000]  [<c0605d15>] schedule+0x35/0x50
[   80.040000]  [<c0604615>] schedule_timeout+0x1e5/0x260
[   80.040000]  [<c02e5202>] ? kmem_cache_free+0x102/0x110
[   80.040000]  [<c04cc6bd>] ? __kfree_skb+0x3d/0x90
[   80.040000]  [<c04cc6bd>] ? __kfree_skb+0x3d/0x90
[   80.040000]  [<c04cc6bd>] ? __kfree_skb+0x3d/0x90
[   80.040000]  [<c024a798>] ? prepare_to_wait+0x48/0x70
[   80.040000]  [<c0559259>] unix_stream_recvmsg+0x389/0x590
[   80.040000]  [<c03b2535>] ? _copy_from_user+0x35/0x50
[   80.040000]  [<c024a930>] ? abort_exclusive_wait+0x80/0x80
[   80.040000]  [<c04c4ffc>] sock_aio_read+0xec/0x100
[   80.040000]  [<c025ada7>] ? sched_clock_cpu+0xd7/0x160
[   80.040000]  [<c02eb42c>] do_sync_read+0xac/0xe0
[   80.040000]  [<c06070ba>] ? apic_timer_interrupt+0x2a/0x30
[   80.040000]  [<c02ebf51>] vfs_read+0x131/0x150
[   80.040000]  [<c02ebfad>] sys_read+0x3d/0x70
[   80.040000]  [<c060750c>] sysenter_do_call+0x12/0x22
[   80.040000] ---[ end trace 3d1cedd589a9a5ca ]---
[   79.100002] ------------[ cut here ]------------
[   79.100002] WARNING: at kernel/watchdog.c:241 watchdog_overflow_callback+0x9c/0xc0()
[   79.100002] Hardware name: ProLiant BL460c G1
[   79.100002] Watchdog detected hard LOCKUP on cpu 6
[   79.100002] Modules linked in: netconsole xt_hashlimit af_packet tg3 bonding
[   79.100002] Pid: 7153, comm: hackbench Tainted: G        W    3.2.0-06100-ge343a89 #12
[   79.100002] Call Trace:
[   79.100002]  [<c0229c42>] warn_slowpath_common+0x72/0xa0
[   79.100002]  [<c027f31c>] ? watchdog_overflow_callback+0x9c/0xc0
[   79.100002]  [<c027f31c>] ? watchdog_overflow_callback+0x9c/0xc0
[   79.100002]  [<c027f280>] ? touch_nmi_watchdog+0x70/0x70
[   79.100002]  [<c0229d13>] warn_slowpath_fmt+0x33/0x40
[   79.100002]  [<c027f31c>] watchdog_overflow_callback+0x9c/0xc0
[   79.100002]  [<c02a72d5>] __perf_event_overflow+0x95/0x220
[   79.100002]  [<c0210039>] ? x86_perf_event_set_period+0x119/0x210
[   79.100002]  [<c02a7b25>] perf_event_overflow+0x15/0x20
[   79.100002]  [<c0213545>] intel_pmu_handle_irq+0x125/0x260
[   79.100002]  [<c025d1a0>] ? find_busiest_group+0x150/0xaa0
[   79.100002]  [<c020f330>] perf_event_nmi_handler+0x20/0x30
[   79.100002]  [<c0205bf7>] do_nmi+0xc7/0x380
[   79.100002]  [<c0607359>] nmi_stack_correct+0x28/0x2d
[   79.100002]  [<c06064a5>] ? _raw_spin_lock+0x25/0x30
[   79.100002]  [<c025de4c>] load_balance+0x35c/0x510
[   79.100002]  [<c025e21a>] idle_balance+0xca/0x140
[   79.100002]  [<c0605ae4>] __schedule+0x4c4/0x640
[   79.100002]  [<c025ada7>] ? sched_clock_cpu+0xd7/0x160
[   79.100002]  [<c0605d15>] schedule+0x35/0x50
[   79.100002]  [<c0604615>] schedule_timeout+0x1e5/0x260
[   79.100002]  [<c04c79a4>] ? sock_alloc_send_pskb+0x164/0x280
[   79.100002]  [<c0607c09>] ? smp_apic_timer_interrupt+0x59/0x88
[   79.100002]  [<c024a798>] ? prepare_to_wait+0x48/0x70
[   79.100002]  [<c04c795d>] sock_alloc_send_pskb+0x11d/0x280
[   79.100002]  [<c024a930>] ? abort_exclusive_wait+0x80/0x80
[   79.100002]  [<c04c7add>] sock_alloc_send_skb+0x1d/0x30
[   79.100002]  [<c0559def>] unix_stream_sendmsg+0x31f/0x420
[   79.100002]  [<c04c50ed>] sock_aio_write+0xdd/0xf0
[   79.100002]  [<c025ab5b>] ? sched_clock_local+0xcb/0x1d0
[   79.100002]  [<c02eb34c>] do_sync_write+0xac/0xe0
[   79.100002]  [<c03abdcc>] ? rb_insert_color+0x7c/0x110
[   79.100002]  [<c02ebe01>] vfs_write+0x131/0x150
[   79.100002]  [<c02ec01d>] sys_write+0x3d/0x70
[   79.100002]  [<c060750c>] sysenter_do_call+0x12/0x22
[   79.100002] ---[ end trace 3d1cedd589a9a5cb ]---


