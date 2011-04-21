Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752378Ab1DUCEd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 22:04:33 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46792 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211Ab1DUCEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 22:04:30 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Subject: Re: Linux 2.6.39-rc4 (regression: NUMA on multi-node CPUs broken)
Cc: kosaki.motohiro@jp.fujitsu.com,
        Andreas Herrmann <herrmann.der.user@googlemail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Tejun Heo <tj@kernel.org>
In-Reply-To: <alpine.DEB.2.00.1104201722540.15906@chino.kir.corp.google.com>
References: <20110420153907.GA9000@alberich.amd.com> <alpine.DEB.2.00.1104201722540.15906@chino.kir.corp.google.com>
Message-Id: <20110421110452.7322.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Thu, 21 Apr 2011 11:04:26 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Right, this yields cpuless nodes that the scheduler can't handle.  Prior 
> to the unification and cleanup, NUMA emulation would bind cpus to all 
> nodes that are allocated on the physical node that it has affinity with on 
> the board.  This causes all nodes to have bound cpus such that 
> node_to_cpumask() correctly reveals the proximity that cpus have to its 
> nodes, either emulated or otherwise.
> 
> We usually don't touch NUMA code for real architectures to fix a problem 
> that can only happen with NUMA emulation, so 7d6b46707f24 should probably 
> be reverted.
> 
> With that patch reverted, NUMA emulation works fine for me; for example, 
> with numa=fake=8:
> 
> 	/sys/devices/system/node/node0/cpulist:0-3
> 	/sys/devices/system/node/node1/cpulist:4-7
> 	/sys/devices/system/node/node2/cpulist:8-11
> 	/sys/devices/system/node/node3/cpulist:12-15
> 	/sys/devices/system/node/node4/cpulist:0-3
> 	/sys/devices/system/node/node5/cpulist:4-7
> 	/sys/devices/system/node/node6/cpulist:8-11
> 	/sys/devices/system/node/node7/cpulist:12-15
> 
> I'm not sure what it's trying to address (yes, there is a problem with the 
> binding for CONFIG_NUMA_EMU && CONFIG_DEBUG_PER_CPU_MAPS, but not 
> otherwise).
> 
> KOSAKI-san?

Simple revert 7d6b46707f24 makes the same boot failure again.

