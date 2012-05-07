Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018Ab2EGJlS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 05:41:18 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34303 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755497Ab2EGJlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 05:41:16 -0400
Message-ID: <1336383752.3638.13.camel@lappy>
Subject: fb: BUGs related to deferred IO
From: Sasha Levin <levinsasha928@gmail.com>
To: FlorianSchandinat@gmx.de
Cc: Dave Jones <davej@redhat.com>, linux-fbdev@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 07 May 2012 11:42:32 +0200
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

During fuzzing using trinity inside a KVM guest, using latest -next kernel, I got the following BUG:

[  601.263570] ------------[ cut here ]------------
[  601.270562] WARNING: at lib/debugobjects.c:261 debug_print_object+0x8d/0xb0()
[  601.298273] ODEBUG: assert_init not available (active state 0) object type: timer_list hint: stub_timer+0x0/0x20
[  601.317051] Pid: 23084, comm: trinity Tainted: G        W    3.4.0-rc6-next-20120507-sasha-00001-g33621a3-dirty #114
[  601.353655] Call Trace:
[  601.358430]  [<ffffffff810b6ca7>] warn_slowpath_common+0x87/0xb0
[  601.369400]  [<ffffffff810b6d71>] warn_slowpath_fmt+0x41/0x50
[  601.376112]  [<ffffffff8189dafd>] debug_print_object+0x8d/0xb0
[  601.382656]  [<ffffffff810c5650>] ? usleep_range+0x40/0x40
[  601.389210]  [<ffffffff8189dcf0>] debug_object_assert_init+0xa0/0x110
[  601.395856]  [<ffffffff810c5e26>] del_timer+0x26/0xd0
[  601.399472]  [<ffffffff810d3c87>] __cancel_work_timer+0x27/0xa0
[  601.403238]  [<ffffffff810d3d0d>] cancel_delayed_work_sync+0xd/0x10
[  601.406969]  [<ffffffff819170d2>] fb_deferred_io_fsync+0x52/0x80
[  601.410281]  [<ffffffff811e1ff8>] ? fget_light+0x118/0x3e0
[  601.413489]  [<ffffffff8120cb48>] vfs_fsync_range+0x18/0x30
[  601.416741]  [<ffffffff8120cb77>] vfs_fsync+0x17/0x20
[  601.419662]  [<ffffffff8120cd74>] do_fsync+0x34/0x60
[  601.422959]  [<ffffffff8120cdae>] sys_fdatasync+0xe/0x20
[  601.425721]  [<ffffffff82d8b1f9>] system_call_fastpath+0x16/0x1b
[  601.449718] ---[ end trace 44593438a59a9537 ]---
[  601.452359] ------------[ cut here ]------------
[  601.453315] kernel BUG at kernel/workqueue.c:564!
[  601.453315] invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[  601.453315] CPU 1 
[  601.453315] Pid: 23084, comm: trinity Tainted: G        W    3.4.0-rc6-next-20120507-sasha-00001-g33621a3-dirty #114
[  601.453315] RIP: 0010:[<ffffffff810d1621>]  [<ffffffff810d1621>] get_work_gcwq+0x41/0x80
[  601.453315] RSP: 0018:ffff88000ed3fe58  EFLAGS: 00010213
[  601.453315] RAX: 0000000000000000 RBX: ffff88007f310e58 RCX: 0000000000000006
[  601.453315] RDX: 0035b5b5b5b5b5b5 RSI: ffff88000f9088e0 RDI: ffff88007f310e58
[  602.339668] RBP: ffff88000ed3fe58 R08: 0000000000000001 R09: 0000000000000000
[  602.339668] R10: 0000000000000001 R11: 0000000000000000 R12: ffff88007f310e58
[  602.339668] R13: 09286401f3b0af98 R14: 13b8db52e413d33a R15: 02be775f01f67918
[  602.339668] FS:  00007f65d4b65700(0000) GS:ffff88001b800000(0000) knlGS:0000000000000000
[  602.339668] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  602.339668] CR2: 0000000000f54800 CR3: 0000000016530000 CR4: 00000000000407e0
[  602.339668] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  602.339668] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  602.339668] Process trinity (pid: 23084, threadinfo ffff88000ed3e000, task ffff88000f908000)
[  602.339668] Stack:
[  602.339668]  ffff88000ed3fe98 ffffffff810d23db 2222222222222222 2222222222222222
[  602.339668]  2222222222222222 ffff88007f310e58 ffff88007f310ea8 09286401f3b0af98
[  602.339668]  ffff88000ed3fec8 ffffffff810d3ce0 13b8db52e413d33a ffff88001aeccb98
[  602.339668] Call Trace:
[  602.339668]  [<ffffffff810d23db>] try_to_grab_pending+0x2b/0xe0
[  602.339668]  [<ffffffff810d3ce0>] __cancel_work_timer+0x80/0xa0
[  602.339668]  [<ffffffff810d3d0d>] cancel_delayed_work_sync+0xd/0x10
[  602.339668]  [<ffffffff819170d2>] fb_deferred_io_fsync+0x52/0x80
[  602.339668]  [<ffffffff811e1ff8>] ? fget_light+0x118/0x3e0
[  602.339668]  [<ffffffff8120cb48>] vfs_fsync_range+0x18/0x30
[  602.339668]  [<ffffffff8120cb77>] vfs_fsync+0x17/0x20
[  602.339668]  [<ffffffff8120cd74>] do_fsync+0x34/0x60
[  602.339668]  [<ffffffff8120cdae>] sys_fdatasync+0xe/0x20
[  602.339668]  [<ffffffff82d8b1f9>] system_call_fastpath+0x16/0x1b
[  602.339668] Code: 66 2e 0f 1f 84 00 00 00 00 00 48 89 c2 31 c0 48 c1 ea 09 81 fa 01 10 00 00 74 3f 81 fa 00 10 00 00 74 27 39 15 89 ca f1 02 77 09 <0f> 0b 0f 1f 44 00 00 eb fe 48 c7 c0 80 f4 00 00 89 d2 48 03 04 
[  602.339668] RIP  [<ffffffff810d1621>] get_work_gcwq+0x41/0x80
[  602.339668]  RSP <ffff88000ed3fe58>
[  602.674604] ---[ end trace 44593438a59a9538 ]---

It would seem that this is the case of trying to use deferred IO on FBs that don't support it. I had a cirrus fbdev in the guest, which from what I can tell doesn't support deferred IO.

The first and the 2nd bug lead me to believe that 'fbdefio' was set to garbage.

