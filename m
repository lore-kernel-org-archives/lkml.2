Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630Ab2JOTui (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 15:50:38 -0400
Received: from mail.unix-scripts.info ([46.21.114.223]:34230 "EHLO
	mail.unix-scripts.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754484Ab2JOTug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 15:50:36 -0400
X-Greylist: delayed 455 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Oct 2012 15:50:36 EDT
Date: Mon, 15 Oct 2012 21:42:58 +0200
From: Laurent CARON <lcaron@unix-scripts.info>
To: linux-kernel@vger.kernel.org
Subject: Strange crash on Dell R720xd
Message-ID: <20121015213522.kaiyahro@trusted.unix-scripts.info>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm currently replacing an old system (HP DL 380 G5) by new dell R720xd.
On those new boxes I did configure the H310 controler as plain JBOD.

Those boxes appear to crash more often than not (from 5 mins to a couple
of hours).
I have the impression those crashes appear under heavy IO.

The setup consists of a few md RAID arrays serving as underlying devices
for either filesystem, or drbd (plus lvm on top).

I managed to catch a trace over netconsole:
------------[ cut here ]------------
kernel BUG at crypto/async_tx/async_tx.c:174!
invalid opcode: 0000 [#1] SMP 
Modules linked in: drbd lru_cache netconsole iptable_filter ip_tables ocfs2_dlmfs ocfs2_stack_o2cb ocfs2_dlm ocfs2_nodemanager ocfs2_stackglue bonding ipv6 btrfs ioatdma lpc_ich sb_edac dca mfd_core
CPU 0 
Pid: 12580, comm: kworker/u:2 Not tainted 3.6.2-r510-r720xd #1 Dell Inc. PowerEdge R720xd
RIP: 0010:[<ffffffff8130f9ab>]  [<ffffffff8130f9ab>] async_tx_submit+0x29/0xab
RSP: 0018:ffff88100940fb30  EFLAGS: 00010202
RAX: ffff88100b30aeb0 RBX: ffff88080b5cf390 RCX: 0000000000000029
RDX: ffff88100940fd00 RSI: ffff88080b5cf390 RDI: ffff880809ad0818
RBP: ffff8808054a7d90 R08: ffff88080b5cf900 R09: 0000000000000001
R10: 0000000000001000 R11: 0000000000000001 R12: ffff88100940fd00
R13: 0000000000000002 R14: ffff880809ad0638 R15: ffff880809ad0818
FS:  0000000000000000(0000) GS:ffff88080fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffffffffff600400 CR3: 0000000e4055f000 CR4: 00000000000407f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kworker/u:2 (pid: 12580, threadinfo ffff88100940e000, task ffff880804850630)
Stack:
 ffff88100940fd00 ffff88100940fc40 0000000000000101 ffffffff8131044b
 0000000000000001 0000000000000246 0000000000000201 ffffffffa0073a00
 ffff8808054a7d90 ffff8808054a7690 ffff88100940fc40 ffff88080bf9e668
Call Trace:
 [<ffffffff8131044b>] ? do_async_gen_syndrome+0x2f3/0x320
 [<ffffffffa0073a00>] ? ioat2_tx_submit_unlock+0xac/0xb3 [ioatdma]
 [<ffffffff815e6820>] ? ops_complete_compute+0x7b/0x7b
 [<ffffffff81310540>] ? async_gen_syndrome+0xc8/0x1d6
 [<ffffffff815e8b9a>] ? __raid_run_ops+0x9e7/0xb5a
 [<ffffffff810848f0>] ? select_task_rq_fair+0x487/0x74b
 [<ffffffff815e6820>] ? ops_complete_compute+0x7b/0x7b
 [<ffffffff8107e40b>] ? __wake_up+0x35/0x46
 [<ffffffff8107ca2a>] ? async_schedule+0x12/0x12
 [<ffffffff815e8d3f>] ? async_run_ops+0x32/0x3e
 [<ffffffff8107cace>] ? async_run_entry_fn+0xa4/0x17e
 [<ffffffff8107ca2a>] ? async_schedule+0x12/0x12
 [<ffffffff81071cf8>] ? process_one_work+0x259/0x381
 [<ffffffff81072312>] ? worker_thread+0x2ad/0x3e3
 [<ffffffff81082e50>] ? try_to_wake_up+0x1fc/0x20c
 [<ffffffff81072065>] ? manage_workers+0x245/0x245
 [<ffffffff81072065>] ? manage_workers+0x245/0x245
 [<ffffffff8107746a>] ? kthread+0x81/0x89
 [<ffffffff81791034>] ? kernel_thread_helper+0x4/0x10
 [<ffffffff810773e9>] ? kthread_freezable_should_stop+0x4e/0x4e
 [<ffffffff81791030>] ? gs_change+0xb/0xb
Code: 5b c3 41 54 49 89 d4 55 53 48 89 f3 48 8b 6a 08 48 8b 42 10 48 85 ed 48 89 46 20 48 8b 42 18 48 89 46 28 74 5c f6 45 04 02 74 72 <0f> 0b eb fe 48 8b 02 48 8b 48 28 80 e1 40 74 24 31 f6 48 89 d7 
RIP  [<ffffffff8130f9ab>] async_tx_submit+0x29/0xab
 RSP <ffff88100940fb30>
---[ end trace 64fb561d16a3b535 ]---
Kernel panic - not syncing: Fatal exception in interrupt
Rebooting in 5 seconds..

Do any of you guys have a clue about it ?

Thanks

Laurent

PS: The very same kernel doesn't cause any trouble on R510 hardware.

