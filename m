Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784Ab2ECF67 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 01:58:59 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:27024 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137Ab2ECF66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 01:58:58 -0400
Message-ID: <1336024803.10945.5.camel@lappy>
Subject: ecryptfs: Kernel BUG when closing device
From: Sasha Levin <sasha.levin@oracle.com>
To: tyhicks@canonical.com, dustin.kirkland@gazzang.com
Cc: Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ecryptfs@vger.kernel.org
Date: Thu, 03 May 2012 08:00:03 +0200
Organization: Oracle
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

After some fuzzing using trinity inside a KVM guest, I've stumbled on the following:

[ 2674.118324] ------------[ cut here ]------------
[ 2674.119028] kernel BUG at fs/ecryptfs/miscdev.c:155!
[ 2674.119028] invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[ 2674.119028] CPU 0 
[ 2674.119028] Pid: 12745, comm: trinity Tainted: G        W    3.4.0-rc5-next-20120501-sasha-00003-gfaa6ef1 #106
[ 2674.119028] RIP: 0010:[<ffffffff813722f6>]  [<ffffffff813722f6>] ecryptfs_miscdev_release+0x66/0x120
[ 2674.119028] RSP: 0018:ffff88006ed19be8  EFLAGS: 00010282
[ 2674.119028] RAX: 00000000ffffffea RBX: ffff88006eee8000 RCX: ffff88001a109d88
[ 2674.119028] RDX: ffffffff83a3cd00 RSI: 000000009a6561a0 RDI: ffff88006ed19bf0
[ 2674.119028] RBP: ffff88006ed19c08 R08: f2fd966b13e561a0 R09: 4000000000000000
[ 2674.119028] R10: 0000000000000000 R11: 0d00000000000000 R12: 000000009a6561a0
[ 2674.119028] R13: ffff88000c834ab0 R14: ffff88000d02d030 R15: ffff88000c834ab0
[ 2674.119028] FS:  00007f7689f4e700(0000) GS:ffff88000d800000(0000) knlGS:0000000000000000
[ 2674.119028] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 2674.119028] CR2: 0000000000000ffc CR3: 0000000003a1c000 CR4: 00000000000407f0
[ 2674.119028] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2674.119028] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2674.119028] Process trinity (pid: 12745, threadinfo ffff88006ed18000, task ffff88006eee8000)
[ 2674.119028] Stack:
[ 2674.119028]  0000000000000008 ffff88001a109d88 ffff8800199b2680 0000000000000008
[ 2674.119028]  ffff88006ed19c58 ffffffff811ebcea ffff8800199b2690 ffff8800406b0020
[ 2674.119028]  ffff88006ed19c58 ffff8800199b2680 ffff88000cc55a00 0000000000000000
[ 2674.119028] Call Trace:
[ 2674.119028]  [<ffffffff811ebcea>] __fput+0x11a/0x2c0
[ 2674.119028]  [<ffffffff811ebea5>] fput+0x15/0x20
[ 2674.119028]  [<ffffffff811e81c2>] filp_close+0x82/0xa0
[ 2674.119028]  [<ffffffff810ba5c4>] close_files+0x1b4/0x200
[ 2674.119028]  [<ffffffff810ba410>] ? wait_task_stopped+0x3c0/0x3c0
[ 2674.119028]  [<ffffffff810ba631>] put_files_struct+0x21/0x180
[ 2674.119028]  [<ffffffff82d93820>] ? _raw_spin_unlock+0x30/0x60
[ 2674.119028]  [<ffffffff810ba7dd>] exit_files+0x4d/0x60
[ 2674.119028]  [<ffffffff810bc85b>] do_exit+0x27b/0x460
[ 2674.119028]  [<ffffffff810e74d1>] ? get_parent_ip+0x11/0x50
[ 2674.119028]  [<ffffffff810bcae1>] do_group_exit+0xa1/0xe0
[ 2674.119028]  [<ffffffff810ccf98>] get_signal_to_deliver+0x348/0x3a0
[ 2674.119028]  [<ffffffff8104daf2>] do_signal+0x42/0x120
[ 2674.119028]  [<ffffffff8104e58f>] ? do_divide_error+0xaf/0xc0
[ 2674.119028]  [<ffffffff82d93fff>] ? retint_signal+0x11/0x92
[ 2674.119028]  [<ffffffff8104dc24>] do_notify_resume+0x54/0xa0
[ 2674.119028]  [<ffffffff82d9403b>] retint_signal+0x4d/0x92
[ 2674.119028] Code: f1 4f d6 ff 48 8b 83 40 06 00 00 48 8d 7d e8 48 8b 90 88 00 00 00 44 89 e6 e8 37 f0 ff ff 85 c0 75 09 48 8b 7d e8 48 85 ff 75 12 <0f> 0b 0f 1f 84 00 00 00 00 00 eb fe 66 0f 1f 44 00 00 48 83 c7 
[ 2674.119028] RIP  [<ffffffff813722f6>] ecryptfs_miscdev_release+0x66/0x120
[ 2674.119028]  RSP <ffff88006ed19be8>
[ 2674.319199] ---[ end trace 44593438a59a9537 ]---

For reference, here are other error messages thrown out during that run:

[  103.989497] ecryptfs_miscdev_open: pid [0xffff8800346dfdc0] has registered with euid [0], but pid [0xffff88000c3aec40] has attempted to open the handle instead
[  347.692999] ecryptfs_miscdev_write: Acceptable packet size range is [6-531], but amount of data written is [10376].120000 iterations.
[ 1920.665966] ecryptfs_miscdev_write: Acceptable packet size range is [6-531], but amount of data written is [37505].1117000 iterations.
[ 2168.232502] ecryptfs_miscdev_write: Acceptable packet size range is [6-531], but amount of data written is [31302].1220000 iterations.

