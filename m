Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584Ab2EKLZ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 07:25:59 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:64135 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083Ab2EKLZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 07:25:58 -0400
MIME-Version: 1.0
From: Sasha Levin <levinsasha928@gmail.com>
Date: Fri, 11 May 2012 13:25:35 +0200
Message-ID: <CA+1xoqeypPQSdVqBT2_X6Evf7_Hw_TYx6CigvYYpM4gLzO+Hvw@mail.gmail.com>
Subject: fs, namespaces: BUG: unable to handle kernel NULL pointer dereference
 at 0000000000000020
To: Al Viro <viro@zeniv.linux.org.uk>, mszeredi@suse.cz
Cc: Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I've started seeing the following when fuzzing with trinity in a KVM
tools guest, using the latest -next.

This started with yesterday's linux-next, so it's probably one of the
recent changes there. I can try bisecting if the problem isn't clear.

[   47.940509] BUG: unable to handle kernel NULL pointer dereference
at 0000000000000020
[   47.941435] IP: [<ffffffff8124e6a8>] dup_mnt_ns+0x38/0x270
[   47.941435] PGD 17a8d067 PUD 17a8b067 PMD 0
[   47.941435] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[   47.941435] CPU 1
[   47.950548] Pid: 6202, comm: trinity Tainted: G        W
3.4.0-rc6-next-20120511-sasha-00003-g0642143 #186
[   47.950548] RIP: 0010:[<ffffffff8124e6a8>]  [<ffffffff8124e6a8>]
dup_mnt_ns+0x38/0x270
[   47.950548] RSP: 0018:ffff880017831e38  EFLAGS: 00010282
[   47.950548] RAX: 0000000000000000 RBX: ffff88001b4cfc00 RCX: 0000000000000001
[   47.950548] RDX: 0000000000000018 RSI: ffffffff8525cfc0 RDI: 0000000000000282
[   47.950548] RBP: ffff880017831e98 R08: 0000000000000001 R09: 0000000000000001
[   47.950548] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[   47.950548] R13: ffff880015d241c8 R14: ffff88001b4cfc00 R15: 000000004c020700
[   47.950548] FS:  00007fefc9b43700(0000) GS:ffff88001b800000(0000)
knlGS:0000000000000000
[   47.950548] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   47.950548] CR2: 0000000000000020 CR3: 00000000179be000 CR4: 00000000000406e0
[   47.950548] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   47.950548] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   47.950548] Process trinity (pid: 6202, threadinfo
ffff880017830000, task ffff880017b60000)
[   47.950548] Stack:
[   47.950548]  ffff88001b4e5be8 ffff88003540c000 ffff88001b4e5be8
00000000000000d0
[   47.950548]  ffff880017831eb8 ffffffff81218814 ffff880017b60000
ffff880017963008
[   47.950548]  000000004c020700 ffff880017b60000 ffff88001b4cfc00
000000004c020700
[   47.950548] Call Trace:
[   47.950548]  [<ffffffff81218814>] ? kmem_cache_alloc+0x154/0x240
[   47.950548]  [<ffffffff8124e91e>] copy_mnt_ns+0x3e/0x60
[   47.950548]  [<ffffffff81105e7c>] create_new_namespaces+0x6c/0x190
[   47.950548]  [<ffffffff81106001>] unshare_nsproxy_namespaces+0x61/0x80
[   47.950548]  [<ffffffff810ce51f>] sys_unshare+0xff/0x290
[   47.950548]  [<ffffffff8195600e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   47.950548]  [<ffffffff82f08039>] system_call_fastpath+0x16/0x1b
[   47.950548] Code: 48 89 f3 48 83 ec 38 4c 8b 67 08 e8 83 ce ff ff
49 89 c5 48 3d 00 f0 ff ff 0f 87 16 02 00 00 48 c7 c7 60 cf 25 85 e8
e8 5c cb 01 <49> 8b 74 24 20 ba 05 00 00 00 4c 89 e7 e8 16 fb ff ff 49
89 c6
[   47.950548] RIP  [<ffffffff8124e6a8>] dup_mnt_ns+0x38/0x270
[   47.950548]  RSP <ffff880017831e38>
[   47.950548] CR2: 0000000000000020
[   47.950613] ---[ end trace 6d450e935ee18997 ]---
