Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810Ab1HKPgj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 11:36:39 -0400
Received: from gateway.hbm.com ([213.157.30.2]:9489 "EHLO hbmntx5.hbm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751339Ab1HKPgi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 11:36:38 -0400
Thread-Index: AcxYPHRWkaknwXFvTPCTxnb5sGFjtg==
Thread-Topic: [ANNOUNCE] 3.0.1-rt8 - Regression to 3.0-rt7
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4862
Content-class: urn:content-classes:message
Importance: normal
From: "Tim Sander" <tim.sander@hbm.com>
Organization: Hottinger Baldwin Messtechnik
To: "Peter Zijlstra" <peterz@infradead.org>
Subject: Re: [ANNOUNCE] 3.0.1-rt8 - Regression to 3.0-rt7
Date: Thu, 11 Aug 2011 17:36:20 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39; KDE/4.4.5; x86_64; ; )
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        "linux-rt-users" <linux-rt-users@vger.kernel.org>
References: <1312580681.28695.44.camel@twins> <201108091713.19292.tim.sander@hbm.com> <1313059558.23660.73.camel@twins>
In-Reply-To: <1313059558.23660.73.camel@twins>
MIME-Version: 1.0
Content-Type: text/Plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <201108111736.20856.tim.sander@hbm.com>
X-OriginalArrivalTime: 11 Aug 2011 15:36:35.0816 (UTC) FILETIME=[743A4680:01CC583C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter
> > Right, so I wouldn't know where to start looking on this one. That's
> > generic code exploding for some reason. How is that related to RTB and
> > what is RTB to begin with?
Sorry, the question on the end slipped out of my screen and my attention...
It is CONFIG_PREEMPT_RTB=y as you already figured out.

> Ah, ok so clue came late and PREEMPT_RTB is basically a half-way house
> between PREEMPT and PREEMPT_RT (_FULL). It should build and boot but its
> not actually meant to be used by anybody but the foolhardly developer.
No, don't dissmiss this option. I am currently testing this stuff on an 
arm1136jfs with 533Mhz. The CONFIG_PREEMPT_RT _FULL with the softirqs is to
slow on this machine to handle a 9.6khz interrupts. I think mainly because 
of the additional context switch caused by the softirqs.

But going to CONFIG_PREEMPT_RTB we are right on the sweet spot for this 
machine. We observed worst case usermode latencies for 1.2khz and are 
able to handle 9.6khz hardirq with reasonable cpu load. So the 
CONFIG_PREEMPT_RTB is the right option for puny systems like arm1136.

Annotation: i was interrupted while writing this mail, so the below part
is outdated by other mails from you. (https://lkml.org/lkml/2011/8/11/139)

*****************
> Still no clue on how I wrecked things there though, maybe if I wake up
> more..
I just thought that that it might be some changes in 3.0.1 compared to 3.0
but i noticed that the rt8 patch also cleanly applys against 3.0 and i tested this
The butsplat looks very similar to my other bugreports sent today. 


Starting kernel ...

Uncompressing Linux... done, booting the kernel.
drivers/rtc/hctosys.c: unable to open rtc device (rtc0)


FATAL: Could not load /lib/modules/3.0.0-rt8-00001-gd5b0226/modules.dep: No such file or directory
kernel BUG at mm/filemap.c:2043!
Unable to handle kernel NULL pointer dereference at virtual address 00000000
pgd = c7a40000
[00000000] *pgd=87a3e831, *pte=00000000, *ppte=00000000
Internal error: Oops: 817 [#1] PREEMPT
Modules linked in:
CPU: 0    Not tainted  (3.0.0-rt8-00001-gd5b0226 #160)
PC is at __bug+0x24/0x30
LR is at vprintk+0x398/0x404
pc : [<c002cbf0>]    lr : [<c003e2e8>]    psr: 60000013
sp : c7a2dce8  ip : c7a2dc30  fp : c7a2dcf4
r10: c7a62de0  r9 : 00000000  r8 : 00000000
r7 : 00000000  r6 : 00000008  r5 : c04267e0  r4 : c7a2dd78
r3 : 00000000  r2 : 00000002  r1 : 00000000  r0 : 00000027
Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: 00c5387d  Table: 87a40008  DAC: 00000015
Process udevd (pid: 215, stack limit = 0xc7a2c268)
Stack: (0xc7a2dce8 to 0xc7a2e000)
dce0:                   c7a2dd14 c7a2dcf8 c0076ab4 c002cbd8 c7a2dd78 c7a797a0
dd00: 00000008 c0252f00 c7a2dd74 c7a2dd18 c0076c34 c0076a7c 00000008 00000000
dd20: c7a2dd44 c7a2dd40 c7a2c000 00000000 00001000 00000000 00000000 00000000
dd40: c7a2dd74 c04267e0 c0041ccc 00000000 00000000 00000000 c7a62de0 c7a2dd78
dd60: 00000000 00000000 c7a2ddac c7a2dd78 c0076d6c c0076b58 c7a2df10 00000001
dd80: 00000000 00000008 00000000 00000000 00000000 c7a62de0 c7a796f0 00000008
dda0: c7a2de3c c7a2ddb0 c0078f68 c0076d1c 00000000 00000000 c7a2ded0 00000008
ddc0: 00000000 c0035100 c7a2ddec c7a2ddd8 c0035100 c002b620 c7a797a0 c7a2ded0
dde0: c7a2df10 c7a2de98 c008ecf4 c0035050 00000000 00000001 c7a2de24 c7a6ade0
de00: 4007f000 00000000 c7a41000 00000008 c7a08860 00000000 c7a62de0 c7a7970c
de20: 00000000 c7a2de98 c7a2df10 00000001 c7a2de8c c7a2de40 c007902c c0078b0c
de40: c002b614 00000001 91827364 c7a2de4c c7a2de4c c7a2de54 c7a2de54 00000000
de60: c7a2deb4 c7a62de0 c7a2de98 c7a2df70 c7a2df10 fffffdee c7a2c000 00000000
de80: c7a2df3c c7a2de90 c00a184c c0078fc0 00000000 00000000 c014dfec c0035050
dea0: 00000000 00000001 ffffffff c7a62de0 00000000 00000000 00000000 00000000
dec0: c7850c20 c005c3c4 00000000 00000000 00000000 00000000 00000007 4007f000
dee0: 00000008 c7a2dfb0 00000008 becf0378 c7a2dfac c7a2df00 c002420c c002f114
df00: c00242b0 c002f114 c7a2df2c c7a2df18 4007f000 00000008 c7a08898 00000008
df20: c7a62de0 4007f000 c7a2df70 00000008 c7a2df6c c7a2df40 c00a1fa0 c00a17b0
df40: c7a2c000 4007f000 00001000 c7a62de0 4007f000 00000000 00000000 00000008
df60: c7a2dfa4 c7a2df70 c00a2224 c00a1ef0 00000000 00000000 00000022 00000000
df80: ffffffff 00000008 000233d8 4007f000 00000004 c0029c24 00000000 c7a2dfa8
dfa0: c0029aa0 c00a21ec 00000008 000233d8 0000000a 4007f000 00000008 00000000
dfc0: 00000008 000233d8 4007f000 00000004 00000008 00022344 000c42e8 00000001
dfe0: 00000000 becef6e8 40167e0c 401bb21c 60000010 0000000a 00000000 00000000
Backtrace: 
[<c002cbcc>] (__bug+0x0/0x30) from [<c0076ab4>] (iov_iter_copy_from_user_atomic+0x44/0xdc)
[<c0076a70>] (iov_iter_copy_from_user_atomic+0x0/0xdc) from [<c0076c34>] (generic_perform_write+0xe8/0x1c4)
 r7:c0252f00 r6:00000008 r5:c7a797a0 r4:c7a2dd78
[<c0076b4c>] (generic_perform_write+0x0/0x1c4) from [<c0076d6c>] (generic_file_buffered_write+0x5c/0x88)
[<c0076d10>] (generic_file_buffered_write+0x0/0x88) from [<c0078f68>] (__generic_file_aio_write+0x468/0x4b4)
 r8:00000008 r7:c7a796f0 r6:c7a62de0 r5:00000000 r4:00000000
[<c0078b00>] (__generic_file_aio_write+0x0/0x4b4) from [<c007902c>] (generic_file_aio_write+0x78/0xe8)
[<c0078fb4>] (generic_file_aio_write+0x0/0xe8) from [<c00a184c>] (do_sync_write+0xa8/0xe4)
[<c00a17a4>] (do_sync_write+0x0/0xe4) from [<c00a1fa0>] (vfs_write+0xbc/0x148)
 r8:00000008 r7:c7a2df70 r6:4007f000 r5:c7a62de0 r4:00000008
[<c00a1ee4>] (vfs_write+0x0/0x148) from [<c00a2224>] (sys_write+0x44/0x70)
 r8:00000008 r7:00000000 r6:00000000 r5:4007f000 r4:c7a62de0
[<c00a21e0>] (sys_write+0x0/0x70) from [<c0029aa0>] (ret_fast_syscall+0x0/0x30)
 r8:c0029c24 r7:00000004 r6:4007f000 r5:000233d8 r4:00000008
Code: e59f0010 e1a01003 eb0874b7 e3a03000 (e5833000) 
---[ end trace 849a9799d85b8278 ]---
note: udevd[215] exited with preempt_count 1
BUG: scheduling while atomic: udevd/215/0x40000002
Modules linked in:
Backtrace: 
[<c002cdf8>] (dump_backtrace+0x0/0x110) from [<c0249d44>] (dump_stack+0x18/0x1c)
 r6:c7a2c000 r5:c0304b38 r4:00000000 r3:20000113
[<c0249d2c>] (dump_stack+0x0/0x1c) from [<c0035038>] (__schedule_bug+0x58/0x64)
[<c0034fe0>] (__schedule_bug+0x0/0x64) from [<c024a040>] (__schedule+0x60/0x2f0)
 r4:c7850c20 r3:00000000
[<c0249fe0>] (__schedule+0x0/0x2f0) from [<c00357bc>] (__cond_resched+0x24/0x3c)
[<c0035798>] (__cond_resched+0x0/0x3c) from [<c024a374>] (_cond_resched+0x38/0x48)
 r4:c7a2dabc r3:00000001
[<c024a33c>] (_cond_resched+0x0/0x48) from [<c00903a0>] (unmap_page_range+0x1c4/0x1dc)
[<c00901dc>] (unmap_page_range+0x0/0x1dc) from [<c00908a8>] (unmap_vmas+0x80/0xb0)
[<c0090828>] (unmap_vmas+0x0/0xb0) from [<c0094a34>] (exit_mmap+0x12c/0x290)
[<c0094908>] (exit_mmap+0x0/0x290) from [<c003b210>] (mmput+0x3c/0xec)
 r7:c7a08894 r6:00000000 r5:00000000 r4:c7a08860
[<c003b1d4>] (mmput+0x0/0xec) from [<c003f2e8>] (exit_mm+0x150/0x160)
 r5:c7850c20 r4:c7a08860
[<c003f198>] (exit_mm+0x0/0x160) from [<c0040ab8>] (do_exit+0x1f8/0x2d8)
 r7:00000817 r6:00000001 r5:0000000b r4:c7850c20
[<c00408c0>] (do_exit+0x0/0x2d8) from [<c002d348>] (die+0x114/0x128)
[<c002d234>] (die+0x0/0x128) from [<c002f0e8>] (__do_kernel_fault+0x6c/0x8c)
 r7:c7a2dca0 r6:c7a08860 r5:00000817 r4:00000000
[<c002f07c>] (__do_kernel_fault+0x0/0x8c) from [<c002f23c>] (do_page_fault+0x134/0x14c)
 r8:00000000 r7:c03030cc r6:c7850c20 r5:c7a08860 r4:c7a2dca0
r3:c7a2dca0
[<c002f108>] (do_page_fault+0x0/0x14c) from [<c002420c>] (do_DataAbort+0x38/0xa0)
[<c00241d4>] (do_DataAbort+0x0/0xa0) from [<c002960c>] (__dabt_svc+0x4c/0x80)
Exception stack(0xc7a2dca0 to 0xc7a2dce8)
dca0: 00000027 00000000 00000002 00000000 c7a2dd78 c04267e0 00000008 00000000
dcc0: 00000000 00000000 c7a62de0 c7a2dcf4 c7a2dc30 c7a2dce8 c003e2e8 c002cbf0
dce0: 60000013 ffffffff
 r8:00000000 r7:00000000 r6:00000008 r5:c7a2dcd4 r4:ffffffff
[<c002cbcc>] (__bug+0x0/0x30) from [<c0076ab4>] (iov_iter_copy_from_user_atomic+0x44/0xdc)
[<c0076a70>] (iov_iter_copy_from_user_atomic+0x0/0xdc) from [<c0076c34>] (generic_perform_write+0xe8/0x1c4)
 r7:c0252f00 r6:00000008 r5:c7a797a0 r4:c7a2dd78
[<c0076b4c>] (generic_perform_write+0x0/0x1c4) from [<c0076d6c>] (generic_file_buffered_write+0x5c/0x88)
[<c0076d10>] (generic_file_buffered_write+0x0/0x88) from [<c0078f68>] (__generic_file_aio_write+0x468/0x4b4)
 r8:00000008 r7:c7a796f0 r6:c7a62de0 r5:00000000 r4:00000000
[<c0078b00>] (__generic_file_aio_write+0x0/0x4b4) from [<c007902c>] (generic_file_aio_write+0x78/0xe8)
[<c0078fb4>] (generic_file_aio_write+0x0/0xe8) from [<c00a184c>] (do_sync_write+0xa8/0xe4)
[<c00a17a4>] (do_sync_write+0x0/0xe4) from [<c00a1fa0>] (vfs_write+0xbc/0x148)
 r8:00000008 r7:c7a2df70 r6:4007f000 r5:c7a62de0 r4:00000008
[<c00a1ee4>] (vfs_write+0x0/0x148) from [<c00a2224>] (sys_write+0x44/0x70)
 r8:00000008 r7:00000000 r6:00000000 r5:4007f000 r4:c7a62de0
[<c00a21e0>] (sys_write+0x0/0x70) from [<c0029aa0>] (ret_fast_syscall+0x0/0x30)
 r8:c0029c24 r7:00000004 r6:4007f000 r5:000233d8 r4:00000008
BUG: scheduling while atomic: udevd/215/0x40000002
Modules linked in:
Backtrace: 
[<c002cdf8>] (dump_backtrace+0x0/0x110) from [<c0249d44>] (dump_stack+0x18/0x1c)
 r6:c7a2c000 r5:c0304b38 r4:00000000 r3:20000013
[<c0249d2c>] (dump_stack+0x0/0x1c) from [<c0035038>] (__schedule_bug+0x58/0x64)
[<c0034fe0>] (__schedule_bug+0x0/0x64) from [<c024a040>] (__schedule+0x60/0x2f0)
 r4:c7850c20 r3:00000000
[<c0249fe0>] (__schedule+0x0/0x2f0) from [<c00357bc>] (__cond_resched+0x24/0x3c)
[<c0035798>] (__cond_resched+0x0/0x3c) from [<c024a374>] (_cond_resched+0x38/0x48)
 r4:c7818d40 r3:00000001
[<c024a33c>] (_cond_resched+0x0/0x48) from [<c00407b8>] (put_files_struct+0x94/0xec)
[<c0040724>] (put_files_struct+0x0/0xec) from [<c00408bc>] (exit_files+0x58/0x5c)
[<c0040864>] (exit_files+0x0/0x5c) from [<c0040ac8>] (do_exit+0x208/0x2d8)
 r5:0000000b r4:c7850c20
[<c00408c0>] (do_exit+0x0/0x2d8) from [<c002d348>] (die+0x114/0x128)
[<c002d234>] (die+0x0/0x128) from [<c002f0e8>] (__do_kernel_fault+0x6c/0x8c)
 r7:c7a2dca0 r6:c7a08860 r5:00000817 r4:00000000
[<c002f07c>] (__do_kernel_fault+0x0/0x8c) from [<c002f23c>] (do_page_fault+0x134/0x14c)
 r8:00000000 r7:c03030cc r6:c7850c20 r5:c7a08860 r4:c7a2dca0
r3:c7a2dca0
[<c002f108>] (do_page_fault+0x0/0x14c) from [<c002420c>] (do_DataAbort+0x38/0xa0)
[<c00241d4>] (do_DataAbort+0x0/0xa0) from [<c002960c>] (__dabt_svc+0x4c/0x80)
Exception stack(0xc7a2dca0 to 0xc7a2dce8)
dca0: 00000027 00000000 00000002 00000000 c7a2dd78 c04267e0 00000008 00000000
dcc0: 00000000 00000000 c7a62de0 c7a2dcf4 c7a2dc30 c7a2dce8 c003e2e8 c002cbf0
dce0: 60000013 ffffffff
 r8:00000000 r7:00000000 r6:00000008 r5:c7a2dcd4 r4:ffffffff
[<c002cbcc>] (__bug+0x0/0x30) from [<c0076ab4>] (iov_iter_copy_from_user_atomic+0x44/0xdc)
[<c0076a70>] (iov_iter_copy_from_user_atomic+0x0/0xdc) from [<c0076c34>] (generic_perform_write+0xe8/0x1c4)
 r7:c0252f00 r6:00000008 r5:c7a797a0 r4:c7a2dd78
[<c0076b4c>] (generic_perform_write+0x0/0x1c4) from [<c0076d6c>] (generic_file_buffered_write+0x5c/0x88)
[<c0076d10>] (generic_file_buffered_write+0x0/0x88) from [<c0078f68>] (__generic_file_aio_write+0x468/0x4b4)
 r8:00000008 r7:c7a796f0 r6:c7a62de0 r5:00000000 r4:00000000
[<c0078b00>] (__generic_file_aio_write+0x0/0x4b4) from [<c007902c>] (generic_file_aio_write+0x78/0xe8)
[<c0078fb4>] (generic_file_aio_write+0x0/0xe8) from [<c00a184c>] (do_sync_write+0xa8/0xe4)
[<c00a17a4>] (do_sync_write+0x0/0xe4) from [<c00a1fa0>] (vfs_write+0xbc/0x148)
 r8:00000008 r7:c7a2df70 r6:4007f000 r5:c7a62de0 r4:00000008
[<c00a1ee4>] (vfs_write+0x0/0x148) from [<c00a2224>] (sys_write+0x44/0x70)
 r8:00000008 r7:00000000 r6:00000000 r5:4007f000 r4:c7a62de0
[<c00a21e0>] (sys_write+0x0/0x70) from [<c0029aa0>] (ret_fast_syscall+0x0/0x30)
 r8:c0029c24 r7:00000004 r6:4007f000 r5:000233d8 r4:00000008

BUG: scheduling while atomic: udevd/215/0x40000002
Modules linked in:
Backtrace: 
[<c002cdf8>] (dump_backtrace+0x0/0x110) from [<c0249d44>] (dump_stack+0x18/0x1c)
 r6:c7a2c000 r5:c0304b38 r4:00000000 r3:20000113
[<c0249d2c>] (dump_stack+0x0/0x1c) from [<c0035038>] (__schedule_bug+0x58/0x64)
[<c0034fe0>] (__schedule_bug+0x0/0x64) from [<c024a040>] (__schedule+0x60/0x2f0)
 r4:c7850c20 r3:00000000
[<c0249fe0>] (__schedule+0x0/0x2f0) from [<c00357bc>] (__cond_resched+0x24/0x3c)
[<c0035798>] (__cond_resched+0x0/0x3c) from [<c024a374>] (_cond_resched+0x38/0x48)
 r4:c7818d40 r3:00000001
[<c024a33c>] (_cond_resched+0x0/0x48) from [<c00407b8>] (put_files_struct+0x94/0xec)
[<c0040724>] (put_files_struct+0x0/0xec) from [<c00408bc>] (exit_files+0x58/0x5c)
[<c0040864>] (exit_files+0x0/0x5c) from [<c0040ac8>] (do_exit+0x208/0x2d8)
 r5:0000000b r4:c7850c20
[<c00408c0>] (do_exit+0x0/0x2d8) from [<c002d348>] (die+0x114/0x128)
[<c002d234>] (die+0x0/0x128) from [<c002f0e8>] (__do_kernel_fault+0x6c/0x8c)
 r7:c7a2dca0 r6:c7a08860 r5:00000817 r4:00000000
[<c002f07c>] (__do_kernel_fault+0x0/0x8c) from [<c002f23c>] (do_page_fault+0x134/0x14c)
 r8:00000000 r7:c03030cc r6:c7850c20 r5:c7a08860 r4:c7a2dca0
r3:c7a2dca0
[<c002f108>] (do_page_fault+0x0/0x14c) from [<c002420c>] (do_DataAbort+0x38/0xa0)
[<c00241d4>] (do_DataAbort+0x0/0xa0) from [<c002960c>] (__dabt_svc+0x4c/0x80)
Exception stack(0xc7a2dca0 to 0xc7a2dce8)
dca0: 00000027 00000000 00000002 00000000 c7a2dd78 c04267e0 00000008 00000000
dcc0: 00000000 00000000 c7a62de0 c7a2dcf4 c7a2dc30 c7a2dce8 c003e2e8 c002cbf0
dce0: 60000013 ffffffff
 r8:00000000 r7:00000000 r6:00000008 r5:c7a2dcd4 r4:ffffffff
[<c002cbcc>] (__bug+0x0/0x30) from [<c0076ab4>] (iov_iter_copy_from_user_atomic+0x44/0xdc)
[<c0076a70>] (iov_iter_copy_from_user_atomic+0x0/0xdc) from [<c0076c34>] (generic_perform_write+0xe8/0x1c4)
 r7:c0252f00 r6:00000008 r5:c7a797a0 r4:c7a2dd78
[<c0076b4c>] (generic_perform_write+0x0/0x1c4) from [<c0076d6c>] (generic_file_buffered_write+0x5c/0x88)
[<c0076d10>] (generic_file_buffered_write+0x0/0x88) from [<c0078f68>] (__generic_file_aio_write+0x468/0x4b4)
 r8:00000008 r7:c7a796f0 r6:c7a62de0 r5:00000000 r4:00000000
[<c0078b00>] (__generic_file_aio_write+0x0/0x4b4) from [<c007902c>] (generic_file_aio_write+0x78/0xe8)
[<c0078fb4>] (generic_file_aio_write+0x0/0xe8) from [<c00a184c>] (do_sync_write+0xa8/0xe4)
[<c00a17a4>] (do_sync_write+0x0/0xe4) from [<c00a1fa0>] (vfs_write+0xbc/0x148)
 r8:00000008 r7:c7a2df70 r6:4007f000 r5:c7a62de0 r4:00000008
[<c00a1ee4>] (vfs_write+0x0/0x148) from [<c00a2224>] (sys_write+0x44/0x70)
 r8:00000008 r7:00000000 r6:00000000 r5:4007f000 r4:c7a62de0
[<c00a21e0>] (sys_write+0x0/0x70) from [<c0029aa0>] (ret_fast_syscall+0x0/0x30)
 r8:c0029c24 r7:00000004 r6:4007f000 r5:000233d8 r4:00000008
tim login: BUG: scheduling while atomic: udevd/215/0x40000002
Modules linked in:
Backtrace: 
[<c002cdf8>] (dump_backtrace+0x0/0x110) from [<c0249d44>] (dump_stack+0x18/0x1c)
 r6:c7a2c000 r5:c0304b38 r4:00000000 r3:20000013
[<c0249d2c>] (dump_stack+0x0/0x1c) from [<c0035038>] (__schedule_bug+0x58/0x64)
[<c0034fe0>] (__schedule_bug+0x0/0x64) from [<c024a040>] (__schedule+0x60/0x2f0)
 r4:c7850c20 r3:00000000
[<c0249fe0>] (__schedule+0x0/0x2f0) from [<c00357bc>] (__cond_resched+0x24/0x3c)
[<c0035798>] (__cond_resched+0x0/0x3c) from [<c024a374>] (_cond_resched+0x38/0x48)
 r4:c7818d40 r3:00000001
[<c024a33c>] (_cond_resched+0x0/0x48) from [<c00407b8>] (put_files_struct+0x94/0xec)
[<c0040724>] (put_files_struct+0x0/0xec) from [<c00408bc>] (exit_files+0x58/0x5c)
[<c0040864>] (exit_files+0x0/0x5c) from [<c0040ac8>] (do_exit+0x208/0x2d8)
 r5:0000000b r4:c7850c20
[<c00408c0>] (do_exit+0x0/0x2d8) from [<c002d348>] (die+0x114/0x128)
[<c002d234>] (die+0x0/0x128) from [<c002f0e8>] (__do_kernel_fault+0x6c/0x8c)
 r7:c7a2dca0 r6:c7a08860 r5:00000817 r4:00000000
[<c002f07c>] (__do_kernel_fault+0x0/0x8c) from [<c002f23c>] (do_page_fault+0x134/0x14c)
 r8:00000000 r7:c03030cc r6:c7850c20 r5:c7a08860 r4:c7a2dca0
r3:c7a2dca0
[<c002f108>] (do_page_fault+0x0/0x14c) from [<c002420c>] (do_DataAbort+0x38/0xa0)
[<c00241d4>] (do_DataAbort+0x0/0xa0) from [<c002960c>] (__dabt_svc+0x4c/0x80)
Exception stack(0xc7a2dca0 to 0xc7a2dce8)
dca0: 00000027 00000000 00000002 00000000 c7a2dd78 c04267e0 00000008 00000000
dcc0: 00000000 00000000 c7a62de0 c7a2dcf4 c7a2dc30 c7a2dce8 c003e2e8 c002cbf0
dce0: 60000013 ffffffff
 r8:00000000 r7:00000000 r6:00000008 r5:c7a2dcd4 r4:ffffffff
[<c002cbcc>] (__bug+0x0/0x30) from [<c0076ab4>] (iov_iter_copy_from_user_atomic+0x44/0xdc)
[<c0076a70>] (iov_iter_copy_from_user_atomic+0x0/0xdc) from [<c0076c34>] (generic_perform_write+0xe8/0x1c4)
 r7:c0252f00 r6:00000008 r5:c7a797a0 r4:c7a2dd78
[<c0076b4c>] (generic_perform_write+0x0/0x1c4) from [<c0076d6c>] (generic_file_buffered_write+0x5c/0x88)
[<c0076d10>] (generic_file_buffered_write+0x0/0x88) from [<c0078f68>] (__generic_file_aio_write+0x468/0x4b4)
 r8:00000008 r7:c7a796f0 r6:c7a62de0 r5:00000000 r4:00000000
[<c0078b00>] (__generic_file_aio_write+0x0/0x4b4) from [<c007902c>] (generic_file_aio_write+0x78/0xe8)
[<c0078fb4>] (generic_file_aio_write+0x0/0xe8) from [<c00a184c>] (do_sync_write+0xa8/0xe4)
[<c00a17a4>] (do_sync_write+0x0/0xe4) from [<c00a1fa0>] (vfs_write+0xbc/0x148)
 r8:00000008 r7:c7a2df70 r6:4007f000 r5:c7a62de0 r4:00000008
[<c00a1ee4>] (vfs_write+0x0/0x148) from [<c00a2224>] (sys_write+0x44/0x70)
 r8:00000008 r7:00000000 r6:00000000 r5:4007f000 r4:c7a62de0
[<c00a21e0>] (sys_write+0x0/0x70) from [<c0029aa0>] (ret_fast_syscall+0x0/0x30)
 r8:c0029c24 r7:00000004 r6:4007f000 r5:000233d8 r4:00000008
kernel BUG at mm/filemap.c:2043!
Unable to handle kernel NULL pointer dereference at virtual address 00000000
pgd = c7a84000
[00000000] *pgd=87a6c831, *pte=00000000, *ppte=00000000
Internal error: Oops: 817 [#2] PREEMPT
Modules linked in:
CPU: 0    Tainted: G      D      (3.0.0-rt8-00001-gd5b0226 #160)
PC is at __bug+0x24/0x30
LR is at vprintk+0x3b4/0x404
pc : [<c002cbf0>]    lr : [<c003e304>]    psr: 20000013
sp : c7a2bce8  ip : c7a2bc30  fp : c7a2bcf4
r10: c7a62960  r9 : 00000000  r8 : 00000000
r7 : 00000000  r6 : 00000041  r5 : c0426da0  r4 : c7a2bd78
r3 : 00000000  r2 : 00000002  r1 : 00000001  r0 : 00000027
Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: 00c5387d  Table: 87a84008  DAC: 00000015
Process syslogd (pid: 226, stack limit = 0xc7a2a268)
Stack: (0xc7a2bce8 to 0xc7a2c000)
bce0:                   c7a2bd14 c7a2bcf8 c0076ab4 c002cbd8 c7a2bd78 c7a79490
bd00: 00000041 c0252f00 c7a2bd74 c7a2bd18 c0076c34 c0076a7c 00000041 00000000
bd20: c7a2bd44 c7a2bd40 c7a2a000 00000000 00001000 00000000 00000000 00000000
bd40: c7a2bd74 c0426da0 c0041ccc 00000000 00000000 00000000 c7a62960 c7a2bd78
bd60: 00000000 00000000 c7a2bdac c7a2bd78 c0076d6c c0076b58 c7a2bf10 00000001
bd80: 00000000 00000041 00000000 00000000 00000000 c7a62960 c7a793e0 00000041
bda0: c7a2be3c c7a2bdb0 c0078f68 c0076d1c 00000000 00000000 c7a2bed0 00000041
bdc0: 00000000 c0057490 ffffffff c7a2a000 c7a2be2c c7a2bde0 c7a79490 c7a2bed0
bde0: c7a2bf10 c7a2be98 00000000 4017c000 00000000 00000001 4017c000 c0427180
be00: c7a2be2c c7a39860 000000b7 00000041 c7a85000 00000000 c7a62960 c7a793fc
be20: 00000000 c7a2be98 c7a2bf10 00000001 c7a2be8c c7a2be40 c007902c c0078b0c
be40: c002cbb0 c002b5f0 91827364 c7a2be4c c7a2be4c c7a2be54 c7a2be54 00000000
be60: c002b650 c7a62960 c7a2be98 c7a2bf70 c7a2bf10 fffffdee c7a2a000 00000000
be80: c7a2bf3c c7a2be90 c00a184c c0078fc0 00000000 00000000 c7a2bebc c7a2bea8
bea0: 00000000 00000001 ffffffff c7a62960 00000000 00000000 00000000 00000000
bec0: c78673e0 c7a2bed0 00000000 00000000 00000000 00000000 00000000 00000007
bee0: 00000041 4017c200 00000041 00000041 00000000 0006c6f0 c7a2bfac c7a2bf08
bf00: c00242b0 c002f114 00000005 01312d03 0006c458 00000041 00000079 00000041
bf20: c7a62960 0006c458 c7a2bf70 00000041 c7a2bf6c c7a2bf40 c00a1fa0 c00a17b0
bf40: 00000079 00000000 00000010 c7a62960 0006c458 00000000 00000000 00000041
bf60: c7a2bfa4 c7a2bf70 c00a2224 c00a1ef0 00000000 00000000 00000005 00000000
bf80: 00001000 0006b89c 00000041 0006c458 00000004 c0029c24 00000000 c7a2bfa8
bfa0: c0029aa0 c00a21ec 0006b89c 00000041 00000004 0006c458 00000041 00032000
bfc0: 0006b89c 00000041 0006c458 00000004 00000041 00000000 0006c6f0 bee4cbdc
bfe0: 00000004 bee4cb30 0000faa4 4017c21c 60000010 00000004 c4dc657c c6c88810
Backtrace: 
[<c002cbcc>] (__bug+0x0/0x30) from [<c0076ab4>] (iov_iter_copy_from_user_atomic+0x44/0xdc)
[<c0076a70>] (iov_iter_copy_from_user_atomic+0x0/0xdc) from [<c0076c34>] (generic_perform_write+0xe8/0x1c4)
 r7:c0252f00 r6:00000041 r5:c7a79490 r4:c7a2bd78
[<c0076b4c>] (generic_perform_write+0x0/0x1c4) from [<c0076d6c>] (generic_file_buffered_write+0x5c/0x88)
[<c0076d10>] (generic_file_buffered_write+0x0/0x88) from [<c0078f68>] (__generic_file_aio_write+0x468/0x4b4)
 r8:00000041 r7:c7a793e0 r6:c7a62960 r5:00000000 r4:00000000
[<c0078b00>] (__generic_file_aio_write+0x0/0x4b4) from [<c007902c>] (generic_file_aio_write+0x78/0xe8)
[<c0078fb4>] (generic_file_aio_write+0x0/0xe8) from [<c00a184c>] (do_sync_write+0xa8/0xe4)
[<c00a17a4>] (do_sync_write+0x0/0xe4) from [<c00a1fa0>] (vfs_write+0xbc/0x148)
 r8:00000041 r7:c7a2bf70 r6:0006c458 r5:c7a62960 r4:00000041
[<c00a1ee4>] (vfs_write+0x0/0x148) from [<c00a2224>] (sys_write+0x44/0x70)
 r8:00000041 r7:00000000 r6:00000000 r5:0006c458 r4:c7a62960
[<c00a21e0>] (sys_write+0x0/0x70) from [<c0029aa0>] (ret_fast_syscall+0x0/0x30)
 r8:c0029c24 r7:00000004 r6:0006c458 r5:00000041 r4:0006b89c
Code: e59f0010 e1a01003 eb0874b7 e3a03000 (e5833000) 
---[ end trace 849a9799d85b8279 ]---
note: syslogd[226] exited with preempt_count 1
BUG: scheduling while atomic: syslogd/226/0x40000002
Modules linked in:
Backtrace: 
[<c002cdf8>] (dump_backtrace+0x0/0x110) from [<c0249d44>] (dump_stack+0x18/0x1c)
 r6:c7a2a000 r5:c0304b38 r4:00000000 r3:20000113
[<c0249d2c>] (dump_stack+0x0/0x1c) from [<c0035038>] (__schedule_bug+0x58/0x64)
[<c0034fe0>] (__schedule_bug+0x0/0x64) from [<c024a040>] (__schedule+0x60/0x2f0)
 r4:c78673e0 r3:00000000
[<c0249fe0>] (__schedule+0x0/0x2f0) from [<c00357bc>] (__cond_resched+0x24/0x3c)
[<c0035798>] (__cond_resched+0x0/0x3c) from [<c024a374>] (_cond_resched+0x38/0x48)
 r4:c7a2babc r3:00000001
[<c024a33c>] (_cond_resched+0x0/0x48) from [<c00903a0>] (unmap_page_range+0x1c4/0x1dc)
[<c00901dc>] (unmap_page_range+0x0/0x1dc) from [<c00908a8>] (unmap_vmas+0x80/0xb0)
[<c0090828>] (unmap_vmas+0x0/0xb0) from [<c0094a34>] (exit_mmap+0x12c/0x290)
[<c0094908>] (exit_mmap+0x0/0x290) from [<c003b210>] (mmput+0x3c/0xec)
 r7:c7a08bd4 r6:00000000 r5:00000000 r4:c7a08ba0
[<c003b1d4>] (mmput+0x0/0xec) from [<c003f2e8>] (exit_mm+0x150/0x160)
 r5:c78673e0 r4:c7a08ba0
[<c003f198>] (exit_mm+0x0/0x160) from [<c0040ab8>] (do_exit+0x1f8/0x2d8)
 r7:00000817 r6:00000001 r5:0000000b r4:c78673e0
[<c00408c0>] (do_exit+0x0/0x2d8) from [<c002d348>] (die+0x114/0x128)
[<c002d234>] (die+0x0/0x128) from [<c002f0e8>] (__do_kernel_fault+0x6c/0x8c)
 r7:c7a2bca0 r6:c7a08ba0 r5:00000817 r4:00000000
[<c002f07c>] (__do_kernel_fault+0x0/0x8c) from [<c002f23c>] (do_page_fault+0x134/0x14c)
 r8:00000000 r7:c03030cc r6:c78673e0 r5:c7a08ba0 r4:c7a2bca0
r3:c7a2bca0
[<c002f108>] (do_page_fault+0x0/0x14c) from [<c002420c>] (do_DataAbort+0x38/0xa0)
[<c00241d4>] (do_DataAbort+0x0/0xa0) from [<c002960c>] (__dabt_svc+0x4c/0x80)
Exception stack(0xc7a2bca0 to 0xc7a2bce8)
bca0: 00000027 00000001 00000002 00000000 c7a2bd78 c0426da0 00000041 00000000
bcc0: 00000000 00000000 c7a62960 c7a2bcf4 c7a2bc30 c7a2bce8 c003e304 c002cbf0
bce0: 20000013 ffffffff
 r8:00000000 r7:00000000 r6:00000041 r5:c7a2bcd4 r4:ffffffff
[<c002cbcc>] (__bug+0x0/0x30) from [<c0076ab4>] (iov_iter_copy_from_user_atomic+0x44/0xdc)
[<c0076a70>] (iov_iter_copy_from_user_atomic+0x0/0xdc) from [<c0076c34>] (generic_perform_write+0xe8/0x1c4)
 r7:c0252f00 r6:00000041 r5:c7a79490 r4:c7a2bd78
[<c0076b4c>] (generic_perform_write+0x0/0x1c4) from [<c0076d6c>] (generic_file_buffered_write+0x5c/0x88)
[<c0076d10>] (generic_file_buffered_write+0x0/0x88) from [<c0078f68>] (__generic_file_aio_write+0x468/0x4b4)
 r8:00000041 r7:c7a793e0 r6:c7a62960 r5:00000000 r4:00000000
[<c0078b00>] (__generic_file_aio_write+0x0/0x4b4) from [<c007902c>] (generic_file_aio_write+0x78/0xe8)
[<c0078fb4>] (generic_file_aio_write+0x0/0xe8) from [<c00a184c>] (do_sync_write+0xa8/0xe4)
[<c00a17a4>] (do_sync_write+0x0/0xe4) from [<c00a1fa0>] (vfs_write+0xbc/0x148)
 r8:00000041 r7:c7a2bf70 r6:0006c458 r5:c7a62960 r4:00000041
[<c00a1ee4>] (vfs_write+0x0/0x148) from [<c00a2224>] (sys_write+0x44/0x70)
 r8:00000041 r7:00000000 r6:00000000 r5:0006c458 r4:c7a62960
[<c00a21e0>] (sys_write+0x0/0x70) from [<c0029aa0>] (ret_fast_syscall+0x0/0x30)
 r8:c0029c24 r7:00000004 r6:0006c458 r5:00000041 r4:0006b89c
kernel BUG at mm/filemap.c:2043!
Unable to handle kernel NULL pointer dereference at virtual address 00000000
pgd = c7a70000
[00000000] *pgd=87a27831, *pte=00000000, *ppte=00000000
Internal error: Oops: 817 [#3] PREEMPT
Modules linked in:
CPU: 0    Tainted: G      D      (3.0.0-rt8-00001-gd5b0226 #160)
PC is at __bug+0x24/0x30
LR is at vprintk+0x398/0x404
pc : [<c002cbf0>]    lr : [<c003e2e8>]    psr: 60000013
sp : c7a77ce8  ip : c7a77c30  fp : c7a77cf4
r10: c7a97ca0  r9 : 00000000  r8 : 00000000
r7 : 00000000  r6 : 00000006  r5 : c0426d60  r4 : c7a77d78
r3 : 00000000  r2 : 00000002  r1 : 00000002  r0 : 00000027
Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: 00c5387d  Table: 87a70008  DAC: 00000015
Process ifup (pid: 222, stack limit = 0xc7a76268)
Stack: (0xc7a77ce8 to 0xc7a78000)
7ce0:                   c7a77d14 c7a77cf8 c0076ab4 c002cbd8 c7a77d78 c7a79308
7d00: 00000006 c0252f00 c7a77d74 c7a77d18 c0076c34 c0076a7c 00000006 00000000
7d20: c7a77d44 c7a77d40 c7a76000 00000000 00001000 00000000 00000000 00000000
7d40: c7a77d74 c0426d60 c0041ccc 00000000 00000000 00000000 c7a97ca0 c7a77d78
7d60: 00000000 00000000 c7a77dac c7a77d78 c0076d6c c0076b58 c7a77f10 00000001
7d80: 00000000 00000006 00000000 00000000 00000000 c7a97ca0 c7a79258 00000006
7da0: c7a77e3c c7a77db0 c0078f68 c0076d1c 00000000 00000000 c7a77ed0 00000006
7dc0: 00000000 c0035100 c7a77dec c7a77dd8 c0035100 c002b620 c7a79308 c7a77ed0
7de0: c7a77f10 c7a77e98 c008ecf4 c0035050 00000000 00000001 c7a77e24 c7a39650
7e00: 40092000 00000000 c7a71000 00000006 c7a081e0 00000000 c7a97ca0 c7a79274
7e20: 00000000 c7a77e98 c7a77f10 00000001 c7a77e8c c7a77e40 c007902c c0078b0c
7e40: c002b614 00000001 91827364 c7a77e4c c7a77e4c c7a77e54 c7a77e54 00000000
7e60: c7a77eb4 c7a97ca0 c7a77e98 c7a77f70 c7a77f10 fffffdee c7a76000 00000000
7e80: c7a77f3c c7a77e90 c00a184c c0078fc0 00000000 00000000 c014dfec c0035050
7ea0: 00000000 00000001 ffffffff c7a97ca0 00000000 00000000 00000000 00000000
7ec0: c7899720 c005c3c4 00000000 00000000 00000000 00000000 00000007 40092000
7ee0: 00000006 c7a77fb0 00000006 0006c0d8 c7a77fac c7a77f00 c002420c c002f114
7f00: c00242b0 c002f114 c7a77f2c c7a77f18 40092000 00000006 c7a08218 00000006
7f20: c7a97ca0 40092000 c7a77f70 00000006 c7a77f6c c7a77f40 c00a1fa0 c00a17b0
7f40: c7a76000 40092000 00001000 c7a97ca0 40092000 00000000 00000000 00000006
7f60: c7a77fa4 c7a77f70 c00a2224 c00a1ef0 00000000 00000000 00000022 00000000
7f80: ffffffff 00000006 0006c4c8 40092000 00000004 c0029c24 00000000 c7a77fa8
7fa0: c0029aa0 c00a21ec 00000006 0006c4c8 00000003 40092000 00000006 00000000
7fc0: 00000006 0006c4c8 40092000 00000004 00000006 00000000 000c42e8 00000001
7fe0: 00000000 bebf9c10 40194e0c 401e821c 60000010 00000003 87ffe821 87ffec21
Backtrace: 
[<c002cbcc>] (__bug+0x0/0x30) from [<c0076ab4>] (iov_iter_copy_from_user_atomic+0x44/0xdc)
[<c0076a70>] (iov_iter_copy_from_user_atomic+0x0/0xdc) from [<c0076c34>] (generic_perform_write+0xe8/0x1c4)
 r7:c0252f00 r6:00000006 r5:c7a79308 r4:c7a77d78
[<c0076b4c>] (generic_perform_write+0x0/0x1c4) from [<c0076d6c>] (generic_file_buffered_write+0x5c/0x88)
[<c0076d10>] (generic_file_buffered_write+0x0/0x88) from [<c0078f68>] (__generic_file_aio_write+0x468/0x4b4)
 r8:00000006 r7:c7a79258 r6:c7a97ca0 r5:00000000 r4:00000000
[<c0078b00>] (__generic_file_aio_write+0x0/0x4b4) from [<c007902c>] (generic_file_aio_write+0x78/0xe8)
[<c0078fb4>] (generic_file_aio_write+0x0/0xe8) from [<c00a184c>] (do_sync_write+0xa8/0xe4)
[<c00a17a4>] (do_sync_write+0x0/0xe4) from [<c00a1fa0>] (vfs_write+0xbc/0x148)
 r8:00000006 r7:c7a77f70 r6:40092000 r5:c7a97ca0 r4:00000006
[<c00a1ee4>] (vfs_write+0x0/0x148) from [<c00a2224>] (sys_write+0x44/0x70)
 r8:00000006 r7:00000000 r6:00000000 r5:40092000 r4:c7a97ca0
[<c00a21e0>] (sys_write+0x0/0x70) from [<c0029aa0>] (ret_fast_syscall+0x0/0x30)
 r8:c0029c24 r7:00000004 r6:40092000 r5:0006c4c8 r4:00000006
Code: e59f0010 e1a01003 eb0874b7 e3a03000 (e5833000) 
---[ end trace 849a9799d85b827a ]---
note: ifup[222] exited with preempt_count 1
BUG: scheduling while atomic: ifup/222/0x40000002
Modules linked in:
Backtrace: 
[<c002cdf8>] (dump_backtrace+0x0/0x110) from [<c0249d44>] (dump_stack+0x18/0x1c)
 r6:c7a76000 r5:c0304b38 r4:00000000 r3:20000113
[<c0249d2c>] (dump_stack+0x0/0x1c) from [<c0035038>] (__schedule_bug+0x58/0x64)
[<c0034fe0>] (__schedule_bug+0x0/0x64) from [<c024a040>] (__schedule+0x60/0x2f0)
 r4:c7899720 r3:00000000
[<c0249fe0>] (__schedule+0x0/0x2f0) from [<c00357bc>] (__cond_resched+0x24/0x3c)
[<c0035798>] (__cond_resched+0x0/0x3c) from [<c024a374>] (_cond_resched+0x38/0x48)
 r4:c7a77abc r3:00000001
[<c024a33c>] (_cond_resched+0x0/0x48) from [<c00903a0>] (unmap_page_range+0x1c4/0x1dc)
[<c00901dc>] (unmap_page_range+0x0/0x1dc) from [<c00908a8>] (unmap_vmas+0x80/0xb0)
[<c0090828>] (unmap_vmas+0x0/0xb0) from [<c0094a34>] (exit_mmap+0x12c/0x290)
[<c0094908>] (exit_mmap+0x0/0x290) from [<c003b210>] (mmput+0x3c/0xec)
 r7:c7a08214 r6:00000000 r5:00000000 r4:c7a081e0
[<c003b1d4>] (mmput+0x0/0xec) from [<c003f2e8>] (exit_mm+0x150/0x160)
 r5:c7899720 r4:c7a081e0
[<c003f198>] (exit_mm+0x0/0x160) from [<c0040ab8>] (do_exit+0x1f8/0x2d8)
 r7:00000817 r6:00000001 r5:0000000b r4:c7899720
[<c00408c0>] (do_exit+0x0/0x2d8) from [<c002d348>] (die+0x114/0x128)
[<c002d234>] (die+0x0/0x128) from [<c002f0e8>] (__do_kernel_fault+0x6c/0x8c)
 r7:c7a77ca0 r6:c7a081e0 r5:00000817 r4:00000000
[<c002f07c>] (__do_kernel_fault+0x0/0x8c) from [<c002f23c>] (do_page_fault+0x134/0x14c)
 r8:00000000 r7:c03030cc r6:c7899720 r5:c7a081e0 r4:c7a77ca0
r3:c7a77ca0
[<c002f108>] (do_page_fault+0x0/0x14c) from [<c002420c>] (do_DataAbort+0x38/0xa0)
[<c00241d4>] (do_DataAbort+0x0/0xa0) from [<c002960c>] (__dabt_svc+0x4c/0x80)
Exception stack(0xc7a77ca0 to 0xc7a77ce8)
7ca0: 00000027 00000002 00000002 00000000 c7a77d78 c0426d60 00000006 00000000
7cc0: 00000000 00000000 c7a97ca0 c7a77cf4 c7a77c30 c7a77ce8 c003e2e8 c002cbf0
7ce0: 60000013 ffffffff
 r8:00000000 r7:00000000 r6:00000006 r5:c7a77cd4 r4:ffffffff
[<c002cbcc>] (__bug+0x0/0x30) from [<c0076ab4>] (iov_iter_copy_from_user_atomic+0x44/0xdc)
[<c0076a70>] (iov_iter_copy_from_user_atomic+0x0/0xdc) from [<c0076c34>] (generic_perform_write+0xe8/0x1c4)
 r7:c0252f00 r6:00000006 r5:c7a79308 r4:c7a77d78
[<c0076b4c>] (generic_perform_write+0x0/0x1c4) from [<c0076d6c>] (generic_file_buffered_write+0x5c/0x88)
[<c0076d10>] (generic_file_buffered_write+0x0/0x88) from [<c0078f68>] (__generic_file_aio_write+0x468/0x4b4)
 r8:00000006 r7:c7a79258 r6:c7a97ca0 r5:00000000 r4:00000000
[<c0078b00>] (__generic_file_aio_write+0x0/0x4b4) from [<c007902c>] (generic_file_aio_write+0x78/0xe8)
[<c0078fb4>] (generic_file_aio_write+0x0/0xe8) from [<c00a184c>] (do_sync_write+0xa8/0xe4)
[<c00a17a4>] (do_sync_write+0x0/0xe4) from [<c00a1fa0>] (vfs_write+0xbc/0x148)
 r8:00000006 r7:c7a77f70 r6:40092000 r5:c7a97ca0 r4:00000006
[<c00a1ee4>] (vfs_write+0x0/0x148) from [<c00a2224>] (sys_write+0x44/0x70)
 r8:00000006 r7:00000000 r6:00000000 r5:40092000 r4:c7a97ca0
[<c00a21e0>] (sys_write+0x0/0x70) from [<c0029aa0>] (ret_fast_syscall+0x0/0x30)
 r8:c0029c24 r7:00000004 r6:40092000 r5:0006c4c8 r4:00000006
BUG: scheduling while atomic: udevd/215/0x40000002
Modules linked in:
Backtrace: 
[<c002cdf8>] (dump_backtrace+0x0/0x110) from [<c0249d44>] (dump_stack+0x18/0x1c)
 r6:c7a2c000 r5:c0304b38 r4:00000000 r3:20000113
[<c0249d2c>] (dump_stack+0x0/0x1c) from [<c0035038>] (__schedule_bug+0x58/0x64)
[<c0034fe0>] (__schedule_bug+0x0/0x64) from [<c024a040>] (__schedule+0x60/0x2f0)
 r4:c7850c20 r3:00000000
[<c0249fe0>] (__schedule+0x0/0x2f0) from [<c00357bc>] (__cond_resched+0x24/0x3c)
[<c0035798>] (__cond_resched+0x0/0x3c) from [<c024a374>] (_cond_resched+0x38/0x48)
 r4:c7818d40 r3:00000001
[<c024a33c>] (_cond_resched+0x0/0x48) from [<c00407b8>] (put_files_struct+0x94/0xec)
[<c0040724>] (put_files_struct+0x0/0xec) from [<c00408bc>] (exit_files+0x58/0x5c)
[<c0040864>] (exit_files+0x0/0x5c) from [<c0040ac8>] (do_exit+0x208/0x2d8)
 r5:0000000b r4:c7850c20
[<c00408c0>] (do_exit+0x0/0x2d8) from [<c002d348>] (die+0x114/0x128)
[<c002d234>] (die+0x0/0x128) from [<c002f0e8>] (__do_kernel_fault+0x6c/0x8c)
 r7:c7a2dca0 r6:c7a08860 r5:00000817 r4:00000000
[<c002f07c>] (__do_kernel_fault+0x0/0x8c) from [<c002f23c>] (do_page_fault+0x134/0x14c)
 r8:00000000 r7:c03030cc r6:c7850c20 r5:c7a08860 r4:c7a2dca0
r3:c7a2dca0
[<c002f108>] (do_page_fault+0x0/0x14c) from [<c002420c>] (do_DataAbort+0x38/0xa0)
[<c00241d4>] (do_DataAbort+0x0/0xa0) from [<c002960c>] (__dabt_svc+0x4c/0x80)
Exception stack(0xc7a2dca0 to 0xc7a2dce8)
dca0: 00000027 00000000 00000002 00000000 c7a2dd78 c04267e0 00000008 00000000
dcc0: 00000000 00000000 c7a62de0 c7a2dcf4 c7a2dc30 c7a2dce8 c003e2e8 c002cbf0
dce0: 60000013 ffffffff
 r8:00000000 r7:00000000 r6:00000008 r5:c7a2dcd4 r4:ffffffff
[<c002cbcc>] (__bug+0x0/0x30) from [<c0076ab4>] (iov_iter_copy_from_user_atomic+0x44/0xdc)
[<c0076a70>] (iov_iter_copy_from_user_atomic+0x0/0xdc) from [<c0076c34>] (generic_perform_write+0xe8/0x1c4)
 r7:c0252f00 r6:00000008 r5:c7a797a0 r4:c7a2dd78
[<c0076b4c>] (generic_perform_write+0x0/0x1c4) from [<c0076d6c>] (generic_file_buffered_write+0x5c/0x88)
[<c0076d10>] (generic_file_buffered_write+0x0/0x88) from [<c0078f68>] (__generic_file_aio_write+0x468/0x4b4)
 r8:00000008 r7:c7a796f0 r6:c7a62de0 r5:00000000 r4:00000000
[<c0078b00>] (__generic_file_aio_write+0x0/0x4b4) from [<c007902c>] (generic_file_aio_write+0x78/0xe8)
[<c0078fb4>] (generic_file_aio_write+0x0/0xe8) from [<c00a184c>] (do_sync_write+0xa8/0xe4)
[<c00a17a4>] (do_sync_write+0x0/0xe4) from [<c00a1fa0>] (vfs_write+0xbc/0x148)
 r8:00000008 r7:c7a2df70 r6:4007f000 r5:c7a62de0 r4:00000008
[<c00a1ee4>] (vfs_write+0x0/0x148) from [<c00a2224>] (sys_write+0x44/0x70)
 r8:00000008 r7:00000000 r6:00000000 r5:4007f000 r4:c7a62de0
[<c00a21e0>] (sys_write+0x0/0x70) from [<c0029aa0>] (ret_fast_syscall+0x0/0x30)
 r8:c0029c24 r7:00000004 r6:4007f000 r5:000233d8 r4:00000008
BUG: scheduling while atomic: udevd/215/0x40000002
Modules linked in:
Backtrace: 
[<c002cdf8>] (dump_backtrace+0x0/0x110) from [<c0249d44>] (dump_stack+0x18/0x1c)
 r6:c7a2c000 r5:c0304b38 r4:00000000 r3:20000113
[<c0249d2c>] (dump_stack+0x0/0x1c) from [<c0035038>] (__schedule_bug+0x58/0x64)
[<c0034fe0>] (__schedule_bug+0x0/0x64) from [<c024a040>] (__schedule+0x60/0x2f0)
 r4:c7850c20 r3:00000000
[<c0249fe0>] (__schedule+0x0/0x2f0) from [<c00357bc>] (__cond_resched+0x24/0x3c)
[<c0035798>] (__cond_resched+0x0/0x3c) from [<c024a374>] (_cond_resched+0x38/0x48)
 r4:c7818d40 r3:00000001
[<c024a33c>] (_cond_resched+0x0/0x48) from [<c00407b8>] (put_files_struct+0x94/0xec)
[<c0040724>] (put_files_struct+0x0/0xec) from [<c00408bc>] (exit_files+0x58/0x5c)
[<c0040864>] (exit_files+0x0/0x5c) from [<c0040ac8>] (do_exit+0x208/0x2d8)
 r5:0000000b r4:c7850c20
[<c00408c0>] (do_exit+0x0/0x2d8) from [<c002d348>] (die+0x114/0x128)
[<c002d234>] (die+0x0/0x128) from [<c002f0e8>] (__do_kernel_fault+0x6c/0x8c)
 r7:c7a2dca0 r6:c7a08860 r5:00000817 r4:00000000
[<c002f07c>] (__do_kernel_fault+0x0/0x8c) from [<c002f23c>] (do_page_fault+0x134/0x14c)
 r8:00000000 r7:c03030cc r6:c7850c20 r5:c7a08860 r4:c7a2dca0
r3:c7a2dca0
[<c002f108>] (do_page_fault+0x0/0x14c) from [<c002420c>] (do_DataAbort+0x38/0xa0)
[<c00241d4>] (do_DataAbort+0x0/0xa0) from [<c002960c>] (__dabt_svc+0x4c/0x80)
Exception stack(0xc7a2dca0 to 0xc7a2dce8)
dca0: 00000027 00000000 00000002 00000000 c7a2dd78 c04267e0 00000008 00000000
dcc0: 00000000 00000000 c7a62de0 c7a2dcf4 c7a2dc30 c7a2dce8 c003e2e8 c002cbf0
dce0: 60000013 ffffffff
 r8:00000000 r7:00000000 r6:00000008 r5:c7a2dcd4 r4:ffffffff
[<c002cbcc>] (__bug+0x0/0x30) from [<c0076ab4>] (iov_iter_copy_from_user_atomic+0x44/0xdc)
[<c0076a70>] (iov_iter_copy_from_user_atomic+0x0/0xdc) from [<c0076c34>] (generic_perform_write+0xe8/0x1c4)
 r7:c0252f00 r6:00000008 r5:c7a797a0 r4:c7a2dd78
[<c0076b4c>] (generic_perform_write+0x0/0x1c4) from [<c0076d6c>] (generic_file_buffered_write+0x5c/0x88)
[<c0076d10>] (generic_file_buffered_write+0x0/0x88) from [<c0078f68>] (__generic_file_aio_write+0x468/0x4b4)
 r8:00000008 r7:c7a796f0 r6:c7a62de0 r5:00000000 r4:00000000
[<c0078b00>] (__generic_file_aio_write+0x0/0x4b4) from [<c007902c>] (generic_file_aio_write+0x78/0xe8)
[<c0078fb4>] (generic_file_aio_write+0x0/0xe8) from [<c00a184c>] (do_sync_write+0xa8/0xe4)
[<c00a17a4>] (do_sync_write+0x0/0xe4) from [<c00a1fa0>] (vfs_write+0xbc/0x148)
 r8:00000008 r7:c7a2df70 r6:4007f000 r5:c7a62de0 r4:00000008
[<c00a1ee4>] (vfs_write+0x0/0x148) from [<c00a2224>] (sys_write+0x44/0x70)
 r8:00000008 r7:00000000 r6:00000000 r5:4007f000 r4:c7a62de0
[<c00a21e0>] (sys_write+0x0/0x70) from [<c0029aa0>] (ret_fast_syscall+0x0/0x30)
 r8:c0029c24 r7:00000004 r6:4007f000 r5:000233d8 r4:00000008
init: udev main process (215) killed by SEGV signal
init: udev main process ended, respawning
kernel BUG at mm/filemap.c:2043!
Unable to handle kernel NULL pointer dereference at virtual address 00000000
pgd = c7ab4000
[00000000] *pgd=87aa3831, *pte=00000000, *ppte=00000000
Internal error: Oops: 817 [#4] PREEMPT
Modules linked in:
CPU: 0    Tainted: G      D      (3.0.0-rt8-00001-gd5b0226 #160)
PC is at __bug+0x24/0x30
LR is at vprintk+0x3b4/0x404
pc : [<c002cbf0>]    lr : [<c003e304>]    psr: 20000013
sp : c7a7dce8  ip : c7a7dc30  fp : c7a7dcf4
r10: c7a9d8c0  r9 : 00000000  r8 : 00000000
r7 : 00000000  r6 : 00001000  r5 : c0333980  r4 : c7a7dd78
r3 : 00000000  r2 : 00000002  r1 : 00000003  r0 : 00000027
Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: 00c5387d  Table: 87ab4008  DAC: 00000015
Process udevadm (pid: 238, stack limit = 0xc7a7c268)
Stack: (0xc7a7dce8 to 0xc7a7e000)
dce0:                   c7a7dd14 c7a7dcf8 c0076ab4 c002cbd8 c7a7dd78 c7aa5f68
dd00: 00001000 c0252f00 c7a7dd74 c7a7dd18 c0076c34 c0076a7c 00001000 00000000
dd20: c7a7dd44 c7a7dd40 c7a7c000 00000000 00001000 00000000 00000000 00000000
dd40: c0035100 c0333980 00000001 00000000 00000000 00000000 c7a9d8c0 c7a7dd78
dd60: 00000000 00000000 c7a7ddac c7a7dd78 c0076d6c c0076b58 c7a7df10 00000001
dd80: 00000000 00001000 00000000 00000000 00000000 c7a9d8c0 c7aa5eb8 00001000
dda0: c7a7de3c c7a7ddb0 c0078f68 c0076d1c 00000000 00000000 c7a7ded0 00001000
ddc0: 00000000 c0426920 c7a7de24 c7a7ddd8 c008e94c c007753c c7aa5f68 c7a7ded0
dde0: c7a7df10 c7a7de98 00000000 bee2bb78 00000004 00000001 c7a7de18 00000001
de00: 00000000 00002000 c74041a0 00001000 c7a7dd28 00000000 c7a9d8c0 c7aa5ed4
de20: 00000000 c7a7de98 c7a7df10 00000001 c7a7de8c c7a7de40 c007902c c0078b0c
de40: 000000a0 c7a7df64 91827364 c7a7de4c c7a7de4c c7a7de54 c7a7de54 00000000
de60: bee2b88c c7a9d8c0 c7a7de98 c7a7df70 c7a7df10 fffffdee c7a7c000 00000000
de80: c7a7df3c c7a7de90 c00a184c c0078fc0 00000000 00000000 c014dfec c0035050
dea0: 00000000 00000001 ffffffff c7a9d8c0 00000000 00000000 00000000 00000000
dec0: c7838640 c005c3c4 00000000 00000000 00000000 00000000 00000007 40211080
dee0: 00001000 c7a7dfb0 00001000 00001f60 c7a7dfac c7a7df00 c002420c c002f114
df00: c00242b0 c002f114 c01d95dc c0042b78 40018000 00001000 c7a7de18 00001000
df20: c7a9d8c0 40018000 c7a7df70 00001000 c7a7df6c c7a7df40 c00a1fa0 c00a17b0
df40: c7a7df80 0000004e c0029c24 c7a9d8c0 40018000 00000000 00000000 00001000
df60: c7a7dfa4 c7a7df70 c00a2224 c00a1ef0 00000000 00000000 bee2b8a0 00000000
df80: 00000007 00001000 4022b5c8 40018000 00000004 c0029c24 00000000 c7a7dfa8
dfa0: c0029aa0 c00a21ec 00001000 4022b5c8 00000001 40018000 00001000 00000000
dfc0: 00001000 4022b5c8 40018000 00000004 00001000 0000001c 000c42e8 bee2b864
dfe0: 00000000 bee2b2a8 40166e0c 401ba21c 60000010 00000001 00000000 00000000
Backtrace: 
[<c002cbcc>] (__bug+0x0/0x30) from [<c0076ab4>] (iov_iter_copy_from_user_atomic+0x44/0xdc)
[<c0076a70>] (iov_iter_copy_from_user_atomic+0x0/0xdc) from [<c0076c34>] (generic_perform_write+0xe8/0x1c4)
 r7:c0252f00 r6:00001000 r5:c7aa5f68 r4:c7a7dd78
[<c0076b4c>] (generic_perform_write+0x0/0x1c4) from [<c0076d6c>] (generic_file_buffered_write+0x5c/0x88)
[<c0076d10>] (generic_file_buffered_write+0x0/0x88) from [<c0078f68>] (__generic_file_aio_write+0x468/0x4b4)
 r8:00001000 r7:c7aa5eb8 r6:c7a9d8c0 r5:00000000 r4:00000000
[<c0078b00>] (__generic_file_aio_write+0x0/0x4b4) from [<c007902c>] (generic_file_aio_write+0x78/0xe8)
[<c0078fb4>] (generic_file_aio_write+0x0/0xe8) from [<c00a184c>] (do_sync_write+0xa8/0xe4)
[<c00a17a4>] (do_sync_write+0x0/0xe4) from [<c00a1fa0>] (vfs_write+0xbc/0x148)
 r8:00001000 r7:c7a7df70 r6:40018000 r5:c7a9d8c0 r4:00001000
[<c00a1ee4>] (vfs_write+0x0/0x148) from [<c00a2224>] (sys_write+0x44/0x70)
 r8:00001000 r7:00000000 r6:00000000 r5:40018000 r4:c7a9d8c0
[<c00a21e0>] (sys_write+0x0/0x70) from [<c0029aa0>] (ret_fast_syscall+0x0/0x30)
 r8:c0029c24 r7:00000004 r6:40018000 r5:4022b5c8 r4:00001000
Code: e59f0010 e1a01003 eb0874b7 e3a03000 (e5833000) 
---[ end trace 849a9799d85b827b ]---
note: udevadm[238] exited with preempt_count 1
BUG: scheduling while atomic: udevadm/238/0x40000002
Modules linked in:
Backtrace: 
[<c002cdf8>] (dump_backtrace+0x0/0x110) from [<c0249d44>] (dump_stack+0x18/0x1c)
 r6:c7a7c000 r5:c0304b38 r4:00000000 r3:20000113
[<c0249d2c>] (dump_stack+0x0/0x1c) from [<c0035038>] (__schedule_bug+0x58/0x64)
[<c0034fe0>] (__schedule_bug+0x0/0x64) from [<c024a040>] (__schedule+0x60/0x2f0)
 r4:c7838640 r3:00000000
[<c0249fe0>] (__schedule+0x0/0x2f0) from [<c00357bc>] (__cond_resched+0x24/0x3c)
[<c0035798>] (__cond_resched+0x0/0x3c) from [<c024a374>] (_cond_resched+0x38/0x48)
 r4:c7a7dabc r3:00000001
[<c024a33c>] (_cond_resched+0x0/0x48) from [<c00903a0>] (unmap_page_range+0x1c4/0x1dc)
[<c00901dc>] (unmap_page_range+0x0/0x1dc) from [<c00908a8>] (unmap_vmas+0x80/0xb0)
[<c0090828>] (unmap_vmas+0x0/0xb0) from [<c0094a34>] (exit_mmap+0x12c/0x290)
[<c0094908>] (exit_mmap+0x0/0x290) from [<c003b210>] (mmput+0x3c/0xec)
 r7:c7a358b4 r6:00000000 r5:00000000 r4:c7a35880
[<c003b1d4>] (mmput+0x0/0xec) from [<c003f2e8>] (exit_mm+0x150/0x160)
 r5:c7838640 r4:c7a35880
[<c003f198>] (exit_mm+0x0/0x160) from [<c0040ab8>] (do_exit+0x1f8/0x2d8)
 r7:00000817 r6:00000001 r5:0000000b r4:c7838640
[<c00408c0>] (do_exit+0x0/0x2d8) from [<c002d348>] (die+0x114/0x128)
[<c002d234>] (die+0x0/0x128) from [<c002f0e8>] (__do_kernel_fault+0x6c/0x8c)
 r7:c7a7dca0 r6:c7a35880 r5:00000817 r4:00000000
[<c002f07c>] (__do_kernel_fault+0x0/0x8c) from [<c002f23c>] (do_page_fault+0x134/0x14c)
 r8:00000000 r7:c03030cc r6:c7838640 r5:c7a35880 r4:c7a7dca0
r3:c7a7dca0
[<c002f108>] (do_page_fault+0x0/0x14c) from [<c002420c>] (do_DataAbort+0x38/0xa0)
[<c00241d4>] (do_DataAbort+0x0/0xa0) from [<c002960c>] (__dabt_svc+0x4c/0x80)
Exception stack(0xc7a7dca0 to 0xc7a7dce8)
dca0: 00000027 00000003 00000002 00000000 c7a7dd78 c0333980 00001000 00000000
dcc0: 00000000 00000000 c7a9d8c0 c7a7dcf4 c7a7dc30 c7a7dce8 c003e304 c002cbf0
dce0: 20000013 ffffffff
 r8:00000000 r7:00000000 r6:00001000 r5:c7a7dcd4 r4:ffffffff
[<c002cbcc>] (__bug+0x0/0x30) from [<c0076ab4>] (iov_iter_copy_from_user_atomic+0x44/0xdc)
[<c0076a70>] (iov_iter_copy_from_user_atomic+0x0/0xdc) from [<c0076c34>] (generic_perform_write+0xe8/0x1c4)
 r7:c0252f00 r6:00001000 r5:c7aa5f68 r4:c7a7dd78
[<c0076b4c>] (generic_perform_write+0x0/0x1c4) from [<c0076d6c>] (generic_file_buffered_write+0x5c/0x88)
[<c0076d10>] (generic_file_buffered_write+0x0/0x88) from [<c0078f68>] (__generic_file_aio_write+0x468/0x4b4)
 r8:00001000 r7:c7aa5eb8 r6:c7a9d8c0 r5:00000000 r4:00000000
[<c0078b00>] (__generic_file_aio_write+0x0/0x4b4) from [<c007902c>] (generic_file_aio_write+0x78/0xe8)
[<c0078fb4>] (generic_file_aio_write+0x0/0xe8) from [<c00a184c>] (do_sync_write+0xa8/0xe4)
[<c00a17a4>] (do_sync_write+0x0/0xe4) from [<c00a1fa0>] (vfs_write+0xbc/0x148)
 r8:00001000 r7:c7a7df70 r6:40018000 r5:c7a9d8c0 r4:00001000
[<c00a1ee4>] (vfs_write+0x0/0x148) from [<c00a2224>] (sys_write+0x44/0x70)
 r8:00001000 r7:00000000 r6:00000000 r5:40018000 r4:c7a9d8c0
[<c00a21e0>] (sys_write+0x0/0x70) from [<c0029aa0>] (ret_fast_syscall+0x0/0x30)
 r8:c0029c24 r7:00000004 r6:40018000 r5:4022b5c8 r4:00001000
Segmentation faultinit: syslogd main process (223) terminated with status 139

init: syslogd main process ended, respawning
init: networking main process (222) killed by SEGV signal
init (339): /proc/339/oom_adj is deprecated, please use /proc/339/oom_score_adj instead.
init: ntpclient pre-start process (340) terminated with status 1
init: dbus main process (347) terminated with status 1
init: dbus main process ended, respawning
init: Unable to connect to the system bus: Failed to connect to socket /var/run/dbus/system_bus_socket: No such file or directory
kernel BUG at mm/filemap.c:2043!
Unable to handle kernel NULL pointer dereference at virtual address 00000000
pgd = c7b4c000
[00000000] *pgd=87ad1831, *pte=00000000, *ppte=00000000
Internal error: Oops: 817 [#5] PREEMPT
Modules linked in:
CPU: 0    Tainted: G      D      (3.0.0-rt8-00001-gd5b0226 #160)
PC is at __bug+0x24/0x30
LR is at vprintk+0x398/0x404
pc : [<c002cbf0>]    lr : [<c003e2e8>]    psr: 60000013
sp : c7b95ce8  ip : c7b95c30  fp : c7b95cf4
r10: c7a62ce0  r9 : 00000000  r8 : 00000000
r7 : 00000000  r6 : 00000004  r5 : c0423580  r4 : c7b95d78
r3 : 00000000  r2 : 00000002  r1 : 00000004  r0 : 00000027
Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: 00c5387d  Table: 87b4c008  DAC: 00000015
Process sshd (pid: 358, stack limit = 0xc7b94268)
Stack: (0xc7b95ce8 to 0xc7b96000)
5ce0:                   c7b95d14 c7b95cf8 c0076ab4 c002cbd8 c7b95d78 c7aa5ad0
5d00: 00000004 c0252f00 c7b95d74 c7b95d18 c0076c34 c0076a7c 00000004 00000000
5d20: c7b95d44 c7b95d40 c7b94000 00000000 00001000 00000000 00000000 00000000
5d40: c7b95d74 c0423580 c0041ccc 00000000 00000000 00000000 c7a62ce0 c7b95d78
5d60: 00000000 00000000 c7b95dac c7b95d78 c0076d6c c0076b58 c7b95f10 00000001
5d80: 00000000 00000004 00000000 00000000 00000000 c7a62ce0 c7aa5a20 00000004
5da0: c7b95e3c c7b95db0 c0078f68 c0076d1c 00000000 00000000 c7b95ed0 00000004
5dc0: 00000000 c0035100 c7b95dec c7b95dd8 c0035100 c002b620 c7aa5ad0 c7b95ed0
5de0: c7b95f10 c7b95e98 c008ecf4 c0035050 00000000 00000001 c7b95e24 c7ac31d8
5e00: 40014000 00000000 c7b4d000 00000004 c7a081e0 00000000 c7a62ce0 c7aa5a3c
5e20: 00000000 c7b95e98 c7b95f10 00000001 c7b95e8c c7b95e40 c007902c c0078b0c
5e40: c002b614 00000001 91827364 c7b95e4c c7b95e4c c7b95e54 c7b95e54 00000000
5e60: c7b95eb4 c7a62ce0 c7b95e98 c7b95f70 c7b95f10 fffffdee c7b94000 00000000
5e80: c7b95f3c c7b95e90 c00a184c c0078fc0 00000000 00000000 c014dfec c0035050
5ea0: 00000000 00000001 ffffffff c7a62ce0 00000000 00000000 00000000 00000000
5ec0: c78673e0 c005c3c4 00000000 00000000 00000000 00000000 00000007 40014000
5ee0: 00000004 c7b95fb0 00000004 bee57135 c7b95fac c7b95f00 c002420c c002f114
5f00: c00242b0 c002f114 c7b95f2c c7b95f18 40014000 00000004 c7a08218 00000004
5f20: c7a62ce0 40014000 c7b95f70 00000004 c7b95f6c c7b95f40 c00a1fa0 c00a17b0
5f40: c7b94000 40014000 00001000 c7a62ce0 40014000 00000000 00000000 00000004
5f60: c7b95fa4 c7b95f70 c00a2224 c00a1ef0 00000000 00000000 00000022 00000000
5f80: ffffffff 00000004 0006b7b8 40014000 00000004 c0029c24 00000000 c7b95fa8
5fa0: c0029aa0 c00a21ec 00000004 0006b7b8 00000004 40014000 00000004 00000000
5fc0: 00000004 0006b7b8 40014000 00000004 00000004 00063710 000c42e8 bee57bac
5fe0: 00000000 bee57180 402c2e0c 4031621c 60000010 00000004 c4cc457c c6c88810
Backtrace: 
[<c002cbcc>] (__bug+0x0/0x30) from [<c0076ab4>] (iov_iter_copy_from_user_atomic+0x44/0xdc)
[<c0076a70>] (iov_iter_copy_from_user_atomic+0x0/0xdc) from [<c0076c34>] (generic_perform_write+0xe8/0x1c4)
 r7:c0252f00 r6:00000004 r5:c7aa5ad0 r4:c7b95d78
[<c0076b4c>] (generic_perform_write+0x0/0x1c4) from [<c0076d6c>] (generic_file_buffered_write+0x5c/0x88)
[<c0076d10>] (generic_file_buffered_write+0x0/0x88) from [<c0078f68>] (__generic_file_aio_write+0x468/0x4b4)
 r8:00000004 r7:c7aa5a20 r6:c7a62ce0 r5:00000000 r4:00000000
[<c0078b00>] (__generic_file_aio_write+0x0/0x4b4) from [<c007902c>] (generic_file_aio_write+0x78/0xe8)
[<c0078fb4>] (generic_file_aio_write+0x0/0xe8) from [<c00a184c>] (do_sync_write+0xa8/0xe4)
[<c00a17a4>] (do_sync_write+0x0/0xe4) from [<c00a1fa0>] (vfs_write+0xbc/0x148)
 r8:00000004 r7:c7b95f70 r6:40014000 r5:c7a62ce0 r4:00000004
[<c00a1ee4>] (vfs_write+0x0/0x148) from [<c00a2224>] (sys_write+0x44/0x70)
 r8:00000004 r7:00000000 r6:00000000 r5:40014000 r4:c7a62ce0
[<c00a21e0>] (sys_write+0x0/0x70) from [<c0029aa0>] (ret_fast_syscall+0x0/0x30)
 r8:c0029c24 r7:00000004 r6:40014000 r5:0006b7b8 r4:00000004
Code: e59f0010 e1a01003 eb0874b7 e3a03000 (e5833000) 
---[ end trace 849a9799d85b827c ]---
note: sshd[358] exited with preempt_count 1
BUG: scheduling while atomic: sshd/358/0x40000002
Modules linked in:
Backtrace: 
[<c002cdf8>] (dump_backtrace+0x0/0x110) from [<c0249d44>] (dump_stack+0x18/0x1c)
 r6:c7b94000 r5:c0304b38 r4:00000000 r3:20000113
[<c0249d2c>] (dump_stack+0x0/0x1c) from [<c0035038>] (__schedule_bug+0x58/0x64)
[<c0034fe0>] (__schedule_bug+0x0/0x64) from [<c024a040>] (__schedule+0x60/0x2f0)
 r4:c78673e0 r3:00000000
[<c0249fe0>] (__schedule+0x0/0x2f0) from [<c00357bc>] (__cond_resched+0x24/0x3c)
[<c0035798>] (__cond_resched+0x0/0x3c) from [<c024a374>] (_cond_resched+0x38/0x48)
 r4:c7b95abc r3:00000001
[<c024a33c>] (_cond_resched+0x0/0x48) from [<c00903a0>] (unmap_page_range+0x1c4/0x1dc)
[<c00901dc>] (unmap_page_range+0x0/0x1dc) from [<c00908a8>] (unmap_vmas+0x80/0xb0)
[<c0090828>] (unmap_vmas+0x0/0xb0) from [<c0094a34>] (exit_mmap+0x12c/0x290)
[<c0094908>] (exit_mmap+0x0/0x290) from [<c003b210>] (mmput+0x3c/0xec)
 r7:c7a08214 r6:00000000 r5:00000000 r4:c7a081e0
[<c003b1d4>] (mmput+0x0/0xec) from [<c003f2e8>] (exit_mm+0x150/0x160)
 r5:c78673e0 r4:c7a081e0
[<c003f198>] (exit_mm+0x0/0x160) from [<c0040ab8>] (do_exit+0x1f8/0x2d8)
 r7:00000817 r6:00000001 r5:0000000b r4:c78673e0
[<c00408c0>] (do_exit+0x0/0x2d8) from [<c002d348>] (die+0x114/0x128)
[<c002d234>] (die+0x0/0x128) from [<c002f0e8>] (__do_kernel_fault+0x6c/0x8c)
 r7:c7b95ca0 r6:c7a081e0 r5:00000817 r4:00000000
[<c002f07c>] (__do_kernel_fault+0x0/0x8c) from [<c002f23c>] (do_page_fault+0x134/0x14c)
 r8:00000000 r7:c03030cc r6:c78673e0 r5:c7a081e0 r4:c7b95ca0
r3:c7b95ca0
[<c002f108>] (do_page_fault+0x0/0x14c) from [<c002420c>] (do_DataAbort+0x38/0xa0)
[<c00241d4>] (do_DataAbort+0x0/0xa0) from [<c002960c>] (__dabt_svc+0x4c/0x80)
Exception stack(0xc7b95ca0 to 0xc7b95ce8)
5ca0: 00000027 00000004 00000002 00000000 c7b95d78 c0423580 00000004 00000000
5cc0: 00000000 00000000 c7a62ce0 c7b95cf4 c7b95c30 c7b95ce8 c003e2e8 c002cbf0
5ce0: 60000013 ffffffff
 r8:00000000 r7:00000000 r6:00000004 r5:c7b95cd4 r4:ffffffff
[<c002cbcc>] (__bug+0x0/0x30) from [<c0076ab4>] (iov_iter_copy_from_user_atomic+0x44/0xdc)
[<c0076a70>] (iov_iter_copy_from_user_atomic+0x0/0xdc) from [<c0076c34>] (generic_perform_write+0xe8/0x1c4)
 r7:c0252f00 r6:00000004 r5:c7aa5ad0 r4:c7b95d78
[<c0076b4c>] (generic_perform_write+0x0/0x1c4) from [<c0076d6c>] (generic_file_buffered_write+0x5c/0x88)
[<c0076d10>] (generic_file_buffered_write+0x0/0x88) from [<c0078f68>] (__generic_file_aio_write+0x468/0x4b4)
 r8:00000004 r7:c7aa5a20 r6:c7a62ce0 r5:00000000 r4:00000000
[<c0078b00>] (__generic_file_aio_write+0x0/0x4b4) from [<c007902c>] (generic_file_aio_write+0x78/0xe8)
[<c0078fb4>] (generic_file_aio_write+0x0/0xe8) from [<c00a184c>] (do_sync_write+0xa8/0xe4)
[<c00a17a4>] (do_sync_write+0x0/0xe4) from [<c00a1fa0>] (vfs_write+0xbc/0x148)
 r8:00000004 r7:c7b95f70 r6:40014000 r5:c7a62ce0 r4:00000004
[<c00a1ee4>] (vfs_write+0x0/0x148) from [<c00a2224>] (sys_write+0x44/0x70)
 r8:00000004 r7:00000000 r6:00000000 r5:40014000 r4:c7a62ce0
[<c00a21e0>] (sys_write+0x0/0x70) from [<c0029aa0>] (ret_fast_syscall+0x0/0x30)
 r8:c0029c24 r7:00000004 r6:40014000 r5:0006b7b8 r4:00000004
init: udevmonitor main process (238) killed by SEGV signal
BUG: scheduling while atomic: sshd/358/0x40000002
Modules linked in:
Backtrace: 
[<c002cdf8>] (dump_backtrace+0x0/0x110) from [<c0249d44>] (dump_stack+0x18/0x1c)
 r6:c7b94000 r5:c0304b38 r4:00000000 r3:20000113
[<c0249d2c>] (dump_stack+0x0/0x1c) from [<c0035038>] (__schedule_bug+0x58/0x64)
[<c0034fe0>] (__schedule_bug+0x0/0x64) from [<c024a040>] (__schedule+0x60/0x2f0)
 r4:c78673e0 r3:00000000
[<c0249fe0>] (__schedule+0x0/0x2f0) from [<c00357bc>] (__cond_resched+0x24/0x3c)
[<c0035798>] (__cond_resched+0x0/0x3c) from [<c024a374>] (_cond_resched+0x38/0x48)
 r4:c78182c0 r3:00000001
[<c024a33c>] (_cond_resched+0x0/0x48) from [<c00407b8>] (put_files_struct+0x94/0xec)
[<c0040724>] (put_files_struct+0x0/0xec) from [<c00408bc>] (exit_files+0x58/0x5c)
[<c0040864>] (exit_files+0x0/0x5c) from [<c0040ac8>] (do_exit+0x208/0x2d8)
 r5:0000000b r4:c78673e0
[<c00408c0>] (do_exit+0x0/0x2d8) from [<c002d348>] (die+0x114/0x128)
[<c002d234>] (die+0x0/0x128) from [<c002f0e8>] (__do_kernel_fault+0x6c/0x8c)
 r7:c7b95ca0 r6:c7a081e0 r5:00000817 r4:00000000
[<c002f07c>] (__do_kernel_fault+0x0/0x8c) from [<c002f23c>] (do_page_fault+0x134/0x14c)
 r8:00000000 r7:c03030cc r6:c78673e0 r5:c7a081e0 r4:c7b95ca0
r3:c7b95ca0
[<c002f108>] (do_page_fault+0x0/0x14c) from [<c002420c>] (do_DataAbort+0x38/0xa0)
[<c00241d4>] (do_DataAbort+0x0/0xa0) from [<c002960c>] (__dabt_svc+0x4c/0x80)
Exception stack(0xc7b95ca0 to 0xc7b95ce8)
5ca0: 00000027 00000004 00000002 00000000 c7b95d78 c0423580 00000004 00000000
5cc0: 00000000 00000000 c7a62ce0 c7b95cf4 c7b95c30 c7b95ce8 c003e2e8 c002cbf0
5ce0: 60000013 ffffffff
 r8:00000000 r7:00000000 r6:00000004 r5:c7b95cd4 r4:ffffffff
[<c002cbcc>] (__bug+0x0/0x30) from [<c0076ab4>] (iov_iter_copy_from_user_atomic+0x44/0xdc)
[<c0076a70>] (iov_iter_copy_from_user_atomic+0x0/0xdc) from [<c0076c34>] (generic_perform_write+0xe8/0x1c4)
 r7:c0252f00 r6:00000004 r5:c7aa5ad0 r4:c7b95d78
[<c0076b4c>] (generic_perform_write+0x0/0x1c4) from [<c0076d6c>] (generic_file_buffered_write+0x5c/0x88)
[<c0076d10>] (generic_file_buffered_write+0x0/0x88) from [<c0078f68>] (__generic_file_aio_write+0x468/0x4b4)
 r8:00000004 r7:c7aa5a20 r6:c7a62ce0 r5:00000000 r4:00000000
[<c0078b00>] (__generic_file_aio_write+0x0/0x4b4) from [<c007902c>] (generic_file_aio_write+0x78/0xe8)
[<c0078fb4>] (generic_file_aio_write+0x0/0xe8) from [<c00a184c>] (do_sync_write+0xa8/0xe4)
[<c00a17a4>] (do_sync_write+0x0/0xe4) from [<c00a1fa0>] (vfs_write+0xbc/0x148)
 r8:00000004 r7:c7b95f70 r6:40014000 r5:c7a62ce0 r4:00000004
[<c00a1ee4>] (vfs_write+0x0/0x148) from [<c00a2224>] (sys_write+0x44/0x70)
 r8:00000004 r7:00000000 r6:00000000 r5:40014000 r4:c7a62ce0
[<c00a21e0>] (sys_write+0x0/0x70) from [<c0029aa0>] (ret_fast_syscall+0x0/0x30)
 r8:c0029c24 r7:00000004 r6:40014000 r5:0006b7b8 r4:00000004
kernel BUG at mm/filemap.c:2043!
Unable to handle kernel NULL pointer dereference at virtual address 00000000
pgd = c7bbc000
[00000000] *pgd=87aac831, *pte=00000000, *ppte=00000000
Internal error: Oops: 817 [#6] PREEMPT
Modules linked in:
CPU: 0    Tainted: G      D      (3.0.0-rt8-00001-gd5b0226 #160)
PC is at __bug+0x24/0x30
LR is at vprintk+0x398/0x404
pc : [<c002cbf0>]    lr : [<c003e2e8>]    psr: 60000013
sp : c7aedce8  ip : c7aedc30  fp : c7aedcf4
r10: c7a22a40  r9 : 00000000  r8 : 00000000
r7 : 00000000  r6 : 00000004  r5 : c0334440  r4 : c7aedd78
r3 : 00000000  r2 : 00000002  r1 : 00000005  r0 : 00000027
Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: 00c5387d  Table: 87bbc008  DAC: 00000015
Process avahi-daemon (pid: 362, stack limit = 0xc7aec268)
Stack: (0xc7aedce8 to 0xc7aee000)
dce0:                   c7aedd14 c7aedcf8 c0076ab4 c002cbd8 c7aedd78 c7aa57c0
dd00: 00000004 c0252f00 c7aedd74 c7aedd18 c0076c34 c0076a7c 00000004 00000000
dd20: c7aedd44 c7aedd40 c7aec000 00000000 00001000 00000000 00000000 00000000
dd40: c7aedd74 c0334440 c0041ccc 00000000 00000000 00000000 c7a22a40 c7aedd78
dd60: 00000000 00000000 c7aeddac c7aedd78 c0076d6c c0076b58 c7aedf10 00000001
dd80: 00000000 00000004 00000000 00000000 00000000 c7a22a40 c7aa5710 00000004
dda0: c7aede3c c7aeddb0 c0078f68 c0076d1c 00000000 00000000 c7aeded0 00000004
ddc0: 00000000 c0422f80 c7aede24 c7aeddd8 c008e94c c007753c c7aa57c0 c7aeded0
dde0: c7aedf10 c7aede98 00000000 00000004 40037000 00000001 c7aede24 c7a94128
de00: 00000004 00000000 c7bbd000 00000004 c7a35880 00000000 c7a22a40 c7aa572c
de20: 00000000 c7aede98 c7aedf10 00000001 c7aede8c c7aede40 c007902c c0078b0c
de40: c002b614 00000001 91827364 c7aede4c c7aede4c c7aede54 c7aede54 00000000
de60: c7aedeb4 c7a22a40 c7aede98 c7aedf70 c7aedf10 fffffdee c7aec000 00000000
de80: c7aedf3c c7aede90 c00a184c c0078fc0 00000000 00000000 c014dfec c0035050
dea0: 00000000 00000001 ffffffff c7a22a40 00000000 00000000 00000000 00000000
dec0: c7bda940 c005c3c4 00000000 00000000 00000000 00000000 00000007 40037078
dee0: 00000004 c7aedfb0 00000004 40037078 c7aedfac c7aedf00 c002420c c002f114
df00: 00000000 c7001660 c7aedf2c c7aedf18 bea9ab88 00000004 00000000 00000004
df20: c7a22a40 bea9ab88 c7aedf70 00000004 c7aedf6c c7aedf40 c00a1fa0 c00a17b0
df40: 00000000 00000000 00000000 c7a22a40 bea9ab88 00000000 00000000 00000004
df60: c7aedfa4 c7aedf70 c00a2224 c00a1ef0 00000000 00000000 c7aedfa4 00000000
df80: c00b09c0 4003f274 40285a58 00000005 00000004 c0029c24 00000000 c7aedfa8
dfa0: c0029aa0 c00a21ec 4003f274 40285a58 00000005 bea9ab88 00000004 00000000
dfc0: 4003f274 40285a58 00000005 00000004 00019f38 00000004 00000004 00000005
dfe0: 0000003f bea9ab88 40036340 4014aaec 60000010 00000005 00000000 00000000
Backtrace: 
[<c002cbcc>] (__bug+0x0/0x30) from [<c0076ab4>] (iov_iter_copy_from_user_atomic+0x44/0xdc)
[<c0076a70>] (iov_iter_copy_from_user_atomic+0x0/0xdc) from [<c0076c34>] (generic_perform_write+0xe8/0x1c4)
 r7:c0252f00 r6:00000004 r5:c7aa57c0 r4:c7aedd78
[<c0076b4c>] (generic_perform_write+0x0/0x1c4) from [<c0076d6c>] (generic_file_buffered_write+0x5c/0x88)
[<c0076d10>] (generic_file_buffered_write+0x0/0x88) from [<c0078f68>] (__generic_file_aio_write+0x468/0x4b4)
 r8:00000004 r7:c7aa5710 r6:c7a22a40 r5:00000000 r4:00000000
[<c0078b00>] (__generic_file_aio_write+0x0/0x4b4) from [<c007902c>] (generic_file_aio_write+0x78/0xe8)
[<c0078fb4>] (generic_file_aio_write+0x0/0xe8) from [<c00a184c>] (do_sync_write+0xa8/0xe4)
[<c00a17a4>] (do_sync_write+0x0/0xe4) from [<c00a1fa0>] (vfs_write+0xbc/0x148)
 r8:00000004 r7:c7aedf70 r6:bea9ab88 r5:c7a22a40 r4:00000004
[<c00a1ee4>] (vfs_write+0x0/0x148) from [<c00a2224>] (sys_write+0x44/0x70)
 r8:00000004 r7:00000000 r6:00000000 r5:bea9ab88 r4:c7a22a40
[<c00a21e0>] (sys_write+0x0/0x70) from [<c0029aa0>] (ret_fast_syscall+0x0/0x30)
 r8:c0029c24 r7:00000004 r6:00000005 r5:40285a58 r4:4003f274
Code: e59f0010 e1a01003 eb0874b7 e3a03000 (e5833000) 
---[ end trace 849a9799d85b827d ]---
note: avahi-daemon[362] exited with preempt_count 1
BUG: scheduling while atomic: avahi-daemon/362/0x40000002
Modules linked in:
Backtrace: 
[<c002cdf8>] (dump_backtrace+0x0/0x110) from [<c0249d44>] (dump_stack+0x18/0x1c)
 r6:c7aec000 r5:c0304b38 r4:00000000 r3:20000113
[<c0249d2c>] (dump_stack+0x0/0x1c) from [<c0035038>] (__schedule_bug+0x58/0x64)
[<c0034fe0>] (__schedule_bug+0x0/0x64) from [<c024a040>] (__schedule+0x60/0x2f0)
 r4:c7bda940 r3:00000000
[<c0249fe0>] (__schedule+0x0/0x2f0) from [<c00357bc>] (__cond_resched+0x24/0x3c)
[<c0035798>] (__cond_resched+0x0/0x3c) from [<c024a374>] (_cond_resched+0x38/0x48)
 r4:c7aedabc r3:00000001
[<c024a33c>] (_cond_resched+0x0/0x48) from [<c00903a0>] (unmap_page_range+0x1c4/0x1dc)
[<c00901dc>] (unmap_page_range+0x0/0x1dc) from [<c00908a8>] (unmap_vmas+0x80/0xb0)
[<c0090828>] (unmap_vmas+0x0/0xb0) from [<c0094a34>] (exit_mmap+0x12c/0x290)
[<c0094908>] (exit_mmap+0x0/0x290) from [<c003b210>] (mmput+0x3c/0xec)
 r7:c7a358b4 r6:00000000 r5:00000000 r4:c7a35880
[<c003b1d4>] (mmput+0x0/0xec) from [<c003f2e8>] (exit_mm+0x150/0x160)
 r5:c7bda940 r4:c7a35880
[<c003f198>] (exit_mm+0x0/0x160) from [<c0040ab8>] (do_exit+0x1f8/0x2d8)
 r7:00000817 r6:00000001 r5:0000000b r4:c7bda940
[<c00408c0>] (do_exit+0x0/0x2d8) from [<c002d348>] (die+0x114/0x128)
[<c002d234>] (die+0x0/0x128) from [<c002f0e8>] (__do_kernel_fault+0x6c/0x8c)
 r7:c7aedca0 r6:c7a35880 r5:00000817 r4:00000000
[<c002f07c>] (__do_kernel_fault+0x0/0x8c) from [<c002f23c>] (do_page_fault+0x134/0x14c)
 r8:00000000 r7:c03030cc r6:c7bda940 r5:c7a35880 r4:c7aedca0
r3:c7aedca0
[<c002f108>] (do_page_fault+0x0/0x14c) from [<c002420c>] (do_DataAbort+0x38/0xa0)
[<c00241d4>] (do_DataAbort+0x0/0xa0) from [<c002960c>] (__dabt_svc+0x4c/0x80)
Exception stack(0xc7aedca0 to 0xc7aedce8)
dca0: 00000027 00000005 00000002 00000000 c7aedd78 c0334440 00000004 00000000
dcc0: 00000000 00000000 c7a22a40 c7aedcf4 c7aedc30 c7aedce8 c003e2e8 c002cbf0
dce0: 60000013 ffffffff
 r8:00000000 r7:00000000 r6:00000004 r5:c7aedcd4 r4:ffffffff
[<c002cbcc>] (__bug+0x0/0x30) from [<c0076ab4>] (iov_iter_copy_from_user_atomic+0x44/0xdc)
[<c0076a70>] (iov_iter_copy_from_user_atomic+0x0/0xdc) from [<c0076c34>] (generic_perform_write+0xe8/0x1c4)
 r7:c0252f00 r6:00000004 r5:c7aa57c0 r4:c7aedd78
[<c0076b4c>] (generic_perform_write+0x0/0x1c4) from [<c0076d6c>] (generic_file_buffered_write+0x5c/0x88)
[<c0076d10>] (generic_file_buffered_write+0x0/0x88) from [<c0078f68>] (__generic_file_aio_write+0x468/0x4b4)
 r8:00000004 r7:c7aa5710 r6:c7a22a40 r5:00000000 r4:00000000
[<c0078b00>] (__generic_file_aio_write+0x0/0x4b4) from [<c007902c>] (generic_file_aio_write+0x78/0xe8)
[<c0078fb4>] (generic_file_aio_write+0x0/0xe8) from [<c00a184c>] (do_sync_write+0xa8/0xe4)
[<c00a17a4>] (do_sync_write+0x0/0xe4) from [<c00a1fa0>] (vfs_write+0xbc/0x148)
 r8:00000004 r7:c7aedf70 r6:bea9ab88 r5:c7a22a40 r4:00000004
[<c00a1ee4>] (vfs_write+0x0/0x148) from [<c00a2224>] (sys_write+0x44/0x70)
 r8:00000004 r7:00000000 r6:00000000 r5:bea9ab88 r4:c7a22a40
[<c00a21e0>] (sys_write+0x0/0x70) from [<c0029aa0>] (ret_fast_syscall+0x0/0x30)
 r8:c0029c24 r7:00000004 r6:00000005 r5:40285a58 r4:4003f274
init: syscfgmgr main process (357) killed by ABRT signal
init: syscfgmgr main process ended, respawning
init: httpdata main process (352) killed by ABRT signal
init: httpdata main process ended, respawning
init: dbuslistener main process (353) killed by ABRT signal
init: dbuslistener main process ended, respawning
init: fwconfig main process (354) killed by ABRT signal
init: fwconfig main process ended, respawning
init: parameter main process (355) killed by ABRT signal
init: parameter main process ended, respawning
init: storagemanager main process (356) killed by ABRT signal
init: storagemanager main process ended, respawning
BUG: scheduling while atomic: sshd/358/0x40000002
Modules linked in:
Backtrace: 
[<c002cdf8>] (dump_backtrace+0x0/0x110) from [<c0249d44>] (dump_stack+0x18/0x1c)
 r6:c7b94000 r5:c0304b38 r4:00000000 r3:20000113
[<c0249d2c>] (dump_stack+0x0/0x1c) from [<c0035038>] (__schedule_bug+0x58/0x64)
[<c0034fe0>] (__schedule_bug+0x0/0x64) from [<c024a040>] (__schedule+0x60/0x2f0)
 r4:c78673e0 r3:00000000
[<c0249fe0>] (__schedule+0x0/0x2f0) from [<c00357bc>] (__cond_resched+0x24/0x3c)
[<c0035798>] (__cond_resched+0x0/0x3c) from [<c024a374>] (_cond_resched+0x38/0x48)
 r4:c78182c0 r3:00000001
[<c024a33c>] (_cond_resched+0x0/0x48) from [<c00407b8>] (put_files_struct+0x94/0xec)
[<c0040724>] (put_files_struct+0x0/0xec) from [<c00408bc>] (exit_files+0x58/0x5c)
[<c0040864>] (exit_files+0x0/0x5c) from [<c0040ac8>] (do_exit+0x208/0x2d8)
 r5:0000000b r4:c78673e0
[<c00408c0>] (do_exit+0x0/0x2d8) from [<c002d348>] (die+0x114/0x128)
[<c002d234>] (die+0x0/0x128) from [<c002f0e8>] (__do_kernel_fault+0x6c/0x8c)
 r7:c7b95ca0 r6:c7a081e0 r5:00000817 r4:00000000
[<c002f07c>] (__do_kernel_fault+0x0/0x8c) from [<c002f23c>] (do_page_fault+0x134/0x14c)
 r8:00000000 r7:c03030cc r6:c78673e0 r5:c7a081e0 r4:c7b95ca0
r3:c7b95ca0
[<c002f108>] (do_page_fault+0x0/0x14c) from [<c002420c>] (do_DataAbort+0x38/0xa0)
[<c00241d4>] (do_DataAbort+0x0/0xa0) from [<c002960c>] (__dabt_svc+0x4c/0x80)
Exception stack(0xc7b95ca0 to 0xc7b95ce8)
5ca0: 00000027 00000004 00000002 00000000 c7b95d78 c0423580 00000004 00000000
5cc0: 00000000 00000000 c7a62ce0 c7b95cf4 c7b95c30 c7b95ce8 c003e2e8 c002cbf0
5ce0: 60000013 ffffffff
 r8:00000000 r7:00000000 r6:00000004 r5:c7b95cd4 r4:ffffffff
[<c002cbcc>] (__bug+0x0/0x30) from [<c0076ab4>] (iov_iter_copy_from_user_atomic+0x44/0xdc)
[<c0076a70>] (iov_iter_copy_from_user_atomic+0x0/0xdc) from [<c0076c34>] (generic_perform_write+0xe8/0x1c4)
 r7:c0252f00 r6:00000004 r5:c7aa5ad0 r4:c7b95d78
[<c0076b4c>] (generic_perform_write+0x0/0x1c4) from [<c0076d6c>] (generic_file_buffered_write+0x5c/0x88)
[<c0076d10>] (generic_file_buffered_write+0x0/0x88) from [<c0078f68>] (__generic_file_aio_write+0x468/0x4b4)
 r8:00000004 r7:c7aa5a20 r6:c7a62ce0 r5:00000000 r4:00000000
[<c0078b00>] (__generic_file_aio_write+0x0/0x4b4) from [<c007902c>] (generic_file_aio_write+0x78/0xe8)
[<c0078fb4>] (generic_file_aio_write+0x0/0xe8) from [<c00a184c>] (do_sync_write+0xa8/0xe4)
[<c00a17a4>] (do_sync_write+0x0/0xe4) from [<c00a1fa0>] (vfs_write+0xbc/0x148)
 r8:00000004 r7:c7b95f70 r6:40014000 r5:c7a62ce0 r4:00000004
[<c00a1ee4>] (vfs_write+0x0/0x148) from [<c00a2224>] (sys_write+0x44/0x70)
 r8:00000004 r7:00000000 r6:00000000 r5:40014000 r4:c7a62ce0
[<c00a21e0>] (sys_write+0x0/0x70) from [<c0029aa0>] (ret_fast_syscall+0x0/0x30)
 r8:c0029c24 r7:00000004 r6:40014000 r5:0006b7b8 r4:00000004
init: ssh main process (358) killed by SEGV signal
init: ssh main process ended, respawning
init: avahi-daemon main process (362) killed by SEGV signal
init: avahi-daemon main process ended, respawning
init: avahi-daemon main process (374) terminated with status 255
init: avahi-daemon main process ended, respawning

Hottinger Baldwin Messtechnik GmbH, Im Tiefen See 45, 64293 Darmstadt, Germany | www.hbm.com 

Registered as GmbH (German limited liability corporation) in the commercial register at the local court of Darmstadt, HRB 1147  
Company domiciled in Darmstadt | CEO: Andreas Huellhorst | Chairman of the board: James Charles Webster

Als Gesellschaft mit beschraenkter Haftung eingetragen im Handelsregister des Amtsgerichts Darmstadt unter HRB 1147 
Sitz der Gesellschaft: Darmstadt | Geschaeftsfuehrung: Andreas Huellhorst | Aufsichtsratsvorsitzender: James Charles Webster

The information in this email is confidential. It is intended solely for the addressee. If you are not the intended recipient, please let me know and delete this email.

Die in dieser E-Mail enthaltene Information ist vertraulich und lediglich für den Empfaenger bestimmt. Sollten Sie nicht der eigentliche Empfaenger sein, informieren Sie mich bitte kurz und loeschen diese E-Mail.

