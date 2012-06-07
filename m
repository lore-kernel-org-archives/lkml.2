Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757624Ab2FGAkz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 20:40:55 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36929 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095Ab2FGAkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 20:40:53 -0400
Message-ID: <1339029719.13373.14.camel@lappy>
Subject: Re: ecryptfs: kernel BUG at fs/ecryptfs/miscdev.c:52
From: Sasha Levin <levinsasha928@gmail.com>
To: tyhicks <tyhicks@canonical.com>
Cc: "dustin.kirkland" <dustin.kirkland@gazzang.com>,
        ecryptfs <ecryptfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 07 Jun 2012 02:41:59 +0200
In-Reply-To: <1338061161.4284.16.camel@lappy>
References: <1338061161.4284.16.camel@lappy>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-05-26 at 21:39 +0200, Sasha Levin wrote:
> Hi all,
> 
> During fuzzing with trinity inside a KVM guest, using latest linux-next kernel, I've stumbled on the following:
> 
> [  175.995560] ------------[ cut here ]------------
> [  175.996026] kernel BUG at fs/ecryptfs/miscdev.c:52!
> [  175.996026] invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> [  175.996026] CPU 3 
> [  175.996026] Pid: 7903, comm: trinity-child3 Tainted: G        W    3.4.0-next-20120524-sasha #296 Bochs Bochs
> [  175.996026] RIP: 0010:[<ffffffff813e945a>]  [<ffffffff813e945a>] ecryptfs_miscdev_poll+0x5a/0x150
> [  175.996026] RSP: 0018:ffff88002d4a3aa8  EFLAGS: 00010282
> [  175.996026] RAX: 00000000ffffffea RBX: ffff88002d4a3b98 RCX: ffff880019d3c348
> [  175.996026] RDX: ffffffff84444140 RSI: 000000000b32e681 RDI: ffff88002d4a3ab0
> [  175.996026] RBP: ffff88002d4a3ad8 R08: cbf7d334712ee681 R09: 0200000000000000
> [  175.996026] R10: 2000000000000000 R11: 3408000000000000 R12: ffff88003d53c000
> [  176.022035] R13: 000000000b32e681 R14: ffff88002d4b059c R15: ffff88003d53c000
> 165983 iteration[  176.026020] FS:  00007f0abac73700(0000) GS:ffff880035a00000(0000) knlGS:0000000000000000
> [  176.026020] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> s.
> [  176.026020] CR2: 00000000011750d8 CR3: 0000000039722000 CR4: 00000000000407e0
> [  176.026020] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  176.026020] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [  176.026020] Process trinity-child3 (pid: 7903, threadinfo ffff88002d4a2000, task ffff88002d503000)
> [  176.026020] Stack:
> [  176.026020]  ffff88002d4b069c ffff880019d3c348 ffff88002d4b069c ffff88002d4b069c
> [  176.026020]  ffff88002d4a3b44 ffff88002d4a3b98 ffff88002d4a3b78 ffffffff8124d9bc
> [  176.026020]  ffff88002d503000 ffff88002d503000 01ffffff811f5afe 0000000000000000
> [  176.026020] Call Trace:
> [  176.026020]  [<ffffffff8124d9bc>] do_poll+0x11c/0x2b0
> [  176.026020]  [<ffffffff8124dcbf>] do_sys_poll+0x16f/0x240
> [  176.026020]  [<ffffffff8114dfdd>] ? __lock_acquired+0x3d/0x2e0
> [  176.026020]  [<ffffffff811fade6>] ? do_wp_page+0x5c6/0x800
> [  176.026020]  [<ffffffff811faf73>] ? do_wp_page+0x753/0x800
> 197143 iteration[  176.026020]  [<ffffffff8197e060>] ? do_raw_spin_unlock+0xd0/0xe0
> s.
> [  176.026020]  [<ffffffff83249080>] ? _raw_spin_unlock+0x30/0x60
> [  176.026020]  [<ffffffff811fafe8>] ? do_wp_page+0x7c8/0x800
> [  176.026020]  [<ffffffff8114dfdd>] ? __lock_acquired+0x3d/0x2e0
> [  176.026020]  [<ffffffff8198044d>] ? debug_object_activate+0x6d/0x1b0
> [  176.026020]  [<ffffffff81980532>] ? debug_object_activate+0x152/0x1b0
> [  176.026020]  [<ffffffff8197e060>] ? do_raw_spin_unlock+0xd0/0xe0
> [  176.026020]  [<ffffffff8114b4cd>] ? trace_hardirqs_off+0xd/0x10
> [  176.026020]  [<ffffffff83249144>] ? _raw_spin_unlock_irqrestore+0x94/0xc0
> [  176.026020]  [<ffffffff81980532>] ? debug_object_activate+0x152/0x1b0
> [  176.026020]  [<ffffffff819611ee>] ? rb_insert_color+0x9e/0x160
> [  176.026020]  [<ffffffff8110c488>] ? __hrtimer_start_range_ns+0x448/0x490
> [  176.026020]  [<ffffffff8197e060>] ? do_raw_spin_unlock+0xd0/0xe0
> [  176.026020]  [<ffffffff8124df6c>] sys_poll+0x6c/0x100
> [  176.026020]  [<ffffffff8324a1f9>] system_call_fastpath+0x16/0x1b
> [  176.026020] Code: 00 00 44 8b 68 24 e8 66 cc e5 01 48 8d 7d d8 48 c7 c2 40 41 44 84 44 89 ee e8 a3 ef ff ff 85 c0 75 09 48 8b 7d 
> d8 48 85 ff 75 0e <0f> 0b 0f 1f 40 00 eb fe 66 0f 1f 44 00 00 48 83 c7 28 31 f6 e8 
> [  176.026020] RIP  [<ffffffff813e945a>] ecryptfs_miscdev_poll+0x5a/0x150
> [  176.026020]  RSP <ffff88002d4a3aa8>
> [  176.028658] ---[ end trace 8f6ca168297608bd ]---
> 

