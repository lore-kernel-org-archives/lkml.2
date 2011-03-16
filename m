Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385Ab1CPPeG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 11:34:06 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48137 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752834Ab1CPPd5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 11:33:57 -0400
Date: Wed, 16 Mar 2011 16:33:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/trampoline changes for v2.6.39
Message-ID: <20110316153343.GA31567@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-trampoline-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-trampoline-for-linus


out-of-topic modifications in x86-trampoline-for-linus:
-------------------------------------------------------
drivers/acpi/sleep.c               # d1ee433: x86, trampoline: Use the unified 

 Thanks,

	Ingo

------------------>
H. Peter Anvin (6):
      x86, trampoline: Common infrastructure for low memory trampolines
      x86, trampoline: Use the unified trampoline setup for ACPI wakeup
      x86: Make the GDT_ENTRY() macro in <asm/segment.h> safe for assembly
      x86, reboot: Move the real-mode reboot code to an assembly file
      x86, reboot: Fix the use of passed arguments in 32-bit BIOS reboot
      x86-64, trampoline: Remove unused variable

Sedat Dilek (1):
      x86: Fix binutils-2.21 symbol related build failures


 arch/x86/Kconfig                           |    4 -
 arch/x86/include/asm/acpi.h                |    4 +-
 arch/x86/include/asm/reboot.h              |    5 +-
 arch/x86/include/asm/segment.h             |   12 ++-
 arch/x86/include/asm/trampoline.h          |   33 +++++---
 arch/x86/kernel/Makefile                   |    4 +-
 arch/x86/kernel/acpi/realmode/wakeup.S     |   21 +++--
 arch/x86/kernel/acpi/realmode/wakeup.h     |    5 +-
 arch/x86/kernel/acpi/realmode/wakeup.lds.S |   28 +++---
 arch/x86/kernel/acpi/sleep.c               |   65 ++------------
 arch/x86/kernel/acpi/sleep.h               |    3 -
 arch/x86/kernel/acpi/wakeup_rm.S           |   12 ++-
 arch/x86/kernel/apm_32.c                   |   12 +---
 arch/x86/kernel/entry_32.S                 |    2 +-
 arch/x86/kernel/head32.c                   |    9 --
 arch/x86/kernel/head_64.S                  |    3 +-
 arch/x86/kernel/reboot.c                   |  120 +++++-------------------
 arch/x86/kernel/reboot_32.S                |  135 ++++++++++++++++++++++++++++
 arch/x86/kernel/setup.c                    |    9 +--
 arch/x86/kernel/smpboot.c                  |   10 ++-
 arch/x86/kernel/trampoline.c               |   42 +++++----
 arch/x86/kernel/trampoline_32.S            |   15 +++-
 arch/x86/kernel/trampoline_64.S            |   28 ++++---
 arch/x86/kernel/vmlinux.lds.S              |   13 +++
 drivers/acpi/sleep.c                       |    1 +
 25 files changed, 315 insertions(+), 280 deletions(-)
 create mode 100644 arch/x86/kernel/reboot_32.S

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index d5ed94d..1359bc9 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -217,10 +217,6 @@ config X86_HT
 	def_bool y
 	depends on SMP
 
-config X86_TRAMPOLINE
-	def_bool y
-	depends on SMP || (64BIT && ACPI_SLEEP)
-
 config X86_32_LAZY_GS
 	def_bool y
 	depends on X86_32 && !CC_STACKPROTECTOR
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
diff --git a/arch/x86/include/asm/reboot.h b/arch/x86/include/asm/reboot.h
index 562d4fd..3250e3d 100644
--- a/arch/x86/include/asm/reboot.h
+++ b/arch/x86/include/asm/reboot.h
@@ -18,7 +18,10 @@ extern struct machine_ops machine_ops;
 
 void native_machine_crash_shutdown(struct pt_regs *regs);
 void native_machine_shutdown(void);
-void machine_real_restart(const unsigned char *code, int length);
+void machine_real_restart(unsigned int type);
+/* These must match dispatch_table in reboot_32.S */
+#define MRR_BIOS	0
+#define MRR_APM		1
 
 typedef void (*nmi_shootdown_cb)(int, struct die_args*);
 void nmi_shootdown_cpus(nmi_shootdown_cb callback);
