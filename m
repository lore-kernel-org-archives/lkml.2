Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287Ab0D0LyR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 07:54:17 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:57026 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab0D0LyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 07:54:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=fh5tBYJ8mg+oy1V9Vuw+VoHmb4z3KedkN37Ql7j+2hlEFDp6JVtkEAwUxD6UTCv+iU
         Rdd7PsofdLb4rMTi6jFEsf8zZlZK3VRRxriT3uhgs7+caFwxvoeGY9Ts0fH0xWZ6X1sy
         bP68m1O5sWt00hC+nCQUVyw7T09ACD0wvTcws=
MIME-Version: 1.0
In-Reply-To: <20100427114004.GD13859@logfs.org>
References: <20100423205518.GB7008@logfs.org> <20100426143253.GB4364@logfs.org>
	 <20100426143803.GM27497@kernel.dk> <20100426144532.GN27497@kernel.dk>
	 <20100426163050.GC4364@logfs.org> <20100426163126.GD4364@logfs.org>
	 <x2v4aa525de1004270201t9f57f49fv1e9cfbb2d886e4ad@mail.gmail.com>
	 <20100427111759.GA13859@logfs.org>
	 <h2h4aa525de1004270431hd98c271ag61462bdb778f7769@mail.gmail.com>
	 <20100427114004.GD13859@logfs.org>
Date: Tue, 27 Apr 2010 13:54:09 +0200
Message-ID: <u2u4aa525de1004270454v4da1cb28ld5f2a3e54962f182@mail.gmail.com>
Subject: Re: [PATCH 2/2] [MTD] Call bdi_init() and bdi_register()
From: Paolo Minazzi <paolo.minazzi@gmail.com>
To: =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@logfs.org>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, now it is very better.
My problem now is that logfs does not save files in the following case:
1) power-off, then power-on (without umount)
2) sync, then power-off, then power-on (without umount)

Using umount sometimes seems works, sometimes I have the following oop :

