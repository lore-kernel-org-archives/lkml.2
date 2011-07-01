Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751608Ab1GAEyN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 00:54:13 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:60356 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092Ab1GAEyL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 00:54:11 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTimo18w5yuE4jtATPvbgENCL04LMpA@mail.gmail.com>
References: <BANLkTimfF3_R5VS4xOriGp+-3j-r7V0W0w@mail.gmail.com>
	<20110630074301.GC27959@flint.arm.linux.org.uk>
	<BANLkTimBTayh_mjOLMZbz3D+wqdtZ10=wA@mail.gmail.com>
	<20110630112804.GA21481@flint.arm.linux.org.uk>
	<BANLkTimo18w5yuE4jtATPvbgENCL04LMpA@mail.gmail.com>
Date: Fri, 1 Jul 2011 12:54:09 +0800
Message-ID: <BANLkTimupUqpLDdDvMRjB+Js0xW59MTOQA@mail.gmail.com>
Subject: Re: PROBLEM: ARM-dma-mapping-fix-for-speculative-prefetching cause OOPS
From: Qin Dehua <qindehua@gmail.com>
To: Russell King <rmk@arm.linux.org.uk>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        santosh.shilimkar@ti.com, neilb@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(sorry, I resent this mail because the previous was rejected by
linux-kernel@vger.kernel.org because of containing HTML.)

I recompiled 2.6.38.8 kernel and run the test 3 times.

Every time the bug occurs at RAID6 starting rebuild the second disk:
~# cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
md1 : active raid6 sdb[1](S) sda[0] sdd[3] sdc[2]
      2000000 blocks super 1.2 level 6, 64k chunk, algorithm 2 [4/2] [__UU]
      [===================>.]  recovery = 99.1% (991760/1000000)
finish=0.0min speed=9784K/sec

unused devices: <none>
~# cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
md1 : active raid6 sdb[1] sda[0] sdd[3] sdc[2]
      2000000 blocks super 1.2 level 6, 64k chunk, algorithm 2 [4/3] [U_UU]
        resync=DELAYED

unused devices: <none>

The followings are messages of the three tests:
====== RUN 1 ======
kernel BUG at drivers/md/raid5.c:3978!
Unable to handle kernel NULL pointer dereference at virtual address 00000000
pgd = 80004000
[00000000] *pgd=00000000
Internal error: Oops: 817 [#1]
last sysfs file: /sys/block/md1/md/mismatch_cnt
Modules linked in:
CPU: 0    Not tainted  (2.6.38.8+ #4)
PC is at __bug+0x1c/0x28
LR is at __bug+0x18/0x28
pc : [<8002b0d4>]    lr : [<8002b0d0>]    psr: 20000093
sp : f122df30  ip : 00000007  fp : 00000000
r10: 00000000  r9 : 00000000  r8 : 00000000
r7 : f11b7328  r6 : f122c000  r5 : 7fffffff  r4 : f11ae4a0
r3 : 00000000  r2 : 60000093  r1 : 0000431f  r0 : 0000002d
Flags: nzCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
Control: 0400397f  Table: 6b4f4018  DAC: 00000035
Process md1_raid6 (pid: 1643, stack limit = 0xf122c278)
Stack: (0xf122df30 to 0xf122e000)
df20:                                     80273244 80273368 00000005 7fffffff
df40: 7fffffff f122c000 f11b7328 f122df6c f0dcf854 f0dcf84c f0f6c400 f0dcf800
df60: 80314dcc 80314784 f11b7320 7fffffff f122c000 f11b7328 f122dfa4 f11b7320
df80: 7fffffff f122c000 f11b7328 f122dfa4 00000000 00000000 00000000 802807e4
dfa0: f122dfcc 00000000 f0fff340 800508a8 f122dfb0 f122dfb0 f11b5c34 f11b7320
dfc0: 8028075c 00000013 00000000 800505e4 00000000 00000000 f11b7320 00000000
dfe0: f122dfe0 f122dfe0 f11b5c34 80050564 80028998 80028998 00000000 00000000
[<8002b0d4>] (__bug+0x1c/0x28) from [<80273368>] (raid5d+0x590/0x594)
[<80273368>] (raid5d+0x590/0x594) from [<802807e4>] (md_thread+0x88/0x130)
[<802807e4>] (md_thread+0x88/0x130) from [<800505e4>] (kthread+0x80/0x88)
[<800505e4>] (kthread+0x80/0x88) from [<80028998>] (kernel_thread_exit+0x0/0x8)
Code: e1a01000 e59f000c eb003cb2 e3a03000 (e5833000)
---[ end trace d52c55614a4f7fe3 ]---

(gdb) li *(raid5d+0x590)
0x8540 is in raid5d (drivers/md/raid5.c:3978).
3973            } else
3974                    return NULL;
3975
3976            list_del_init(&sh->lru);
3977            atomic_inc(&sh->count);
3978            BUG_ON(atomic_read(&sh->count) != 1);
3979            return sh;
3980    }
3981
3982    static int make_request(mddev_t *mddev, struct bio * bi)

