Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751263Ab1BEGbY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 01:31:24 -0500
Received: from hera.kernel.org ([140.211.167.34]:46403 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945Ab1BEGbW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 01:31:22 -0500
Date: Sat, 5 Feb 2011 06:31:02 GMT
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        castet.matthieu@free.fr, kees.cook@canonical.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        castet.matthieu@free.fr, kees.cook@canonical.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <4D41E86D.8060205@free.fr>
References: <4D41E86D.8060205@free.fr>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86-32: Make sure the stack is set up before we use it
Message-ID: <tip-11d4c3f9b671720e80353dd7e433ff2bf65e9500@git.kernel.org>
Git-Commit-ID: 11d4c3f9b671720e80353dd7e433ff2bf65e9500
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 05 Feb 2011 06:31:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  11d4c3f9b671720e80353dd7e433ff2bf65e9500
Gitweb:     http://git.kernel.org/tip/11d4c3f9b671720e80353dd7e433ff2bf65e9500
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Fri, 4 Feb 2011 16:14:11 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 4 Feb 2011 22:27:28 -0800

x86-32: Make sure the stack is set up before we use it

Since checkin ebba638ae723d8a8fc2f7abce5ec18b688b791d7 we call
verify_cpu even in 32-bit mode.  Unfortunately, calling a function
means using the stack, and the stack pointer was not initialized in
the 32-bit setup code!  This code initializes the stack pointer, and
simplifies the interface slightly since it is easier to rely on just a
pointer value rather than a descriptor; we need to have different
values for the segment register anyway.

This retains start_stack as a virtual address, even though a physical
address would be more convenient for 32 bits; the 64-bit code wants
the other way around...

Reported-by: Matthieu Castet <castet.matthieu@free.fr>
LKML-Reference: <4D41E86D.8060205@free.fr>
Tested-by: Kees Cook <kees.cook@canonical.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/smp.h   |    5 +----
 arch/x86/kernel/acpi/sleep.c |    2 +-
 arch/x86/kernel/head_32.S    |   30 +++++++++++++-----------------
 arch/x86/kernel/smpboot.c    |    4 ++--
 4 files changed, 17 insertions(+), 24 deletions(-)

diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index 4c2f63c..1f46951 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -40,10 +40,7 @@ DECLARE_EARLY_PER_CPU(u16, x86_cpu_to_apicid);
 DECLARE_EARLY_PER_CPU(u16, x86_bios_cpu_apicid);
 
 /* Static state in head.S used to set up a CPU */
-extern struct {
-	void *sp;
-	unsigned short ss;
-} stack_start;
+extern unsigned long stack_start; /* Initial stack pointer address */
 
 struct smp_ops {
 	void (*smp_prepare_boot_cpu)(void);
diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index 69fd72a..4d9ebba 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -100,7 +100,7 @@ int acpi_save_state_mem(void)
 #else /* CONFIG_64BIT */
 	header->trampoline_segment = setup_trampoline() >> 4;
 #ifdef CONFIG_SMP
-	stack_start.sp = temp_stack + sizeof(temp_stack);
+	stack_start = (unsigned long)temp_stack + sizeof(temp_stack);
 	early_gdt_descr.address =
 			(unsigned long)get_cpu_gdt_table(smp_processor_id());
 	initial_gs = per_cpu_offset(smp_processor_id());
diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index fc293dc..767d6c4 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -85,6 +85,8 @@ RESERVE_BRK(pagetables, INIT_MAP_SIZE)
  */
 __HEAD
 ENTRY(startup_32)
+	movl pa(stack_start),%ecx
+	
 	/* test KEEP_SEGMENTS flag to see if the bootloader is asking
 		us to not reload segments */
 	testb $(1<<6), BP_loadflags(%esi)
@@ -99,7 +101,9 @@ ENTRY(startup_32)
 	movl %eax,%es
 	movl %eax,%fs
 	movl %eax,%gs
+	movl %eax,%ss
 2:
+	leal -__PAGE_OFFSET(%ecx),%esp
 
 /*
  * Clear BSS first so that there are no surprises...
@@ -145,8 +149,6 @@ ENTRY(startup_32)
  * _brk_end is set up to point to the first "safe" location.
  * Mappings are created both at virtual address 0 (identity mapping)
  * and PAGE_OFFSET for up to _end.
- *
- * Note that the stack is not yet set up!
  */
 #ifdef CONFIG_X86_PAE
 
@@ -282,6 +284,9 @@ ENTRY(startup_32_smp)
 	movl %eax,%es
 	movl %eax,%fs
 	movl %eax,%gs
+	movl pa(stack_start),%ecx
+	movl %eax,%ss
+	leal -__PAGE_OFFSET(%ecx),%esp
 #endif /* CONFIG_SMP */
 default_entry:
 
@@ -347,8 +352,8 @@ default_entry:
 	movl %eax,%cr0		/* ..and set paging (PG) bit */
 	ljmp $__BOOT_CS,$1f	/* Clear prefetch and normalize %eip */
 1:
-	/* Set up the stack pointer */
-	lss stack_start,%esp
+	/* Shift the stack pointer to a virtual address */
+	addl $__PAGE_OFFSET, %esp
 
 /*
  * Initialize eflags.  Some BIOS's leave bits like NT set.  This would
@@ -360,9 +365,7 @@ default_entry:
 
 #ifdef CONFIG_SMP
 	cmpb $0, ready
-	jz  1f				/* Initial CPU cleans BSS */
-	jmp checkCPUtype
-1:
+	jnz checkCPUtype
 #endif /* CONFIG_SMP */
 
 /*
@@ -470,14 +473,7 @@ is386:	movl $2,%ecx		# set MP
 
 	cld			# gcc2 wants the direction flag cleared at all times
 	pushl $0		# fake return address for unwinder
-#ifdef CONFIG_SMP
-	movb ready, %cl
 	movb $1, ready
-	cmpb $0,%cl		# the first CPU calls start_kernel
-	je   1f
-	movl (stack_start), %esp
-1:
-#endif /* CONFIG_SMP */
 	jmp *(initial_code)
 
 /*
@@ -670,15 +666,15 @@ ENTRY(initial_page_table)
 #endif
 
 .data
+.balign 4
 ENTRY(stack_start)
 	.long init_thread_union+THREAD_SIZE
-	.long __BOOT_DS
-
-ready:	.byte 0
 
 early_recursion_flag:
 	.long 0
 
+ready:	.byte 0
+
 int_msg:
 	.asciz "Unknown interrupt or fault at: %p %p %p\n"
 
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 0cbe8c0..03273b6 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -638,7 +638,7 @@ wakeup_secondary_cpu_via_init(int phys_apicid, unsigned long start_eip)
 	 * target processor state.
 	 */
 	startup_ipi_hook(phys_apicid, (unsigned long) start_secondary,
-			 (unsigned long)stack_start.sp);
+			 stack_start);
 
 	/*
 	 * Run STARTUP IPI loop.
@@ -785,7 +785,7 @@ do_rest:
 #endif
 	early_gdt_descr.address = (unsigned long)get_cpu_gdt_table(cpu);
 	initial_code = (unsigned long)start_secondary;
-	stack_start.sp = (void *) c_idle.idle->thread.sp;
+	stack_start  = c_idle.idle->thread.sp;
 
 	/* start_ip had better be page-aligned! */
 	start_ip = setup_trampoline();
