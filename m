Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243Ab1LaPNT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Dec 2011 10:13:19 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:40041 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146Ab1LaPNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Dec 2011 10:13:16 -0500
Message-ID: <1325344394.28904.43.camel@lappy>
Subject: [BUG] 3.2-rc7: Hang when calling clone()
From: Sasha Levin <levinsasha928@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Date: Sat, 31 Dec 2011 17:13:14 +0200
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.2 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

During recent fuzzer tests (Trinity over KVM tool), I've managed to cause the following kernel oops:

[10080.793053] INFO: task kworker/u:0:5 blocked for more than 120 seconds.
[10080.794297] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[10080.795751] kworker/u:0     D ffff880015320bd8  4576     5      2 0x00000000
[10080.797127]  ffff880019d5ba00 0000000000000082 ffff8800ffffffff 000016b2b9b199b6
[10080.798571]  ffff88001a7d3ec0 00000000001d33c0 ffff880019d3d800 00000000001d33c0
[10080.800050]  ffff880019d5bfd8 ffff880019d5a000 00000000001d33c0 00000000001d33c0
[10080.802092] Call Trace:
[10080.802546]  [<ffffffff823d87fa>] schedule+0x3a/0x50
[10080.803466]  [<ffffffff823d90e5>] schedule_timeout+0x245/0x2c0
[10080.804522]  [<ffffffff810e7e2e>] ? mark_held_locks+0x6e/0x130
[10080.805580]  [<ffffffff810e54f2>] ? lock_release_holdtime+0xb2/0x160
[10080.806743]  [<ffffffff823db2ab>] ? _raw_spin_unlock_irq+0x2b/0x70
[10080.807885]  [<ffffffff810a4831>] ? get_parent_ip+0x11/0x50
[10080.808933]  [<ffffffff823d8d70>] wait_for_common+0x120/0x170
[10080.810118]  [<ffffffff810a3150>] ? try_to_wake_up+0x350/0x350
[10080.811205]  [<ffffffff810a33e4>] ? wake_up_new_task+0x124/0x1f0
[10080.812318]  [<ffffffff823d8e68>] wait_for_completion+0x18/0x20
[10080.813416]  [<ffffffff810ae9c4>] do_fork+0xf4/0x330
[10080.814339]  [<ffffffff823d8c94>] ? wait_for_common+0x44/0x170
[10080.815429]  [<ffffffff8104bd91>] kernel_thread+0x71/0x80
[10080.816448]  [<ffffffff810c6bd0>] ? proc_cap_handler+0x1c0/0x1c0
[10080.817565]  [<ffffffff823deac0>] ? gs_change+0x13/0x13
[10080.818543]  [<ffffffff810c6de2>] __call_usermodehelper+0x32/0xa0
[10080.819679]  [<ffffffff810c7bd7>] process_one_work+0x1c7/0x460
[10080.820754]  [<ffffffff810c7b76>] ? process_one_work+0x166/0x460
[10080.821843]  [<ffffffff810c6db0>] ? call_usermodehelper_freeinfo+0x30/0x30
[10080.823078]  [<ffffffff810c9152>] worker_thread+0x162/0x340
[10080.824108]  [<ffffffff810c8ff0>] ? manage_workers.clone.20+0x240/0x240
[10080.825286]  [<ffffffff810cf716>] kthread+0xb6/0xc0
[10080.826171]  [<ffffffff823deac4>] kernel_thread_helper+0x4/0x10
[10080.827235]  [<ffffffff823dc038>] ? retint_restore_args+0x13/0x13
[10080.828368]  [<ffffffff810cf660>] ? kthread_flush_work_fn+0x10/0x10
[10080.829538]  [<ffffffff823deac0>] ? gs_change+0x13/0x13
[10080.843036] 2 locks held by kworker/u:0/5:
[10080.843803]  #0:  (khelper){.+.+.+}, at: [<ffffffff810c7b76>] process_one_work+0x166/0x460
[10080.845447]  #1:  ((&sub_info->work)){+.+.+.}, at: [<ffffffff810c7b76>] process_one_work+0x166/0x460
[10080.847223] Kernel panic - not syncing: hung_task: blocked tasks
[10080.848338] Pid: 947, comm: khungtaskd Not tainted 3.2.0-rc7-sasha-00039-g89307ba #93
[10080.849787] Call Trace:
[10080.850361]  [<ffffffff823d7811>] panic+0x96/0x1c5
[10080.851259]  [<ffffffff810e6021>] ? print_lock+0x61/0xb0
[10080.852251]  [<ffffffff81126a46>] watchdog+0x2b6/0x2f0
[10080.853205]  [<ffffffff81126800>] ? watchdog+0x70/0x2f0
[10080.854188]  [<ffffffff823db273>] ? _raw_spin_unlock_irqrestore+0x93/0xa0
[10080.855421]  [<ffffffff81126790>] ? hung_task_panic+0x20/0x20
[10080.856463]  [<ffffffff810cf716>] kthread+0xb6/0xc0
[10080.857363]  [<ffffffff823deac4>] kernel_thread_helper+0x4/0x10
[10080.858458]  [<ffffffff823dc038>] ? retint_restore_args+0x13/0x13
[10080.859570]  [<ffffffff810cf660>] ? kthread_flush_work_fn+0x10/0x10
[10080.860743]  [<ffffffff823deac0>] ? gs_change+0x13/0x13

This is the syscall that caused that:

clone(clone_flags=0xd8220000, newsp=0xf3f270[page_0xff], parent_tid=0xf41290[page_allocs], child_tid=0xf3f270[page_0xff], regs=0x7f1b066a1000)

I've seen two variants of this, one where the hang was in the same process that called clone(), and one (like the above) where it happened in kworker. In both cases, the stack above do_fork() is the same.

-- 

Sasha.

