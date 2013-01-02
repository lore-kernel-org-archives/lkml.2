Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788Ab3ABRVN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 12:21:13 -0500
Received: from relay3.sgi.com ([192.48.152.1]:40427 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752132Ab3ABRVM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 12:21:12 -0500
Date: Wed, 2 Jan 2013 11:21:10 -0600
From: Nathan Zimmer <nzimmer@sgi.com>
To: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
Cc: matt.fleming@intel.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com
Subject: BUG: unable to handle kernel paging request at 000000effd870020
Message-ID: <20130102172107.GA26761@gulag1.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am getting an early boot problem. It only happens on the larger of the
machines I haven't seen it crop up on machines with more then 512 GB of ram.
It shows in the latest linus kernel too.

I am (wildly) guessing that what is happening is that the new_memmap that is
being passed to bios is somehow placed incorrectly.  
I have come up with a workaround.  By placing it the DMA area the issue goes
away but that doesn't seem like a real fix. 


BUG: unable to handle kernel paging request at 000000effd870020
IP: [<0000000078bce331>] 0x78bce330
PGD 0 
Oops: 0000 [#1] SMP 
Modules linked in:
CPU 0 
Pid: 0, comm: swapper/0 Tainted: G        W    3.8.0-rc1-next-20121224-medusa_ntz+ #2 Intel Corp. Stoutland Platform
RIP: 0010:[<0000000078bce331>]  [<0000000078bce331>] 0x78bce330
RSP: 0000:ffffffff81601d28  EFLAGS: 00010006
RAX: 0000000078b80e18 RBX: 0000000000000004 RCX: 0000000000000004
RDX: 0000000078bcf958 RSI: 0000000000002400 RDI: 8000000000000000
RBP: 0000000078bcf760 R08: 000000effd870000 R09: 0000000000000000
R10: 0000000000000000 R11: 00000000000000c3 R12: 0000000000000030
R13: 000000effd870000 R14: 0000000000000000 R15: ffff88effd870000
FS:  0000000000000000(0000) GS:ffff88effe400000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000effd870020 CR3: 000000000160c000 CR4: 00000000000006b0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper/0 (pid: 0, threadinfo ffffffff81600000, task ffffffff81614400)
Stack:
 0000000078b80d18 0000000000000004 0000000078bced7b ffff880078b81fff
 0000000000000000 0000000000000082 0000000078bce3a8 0000000000002400
 0000000060000202 0000000078b80da0 0000000078bce45d ffffffff8107cb5a
Call Trace:
 [<ffffffff8107cb5a>] ? on_each_cpu+0x77/0x83
 [<ffffffff8102f4eb>] ? change_page_attr_set_clr+0x32f/0x3ed
 [<ffffffff81035946>] ? efi_call4+0x46/0x80
 [<ffffffff816c5abb>] ? efi_enter_virtual_mode+0x1f5/0x305
 [<ffffffff816aeb24>] ? start_kernel+0x34a/0x3d2
 [<ffffffff816ae5ed>] ? repair_env_string+0x60/0x60
 [<ffffffff816ae2be>] ? x86_64_start_reservations+0xba/0xc1
 [<ffffffff816ae120>] ? early_idt_handlers+0x120/0x120
 [<ffffffff816ae419>] ? x86_64_start_kernel+0x154/0x163
Code:  Bad RIP value.
RIP  [<0000000078bce331>] 0x78bce330
 RSP <ffffffff81601d28>
CR2: 000000effd870020
---[ end trace ead828934fef5eab ]---



---
 arch/x86/platform/efi/efi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/arch/x86/platform/efi/efi.c
===================================================================
--- linux.orig/arch/x86/platform/efi/efi.c	2012-11-24 09:43:09.236997834 -0600
+++ linux/arch/x86/platform/efi/efi.c	2012-11-24 09:53:30.264654748 -0600
@@ -915,7 +915,7 @@
 		}
 		new_memmap = krealloc(new_memmap,
 				      (count + 1) * memmap.desc_size,
-				      GFP_KERNEL);
+				      GFP_DMA);
 		memcpy(new_memmap + (count * memmap.desc_size), md,
 		       memmap.desc_size);
 		count++;