====== RUN 2 ======
kernel BUG at drivers/md/raid5.c:199!
Unable to handle kernel NULL pointer dereference at virtual address 00000000
pgd = f0d8c000
[00000000] *pgd=7115b831, *pte=00000000, *ppte=00000000
Internal error: Oops: 817 [#1]
last sysfs file: /sys/block/md1/md/metadata_version
Modules linked in:
CPU: 0    Not tainted  (2.6.38.8+ #4)
PC is at __bug+0x1c/0x28
LR is at __bug+0x18/0x28
pc : [<8002b0d4>]    lr : [<8002b0d0>]    psr: 20000093
sp : f11d7990  ip : 00000007  fp : 00000000
r10: 00048000  r9 : 00000000  r8 : ee29c948
r7 : 00038000  r6 : f0e70de8  r5 : f0d29600  r4 : f0e70de0
r3 : 00000000  r2 : 60000093  r1 : 000044c9  r0 : 0000002c
Flags: nzCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: 0400397f  Table: 70d8c018  DAC: 00000015
Process syslogd (pid: 913, stack limit = 0xf11d6278)
Stack: (0xf11d7990 to 0xf11d8000)
7980:                                     f11d79bc 8026c580 20000013 f134f5a0
79a0: f0e70eb0 8026c5ac 00001000 800b4438 00038000 801b2c94 00000013 00000000
79c0: f1857740 00000000 ee29c948 00000000 00000000 ee29c948 00000000 f1857400
79e0: 00000000 801b3010 f10be4b8 ee29c948 ee29c948 00000000 00000000 801b3dd0
7a00: 00000000 ee29c948 ef68b0a0 00000000 00000000 801b3e28 ef68b280 802106bc
7a20: 000001ad 80027b7c 00000801 f1857400 00000000 00080000 f10bee00 f11d7a60
7a40: 00000001 80532a54 00000010 00000100 0000000a f11d6000 8041e994 801b8370
7a60: f11d7a60 f11d7a60 00000004 8003e484 f1825824 804228f8 0000006b 0000006b
7a80: 804278a0 00000000 f18983fc f1898414 00000040 00000007 f1825824 8002704c
7aa0: ffffffff f11d7ae4 000001ad 80027b7c 00000121 ffffffff 000016e0 0000270f
7ac0: 00000002 00000002 000003e8 f18983fc f1898414 00000040 00000007 f1825824
7ae0: f11d7af8 f11d7af8 80242a68 801be554 20000013 ffffffff 00cfc120 00cfc120
7b00: f18983c0 00000400 f11d6000 00000080 00000093 00000000 f1936b00 80035a24
7b20: 00000000 00000000 80035e78 00000002 00000001 00000002 00000073 f1825824
7b40: 00cfc120 f18983c0 00000000 80244720 00000020 00000080 00000400 00000000
7b60: 0000005b f1898414 00000001 f11d7cc8 00232031 000000e8 00000020 00000000
7b80: 00000000 00cfc120 00000008 00000000 f18983c0 00cfc140 00000001 f18983fc
7ba0: 0000001f 00cfc120 00000020 00000002 00000000 00380000 00000000 00cfc0f4
7bc0: 00000000 f0d37960 00000002 f1074c00 f11d7cc0 8023bcd0 00cfc0f4 00000000
7be0: f11d7cd4 00000000 00000000 0097c0f4 00000000 f1112800 f1112800 8019fe5c
7c00: 0097c0f4 00000000 f11d7cd4 00000000 00000000 00000000 00000000 00000000
7c20: 00000000 0097c0f4 00000000 f1112800 f1112800 f0d37960 f14df000 0097c0f4
7c40: 00000000 801a1d9c 0097c0f4 00000000 f11d7cd4 00000000 00000000 00000002
7c60: f11d7cc0 00000000 00000000 00000000 00000000 00000000 00000000 0097c0f4
7c80: 00000000 0097c0f4 f1112800 f0d37960 f14df000 0000009f 00000003 801994cc
7ca0: 0097c0f4 00000000 f11d7cd4 00000622 f0d37240 f1149d20 00000000 00000002
7cc0: f0d37960 00000044 efb4c354 0000005b 32353a30 0000002c f11d12b8 0000005b
7ce0: 00000000 00000000 00000000 00000000 00000000 00000002 f0d37960 80199af0
7d00: 0000005b 00000003 00000000 0000005b 000002e3 00000000 efb4c354 f14df000
7d20: f1112800 0000005b 00000000 00000000 0000005b 0000005b 00003f0c efb4c354
7d40: ef68b3c0 f0d37988 f0d37960 f14df028 00000355 8133a980 000003af 0002e355
7d60: 00000000 80193fa8 0002e354 0000005b f11d7d84 0000005a f1112800 00000354
7d80: f14df0dc 00000000 0000005a 0000005a 0000005a 0002e355 00000000 f11d6000
7da0: f14df0dc 00000355 00000000 80067324 0000005a 0000005a 8133a980 00000001
7dc0: ee2edb80 00000cab 00000000 80324fa0 f11d7f40 00000001 00000000 0000005a
7de0: 00000001 8133a980 4e0d3670 f14df028 00000001 0002e355 00000000 0000005a
7e00: ee2edb80 f11d6000 00000000 800687f4 0002e355 00000000 f11d7f00 0000005a
7e20: 00000000 80088664 000200da f11d7f00 f11d7f40 f11d7ec8 f11d7ee4 f1412180
7e40: f11d7e84 f14df0dc 0000044e f0c37370 f0c37370 00000001 00000000 f0c35514
7e60: 7065114f f0c37370 81350a20 0000005a f0d8caa8 f14df040 00000001 f11d7ec8
7e80: f11d7f40 0002e355 00000000 ee2edb80 7eb75724 80068a70 f0d8c000 2ab45000
7ea0: f11d7ec8 fffffdee f11d7f40 ee2edb80 f11d7f80 f11d6000 00000000 8008d2b4
7ec0: 0002e355 00000000 00000817 f10f8ab4 00000000 00000001 ffffffff ee2edb80
7ee0: 00000000 00000000 00000000 00000000 f1936b00 8041d068 00000000 00000000
7f00: 0002e355 00000000 7eb750d4 800272e0 0000005a 800828f4 0000005a 00000000
7f20: 00000000 0002ab45 00000000 80080c78 00000022 00000022 00000000 00000000
7f40: 2ab45000 0000005a ee2edb80 0000005a 2ab45000 f11d7f80 800280e4 8008db34
7f60: ee2edb80 00000001 ee2edb80 fffffff7 0002e355 00000000 800280e4 8008e110
7f80: 0002e355 00000000 00000001 00000001 00000000 7eb751a0 0000005a 2ab45000
7fa0: 00000004 80027f40 7eb751a0 0000005a 00000004 2ab45000 0000005a 00000000
7fc0: 7eb751a0 0000005a 2ab45000 00000004 0000005a 0000004a 2ada7000 7eb75724
7fe0: 00000000 7eb75088 2ad58a9c 2ad40ac4 60000010 00000004 00000000 00000000
[<8002b0d4>] (__bug+0x1c/0x28) from [<8026c580>] (__release_stripe+0x1dc/0x1ec)
[<8026c580>] (__release_stripe+0x1dc/0x1ec) from [<8026c5ac>]
(release_stripe+0x1c/0x24)
[<8026c5ac>] (release_stripe+0x1c/0x24) from [<800b4438>] (bio_endio+0x48/0x64)
[<800b4438>] (bio_endio+0x48/0x64) from [<801b2c94>]
(blk_update_request+0x8c/0x3f0)
[<801b2c94>] (blk_update_request+0x8c/0x3f0) from [<801b3010>]
(blk_update_bidi_request+0x18/0x74)
[<801b3010>] (blk_update_bidi_request+0x18/0x74) from [<801b3dd0>]
(blk_end_bidi_request+0x14/0x5c)
[<801b3dd0>] (blk_end_bidi_request+0x14/0x5c) from [<801b3e28>]
(blk_end_request+0x10/0x18)
[<801b3e28>] (blk_end_request+0x10/0x18) from [<802106bc>]
(scsi_io_completion+0x74/0x4c4)
[<802106bc>] (scsi_io_completion+0x74/0x4c4) from [<801b8370>]
(blk_done_softirq+0x80/0x98)
[<801b8370>] (blk_done_softirq+0x80/0x98) from [<8003e484>]
(__do_softirq+0x88/0x124)
[<8003e484>] (__do_softirq+0x88/0x124) from [<8002704c>] (asm_do_IRQ+0x4c/0x98)
[<8002704c>] (asm_do_IRQ+0x4c/0x98) from [<80027b7c>] (__irq_svc+0x3c/0x80)
Exception stack(0xf11d7ab0 to 0xf11d7af8)
7aa0:                                     00000121 ffffffff 000016e0 0000270f
7ac0: 00000002 00000002 000003e8 f18983fc f1898414 00000040 00000007 f1825824
7ae0: f11d7af8 f11d7af8 80242a68 801be554 20000013 ffffffff
[<80027b7c>] (__irq_svc+0x3c/0x80) from [<801be554>] (__delay+0x4/0xc)
[<801be554>] (__delay+0x4/0xc) from [<80242a68>]
(inval_cache_and_wait_for_operation+0x27c/0x3b0)
[<80242a68>] (inval_cache_and_wait_for_operation+0x27c/0x3b0) from
[<80244720>] (cfi_intelext_writev+0xaa0/0x1184)
[<80244720>] (cfi_intelext_writev+0xaa0/0x1184) from [<8023bcd0>]
(part_writev+0x48/0x58)
[<8023bcd0>] (part_writev+0x48/0x58) from [<8019fe5c>]
(jffs2_flash_direct_writev+0x38/0x104)
[<8019fe5c>] (jffs2_flash_direct_writev+0x38/0x104) from [<801a1d9c>]
(jffs2_flash_writev+0x330/0x438)
[<801a1d9c>] (jffs2_flash_writev+0x330/0x438) from [<801994cc>]
(jffs2_write_dnode+0x1d8/0x434)
[<801994cc>] (jffs2_write_dnode+0x1d8/0x434) from [<80199af0>]
(jffs2_write_inode_range+0x2a8/0x430)
[<80199af0>] (jffs2_write_inode_range+0x2a8/0x430) from [<80193fa8>]
(jffs2_write_end+0x180/0x2e4)
[<80193fa8>] (jffs2_write_end+0x180/0x2e4) from [<80067324>]
(generic_file_buffered_write+0xec/0x234)
[<80067324>] (generic_file_buffered_write+0xec/0x234) from
[<800687f4>] (__generic_file_aio_write+0x264/0x484)
[<800687f4>] (__generic_file_aio_write+0x264/0x484) from [<80068a70>]
(generic_file_aio_write+0x5c/0xd0)
[<80068a70>] (generic_file_aio_write+0x5c/0xd0) from [<8008d2b4>]
(do_sync_write+0xa8/0xe8)
[<8008d2b4>] (do_sync_write+0xa8/0xe8) from [<8008db34>] (vfs_write+0xb4/0x148)
[<8008db34>] (vfs_write+0xb4/0x148) from [<8008e110>] (sys_write+0x3c/0x6c)
[<8008e110>] (sys_write+0x3c/0x6c) from [<80027f40>] (ret_fast_syscall+0x0/0x3c)
Code: e1a01000 e59f000c eb003cb2 e3a03000 (e5833000)
---[ end trace 85ad4ff48ad369db ]---
Kernel panic - not syncing: Fatal exception in interrupt
[<8002ced8>] (unwind_backtrace+0x0/0xf0) from [<8003934c>] (panic+0x5c/0x1a0)
[<8003934c>] (panic+0x5c/0x1a0) from [<8002b60c>] (die+0x188/0x1bc)
[<8002b60c>] (die+0x188/0x1bc) from [<8002dfb4>] (__do_kernel_fault+0x68/0x88)
[<8002dfb4>] (__do_kernel_fault+0x68/0x88) from [<8002e11c>]
(do_page_fault+0x148/0x214)
[<8002e11c>] (do_page_fault+0x148/0x214) from [<800272e0>]
(do_DataAbort+0x38/0x9c)
[<800272e0>] (do_DataAbort+0x38/0x9c) from [<80027b2c>] (__dabt_svc+0x4c/0x60)
Exception stack(0xf11d7948 to 0xf11d7990)
7940:                   0000002c 000044c9 60000093 00000000 f0e70de0 f0d29600
7960: f0e70de8 00038000 ee29c948 00000000 00048000 00000000 00000007 f11d7990
7980: 8002b0d0 8002b0d4 20000093 ffffffff
[<80027b2c>] (__dabt_svc+0x4c/0x60) from [<8002b0d4>] (__bug+0x1c/0x28)
[<8002b0d4>] (__bug+0x1c/0x28) from [<8026c580>] (__release_stripe+0x1dc/0x1ec)
[<8026c580>] (__release_stripe+0x1dc/0x1ec) from [<8026c5ac>]
(release_stripe+0x1c/0x24)
[<8026c5ac>] (release_stripe+0x1c/0x24) from [<800b4438>] (bio_endio+0x48/0x64)
[<800b4438>] (bio_endio+0x48/0x64) from [<801b2c94>]
(blk_update_request+0x8c/0x3f0)
[<801b2c94>] (blk_update_request+0x8c/0x3f0) from [<801b3010>]
(blk_update_bidi_request+0x18/0x74)
[<801b3010>] (blk_update_bidi_request+0x18/0x74) from [<801b3dd0>]
(blk_end_bidi_request+0x14/0x5c)
[<801b3dd0>] (blk_end_bidi_request+0x14/0x5c) from [<801b3e28>]
(blk_end_request+0x10/0x18)
[<801b3e28>] (blk_end_request+0x10/0x18) from [<802106bc>]
(scsi_io_completion+0x74/0x4c4)
[<802106bc>] (scsi_io_completion+0x74/0x4c4) from [<801b8370>]
(blk_done_softirq+0x80/0x98)
[<801b8370>] (blk_done_softirq+0x80/0x98) from [<8003e484>]
(__do_softirq+0x88/0x124)
[<8003e484>] (__do_softirq+0x88/0x124) from [<8002704c>] (asm_do_IRQ+0x4c/0x98)
[<8002704c>] (asm_do_IRQ+0x4c/0x98) from [<80027b7c>] (__irq_svc+0x3c/0x80)
Exception stack(0xf11d7ab0 to 0xf11d7af8)
7aa0:                                     00000121 ffffffff 000016e0 0000270f
7ac0: 00000002 00000002 000003e8 f18983fc f1898414 00000040 00000007 f1825824
7ae0: f11d7af8 f11d7af8 80242a68 801be554 20000013 ffffffff
[<80027b7c>] (__irq_svc+0x3c/0x80) from [<801be554>] (__delay+0x4/0xc)
[<801be554>] (__delay+0x4/0xc) from [<80242a68>]
(inval_cache_and_wait_for_operation+0x27c/0x3b0)
[<80242a68>] (inval_cache_and_wait_for_operation+0x27c/0x3b0) from
[<80244720>] (cfi_intelext_writev+0xaa0/0x1184)
[<80244720>] (cfi_intelext_writev+0xaa0/0x1184) from [<8023bcd0>]
(part_writev+0x48/0x58)
[<8023bcd0>] (part_writev+0x48/0x58) from [<8019fe5c>]
(jffs2_flash_direct_writev+0x38/0x104)
[<8019fe5c>] (jffs2_flash_direct_writev+0x38/0x104) from [<801a1d9c>]
(jffs2_flash_writev+0x330/0x438)
[<801a1d9c>] (jffs2_flash_writev+0x330/0x438) from [<801994cc>]
(jffs2_write_dnode+0x1d8/0x434)
[<801994cc>] (jffs2_write_dnode+0x1d8/0x434) from [<80199af0>]
(jffs2_write_inode_range+0x2a8/0x430)
[<80199af0>] (jffs2_write_inode_range+0x2a8/0x430) from [<80193fa8>]
(jffs2_write_end+0x180/0x2e4)
[<80193fa8>] (jffs2_write_end+0x180/0x2e4) from [<80067324>]
(generic_file_buffered_write+0xec/0x234)
[<80067324>] (generic_file_buffered_write+0xec/0x234) from
[<800687f4>] (__generic_file_aio_write+0x264/0x484)
[<800687f4>] (__generic_file_aio_write+0x264/0x484) from [<80068a70>]
(generic_file_aio_write+0x5c/0xd0)
[<80068a70>] (generic_file_aio_write+0x5c/0xd0) from [<8008d2b4>]
(do_sync_write+0xa8/0xe8)
[<8008d2b4>] (do_sync_write+0xa8/0xe8) from [<8008db34>] (vfs_write+0xb4/0x148)
[<8008db34>] (vfs_write+0xb4/0x148) from [<8008e110>] (sys_write+0x3c/0x6c)
[<8008e110>] (sys_write+0x3c/0x6c) from [<80027f40>] (ret_fast_syscall+0x0/0x3c)

(gdb) li *(__release_stripe+0x1dc)
0x1758 is in __release_stripe (drivers/md/raid5.c:215).
210                                     clear_bit(STRIPE_BIT_DELAY, &sh->state);
211                                     list_add_tail(&sh->lru,
&conf->handle_list);
212                             }
213                             md_wakeup_thread(conf->mddev->thread);
214                     } else {
215                             BUG_ON(stripe_operations_active(sh));
216                             if
(test_and_clear_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
217
atomic_dec(&conf->preread_active_stripes);
218                                     if
(atomic_read(&conf->preread_active_stripes) < IO_THRESHOLD)
219
md_wakeup_thread(conf->mddev->thread);

vi drivers/md/raid5.c:

 196 static void __release_stripe(raid5_conf_t *conf, struct stripe_head *sh)
 197 {
 198     if (atomic_dec_and_test(&sh->count)) {
 199         BUG_ON(!list_empty(&sh->lru));
 200         BUG_ON(atomic_read(&conf->active_stripes)==0);
 201         if (test_bit(STRIPE_HANDLE, &sh->state)) {
 202             if (test_bit(STRIPE_DELAYED, &sh->state)) {
 203                 list_add_tail(&sh->lru, &conf->delayed_list);
 204                 plugger_set_plug(&conf->plug);
 205             } else if (test_bit(STRIPE_BIT_DELAY, &sh->state) &&
 206                    sh->bm_seq - conf->seq_write > 0) {
 207                 list_add_tail(&sh->lru, &conf->bitmap_list);
 208                 plugger_set_plug(&conf->plug);
 209             } else {
 210                 clear_bit(STRIPE_BIT_DELAY, &sh->state);
 211                 list_add_tail(&sh->lru, &conf->handle_list);
 212             }
 213             md_wakeup_thread(conf->mddev->thread);
 214         } else {
 215             BUG_ON(stripe_operations_active(sh));

====== RUN 3 ======
kernel BUG at drivers/md/raid5.c:199!
Unable to handle kernel NULL pointer dereference at virtual address 00000000
pgd = eb234000
[00000000] *pgd=6b876831, *pte=00000000, *ppte=00000000
Internal error: Oops: 817 [#1]
last sysfs file: /sys/block/md1/md/metadata_version
Modules linked in:
CPU: 0    Not tainted  (2.6.38.8+ #4)
PC is at __bug+0x1c/0x28
LR is at __bug+0x18/0x28
pc : [<8002b0d4>]    lr : [<8002b0d0>]    psr: 20000093
sp : efc83c80  ip : 00000007  fp : 00000000
r10: 00009000  r9 : 00000000  r8 : efca8ca8
r7 : 00057000  r6 : f0e4a4a8  r5 : f0ca0600  r4 : f0e4a4a0
r3 : 00000000  r2 : 60000093  r1 : 00004544  r0 : 0000002c
Flags: nzCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: 0400397f  Table: 6b234018  DAC: 00000015
Process handle_alarm.sh (pid: 5250, stack limit = 0xefc82278)
Stack: (0xefc83c80 to 0xefc84000)
3c80: f18b413c 8026c580 20000013 f1206f30 f0e4a5f0 8026c5ac 00001000 800b4438
3ca0: 00057000 801b2c94 f1831430 00000000 f18b4000 00000000 efca8ca8 00000000
3cc0: 00000000 efca8ca8 00000000 f1857740 00000000 801b3010 f18b4000 efca8ca8
3ce0: efca8ca8 00000000 00000000 801b3dd0 00000002 efca8ca8 ef22daa0 00000000
3d00: 00000000 801b3e28 ef22db40 802106bc f5000000 f181f190 00000000 f1857740
3d20: f5000000 00060000 f10be400 efc83d50 00000001 80532a54 00000010 00000100
3d40: 0000000a efc82000 8041e994 801b8370 efc83d50 efc83d50 00000004 8003e484
3d60: efc83df4 804228f8 0000006b 0000006b 804278a0 00000000 00001564 0000005a
3d80: 00000000 f0c97a80 efc83df4 8002704c ffffffff efc83dd4 000001ad 80027b7c
3da0: 00000000 f10c6290 f10c6290 60000013 00000000 00000001 efc6a5d8 00001564
3dc0: 0000005a 00000000 f0c97a80 efc83df4 f10c6290 efc83de8 801c33f0 8002e958
3de0: 60000013 ffffffff efc481e0 2ac78000 81335e60 f10c6290 00000100 00000000
3e00: 00000000 f140a3b0 0000005a 0000005a 80544000 0156418f 8056ec80 efc6a5d8
3e20: efc481e0 00000000 00000200 2ac78000 00000000 8007c2e8 00000001 eb234ab0
3e40: 00000000 00000000 00000000 0000005a 2ac78000 8056ec80 eb234aa8 00000000
3e60: efc481e0 efc6a5d8 00000000 2ac78000 eb234ab0 f0c97a80 7ee878a4 8007cef4
3e80: 0000005a 00000000 00000000 ffffffff 00000817 00000ab0 eb234000 2ac78000
3ea0: f0c97a80 eb234ab0 00000000 efc6a5d8 7ee878a4 8007d638 eb234ab0 00000000
3ec0: efc6a5d8 f0c97a80 80000005 f0c97ab4 2ac78d08 efc83fb0 f0072840 8002e144
3ee0: f10fdbb0 8003405c 8041e578 ffffffff 00000005 8041ce48 2ac78d08 efc83fb0
3f00: 00000000 2ad21000 7ee878a4 80027244 00000000 efc83f20 80314818 80027f00
3f20: efc82000 00000011 00000000 7ef43e1c f1836000 f0072840 ffffffff efc83f84
3f40: 00000000 00000000 00000000 80027b2c 2ab28048 00000000 00001482 f0072840
3f60: efc82000 00000000 00000000 00000000 00000000 00000000 00000000 efc83fac
3f80: 8041ffb4 efc83f98 80035fac 801bf97c 60000013 ffffffff ffffffff 000013e7
3fa0: 7ee87840 00000078 00000000 80027ec0 00000000 00000000 00000000 2ac78d08
3fc0: 00000000 000013e7 7ee87840 00000078 00000000 00000000 2ad21000 7ee878a4
3fe0: 2ab052b0 7ee87840 2ac9af14 2ac78d08 20000010 ffffffff 00000000 00000000
[<8002b0d4>] (__bug+0x1c/0x28) from [<8026c580>] (__release_stripe+0x1dc/0x1ec)
[<8026c580>] (__release_stripe+0x1dc/0x1ec) from [<8026c5ac>]
(release_stripe+0x1c/0x24)
[<8026c5ac>] (release_stripe+0x1c/0x24) from [<800b4438>] (bio_endio+0x48/0x64)
[<800b4438>] (bio_endio+0x48/0x64) from [<801b2c94>]
(blk_update_request+0x8c/0x3f0)
[<801b2c94>] (blk_update_request+0x8c/0x3f0) from [<801b3010>]
(blk_update_bidi_request+0x18/0x74)
[<801b3010>] (blk_update_bidi_request+0x18/0x74) from [<801b3dd0>]
(blk_end_bidi_request+0x14/0x5c)
[<801b3dd0>] (blk_end_bidi_request+0x14/0x5c) from [<801b3e28>]
(blk_end_request+0x10/0x18)
[<801b3e28>] (blk_end_request+0x10/0x18) from [<802106bc>]
(scsi_io_completion+0x74/0x4c4)
[<802106bc>] (scsi_io_completion+0x74/0x4c4) from [<801b8370>]
(blk_done_softirq+0x80/0x98)
[<801b8370>] (blk_done_softirq+0x80/0x98) from [<8003e484>]
(__do_softirq+0x88/0x124)
[<8003e484>] (__do_softirq+0x88/0x124) from [<8002704c>] (asm_do_IRQ+0x4c/0x98)
[<8002704c>] (asm_do_IRQ+0x4c/0x98) from [<80027b7c>] (__irq_svc+0x3c/0x80)
Exception stack(0xefc83da0 to 0xefc83de8)
3da0: 00000000 f10c6290 f10c6290 60000013 00000000 00000001 efc6a5d8 00001564
3dc0: 0000005a 00000000 f0c97a80 efc83df4 f10c6290 efc83de8 801c33f0 8002e958
3de0: 60000013 ffffffff
[<80027b7c>] (__irq_svc+0x3c/0x80) from [<8002e958>]
(update_mmu_cache+0x168/0x1f0)
[<8002e958>] (update_mmu_cache+0x168/0x1f0) from [<8007c2e8>]
(__do_fault+0x294/0x430)
[<8007c2e8>] (__do_fault+0x294/0x430) from [<8007cef4>]
(handle_pte_fault+0x78/0x35c)
[<8007cef4>] (handle_pte_fault+0x78/0x35c) from [<8007d638>]
(handle_mm_fault+0x88/0xac)
[<8007d638>] (handle_mm_fault+0x88/0xac) from [<8002e144>]
(do_page_fault+0x170/0x214)
[<8002e144>] (do_page_fault+0x170/0x214) from [<80027244>]
(do_PrefetchAbort+0x38/0x9c)
[<80027244>] (do_PrefetchAbort+0x38/0x9c) from [<80027ec0>]
(ret_from_exception+0x0/0x10)
Exception stack(0xefc83fb0 to 0xefc83ff8)
3fa0:                                     00000000 00000000 00000000 2ac78d08
3fc0: 00000000 000013e7 7ee87840 00000078 00000000 00000000 2ad21000 7ee878a4
3fe0: 2ab052b0 7ee87840 2ac9af14 2ac78d08 20000010 ffffffff
Code: e1a01000 e59f000c eb003cb2 e3a03000 (e5833000)
---[ end trace 01791389570b7cb9 ]---
Kernel panic - not syncing: Fatal exception in interrupt
[<8002ced8>] (unwind_backtrace+0x0/0xf0) from [<8003934c>] (panic+0x5c/0x1a0)
[<8003934c>] (panic+0x5c/0x1a0) from [<8002b60c>] (die+0x188/0x1bc)
[<8002b60c>] (die+0x188/0x1bc) from [<8002dfb4>] (__do_kernel_fault+0x68/0x88)
[<8002dfb4>] (__do_kernel_fault+0x68/0x88) from [<8002e11c>]
(do_page_fault+0x148/0x214)
[<8002e11c>] (do_page_fault+0x148/0x214) from [<800272e0>]
(do_DataAbort+0x38/0x9c)
[<800272e0>] (do_DataAbort+0x38/0x9c) from [<80027b2c>] (__dabt_svc+0x4c/0x60)
Exception stack(0xefc83c38 to 0xefc83c80)
3c20:                                                       0000002c 00004544
3c40: 60000093 00000000 f0e4a4a0 f0ca0600 f0e4a4a8 00057000 efca8ca8 00000000
3c60: 00009000 00000000 00000007 efc83c80 8002b0d0 8002b0d4 20000093 ffffffff
[<80027b2c>] (__dabt_svc+0x4c/0x60) from [<8002b0d4>] (__bug+0x1c/0x28)
[<8002b0d4>] (__bug+0x1c/0x28) from [<8026c580>] (__release_stripe+0x1dc/0x1ec)
[<8026c580>] (__release_stripe+0x1dc/0x1ec) from [<8026c5ac>]
(release_stripe+0x1c/0x24)
[<8026c5ac>] (release_stripe+0x1c/0x24) from [<800b4438>] (bio_endio+0x48/0x64)
[<800b4438>] (bio_endio+0x48/0x64) from [<801b2c94>]
(blk_update_request+0x8c/0x3f0)
[<801b2c94>] (blk_update_request+0x8c/0x3f0) from [<801b3010>]
(blk_update_bidi_request+0x18/0x74)
[<801b3010>] (blk_update_bidi_request+0x18/0x74) from [<801b3dd0>]
(blk_end_bidi_request+0x14/0x5c)
[<801b3dd0>] (blk_end_bidi_request+0x14/0x5c) from [<801b3e28>]
(blk_end_request+0x10/0x18)
[<801b3e28>] (blk_end_request+0x10/0x18) from [<802106bc>]
(scsi_io_completion+0x74/0x4c4)
[<802106bc>] (scsi_io_completion+0x74/0x4c4) from [<801b8370>]
(blk_done_softirq+0x80/0x98)
[<801b8370>] (blk_done_softirq+0x80/0x98) from [<8003e484>]
(__do_softirq+0x88/0x124)
[<8003e484>] (__do_softirq+0x88/0x124) from [<8002704c>] (asm_do_IRQ+0x4c/0x98)
[<8002704c>] (asm_do_IRQ+0x4c/0x98) from [<80027b7c>] (__irq_svc+0x3c/0x80)
Exception stack(0xefc83da0 to 0xefc83de8)
3da0: 00000000 f10c6290 f10c6290 60000013 00000000 00000001 efc6a5d8 00001564
3dc0: 0000005a 00000000 f0c97a80 efc83df4 f10c6290 efc83de8 801c33f0 8002e958
3de0: 60000013 ffffffff
[<80027b7c>] (__irq_svc+0x3c/0x80) from [<8002e958>]
(update_mmu_cache+0x168/0x1f0)
[<8002e958>] (update_mmu_cache+0x168/0x1f0) from [<8007c2e8>]
(__do_fault+0x294/0x430)
[<8007c2e8>] (__do_fault+0x294/0x430) from [<8007cef4>]
(handle_pte_fault+0x78/0x35c)
[<8007cef4>] (handle_pte_fault+0x78/0x35c) from [<8007d638>]
(handle_mm_fault+0x88/0xac)
[<8007d638>] (handle_mm_fault+0x88/0xac) from [<8002e144>]
(do_page_fault+0x170/0x214)
[<8002e144>] (do_page_fault+0x170/0x214) from [<80027244>]
(do_PrefetchAbort+0x38/0x9c)
[<80027244>] (do_PrefetchAbort+0x38/0x9c) from [<80027ec0>]
(ret_from_exception+0x0/0x10)
Exception stack(0xefc83fb0 to 0xefc83ff8)
3fa0:                                     00000000 00000000 00000000 2ac78d08
3fc0: 00000000 000013e7 7ee87840 00000078 00000000 00000000 2ad21000 7ee878a4
3fe0: 2ab052b0 7ee87840 2ac9af14 2ac78d08 20000010 ffffffff

Regards,
QinDehua

2011/7/1 Dan Williams <dan.j.williams@intel.com>
>
> On Thu, Jun 30, 2011 at 4:28 AM, Russell King <rmk@arm.linux.org.uk> wrote:
> > In that case, the raid5 code contains an explicit NULL pointer
> > dereference which isn't a BUG() - the code line disassembles to:
> >
> >   0:   ebfff1bc        bl      0xffffc6f8
> >   4:   e28dd044        add     sp, sp, #68     ; 0x44
> >   8:   e8bd8ff0        pop     {r4, r5, r6, r7, r8, r9, sl, fp, pc}
> >   c:   e3a03000        mov     r3, #0  ; 0x0
> >  10:   e5833000        str     r3, [r3] <=== faulting instruction
> >
> > So, if you're saying that's not a BUG(), then I don't know what it is
> > and I'm afraid I can't help because the oops doesn't make any sense
> > to me.
> >
>
> QinDehua,
>
> Can you rebuild with CONFIG_DEBUG_INFO=y, reproduce the crash and then
> send the output of:
>
> $ gdb drivers/md/raid5.o
> (gdb) li *(raid5d+0x580)
> (gdb) li *(__release_stripe+0x1e4)
> etc...
>
> ...those offsets might change so just grab whatever "PC is at "
> reports in the oops.
>
> --
> Dan
