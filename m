Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117Ab2DRPQv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 11:16:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56787 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151Ab2DRPQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 11:16:48 -0400
Message-ID: <1334762158.5922.3.camel@lappy>
Subject: jbd: NULL dereference on chown()
From: Sasha Levin <levinsasha928@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, jack@suse.cz
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 18 Apr 2012 17:15:58 +0200
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I've stumbled on the following after some fuzzing inside a KVM guest, guest was running -next from today:

[   73.117530] BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
[   73.117534] IP: [<ffffffff81313a5e>] journal_add_journal_head+0x1be/0x220
[   73.117543] PGD 32327067 PUD 33d32067 PMD 0 
[   73.117548] Oops: 0002 [#1] PREEMPT SMP 
[   73.117551] CPU 3 
[   73.117555] Pid: 6964, comm: trinity Tainted: G        W    3.4.0-rc3-next-20120418-sasha-dirty #85  
[   73.117559] RIP: 0010:[<ffffffff81313a5e>]  [<ffffffff81313a5e>] journal_add_journal_head+0x1be/0x220
[   73.117563] RSP: 0018:ffff880032195cf8  EFLAGS: 00010202
[   73.117565] RAX: 0000000000000000 RBX: ffff88003d0026c0 RCX: 0000000000000000
[   73.117568] RDX: 0000000000000000 RSI: ffff88003d0026c0 RDI: ffffffff8130cc6c
[   73.117570] RBP: ffff880032195d28 R08: 0000000000000000 R09: 0000000000000000
[   73.117572] R10: 0000000000000000 R11: 0000000000000001 R12: ffff880032194000
[   73.117574] R13: 000000000000000e R14: ffff880032194000 R15: 0000000000000000
[   73.117577] FS:  00007f7615d4b700(0000) GS:ffff880035a00000(0000) knlGS:0000000000000000
[   73.117580] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   73.117582] CR2: 0000000000000008 CR3: 0000000031bb0000 CR4: 00000000000406e0
[   73.117590] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   73.117596] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   73.117598] Process trinity (pid: 6964, threadinfo ffff880032194000, task ffff880033cf8000)
[   73.117600] Stack:
[   73.117602]  00000000000003ff ffffffff82848140 ffff880035026000 ffff880035026000
[   73.117606]  0000000000000000 ffff880035026000 ffff880032195d48 ffffffff8130cc6c
[   73.117611]  ffffffff82848140 ffff88003d0026c0 ffff880032195d88 ffffffff812c5278
[   73.117615] Call Trace:
[   73.117621]  [<ffffffff8130cc6c>] journal_get_write_access+0x1c/0x50
[   73.117624]  [<ffffffff812c5278>] __ext3_journal_get_write_access+0x28/0x60
[   73.117629]  [<ffffffff812b7141>] ext3_reserve_inode_write+0x51/0xb0
[   73.117633]  [<ffffffff812b71df>] ext3_mark_inode_dirty+0x3f/0x60
[   73.117636]  [<ffffffff812b91bd>] ext3_setattr+0x12d/0x310
[   73.117642]  [<ffffffff811fa3d9>] notify_change+0x209/0x330
[   73.117647]  [<ffffffff811da0d8>] chown_common+0x98/0xc0
[   73.117650]  [<ffffffff811dacdc>] sys_chown+0x5c/0x90
[   73.117657]  [<ffffffff826a00bd>] system_call_fastpath+0x1a/0x1f
[   73.117659] Code: a8 08 0f 84 95 fe ff ff e8 d0 98 38 01 e9 8b fe ff ff 0f 1f 00 f0 80 4b 01 40 4c 89 7b 40 49 89 1f f0 ff 43 60 4c 89 f8 45 31 ff <ff> 40 08 48 8b 03 a9 00 00 20 00 75 05 0f 0b 0f 1f 00 f0 80 63 
[   73.117697] RIP  [<ffffffff81313a5e>] journal_add_journal_head+0x1be/0x220
[   73.117701]  RSP <ffff880032195cf8>
[   73.117702] CR2: 0000000000000008
[   73.117706] ---[ end trace a307b3ed40206b4c ]---

