Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752283Ab1BRFUT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 00:20:19 -0500
Received: from hera.kernel.org ([140.211.167.34]:55494 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751815Ab1BRFUD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 00:20:03 -0500
Date: Fri, 18 Feb 2011 05:19:29 GMT
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        castet.matthieu@free.fr, tglx@linutronix.de, sfr@canb.auug.org.au,
        hpa@linux.intel.com, rjw@sisk.pl
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        castet.matthieu@free.fr, tglx@linutronix.de, sfr@canb.auug.org.au,
        hpa@linux.intel.com, rjw@sisk.pl
In-Reply-To: <4D5DFBE4.7090104@intel.com>
References: <4D5DFBE4.7090104@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/trampoline] x86, trampoline: Use the unified trampoline setup for ACPI wakeup
Message-ID: <tip-d1ee433539ea5963a8f946f3428b335d1c5fdb20@git.kernel.org>
Git-Commit-ID: d1ee433539ea5963a8f946f3428b335d1c5fdb20
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 18 Feb 2011 05:19:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d1ee433539ea5963a8f946f3428b335d1c5fdb20
Gitweb:     http://git.kernel.org/tip/d1ee433539ea5963a8f946f3428b335d1c5fdb20
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Mon, 14 Feb 2011 15:42:46 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 17 Feb 2011 21:05:06 -0800

x86, trampoline: Use the unified trampoline setup for ACPI wakeup

Use the unified trampoline allocation setup to allocate and install
the ACPI wakeup code in low memory.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
LKML-Reference: <4D5DFBE4.7090104@intel.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Matthieu Castet <castet.matthieu@free.fr>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/x86/include/asm/acpi.h                |    4 +-
 arch/x86/include/asm/trampoline.h          |   33 +++++++++-----
 arch/x86/kernel/acpi/realmode/wakeup.S     |   21 ++++++---
 arch/x86/kernel/acpi/realmode/wakeup.h     |    5 +-
 arch/x86/kernel/acpi/realmode/wakeup.lds.S |   28 ++++++------
 arch/x86/kernel/acpi/sleep.c               |   65 +++-------------------------
 arch/x86/kernel/acpi/sleep.h               |    3 -
 arch/x86/kernel/acpi/wakeup_rm.S           |   10 +++--
 arch/x86/kernel/setup.c                    |    7 ---
 drivers/acpi/sleep.c                       |    1 +
 10 files changed, 69 insertions(+), 108 deletions(-)

diff --git a/arch/x86/include/asm/acpi.h b/arch/x86/include/asm/acpi.h
index 211ca3f..4784df5 100644
--- a/arch/x86/include/asm/acpi.h
+++ b/arch/x86/include/asm/acpi.h
@@ -29,6 +29,7 @@
 #include <asm/processor.h>
 #include <asm/mmu.h>
 #include <asm/mpspec.h>
+#include <asm/trampoline.h>
 
 #define COMPILER_DEPENDENT_INT64   long long
 #define COMPILER_DEPENDENT_UINT64  unsigned long long
@@ -116,7 +117,8 @@ static inline void acpi_disable_pci(void)
 extern int acpi_save_state_mem(void);
 extern void acpi_restore_state_mem(void);
 
-extern unsigned long acpi_wakeup_address;
+extern const unsigned char acpi_wakeup_code[];
+#define acpi_wakeup_address (__pa(TRAMPOLINE_SYM(acpi_wakeup_code)))
 
 /* early initialization routine */
 extern void acpi_reserve_wakeup_memory(void);
diff --git a/arch/x86/include/asm/trampoline.h b/arch/x86/include/asm/trampoline.h
index f4500fb..feca311 100644
--- a/arch/x86/include/asm/trampoline.h
+++ b/arch/x86/include/asm/trampoline.h
@@ -3,25 +3,36 @@
 
 #ifndef __ASSEMBLY__
 
-#ifdef CONFIG_X86_TRAMPOLINE
+#include <linux/types.h>
+#include <asm/io.h>
+
 /*
- * Trampoline 80x86 program as an array.
+ * Trampoline 80x86 program as an array.  These are in the init rodata
+ * segment, but that's okay, because we only care about the relative
+ * addresses of the symbols.
  */
