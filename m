Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932264Ab1CRDyT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 23:54:19 -0400
Received: from ozlabs.org ([203.10.76.45]:45950 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932140Ab1CRDyL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 23:54:11 -0400
To: Stephen Rothwell <sfr@canb.auug.org.au>, Tejun Heo <tj@kernel.org>
cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: linux-next: Tree for March 17
In-reply-to: <20110317173442.da7f3fd3.sfr@canb.auug.org.au>
References: <20110317173442.da7f3fd3.sfr@canb.auug.org.au>
Comments: In-reply-to Stephen Rothwell <sfr@canb.auug.org.au>
   message dated "Thu, 17 Mar 2011 17:34:42 +1100."
Date: Fri, 18 Mar 2011 14:54:09 +1100
Message-ID: <27409.1300420449@neuling.org>
From: Michael Neuling <mikey@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun,

> Re: linux-next: Tree for March 17

I'm getting this on boot on powerpc once my init scripts are running:
---
Unable to handle kernel paging request for data at address 0x00000240
Faulting instruction address: 0xc0000000001a3138
Oops: Kernel access of bad area, sig: 11 [#1]
SMP NR_CPUS=1024 NUMA parries
last sysfs file: /sys/kernel/uevent_seqnum
Modules linked in:
NIP: c0000000001a3138 LR: c0000000001a2e10 CTR: 0000000000000000
REGS: c00000007e69f520 TRAP: 0300   Tainted: G        W    (2.6.38-next-20110317-mikey)
MSR: 9000000000009032 <EE,ME,IR,DR>  CR: 24000844  XER: 02000000
DAR: 0000000000000240, DSISR: 40000000
TASK = c00000007e829f00[1342] 'fsck' THREAD: c00000007e69c000 CPU: 0
GPR00: c0000000001a2e10 c00000007e69f7a0 c000000000ac8690 0000000000000000 
GPR04: 0000000000000001 0000000000000000 0000000000000000 0000000000000000 
GPR08: c00000007e0b7208 0000000000000000 0000000000000000 ffffffffffffffff 
GPR12: 0000000024000842 c00000000ff60000 0000000000000000 0000000010005b14 
GPR16: 0000000010005e14 00000000100162f0 00000000100162d4 0000000000000000 
GPR20: 00000000100162d8 00000000100162b4 0000000000000000 0000000000000000 
GPR24: c00000007e69f810 fffffffffffffffa 0000000000000000 c00000007d023ba0 
GPR28: 000000000000001d 0000000000000000 c000000000a1f080 c00000007d023b80 
NIP [c0000000001a3138] .__blkdev_get+0x3b0/0x40c
LR [c0000000001a2e10] .__blkdev_get+0x88/0x40c
Call Trace:
[c00000007e69f7a0] [c0000000001a2e10] .__blkdev_get+0x88/0x40c (unreliable)
[c00000007e69f860] [c0000000001a3224] .blkdev_get+0x90/0x210
[c00000007e69f910] [c00000000016498c] .__dentry_open+0x20c/0x370
[c00000007e69f9d0] [c0000000001767ac] .do_last+0x66c/0x814
[c00000007e69faa0] [c000000000177820] .path_openat+0x110/0x450
[c00000007e69fbc0] [c000000000177ca4] .do_filp_open+0x68/0xb0
[c00000007e69fd00] [c00000000016468c] .do_sys_open+0x160/0x228
[c00000007e69fdc0] [c0000000001b6aa8] .compat_sys_open+0x24/0x38
[c00000007e69fe30] [c000000000008564] syscall_exit+0x0/0x40
Instruction dump:
419e0010 7f84e378 38a00001 4bfff8e9 38000000 f81f0078 7f63db78 484a1865 
60000000 7fa3eb78 4817be41 60000000 <e93d0240> e8690058 4bf14521 60000000 
---[ end trace 31fd0ba7d8756004 ]---
fsckdied with signal 11
--
The system has no disks, only an RAM fs.

If I revert just this patch, the oops goes away:
  69e02c59a7d962dced8047401b81a8d897e1702e 
  block: Don't check events while open is in progress

So it looks like this null check is still needed.

-       if (disk)
-               module_put(disk->fops->owner);
+       module_put(disk->fops->owner);


Mikey
