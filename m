Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722Ab2IVLnI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 07:43:08 -0400
Received: from mail.windriver.com ([147.11.1.11]:33761 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754261Ab2IVLnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 07:43:06 -0400
Message-ID: <505DA444.7090805@windriver.com>
Date: Sat, 22 Sep 2012 06:43:00 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>
CC: "Gortmaker, Paul" <Paul.Gortmaker@windriver.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: 3.4.5 regression kernel oops in mount attempt without lockd present
References: <505CBF46.1060901@windriver.com>
In-Reply-To: <505CBF46.1060901@windriver.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Greg,

In 3.4.5, a regression was introduced from commit: ee92389156 "SUNRPC:
move per-net operations from svc_destroy()".

This regression was actually fixed in a later upstream patch in
v3.5-rc1, specifically 4db77695bf5 "LockD: pass service to per-net up
and down functions", which means there is no stock kernel.org kernel
that exhibits this particular crash.

Please add 4db77695bf5 to the 3.4.Y, it should cherry-pick cleanly.

Below is the stack trace you can get from lockd initiation crashing if
you try to mount a file system with locks when lockd is not running.

BUG: unable to handle kernel NULL pointer dereference at 0000011c
IP: [<c1208481>] lockd_down_net+0x41/0xb0
*pde = 00000000
Oops: 0000 [#1] PREEMPT SMP
Modules linked in:

Pid: 42, comm: mount Not tainted 3.4.10-WR5.0+snapshot-20120814_standard #26 Bochs Bochs
EIP: 0060:[<c1208481>] EFLAGS: 00010282 CPU: 0
EIP is at lockd_down_net+0x41/0xb0
EAX: 00000000 EBX: 00000003 ECX: 00000000 EDX: 00000000
ESI: c1a23540 EDI: d7949708 EBP: d7033da0 ESP: d7033d88
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
CR0: 8005003b CR2: 0000011c CR3: 1701a000 CR4: 000006d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
Process mount (pid: 42, ti=d7032000 task=d7a2e200 task.ti=d7032000)
Stack:
 c1208993 c181af78 ffffff91 ffffff91 d7af9980 c1a23540 d7033dcc c1208ba7
 d79d5500 d7033db8 c11dec06 00000000 d7033dd0 d7949708 d7033df8 00000004
 00000003 d7033df0 c120591c c11de15e 00000001 00000000 d79d54e0 d700ac00
Call Trace:
 [<c1208993>] ? make_socks+0x93/0xa0
 [<c1208ba7>] lockd_up+0x207/0x280
 [<c11dec06>] ? nfs_mark_client_ready+0x26/0x30
 [<c120591c>] nlmclnt_init+0x2c/0x80
 [<c11de15e>] ? nfs_get_client+0x4ee/0x580
 [<c11dd94c>] nfs_start_lockd+0x9c/0xd0
 [<c11def8d>] nfs_create_server+0x1bd/0x3e0
 [<c11e95b1>] nfs_fs_mount+0x91/0x3e0
 [<c12d131d>] ? ida_get_new_above+0x1ad/0x230
 [<c10f70f6>] mount_fs+0x36/0x180
 [<c10d9abf>] ? __alloc_percpu+0xf/0x20
 [<c110d701>] vfs_kern_mount+0x51/0xc0
 [<c110db3e>] do_kern_mount+0x3e/0xe0
 [<c110ef69>] do_mount+0x169/0x710
 [<c110f62b>] sys_mount+0x6b/0xa0
 [<c1662359>] syscall_call+0x7/0xb
Code: c0 8b a1 c1 89 c6 e8 6f 8f e8 ff 85 db 8b 86 80 03 00 00 74 5a 3b 18 77 56 8b 7c 98 08 e8 48 a6 e8 ff 85 ff 74 66 a1 cc 8b a1 c1 <8b> 98 1c 01 00 00 8b 07 85 c0 74 3a 83 e8 01 85 c0 89 07 74 12
EIP: [<c1208481>] lockd_down_net+0x41/0xb0 SS:ESP 0068:d7033d88
CR2: 000000000000011c
---[ end trace 4812fcaee13b225d ]---


Thanks,
Jason.


