Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952Ab2JGN2n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 09:28:43 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:58423 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794Ab2JGN2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 09:28:34 -0400
Message-ID: <5071837C.30208@gmail.com>
Date: Sun, 07 Oct 2012 09:28:28 -0400
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120913 Thunderbird/15.0.1
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
Subject: vfs: oops on open_by_handle_at() in linux-next
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

While fuzzing with trinity inside a KVM tools guest using latest linux-next, I've stumbled on the following:

[   74.082463] BUG: unable to handle kernel paging request at ffff880061cd3000
[   74.087481] IP: [<ffffffff812190d0>] shmem_alloc_inode+0x40/0x40
[   74.090032] PGD 4e27063 PUD 1fb7b067 PMD 1fc8a067 PTE 8000000061cd3160
[   74.090032] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[   74.090032] Dumping ftrace buffer:
[   74.090032]    (ftrace buffer empty)
[   74.090032] CPU 1
[   74.090032] Pid: 7234, comm: trinity-child40 Tainted: G        W    3.6.0-next-20121005-sasha-00001-g1eae105-dirty #34
[   74.090032] RIP: 0010:[<ffffffff812190d0>]  [<ffffffff812190d0>] shmem_alloc_inode+0x40/0x40
[   74.109655] RSP: 0018:ffff8800268efd90  EFLAGS: 00010282
[   74.109655] RAX: ffffffff812190d0 RBX: ffff8800663d8a20 RCX: 0000000000000000
[   74.109655] RDX: 0000000000000001 RSI: ffff880061cd2ff8 RDI: ffff8800332a9000
[   74.109655] RBP: ffff8800268efef8 R08: ffffffff812d7450 R09: 0000000000000000
[   74.109655] R10: 0000000000000001 R11: 0000000000000000 R12: ffffffff83c48340
[   74.109655] R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000000
[   74.127365] ircomm_tty_close()
[   74.127345] FS:  00007fbf37c56700(0000) GS:ffff880033600000(0000) knlGS:0000000000000000
[   74.127345] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   74.127345] CR2: ffff880061cd3000 CR3: 00000000262c4000 CR4: 00000000000406e0
[   74.127345] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   74.127345] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   74.127345] Process trinity-child40 (pid: 7234, threadinfo ffff8800268ee000, task ffff880026208000)
[   74.127345] Stack:
[   74.127345]  ffffffff81488649 ffffffff85f2e7b0 0000000000000000 ffffffff812d7450
[   74.127345]  ffff880061cd2ff8 ffff8800268efdc8 ffffffff8117a23e ffff8800268efde8
[   74.127345]  ffffffff8117ac46 ffff8800261d1108 ffff880026208000 ffff8800268efe88
[   74.127345] Call Trace:
[   74.127345]  [<ffffffff81488649>] ? exportfs_decode_fh+0x79/0x2d0
[   74.127345]  [<ffffffff812d7450>] ? dump_seek+0xf0/0xf0
[   74.127345]  [<ffffffff8117a23e>] ? put_lock_stats.isra.16+0xe/0x40
[   74.127345]  [<ffffffff8117ac46>] ? lock_release_holdtime+0x126/0x140
[   74.127345]  [<ffffffff8117fbfe>] ? lock_release_non_nested+0xde/0x310
[   74.127345]  [<ffffffff83a5d914>] ? _raw_spin_unlock_irqrestore+0x84/0xb0
[   74.127345]  [<ffffffff812d77c3>] do_handle_open+0x163/0x2c0
[   74.127345]  [<ffffffff812d792c>] sys_open_by_handle_at+0xc/0x10
[   74.127345]  [<ffffffff83a5f3f8>] tracesys+0xe1/0xe6
[   74.127345] Code: 48 85 c0 74 0e 48 05 78 01 00 00 eb 0e 66 0f 1f 44 00 00 31 c0 66 0f 1f 44 00 00 5d c3 66 66 66 66 66 2e 0f
1f 84 00 00 00 00 00 <8b> 46 08 48 89 f1 8b 76 04 48 c1 e0 20 48 09 f0 83 fa 02 7e 46
[   74.127345] RIP  [<ffffffff812190d0>] shmem_alloc_inode+0x40/0x40
[   74.127345]  RSP <ffff8800268efd90>
[   74.127345] CR2: ffff880061cd3000
[   74.127345] ---[ end trace 60d7f664788c4cb8 ]---



 # addr2line -i -e vmlinux ffffffff812d792c
/usr/src/linux/fs/fhandle.c:265
 # addr2line -i -e vmlinux ffffffff812d77c3
/usr/src/linux/fs/fhandle.c:155
/usr/src/linux/fs/fhandle.c:205
/usr/src/linux/fs/fhandle.c:221
 # addr2line -i -e vmlinux ffffffff81488649
/usr/src/linux/fs/exportfs/expfs.c:385
 # addr2line -i -e vmlinux ffffffff812190d0
/usr/src/linux/mm/shmem.c:2224


Thanks,
Sasha