-extern const unsigned char trampoline_data [];
-extern const unsigned char trampoline_end  [];
-extern unsigned char *trampoline_base;
+extern const unsigned char x86_trampoline_start [];
+extern const unsigned char x86_trampoline_end   [];
+extern unsigned char *x86_trampoline_base;
 
 extern unsigned long init_rsp;
 extern unsigned long initial_code;
 extern unsigned long initial_gs;
 
-#define TRAMPOLINE_SIZE roundup(trampoline_end - trampoline_data, PAGE_SIZE)
+extern void __init setup_trampolines(void);
+
+extern const unsigned char trampoline_data[];
+extern const unsigned char trampoline_status[];
+
+#define TRAMPOLINE_SYM(x)						\
+	((void *)(x86_trampoline_base +					\
+		  ((const unsigned char *)(x) - x86_trampoline_start)))
 
-extern unsigned long setup_trampoline(void);
-extern void __init reserve_trampoline_memory(void);
-#else
-static inline void reserve_trampoline_memory(void) {}
-#endif /* CONFIG_X86_TRAMPOLINE */
+/* Address of the SMP trampoline */
+static inline unsigned long trampoline_address(void)
+{
+	return virt_to_phys(TRAMPOLINE_SYM(trampoline_data));
+}
 
 #endif /* __ASSEMBLY__ */
 
diff --git a/arch/x86/kernel/acpi/realmode/wakeup.S b/arch/x86/kernel/acpi/realmode/wakeup.S
index 28595d6..ead21b6 100644
--- a/arch/x86/kernel/acpi/realmode/wakeup.S
+++ b/arch/x86/kernel/acpi/realmode/wakeup.S
@@ -6,11 +6,17 @@
 #include <asm/page_types.h>
 #include <asm/pgtable_types.h>
 #include <asm/processor-flags.h>
+#include "wakeup.h"
 
 	.code16
-	.section ".header", "a"
+	.section ".jump", "ax"
+	.globl	_start
+_start:
+	cli
+	jmp	wakeup_code
 
 /* This should match the structure in wakeup.h */
+		.section ".header", "a"
 		.globl	wakeup_header
 wakeup_header:
 video_mode:	.short	0	/* Video mode number */
@@ -30,14 +36,11 @@ wakeup_jmp:	.byte	0xea	/* ljmpw */
 wakeup_jmp_off:	.word	3f
 wakeup_jmp_seg:	.word	0
 wakeup_gdt:	.quad	0, 0, 0
-signature:	.long	0x51ee1111
+signature:	.long	WAKEUP_HEADER_SIGNATURE
 
 	.text
-	.globl	_start
 	.code16
 wakeup_code:
-_start:
-	cli
 	cld
 
 	/* Apparently some dimwit BIOS programmers don't know how to
@@ -77,12 +80,12 @@ _start:
 
 	/* Check header signature... */
 	movl	signature, %eax
-	cmpl	$0x51ee1111, %eax
+	cmpl	$WAKEUP_HEADER_SIGNATURE, %eax
 	jne	bogus_real_magic
 
 	/* Check we really have everything... */
 	movl	end_signature, %eax
-	cmpl	$0x65a22c82, %eax
+	cmpl	$WAKEUP_END_SIGNATURE, %eax
 	jne	bogus_real_magic
 
 	/* Call the C code */
@@ -147,3 +150,7 @@ wakeup_heap:
 wakeup_stack:
 	.space	2048
 wakeup_stack_end:
