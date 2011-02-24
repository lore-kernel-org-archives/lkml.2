Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932517Ab1BXEwc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 23:52:32 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:58767 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752138Ab1BXEwb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 23:52:31 -0500
Date: Thu, 24 Feb 2011 15:52:21 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>
Subject: linux-next: manual merge of the tip tree with the acpi tree
Message-Id: <20110224155221.4f35f728.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the tip tree got a conflict in
arch/x86/kernel/acpi/sleep.c between commit
a69fa313606a51cee99d802c14895330948f60c8 ("ACPI / PM: Drop
acpi_restore_state_mem()") from the acpi tree and commit
d1ee433539ea5963a8f946f3428b335d1c5fdb20 ("x86, trampoline: Use the
unified trampoline setup for ACPI wakeup") from the tip tree.

Just context (I think).  I fixed it up (see below) and can carry the fix
as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/x86/kernel/acpi/sleep.c
index 5f1b747,4572c58..0000000
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@@ -33,22 -29,17 +29,17 @@@ static char temp_stack[4096]
   *
   * Create an identity mapped page table and copy the wakeup routine to
   * low memory.
-  *
-  * Note that this is too late to change acpi_wakeup_address.
   */
 -int acpi_save_state_mem(void)
 +int acpi_suspend_lowlevel(void)
  {
  	struct wakeup_header *header;
+ 	/* address in low memory of the wakeup routine. */
+ 	char *acpi_realmode;
  
- 	if (!acpi_realmode) {
- 		printk(KERN_ERR "Could not allocate memory during boot, "
- 		       "S3 disabled\n");
- 		return -ENOMEM;
- 	}
- 	memcpy((void *)acpi_realmode, &wakeup_code_start, WAKEUP_SIZE);
+ 	acpi_realmode = TRAMPOLINE_SYM(acpi_wakeup_code);
  
- 	header = (struct wakeup_header *)(acpi_realmode + HEADER_OFFSET);
- 	if (header->signature != 0x51ee1111) {
+ 	header = (struct wakeup_header *)(acpi_realmode + WAKEUP_HEADER_OFFSET);
+ 	if (header->signature != WAKEUP_HEADER_SIGNATURE) {
  		printk(KERN_ERR "wakeup header does not match\n");
  		return -EINVAL;
  	}
@@@ -111,45 -99,13 +100,6 @@@
  	return 0;
  }
  
- /**
-  * acpi_reserve_wakeup_memory - do _very_ early ACPI initialisation
-  *
-  * We allocate a page from the first 1MB of memory for the wakeup
-  * routine for when we come back from a sleep state. The
-  * runtime allocator allows specification of <16MB pages, but not
-  * <1MB pages.
-  */
- void __init acpi_reserve_wakeup_memory(void)
- {
- 	phys_addr_t mem;
- 
- 	if ((&wakeup_code_end - &wakeup_code_start) > WAKEUP_SIZE) {
- 		printk(KERN_ERR
- 		       "ACPI: Wakeup code way too big, S3 disabled.\n");
- 		return;
- 	}
- 
- 	mem = memblock_find_in_range(0, 1<<20, WAKEUP_SIZE, PAGE_SIZE);
- 
- 	if (mem == MEMBLOCK_ERROR) {
- 		printk(KERN_ERR "ACPI: Cannot allocate lowmem, S3 disabled.\n");
- 		return;
- 	}
- 	acpi_realmode = (unsigned long) phys_to_virt(mem);
- 	acpi_wakeup_address = mem;
- 	memblock_x86_reserve_range(mem, mem + WAKEUP_SIZE, "ACPI WAKEUP");
- }
- 
- int __init acpi_configure_wakeup_memory(void)
- {
- 	if (acpi_realmode)
- 		set_memory_x(acpi_realmode, WAKEUP_SIZE >> PAGE_SHIFT);
- 
- 	return 0;
- }
- arch_initcall(acpi_configure_wakeup_memory);
- 
- 
 -/*
 - * acpi_restore_state - undo effects of acpi_save_state_mem
 - */
 -void acpi_restore_state_mem(void)
 -{
 -}
 -
  static int __init acpi_sleep_setup(char *str)
  {
  	while ((str != NULL) && (*str != '\0')) {
