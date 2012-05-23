Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759980Ab2EWONP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 10:13:15 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54565 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915Ab2EWONO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 10:13:14 -0400
Message-ID: <1337782454.20792.63.camel@lappy>
Subject: GPF in numa_vma_unlink
From: Sasha Levin <levinsasha928@gmail.com>
To: a.p.zijlstra@chello.nl, mingo@kernel.org
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Date: Wed, 23 May 2012 16:14:14 +0200
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

During fuzzing with trinity inside a KVM tools guest, using latest linux-next, I've stumbled on the following:

[ 4112.424701] general protection fault: 0000 [#2] PREEMPT SMP DEBUG_PAGEALLOC
[ 4112.427171] CPU 4 
[ 4112.427171] Pid: 20586, comm: trinity Tainted: G      D W    3.4.0-next-20120523-sasha-00004-gaf4dba1 #269  
[ 4112.434521] RIP: 0010:[<ffffffff81098350>]  [<ffffffff81098350>] __ticket_spin_lock+0x30/0x30
[ 4112.434521] RSP: 0018:ffff88003d513d40  EFLAGS: 00010286
[ 4112.434521] RAX: ffff88003dee3000 RBX: 6b6b6b6b6b6b6b6b RCX: 0000000000000000
[ 4112.434521] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 6b6b6b6b6b6b6b6b
[ 4112.434521] RBP: ffff88003d513d58 R08: 0000000000000000 R09: 0000000000000000
[ 4112.434521] R10: 0000000000000000 R11: 0000000000000001 R12: 6b6b6b6b6b6b6b83
[ 4112.434521] R13: ffff88003dee37e8 R14: ffff88003d05a0a8 R15: 0000000000000034
[ 4112.434521] FS:  00007f5fc2781700(0000) GS:ffff880041800000(0000) knlGS:0000000000000000
[ 4112.434521] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 4112.434521] CR2: 00007fd0463ddefc CR3: 0000000003e1c000 CR4: 00000000000406e0
[ 4112.434521] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 4112.434521] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 4112.434521] Process trinity (pid: 20586, threadinfo ffff88003d512000, task ffff88003dee3000)
[ 4112.434521] Stack:
[ 4112.434521]  ffffffff81976ecd 6b6b6b6b6b6b6b6b 6b6b6b6b6b6b6b83 ffff88003d513d88
[ 4112.434521]  ffffffff82f695f3 ffffffff8112b27a 0000000000000034 6b6b6b6b6b6b6b6b
[ 4112.434521]  ffff88003f9f7980 ffff88003d513da8 ffffffff8112b27a ffff8800097e43f0
[ 4112.434521] Call Trace:
[ 4112.434521]  [<ffffffff81976ecd>] ? do_raw_spin_trylock+0x2d/0x60
[ 4112.434521]  [<ffffffff82f695f3>] _raw_spin_lock+0x43/0x70
[ 4112.434521]  [<ffffffff8112b27a>] ? numa_vma_unlink+0x2a/0x90
[ 4112.434521]  [<ffffffff8112b27a>] numa_vma_unlink+0x2a/0x90
[ 4112.434521]  [<ffffffff8120f491>] vma_put_policy+0x11/0x30
[ 4112.434521]  [<ffffffff811f7642>] remove_vma+0x62/0x80
[ 4112.434521]  [<ffffffff811f777d>] exit_mmap+0x11d/0x170
[ 4112.434521]  [<ffffffff810cf719>] mmput+0x89/0xe0
[ 4112.434521]  [<ffffffff810d5f7b>] exit_mm+0x11b/0x130
[ 4112.434521]  [<ffffffff82f6a159>] ? _raw_spin_unlock_irq+0x59/0x80
[ 4112.434521]  [<ffffffff810d8933>] do_exit+0x263/0x510
[ 4112.434521]  [<ffffffff810d8c81>] do_group_exit+0xa1/0xe0
[ 4112.434521]  [<ffffffff810d8cd2>] sys_exit_group+0x12/0x20
[ 4112.434521]  [<ffffffff82f6b1b9>] system_call_fastpath+0x16/0x1b
[ 4112.434521] Code: 00 48 89 e5 f0 0f c1 07 89 c2 c1 ea 10 66 39 c2 74 13 66 0f 1f 84 00 00 00 00 00 f3 90 0f b7 07 66 39 d0 75 f6 c9 c3 0f 1f 40 00 <8b> 17 55 89 d1 31 c0 c1 e9 10 48 89 e5 66 39 ca 75 14 8d 8a 00 
[ 4112.434521] RIP  [<ffffffff81098350>] __ticket_spin_lock+0x30/0x30
[ 4112.434521]  RSP <ffff88003d513d40>
[ 4113.313776] ---[ end trace 6d450e935ee18981 ]---

