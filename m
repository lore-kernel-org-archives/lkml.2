Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365Ab1EaFhn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 01:37:43 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:41527 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102Ab1EaFhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 01:37:42 -0400
Date: Mon, 30 May 2011 22:35:07 -0700 (PDT)
Message-Id: <20110530.223506.424661345.davem@davemloft.net>
To: tj@kernel.org
CC: linux-kernel@vger.kernel.org
Subject: blkdev_get() change causes OOPS...
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 30 May 2011 22:35:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I don't think whole->bd_disk is guaranteed to be non-NULL where you're
dereferencing it in blkdev_get() after commit
d4dc210f69bcb0b4bef5a83b1c323817be89bad1 ("block: don't block events
on excl write for non-optical devices")

I have a CDROM over USB storage, and on bootup the execution of
cdrom_id causes an OOPS when the cdrom is probed.

[1055409.109969] sr 1:0:0:0: Attached scsi CD-ROM sr0
[1055409.167808] Unable to handle kernel NULL pointer dereference
[1055409.167953] tsk->{mm,active_mm}->context = 0000000000000483
[1055409.168080] tsk->{mm,active_mm}->pgd = fffff803fb4f8000
[1055409.168206]               \|/ ____ \|/
[1055409.168212]               "@'/ .. \`@"
[1055409.168218]               /_| \__/ |_\
[1055409.168224]                  \__U_/
[1055409.168372] cdrom_id(2104): Oops [#1]
[1055409.168414] TSTATE: 0000004411001607 TPC: 0000000000544d48 TNPC: 0000000000544d4c Y: 00000000    Not tainted
[1055409.168551] TPC: <blkdev_get+0x208/0x2e0>
[1055409.168590] g0: 0000000000000000 g1: fffff8000e41c268 g2: fffff8000e41c268 g3: 0000000000000000
[1055409.168696] g4: fffff803fc845960 g5: fffff80012868000 g6: fffff803fa504000 g7: ac4b6952bde67a00
[1055409.168875] o0: fffff8000e41c260 o1: fffff803b29799e8 o2: 0000000000000000 o3: fffff803b29799b8
[1055409.169022] o4: ffffffffffffff83 o5: fffff803b29799e8 sp: fffff803fa507161 ret_pc: 0000000000544d3c
[1055409.169134] RPC: <blkdev_get+0x1fc/0x2e0>
[1055409.169210] l0: fffff803b29799b8 l1: 0000000000000000 l2: fffff803b29799e8 l3: 0000000000002000
[1055409.169316] l4: 000000000000000f l5: 0000000000000000 l6: 0000000070008910 l7: 0000000070019c20
[1055409.169422] i0: fffff803b29799a0 i1: 000000000000009d i2: fffff803b031a8a0 i3: ffffffffffffff83
[1055409.169527] i4: 00000000008e22c0 i5: fffff803b29799a0 i6: fffff803fa507241 i7: 0000000000512174
[1055409.169637] I7: <__dentry_open.isra.13+0x114/0x320>
[1055409.169724] Call Trace:
[1055409.169760]  [0000000000512174] __dentry_open.isra.13+0x114/0x320
[1055409.169860]  [0000000000520f00] do_last.isra.38+0x2a0/0x780
[1055409.169954]  [0000000000521524] path_openat+0x84/0x3c0
[1055409.170046]  [0000000000521878] do_filp_open+0x18/0x80
[1055409.170139]  [0000000000513218] do_sys_open+0xd8/0x1a0
[1055409.170204]  [0000000000406114] linux_sparc_syscall32+0x34/0x40
[1055409.170231] sd 0:0:0:0: Attached scsi generic sg0 type 0
[1055409.170374] Disabling lock debugging due to kernel taint
[1055409.170467] sd 0:0:1:0: Attached scsi generic sg1 type 0
[1055409.170485] Caller[0000000000512174]: __dentry_open.isra.13+0x114/0x320
[1055409.170502] Caller[0000000000520f00]: do_last.isra.38+0x2a0/0x780
[1055409.170517] Caller[0000000000521524]: path_openat+0x84/0x3c0
[1055409.170532] Caller[0000000000521878]: do_filp_open+0x18/0x80
[1055409.170546] Caller[0000000000513218]: do_sys_open+0xd8/0x1a0
[1055409.170563] Caller[0000000000406114]: linux_sparc_syscall32+0x34/0x40
[1055409.170580] Caller[00000000f7b78ba8]: 0xf7b78ba8
[1055409.170588] Instruction DUMP: 7ffd1069  92102000  c02f0000 <c2046220> 80a0001b  84603fff  83307008  80888001  02480009
