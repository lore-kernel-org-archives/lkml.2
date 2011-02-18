Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751543Ab1BRFTy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 00:19:54 -0500
Received: from hera.kernel.org ([140.211.167.34]:55474 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750842Ab1BRFTv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 00:19:51 -0500
Date: Fri, 18 Feb 2011 05:19:03 GMT
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
Subject: [tip:x86/trampoline] x86, trampoline: Common infrastructure for low memory trampolines
Message-ID: <tip-4822b7fc6d4870685a9feadfc348d48f5e47460a@git.kernel.org>
Git-Commit-ID: 4822b7fc6d4870685a9feadfc348d48f5e47460a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 18 Feb 2011 05:19:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4822b7fc6d4870685a9feadfc348d48f5e47460a
Gitweb:     http://git.kernel.org/tip/4822b7fc6d4870685a9feadfc348d48f5e47460a
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Mon, 14 Feb 2011 15:34:57 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 17 Feb 2011 21:02:43 -0800

x86, trampoline: Common infrastructure for low memory trampolines

Common infrastructure for low memory trampolines.  This code installs
the trampolines permanently in low memory very early.  It also permits
multiple pieces of code to be used for this purpose.

This code also introduces a standard infrastructure for computing
symbol addresses in the trampoline code.

The only change to the actual SMP trampolines themselves is that the
64-bit trampoline has been made reusable -- the previous version would
overwrite the code with a status variable; this moves the status
variable to a separate location.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
LKML-Reference: <4D5DFBE4.7090104@intel.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Matthieu Castet <castet.matthieu@free.fr>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/x86/Kconfig                |    4 ---
 arch/x86/kernel/Makefile        |    3 +-
 arch/x86/kernel/head32.c        |    9 --------
 arch/x86/kernel/head_64.S       |    3 +-
 arch/x86/kernel/setup.c         |    2 +-
 arch/x86/kernel/smpboot.c       |   10 +++++---
 arch/x86/kernel/trampoline.c    |   42 ++++++++++++++++++++------------------
 arch/x86/kernel/trampoline_32.S |   15 ++++++++++---
 arch/x86/kernel/trampoline_64.S |   30 ++++++++++++++++-----------
 arch/x86/kernel/vmlinux.lds.S   |   13 ++++++++++++
 10 files changed, 73 insertions(+), 58 deletions(-)

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
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 34244b2..2e8ce0d 100644
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
@@ -69,7 +69,6 @@ obj-$(CONFIG_SMP)		+= smp.o
 obj-$(CONFIG_SMP)		+= smpboot.o tsc_sync.o
 obj-$(CONFIG_SMP)		+= setup_percpu.o
 obj-$(CONFIG_X86_64_SMP)	+= tsc_sync.o
-obj-$(CONFIG_X86_TRAMPOLINE)	+= trampoline_$(BITS).o
 obj-$(CONFIG_X86_MPPARSE)	+= mpparse.o
 obj-y				+= apic/
 obj-$(CONFIG_X86_REBOOTFIXUPS)	+= reboot_fixups_32.o
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
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index d3cfe26..994ea20 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -935,7 +935,7 @@ void __init setup_arch(char **cmdline_p)
 	printk(KERN_DEBUG "initial memory mapped : 0 - %08lx\n",
 			max_pfn_mapped<<PAGE_SHIFT);
 
-	reserve_trampoline_memory();
+	setup_trampolines();
 
 #ifdef CONFIG_ACPI_SLEEP
 	/*
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
index 075d130..49c77a6 100644
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
@@ -156,6 +156,12 @@ startup_64_vector:
 	.long	startup_64 - r_base
 	.word	__KERNEL_CS, 0
 
+	.balign 4
+fixup_base:
+	.long	0
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