+
+	.section ".signature","a"
+end_signature:
+	.long	WAKEUP_END_SIGNATURE
diff --git a/arch/x86/kernel/acpi/realmode/wakeup.h b/arch/x86/kernel/acpi/realmode/wakeup.h
index 69d38d0..e1828c0 100644
--- a/arch/x86/kernel/acpi/realmode/wakeup.h
+++ b/arch/x86/kernel/acpi/realmode/wakeup.h
@@ -35,7 +35,8 @@ struct wakeup_header {
 extern struct wakeup_header wakeup_header;
 #endif
 
-#define HEADER_OFFSET 0x3f00
-#define WAKEUP_SIZE   0x4000
+#define WAKEUP_HEADER_OFFSET	8
+#define WAKEUP_HEADER_SIGNATURE 0x51ee1111
+#define WAKEUP_END_SIGNATURE	0x65a22c82
 
 #endif /* ARCH_X86_KERNEL_ACPI_RM_WAKEUP_H */
diff --git a/arch/x86/kernel/acpi/realmode/wakeup.lds.S b/arch/x86/kernel/acpi/realmode/wakeup.lds.S
index 060fff8..d4f8010 100644
--- a/arch/x86/kernel/acpi/realmode/wakeup.lds.S
+++ b/arch/x86/kernel/acpi/realmode/wakeup.lds.S
@@ -13,9 +13,19 @@ ENTRY(_start)
 SECTIONS
 {
 	. = 0;
+	.jump	: {
+		*(.jump)
+	} = 0x90909090
+
+	. = WAKEUP_HEADER_OFFSET;
+	.header : {
+		*(.header)
+	}
+
+	. = ALIGN(16);
 	.text : {
 		 *(.text*)
-	}
+	} = 0x90909090
 
 	. = ALIGN(16);
 	.rodata : {
@@ -33,11 +43,6 @@ SECTIONS
 		 *(.data*)
 	}
 
-	.signature : {
-		end_signature = .;
-		LONG(0x65a22c82)
-	}
-
 	. = ALIGN(16);
 	.bss :	{
 		__bss_start = .;
@@ -45,20 +50,13 @@ SECTIONS
 		__bss_end = .;
 	}
 
-	. = HEADER_OFFSET;
-	.header : {
-		*(.header)
+	.signature : {
+		*(.signature)
 	}
 
-	. = ALIGN(16);
 	_end = .;
 
 	/DISCARD/ : {
 		*(.note*)
 	}
-
-	/*
-	 * The ASSERT() sink to . is intentional, for binutils 2.14 compatibility:
-	 */
-	. = ASSERT(_end <= WAKEUP_SIZE, "Wakeup too big!");
 }
diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index 68d1537..4572c58 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -18,12 +18,8 @@
 #include "realmode/wakeup.h"
 #include "sleep.h"
 
-unsigned long acpi_wakeup_address;
 unsigned long acpi_realmode_flags;
 
-/* address in low memory of the wakeup routine. */
-static unsigned long acpi_realmode;
-
 #if defined(CONFIG_SMP) && defined(CONFIG_64BIT)
 static char temp_stack[4096];
 #endif
@@ -33,22 +29,17 @@ static char temp_stack[4096];
  *
  * Create an identity mapped page table and copy the wakeup routine to
  * low memory.
- *
- * Note that this is too late to change acpi_wakeup_address.
  */
 int acpi_save_state_mem(void)
 {
 	struct wakeup_header *header;
+	/* address in low memory of the wakeup routine. */
+	char *acpi_realmode;
 
-	if (!acpi_realmode) {
-		printk(KERN_ERR "Could not allocate memory during boot, "
-		       "S3 disabled\n");
-		return -ENOMEM;
-	}
-	memcpy((void *)acpi_realmode, &wakeup_code_start, WAKEUP_SIZE);
+	acpi_realmode = TRAMPOLINE_SYM(acpi_wakeup_code);
 
-	header = (struct wakeup_header *)(acpi_realmode + HEADER_OFFSET);
-	if (header->signature != 0x51ee1111) {
+	header = (struct wakeup_header *)(acpi_realmode + WAKEUP_HEADER_OFFSET);
+	if (header->signature != WAKEUP_HEADER_SIGNATURE) {
 		printk(KERN_ERR "wakeup header does not match\n");
 		return -EINVAL;
 	}
@@ -68,9 +59,7 @@ int acpi_save_state_mem(void)
 	/* GDT[0]: GDT self-pointer */
 	header->wakeup_gdt[0] =
 		(u64)(sizeof(header->wakeup_gdt) - 1) +
-		((u64)(acpi_wakeup_address +
-			((char *)&header->wakeup_gdt - (char *)acpi_realmode))
-				<< 16);
+		((u64)__pa(&header->wakeup_gdt) << 16);
 	/* GDT[1]: big real mode-like code segment */
 	header->wakeup_gdt[1] =
 		GDT_ENTRY(0x809b, acpi_wakeup_address, 0xfffff);
@@ -96,7 +85,7 @@ int acpi_save_state_mem(void)
 	header->pmode_cr3 = (u32)__pa(&initial_page_table);
 	saved_magic = 0x12345678;
 #else /* CONFIG_64BIT */
-	header->trampoline_segment = setup_trampoline() >> 4;
+	header->trampoline_segment = trampoline_address() >> 4;
 #ifdef CONFIG_SMP
 	stack_start = (unsigned long)temp_stack + sizeof(temp_stack);
 	early_gdt_descr.address =
@@ -117,46 +106,6 @@ void acpi_restore_state_mem(void)
 {
 }
 
-
-/**
- * acpi_reserve_wakeup_memory - do _very_ early ACPI initialisation
- *
- * We allocate a page from the first 1MB of memory for the wakeup
- * routine for when we come back from a sleep state. The
- * runtime allocator allows specification of <16MB pages, but not
- * <1MB pages.
- */
-void __init acpi_reserve_wakeup_memory(void)
-{
-	phys_addr_t mem;
-
-	if ((&wakeup_code_end - &wakeup_code_start) > WAKEUP_SIZE) {
-		printk(KERN_ERR
-		       "ACPI: Wakeup code way too big, S3 disabled.\n");
-		return;
-	}
-
-	mem = memblock_find_in_range(0, 1<<20, WAKEUP_SIZE, PAGE_SIZE);
-
-	if (mem == MEMBLOCK_ERROR) {
-		printk(KERN_ERR "ACPI: Cannot allocate lowmem, S3 disabled.\n");
-		return;
-	}
-	acpi_realmode = (unsigned long) phys_to_virt(mem);
-	acpi_wakeup_address = mem;
-	memblock_x86_reserve_range(mem, mem + WAKEUP_SIZE, "ACPI WAKEUP");
-}
-
-int __init acpi_configure_wakeup_memory(void)
-{
-	if (acpi_realmode)
-		set_memory_x(acpi_realmode, WAKEUP_SIZE >> PAGE_SHIFT);
-
-	return 0;
-}
-arch_initcall(acpi_configure_wakeup_memory);
-
-
 static int __init acpi_sleep_setup(char *str)
 {
 	while ((str != NULL) && (*str != '\0')) {
diff --git a/arch/x86/kernel/acpi/sleep.h b/arch/x86/kernel/acpi/sleep.h
index adbcbaa..86ba1c8 100644
--- a/arch/x86/kernel/acpi/sleep.h
+++ b/arch/x86/kernel/acpi/sleep.h
@@ -4,13 +4,10 @@
 
 #include <asm/trampoline.h>
 
-extern char wakeup_code_start, wakeup_code_end;
-
 extern unsigned long saved_video_mode;
 extern long saved_magic;
 
 extern int wakeup_pmode_return;
-extern char swsusp_pg_dir[PAGE_SIZE];
 
 extern unsigned long acpi_copy_wakeup_routine(unsigned long);
 extern void wakeup_long64(void);
diff --git a/arch/x86/kernel/acpi/wakeup_rm.S b/arch/x86/kernel/acpi/wakeup_rm.S
index 6ff3b57..6ce81ee 100644
--- a/arch/x86/kernel/acpi/wakeup_rm.S
+++ b/arch/x86/kernel/acpi/wakeup_rm.S
@@ -2,9 +2,11 @@
  * Wrapper script for the realmode binary as a transport object
  * before copying to low memory.
  */
-	.section ".rodata","a"
-	.globl	wakeup_code_start, wakeup_code_end
-wakeup_code_start:
+#include <asm/page_types.h>
+
+	.section ".x86_trampoline","a"
+	.balign PAGE_SIZE
+	.globl	acpi_wakeup_code
+acpi_wakeup_code:
 	.incbin	"arch/x86/kernel/acpi/realmode/wakeup.bin"
-wakeup_code_end:
 	.size	wakeup_code_start, .-wakeup_code_start
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 994ea20..a089fc1 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -937,13 +937,6 @@ void __init setup_arch(char **cmdline_p)
 
 	setup_trampolines();
 
-#ifdef CONFIG_ACPI_SLEEP
-	/*
-	 * Reserve low memory region for sleep support.
-	 * even before init_memory_mapping
-	 */
-	acpi_reserve_wakeup_memory();
-#endif
 	init_gbpages();
 
 	/* max_pfn_mapped is updated here */
diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
index d6a8cd1..e9fef94 100644
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -16,6 +16,7 @@
 #include <linux/device.h>
 #include <linux/suspend.h>
 #include <linux/reboot.h>
+#include <linux/acpi.h>
 
 #include <asm/io.h>
 