~ # mount -t logfs /dev/mtdblock7 /mitrolbackup
~ # cd /mitrolbackup
/mitrolbackup # echo ciao > ciao
/mitrolbackup # echo pino > pino
/mitrolbackup # ls
ciao  pino
/mitrolbackup # cd ..
~ # umount /mitrolbackup/
kernel BUG at fs/logfs/readwrite.c:1976!
Unable to handle kernel NULL pointer dereference at virtual address 00000000
pgd = c7db0000
[00000000] *pgd=c7dac031, *pte=00000000, *ppte=00000000
Internal error: Oops: 817 [#1]
last sysfs file:
Modules linked in:
CPU: 0    Not tainted  (2.6.34-rc5 #19)
PC is at __bug+0x20/0x2c
LR is at release_console_sem+0x1b8/0x1ec
pc : [<c003a1ac>]    lr : [<c004760c>]    psr: 60000013
sp : c7d5fe60  ip : c7d5fd98  fp : c7d5fe6c
r10: 00000003  r9 : 00000000  r8 : c7d5feb4
r7 : 00000003  r6 : c7d5feb4  r5 : c7819878  r4 : c7819870
r3 : 00000000  r2 : 60000013  r1 : 000019c2  r0 : 0000002f
Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: c000717f  Table: c7db0000  DAC: 00000015
Process umount (pid: 307, stack limit = 0xc7d5e260)
Stack: (0xc7d5fe60 to 0xc7d60000)
fe60: c7d5fe7c c7d5fe70 c00fb2f0 c003a19c c7d5fe90 c7d5fe80 c00ad358 c00fb274
fe80: c7819870 c7d5feb0 c7d5fe94 c00ad3e4 c00ad2bc c7d46a64 c7d46a54 c7819880
fea0: c7d46a64 c7d5fee4 c7d5feb4 c00ad5a8 c00ad3d0 c7d5feb4 c7d5feb4 c7d46a00
fec0: c7d5e000 c022a324 00000000 c7d5ff54 c7d2b880 00000000 c7d5ff00 c7d5fee8
fee0: c009c8ec c00ad4c0 c7d46a00 c7c14000 c7d2b880 c7d5ff1c c7d5ff04 c00feb38
ff00: c009c84c c7d46a00 c02b7b84 c7d2b880 c7d5ff34 c7d5ff20 c009c740 c00feb00
ff20: c7d2b880 c7d46a00 c7d5ff4c c7d5ff38 c00b0bd0 c009c708 00000000 c7d2b898
ff40: c7d5ff94 c7d5ff50 c00b1e90 c00b0b7c 00000000 c7d5ff54 c7d5ff54 c7d5ff5c
ff60: c7d5ff5c c7d2b880 c7817500 be8e3e0c 00000000 be8e5fb4 00000016 c00370a4
ff80: c7d5e000 be8e5eec c7d5ffa4 c7d5ff98 c00b2164 c00b1e34 00000000 c7d5ffa8
ffa0: c0036f00 c00b2160 be8e3e0c 00000000 be8e5fb4 be8e3e0c be8e3e1a 00000000
ffc0: be8e3e0c 00000000 be8e5fb4 00000000 00000000 00000000 be8e5eec 00000000
ffe0: 40099450 be8e3de4 0006779c 40099458 20000010 be8e5fb4 e0830007 e0833006
Backtrace:
[<c003a18c>] (__bug+0x0/0x2c) from [<c00fb2f0>] (logfs_clear_inode+0x8c/0xb0)
[<c00fb264>] (logfs_clear_inode+0x0/0xb0) from [<c00ad358>]
(clear_inode+0xac/0x114)
[<c00ad2ac>] (clear_inode+0x0/0x114) from [<c00ad3e4>] (dispose_list+0x24/0xf0)
 r4:c7819870
[<c00ad3c0>] (dispose_list+0x0/0xf0) from [<c00ad5a8>]
(invalidate_inodes+0xf8/0x12c)
 r7:c7d46a64 r6:c7819880 r5:c7d46a54 r4:c7d46a64
[<c00ad4b0>] (invalidate_inodes+0x0/0x12c) from [<c009c8ec>]
(generic_shutdown_super+0xb0/0x11c)
[<c009c83c>] (generic_shutdown_super+0x0/0x11c) from [<c00feb38>]
(logfs_kill_sb+0x48/0xfc)
 r6:c7d2b880 r5:c7c14000 r4:c7d46a00
[<c00feaf0>] (logfs_kill_sb+0x0/0xfc) from [<c009c740>]
(deactivate_super+0x48/0x60)
 r6:c7d2b880 r5:c02b7b84 r4:c7d46a00
[<c009c6f8>] (deactivate_super+0x0/0x60) from [<c00b0bd0>]
(mntput_no_expire+0x64/0xbc)
 r5:c7d46a00 r4:c7d2b880
[<c00b0b6c>] (mntput_no_expire+0x0/0xbc) from [<c00b1e90>]
(sys_umount+0x6c/0x32c)
 r5:c7d2b898 r4:00000000
[<c00b1e24>] (sys_umount+0x0/0x32c) from [<c00b2164>] (sys_oldumount+0x14/0x18)
[<c00b2150>] (sys_oldumount+0x0/0x18) from [<c0036f00>]
(ret_fast_syscall+0x0/0x2c)
Code: e1a01000 e59f000c eb003605 e3a03000 (e5833000)
---[ end trace 979e02c61e928049 ]---
------------[ cut here ]------------
WARNING: at kernel/exit.c:907 do_exit+0x50c/0x628()
Modules linked in:
Backtrace:
[<c003a3dc>] (dump_backtrace+0x0/0x12c) from [<c003a520>] (dump_stack+0x18/0x1c)
 r7:00000000 r6:c00493a4 r5:c02794cc r4:0000038b
[<c003a508>] (dump_stack+0x0/0x1c) from [<c0046a38>]
(warn_slowpath_common+0x4c/0x64)
[<c00469ec>] (warn_slowpath_common+0x0/0x64) from [<c0046a68>]
(warn_slowpath_null+0x18/0x1c)
 r7:c7d5fcdf r6:c7c8cc00 r5:00000000 r4:0000000b
[<c0046a50>] (warn_slowpath_null+0x0/0x1c) from [<c00493a4>]
(do_exit+0x50c/0x628)
[<c0048e98>] (do_exit+0x0/0x628) from [<c003a7bc>] (die+0x27c/0x2b4)
[<c003a540>] (die+0x0/0x2b4) from [<c003be7c>] (__do_kernel_fault+0x6c/0x8c)
[<c003be10>] (__do_kernel_fault+0x0/0x8c) from [<c003c108>]
(do_page_fault+0x198/0x1d8)
 r8:00000000 r7:00010000 r6:c7d341b4 r5:c7d34180 r4:c7d33d74
[<c003bf70>] (do_page_fault+0x0/0x1d8) from [<c0036210>]
(do_DataAbort+0x40/0xa8)
[<c00361d0>] (do_DataAbort+0x0/0xa8) from [<c0036a80>] (__dabt_svc+0x40/0x60)
Exception stack(0xc7d5fe18 to 0xc7d5fe60)
fe00:                                                       0000002f 000019c2
fe20: 60000013 00000000 c7819870 c7819878 c7d5feb4 00000003 c7d5feb4 00000000
fe40: 00000003 c7d5fe6c c7d5fd98 c7d5fe60 c004760c c003a1ac 60000013 ffffffff
 r8:c7d5feb4 r7:00000003 r6:c7d5feb4 r5:c7d5fe4c r4:ffffffff
[<c003a18c>] (__bug+0x0/0x2c) from [<c00fb2f0>] (logfs_clear_inode+0x8c/0xb0)
[<c00fb264>] (logfs_clear_inode+0x0/0xb0) from [<c00ad358>]
(clear_inode+0xac/0x114)
[<c00ad2ac>] (clear_inode+0x0/0x114) from [<c00ad3e4>] (dispose_list+0x24/0xf0)
 r4:c7819870
[<c00ad3c0>] (dispose_list+0x0/0xf0) from [<c00ad5a8>]
(invalidate_inodes+0xf8/0x12c)
 r7:c7d46a64 r6:c7819880 r5:c7d46a54 r4:c7d46a64
[<c00ad4b0>] (invalidate_inodes+0x0/0x12c) from [<c009c8ec>]
(generic_shutdown_super+0xb0/0x11c)
[<c009c83c>] (generic_shutdown_super+0x0/0x11c) from [<c00feb38>]
(logfs_kill_sb+0x48/0xfc)
 r6:c7d2b880 r5:c7c14000 r4:c7d46a00
[<c00feaf0>] (logfs_kill_sb+0x0/0xfc) from [<c009c740>]
(deactivate_super+0x48/0x60)
 r6:c7d2b880 r5:c02b7b84 r4:c7d46a00
[<c009c6f8>] (deactivate_super+0x0/0x60) from [<c00b0bd0>]
(mntput_no_expire+0x64/0xbc)
 r5:c7d46a00 r4:c7d2b880
[<c00b0b6c>] (mntput_no_expire+0x0/0xbc) from [<c00b1e90>]
(sys_umount+0x6c/0x32c)
 r5:c7d2b898 r4:00000000
[<c00b1e24>] (sys_umount+0x0/0x32c) from [<c00b2164>] (sys_oldumount+0x14/0x18)
[<c00b2150>] (sys_oldumount+0x0/0x18) from [<c0036f00>]
(ret_fast_syscall+0x0/0x2c)
---[ end trace 979e02c61e92804a ]---
Segmentation fault

Today I have to work for money....probably I have no much time to test ....
As soon as I can I'm happy to give my contribute to test.

Paolo
