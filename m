Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061Ab2AWU7Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 15:59:25 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:45536 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753501Ab2AWU7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 15:59:23 -0500
Date: Mon, 23 Jan 2012 15:56:38 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, mingo@elte.hu, linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, gregkh@suse.de, rjw@sisk.pl
Subject: v3.3-rc1, regression introduced by "sched, nohz: Implement sched
 group, domain aware nohz idle load balancing" when unplugging CPUs.
Message-ID: <20120123205638.GA8542@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090203.4F1DCA13.0016,ss=1,re=-2.300,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

Not exactly sure how this patch does it, but with this git commit
0b005cf54eac170a8f22540ab096a6e07bf49e7c, the Linux kernel crashes
if I try to hot unplug VCPUs to the first (initial) domain.
This is found using git bisection, and if I use the kernel compiled
with 69e1e811dcc436a6b129dbef273ad9ec22d095ce (the previous commit)
it works nicely.
 
I am not really sure if xen_send_IPI_one needs to be updated, but
it looks as if an IPI to a non-existed (torn-down) CPU is sent.. Hmm.

The VCPU unplug mechanism uses the arch_unregister_cpu, so I think
this can also be reproduced by doing ACPI CPU hotplug on baremetal.

The steps to reproduce this are quite easy.

sh-4.1# uname -a
Linux tst018.dumpdata.com 3.2.0-rc1-00328-g0b005cf #1 SMP PREEMPT Mon Jan 23 15:34:43 EST 2012 x86_64 x86_64 x86_64 GNU/Linux
sh-4.1# xl vcpu-list
Name                                ID  VCPU   CPU State   Time(s) CPU Affinity
Domain-0                             0     0    0   -b-       5.0  any cpu
Domain-0                             0     1    1   -b-       1.3  any cpu
Domain-0                             0     2    2   -b-       1.6  any cpu
Domain-0                             0     3    3   r--       2.0  any cpu
sh-4.1# xl vcpu-set 0 2
sh-4.1# [  123.856084] ------------[ cut here ]------------
[  123.857166] kernel BUG at /home/konrad/ssd/linux/drivers/xen/events.c:1071!
[  123.858265] invalid opcode: 0000 [#1] PREEMPT SMP 
[  123.859387] CPU 1 
[  123.859400] Modules linked in: dm_multipath dm_mod xen_evtchn iscsi_boot_sysfs iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi libcrc32c crc32c sg sd_mod usbhid hid usb_storage nouveau ahci libahci ata_generic libata i915 fbcon ttm tileblit scsi_mod font mxm_wmi bitblit e1000e softcursor wmi drm_kms_helper video xen_blkfront xen_netfront fb_sys_fops sysimgblt sysfillrect syscopyarea xenfs
[  123.864413] 
[  123.865679] Pid: 2568, comm: kworker/u:7 Not tainted 3.2.0-rc1-00328-g0b005cf #1                  /DQ67SW
[  123.867010] RIP: e030:[<ffffffff8138a81e>]  [<ffffffff8138a81e>] xen_send_IPI_one+0x2e/0x40
[  123.868352] RSP: e02b:ffff8803e2ea3c18  EFLAGS: 00010086
[  123.869688] RAX: 0000000000010980 RBX: 0000000000000001 RCX: 0000000000000002
[  123.871051] RDX: ffff8803e2ebc000 RSI: 0000000000000000 RDI: 00000000ffffffff
[  123.872407] RBP: ffff8803e2ea3c18 R08: 0000000000000000 R09: 0000000000000001
[  123.873768] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8803e2eb3800
[  123.875115] R13: 00000000fffd338f R14: ffff8803e2eb3800 R15: 0000000000000001
[  123.876458] FS:  00007fd00c8a4700(0000) GS:ffff8803e2ea0000(0000) knlGS:0000000000000000
[  123.877806] CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
[  123.879169] CR2: 00007fd00c8a2000 CR3: 00000003bbd2c000 CR4: 0000000000002660
[  123.880538] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  123.881900] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  123.883258] Process kworker/u:7 (pid: 2568, threadinfo ffff8803c39ce000, task ffff8803cc753d20)
[  123.884626] Stack:
[  123.885980]  ffff8803e2ea3c28 ffffffff81049d70 ffff8803e2ea3c78 ffffffff810c69b0
[  123.887376]  0000000000000001 00000002cc753d68 ffff8803e2ea3c78 ffff8803e2eb3800
[  123.888759]  0000000000000001 0000000000000001 ffff8803e2eb3800 ffff8803cc753d20
[  123.890136] Call Trace:
[  123.891455]  <IRQ> 
[  123.892763]  [<ffffffff81049d70>] xen_smp_send_reschedule+0x10/0x20
[  123.894085]  [<ffffffff810c69b0>] trigger_load_balance+0x260/0x330
[  123.895392]  [<ffffffff810bc044>] scheduler_tick+0x104/0x160
[  123.896691]  [<ffffffff8109a66e>] update_process_times+0x6e/0x90
[  123.897980]  [<ffffffff810d97c2>] tick_sched_timer+0x62/0xc0
[  123.899257]  [<ffffffff810b3766>] __run_hrtimer+0x96/0x280
[  123.900539]  [<ffffffff810d9760>] ? tick_nohz_handler+0x100/0x100
[  123.901846]  [<ffffffff810b3be6>] hrtimer_interrupt+0x106/0x240
[  123.903165]  [<ffffffff81042398>] xen_timer_interrupt+0x38/0x1f0
[  123.904478]  [<ffffffff810919bb>] ? irq_exit+0x7b/0x100
[  123.905780]  [<ffffffff8110eeed>] handle_irq_event_percpu+0x8d/0x290
[  123.907081]  [<ffffffff81112238>] handle_percpu_irq+0x48/0x70
[  123.908359]  [<ffffffff813891b1>] __xen_evtchn_do_upcall+0x1c1/0x2c0
[  123.909631]  [<ffffffff8138947f>] xen_evtchn_do_upcall+0x2f/0x50
[  123.910898]  [<ffffffff8164677e>] xen_do_hypervisor_callback+0x1e/0x30
[  123.912150]  <EOI> 
[  123.913384]  [<ffffffff8100122a>] ? hypercall_page+0x22a/0x1000
[  123.914627]  [<ffffffff8100122a>] ? hypercall_page+0x22a/0x1000
[  123.915847]  [<ffffffff81041e1d>] ? xen_force_evtchn_callback+0xd/0x10
[  123.917067]  [<ffffffff81042802>] ? check_events+0x12/0x20
[  123.918282]  [<ffffffff810427a9>] ? xen_irq_enable_direct_reloc+0x4/0x4
[  123.919508]  [<ffffffff8163cd6b>] ? _raw_spin_unlock_irq+0x2b/0x70
[  123.920718]  [<ffffffff810bc53e>] ? finish_task_switch+0x4e/0xe0
[  123.921913]  [<ffffffff8163b669>] ? __schedule+0x469/0x890
[  123.923103]  [<ffffffff8163bb6f>] ? schedule+0x3f/0x60
[  123.924285]  [<ffffffff816399ad>] ? schedule_timeout+0x1fd/0x350
[  123.925466]  [<ffffffff8104259c>] ? xen_clocksource_read+0x4c/0x80
[  123.926645]  [<ffffffff810c57f4>] ? update_curr+0x144/0x1e0
[  123.927816]  [<ffffffff8104a8c6>] ? xen_spin_lock+0xa6/0x110
[  123.928974]  [<ffffffff810bb491>] ? get_parent_ip+0x11/0x50
[  123.930117]  [<ffffffff8163aff0>] ? wait_for_common+0xd0/0x190
[  123.931262]  [<ffffffff810c0c20>] ? try_to_wake_up+0x2c0/0x2c0
[  123.932367]  [<ffffffff8163b18d>] ? wait_for_completion+0x1d/0x20
[  123.933427]  [<ffffffff81089eb9>] ? do_fork+0xe9/0x350
[  123.934440]  [<ffffffff810a5640>] ? call_usermodehelper_exec+0xe0/0xe0
[  123.935465]  [<ffffffff810557d6>] ? kernel_thread+0x76/0x80
[  123.936473]  [<ffffffff810a5290>] ? call_usermodehelper_setup+0xa0/0xa0
[  123.937471]  [<ffffffff81646630>] ? gs_change+0x13/0x13
[  123.938454]  [<ffffffff816409ad>] ? sub_preempt_count+0x9d/0xd0
[  123.939428]  [<ffffffff810a5677>] ? __call_usermodehelper+0x37/0xb0
[  123.940411]  [<ffffffff810a7b59>] ? process_one_work+0x129/0x4e0
[  123.941400]  [<ffffffff810a9c4e>] ? worker_thread+0x17e/0x410
[  123.942383]  [<ffffffff810a9ad0>] ? manage_workers+0x210/0x210
[  123.943363]  [<ffffffff810ae906>] ? kthread+0x96/0xa0
[  123.944327]  [<ffffffff81646634>] ? kernel_thread_helper+0x4/0x10
[  123.945287]  [<ffffffff816446e3>] ? int_ret_from_sys_call+0x7/0x1b
[  123.946238]  [<ffffffff8163d200>] ? retint_restore_args+0x5/0x6
[  123.947187]  [<ffffffff81646630>] ? gs_change+0x13/0x13
[  123.948132] Code: e5 66 66 66 66 90 48 c7 c0 80 09 01 00 89 ff 89 f6 48 8b 14 fd e0 28 ac 81 48 8d 04 b0 8b 3c 10 85 ff 78 07 e8 74 ff ff ff c9 c3 <0f> 0b eb fe 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 
[  123.950401] RIP  [<ffffffff8138a81e>] xen_send_IPI_one+0x2e/0x40
[  123.951419]  RSP <ffff8803e2ea3c18>
[  123.952425] ---[ end trace 4c21b5ae5c292a38 ]---
[  123.953438] Kernel panic - not syncing: Fatal exception in interrupt
[  123.954459] Pid: 2568, comm: kworker/u:7 Tainted: G      D      3.2.0-rc1-00328-g0b005cf #1
[  123.955508] Call Trace:
[  123.956539]  <IRQ>  [<ffffffff816394e2>] panic+0x9b/0x1c9
[  123.957592]  [<ffffffff81042802>] ? check_events+0x12/0x20
[  123.958644]  [<ffffffff8163df8a>] oops_end+0x10a/0x120
[  123.959694]  [<ffffffff8104fcbb>] die+0x5b/0x90
[  123.960736]  [<ffffffff8163d8c4>] do_trap+0xc4/0x170
[  123.961774]  [<ffffffff8104d906>] do_invalid_op+0xa6/0xc0
[  123.962813]  [<ffffffff8138a81e>] ? xen_send_IPI_one+0x2e/0x40
[  123.963850]  [<ffffffff810c510b>] ? find_busiest_group+0x9bb/0xac0
[  123.964890]  [<ffffffff816464ab>] invalid_op+0x1b/0x20
[  123.965929]  [<ffffffff8138a81e>] ? xen_send_IPI_one+0x2e/0x40
[  123.966967]  [<ffffffff81049d70>] xen_smp_send_reschedule+0x10/0x20
[  123.968009]  [<ffffffff810c69b0>] trigger_load_balance+0x260/0x330
[  123.969049]  [<ffffffff810bc044>] scheduler_tick+0x104/0x160
[  123.970086]  [<ffffffff8109a66e>] update_process_times+0x6e/0x90
[  123.971119]  [<ffffffff810d97c2>] tick_sched_timer+0x62/0xc0
[  123.972148]  [<ffffffff810b3766>] __run_hrtimer+0x96/0x280
[  123.973167]  [<ffffffff810d9760>] ? tick_nohz_handler+0x100/0x100
[  123.974203]  [<ffffffff810b3be6>] hrtimer_interrupt+0x106/0x240
[  123.975238]  [<ffffffff81042398>] xen_timer_interrupt+0x38/0x1f0
[  123.976274]  [<ffffffff810919bb>] ? irq_exit+0x7b/0x100
[  123.977308]  [<ffffffff8110eeed>] handle_irq_event_percpu+0x8d/0x290
[  123.978344]  [<ffffffff81112238>] handle_percpu_irq+0x48/0x70
[  123.979379]  [<ffffffff813891b1>] __xen_evtchn_do_upcall+0x1c1/0x2c0
[  123.980422]  [<ffffffff8138947f>] xen_evtchn_do_upcall+0x2f/0x50
[  123.981465]  [<ffffffff8164677e>] xen_do_hypervisor_callback+0x1e/0x30
[  123.982517]  <EOI>  [<ffffffff8100122a>] ? hypercall_page+0x22a/0x1000
[  123.983584]  [<ffffffff8100122a>] ? hypercall_page+0x22a/0x1000
[  123.984652]  [<ffffffff81041e1d>] ? xen_force_evtchn_callback+0xd/0x10
[  123.985721]  [<ffffffff81042802>] ? check_events+0x12/0x20
[  123.986792]  [<ffffffff810427a9>] ? xen_irq_enable_direct_reloc+0x4/0x4
[  123.987869]  [<ffffffff8163cd6b>] ? _raw_spin_unlock_irq+0x2b/0x70
[  123.988948]  [<ffffffff810bc53e>] ? finish_task_switch+0x4e/0xe0
[  123.990027]  [<ffffffff8163b669>] ? __schedule+0x469/0x890
[  123.991106]  [<ffffffff8163bb6f>] ? schedule+0x3f/0x60
[  123.992176]  [<ffffffff816399ad>] ? schedule_timeout+0x1fd/0x350
[  123.993244]  [<ffffffff8104259c>] ? xen_clocksource_read+0x4c/0x80
[  123.994308]  [<ffffffff810c57f4>] ? update_curr+0x144/0x1e0
[  123.995370]  [<ffffffff8104a8c6>] ? xen_spin_lock+0xa6/0x110
[  123.996429]  [<ffffffff810bb491>] ? get_parent_ip+0x11/0x50
[  123.997489]  [<ffffffff8163aff0>] ? wait_for_common+0xd0/0x190
[  123.998545]  [<ffffffff810c0c20>] ? try_to_wake_up+0x2c0/0x2c0
[  123.999600]  [<ffffffff8163b18d>] ? wait_for_completion+0x1d/0x20
[  124.000660]  [<ffffffff81089eb9>] ? do_fork+0xe9/0x350
[  124.001715]  [<ffffffff810a5640>] ? call_usermodehelper_exec+0xe0/0xe0
[  124.002781]  [<ffffffff810557d6>] ? kernel_thread+0x76/0x80
[  124.003847]  [<ffffffff810a5290>] ? call_usermodehelper_setup+0xa0/0xa0
[  124.004914]  [<ffffffff81646630>] ? gs_change+0x13/0x13
[  124.005982]  [<ffffffff816409ad>] ? sub_preempt_count+0x9d/0xd0
[  124.007009]  [<ffffffff810a5677>] ? __call_usermodehelper+0x37/0xb0
[  124.007991]  [<ffffffff810a7b59>] ? process_one_work+0x129/0x4e0
[  124.008965]  [<ffffffff810a9c4e>] ? worker_thread+0x17e/0x410
[  124.009923]  [<ffffffff810a9ad0>] ? manage_workers+0x210/0x210
[  124.010882]  [<ffffffff810ae906>] ? kthread+0x96/0xa0
[  124.011830]  [<ffffffff81646634>] ? kernel_thread_helper+0x4/0x10
[  124.012765]  [<ffffffff816446e3>] ? int_ret_from_sys_call+0x7/0x1b
[  124.013684]  [<ffffffff8163d200>] ? retint_restore_args+0x5/0x6
[  124.014603]  [<ffffffff81646630>] ? gs_change+0x13/0x13
(XEN) Domain 0 crashed: rebooting machine in 5 seconds.
amtterm: RUN_SOL -> ERROR (failure)
amtterm: ERROR: redir_data: unknown r->buf 0x29

