Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739Ab2ISJMj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 05:12:39 -0400
Received: from mail.skyhub.de ([78.46.96.112]:38381 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751610Ab2ISJMf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 05:12:35 -0400
Date: Wed, 19 Sep 2012 11:12:30 +0200
From: Borislav Petkov <bp@alien8.de>
To: Peter Zijlstra <peterz@infradead.org>,
        Akinobu Mita <akinobu.mita@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: kernel BUG at kernel/sched/core.c:1465!
Message-ID: <20120919091230.GA25576@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Akinobu Mita <akinobu.mita@gmail.com>,
	lkml <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I got the below oops when running rc6 + tip/master from two days ago and
CONFIG_DEBUG_PAGEALLOC enabled.

Looks like the task's runqueue is not this runqueue on the CPU it
happened - in this case CPU 5.

I was running a simple workload where a userspace test is pinned on each
core with taskset.

[10199.391444] ------------[ cut here ]------------
[10199.396440] kernel BUG at kernel/sched/core.c:1465!
[10199.401288] invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC
[10199.406684] Modules linked in: nfsv3 nfs_acl nfs lockd sunrpc radeon kvm_amd kvm fbcon tileblit ttm font bitblit softcursor drm_kms_helper drm psmou
se microcode bnx2 i2c_algo_bit i2c_piix4 serio_raw
[10199.425015] CPU 5 
[10199.426844] Pid: 4, comm: kworker/0:0 Not tainted 3.6.0-rc6-kvm+ #1 AMD
[10199.434642] RIP: 0010:[<ffffffff814dbe65>]  [<ffffffff814dbe65>] __schedule+0x1af/0x578
[10199.442616] RSP: 0018:ffff880425c797f0  EFLAGS: 00010087
[10199.448193] RAX: ffff880427d53880 RBX: ffff880427d53880 RCX: 0000000000000005
[10199.455595] RDX: ffffffff8108ea0b RSI: 0000000000000005 RDI: ffff880427c13840
[10199.462691] RBP: ffff880425c79880 R08: 0000000000000400 R09: 0000000000000000
[10199.469787] R10: ffff880425d89c8a R11: 00000000ffffffff R12: ffff8804255ddac0
[10199.476881] R13: ffff880427c13880 R14: 0000000000000005 R15: ffff880425c64410
[10199.483977] FS:  00007f5d51dbe700(0000) GS:ffff880427d40000(0000) knlGS:0000000000000000
[10199.492021] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[10199.497735] CR2: 00007f5d518c29f0 CR3: 0000000001a0b000 CR4: 00000000000407e0
[10199.504830] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[10199.511926] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[10199.519021] Process kworker/0:0 (pid: 4, threadinfo ffff880425c78000, task ffff880425c64410)
[10199.528026] Stack:
[10199.530025]  0000000000013880 0000000000013880 0000000000013880 ffff880425c64410
[10199.537416]  0000000000013880 ffff880425c79fd8 0000000000013880 0000000000013880
[10199.544810]  ffff880425c79fd8 0000000000013880 ffff880425c79850 ffff880425c64410
[10199.552206] Call Trace:
[10199.554639]  [<ffffffff814dc2f7>] schedule+0x64/0x66
[10199.559577]  [<ffffffff814daf5f>] schedule_timeout+0x36/0xe5
[10199.565207]  [<ffffffff8106d186>] ? ttwu_do_wakeup+0x59/0xd0
[10199.571107]  [<ffffffff814dcd3b>] ? _raw_spin_unlock_irqrestore+0x1a/0x1d
[10199.578199]  [<ffffffff814dbb86>] wait_for_common+0x9d/0x113
[10199.583826]  [<ffffffff8106f179>] ? try_to_wake_up+0x1eb/0x1eb
[10199.589627]  [<ffffffff814dcd3b>] ? _raw_spin_unlock_irqrestore+0x1a/0x1d
[10199.596378]  [<ffffffff814dbcb4>] wait_for_completion+0x1d/0x1f
[10199.602267]  [<ffffffff810a1038>] stop_one_cpu+0x60/0x77
[10199.607549]  [<ffffffff8106d501>] ? __migrate_task+0xf6/0xf6
[10199.613176]  [<ffffffff8106b033>] ? task_rq_unlock+0x22/0x27
[10199.618803]  [<ffffffff8106f342>] set_cpus_allowed_ptr+0xbe/0xe4
[10199.624777]  [<ffffffff813ede71>] ? query_current_values_with_pending_wait+0x33/0x95
[10199.632478]  [<ffffffff813eeb85>] powernowk8_target+0x601/0x640
[10199.638364]  [<ffffffff8108ea0b>] ? do_raw_spin_lock+0x9/0xd
[10199.643992]  [<ffffffff813ec0ac>] ? cpufreq_stat_notifier_trans+0x88/0x93
[10199.650742]  [<ffffffff813e9b7d>] __cpufreq_driver_target+0x41/0x43
[10199.656976]  [<ffffffff813ecd27>] cpufreq_governor_dbs+0x2c9/0x2e6
[10199.663123]  [<ffffffff813e9cbb>] __cpufreq_governor+0x68/0xa5
[10199.668923]  [<ffffffff813e9e80>] __cpufreq_set_policy+0x137/0x143
[10199.675068]  [<ffffffff813eba6c>] cpufreq_update_policy+0xbd/0xe1
[10199.681130]  [<ffffffff813eba90>] ? cpufreq_update_policy+0xe1/0xe1
[10199.687365]  [<ffffffff812d15fc>] acpi_processor_ppc_has_changed+0x62/0x69
[10199.694204]  [<ffffffff8111927b>] ? virt_to_head_page+0x9/0x2c
[10199.700006]  [<ffffffff812cdea1>] acpi_processor_notify+0x55/0x115
[10199.706154]  [<ffffffff812a8849>] acpi_device_notify+0x19/0x1b
[10199.711956]  [<ffffffff812b573d>] acpi_ev_notify_dispatch+0x41/0x5c
[10199.718188]  [<ffffffff812a5932>] acpi_os_execute_deferred+0x27/0x34
[10199.724507]  [<ffffffff8105af8a>] process_one_work+0x1a7/0x2a3
[10199.730307]  [<ffffffff812a590b>] ? acpi_os_wait_events_complete+0x23/0x23
[10199.737145]  [<ffffffff8105cb27>] worker_thread+0x20f/0x29b
[10199.742686]  [<ffffffff814dcd3b>] ? _raw_spin_unlock_irqrestore+0x1a/0x1d
[10199.749437]  [<ffffffff8105c918>] ? manage_workers+0x243/0x243
[10199.755237]  [<ffffffff810607e1>] kthread+0x95/0x9d
[10199.760089]  [<ffffffff814e4cc4>] kernel_thread_helper+0x4/0x10
[10199.765977]  [<ffffffff8106074c>] ? kthread_freezable_should_stop+0x41/0x41
[10199.772899]  [<ffffffff814e4cc0>] ? gs_change+0x13/0x13
[10199.778093] Code: 00 00 00 48 8b 40 08 4c 8b 6d 90 8b 40 18 4c 03 2c c5 40 27 a9 81 48 c7 c0 80 38 01 00 65 48 03 04 25 08 db 00 00 49 39 c5 74 02 <0f> 0b 4c 3b 65 88 75 02 0f 0b 4d 8d bc 24 da 05 00 00 4c 89 ff 
[10199.797435] RIP  [<ffffffff814dbe65>] __schedule+0x1af/0x578
[10199.803074]  RSP <ffff880425c797f0>
[10199.849926] ---[ end trace 4418a7e0165bd3f8 ]---


-- 
Regards/Gruss,
    Boris.