[    0.215976] Pid: 1, comm: swapper Not tainted 2.6.39-rc4+ #10 FUJITSU-SV      PRIMERGY                      /D2559-A1
[    0.215976] RIP: 0010:[<ffffffff81085b94>]  [<ffffffff81085b94>] find_busiest_group+0x464/0xea0
[    0.215976] RSP: 0018:ffff88003c67d850  EFLAGS: 00010046
[    0.215976] RAX: 0000000000000000 RBX: 00000000001d2ec0 RCX: 0000000000000000
[    0.215976] RDX: 0000000000000000 RSI: 0000000000000002 RDI: 0000000000000000
[    0.215976] RBP: ffff88003c67da10 R08: 0000000000000000 R09: 0000000000000000
[    0.215976] R10: 0000000000000400 R11: 0000000000000000 R12: 00000000001d2ec0
[    0.215976] R13: 00000000ffffffff R14: ffff88003c640780 R15: 0000000000000001
[    0.215976] FS:  0000000000000000(0000) GS:ffff88003fc00000(0000) knlGS:0000000000000000
[    0.215976] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    0.215976] CR2: 0000000000000000 CR3: 0000000001a03000 CR4: 00000000000006f0
[    0.215976] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    0.215976] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    0.215976] Process swapper (pid: 1, threadinfo ffff88003c67c000, task ffff88003c678040)
[    0.215976] Stack:
[    0.215976]  ffff88003c678078 ffff88003c67d9a0 ffff88003c67d880 ffff88003fc00000
[    0.215976]  0000000000000000 00000000001d2ec0 ffff88003c67db00 0100000000000002
[    0.215976]  ffff88003c67dbdc 0000000000000001 ffff88003fc0e4a0 000000003c678040
[    0.215976] Call Trace:
[    0.215976]  [<ffffffff810c24ff>] ? local_clock+0x6f/0x80
[    0.215976]  [<ffffffff8108c875>] load_balance+0xc5/0x990
[    0.215976]  [<ffffffff810d05ed>] ? trace_hardirqs_off+0xd/0x10
[    0.215976]  [<ffffffff810c24ff>] ? local_clock+0x6f/0x80
[    0.215976]  [<ffffffff8107e6a2>] ? update_shares+0x162/0x1a0
[    0.215976]  [<ffffffff8107e6ba>] ? update_shares+0x17a/0x1a0
[    0.215976]  [<ffffffff8107e540>] ? update_cfs_shares+0x1d0/0x1d0
[    0.215976]  [<ffffffff815a2673>] schedule+0xb03/0xb10
[    0.215976]  [<ffffffff810d48e1>] ? __lock_acquire+0x541/0x1e80
[    0.215976]  [<ffffffff810c24ff>] ? local_clock+0x6f/0x80
[    0.215976]  [<ffffffff815a2fa5>] schedule_timeout+0x265/0x320
[    0.215976]  [<ffffffff810d05ed>] ? trace_hardirqs_off+0xd/0x10
[    0.215976]  [<ffffffff810c24ff>] ? local_clock+0x6f/0x80
[    0.215976]  [<ffffffff810d0625>] ? lock_release_holdtime+0x35/0x180
[    0.215976]  [<ffffffff815a59e0>] ? _raw_spin_unlock_irq+0x30/0x40
[    0.215976]  [<ffffffff815a59e0>] ? _raw_spin_unlock_irq+0x30/0x40
[    0.215976]  [<ffffffff815a2a80>] wait_for_common+0x130/0x190
[    0.215976]  [<ffffffff8108ddb0>] ? try_to_wake_up+0x520/0x520
[    0.215976]  [<ffffffff815a2bbd>] wait_for_completion+0x1d/0x20
[    0.215976]  [<ffffffff810bafbc>] kthread_create_on_node+0xac/0x150
[    0.215976]  [<ffffffff810b3870>] ? process_scheduled_works+0x40/0x40
[    0.215976]  [<ffffffff815a299f>] ? wait_for_common+0x4f/0x190
[    0.215976]  [<ffffffff810b5f03>] __alloc_workqueue_key+0x1a3/0x590
[    0.215976]  [<ffffffff81cc2864>] cpuset_init_smp+0x64/0x74
[    0.215976]  [<ffffffff81ca8cd7>] kernel_init+0xa9/0x168
[    0.215976]  [<ffffffff815af4e4>] kernel_thread_helper+0x4/0x10
[    0.215976]  [<ffffffff815a61d4>] ? retint_restore_args+0x13/0x13
[    0.215976]  [<ffffffff81ca8c2e>] ? start_kernel+0x3f6/0x3f6
[    0.215976]  [<ffffffff815af4e0>] ? gs_change+0x13/0x13
[    0.215976] Code: 50 fe ff ff 41 89 50 08 0f 1f 80 00 00 00 00 48 8b 95 b0 fe ff ff 48 8b 7d 98 44 8b 42 08 48 89 f8 31 d2 48 c1 e0 0a 48 8b 4d a0
[    0.215976]  f7 f0 48 85 c9 48 89 c6 49 89 c1 48 89 45 90 74 1f 31 d2 48
[    0.215976] RIP  [<ffffffff81085b94>] find_busiest_group+0x464/0xea0
[    0.215976]  RSP <ffff88003c67d850>
[    0.215976] divide error: 0000 [#2]
[    0.215976] ---[ end trace 93d72a36b9146f22 ]---
[    0.215990] swapper used greatest stack depth: 3608 bytes left
[    0.216000] Kernel panic - not syncing: Attempted to kill init!
[    0.216002] Pid: 1, comm: swapper Tainted: G      D     2.6.39-rc4+ #10
[    0.216003] Call Trace:
[    0.216006]  [<ffffffff815a1816>] panic+0x91/0x1ab
[    0.216009]  [<ffffffff815a5a20>] ? _raw_write_unlock_irq+0x30/0x40
[    0.216011]  [<ffffffff8109b0ca>] ? do_exit+0x80a/0x970
[    0.216013]  [<ffffffff8109b183>] do_exit+0x8c3/0x970
[    0.216016]  [<ffffffff815a71ef>] oops_end+0xaf/0xf0
[    0.216019]  [<ffffffff81040fab>] die+0x5b/0x90
[    0.216021]  [<ffffffff815a68e4>] do_trap+0xc4/0x170
[    0.216023]  [<ffffffff8103de4f>] do_divide_error+0x8f/0xb0
[    0.216025]  [<ffffffff81085b94>] ? find_busiest_group+0x464/0xea0
[    0.216028]  [<ffffffff812c8d2d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[    0.216030]  [<ffffffff815a6204>] ? restore_args+0x30/0x30
[    0.216033]  [<ffffffff815af2fb>] divide_error+0x1b/0x20
[    0.216035]  [<ffffffff81085b94>] ? find_busiest_group+0x464/0xea0
[    0.216038]  [<ffffffff810c24ff>] ? local_clock+0x6f/0x80
[    0.216041]  [<ffffffff8108c875>] load_balance+0xc5/0x990
[    0.216043]  [<ffffffff810d05ed>] ? trace_hardirqs_off+0xd/0x10
[    0.216046]  [<ffffffff810c24ff>] ? local_clock+0x6f/0x80
[    0.216048]  [<ffffffff8107e6a2>] ? update_shares+0x162/0x1a0
[    0.216051]  [<ffffffff8107e6ba>] ? update_shares+0x17a/0x1a0
[    0.216053]  [<ffffffff8107e540>] ? update_cfs_shares+0x1d0/0x1d0
[    0.216055]  [<ffffffff815a2673>] schedule+0xb03/0xb10
[    0.216058]  [<ffffffff810d48e1>] ? __lock_acquire+0x541/0x1e80
[    0.216060]  [<ffffffff810c24ff>] ? local_clock+0x6f/0x80
[    0.216062]  [<ffffffff815a2fa5>] schedule_timeout+0x265/0x320
[    0.216064]  [<ffffffff810d05ed>] ? trace_hardirqs_off+0xd/0x10
[    0.216066]  [<ffffffff810c24ff>] ? local_clock+0x6f/0x80
[    0.216069]  [<ffffffff810d0625>] ? lock_release_holdtime+0x35/0x180
[    0.216071]  [<ffffffff815a59e0>] ? _raw_spin_unlock_irq+0x30/0x40
[    0.216073]  [<ffffffff815a59e0>] ? _raw_spin_unlock_irq+0x30/0x40
[    0.216076]  [<ffffffff815a2a80>] wait_for_common+0x130/0x190
[    0.216078]  [<ffffffff8108ddb0>] ? try_to_wake_up+0x520/0x520
[    0.216080]  [<ffffffff815a2bbd>] wait_for_completion+0x1d/0x20
[    0.216083]  [<ffffffff810bafbc>] kthread_create_on_node+0xac/0x150
[    0.216085]  [<ffffffff810b3870>] ? process_scheduled_works+0x40/0x40
[    0.216088]  [<ffffffff815a299f>] ? wait_for_common+0x4f/0x190
[    0.216090]  [<ffffffff810b5f03>] __alloc_workqueue_key+0x1a3/0x590
[    0.216092]  [<ffffffff81cc2864>] cpuset_init_smp+0x64/0x74
[    0.216095]  [<ffffffff81ca8cd7>] kernel_init+0xa9/0x168
[    0.216097]  [<ffffffff815af4e4>] kernel_thread_helper+0x4/0x10
[    0.216099]  [<ffffffff815a61d4>] ? retint_restore_args+0x13/0x13
[    0.216101]  [<ffffffff81ca8c2e>] ? start_kernel+0x3f6/0x3f6
[    0.216103]  [<ffffffff815af4e0>] ? gs_change+0x13/0x13
[    0.215976] SMP
[    0.215976] last sysfs file:
[    0.215976] CPU 1
[    0.215976] Modules linked in:
[    0.215976]
[    0.215976] Pid: 2, comm: kthreadd Tainted: G      D     2.6.39-rc4+ #10 FUJITSU-SV      PRIMERGY                      /D2559-A1
[    0.215976] RIP: 0010:[<ffffffff81084d65>]  [<ffffffff81084d65>] select_task_rq_fair+0x855/0xb80
[    0.215976] RSP: 0000:ffff88003c67fc40  EFLAGS: 00010046
[    0.215976] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
[    0.215976] RDX: 0000000000000000 RSI: 0000000000000002 RDI: 0000000000000002
[    0.215976] RBP: ffff88003c67fcf0 R08: ffff88007aa133f0 R09: 0000000000000000
[    0.215976] R10: 0000000000000000 R11: 0000000000000001 R12: ffff88007aa133f0
[    0.215976] R13: ffff88007aa133d8 R14: 0000000000000000 R15: 0000000000000000
[    0.215976] FS:  0000000000000000(0000) GS:ffff88007fc00000(0000) knlGS:0000000000000000
[    0.215976] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    0.215976] CR2: 0000000000000000 CR3: 0000000001a03000 CR4: 00000000000006e0
[    0.215976] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    0.215976] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    0.215976] Process kthreadd (pid: 2, threadinfo ffff88003c67e000, task ffff88003c680080)
[    0.215976] Stack:
[    0.215976]  ffffffff815a5a20 000000007aa886e8 ffff88007fdd2ed8 0000000000000002
[    0.215976]  0000000000000000 00000000001d2ec0 000000000000007d 0000000000000200
[    0.215976]  ffffffffffffffff 0000000000000000 0000000100000008 ffffffff00000001
[    0.215976] Call Trace:
[    0.215976]  [<ffffffff815a5a20>] ? _raw_write_unlock_irq+0x30/0x40
[    0.215976]  [<ffffffff8108e201>] wake_up_new_task+0x41/0x1b0
[    0.215976]  [<ffffffff810b6cd0>] ? __task_pid_nr_ns+0xc0/0x100
[    0.215976]  [<ffffffff810b6c10>] ? cpumask_weight+0x20/0x20
[    0.215976]  [<ffffffff81095112>] do_fork+0xe2/0x3a0
[    0.215976]  [<ffffffff815a59e0>] ? _raw_spin_unlock_irq+0x30/0x40
[    0.215976]  [<ffffffff815a59e0>] ? _raw_spin_unlock_irq+0x30/0x40
[    0.215976]  [<ffffffff81044885>] ? native_sched_clock+0x15/0x70
[    0.215976]  [<ffffffff810c24ff>] ? local_clock+0x6f/0x80
[    0.215976]  [<ffffffff810456d6>] kernel_thread+0x76/0x80
[    0.215976]  [<ffffffff810bac70>] ? __init_kthread_worker+0x70/0x70
[    0.215976]  [<ffffffff815af4e0>] ? gs_change+0x13/0x13
[    0.215976]  [<ffffffff810bb1c3>] kthreadd+0x113/0x150
[    0.215976]  [<ffffffff815af4e4>] kernel_thread_helper+0x4/0x10
[    0.215976]  [<ffffffff815a61d4>] ? retint_restore_args+0x13/0x13
[    0.215976]  [<ffffffff810bb0b0>] ? tsk_fork_get_node+0x30/0x30
[    0.215976]  [<ffffffff815af4e0>] ? gs_change+0x13/0x13
[    0.215976] Code: ff ff 44 89 fe 89 c7 e8 4a 26 ff ff 8b 8d 68 ff ff ff 8b 95 70 ff ff ff eb 93 0f 1f 40 00 31 d2 48 89 d8 41 8b 4d 08 48 c1 e0 0a
[    0.215976]  f7 f1 45 85 f6 75 43 48 3b 45 90 0f 83 d9 fe ff ff 4c 89 6d
[    0.215976] RIP  [<ffffffff81084d65>] select_task_rq_fair+0x855/0xb80
[    0.215976]  RSP <ffff88003c67fc40>
[    0.215976] ---[ end trace 93d72a36b9146f23 ]---




