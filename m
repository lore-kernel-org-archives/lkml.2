Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445Ab1LJBkz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 20:40:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48511 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab1LJBkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 20:40:53 -0500
Date: Fri, 9 Dec 2011 17:40:36 -0800
From: tip-bot for Matt Fleming <matt.fleming@intel.com>
Message-ID: <tip-6d3e32e63f1fb47b3ba104d13dfac116df7b2bbb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, mjg@redhat.com, hpa@zytor.com,
        mingo@redhat.com, dvhart@linux.intel.com, matt.fleming@intel.com,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, mjg@redhat.com,
        linux-kernel@vger.kernel.org, dvhart@linux.intel.com,
        matt.fleming@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1323346250.3894.74.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1323346250.3894.74.camel@mfleming-mobl1.ger.corp.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, efi: Make efi_call_phys_{prelog,epilog} CONFIG_RELOCATABLE-aware
Git-Commit-ID: 6d3e32e63f1fb47b3ba104d13dfac116df7b2bbb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 09 Dec 2011 17:40:41 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6d3e32e63f1fb47b3ba104d13dfac116df7b2bbb
Gitweb:     http://git.kernel.org/tip/6d3e32e63f1fb47b3ba104d13dfac116df7b2bbb
Author:     Matt Fleming <matt.fleming@intel.com>
AuthorDate: Thu, 8 Dec 2011 12:10:50 +0000
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 9 Dec 2011 16:39:11 -0800

x86, efi: Make efi_call_phys_{prelog,epilog} CONFIG_RELOCATABLE-aware

efi_call_phys_prelog() sets up a 1:1 mapping of the physical address
range in swapper_pg_dir. Instead of replacing then restoring entries
in swapper_pg_dir we should be using initial_page_table which already
contains the 1:1 mapping.

It's safe to blindly switch back to swapper_pg_dir in the epilog
because the physical EFI routines are only called before
efi_enter_virtual_mode(), e.g. before any user processes have been
forked. Therefore, we don't need to track which pgd was in %cr3 when
we entered the prelog.

The previous code actually contained a bug because it assumed that the
kernel was loaded at a physical address within the first 8MB of ram,
usually at 0x100000. However, this isn't the case with a
CONFIG_RELOCATABLE=y kernel which could have been loaded anywhere in
the physical address space.

Also delete the ancient (and bogus) comments about the page table
being restored after the lock is released. There is no locking.

Cc: Matthew Garrett <mjg@redhat.com>
Cc: Darrent Hart <dvhart@linux.intel.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Link: http://lkml.kernel.org/r/1323346250.3894.74.camel@mfleming-mobl1.ger.corp.intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/platform/efi/efi_32.c |   48 +--------------------------------------
 1 files changed, 2 insertions(+), 46 deletions(-)

diff --git a/arch/x86/platform/efi/efi_32.c b/arch/x86/platform/efi/efi_32.c
index e36bf71..40e4469 100644
--- a/arch/x86/platform/efi/efi_32.c
+++ b/arch/x86/platform/efi/efi_32.c
@@ -39,43 +39,14 @@
  */
 
 static unsigned long efi_rt_eflags;
-static pgd_t efi_bak_pg_dir_pointer[2];
 
 void efi_call_phys_prelog(void)
 {
-	unsigned long cr4;
-	unsigned long temp;
 	struct desc_ptr gdt_descr;
 
 	local_irq_save(efi_rt_eflags);
 
-	/*
-	 * If I don't have PAE, I should just duplicate two entries in page
-	 * directory. If I have PAE, I just need to duplicate one entry in
-	 * page directory.
-	 */
-	cr4 = read_cr4_safe();
-
-	if (cr4 & X86_CR4_PAE) {
-		efi_bak_pg_dir_pointer[0].pgd =
-		    swapper_pg_dir[pgd_index(0)].pgd;
-		swapper_pg_dir[0].pgd =
-		    swapper_pg_dir[pgd_index(PAGE_OFFSET)].pgd;
-	} else {
-		efi_bak_pg_dir_pointer[0].pgd =
-		    swapper_pg_dir[pgd_index(0)].pgd;
-		efi_bak_pg_dir_pointer[1].pgd =
-		    swapper_pg_dir[pgd_index(0x400000)].pgd;
-		swapper_pg_dir[pgd_index(0)].pgd =
-		    swapper_pg_dir[pgd_index(PAGE_OFFSET)].pgd;
-		temp = PAGE_OFFSET + 0x400000;
-		swapper_pg_dir[pgd_index(0x400000)].pgd =
-		    swapper_pg_dir[pgd_index(temp)].pgd;
-	}
-
-	/*
-	 * After the lock is released, the original page table is restored.
-	 */
+	load_cr3(initial_page_table);
 	__flush_tlb_all();
 
 	gdt_descr.address = __pa(get_cpu_gdt_table(0));
@@ -85,28 +56,13 @@ void efi_call_phys_prelog(void)
 
 void efi_call_phys_epilog(void)
 {
-	unsigned long cr4;
 	struct desc_ptr gdt_descr;
 
 	gdt_descr.address = (unsigned long)get_cpu_gdt_table(0);
 	gdt_descr.size = GDT_SIZE - 1;
 	load_gdt(&gdt_descr);
 
-	cr4 = read_cr4_safe();
-
-	if (cr4 & X86_CR4_PAE) {
-		swapper_pg_dir[pgd_index(0)].pgd =
-		    efi_bak_pg_dir_pointer[0].pgd;
-	} else {
-		swapper_pg_dir[pgd_index(0)].pgd =
-		    efi_bak_pg_dir_pointer[0].pgd;
-		swapper_pg_dir[pgd_index(0x400000)].pgd =
-		    efi_bak_pg_dir_pointer[1].pgd;
-	}
-
-	/*
-	 * After the lock is released, the original page table is restored.
-	 */
+	load_cr3(swapper_pg_dir);
 	__flush_tlb_all();
 
 	local_irq_restore(efi_rt_eflags);
