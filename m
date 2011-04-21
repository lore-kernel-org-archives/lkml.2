Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046Ab1DUOcD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 10:32:03 -0400
Received: from dalsmrelay2.nai.com ([205.227.136.216]:23794 "EHLO
	dalsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458Ab1DUOcA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 10:32:00 -0400
X-Greylist: delayed 604 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Apr 2011 10:32:00 EDT
From: <Martin_Zielinski@McAfee.com>
To: <linux-kernel@vger.kernel.org>
Date: Thu, 21 Apr 2011 09:17:57 -0500
Subject: 2.6.32 ext3 assertion j_running_transaction != NULL fails in
 commit.c
Thread-Topic: 2.6.32 ext3 assertion j_running_transaction != NULL fails in
 commit.c
Thread-Index: AcwALumqG0lmreiaQja41K9AhA/3RA==
Message-ID: <BCB84D936723884B91E4CC5CA0A7C54AA4F6D082BE@EMEADALEXMB1.corp.nai.org>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: de-DE, en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello List!

Please CC me as I'm not subscribed to the list.

I posted this BUG already on the ext3-users list without response.
After making some new observations I hope, that someone here can tell me these make sense. Kernel output of the BUG is at the end of the mail.

On a 2.6.32 ext3 file system in writeback mode we observed several times a BUG in jbd/commit.c on the console. No data goes to the harddisk anymore in this state.

While trying to understand the filesystem code I saw that fsync.c - ext3_sync_file() was called over and over with datasync=1 and a i_datasync_tid smaller than the ei->i_sync_tid and the running transaction tid (suspecting sqlite to be the cause).

Here's some debug output that I put into the code:
kernel: (fs/ext3/fsync.c, 77): ext3_sync_file: ext3_sync_file datasync=1 d_tid=27807 tid=27846
kernel: (fs/jbd/journal.c, 467): log_start_commit: log start commit called with commit request=27845, tid=27807 running transaction=ffff8800266913c0 27846

So the "really-commited" transaction id was advancing while this datasync_tid stayed the same and journal.c - log_start_commit() was called without waking the commit process.

I wondered what happens if the current journal tid is overflowing (32bit unsigned integer). By forcing the tid in get_transaction to jump close to UINT_MAX, I could reproduce the BUG.

In kjournald the condition (journal->j_commit_sequence != journal->j_commit_request) will always be true (commit_sequence = 1,2,3,... commit_request stays 27807) and the commit code is called in a fast loop. 
But this calls are no longer related to the question if a j_running_transaction exists.

I understand litte from the filesystem code. Does this make sense? Is it possible that the overflow of the transaction id leads to this crash?

Thanks for any help that makes me understand better what's going on!

Cheers,
Martin

------------[ cut here ]------------
kernel BUG at fs/jbd/commit.c:342!
invalid opcode: 0000 [#1] SMP 
last sysfs file: /sys/devices/pci0000:00/0000:00:03.0/0000:02:00.1/net/eth3/statistics/tx_bytes
CPU 1 
Modules linked in: bridge stp llc iptable_filter ip_tables x_tables i2c_dev i2c_core ipv6 binfmt_misc sbs sbshc pci_slot fan container battery ac parport_pc lp parport sg ses enclosure button thermal processor
Pid: 2024, comm: kjournald Not tainted 2.6.32-46.r1-x86_64 #1 Appliance
RIP: 0010:[<ffffffff811583db>]  [<ffffffff811583db>] journal_commit_transaction+0xb2/0x10f7
RSP: 0018:ffff88031da3fda0  EFLAGS: 00010246
RAX: ffff88031f04a000 RBX: ffff88031ea41424 RCX: 00000000000004af
RDX: 00000000000004af RSI: 0000000000000000 RDI: ffff88031ea41400
RBP: ffff88031da3fe60 R08: ffff88031ea41488 R09: 0000000000000009
R10: 0000000000000000 R11: 0000000000000001 R12: ffff88031ea41400
R13: ffff88031ea41400 R14: ffff88031ea41590 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff880033020000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00007f3289a6f6b0 CR3: 0000000231828000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kjournald (pid: 2024, threadinfo ffff88031da3e000, task ffff88031e6de140)
Stack:
0000000000013680 000571ff7e347b40 ffff88031ff98400 ffff88031f04a000
<0> 0000000000000000 0000000000000286 ffff88031da3fe00 ffffffff810522c9
<0> 00000000ffffffff ffff88031ea41590 ffff88031ea414c8 0000000000000286
Call Trace:
 [<ffffffff810522c9>] ? lock_timer_base+0x26/0x4a
 [<ffffffff81052392>] ? try_to_del_timer_sync+0xa5/0xb2
 [<ffffffff8115c6b1>] kjournald+0x147/0x377
 [<ffffffff8105edd4>] ? autoremove_wake_function+0x0/0x38
 [<ffffffff8115c56a>] ? kjournald+0x0/0x377
 [<ffffffff8105ecbf>] kthread+0x7d/0x86
 [<ffffffff8100c9da>] child_rip+0xa/0x20
 [<ffffffff8105ec42>] ? kthread+0x0/0x86
 [<ffffffff8100c9d0>] ? child_rip+0x0/0x20
Code: 81 ba 53 01 00 00 48 c7 c6 2e b5 8b 81 31 c0 e8 b0 fe ee ff 48 c7 c7 53 b5 8b 81 31 c0 e8 a2 fe ee ff 49 8b 75 50 48 85 f6 75 04 <0f> 0b eb fe 49 83 7d 58 00 74 04 0f 0b eb fe 83 7e 0c 00 49 89 
RIP  [<ffffffff811583db>] journal_commit_transaction+0xb2/0x10f7
 RSP <ffff88031da3fda0>
---[ end trace 7ef4aef5b1834556 ]---

