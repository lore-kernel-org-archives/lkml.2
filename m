Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238Ab3ACWHW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 17:07:22 -0500
Received: from relay1.sgi.com ([192.48.179.29]:46376 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753643Ab3ACWHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 17:07:19 -0500
Date: Thu, 3 Jan 2013 16:07:16 -0600
From: Nathan Zimmer <nzimmer@sgi.com>
To: Matt Fleming <matt.fleming@intel.com>, Robin Holt <holt@sgi.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com
Subject: Re: BUG: unable to handle kernel paging request at 000000effd870020
Message-ID: <20130103220716.GA13995@gulag1.americas.sgi.com>
References: <20130102172107.GA26761@gulag1.americas.sgi.com> <50E476C2.7060300@zytor.com> <50E486E7.1080903@sgi.com> <20130102210958.GD3470@sgi.com> <1357228255.8203.10.camel@mfleming-mobl1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357228255.8203.10.camel@mfleming-mobl1.ger.corp.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 03, 2013 at 03:50:55PM +0000, Matt Fleming wrote:
> On Wed, 2013-01-02 at 15:09 -0600, Robin Holt wrote:
> > On Wed, Jan 02, 2013 at 01:13:43PM -0600, Nathan Zimmer wrote:
> > > On 01/02/2013 12:04 PM, H. Peter Anvin wrote:
> > > >On 01/02/2013 09:21 AM, Nathan Zimmer wrote:
> > > >>I am getting an early boot problem. It only happens on the larger of the
> > > >>machines I haven't seen it crop up on machines with more then 512 GB of ram.
> > > >>It shows in the latest linus kernel too.
> > > >>
> > > >>I am (wildly) guessing that what is happening is that the new_memmap that is
> > > >>being passed to bios is somehow placed incorrectly.
> > > >>I have come up with a workaround.  By placing it the DMA area the issue goes
> > > >>away but that doesn't seem like a real fix.
> > > >>
> > > >What does your memory map look like?
> > 
> > We reported this a few times (Russ Anderson and I both).  The problem is
> > at the point in boot where the efi_enter_virtual_mode callback is, there
> > is no identity mapping for most of memory.  If the allocation happens
> > to be above the 512GB (or maybe something lower than that) point, the
> > BIOS is not able to address this via the physical address passed to it.
> 
> Right, looks like efi_call_phys_prelog() needs rewriting to install a
> proper identity mapping that actually addresses *all* of available
> memory, instead of just the first PGDIR_SIZE bytes.
> 
> 

Ok here is what Robin and I came up with


>From c96406c36a45de25ac83681971b64d48096288e2 Mon Sep 17 00:00:00 2001
From: Nathan Zimmer <nzimmer@sgi.com>
Date: Thu, 3 Jan 2013 15:41:10 -0600
Subject: [PATCH] Pass a proper identity mapping in efi_call_phys_prelog

Update efi_call_phys_prelog to install an identity mapping of all available
memory.  This corrects a bug on very large systems with more then 512 GB in
which bios would not be able to access addresses above not in the mapping.

The result is a crash that looks much like this.

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

Cc: Matt Fleming <matt.fleming@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>
Signed-off-by: Robin Holt <holt@sgi.com>
---
 arch/x86/platform/efi/efi_64.c |   23 ++++++++++++++++++-----
 1 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index 95fd505..79d54d7 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -38,7 +38,7 @@
 #include <asm/cacheflush.h>
 #include <asm/fixmap.h>
 
-static pgd_t save_pgd __initdata;
+static pgd_t *save_pgd __initdata;
 static unsigned long efi_flags __initdata;
 
 static void __init early_code_mapping_set_exec(int executable)
@@ -61,13 +61,22 @@ static void __init early_code_mapping_set_exec(int executable)
 void __init efi_call_phys_prelog(void)
 {
 	unsigned long vaddress;
+	int pgd;
+	int n_pgds;
 
 	early_code_mapping_set_exec(1);
 	local_irq_save(efi_flags);
-	vaddress = (unsigned long)__va(0x0UL);
-	save_pgd = *pgd_offset_k(0x0UL);
-	set_pgd(pgd_offset_k(0x0UL), *pgd_offset_k(vaddress));
+
+	n_pgds = DIV_ROUND_UP((max_pfn << PAGE_SHIFT), PGDIR_SIZE);
+	save_pgd = kmalloc(n_pgds * sizeof(pgd_t), GFP_KERNEL);
+
+	for (pgd = 0; pgd < n_pgds; pgd++) {
+		save_pgd[pgd] = *pgd_offset_k(pgd * PGDIR_SIZE);
+		vaddress = (unsigned long)__va(pgd * PGDIR_SIZE);
+		set_pgd(pgd_offset_k(j * PGDIR_SIZE), *pgd_offset_k(vaddress));
+	}
 	__flush_tlb_all();
+
 }
 
 void __init efi_call_phys_epilog(void)
@@ -75,7 +84,11 @@ void __init efi_call_phys_epilog(void)
 	/*
 	 * After the lock is released, the original page table is restored.
 	 */
-	set_pgd(pgd_offset_k(0x0UL), save_pgd);
+	int pgd;
+	int n_pgds = DIV_ROUND_UP((max_pfn << PAGE_SHIFT) , PGDIR_SIZE);
+	for (pgd = 0; pgd < n_pgds; pgd++)
+		set_pgd(pgd_offset_k(pgd * PGDIR_SIZE), save_pgd[pgd]);
+	kfree(save_pgd);
 	__flush_tlb_all();
 	local_irq_restore(efi_flags);
 	early_code_mapping_set_exec(0);
-- 
1.6.0.2