diff --git a/arch/x86/include/asm/segment.h b/arch/x86/include/asm/segment.h
index 231f1c1..cd84f72 100644
--- a/arch/x86/include/asm/segment.h
+++ b/arch/x86/include/asm/segment.h
@@ -1,14 +1,16 @@
 #ifndef _ASM_X86_SEGMENT_H
 #define _ASM_X86_SEGMENT_H
 
+#include <linux/const.h>
+
 /* Constructor for a conventional segment GDT (or LDT) entry */
 /* This is a macro so it can be used in initializers */
 #define GDT_ENTRY(flags, base, limit)			\
-	((((base)  & 0xff000000ULL) << (56-24)) |	\
-	 (((flags) & 0x0000f0ffULL) << 40) |		\
-	 (((limit) & 0x000f0000ULL) << (48-16)) |	\
-	 (((base)  & 0x00ffffffULL) << 16) |		\
-	 (((limit) & 0x0000ffffULL)))
+	((((base)  & _AC(0xff000000,ULL)) << (56-24)) |	\
+	 (((flags) & _AC(0x0000f0ff,ULL)) << 40) |	\
+	 (((limit) & _AC(0x000f0000,ULL)) << (48-16)) |	\
+	 (((base)  & _AC(0x00ffffff,ULL)) << 16) |	\
+	 (((limit) & _AC(0x0000ffff,ULL))))
 
 /* Simple and small GDT entries for booting only */
 
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
 
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 34244b2..778c5b93 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -47,7 +47,7 @@ obj-y			+= tsc.o io_delay.o rtc.o
 obj-y			+= pci-iommu_table.o
 obj-y			+= resource.o
 
-obj-$(CONFIG_X86_TRAMPOLINE)	+= trampoline.o
+obj-y				+= trampoline.o trampoline_$(BITS).o
 obj-y				+= process.o
 obj-y				+= i387.o xsave.o
 obj-y				+= ptrace.o
@@ -59,6 +59,7 @@ obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
 obj-y				+= cpu/
 obj-y				+= acpi/
 obj-y				+= reboot.o
+obj-$(CONFIG_X86_32)		+= reboot_32.o
 obj-$(CONFIG_MCA)		+= mca_32.o
 obj-$(CONFIG_X86_MSR)		+= msr.o
 obj-$(CONFIG_X86_CPUID)		+= cpuid.o
@@ -69,7 +70,6 @@ obj-$(CONFIG_SMP)		+= smp.o
 obj-$(CONFIG_SMP)		+= smpboot.o tsc_sync.o
 obj-$(CONFIG_SMP)		+= setup_percpu.o
 obj-$(CONFIG_X86_64_SMP)	+= tsc_sync.o
