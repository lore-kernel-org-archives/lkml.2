Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501Ab2BUQXO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 11:23:14 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:56904 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394Ab2BUQXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 11:23:13 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of levinsasha928@gmail.com designates 10.180.90.212 as permitted sender) smtp.mail=levinsasha928@gmail.com; dkim=pass header.i=levinsasha928@gmail.com
Message-ID: <1329841429.10124.38.camel@lappy>
Subject: 9p: BUG: unable to handle kernel paging request at ffff880035698000
From: Sasha Levin <levinsasha928@gmail.com>
To: ericvh@gmail.com, rminnich@sandia.gov, lucho@ionkov.net
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        v9fs-developer@lists.sourceforge.net, Dave Jones <davej@redhat.com>
Date: Tue, 21 Feb 2012 18:23:49 +0200
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I was using the KVM tool for tests with trinity on top of a virtio-9p filesystem, and started seeing the BUGs below when I've put some pressure on the 9p fs (not much, just started writing the logs from trinity to a 9p fs).

This reproduces not so easily, but it happens 2-3 times a day.

[  156.384520] BUG: unable to handle kernel paging request at ffff880035698000
[  156.386845] IP: [<ffffffff825be143>] p9_release_pages+0x43/0x60
[  156.388766] PGD 321d063 PUD 3221063 PMD 1ffa9067 PTE 35698160
[  156.388766] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[  156.393871] CPU 0
[  156.393871] Pid: 10293, comm: trinity Not tainted 3.3.0-rc4-next-20120220-sasha-00003-g949d91b #14
[  156.400127] RIP: 0010:[<ffffffff825be143>]  [<ffffffff825be143>] p9_release_pages+0x43/0x60
[  156.402161] RSP: 0018:ffff8800356edbf8  EFLAGS: 00010202
[  156.402161] RAX: 0000000000000001 RBX: ffff880035697ff8 RCX: 0000000000000000
[  156.402161] RDX: ffff8800330cb000 RSI: 0000000000000001 RDI: ffffea0000cfed40
[  156.402161] RBP: ffff8800356edc18 R08: 0000000000000001 R09: 0000000000000000
[  156.402161] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
[  156.407866] R13: 0000000000000001 R14: ffff880038a58070 R15: 0000000000000000
[  156.407866] FS:  00007fb4bf398700(0000) GS:ffff88003de00000(0000) knlGS:0000000000000000
[  156.407866] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  156.410381] CR2: ffff880035698000 CR3: 00000000355b2000 CR4: 00000000000406f0
[  156.410949] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  156.410949] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  156.413619] Process trinity (pid: 10293, threadinfo ffff8800356ec000, task ffff8800330cb000)
[  156.415369] Stack:
[  156.415369]  ffff8800356edc98 ffff8800356edc98 0000000000000000 ffff8800356edc98
[  156.417242]  ffff8800356edcf8 ffffffff825bed35 0000000000000076 0000000000000017
[  156.417242]  ffff8800356edcb0 ffff8800330cb000 0000000000001000 0000000000000286
[  156.417242] Call Trace:
[  156.417242]  [<ffffffff825bed35>] p9_virtio_zc_request+0xd5/0x510
[  156.417242]  [<ffffffff810d3a10>] ? wake_up_bit+0x40/0x40
[  156.417242]  [<ffffffff825ba548>] p9_client_zc_rpc+0xe8/0x4f0
[  156.417242]  [<ffffffff810e9155>] ? sched_clock_local+0x25/0x90
[  156.417242]  [<ffffffff810df381>] ? get_parent_ip+0x11/0x50
[  156.424263]  [<ffffffff810df381>] ? get_parent_ip+0x11/0x50
[  156.424263]  [<ffffffff825babf2>] p9_client_write+0xe2/0x1e0
[  156.424263]  [<ffffffff81592e15>] v9fs_file_write_internal+0x65/0x140
[  156.424263]  [<ffffffff81592f7c>] v9fs_file_write+0x8c/0xb0
[  156.424263]  [<ffffffff811d6258>] vfs_write+0xc8/0x190
[  156.424263]  [<ffffffff811d640f>] sys_write+0x4f/0x90
[  156.424263]  [<ffffffff82663f39>] system_call_fastpath+0x16/0x1b
[  156.424263] Code: ff 74 31 85 f6 74 2d 45 31 e4 eb 0e 0f 1f 40 00 45 39 e5 0f 1f 44 00 00 74 1a 66 0f 1f 44 00 00 e8 53 ef bb fe$
[  156.432262] RIP  [<ffffffff825be143>] p9_release_pages+0x43/0x60
[  156.432262]  RSP <ffff8800356edbf8>
[  156.434735] CR2: ffff880035698000

