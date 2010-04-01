Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827Ab0DAJzD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 05:55:03 -0400
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:49032 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754707Ab0DAJyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 05:54:54 -0400
X-Greylist: delayed 549 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Apr 2010 05:54:54 EDT
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       hsweeten@visionengravers.com, hpa@zytor.com, eric.piel@tremplin-utc.net
Cc: aaro.koskinen@iki.fi, stable <stable@kernel.org>
Subject: [PATCH] initramfs: prevent buffer overflow when unpacking to rootfs
Date: Thu,  1 Apr 2010 12:45:46 +0300
Message-Id: <1270115146-25342-1-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Garbage in the initrd memory area may result in the unpack routine
accessing memory outside the buffer. The patch adds a check that the
specified area size is not exceeded.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: stable <stable@kernel.org>
---

The patch prevents the following kernel panic on Amstrad E3:

	Unpacking initramfs...
	Unable to handle kernel paging request at virtual address c20121a7
	pgd = c0004000
	[c20121a7] *pgd=00000000
	Internal error: Oops: 75 [#1] PREEMPT
	last sysfs file: 
	Modules linked in:
	CPU: 0    Not tainted  (2.6.34-rc2-00052-gae6be51 #19)
	PC is at unpack_to_rootfs+0xac/0x33c
	LR is at decompress_method+0x28/0x64
	pc : [<c0009858>]    lr : [<c015fcc4>]    psr: 20000013
	sp : c1819f68  ip : 00000000  fp : c0023b88
	r10: c20121a7  r9 : c0023b98  r8 : 00000000
	r7 : 00300000  r6 : fffede59  r5 : c0023ad8  r4 : 00000000
	r3 : 00000000  r2 : 00000001  r1 : c0303034  r0 : 00000000
	Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
	Control: 0000317f  Table: 10004000  DAC: 00000017
	Process swapper (pid: 1, stack limit = 0xc1818270)
	Stack: (0xc1819f68 to 0xc181a000)
	9f60:                   00000000 c03f77ec c00092f8 c03f68fc 00000000 c03f77e0
	9f80: c00228fc 00000000 c000a3c8 00000000 00000000 c03f77e0 c00228fc 00000000
	9fa0: c000a3c8 00000001 00000000 00000000 00000000 c000a410 c002263c c00283b0
	9fc0: 00000000 00000170 c03da678 00000000 c002263c c00228fc 00000000 00000000
	9fe0: 00000000 c0008594 00000000 00000000 00000000 c0029f74 8d7cf20a a7ca85e0
	[<c0009858>] (unpack_to_rootfs+0xac/0x33c) from [<c000a410>] (populate_rootfs+0x48/0xb0)
	[<c000a410>] (populate_rootfs+0x48/0xb0) from [<c00283b0>] (do_one_initcall+0x60/0x1c0)
	[<c00283b0>] (do_one_initcall+0x60/0x1c0) from [<c0008594>] (kernel_init+0xa8/0x15c)
	[<c0008594>] (kernel_init+0xa8/0x15c) from [<c0029f74>] (kernel_thread_exit+0x0/0x8)
	Code: e1a05001 e1a09000 e1a0b00c ea000059 (e5da3000) 
	---[ end trace da227214a82491b7 ]---
	Kernel panic - not syncing: Attempted to kill init!
	[<c002e56c>] (unwind_backtrace+0x0/0xec) from [<c02f1a40>] (panic+0x40/0xcc)
	[<c02f1a40>] (panic+0x40/0xcc) from [<c004af64>] (do_exit+0x60/0x608)
	[<c004af64>] (do_exit+0x60/0x608) from [<c002c8d4>] (die+0x1b4/0x1e4)
	[<c002c8d4>] (die+0x1b4/0x1e4) from [<c002f7d8>] (__do_kernel_fault+0x64/0x84)
	[<c002f7d8>] (__do_kernel_fault+0x64/0x84) from [<c002fac8>] (do_translation_fault+0x70/0x80)
	[<c002fac8>] (do_translation_fault+0x70/0x80) from [<c00282f0>] (do_DataAbort+0x34/0x94)
	[<c00282f0>] (do_DataAbort+0x34/0x94) from [<c0028ac0>] (__dabt_svc+0x40/0x60)
	Exception stack(0xc1819f20 to 0xc1819f68)
	9f20: 00000000 c0303034 00000001 00000000 00000000 c0023ad8 fffede59 00300000
	9f40: 00000000 c0023b98 c20121a7 c0023b88 00000000 c1819f68 c015fcc4 c0009858
	9f60: 20000013 ffffffff
	[<c0028ac0>] (__dabt_svc+0x40/0x60) from [<c0009858>] (unpack_to_rootfs+0xac/0x33c)
	[<c0009858>] (unpack_to_rootfs+0xac/0x33c) from [<c000a410>] (populate_rootfs+0x48/0xb0)
	[<c000a410>] (populate_rootfs+0x48/0xb0) from [<c00283b0>] (do_one_initcall+0x60/0x1c0)
	[<c00283b0>] (do_one_initcall+0x60/0x1c0) from [<c0008594>] (kernel_init+0xa8/0x15c)
	[<c0008594>] (kernel_init+0xa8/0x15c) from [<c0029f74>] (kernel_thread_exit+0x0/0x8)

 init/initramfs.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/init/initramfs.c b/init/initramfs.c
index 37d3859..223bdaa 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -460,6 +460,8 @@ static char * __init unpack_to_rootfs(char *buf, unsigned len)
 		}
 		if (state != Reset)
 			error("junk in compressed archive");
+		if (my_inptr >= len)
+			break;
 		this_header = saved_offset + my_inptr;
 		buf += my_inptr;
 		len -= my_inptr;
-- 
1.5.6.5