-obj-$(CONFIG_X86_TRAMPOLINE)	+= trampoline_$(BITS).o
 obj-$(CONFIG_X86_MPPARSE)	+= mpparse.o
 obj-y				+= apic/
 obj-$(CONFIG_X86_REBOOTFIXUPS)	+= reboot_fixups_32.o
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
index 6ff3b57..63b8ab5 100644
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
-	.size	wakeup_code_start, .-wakeup_code_start
+	.size	acpi_wakeup_code, .-acpi_wakeup_code
diff --git a/arch/x86/kernel/apm_32.c b/arch/x86/kernel/apm_32.c
index 0e4f24c..b929108 100644
--- a/arch/x86/kernel/apm_32.c
+++ b/arch/x86/kernel/apm_32.c
@@ -975,20 +975,10 @@ recalc:
 
 static void apm_power_off(void)
 {
-	unsigned char po_bios_call[] = {
-		0xb8, 0x00, 0x10,	/* movw  $0x1000,ax  */
-		0x8e, 0xd0,		/* movw  ax,ss       */
-		0xbc, 0x00, 0xf0,	/* movw  $0xf000,sp  */
-		0xb8, 0x07, 0x53,	/* movw  $0x5307,ax  */
-		0xbb, 0x01, 0x00,	/* movw  $0x0001,bx  */
-		0xb9, 0x03, 0x00,	/* movw  $0x0003,cx  */
-		0xcd, 0x15		/* int   $0x15       */
-	};
-
 	/* Some bioses don't like being called from CPU != 0 */
 	if (apm_info.realmode_power_off) {
 		set_cpus_allowed_ptr(current, cpumask_of(0));
-		machine_real_restart(po_bios_call, sizeof(po_bios_call));
+		machine_real_restart(MRR_APM);
 	} else {
 		(void)set_system_power_state(APM_STATE_OFF);
 	}
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index c8b4efa..9ca3b0e 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -1413,7 +1413,7 @@ ENTRY(async_page_fault)
 	CFI_ADJUST_CFA_OFFSET 4
 	jmp error_code
 	CFI_ENDPROC
-END(apf_page_fault)
+END(async_page_fault)
 #endif
 
 /*
diff --git a/arch/x86/kernel/head32.c b/arch/x86/kernel/head32.c
index 7f138b3..d6d6bb3 100644
--- a/arch/x86/kernel/head32.c
+++ b/arch/x86/kernel/head32.c
@@ -34,15 +34,6 @@ void __init i386_start_kernel(void)
 {
 	memblock_init();
 
-#ifdef CONFIG_X86_TRAMPOLINE
-	/*
-	 * But first pinch a few for the stack/trampoline stuff
-	 * FIXME: Don't need the extra page at 4K, but need to fix
-	 * trampoline before removing it. (see the GDT stuff)
-	 */
-	memblock_x86_reserve_range(PAGE_SIZE, PAGE_SIZE + PAGE_SIZE, "EX TRAMPOLINE");
-#endif
-
 	memblock_x86_reserve_range(__pa_symbol(&_text), __pa_symbol(&__bss_stop), "TEXT DATA BSS");
 
 #ifdef CONFIG_BLK_DEV_INITRD
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 239046b..e11e394 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -136,10 +136,9 @@ ident_complete:
 	/* Fixup phys_base */
 	addq	%rbp, phys_base(%rip)
 
-#ifdef CONFIG_X86_TRAMPOLINE
+	/* Fixup trampoline */
 	addq	%rbp, trampoline_level4_pgt + 0(%rip)
 	addq	%rbp, trampoline_level4_pgt + (511*8)(%rip)
-#endif
 
 	/* Due to ENTRY(), sometimes the empty space gets filled with
 	 * zeros. Better take a jmp than relying on empty space being
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index fc7aae1..10c6619 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -295,68 +295,16 @@ static int __init reboot_init(void)
 }
 core_initcall(reboot_init);
 
-/* The following code and data reboots the machine by switching to real
-   mode and jumping to the BIOS reset entry point, as if the CPU has
-   really been reset.  The previous version asked the keyboard
-   controller to pulse the CPU reset line, which is more thorough, but
-   doesn't work with at least one type of 486 motherboard.  It is easy
-   to stop this code working; hence the copious comments. */
-static const unsigned long long
-real_mode_gdt_entries [3] =
-{
-	0x0000000000000000ULL,	/* Null descriptor */
-	0x00009b000000ffffULL,	/* 16-bit real-mode 64k code at 0x00000000 */
-	0x000093000100ffffULL	/* 16-bit real-mode 64k data at 0x00000100 */
-};
+extern const unsigned char machine_real_restart_asm[];
+extern const u64 machine_real_restart_gdt[3];
 
-static const struct desc_ptr
-real_mode_gdt = { sizeof (real_mode_gdt_entries) - 1, (long)real_mode_gdt_entries },
-real_mode_idt = { 0x3ff, 0 };
-
-/* This is 16-bit protected mode code to disable paging and the cache,
-   switch to real mode and jump to the BIOS reset code.
-
-   The instruction that switches to real mode by writing to CR0 must be
-   followed immediately by a far jump instruction, which set CS to a
-   valid value for real mode, and flushes the prefetch queue to avoid
-   running instructions that have already been decoded in protected
-   mode.
-
-   Clears all the flags except ET, especially PG (paging), PE
-   (protected-mode enable) and TS (task switch for coprocessor state
-   save).  Flushes the TLB after paging has been disabled.  Sets CD and
-   NW, to disable the cache on a 486, and invalidates the cache.  This
-   is more like the state of a 486 after reset.  I don't know if
-   something else should be done for other chips.
-
-   More could be done here to set up the registers as if a CPU reset had
-   occurred; hopefully real BIOSs don't assume much. */
-static const unsigned char real_mode_switch [] =
-{
-	0x66, 0x0f, 0x20, 0xc0,			/*    movl  %cr0,%eax        */
-	0x66, 0x83, 0xe0, 0x11,			/*    andl  $0x00000011,%eax */
-	0x66, 0x0d, 0x00, 0x00, 0x00, 0x60,	/*    orl   $0x60000000,%eax */
-	0x66, 0x0f, 0x22, 0xc0,			/*    movl  %eax,%cr0        */
-	0x66, 0x0f, 0x22, 0xd8,			/*    movl  %eax,%cr3        */
-	0x66, 0x0f, 0x20, 0xc3,			/*    movl  %cr0,%ebx        */
-	0x66, 0x81, 0xe3, 0x00, 0x00, 0x00, 0x60,	/*    andl  $0x60000000,%ebx */
-	0x74, 0x02,				/*    jz    f                */
-	0x0f, 0x09,				/*    wbinvd                 */
-	0x24, 0x10,				/* f: andb  $0x10,al         */
-	0x66, 0x0f, 0x22, 0xc0			/*    movl  %eax,%cr0        */
-};
-static const unsigned char jump_to_bios [] =
+void machine_real_restart(unsigned int type)
 {
-	0xea, 0x00, 0x00, 0xff, 0xff		/*    ljmp  $0xffff,$0x0000  */
-};
+	void *restart_va;
+	unsigned long restart_pa;
+	void (*restart_lowmem)(unsigned int);
+	u64 *lowmem_gdt;
 
-/*
- * Switch to real mode and then execute the code
- * specified by the code and length parameters.
- * We assume that length will aways be less that 100!
- */
-void machine_real_restart(const unsigned char *code, int length)
-{
 	local_irq_disable();
 
 	/* Write zero to CMOS register number 0x0f, which the BIOS POST
@@ -384,41 +332,23 @@ void machine_real_restart(const unsigned char *code, int length)
 	   too. */
 	*((unsigned short *)0x472) = reboot_mode;
 
-	/* For the switch to real mode, copy some code to low memory.  It has
-	   to be in the first 64k because it is running in 16-bit mode, and it
-	   has to have the same physical and virtual address, because it turns
-	   off paging.  Copy it near the end of the first page, out of the way
-	   of BIOS variables. */
-	memcpy((void *)(0x1000 - sizeof(real_mode_switch) - 100),
-		real_mode_switch, sizeof (real_mode_switch));
-	memcpy((void *)(0x1000 - 100), code, length);
-
-	/* Set up the IDT for real mode. */
-	load_idt(&real_mode_idt);
-
-	/* Set up a GDT from which we can load segment descriptors for real
-	   mode.  The GDT is not used in real mode; it is just needed here to
-	   prepare the descriptors. */
-	load_gdt(&real_mode_gdt);
-
-	/* Load the data segment registers, and thus the descriptors ready for
-	   real mode.  The base address of each segment is 0x100, 16 times the
-	   selector value being loaded here.  This is so that the segment
-	   registers don't have to be reloaded after switching to real mode:
-	   the values are consistent for real mode operation already. */
-	__asm__ __volatile__ ("movl $0x0010,%%eax\n"
-				"\tmovl %%eax,%%ds\n"
-				"\tmovl %%eax,%%es\n"
-				"\tmovl %%eax,%%fs\n"
-				"\tmovl %%eax,%%gs\n"
-				"\tmovl %%eax,%%ss" : : : "eax");
-
-	/* Jump to the 16-bit code that we copied earlier.  It disables paging
-	   and the cache, switches to real mode, and jumps to the BIOS reset
-	   entry point. */
-	__asm__ __volatile__ ("ljmp $0x0008,%0"
-				:
-				: "i" ((void *)(0x1000 - sizeof (real_mode_switch) - 100)));
+	/* Patch the GDT in the low memory trampoline */
+	lowmem_gdt = TRAMPOLINE_SYM(machine_real_restart_gdt);
+
+	restart_va = TRAMPOLINE_SYM(machine_real_restart_asm);
+	restart_pa = virt_to_phys(restart_va);
+	restart_lowmem = (void (*)(unsigned int))restart_pa;
+
+	/* GDT[0]: GDT self-pointer */
+	lowmem_gdt[0] =
+		(u64)(sizeof(machine_real_restart_gdt) - 1) +
+		((u64)virt_to_phys(lowmem_gdt) << 16);
+	/* GDT[1]: 64K real mode code segment */
+	lowmem_gdt[1] =
+		GDT_ENTRY(0x009b, restart_pa, 0xffff);
+
+	/* Jump to the identity-mapped low memory code */
+	restart_lowmem(type);
 }
 #ifdef CONFIG_APM_MODULE
 EXPORT_SYMBOL(machine_real_restart);
@@ -573,7 +503,7 @@ static void native_machine_emergency_restart(void)
 
 #ifdef CONFIG_X86_32
 		case BOOT_BIOS:
-			machine_real_restart(jump_to_bios, sizeof(jump_to_bios));
+			machine_real_restart(MRR_BIOS);
 
 			reboot_type = BOOT_KBD;
 			break;
diff --git a/arch/x86/kernel/reboot_32.S b/arch/x86/kernel/reboot_32.S
new file mode 100644
index 0000000..29092b3
--- /dev/null
+++ b/arch/x86/kernel/reboot_32.S
@@ -0,0 +1,135 @@
+#include <linux/linkage.h>
+#include <linux/init.h>
+#include <asm/segment.h>
+#include <asm/page_types.h>
+
+/*
+ * The following code and data reboots the machine by switching to real
+ * mode and jumping to the BIOS reset entry point, as if the CPU has
+ * really been reset.  The previous version asked the keyboard
+ * controller to pulse the CPU reset line, which is more thorough, but
+ * doesn't work with at least one type of 486 motherboard.  It is easy
+ * to stop this code working; hence the copious comments.
+ *
+ * This code is called with the restart type (0 = BIOS, 1 = APM) in %eax.
+ */
+	.section ".x86_trampoline","a"
+	.balign 16
+	.code32
+ENTRY(machine_real_restart_asm)
+r_base = .
+	/* Get our own relocated address */
+	call	1f
+1:	popl	%ebx
+	subl	$1b, %ebx
+
+	/* Compute the equivalent real-mode segment */
+	movl	%ebx, %ecx
+	shrl	$4, %ecx
+	
+	/* Patch post-real-mode segment jump */
+	movw	dispatch_table(%ebx,%eax,2),%ax
+	movw	%ax, 101f(%ebx)
+	movw	%cx, 102f(%ebx)
+
+	/* Set up the IDT for real mode. */
+	lidtl	machine_real_restart_idt(%ebx)
+
+	/*
+	 * Set up a GDT from which we can load segment descriptors for real
+	 * mode.  The GDT is not used in real mode; it is just needed here to
+	 * prepare the descriptors.
+	 */
+	lgdtl	machine_real_restart_gdt(%ebx)
+
+	/*
+	 * Load the data segment registers with 16-bit compatible values
+	 */
+	movl	$16, %ecx
+	movl	%ecx, %ds
+	movl	%ecx, %es
+	movl	%ecx, %fs
+	movl	%ecx, %gs
+	movl	%ecx, %ss
+	ljmpl	$8, $1f - r_base
+
+/*
+ * This is 16-bit protected mode code to disable paging and the cache,
+ * switch to real mode and jump to the BIOS reset code.
+ *
+ * The instruction that switches to real mode by writing to CR0 must be
+ * followed immediately by a far jump instruction, which set CS to a
+ * valid value for real mode, and flushes the prefetch queue to avoid
+ * running instructions that have already been decoded in protected
+ * mode.
+ *
+ * Clears all the flags except ET, especially PG (paging), PE
+ * (protected-mode enable) and TS (task switch for coprocessor state
+ * save).  Flushes the TLB after paging has been disabled.  Sets CD and
+ * NW, to disable the cache on a 486, and invalidates the cache.  This
+ * is more like the state of a 486 after reset.  I don't know if
+ * something else should be done for other chips.
+ *
+ * More could be done here to set up the registers as if a CPU reset had
+ * occurred; hopefully real BIOSs don't assume much.  This is not the
+ * actual BIOS entry point, anyway (that is at 0xfffffff0).
+ *
+ * Most of this work is probably excessive, but it is what is tested.
+ */
+	.code16
+1:
+	xorl	%ecx, %ecx
+	movl	%cr0, %eax
+	andl	$0x00000011, %eax
+	orl	$0x60000000, %eax
+	movl	%eax, %cr0
+	movl	%ecx, %cr3
+	movl	%cr0, %edx
+	andl	$0x60000000, %edx	/* If no cache bits -> no wbinvd */
+	jz	2f
+	wbinvd
+2:
+	andb	$0x10, %al
+	movl	%eax, %cr0
+	.byte	0xea			/* ljmpw */
+101:	.word	0			/* Offset */
+102:	.word	0			/* Segment */
+
+bios:
+	ljmpw	$0xf000, $0xfff0
+
+apm:
+	movw	$0x1000, %ax
+	movw	%ax, %ss
+	movw	$0xf000, %sp
+	movw	$0x5307, %ax
+	movw	$0x0001, %bx
+	movw	$0x0003, %cx
+	int	$0x15
+
+END(machine_real_restart_asm)
+
+	.balign 16
+	/* These must match <asm/reboot.h */
+dispatch_table:
+	.word	bios - r_base
+	.word	apm - r_base
+END(dispatch_table)
+
+	.balign 16
+machine_real_restart_idt:
+	.word	0xffff		/* Length - real mode default value */
+	.long	0		/* Base - real mode default value */
+END(machine_real_restart_idt)
+
+	.balign 16
+ENTRY(machine_real_restart_gdt)
+	.quad	0		/* Self-pointer, filled in by PM code */
+	.quad	0		/* 16-bit code segment, filled in by PM code */
+	/*
+	 * 16-bit data segment with the selector value 16 = 0x10 and
+	 * base value 0x100; since this is consistent with real mode
+	 * semantics we don't have to reload the segments once CR0.PE = 0.
+	 */
+	.quad	GDT_ENTRY(0x0093, 0x100, 0xffff)
+END(machine_real_restart_gdt)
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index d3cfe26..a089fc1 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -935,15 +935,8 @@ void __init setup_arch(char **cmdline_p)
 	printk(KERN_DEBUG "initial memory mapped : 0 - %08lx\n",
 			max_pfn_mapped<<PAGE_SHIFT);
 
-	reserve_trampoline_memory();
+	setup_trampolines();
 
-#ifdef CONFIG_ACPI_SLEEP
-	/*
-	 * Reserve low memory region for sleep support.
-	 * even before init_memory_mapping
-	 */
-	acpi_reserve_wakeup_memory();
-#endif
 	init_gbpages();
 
 	/* max_pfn_mapped is updated here */
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 08776a9..5452733 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -788,7 +788,7 @@ do_rest:
 	stack_start  = c_idle.idle->thread.sp;
 
 	/* start_ip had better be page-aligned! */
-	start_ip = setup_trampoline();
+	start_ip = trampoline_address();
 
 	/* So we see what's up */
 	announce_cpu(cpu, apicid);
@@ -798,6 +798,8 @@ do_rest:
 	 * the targeted processor.
 	 */
 
+	printk(KERN_DEBUG "smpboot cpu %d: start_ip = %lx\n", cpu, start_ip);
+
 	atomic_set(&init_deasserted, 0);
 
 	if (get_uv_system_type() != UV_NON_UNIQUE_APIC) {
@@ -851,8 +853,8 @@ do_rest:
 			pr_debug("CPU%d: has booted.\n", cpu);
 		else {
 			boot_error = 1;
-			if (*((volatile unsigned char *)trampoline_base)
-					== 0xA5)
+			if (*(volatile u32 *)TRAMPOLINE_SYM(trampoline_status)
+			    == 0xA5A5A5A5)
 				/* trampoline started but...? */
 				pr_err("CPU%d: Stuck ??\n", cpu);
 			else
@@ -878,7 +880,7 @@ do_rest:
 	}
 
 	/* mark "stuck" area as not stuck */
-	*((volatile unsigned long *)trampoline_base) = 0;
+	*(volatile u32 *)TRAMPOLINE_SYM(trampoline_status) = 0;
 
 	if (get_uv_system_type() != UV_NON_UNIQUE_APIC) {
 		/*
diff --git a/arch/x86/kernel/trampoline.c b/arch/x86/kernel/trampoline.c
index a375616..a91ae77 100644
--- a/arch/x86/kernel/trampoline.c
+++ b/arch/x86/kernel/trampoline.c
@@ -2,39 +2,41 @@
 #include <linux/memblock.h>
 
 #include <asm/trampoline.h>
+#include <asm/cacheflush.h>
 #include <asm/pgtable.h>
 
-#if defined(CONFIG_X86_64) && defined(CONFIG_ACPI_SLEEP)
-#define __trampinit
-#define __trampinitdata
-#else
-#define __trampinit __cpuinit
-#define __trampinitdata __cpuinitdata
-#endif
+unsigned char *x86_trampoline_base;
 
-/* ready for x86_64 and x86 */
-unsigned char *__trampinitdata trampoline_base;
-
-void __init reserve_trampoline_memory(void)
+void __init setup_trampolines(void)
 {
 	phys_addr_t mem;
+	size_t size = PAGE_ALIGN(x86_trampoline_end - x86_trampoline_start);
 
 	/* Has to be in very low memory so we can execute real-mode AP code. */
-	mem = memblock_find_in_range(0, 1<<20, TRAMPOLINE_SIZE, PAGE_SIZE);
+	mem = memblock_find_in_range(0, 1<<20, size, PAGE_SIZE);
 	if (mem == MEMBLOCK_ERROR)
 		panic("Cannot allocate trampoline\n");
 
-	trampoline_base = __va(mem);
-	memblock_x86_reserve_range(mem, mem + TRAMPOLINE_SIZE, "TRAMPOLINE");
+	x86_trampoline_base = __va(mem);
+	memblock_x86_reserve_range(mem, mem + size, "TRAMPOLINE");
+
+	printk(KERN_DEBUG "Base memory trampoline at [%p] %llx size %zu\n",
+	       x86_trampoline_base, (unsigned long long)mem, size);
+
+	memcpy(x86_trampoline_base, x86_trampoline_start, size);
 }
 
 /*
- * Currently trivial. Write the real->protected mode
- * bootstrap into the page concerned. The caller
- * has made sure it's suitably aligned.
+ * setup_trampolines() gets called very early, to guarantee the
+ * availability of low memory.  This is before the proper kernel page
+ * tables are set up, so we cannot set page permissions in that
+ * function.  Thus, we use an arch_initcall instead.
  */
-unsigned long __trampinit setup_trampoline(void)
+static int __init configure_trampolines(void)
 {
-	memcpy(trampoline_base, trampoline_data, TRAMPOLINE_SIZE);
-	return virt_to_phys(trampoline_base);
+	size_t size = PAGE_ALIGN(x86_trampoline_end - x86_trampoline_start);
+
+	set_memory_x((unsigned long)x86_trampoline_base, size >> PAGE_SHIFT);
+	return 0;
 }
+arch_initcall(configure_trampolines);
diff --git a/arch/x86/kernel/trampoline_32.S b/arch/x86/kernel/trampoline_32.S
index 8508237..451c0a7 100644
--- a/arch/x86/kernel/trampoline_32.S
+++ b/arch/x86/kernel/trampoline_32.S
@@ -32,9 +32,11 @@
 #include <asm/segment.h>
 #include <asm/page_types.h>
 
-/* We can free up trampoline after bootup if cpu hotplug is not supported. */
-__CPUINITRODATA
-.code16
+#ifdef CONFIG_SMP
+
+	.section ".x86_trampoline","a"
+	.balign PAGE_SIZE
+	.code16
 
 ENTRY(trampoline_data)
 r_base = .
@@ -44,7 +46,7 @@ r_base = .
 
 	cli			# We should be safe anyway
 
-	movl	$0xA5A5A5A5, trampoline_data - r_base
+	movl	$0xA5A5A5A5, trampoline_status - r_base
 				# write marker for master knows we're running
 
 	/* GDT tables in non default location kernel can be beyond 16MB and
@@ -72,5 +74,10 @@ boot_idt_descr:
 	.word	0				# idt limit = 0
 	.long	0				# idt base = 0L
 
+ENTRY(trampoline_status)
+	.long	0
+
 .globl trampoline_end
 trampoline_end:
+
+#endif /* CONFIG_SMP */
diff --git a/arch/x86/kernel/trampoline_64.S b/arch/x86/kernel/trampoline_64.S
index 075d130..09ff517 100644
--- a/arch/x86/kernel/trampoline_64.S
+++ b/arch/x86/kernel/trampoline_64.S
@@ -32,13 +32,9 @@
 #include <asm/segment.h>
 #include <asm/processor-flags.h>
 
-#ifdef CONFIG_ACPI_SLEEP
-.section .rodata, "a", @progbits
-#else
-/* We can free up the trampoline after bootup if cpu hotplug is not supported. */
-__CPUINITRODATA
-#endif
-.code16
+	.section ".x86_trampoline","a"
+	.balign PAGE_SIZE
+	.code16
 
 ENTRY(trampoline_data)
 r_base = .
@@ -50,7 +46,7 @@ r_base = .
 	mov	%ax, %ss
 
 
-	movl	$0xA5A5A5A5, trampoline_data - r_base
+	movl	$0xA5A5A5A5, trampoline_status - r_base
 				# write marker for master knows we're running
 
 					# Setup stack
@@ -64,10 +60,13 @@ r_base = .
 	movzx	%ax, %esi		# Find the 32bit trampoline location
 	shll	$4, %esi
 
-					# Fixup the vectors
-	addl	%esi, startup_32_vector - r_base
-	addl	%esi, startup_64_vector - r_base
-	addl	%esi, tgdt + 2 - r_base	# Fixup the gdt pointer
+					# Fixup the absolute vectors
+	leal	(startup_32 - r_base)(%esi), %eax
+	movl	%eax, startup_32_vector - r_base
+	leal	(startup_64 - r_base)(%esi), %eax
+	movl	%eax, startup_64_vector - r_base
+	leal	(tgdt - r_base)(%esi), %eax
+	movl	%eax, (tgdt + 2 - r_base)
 
 	/*
 	 * GDT tables in non default location kernel can be beyond 16MB and
@@ -129,6 +128,7 @@ no_longmode:
 	jmp no_longmode
 #include "verify_cpu.S"
 
+	.balign 4
 	# Careful these need to be in the same 64K segment as the above;
 tidt:
 	.word	0			# idt limit = 0
@@ -156,6 +156,10 @@ startup_64_vector:
 	.long	startup_64 - r_base
 	.word	__KERNEL_CS, 0
 
+	.balign 4
+ENTRY(trampoline_status)
+	.long	0
+
 trampoline_stack:
 	.org 0x1000
 trampoline_stack_end:
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index bf47007..cb2c506 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -240,6 +240,18 @@ SECTIONS
 
 	INIT_DATA_SECTION(16)
 
+	/*
+	 * Code and data for a variety of lowlevel trampolines, to be
+	 * copied into base memory (< 1 MiB) during initialization.
+	 * Since it is copied early, the main copy can be discarded
+	 * afterwards.
+	 */
+	 .x86_trampoline : AT(ADDR(.x86_trampoline) - LOAD_OFFSET) {
+		x86_trampoline_start = .;
+		*(.x86_trampoline)
+		x86_trampoline_end = .;
+	}
+
 	.x86_cpu_dev.init : AT(ADDR(.x86_cpu_dev.init) - LOAD_OFFSET) {
 		__x86_cpu_dev_start = .;
 		*(.x86_cpu_dev.init)
@@ -291,6 +303,7 @@ SECTIONS
 		*(.iommu_table)
 		__iommu_table_end = .;
 	}
+
 	. = ALIGN(8);
 	/*
 	 * .exit.text is discard at runtime, not link time, to deal with
diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
index d6a8cd1..e9fef94d 100644
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -16,6 +16,7 @@
 #include <linux/device.h>
 #include <linux/suspend.h>
 #include <linux/reboot.h>
+#include <linux/acpi.h>
 
 #include <asm/io.h>
 