I'm also seeing this, which is probably related:

[  269.149993] ------------[ cut here ]------------
[  269.150735] kernel BUG at fs/ecryptfs/miscdev.c:272!
[  269.150735] invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[  269.150735] CPU 0 
[  269.150735] Pid: 8059, comm: trinity-child0 Tainted: G        W    3.5.0-rc1-next-20120605-sasha-00012-g1389a60 #355  
[  269.150735] RIP: 0010:[<ffffffff813eb711>]  [<ffffffff813eb711>] ecryptfs_miscdev_read+0x61/0x470
[  269.150735] RSP: 0018:ffff88000baf3e58  EFLAGS: 00010282
[  269.150735] RAX: 00000000ffffffea RBX: 00000000ffffffea RCX: ffff880028d9c620
[  269.150735] RDX: ffffffff84a4d140 RSI: 000000007184449d RDI: ffff88000baf3eb0
[  269.150735] RBP: ffff88000baf3ef8 R08: db1639ef5f10449d R09: 3a00000000000000
[  269.150735] R10: a000000000000000 R11: 24e8000000000000 R12: ffff88000bb1b000
[  269.150735] R13: 0000000000f59af0 R14: 0000000000000000 R15: 000000007184449d
[  269.150735] FS:  00007fa2c283e700(0000) GS:ffff88000d800000(0000) knlGS:0000000000000000
[  269.150735] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  269.150735] CR2: 00000000012d0098 CR3: 000000003349e000 CR4: 00000000000406f0
[  269.150735] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  269.150735] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  269.150735] Process trinity-child0 (pid: 8059, threadinfo ffff88000baf2000, task ffff88000bb1b000)
[  269.150735] Stack:
[  269.150735]  0000000000000000 0000000000000000 ffff88000bb1b000 0000000000020000
[  269.150735]  ffff880019fbac10 ffff88001adeabe8 0000000000000004 0000000000000191
[  269.150735]  ffff88000baf3ec8 ffffffff818ae971 0000000000000000 ffff880019fbac00
[  269.150735] Call Trace:
[  269.150735]  [<ffffffff818ae971>] ? security_file_permission+0x81/0x90
[  269.150735]  [<ffffffff81239e87>] vfs_read+0xc7/0x190
[  269.150735]  [<ffffffff8123a02f>] sys_read+0x4f/0x90
[  269.150735]  [<ffffffff837cdf39>] system_call_fastpath+0x16/0x1b
[  269.150735] Code: 80 b5 fc 85 e8 51 e8 3d 02 48 8d 7d b8 48 c7 c2 40 d1 a4 84 44 89 fe e8 2e ea ff ff 89 c3 85 c0 75 09 48 8b 7d 
b8 48 85 ff 75 0f <0f> 0b 0f 1f 44 00 00 eb fe 66 0f 1f 44 00 00 48 83 c7 28 31 f6 
[  269.150735] RIP  [<ffffffff813eb711>] ecryptfs_miscdev_read+0x61/0x470
[  269.150735]  RSP <ffff88000baf3e58>
[  269.188128] ---[ end trace 6d450e935ee18981 ]---

