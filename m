Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077Ab2BSUgF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 15:36:05 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:33370 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754742Ab2BSUgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 15:36:03 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of levinsasha928@gmail.com designates 10.213.105.140 as permitted sender) smtp.mail=levinsasha928@gmail.com; dkim=pass header.i=levinsasha928@gmail.com
Message-ID: <1329683796.10124.21.camel@lappy>
Subject: TTY: NULL dereference when closing a pty file
From: Sasha Levin <levinsasha928@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>, Greg KH <greg@kroah.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sun, 19 Feb 2012 22:36:36 +0200
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I got the following BUG() when running trinity on the KVM tool:

[  665.738774] BUG: unable to handle kernel NULL pointer dereference at 0000000000000028
[  665.739651] IP: [<ffffffff81257e2b>] devpts_pty_kill+0x1b/0xa0
[  665.739651] PGD 22eba067 PUD 22eaf067 PMD 0 
[  665.739651] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[  665.739651] CPU 5 
[  665.739651] Pid: 3061, comm: trinity Not tainted 3.3.0-rc3-next-20120217-sasha-00001-gfa56acb #18  
[  665.739651] RIP: 0010:[<ffffffff81257e2b>]  [<ffffffff81257e2b>] devpts_pty_kill+0x1b/0xa0
[  665.739651] RSP: 0018:ffff880022ecfd88  EFLAGS: 00010286
[  665.739651] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
[  665.739651] RDX: 0000000000000001 RSI: 0000000000000001 RDI: ffff880022921148
[  665.739651] RBP: ffff880022ecfda8 R08: 0000000000000000 R09: 0000000000000001
[  665.739651] R10: 0000000000000001 R11: 0000000000000001 R12: ffff880022921148
[  665.739651] R13: ffff880022934840 R14: ffff880026831970 R15: ffff880026831970
[  665.739651] FS:  00007f29c344e700(0000) GS:ffff88002a400000(0000) knlGS:0000000000000000
[  665.739651] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  665.739651] CR2: 0000000000000028 CR3: 0000000022e1c000 CR4: 00000000000406e0
[  665.739651] DR0: ffffffff810adc50 DR1: 0000000000000000 DR2: 0000000000000000
[  665.739651] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
[  665.739651] Process trinity (pid: 3061, threadinfo ffff880022ece000, task ffff880022d88000)
[  665.739651] Stack:
[  665.739651]  ffff880022ecfd98 ffff8800229267b0 ffff880022921148 ffff880022934840
[  665.739651]  ffff880022ecfdc8 ffffffff819407f1 ffff880022934840 ffff8800229267b0
[  665.739651]  ffff880022ecfeb8 ffffffff819374a6 ffff880022ecfe18 ffffffff81078e76
[  665.739651] Call Trace:
[  665.739651]  [<ffffffff819407f1>] pty_close+0x121/0x140
[  665.739651]  [<ffffffff819374a6>] tty_release+0x186/0x610
[  665.739651]  [<ffffffff81078e76>] ? kvm_clock_read+0x46/0x80
[  665.739651]  [<ffffffff81054973>] ? sched_clock+0x13/0x20
[  665.739651]  [<ffffffff811d9b16>] fput+0xf6/0x330
[  665.739651]  [<ffffffff811d68b4>] filp_close+0x64/0x90
[  665.739651]  [<ffffffff811d699b>] sys_close+0xbb/0x1b0
[  665.739651]  [<ffffffff8267c079>] system_call_fastpath+0x16/0x1b
[  665.739651] Code: 4c 8b a3 08 04 00 00 eb df 0f 0b 0f 1f 44 00 00 55 48 89 e5 48 83 ec 20 48 89 5d e8 4c 89 65 f0 4c 89 6d f8 48 8b 9f 28 04 00 00 <48> 8b 43 28 48 81 78 58 d1 1c 00 00 74 0b 48 8b 05 f0 17 26 03 
[  665.739651] RIP  [<ffffffff81257e2b>] devpts_pty_kill+0x1b/0xa0
[  665.739651]  RSP <ffff880022ecfd88>
[  665.739651] CR2: 0000000000000028
[  665.782570] ---[ end trace 5b128b9a8217de35 ]---

Looking further, it looks like devpts_pty_kill was called with tty->link==NULL.

I've bisected it down to d3bda529 ("TTY: get rid of BTM around devpts_*"), which has moved devpts_pty_kill() out of the tty_lock() protection.

