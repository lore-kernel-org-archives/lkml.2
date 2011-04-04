Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775Ab1DDDNE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 23:13:04 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52966 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753604Ab1DDDNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 23:13:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=JfD1E27BWKsVmGMmQPeOvR6y++G+S+q0CJ45VLY8hMzX1Q20gTg4SeQr609lx4b8/l
         p2IYViildkya2ICDAmo4AV4aSh3znkO/V+zPAhow7xLWu5hyWUzDy1IdJf6V8ZmVo5jA
         SfClmDCYiu5oDx6ET5EMulR4ZJjo2PJeIE2ho=
MIME-Version: 1.0
Date: Mon, 4 Apr 2011 11:13:01 +0800
Message-ID: <BANLkTi=pS8Wk9Ymtj=DeVqfgqBsbTXDHZA@mail.gmail.com>
Subject: [2.6.39-rc1] LTP hitting max (8) nested links...
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a test from the Linux Test Project [1] with 2.6.39-rc1 while
trying to reproduce another fileystem issue, I quickly hit the 8
nested link limit [2]:
BUG_ON(nd->depth >= MAX_NESTED_LINKS)

It seems a mutually exclusive condition to have such a technical limit
in-kernel and a test in LTP which triggers that, unless there is a bug
of course.

Though 8 seems reasonable in most cases, it looks like an artificial
and not technical limit which feels more broken - perhaps a WARN_ON or
higher limit before BUG() is called makes sense?

--- [1]

cd ltp/testcases/bin
TMPDIR=/tmp ./fs_racer.sh -t 30

--- [2]

kernel BUG at fs/namei.c:1380!
invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
last sysfs file: /sys/devices/virtual/misc/tun/uevent
CPU 0
Modules linked in: tun loop

Pid: 29776, comm: mkdir Tainted: G        W   2.6.39-rc1-350cd+ #9
Supermicro X8STi/X8STi
RIP: 0010:[<ffffffff8114cc34>]  [<ffffffff8114cc34>] link_path_walk+0x804/0x970
RSP: 0018:ffff8801e8441648  EFLAGS: 00010202
RAX: 0000000000000008 RBX: ffff8801e8441dd8 RCX: ffffffff8173b340
RDX: ffff8801ed09a1f0 RSI: ffff8801ed00dc80 RDI: ffff8801ed00dc80
RBP: ffff8801e84416f8 R08: 0000000000000000 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000001 R12: ffff8802a1994002
R13: 000000000000002f R14: ffff8801e7798000 R15: ffff8802a1994002
FS:  00007fbdd94a47a0(0000) GS:ffff88031fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000403000 CR3: 00000001e842e000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process mkdir (pid: 29776, threadinfo ffff8801e8440000, task ffff8801e7798000)
Stack:
 ffffffff810e8090 ffff8801ed00dc80 ffff8801e84416e0 000000170000002f
 ffff8801e8441df8 ffff8801e7798000 ffff8801e8441de8 ffff8801e7798000
 ffff8801e8441698 ffff8801ed00dc80 0000000100002331 ffff8802a1994000
Call Trace:
 [<ffffffff810e8090>] ? find_get_pages+0x210/0x210
 [<ffffffff8114c97c>] link_path_walk+0x54c/0x970
 [<ffffffff810e8090>] ? find_get_pages+0x210/0x210
 [<ffffffff8114c97c>] link_path_walk+0x54c/0x970
 [<ffffffff810e8090>] ? find_get_pages+0x210/0x210
 [<ffffffff8114c97c>] link_path_walk+0x54c/0x970
 [<ffffffff810e8090>] ? find_get_pages+0x210/0x210
 [<ffffffff8114c97c>] link_path_walk+0x54c/0x970
 [<ffffffff810e8090>] ? find_get_pages+0x210/0x210
 [<ffffffff8114c97c>] link_path_walk+0x54c/0x970
 [<ffffffff810e8090>] ? find_get_pages+0x210/0x210
 [<ffffffff8114c97c>] link_path_walk+0x54c/0x970
 [<ffffffff810e8090>] ? find_get_pages+0x210/0x210
 [<ffffffff8114c97c>] link_path_walk+0x54c/0x970
 [<ffffffff8114c97c>] link_path_walk+0x54c/0x970
 [<ffffffff8114f34d>] path_lookupat+0x2dd/0x860
 [<ffffffff8114f8fc>] do_path_lookup+0x2c/0xc0
 [<ffffffff8114d216>] ? getname_flags+0x126/0x250
 [<ffffffff81150ba4>] user_path_at+0x54/0xa0
 [<ffffffff81144fc7>] vfs_fstatat+0x47/0x80
 [<ffffffff81145036>] vfs_stat+0x16/0x20
 [<ffffffff8114520f>] sys_newstat+0x1f/0x50
 [<ffffffff810961fd>] ? trace_hardirqs_on_caller+0x14d/0x190
 [<ffffffff813325fe>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff81709d7b>] system_call_fastpath+0x16/0x1b
Code: ff 48 8b 85 60 ff ff ff e9 66 fd ff ff 48 8d 7d b0 48 89 de e8
1e e8 ff ff 48 89 df e8 c6 e9 ff ff b9 d8 ff ff ff e9 64 fa ff ff <0f>
0b eb fe 0f 0b eb fe 48 89 df e8 9c ea ff ff 85 c0 75 3b 48
RIP  [<ffffffff8114cc34>] link_path_walk+0x804/0x970
 RSP <ffff8801e8441648>
-- 
Daniel J Blueman
