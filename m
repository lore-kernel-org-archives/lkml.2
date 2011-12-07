Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758311Ab1LGT73 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 14:59:29 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62110 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756215Ab1LGT71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 14:59:27 -0500
Message-ID: <1323287944.3904.4.camel@lappy>
Subject: Re: linux-next: Tree for Dec 7
From: Sasha Levin <levinsasha928@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        prasadjoshi.linux@gmail.com
Date: Wed, 07 Dec 2011 21:59:04 +0200
In-Reply-To: <1323254393.4009.6.camel@lappy>
References: <20111207171218.e11db78531e7f20659e2ca65@canb.auug.org.au>
	 <1323254393.4009.6.camel@lappy>
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.2 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bugs below were bisected to:

commit 39da12ef4bbeded56cfc64bbea3ff877abbd596b
Author: Prasad Joshi <prasadjoshi.linux@gmail.com>
Date:   Mon Oct 31 20:32:20 2011 +0530

    logfs: take write mutex lock during fsync and sync

Cc'ed Prasad.

On Wed, 2011-12-07 at 12:39 +0200, Sasha Levin wrote:
> Hi,
> 
> I got a stream of warnings and bugs in today's linux-next tree when
> trying to simply mount a (non logfs) filesystem. This has worked fine in
> yesterday's linux-next.
> 
> Here are the warnings:
> 
> [   46.120751] INFO: trying to register non-static key.
> [   46.121026] the code is fine but needs lockdep annotation.
> [   46.121026] turning off the locking correctness validator.
> [   46.121026] Pid: 2817, comm: mount Not tainted 3.2.0-rc4-next-20111207-sasha-00003-gd171823 #51
> [   46.121026] Call Trace:
> [   46.121026]  [<ffffffff810ec2e4>] __lock_acquire+0x1574/0x1f00
> [   46.121026]  [<ffffffff823e116b>] ? _raw_spin_unlock_irq+0x2b/0x70
> [   46.121026]  [<ffffffff810c60bd>] ? sub_preempt_count+0x9d/0xd0
> [   46.121026]  [<ffffffff823e1186>] ? _raw_spin_unlock_irq+0x46/0x70
> [   46.121026]  [<ffffffff823e03b2>] ? wait_for_common+0x62/0x170
> [   46.121026]  [<ffffffff810c46b0>] ? try_to_wake_up+0x350/0x350
> [   46.121026]  [<ffffffff810ed2e5>] lock_acquire+0xc5/0x100
> [   46.121026]  [<ffffffff81432ece>] ? logfs_get_wblocks+0x3e/0x90
> [   46.121026]  [<ffffffff811c9ed1>] ? writeback_inodes_sb_nr+0x151/0x190
> [   46.121026]  [<ffffffff823de095>] __mutex_lock_common+0x65/0x5b0
> [   46.121026]  [<ffffffff81432ece>] ? logfs_get_wblocks+0x3e/0x90
> [   46.121026]  [<ffffffff81432ece>] ? logfs_get_wblocks+0x3e/0x90
> [   46.121026]  [<ffffffff823de620>] mutex_lock_nested+0x40/0x50
> [   46.121026]  [<ffffffff81432ece>] logfs_get_wblocks+0x3e/0x90
> [   46.121026]  [<ffffffff8142fac8>] logfs_sync_fs+0x18/0x40
> [   46.121026]  [<ffffffff811cd9fe>] __sync_filesystem+0x5e/0x90
> [   46.121026]  [<ffffffff811cda82>] sync_filesystem+0x32/0x60
> [   46.121026]  [<ffffffff81437237>] logfs_kill_sb+0x27/0xe0
> [   46.121026]  [<ffffffff811a46a8>] deactivate_locked_super+0x38/0x90
> [   46.121026]  [<ffffffff81437c25>] logfs_mount+0x265/0x760
> [   46.121026]  [<ffffffff811a5f82>] mount_fs+0x42/0x1b0
> [   46.121026]  [<ffffffff8115decb>] ? __alloc_percpu+0xb/0x10
> [   46.121026]  [<ffffffff811c1a6e>] vfs_kern_mount+0x5e/0xd0
> [   46.121026]  [<ffffffff823e1500>] ? _raw_read_unlock+0x30/0x60
> [   46.121026]  [<ffffffff811c2dff>] do_kern_mount+0x4f/0x100
> [   46.121026]  [<ffffffff811c382f>] do_mount+0x50f/0x820
> [   46.121026]  [<ffffffff81158b63>] ? strndup_user+0x53/0x70
> [   46.121026]  [<ffffffff811c3cbb>] sys_mount+0x8b/0xe0
> [   46.121026]  [<ffffffff823e2779>] system_call_fastpath+0x16/0x1b
> [   46.163790] BUG: unable to handle kernel NULL pointer dereference at           (null)
> [   46.164433] IP: [<ffffffff817c9fd6>] __list_add+0x26/0xa0
> [   46.164433] PGD 10ed3067 PUD 10525067 PMD 0 
> [   46.164433] Oops: 0000 [#1] PREEMPT SMP 
> [   46.164433] CPU 0 
> [   46.164433] Pid: 2817, comm: mount Not tainted 3.2.0-rc4-next-20111207-sasha-00003-gd171823 #51  
> [   46.164433] RIP: 0010:[<ffffffff817c9fd6>]  [<ffffffff817c9fd6>] __list_add+0x26/0xa0
> [   46.164433] RSP: 0018:ffff880011667b78  EFLAGS: 00010046
> [   46.164433] RAX: ffff88001045ac20 RBX: ffff880011667c08 RCX: 0000000000000000
> [   46.164433] RDX: ffff880010d5dec0 RSI: 0000000000000000 RDI: ffff880011667c08
> [   46.164433] RBP: ffff880011667b98 R08: 0000000000000000 R09: 0000000000000000
> [   46.164433] R10: 0000000000000002 R11: 0000000000000000 R12: ffff880010d5dec0
> [   46.164433] R13: 0000000000000000 R14: 00000000ffffffff R15: ffffffffffffffea
> [   46.164433] FS:  00007f1686542740(0000) GS:ffff880013a00000(0000) knlGS:0000000000000000
> [   46.164433] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [   46.164433] CR2: 0000000000000000 CR3: 0000000010537000 CR4: 00000000000006f0
> [   46.164433] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   46.164433] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [   46.164433] Process mount (pid: 2817, threadinfo ffff880011666000, task ffff88001045ac20)
> [   46.164433] Stack:
> [   46.164433]  ffff880011667b98 ffff880010d5de70 0000000000000282 ffff880010d5de78
> [   46.164433]  ffff880011667c58 ffffffff823de157 ffffffff81432ece ffffffffffffffff
> [   46.164433]  ffffffff83c1f06c 0000000000000000 0000000000000000 ffffffff82a1c6bb
> [   46.164433] Call Trace:
> [   46.164433]  [<ffffffff823de157>] __mutex_lock_common+0x127/0x5b0
> [   46.164433]  [<ffffffff81432ece>] ? logfs_get_wblocks+0x3e/0x90
> [   46.164433]  [<ffffffff81432ece>] ? logfs_get_wblocks+0x3e/0x90
> [   46.164433]  [<ffffffff823de620>] mutex_lock_nested+0x40/0x50
> [   46.164433]  [<ffffffff81432ece>] logfs_get_wblocks+0x3e/0x90
> [   46.164433]  [<ffffffff8142fac8>] logfs_sync_fs+0x18/0x40
> [   46.164433]  [<ffffffff811cd9fe>] __sync_filesystem+0x5e/0x90
> [   46.164433]  [<ffffffff811cda82>] sync_filesystem+0x32/0x60
> [   46.164433]  [<ffffffff81437237>] logfs_kill_sb+0x27/0xe0
> [   46.164433]  [<ffffffff811a46a8>] deactivate_locked_super+0x38/0x90
> [   46.164433]  [<ffffffff81437c25>] logfs_mount+0x265/0x760
> [   46.164433]  [<ffffffff811a5f82>] mount_fs+0x42/0x1b0
> [   46.164433]  [<ffffffff8115decb>] ? __alloc_percpu+0xb/0x10
> [   46.164433]  [<ffffffff811c1a6e>] vfs_kern_mount+0x5e/0xd0
> [   46.164433]  [<ffffffff823e1500>] ? _raw_read_unlock+0x30/0x60
> [   46.164433]  [<ffffffff811c2dff>] do_kern_mount+0x4f/0x100
> [   46.164433]  [<ffffffff811c382f>] do_mount+0x50f/0x820
> [   46.164433]  [<ffffffff81158b63>] ? strndup_user+0x53/0x70
> [   46.164433]  [<ffffffff811c3cbb>] sys_mount+0x8b/0xe0
> [   46.164433]  [<ffffffff823e2779>] system_call_fastpath+0x16/0x1b
> [   46.164433] Code: 0b 90 90 90 90 55 48 89 e5 48 83 ec 20 48 89 5d e8 4c 89 65 f0 4c 89 6d f8 48 89 fb 4c 8b 42 08 49 89 f5 49 89 d4 49 39 f0 75 27 <4d> 8b 45 00 4d 39 c4 75 40 49 89 5c 24 08 4c 89 23 4c 89 6b 08 
> [   46.164433] RIP  [<ffffffff817c9fd6>] __list_add+0x26/0xa0
> [   46.164433]  RSP <ffff880011667b78>
> [   46.164433] CR2: 0000000000000000
> [   46.164433] ---[ end trace 0629a1357fe30cea ]---
> [   46.164433] note: mount[2817] exited with preempt_count 1
> [   46.164433] BUG: sleeping function called from invalid context at kernel/rwsem.c:21
> [   46.164433] in_atomic(): 1, irqs_disabled(): 1, pid: 2817, name: mount
> [   46.164433] INFO: lockdep is turned off.
> [   46.164433] irq event stamp: 7047
> [   46.164433] hardirqs last  enabled at (7047): [<ffffffff823e116b>] _raw_spin_unlock_irq+0x2b/0x70
> [   46.164433] hardirqs last disabled at (7046): [<ffffffff823e0f54>] _raw_spin_lock_irq+0x24/0x90
> [   46.164433] softirqs last  enabled at (7034): [<ffffffff811c88e4>] bdi_queue_work+0x54/0x70
> [   46.164433] softirqs last disabled at (7030): [<ffffffff823e0fd3>] _raw_spin_lock_bh+0x13/0x80
> [   46.164433] Pid: 2817, comm: mount Tainted: G      D      3.2.0-rc4-next-20111207-sasha-00003-gd171823 #51
> [   46.164433] Call Trace:
> [   46.164433]  [<ffffffff810e8990>] ? print_irqtrace_events+0xd0/0xe0
> [   46.164433]  [<ffffffff810c9be9>] __might_sleep+0x149/0x200
> [   46.164433]  [<ffffffff823dee85>] down_read+0x25/0x90
> [   46.164433]  [<ffffffff81101756>] acct_collect+0x46/0x1a0
> [   46.164433]  [<ffffffff8109ab14>] do_exit+0x744/0x950
> [   46.164433]  [<ffffffff810976b5>] ? kmsg_dump+0x75/0x1c0
> [   46.164433]  [<ffffffff823dd984>] ? printk+0x3c/0x3e
> [   46.164433]  [<ffffffff81045bb2>] oops_end+0xc2/0x110
> [   46.164433]  [<ffffffff81071642>] no_context+0x122/0x2e0
> [   46.164433]  [<ffffffff8107192d>] __bad_area_nosemaphore+0x12d/0x230
> [   46.164433]  [<ffffffff81071a3e>] bad_area_nosemaphore+0xe/0x10
> [   46.164433]  [<ffffffff810725e3>] do_page_fault+0x343/0x4e0
> [   46.164433]  [<ffffffff810459e0>] ? show_trace+0x10/0x20
> [   46.164433]  [<ffffffff823dd76f>] ? dump_stack+0x72/0x7b
> [   46.164433]  [<ffffffff810ec2e4>] ? __lock_acquire+0x1574/0x1f00
> [   46.164433]  [<ffffffff823e116b>] ? _raw_spin_unlock_irq+0x2b/0x70
> [   46.164433]  [<ffffffff817b4fce>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> [   46.164433]  [<ffffffff8106b431>] do_async_page_fault+0x31/0x90
> [   46.164433]  [<ffffffff823e21d5>] async_page_fault+0x25/0x30
> [   46.164433]  [<ffffffff817c9fd6>] ? __list_add+0x26/0xa0
> [   46.164433]  [<ffffffff823de157>] __mutex_lock_common+0x127/0x5b0
> [   46.164433]  [<ffffffff81432ece>] ? logfs_get_wblocks+0x3e/0x90
> [   46.164433]  [<ffffffff81432ece>] ? logfs_get_wblocks+0x3e/0x90
> [   46.164433]  [<ffffffff823de620>] mutex_lock_nested+0x40/0x50
> [   46.164433]  [<ffffffff81432ece>] logfs_get_wblocks+0x3e/0x90
> [   46.164433]  [<ffffffff8142fac8>] logfs_sync_fs+0x18/0x40
> [   46.164433]  [<ffffffff811cd9fe>] __sync_filesystem+0x5e/0x90
> [   46.164433]  [<ffffffff811cda82>] sync_filesystem+0x32/0x60
> [   46.164433]  [<ffffffff81437237>] logfs_kill_sb+0x27/0xe0
> [   46.164433]  [<ffffffff811a46a8>] deactivate_locked_super+0x38/0x90
> [   46.164433]  [<ffffffff81437c25>] logfs_mount+0x265/0x760
> [   46.164433]  [<ffffffff811a5f82>] mount_fs+0x42/0x1b0
> [   46.164433]  [<ffffffff8115decb>] ? __alloc_percpu+0xb/0x10
> [   46.164433]  [<ffffffff811c1a6e>] vfs_kern_mount+0x5e/0xd0
> [   46.164433]  [<ffffffff823e1500>] ? _raw_read_unlock+0x30/0x60
> [   46.164433]  [<ffffffff811c2dff>] do_kern_mount+0x4f/0x100
> [   46.164433]  [<ffffffff811c382f>] do_mount+0x50f/0x820
> [   46.164433]  [<ffffffff81158b63>] ? strndup_user+0x53/0x70
> [   46.164433]  [<ffffffff811c3cbb>] sys_mount+0x8b/0xe0
> [   46.164433]  [<ffffffff823e2779>] system_call_fastpath+0x16/0x1b
> [   46.275955] BUG: scheduling while atomic: mount/2817/0x10000002
> [   46.276972] INFO: lockdep is turned off.
> [   46.277649] Pid: 2817, comm: mount Tainted: G      D      3.2.0-rc4-next-20111207-sasha-00003-gd171823 #51
> [   46.279182] Call Trace:
> [   46.279574]  [<ffffffff810c18b5>] __schedule_bug+0x85/0x90
> [   46.280678]  [<ffffffff823dfbf7>] __schedule+0x887/0x930
> [   46.281845]  [<ffffffff810c6103>] __cond_resched+0x13/0x20
> [   46.282928]  [<ffffffff823dfe9c>] _cond_resched+0x2c/0x40
> [   46.283783]  [<ffffffff811617ad>] unmap_vmas+0x5cd/0x900
> [   46.284618]  [<ffffffff810457d5>] ? print_context_stack+0x75/0xd0
> [   46.285570]  [<ffffffff81169d0c>] exit_mmap+0x9c/0x140
> [   46.286379]  [<ffffffff81093057>] mmput+0x77/0x100
> [   46.287126]  [<ffffffff8109a1a8>] exit_mm+0x108/0x130
> [   46.288227]  [<ffffffff823e11a8>] ? _raw_spin_unlock_irq+0x68/0x70
> [   46.289560]  [<ffffffff8109a541>] do_exit+0x171/0x950
> [   46.291224]  [<ffffffff810976b5>] ? kmsg_dump+0x75/0x1c0
> [   46.293226]  [<ffffffff823dd984>] ? printk+0x3c/0x3e
> [   46.295163]  [<ffffffff81045bb2>] oops_end+0xc2/0x110
> [   46.296721]  [<ffffffff81071642>] no_context+0x122/0x2e0
> [   46.297932]  [<ffffffff8107192d>] __bad_area_nosemaphore+0x12d/0x230
> [   46.299132]  [<ffffffff81071a3e>] bad_area_nosemaphore+0xe/0x10
> [   46.300056]  [<ffffffff810725e3>] do_page_fault+0x343/0x4e0
> [   46.300898]  [<ffffffff810459e0>] ? show_trace+0x10/0x20
> [   46.301735]  [<ffffffff823dd76f>] ? dump_stack+0x72/0x7b
> [   46.302570]  [<ffffffff810ec2e4>] ? __lock_acquire+0x1574/0x1f00
> [   46.303646]  [<ffffffff823e116b>] ? _raw_spin_unlock_irq+0x2b/0x70
> [   46.305071]  [<ffffffff817b4fce>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> [   46.306479]  [<ffffffff8106b431>] do_async_page_fault+0x31/0x90
> [   46.307789]  [<ffffffff823e21d5>] async_page_fault+0x25/0x30
> [   46.308761]  [<ffffffff817c9fd6>] ? __list_add+0x26/0xa0
> [   46.309605]  [<ffffffff823de157>] __mutex_lock_common+0x127/0x5b0
> [   46.310551]  [<ffffffff81432ece>] ? logfs_get_wblocks+0x3e/0x90
> [   46.311469]  [<ffffffff81432ece>] ? logfs_get_wblocks+0x3e/0x90
> [   46.312467]  [<ffffffff823de620>] mutex_lock_nested+0x40/0x50
> [   46.313713]  [<ffffffff81432ece>] logfs_get_wblocks+0x3e/0x90
> [   46.314963]  [<ffffffff8142fac8>] logfs_sync_fs+0x18/0x40
> [   46.316239]  [<ffffffff811cd9fe>] __sync_filesystem+0x5e/0x90
> [   46.317421]  [<ffffffff811cda82>] sync_filesystem+0x32/0x60
> [   46.318287]  [<ffffffff81437237>] logfs_kill_sb+0x27/0xe0
> [   46.319117]  [<ffffffff811a46a8>] deactivate_locked_super+0x38/0x90
> [   46.320089]  [<ffffffff81437c25>] logfs_mount+0x265/0x760
> [   46.320904]  [<ffffffff811a5f82>] mount_fs+0x42/0x1b0
> [   46.321916]  [<ffffffff8115decb>] ? __alloc_percpu+0xb/0x10
> [   46.323146]  [<ffffffff811c1a6e>] vfs_kern_mount+0x5e/0xd0
> [   46.324342]  [<ffffffff823e1500>] ? _raw_read_unlock+0x30/0x60
> [   46.325605]  [<ffffffff811c2dff>] do_kern_mount+0x4f/0x100
> [   46.326802]  [<ffffffff811c382f>] do_mount+0x50f/0x820
> [   46.327661]  [<ffffffff81158b63>] ? strndup_user+0x53/0x70
> [   46.328524]  [<ffffffff811c3cbb>] sys_mount+0x8b/0xe0
> [   46.329320]  [<ffffffff823e2779>] system_call_fastpath+0x16/0x1b
> 

-- 

Sasha.

