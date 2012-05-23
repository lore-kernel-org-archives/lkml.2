Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757006Ab2EWIH3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 04:07:29 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:50920 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755407Ab2EWIGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 04:06:53 -0400
Date: Wed, 23 May 2012 10:06:41 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/extable changes for v3.5
Message-ID: <20120523080641.GA12893@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-extable-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-extable-for-linus

   HEAD: 8b5ad472991796b2347464922c72de2ca5a028f3 Revert "x86, extable: Disable presorted exception table for now"

The biggest change here is to allow the build-time sorting of 
the exception table, to speed up booting. This is achieved by 
the architecture enabling BUILDTIME_EXTABLE_SORT. This option is 
enabled for x86 and MIPS currently.

On x86 a number of fixes and changes were needed to allow 
build-time sorting of the exception table, in particular a 
relocation invariant exception table format was needed. This 
required the abstracting out of exception table protocol and the 
removal of 20 years of accumulated assumptions about the x86 
exception table format.

While at it, this tree also cleans up various other aspects of 
exception handling, such as early(er) exception handling for 
rdmsr_safe() et al.

All in one, as the result of these changes the x86 exception 
code is now pretty nice and modern. As an added bonus any 
regressions in this code will be early and violent crashes, so 
if you see any of those, you'll know whom to blame!

out-of-topic modifications in x86-extable-for-linus:
----------------------------------------------------
Makefile                           # 1dbdc6f: kbuild/extable: Hook up sortextab
arch/mips/Kconfig                  # 4b05449: MIPS: Select BUILDTIME_EXTABLE_SO
init/Kconfig                       # 1dbdc6f: kbuild/extable: Hook up sortextab
kernel/extable.c                   # d219e2e: extable: Skip sorting if sorted a
scripts/.gitignore                 # a79f248: scripts: Add sortextable to sort 
scripts/Makefile                   # d59a168: scripts/sortextable: Handle relat
                                   # a79f248: scripts: Add sortextable to sort 
scripts/sortextable.c              # d59a168: scripts/sortextable: Handle relat
                                   # a79f248: scripts: Add sortextable to sort 
scripts/sortextable.h              # d59a168: scripts/sortextable: Handle relat
                                   # a79f248: scripts: Add sortextable to sort 

 Thanks,

	Ingo

------------------>
David Daney (7):
      scripts: Add sortextable to sort the kernel's exception table.
      extable: Skip sorting if sorted at build time.
      kbuild/extable: Hook up sortextable into the build system.
      MIPS: Select BUILDTIME_EXTABLE_SORT
      x86: Select BUILDTIME_EXTABLE_SORT
      scripts/sortextable: Handle relative entries, and other cleanups
      Revert "x86, extable: Disable presorted exception table for now"

H. Peter Anvin (28):
      x86, nop: Make the ASM_NOP* macros work from assembly
      x86: Add symbolic constant for exceptions with error code
      x86, paravirt: Replace GET_CR2_INTO_RCX with GET_CR2_INTO_RAX
      x86, extable: Add early_fixup_exception()
      x86-64: Handle exception table entries during early boot
      x86-32: Handle exception table entries during early boot
      x86, doc: Revert "x86: Document rdmsr_safe restrictions"
      x86, extable: Use .pushsection ... .popsection for _ASM_EXTABLE()
      x86, extable: Remove open-coded exception table entries in arch/x86/ia32/ia32entry.S
      x86, extable: Remove open-coded exception table entries in arch/x86/kernel/entry_32.S
      x86, extable: Remove open-coded exception table entries in arch/x86/kernel/entry_64.S
      x86, extable: Remove open-coded exception table entries in arch/x86/kernel/test_rodata.c
      x86, extable: Remove open-coded exception table entries in arch/x86/lib/checksum_32.S
      x86, extable: Remove open-coded exception table entries in arch/x86/lib/copy_user_64.S
      x86, extable: Remove open-coded exception table entries in arch/x86/lib/copy_user_nocache_64.S
      x86, extable: Remove open-coded exception table entries in arch/x86/lib/csum-copy_64.S
      x86, extable: Remove open-coded exception table entries in arch/x86/lib/getuser.S
      x86, extable: Remove open-coded exception table entries in arch/x86/lib/putuser.S
      x86, extable: Remove open-coded exception table entries in arch/x86/lib/usercopy_32.c
      x86, extable: Remove open-coded exception table entries in arch/x86/um/checksum_32.S
      x86, extable: Remove open-coded exception table entries in arch/x86/xen/xen-asm_32.S
      x86, extable: Remove the now-unused __ASM_EX_SEC macros
      x86, extable: Remove open-coded exception table entries in arch/x86/include/asm/kvm_host.h
      x86, extable: Remove open-coded exception table entries in arch/x86/include/asm/xsave.h
      x86, extable: Remove open-coded exception table entries in arch/x86/ia32/ia32entry.S
      x86, extable: Add _ASM_EXTABLE_EX() macro
      x86, extable: Disable presorted exception table for now
      x86, extable: Switch to relative exception table entries


 Makefile                            |  10 ++
 arch/mips/Kconfig                   |   1 +
 arch/x86/Kconfig                    |   1 +
 arch/x86/ia32/ia32entry.S           |   9 +-
 arch/x86/include/asm/asm.h          |  38 +++--
 arch/x86/include/asm/kvm_host.h     |   5 +-
 arch/x86/include/asm/msr.h          |   9 +-
 arch/x86/include/asm/nops.h         |   4 +
 arch/x86/include/asm/paravirt.h     |   6 +-
 arch/x86/include/asm/segment.h      |   4 +-
 arch/x86/include/asm/uaccess.h      |  25 +--
 arch/x86/include/asm/xsave.h        |  10 +-
 arch/x86/kernel/entry_32.S          |  47 ++----
 arch/x86/kernel/entry_64.S          |  16 +-
 arch/x86/kernel/head_32.S           | 223 ++++++++++++++-----------
 arch/x86/kernel/head_64.S           |  80 ++++++---
 arch/x86/kernel/test_rodata.c       |  10 +-
 arch/x86/lib/checksum_32.S          |   9 +-
 arch/x86/lib/copy_user_64.S         |  63 +++----
 arch/x86/lib/copy_user_nocache_64.S |  50 +++---
 arch/x86/lib/csum-copy_64.S         |  16 +-
 arch/x86/lib/getuser.S              |   9 +-
 arch/x86/lib/putuser.S              |  12 +-
 arch/x86/lib/usercopy_32.c          | 232 ++++++++++++--------------
 arch/x86/mm/extable.c               | 142 +++++++++++++++-
 arch/x86/um/checksum_32.S           |   9 +-
 arch/x86/xen/xen-asm_32.S           |   6 +-
 init/Kconfig                        |   3 +
 kernel/extable.c                    |   8 +-
 scripts/.gitignore                  |   1 +
 scripts/Makefile                    |   3 +
 scripts/sortextable.c               | 322 ++++++++++++++++++++++++++++++++++++
 scripts/sortextable.h               | 191 +++++++++++++++++++++
 33 files changed, 1118 insertions(+), 456 deletions(-)
 create mode 100644 scripts/sortextable.c
 create mode 100644 scripts/sortextable.h

diff --git a/Makefile b/Makefile
index f6578f4..622c918 100644
--- a/Makefile
+++ b/Makefile
@@ -784,6 +784,10 @@ quiet_cmd_vmlinux_version = GEN     .version
 quiet_cmd_sysmap = SYSMAP
       cmd_sysmap = $(CONFIG_SHELL) $(srctree)/scripts/mksysmap
 
+# Sort exception table at build time
+quiet_cmd_sortextable = SORTEX
+      cmd_sortextable = $(objtree)/scripts/sortextable
+
 # Link of vmlinux
 # If CONFIG_KALLSYMS is set .version is already updated
 # Generate System.map and verify that the content is consistent
@@ -796,6 +800,12 @@ define rule_vmlinux__
 	$(call cmd,vmlinux__)
 	$(Q)echo 'cmd_$@ := $(cmd_vmlinux__)' > $(@D)/.$(@F).cmd
 
+	$(if $(CONFIG_BUILDTIME_EXTABLE_SORT),				\
+	  $(Q)$(if $($(quiet)cmd_sortextable),				\
+	    echo '  $($(quiet)cmd_sortextable)  vmlinux' &&)		\
+	  $(cmd_sortextable)  vmlinux)
+
+
 	$(Q)$(if $($(quiet)cmd_sysmap),                                      \
 	  echo '  $($(quiet)cmd_sysmap)  System.map' &&)                     \
 	$(cmd_sysmap) $@ System.map;                                         \
diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index ce30e2f..780a769 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -29,6 +29,7 @@ config MIPS
 	select HAVE_MEMBLOCK
 	select HAVE_MEMBLOCK_NODE_MAP
 	select ARCH_DISCARD_MEMBLOCK
+	select BUILDTIME_EXTABLE_SORT
 
 menu "Machine selection"
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 1d14cc6..2f925cc 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -82,6 +82,7 @@ config X86
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_IOMAP
 	select DCACHE_WORD_ACCESS if !DEBUG_PAGEALLOC
+	select BUILDTIME_EXTABLE_SORT
 
 config INSTRUCTION_DECODER
 	def_bool (KPROBES || PERF_EVENTS)
diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index e3e7340..20e5f7b 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -13,6 +13,7 @@
 #include <asm/thread_info.h>	
 #include <asm/segment.h>
 #include <asm/irqflags.h>
+#include <asm/asm.h>
 #include <linux/linkage.h>
 #include <linux/err.h>
 
@@ -146,9 +147,7 @@ ENTRY(ia32_sysenter_target)
  	/* no need to do an access_ok check here because rbp has been
  	   32bit zero extended */ 
 1:	movl	(%rbp),%ebp
- 	.section __ex_table,"a"
- 	.quad 1b,ia32_badarg
- 	.previous	
+	_ASM_EXTABLE(1b,ia32_badarg)
 	orl     $TS_COMPAT,TI_status+THREAD_INFO(%rsp,RIP-ARGOFFSET)
 	testl   $_TIF_WORK_SYSCALL_ENTRY,TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
 	CFI_REMEMBER_STATE
@@ -303,9 +302,7 @@ ENTRY(ia32_cstar_target)
 	   32bit zero extended */ 
 	/* hardware stack frame is complete now */	
 1:	movl	(%r8),%r9d
-	.section __ex_table,"a"
-	.quad 1b,ia32_badarg
-	.previous	
+	_ASM_EXTABLE(1b,ia32_badarg)
 	orl     $TS_COMPAT,TI_status+THREAD_INFO(%rsp,RIP-ARGOFFSET)
 	testl   $_TIF_WORK_SYSCALL_ENTRY,TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
 	CFI_REMEMBER_STATE
diff --git a/arch/x86/include/asm/asm.h b/arch/x86/include/asm/asm.h
index 9412d65..1c2d247 100644
--- a/arch/x86/include/asm/asm.h
+++ b/arch/x86/include/asm/asm.h
@@ -4,11 +4,9 @@
 #ifdef __ASSEMBLY__
 # define __ASM_FORM(x)	x
 # define __ASM_FORM_COMMA(x) x,
-# define __ASM_EX_SEC	.section __ex_table, "a"
 #else
 # define __ASM_FORM(x)	" " #x " "
 # define __ASM_FORM_COMMA(x) " " #x ","
-# define __ASM_EX_SEC	" .section __ex_table,\"a\"\n"
 #endif
 
 #ifdef CONFIG_X86_32
@@ -42,17 +40,33 @@
 
 /* Exception table entry */
 #ifdef __ASSEMBLY__
-# define _ASM_EXTABLE(from,to)	    \
-	__ASM_EX_SEC ;		    \
-	_ASM_ALIGN ;		    \
-	_ASM_PTR from , to ;	    \
-	.previous
+# define _ASM_EXTABLE(from,to)					\
+	.pushsection "__ex_table","a" ;				\
+	.balign 8 ;						\
+	.long (from) - . ;					\
+	.long (to) - . ;					\
+	.popsection
+
+# define _ASM_EXTABLE_EX(from,to)				\
+	.pushsection "__ex_table","a" ;				\
+	.balign 8 ;						\
+	.long (from) - . ;					\
+	.long (to) - . + 0x7ffffff0 ;				\
+	.popsection
 #else
-# define _ASM_EXTABLE(from,to) \
-	__ASM_EX_SEC	\
-	_ASM_ALIGN "\n" \
-	_ASM_PTR #from "," #to "\n" \
-	" .previous\n"
+# define _ASM_EXTABLE(from,to)					\
+	" .pushsection \"__ex_table\",\"a\"\n"			\
+	" .balign 8\n"						\
+	" .long (" #from ") - .\n"				\
+	" .long (" #to ") - .\n"				\
+	" .popsection\n"
+
+# define _ASM_EXTABLE_EX(from,to)				\
+	" .pushsection \"__ex_table\",\"a\"\n"			\
+	" .balign 8\n"						\
+	" .long (" #from ") - .\n"				\
+	" .long (" #to ") - . + 0x7ffffff0\n"			\
+	" .popsection\n"
 #endif
 
 #endif /* _ASM_X86_ASM_H */
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e216ba0..e5b97be 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -27,6 +27,7 @@
 #include <asm/desc.h>
 #include <asm/mtrr.h>
 #include <asm/msr-index.h>
+#include <asm/asm.h>
 
 #define KVM_MAX_VCPUS 254
 #define KVM_SOFT_MAX_VCPUS 160
@@ -921,9 +922,7 @@ extern bool kvm_rebooting;
 	__ASM_SIZE(push) " $666b \n\t"	      \
 	"call kvm_spurious_fault \n\t"	      \
 	".popsection \n\t" \
-	".pushsection __ex_table, \"a\" \n\t" \
-	_ASM_PTR " 666b, 667b \n\t" \
-	".popsection"
+	_ASM_EXTABLE(666b, 667b)
 
 #define __kvm_handle_fault_on_reboot(insn)		\
 	____kvm_handle_fault_on_reboot(insn, "")
diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index 95203d4..084ef95 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -169,14 +169,7 @@ static inline int wrmsr_safe(unsigned msr, unsigned low, unsigned high)
 	return native_write_msr_safe(msr, low, high);
 }
 
-/*
- * rdmsr with exception handling.
- *
- * Please note that the exception handling works only after we've
- * switched to the "smart" #GP handler in trap_init() which knows about
- * exception tables - using this macro earlier than that causes machine
- * hangs on boxes which do not implement the @msr in the first argument.
- */
+/* rdmsr with exception handling */
 #define rdmsr_safe(msr, p1, p2)					\
 ({								\
 	int __err;						\
diff --git a/arch/x86/include/asm/nops.h b/arch/x86/include/asm/nops.h
index 405b403..aff2b33 100644
--- a/arch/x86/include/asm/nops.h
+++ b/arch/x86/include/asm/nops.h
@@ -87,7 +87,11 @@
 #define P6_NOP8	0x0f,0x1f,0x84,0x00,0,0,0,0
 #define P6_NOP5_ATOMIC P6_NOP5
 
+#ifdef __ASSEMBLY__
+#define _ASM_MK_NOP(x) .byte x
+#else
 #define _ASM_MK_NOP(x) ".byte " __stringify(x) "\n"
+#endif
 
 #if defined(CONFIG_MK7)
 #define ASM_NOP1 _ASM_MK_NOP(K7_NOP1)
diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index aa0f913..6cbbabf 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -1023,10 +1023,8 @@ extern void default_banner(void);
 		  call PARA_INDIRECT(pv_cpu_ops+PV_CPU_swapgs)		\
 		 )
 
-#define GET_CR2_INTO_RCX				\
-	call PARA_INDIRECT(pv_mmu_ops+PV_MMU_read_cr2);	\
-	movq %rax, %rcx;				\
-	xorq %rax, %rax;
+#define GET_CR2_INTO_RAX				\
+	call PARA_INDIRECT(pv_mmu_ops+PV_MMU_read_cr2)
 
 #define PARAVIRT_ADJUST_EXCEPTION_FRAME					\
 	PARA_SITE(PARA_PATCH(pv_irq_ops, PV_IRQ_adjust_exception_frame), \
diff --git a/arch/x86/include/asm/segment.h b/arch/x86/include/asm/segment.h
index 1654662..c48a950 100644
--- a/arch/x86/include/asm/segment.h
+++ b/arch/x86/include/asm/segment.h
@@ -205,13 +205,15 @@
 
 #define IDT_ENTRIES 256
 #define NUM_EXCEPTION_VECTORS 32
+/* Bitmask of exception vectors which push an error code on the stack */
+#define EXCEPTION_ERRCODE_MASK  0x00027d00
 #define GDT_SIZE (GDT_ENTRIES * 8)
 #define GDT_ENTRY_TLS_ENTRIES 3
 #define TLS_SIZE (GDT_ENTRY_TLS_ENTRIES * 8)
 
 #ifdef __KERNEL__
 #ifndef __ASSEMBLY__
-extern const char early_idt_handlers[NUM_EXCEPTION_VECTORS][10];
+extern const char early_idt_handlers[NUM_EXCEPTION_VECTORS][2+2+5];
 
 /*
  * Load a segment. Fall back on loading the zero
diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index e054459..851fe0d 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -79,11 +79,12 @@
 #define access_ok(type, addr, size) (likely(__range_not_ok(addr, size) == 0))
 
 /*
- * The exception table consists of pairs of addresses: the first is the
- * address of an instruction that is allowed to fault, and the second is
- * the address at which the program should continue.  No registers are
- * modified, so it is entirely up to the continuation code to figure out
- * what to do.
+ * The exception table consists of pairs of addresses relative to the
+ * exception table enty itself: the first is the address of an
+ * instruction that is allowed to fault, and the second is the address
+ * at which the program should continue.  No registers are modified,
+ * so it is entirely up to the continuation code to figure out what to
+ * do.
  *
  * All the routines below use bits of fixup code that are out of line
  * with the main instruction path.  This means when everything is well,
@@ -92,10 +93,14 @@
  */
 
 struct exception_table_entry {
-	unsigned long insn, fixup;
+	int insn, fixup;
 };
+/* This is not the generic standard exception_table_entry format */
+#define ARCH_HAS_SORT_EXTABLE
+#define ARCH_HAS_SEARCH_EXTABLE
 
 extern int fixup_exception(struct pt_regs *regs);
+extern int early_fixup_exception(unsigned long *ip);
 
 /*
  * These are the main single-value transfer routines.  They automatically
@@ -202,8 +207,8 @@ extern int __get_user_bad(void);
 	asm volatile("1:	movl %%eax,0(%1)\n"			\
 		     "2:	movl %%edx,4(%1)\n"			\
 		     "3:\n"						\
-		     _ASM_EXTABLE(1b, 2b - 1b)				\
-		     _ASM_EXTABLE(2b, 3b - 2b)				\
+		     _ASM_EXTABLE_EX(1b, 2b)				\
+		     _ASM_EXTABLE_EX(2b, 3b)				\
 		     : : "A" (x), "r" (addr))
 
 #define __put_user_x8(x, ptr, __ret_pu)				\
@@ -408,7 +413,7 @@ do {									\
 #define __get_user_asm_ex(x, addr, itype, rtype, ltype)			\
 	asm volatile("1:	mov"itype" %1,%"rtype"0\n"		\
 		     "2:\n"						\
-		     _ASM_EXTABLE(1b, 2b - 1b)				\
+		     _ASM_EXTABLE_EX(1b, 2b)				\
 		     : ltype(x) : "m" (__m(addr)))
 
 #define __put_user_nocheck(x, ptr, size)			\
@@ -450,7 +455,7 @@ struct __large_struct { unsigned long buf[100]; };
 #define __put_user_asm_ex(x, addr, itype, rtype, ltype)			\
 	asm volatile("1:	mov"itype" %"rtype"0,%1\n"		\
 		     "2:\n"						\
-		     _ASM_EXTABLE(1b, 2b - 1b)				\
+		     _ASM_EXTABLE_EX(1b, 2b)				\
 		     : : ltype(x), "m" (__m(addr)))
 
 /*
diff --git a/arch/x86/include/asm/xsave.h b/arch/x86/include/asm/xsave.h
index c6ce245..8a1b6f9 100644
--- a/arch/x86/include/asm/xsave.h
+++ b/arch/x86/include/asm/xsave.h
@@ -80,10 +80,7 @@ static inline int xsave_user(struct xsave_struct __user *buf)
 			     "3:  movl $-1,%[err]\n"
 			     "    jmp  2b\n"
 			     ".previous\n"
-			     ".section __ex_table,\"a\"\n"
-			     _ASM_ALIGN "\n"
-			     _ASM_PTR "1b,3b\n"
-			     ".previous"
+			     _ASM_EXTABLE(1b,3b)
 			     : [err] "=r" (err)
 			     : "D" (buf), "a" (-1), "d" (-1), "0" (0)
 			     : "memory");
@@ -106,10 +103,7 @@ static inline int xrestore_user(struct xsave_struct __user *buf, u64 mask)
 			     "3:  movl $-1,%[err]\n"
 			     "    jmp  2b\n"
 			     ".previous\n"
-			     ".section __ex_table,\"a\"\n"
-			     _ASM_ALIGN "\n"
-			     _ASM_PTR "1b,3b\n"
-			     ".previous"
+			     _ASM_EXTABLE(1b,3b)
 			     : [err] "=r" (err)
 			     : "D" (xstate), "a" (lmask), "d" (hmask), "0" (0)
 			     : "memory");	/* memory required? */
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 7b784f4..01ccf9b 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -56,6 +56,7 @@
 #include <asm/irq_vectors.h>
 #include <asm/cpufeature.h>
 #include <asm/alternative-asm.h>
+#include <asm/asm.h>
 
 /* Avoid __ASSEMBLER__'ifying <linux/audit.h> just for this.  */
 #include <linux/elf-em.h>
@@ -151,10 +152,8 @@
 .pushsection .fixup, "ax"
 99:	movl $0, (%esp)
 	jmp 98b
-.section __ex_table, "a"
-	.align 4
-	.long 98b, 99b
 .popsection
+	_ASM_EXTABLE(98b,99b)
 .endm
 
 .macro PTGS_TO_GS
@@ -164,10 +163,8 @@
 .pushsection .fixup, "ax"
 99:	movl $0, PT_GS(%esp)
 	jmp 98b
-.section __ex_table, "a"
-	.align 4
-	.long 98b, 99b
 .popsection
+	_ASM_EXTABLE(98b,99b)
 .endm
 
 .macro GS_TO_REG reg
@@ -249,12 +246,10 @@
 	jmp 2b
 6:	movl $0, (%esp)
 	jmp 3b
-.section __ex_table, "a"
-	.align 4
-	.long 1b, 4b
-	.long 2b, 5b
-	.long 3b, 6b
 .popsection
+	_ASM_EXTABLE(1b,4b)
+	_ASM_EXTABLE(2b,5b)
+	_ASM_EXTABLE(3b,6b)
 	POP_GS_EX
 .endm
 
@@ -415,10 +410,7 @@ sysenter_past_esp:
 	jae syscall_fault
 1:	movl (%ebp),%ebp
 	movl %ebp,PT_EBP(%esp)
-.section __ex_table,"a"
-	.align 4
-	.long 1b,syscall_fault
-.previous
+	_ASM_EXTABLE(1b,syscall_fault)
 
 	GET_THREAD_INFO(%ebp)
 
@@ -485,10 +477,8 @@ sysexit_audit:
 .pushsection .fixup,"ax"
 2:	movl $0,PT_FS(%esp)
 	jmp 1b
-.section __ex_table,"a"
-	.align 4
-	.long 1b,2b
 .popsection
+	_ASM_EXTABLE(1b,2b)
 	PTGS_TO_GS_EX
 ENDPROC(ia32_sysenter_target)
 
@@ -543,10 +533,7 @@ ENTRY(iret_exc)
 	pushl $do_iret_error
 	jmp error_code
 .previous
-.section __ex_table,"a"
-	.align 4
-	.long irq_return,iret_exc
-.previous
+	_ASM_EXTABLE(irq_return,iret_exc)
 
 	CFI_RESTORE_STATE
 ldt_ss:
@@ -901,10 +888,7 @@ END(device_not_available)
 #ifdef CONFIG_PARAVIRT
 ENTRY(native_iret)
 	iret
-.section __ex_table,"a"
-	.align 4
-	.long native_iret, iret_exc
-.previous
+	_ASM_EXTABLE(native_iret, iret_exc)
 END(native_iret)
 
 ENTRY(native_irq_enable_sysexit)
@@ -1093,13 +1077,10 @@ ENTRY(xen_failsafe_callback)
 	movl %eax,16(%esp)
 	jmp 4b
 .previous
-.section __ex_table,"a"
-	.align 4
-	.long 1b,6b
-	.long 2b,7b
-	.long 3b,8b
-	.long 4b,9b
-.previous
+	_ASM_EXTABLE(1b,6b)
+	_ASM_EXTABLE(2b,7b)
+	_ASM_EXTABLE(3b,8b)
+	_ASM_EXTABLE(4b,9b)
 ENDPROC(xen_failsafe_callback)
 
 BUILD_INTERRUPT3(xen_hvm_callback_vector, XEN_HVM_EVTCHN_CALLBACK,
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index cdc79b5..320852d 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -55,6 +55,7 @@
 #include <asm/paravirt.h>
 #include <asm/ftrace.h>
 #include <asm/percpu.h>
+#include <asm/asm.h>
 #include <linux/err.h>
 
 /* Avoid __ASSEMBLER__'ifying <linux/audit.h> just for this.  */
@@ -900,18 +901,12 @@ restore_args:
 
 irq_return:
 	INTERRUPT_RETURN
-
-	.section __ex_table, "a"
-	.quad irq_return, bad_iret
-	.previous
+	_ASM_EXTABLE(irq_return, bad_iret)
 
 #ifdef CONFIG_PARAVIRT
 ENTRY(native_iret)
 	iretq
-
-	.section __ex_table,"a"
-	.quad native_iret, bad_iret
-	.previous
+	_ASM_EXTABLE(native_iret, bad_iret)
 #endif
 
 	.section .fixup,"ax"
@@ -1181,10 +1176,7 @@ gs_change:
 	CFI_ENDPROC
 END(native_load_gs_index)
 
-	.section __ex_table,"a"
-	.align 8
-	.quad gs_change,bad_gs
-	.previous
+	_ASM_EXTABLE(gs_change,bad_gs)
 	.section .fixup,"ax"
 	/* running with kernelgs */
 bad_gs:
diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index ce0be7c..463c979 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -21,6 +21,7 @@
 #include <asm/msr-index.h>
 #include <asm/cpufeature.h>
 #include <asm/percpu.h>
+#include <asm/nops.h>
 
 /* Physical address */
 #define pa(X) ((X) - __PAGE_OFFSET)
@@ -363,28 +364,23 @@ default_entry:
 	pushl $0
 	popfl
 
-#ifdef CONFIG_SMP
-	cmpb $0, ready
-	jnz checkCPUtype
-#endif /* CONFIG_SMP */
-
 /*
  * start system 32-bit setup. We need to re-do some of the things done
  * in 16-bit mode for the "real" operations.
  */
-	call setup_idt
-
-checkCPUtype:
-
-	movl $-1,X86_CPUID		#  -1 for no CPUID initially
-
+	movl setup_once_ref,%eax
+	andl %eax,%eax
+	jz 1f				# Did we do this already?
+	call *%eax
+1:
+	
 /* check if it is 486 or 386. */
 /*
  * XXX - this does a lot of unnecessary setup.  Alignment checks don't
  * apply at our cpl of 0 and the stack ought to be aligned already, and
  * we don't need to preserve eflags.
  */
-
+	movl $-1,X86_CPUID	# -1 for no CPUID initially
 	movb $3,X86		# at least 386
 	pushfl			# push EFLAGS
 	popl %eax		# get EFLAGS
@@ -450,21 +446,6 @@ is386:	movl $2,%ecx		# set MP
 	movl $(__KERNEL_PERCPU), %eax
 	movl %eax,%fs			# set this cpu's percpu
 
-#ifdef CONFIG_CC_STACKPROTECTOR
-	/*
-	 * The linker can't handle this by relocation.  Manually set
-	 * base address in stack canary segment descriptor.
-	 */
-	cmpb $0,ready
-	jne 1f
-	movl $gdt_page,%eax
-	movl $stack_canary,%ecx
-	movw %cx, 8 * GDT_ENTRY_STACK_CANARY + 2(%eax)
-	shrl $16, %ecx
-	movb %cl, 8 * GDT_ENTRY_STACK_CANARY + 4(%eax)
-	movb %ch, 8 * GDT_ENTRY_STACK_CANARY + 7(%eax)
-1:
-#endif
 	movl $(__KERNEL_STACK_CANARY),%eax
 	movl %eax,%gs
 
@@ -473,7 +454,6 @@ is386:	movl $2,%ecx		# set MP
 
 	cld			# gcc2 wants the direction flag cleared at all times
 	pushl $0		# fake return address for unwinder
-	movb $1, ready
 	jmp *(initial_code)
 
 /*
@@ -495,81 +475,122 @@ check_x87:
 	.byte 0xDB,0xE4		/* fsetpm for 287, ignored by 387 */
 	ret
 
+	
+#include "verify_cpu.S"
+
 /*
- *  setup_idt
+ *  setup_once
  *
- *  sets up a idt with 256 entries pointing to
- *  ignore_int, interrupt gates. It doesn't actually load
- *  idt - that can be done only after paging has been enabled
- *  and the kernel moved to PAGE_OFFSET. Interrupts
- *  are enabled elsewhere, when we can be relatively
- *  sure everything is ok.
+ *  The setup work we only want to run on the BSP.
  *
  *  Warning: %esi is live across this function.
  */
-setup_idt:
-	lea ignore_int,%edx
-	movl $(__KERNEL_CS << 16),%eax
-	movw %dx,%ax		/* selector = 0x0010 = cs */
-	movw $0x8E00,%dx	/* interrupt gate - dpl=0, present */
+__INIT
+setup_once:
+	/*
+	 * Set up a idt with 256 entries pointing to ignore_int,
+	 * interrupt gates. It doesn't actually load idt - that needs
+	 * to be done on each CPU. Interrupts are enabled elsewhere,
+	 * when we can be relatively sure everything is ok.
+	 */
 
-	lea idt_table,%edi
-	mov $256,%ecx
-rp_sidt:
+	movl $idt_table,%edi
+	movl $early_idt_handlers,%eax
+	movl $NUM_EXCEPTION_VECTORS,%ecx
+1:
 	movl %eax,(%edi)
-	movl %edx,4(%edi)
+	movl %eax,4(%edi)
+	/* interrupt gate, dpl=0, present */
+	movl $(0x8E000000 + __KERNEL_CS),2(%edi)
+	addl $9,%eax
 	addl $8,%edi
-	dec %ecx
-	jne rp_sidt
+	loop 1b
 
-.macro	set_early_handler handler,trapno
-	lea \handler,%edx
+	movl $256 - NUM_EXCEPTION_VECTORS,%ecx
+	movl $ignore_int,%edx
 	movl $(__KERNEL_CS << 16),%eax
-	movw %dx,%ax
+	movw %dx,%ax		/* selector = 0x0010 = cs */
 	movw $0x8E00,%dx	/* interrupt gate - dpl=0, present */
-	lea idt_table,%edi
-	movl %eax,8*\trapno(%edi)
-	movl %edx,8*\trapno+4(%edi)
-.endm
+2:
+	movl %eax,(%edi)
+	movl %edx,4(%edi)
+	addl $8,%edi
+	loop 2b
 
-	set_early_handler handler=early_divide_err,trapno=0
-	set_early_handler handler=early_illegal_opcode,trapno=6
-	set_early_handler handler=early_protection_fault,trapno=13
-	set_early_handler handler=early_page_fault,trapno=14
+#ifdef CONFIG_CC_STACKPROTECTOR
+	/*
+	 * Configure the stack canary. The linker can't handle this by
+	 * relocation.  Manually set base address in stack canary
+	 * segment descriptor.
+	 */
+	movl $gdt_page,%eax
+	movl $stack_canary,%ecx
+	movw %cx, 8 * GDT_ENTRY_STACK_CANARY + 2(%eax)
+	shrl $16, %ecx
+	movb %cl, 8 * GDT_ENTRY_STACK_CANARY + 4(%eax)
+	movb %ch, 8 * GDT_ENTRY_STACK_CANARY + 7(%eax)
+#endif
 
+	andl $0,setup_once_ref	/* Once is enough, thanks */
 	ret
 
-early_divide_err:
-	xor %edx,%edx
-	pushl $0	/* fake errcode */
-	jmp early_fault
+ENTRY(early_idt_handlers)
+	# 36(%esp) %eflags
+	# 32(%esp) %cs
+	# 28(%esp) %eip
+	# 24(%rsp) error code
+	i = 0
+	.rept NUM_EXCEPTION_VECTORS
+	.if (EXCEPTION_ERRCODE_MASK >> i) & 1
+	ASM_NOP2
+	.else
+	pushl $0		# Dummy error code, to make stack frame uniform
+	.endif
+	pushl $i		# 20(%esp) Vector number
+	jmp early_idt_handler
+	i = i + 1
+	.endr
+ENDPROC(early_idt_handlers)
+	
+	/* This is global to keep gas from relaxing the jumps */
+ENTRY(early_idt_handler)
+	cld
+	cmpl $2,%ss:early_recursion_flag
+	je hlt_loop
+	incl %ss:early_recursion_flag
 
-early_illegal_opcode:
-	movl $6,%edx
-	pushl $0	/* fake errcode */
-	jmp early_fault
+	push %eax		# 16(%esp)
+	push %ecx		# 12(%esp)
+	push %edx		#  8(%esp)
+	push %ds		#  4(%esp)
+	push %es		#  0(%esp)
+	movl $(__KERNEL_DS),%eax
+	movl %eax,%ds
+	movl %eax,%es
 
-early_protection_fault:
-	movl $13,%edx
-	jmp early_fault
+	cmpl $(__KERNEL_CS),32(%esp)
+	jne 10f
 
-early_page_fault:
-	movl $14,%edx
-	jmp early_fault
+	leal 28(%esp),%eax	# Pointer to %eip
+	call early_fixup_exception
+	andl %eax,%eax
+	jnz ex_entry		/* found an exception entry */
 
-early_fault:
-	cld
+10:
 #ifdef CONFIG_PRINTK
-	pusha
-	movl $(__KERNEL_DS),%eax
-	movl %eax,%ds
-	movl %eax,%es
-	cmpl $2,early_recursion_flag
-	je hlt_loop
-	incl early_recursion_flag
+	xorl %eax,%eax
+	movw %ax,2(%esp)	/* clean up the segment values on some cpus */
+	movw %ax,6(%esp)
+	movw %ax,34(%esp)
+	leal  40(%esp),%eax
+	pushl %eax		/* %esp before the exception */
+	pushl %ebx
+	pushl %ebp
+	pushl %esi
+	pushl %edi
 	movl %cr2,%eax
 	pushl %eax
-	pushl %edx		/* trapno */
+	pushl (20+6*4)(%esp)	/* trapno */
 	pushl $fault_msg
 	call printk
 #endif
@@ -578,6 +599,17 @@ hlt_loop:
 	hlt
 	jmp hlt_loop
 
+ex_entry:
+	pop %es
+	pop %ds
+	pop %edx
+	pop %ecx
+	pop %eax
+	addl $8,%esp		/* drop vector number and error code */
+	decl %ss:early_recursion_flag
+	iret
+ENDPROC(early_idt_handler)
+
 /* This is the default interrupt "handler" :-) */
 	ALIGN
 ignore_int:
@@ -611,13 +643,18 @@ ignore_int:
 	popl %eax
 #endif
 	iret
+ENDPROC(ignore_int)
+__INITDATA
+	.align 4
+early_recursion_flag:
+	.long 0
 
-#include "verify_cpu.S"
-
-	__REFDATA
-.align 4
+__REFDATA
+	.align 4
 ENTRY(initial_code)
 	.long i386_start_kernel
+ENTRY(setup_once_ref)
+	.long setup_once
 
 /*
  * BSS section
@@ -670,22 +707,19 @@ ENTRY(initial_page_table)
 ENTRY(stack_start)
 	.long init_thread_union+THREAD_SIZE
 
-early_recursion_flag:
-	.long 0
-
-ready:	.byte 0
-
+__INITRODATA
 int_msg:
 	.asciz "Unknown interrupt or fault at: %p %p %p\n"
 
 fault_msg:
 /* fault info: */
 	.ascii "BUG: Int %d: CR2 %p\n"
-/* pusha regs: */
-	.ascii "     EDI %p  ESI %p  EBP %p  ESP %p\n"
-	.ascii "     EBX %p  EDX %p  ECX %p  EAX %p\n"
+/* regs pushed in early_idt_handler: */
+	.ascii "     EDI %p  ESI %p  EBP %p  EBX %p\n"
+	.ascii "     ESP %p   ES %p   DS %p\n"
+	.ascii "     EDX %p  ECX %p  EAX %p\n"
 /* fault frame: */
-	.ascii "     err %p  EIP %p   CS %p  flg %p\n"
+	.ascii "     vec %p  err %p  EIP %p   CS %p  flg %p\n"
 	.ascii "Stack: %p %p %p %p %p %p %p %p\n"
 	.ascii "       %p %p %p %p %p %p %p %p\n"
 	.asciz "       %p %p %p %p %p %p %p %p\n"
@@ -699,6 +733,7 @@ fault_msg:
  * segment size, and 32-bit linear address value:
  */
 
+	.data
 .globl boot_gdt_descr
 .globl idt_descr
 
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 40f4eb3..7a40f24 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -19,12 +19,15 @@
 #include <asm/cache.h>
 #include <asm/processor-flags.h>
 #include <asm/percpu.h>
+#include <asm/nops.h>
 
 #ifdef CONFIG_PARAVIRT
 #include <asm/asm-offsets.h>
 #include <asm/paravirt.h>
+#define GET_CR2_INTO(reg) GET_CR2_INTO_RAX ; movq %rax, reg
 #else
-#define GET_CR2_INTO_RCX movq %cr2, %rcx
+#define GET_CR2_INTO(reg) movq %cr2, reg
+#define INTERRUPT_RETURN iretq
 #endif
 
 /* we are not able to switch in one step to the final KERNEL ADDRESS SPACE
@@ -270,36 +273,56 @@ bad_address:
 	jmp bad_address
 
 	.section ".init.text","ax"
-#ifdef CONFIG_EARLY_PRINTK
 	.globl early_idt_handlers
 early_idt_handlers:
+	# 104(%rsp) %rflags
+	#  96(%rsp) %cs
+	#  88(%rsp) %rip
+	#  80(%rsp) error code
 	i = 0
 	.rept NUM_EXCEPTION_VECTORS
-	movl $i, %esi
+	.if (EXCEPTION_ERRCODE_MASK >> i) & 1
+	ASM_NOP2
+	.else
+	pushq $0		# Dummy error code, to make stack frame uniform
+	.endif
+	pushq $i		# 72(%rsp) Vector number
 	jmp early_idt_handler
 	i = i + 1
 	.endr
-#endif
 
 ENTRY(early_idt_handler)
-#ifdef CONFIG_EARLY_PRINTK
+	cld
+
 	cmpl $2,early_recursion_flag(%rip)
 	jz  1f
 	incl early_recursion_flag(%rip)
-	GET_CR2_INTO_RCX
-	movq %rcx,%r9
-	xorl %r8d,%r8d		# zero for error code
-	movl %esi,%ecx		# get vector number
-	# Test %ecx against mask of vectors that push error code.
-	cmpl $31,%ecx
-	ja 0f
-	movl $1,%eax
-	salq %cl,%rax
-	testl $0x27d00,%eax
-	je 0f
-	popq %r8		# get error code
-0:	movq 0(%rsp),%rcx	# get ip
-	movq 8(%rsp),%rdx	# get cs
+
+	pushq %rax		# 64(%rsp)
+	pushq %rcx		# 56(%rsp)
+	pushq %rdx		# 48(%rsp)
+	pushq %rsi		# 40(%rsp)
+	pushq %rdi		# 32(%rsp)
+	pushq %r8		# 24(%rsp)
+	pushq %r9		# 16(%rsp)
+	pushq %r10		#  8(%rsp)
+	pushq %r11		#  0(%rsp)
+
+	cmpl $__KERNEL_CS,96(%rsp)
+	jne 10f
+
+	leaq 88(%rsp),%rdi	# Pointer to %rip
+	call early_fixup_exception
+	andl %eax,%eax
+	jnz 20f			# Found an exception entry
+
+10:
+#ifdef CONFIG_EARLY_PRINTK
+	GET_CR2_INTO(%r9)	# can clobber any volatile register if pv
+	movl 80(%rsp),%r8d	# error code
+	movl 72(%rsp),%esi	# vector number
+	movl 96(%rsp),%edx	# %cs
+	movq 88(%rsp),%rcx	# %rip
 	xorl %eax,%eax
 	leaq early_idt_msg(%rip),%rdi
 	call early_printk
@@ -308,17 +331,32 @@ ENTRY(early_idt_handler)
 	call dump_stack
 #ifdef CONFIG_KALLSYMS	
 	leaq early_idt_ripmsg(%rip),%rdi
-	movq 0(%rsp),%rsi	# get rip again
+	movq 40(%rsp),%rsi	# %rip again
 	call __print_symbol
 #endif
 #endif /* EARLY_PRINTK */
 1:	hlt
 	jmp 1b
 
-#ifdef CONFIG_EARLY_PRINTK
+20:	# Exception table entry found
+	popq %r11
+	popq %r10
+	popq %r9
+	popq %r8
+	popq %rdi
+	popq %rsi
+	popq %rdx
+	popq %rcx
+	popq %rax
+	addq $16,%rsp		# drop vector number and error code
+	decl early_recursion_flag(%rip)
+	INTERRUPT_RETURN
+
+	.balign 4
 early_recursion_flag:
 	.long 0
 
+#ifdef CONFIG_EARLY_PRINTK
 early_idt_msg:
 	.asciz "PANIC: early exception %02lx rip %lx:%lx error %lx cr2 %lx\n"
 early_idt_ripmsg:
diff --git a/arch/x86/kernel/test_rodata.c b/arch/x86/kernel/test_rodata.c
index c29e235..b79133a 100644
--- a/arch/x86/kernel/test_rodata.c
+++ b/arch/x86/kernel/test_rodata.c
@@ -12,6 +12,7 @@
 #include <linux/module.h>
 #include <asm/cacheflush.h>
 #include <asm/sections.h>
+#include <asm/asm.h>
 
 int rodata_test(void)
 {
@@ -42,14 +43,7 @@ int rodata_test(void)
 		".section .fixup,\"ax\"\n"
 		"2:	jmp 1b\n"
 		".previous\n"
-		".section __ex_table,\"a\"\n"
-		"       .align 16\n"
-#ifdef CONFIG_X86_32
-		"	.long 0b,2b\n"
-#else
-		"	.quad 0b,2b\n"
-#endif
-		".previous"
+		_ASM_EXTABLE(0b,2b)
 		: [rslt] "=r" (result)
 		: [rodata_test] "r" (&rodata_test_data), [zero] "r" (0UL)
 	);
diff --git a/arch/x86/lib/checksum_32.S b/arch/x86/lib/checksum_32.S
index 78d16a5..2af5df3 100644
--- a/arch/x86/lib/checksum_32.S
+++ b/arch/x86/lib/checksum_32.S
@@ -28,6 +28,7 @@
 #include <linux/linkage.h>
 #include <asm/dwarf2.h>
 #include <asm/errno.h>
+#include <asm/asm.h>
 				
 /*
  * computes a partial checksum, e.g. for TCP/UDP fragments
@@ -282,15 +283,11 @@ unsigned int csum_partial_copy_generic (const char *src, char *dst,
 
 #define SRC(y...)			\
 	9999: y;			\
-	.section __ex_table, "a";	\
-	.long 9999b, 6001f	;	\
-	.previous
+	_ASM_EXTABLE(9999b, 6001f)
 
 #define DST(y...)			\
 	9999: y;			\
-	.section __ex_table, "a";	\
-	.long 9999b, 6002f	;	\
-	.previous
+	_ASM_EXTABLE(9999b, 6002f)
 
 #ifndef CONFIG_X86_USE_PPRO_CHECKSUM
 
diff --git a/arch/x86/lib/copy_user_64.S b/arch/x86/lib/copy_user_64.S
index 0248402..5b2995f 100644
--- a/arch/x86/lib/copy_user_64.S
+++ b/arch/x86/lib/copy_user_64.S
@@ -16,6 +16,7 @@
 #include <asm/thread_info.h>
 #include <asm/cpufeature.h>
 #include <asm/alternative-asm.h>
+#include <asm/asm.h>
 
 /*
  * By placing feature2 after feature1 in altinstructions section, we logically
@@ -63,11 +64,8 @@
 	jmp copy_user_handle_tail
 	.previous
 
-	.section __ex_table,"a"
-	.align 8
-	.quad 100b,103b
-	.quad 101b,103b
-	.previous
+	_ASM_EXTABLE(100b,103b)
+	_ASM_EXTABLE(101b,103b)
 #endif
 	.endm
 
@@ -191,29 +189,26 @@ ENTRY(copy_user_generic_unrolled)
 60:	jmp copy_user_handle_tail /* ecx is zerorest also */
 	.previous
 
-	.section __ex_table,"a"
-	.align 8
-	.quad 1b,30b
-	.quad 2b,30b
-	.quad 3b,30b
-	.quad 4b,30b
-	.quad 5b,30b
-	.quad 6b,30b
-	.quad 7b,30b
-	.quad 8b,30b
-	.quad 9b,30b
-	.quad 10b,30b
-	.quad 11b,30b
-	.quad 12b,30b
-	.quad 13b,30b
-	.quad 14b,30b
-	.quad 15b,30b
-	.quad 16b,30b
-	.quad 18b,40b
-	.quad 19b,40b
-	.quad 21b,50b
-	.quad 22b,50b
-	.previous
+	_ASM_EXTABLE(1b,30b)
+	_ASM_EXTABLE(2b,30b)
+	_ASM_EXTABLE(3b,30b)
+	_ASM_EXTABLE(4b,30b)
+	_ASM_EXTABLE(5b,30b)
+	_ASM_EXTABLE(6b,30b)
+	_ASM_EXTABLE(7b,30b)
+	_ASM_EXTABLE(8b,30b)
+	_ASM_EXTABLE(9b,30b)
+	_ASM_EXTABLE(10b,30b)
+	_ASM_EXTABLE(11b,30b)
+	_ASM_EXTABLE(12b,30b)
+	_ASM_EXTABLE(13b,30b)
+	_ASM_EXTABLE(14b,30b)
+	_ASM_EXTABLE(15b,30b)
+	_ASM_EXTABLE(16b,30b)
+	_ASM_EXTABLE(18b,40b)
+	_ASM_EXTABLE(19b,40b)
+	_ASM_EXTABLE(21b,50b)
+	_ASM_EXTABLE(22b,50b)
 	CFI_ENDPROC
 ENDPROC(copy_user_generic_unrolled)
 
@@ -259,11 +254,8 @@ ENTRY(copy_user_generic_string)
 	jmp copy_user_handle_tail
 	.previous
 
-	.section __ex_table,"a"
-	.align 8
-	.quad 1b,11b
-	.quad 3b,12b
-	.previous
+	_ASM_EXTABLE(1b,11b)
+	_ASM_EXTABLE(3b,12b)
 	CFI_ENDPROC
 ENDPROC(copy_user_generic_string)
 
@@ -294,9 +286,6 @@ ENTRY(copy_user_enhanced_fast_string)
 	jmp copy_user_handle_tail
 	.previous
 
-	.section __ex_table,"a"
-	.align 8
-	.quad 1b,12b
-	.previous
+	_ASM_EXTABLE(1b,12b)
 	CFI_ENDPROC
 ENDPROC(copy_user_enhanced_fast_string)
diff --git a/arch/x86/lib/copy_user_nocache_64.S b/arch/x86/lib/copy_user_nocache_64.S
index cb0c112..cacddc7 100644
--- a/arch/x86/lib/copy_user_nocache_64.S
+++ b/arch/x86/lib/copy_user_nocache_64.S
@@ -14,6 +14,7 @@
 #include <asm/current.h>
 #include <asm/asm-offsets.h>
 #include <asm/thread_info.h>
+#include <asm/asm.h>
 
 	.macro ALIGN_DESTINATION
 #ifdef FIX_ALIGNMENT
@@ -36,11 +37,8 @@
 	jmp copy_user_handle_tail
 	.previous
 
-	.section __ex_table,"a"
-	.align 8
-	.quad 100b,103b
-	.quad 101b,103b
-	.previous
+	_ASM_EXTABLE(100b,103b)
+	_ASM_EXTABLE(101b,103b)
 #endif
 	.endm
 
@@ -111,27 +109,25 @@ ENTRY(__copy_user_nocache)
 	jmp copy_user_handle_tail
 	.previous
 
-	.section __ex_table,"a"
-	.quad 1b,30b
-	.quad 2b,30b
-	.quad 3b,30b
-	.quad 4b,30b
-	.quad 5b,30b
-	.quad 6b,30b
-	.quad 7b,30b
-	.quad 8b,30b
-	.quad 9b,30b
-	.quad 10b,30b
-	.quad 11b,30b
-	.quad 12b,30b
-	.quad 13b,30b
-	.quad 14b,30b
-	.quad 15b,30b
-	.quad 16b,30b
-	.quad 18b,40b
-	.quad 19b,40b
-	.quad 21b,50b
-	.quad 22b,50b
-	.previous
+	_ASM_EXTABLE(1b,30b)
+	_ASM_EXTABLE(2b,30b)
+	_ASM_EXTABLE(3b,30b)
+	_ASM_EXTABLE(4b,30b)
+	_ASM_EXTABLE(5b,30b)
+	_ASM_EXTABLE(6b,30b)
+	_ASM_EXTABLE(7b,30b)
+	_ASM_EXTABLE(8b,30b)
+	_ASM_EXTABLE(9b,30b)
+	_ASM_EXTABLE(10b,30b)
+	_ASM_EXTABLE(11b,30b)
+	_ASM_EXTABLE(12b,30b)
+	_ASM_EXTABLE(13b,30b)
+	_ASM_EXTABLE(14b,30b)
+	_ASM_EXTABLE(15b,30b)
+	_ASM_EXTABLE(16b,30b)
+	_ASM_EXTABLE(18b,40b)
+	_ASM_EXTABLE(19b,40b)
+	_ASM_EXTABLE(21b,50b)
+	_ASM_EXTABLE(22b,50b)
 	CFI_ENDPROC
 ENDPROC(__copy_user_nocache)
diff --git a/arch/x86/lib/csum-copy_64.S b/arch/x86/lib/csum-copy_64.S
index fb903b7..2419d5f 100644
--- a/arch/x86/lib/csum-copy_64.S
+++ b/arch/x86/lib/csum-copy_64.S
@@ -8,6 +8,7 @@
 #include <linux/linkage.h>
 #include <asm/dwarf2.h>
 #include <asm/errno.h>
+#include <asm/asm.h>
 
 /*
  * Checksum copy with exception handling.
@@ -31,26 +32,17 @@
 
 	.macro source
 10:
-	.section __ex_table, "a"
-	.align 8
-	.quad 10b, .Lbad_source
-	.previous
+	_ASM_EXTABLE(10b, .Lbad_source)
 	.endm
 
 	.macro dest
 20:
-	.section __ex_table, "a"
-	.align 8
-	.quad 20b, .Lbad_dest
-	.previous
+	_ASM_EXTABLE(20b, .Lbad_dest)
 	.endm
 
 	.macro ignore L=.Lignore
 30:
-	.section __ex_table, "a"
-	.align 8
-	.quad 30b, \L
-	.previous
+	_ASM_EXTABLE(30b, \L)
 	.endm
 
 
diff --git a/arch/x86/lib/getuser.S b/arch/x86/lib/getuser.S
index 51f1504..b33b1fb 100644
--- a/arch/x86/lib/getuser.S
+++ b/arch/x86/lib/getuser.S
@@ -95,10 +95,9 @@ bad_get_user:
 	CFI_ENDPROC
 END(bad_get_user)
 
-.section __ex_table,"a"
-	_ASM_PTR 1b,bad_get_user
-	_ASM_PTR 2b,bad_get_user
-	_ASM_PTR 3b,bad_get_user
+	_ASM_EXTABLE(1b,bad_get_user)
+	_ASM_EXTABLE(2b,bad_get_user)
+	_ASM_EXTABLE(3b,bad_get_user)
 #ifdef CONFIG_X86_64
-	_ASM_PTR 4b,bad_get_user
+	_ASM_EXTABLE(4b,bad_get_user)
 #endif
diff --git a/arch/x86/lib/putuser.S b/arch/x86/lib/putuser.S
index 36b0d15..7f951c8 100644
--- a/arch/x86/lib/putuser.S
+++ b/arch/x86/lib/putuser.S
@@ -86,12 +86,10 @@ bad_put_user:
 	EXIT
 END(bad_put_user)
 
-.section __ex_table,"a"
-	_ASM_PTR 1b,bad_put_user
-	_ASM_PTR 2b,bad_put_user
-	_ASM_PTR 3b,bad_put_user
-	_ASM_PTR 4b,bad_put_user
+	_ASM_EXTABLE(1b,bad_put_user)
+	_ASM_EXTABLE(2b,bad_put_user)
+	_ASM_EXTABLE(3b,bad_put_user)
+	_ASM_EXTABLE(4b,bad_put_user)
 #ifdef CONFIG_X86_32
-	_ASM_PTR 5b,bad_put_user
+	_ASM_EXTABLE(5b,bad_put_user)
 #endif
-.previous
diff --git a/arch/x86/lib/usercopy_32.c b/arch/x86/lib/usercopy_32.c
index ef2a6a5..883b216 100644
--- a/arch/x86/lib/usercopy_32.c
+++ b/arch/x86/lib/usercopy_32.c
@@ -13,6 +13,7 @@
 #include <linux/interrupt.h>
 #include <asm/uaccess.h>
 #include <asm/mmx.h>
+#include <asm/asm.h>
 
 #ifdef CONFIG_X86_INTEL_USERCOPY
 /*
@@ -127,10 +128,7 @@ long strnlen_user(const char __user *s, long n)
 		"3:	movb $1,%%al\n"
 		"	jmp 1b\n"
 		".previous\n"
-		".section __ex_table,\"a\"\n"
-		"	.align 4\n"
-		"	.long 0b,2b\n"
-		".previous"
+		_ASM_EXTABLE(0b,2b)
 		:"=&r" (n), "=&D" (s), "=&a" (res), "=&c" (tmp)
 		:"0" (n), "1" (s), "2" (0), "3" (mask)
 		:"cc");
@@ -199,47 +197,44 @@ __copy_user_intel(void __user *to, const void *from, unsigned long size)
 		       "101:   lea 0(%%eax,%0,4),%0\n"
 		       "       jmp 100b\n"
 		       ".previous\n"
-		       ".section __ex_table,\"a\"\n"
-		       "       .align 4\n"
-		       "       .long 1b,100b\n"
-		       "       .long 2b,100b\n"
-		       "       .long 3b,100b\n"
-		       "       .long 4b,100b\n"
-		       "       .long 5b,100b\n"
-		       "       .long 6b,100b\n"
-		       "       .long 7b,100b\n"
-		       "       .long 8b,100b\n"
-		       "       .long 9b,100b\n"
-		       "       .long 10b,100b\n"
-		       "       .long 11b,100b\n"
-		       "       .long 12b,100b\n"
-		       "       .long 13b,100b\n"
-		       "       .long 14b,100b\n"
-		       "       .long 15b,100b\n"
-		       "       .long 16b,100b\n"
-		       "       .long 17b,100b\n"
-		       "       .long 18b,100b\n"
-		       "       .long 19b,100b\n"
-		       "       .long 20b,100b\n"
-		       "       .long 21b,100b\n"
-		       "       .long 22b,100b\n"
-		       "       .long 23b,100b\n"
-		       "       .long 24b,100b\n"
-		       "       .long 25b,100b\n"
-		       "       .long 26b,100b\n"
-		       "       .long 27b,100b\n"
-		       "       .long 28b,100b\n"
-		       "       .long 29b,100b\n"
-		       "       .long 30b,100b\n"
-		       "       .long 31b,100b\n"
-		       "       .long 32b,100b\n"
-		       "       .long 33b,100b\n"
-		       "       .long 34b,100b\n"
-		       "       .long 35b,100b\n"
-		       "       .long 36b,100b\n"
-		       "       .long 37b,100b\n"
-		       "       .long 99b,101b\n"
-		       ".previous"
+		       _ASM_EXTABLE(1b,100b)
+		       _ASM_EXTABLE(2b,100b)
+		       _ASM_EXTABLE(3b,100b)
+		       _ASM_EXTABLE(4b,100b)
+		       _ASM_EXTABLE(5b,100b)
+		       _ASM_EXTABLE(6b,100b)
+		       _ASM_EXTABLE(7b,100b)
+		       _ASM_EXTABLE(8b,100b)
+		       _ASM_EXTABLE(9b,100b)
+		       _ASM_EXTABLE(10b,100b)
+		       _ASM_EXTABLE(11b,100b)
+		       _ASM_EXTABLE(12b,100b)
+		       _ASM_EXTABLE(13b,100b)
+		       _ASM_EXTABLE(14b,100b)
+		       _ASM_EXTABLE(15b,100b)
+		       _ASM_EXTABLE(16b,100b)
+		       _ASM_EXTABLE(17b,100b)
+		       _ASM_EXTABLE(18b,100b)
+		       _ASM_EXTABLE(19b,100b)
+		       _ASM_EXTABLE(20b,100b)
+		       _ASM_EXTABLE(21b,100b)
+		       _ASM_EXTABLE(22b,100b)
+		       _ASM_EXTABLE(23b,100b)
+		       _ASM_EXTABLE(24b,100b)
+		       _ASM_EXTABLE(25b,100b)
+		       _ASM_EXTABLE(26b,100b)
+		       _ASM_EXTABLE(27b,100b)
+		       _ASM_EXTABLE(28b,100b)
+		       _ASM_EXTABLE(29b,100b)
+		       _ASM_EXTABLE(30b,100b)
+		       _ASM_EXTABLE(31b,100b)
+		       _ASM_EXTABLE(32b,100b)
+		       _ASM_EXTABLE(33b,100b)
+		       _ASM_EXTABLE(34b,100b)
+		       _ASM_EXTABLE(35b,100b)
+		       _ASM_EXTABLE(36b,100b)
+		       _ASM_EXTABLE(37b,100b)
+		       _ASM_EXTABLE(99b,101b)
 		       : "=&c"(size), "=&D" (d0), "=&S" (d1)
 		       :  "1"(to), "2"(from), "0"(size)
 		       : "eax", "edx", "memory");
@@ -312,29 +307,26 @@ __copy_user_zeroing_intel(void *to, const void __user *from, unsigned long size)
 		       "        popl %0\n"
 		       "        jmp 8b\n"
 		       ".previous\n"
-		       ".section __ex_table,\"a\"\n"
-		       "	.align 4\n"
-		       "	.long 0b,16b\n"
-		       "	.long 1b,16b\n"
-		       "	.long 2b,16b\n"
-		       "	.long 21b,16b\n"
-		       "	.long 3b,16b\n"
-		       "	.long 31b,16b\n"
-		       "	.long 4b,16b\n"
-		       "	.long 41b,16b\n"
-		       "	.long 10b,16b\n"
-		       "	.long 51b,16b\n"
-		       "	.long 11b,16b\n"
-		       "	.long 61b,16b\n"
-		       "	.long 12b,16b\n"
-		       "	.long 71b,16b\n"
-		       "	.long 13b,16b\n"
-		       "	.long 81b,16b\n"
-		       "	.long 14b,16b\n"
-		       "	.long 91b,16b\n"
-		       "	.long 6b,9b\n"
-		       "        .long 7b,16b\n"
-		       ".previous"
+		       _ASM_EXTABLE(0b,16b)
+		       _ASM_EXTABLE(1b,16b)
+		       _ASM_EXTABLE(2b,16b)
+		       _ASM_EXTABLE(21b,16b)
+		       _ASM_EXTABLE(3b,16b)
+		       _ASM_EXTABLE(31b,16b)
+		       _ASM_EXTABLE(4b,16b)
+		       _ASM_EXTABLE(41b,16b)
+		       _ASM_EXTABLE(10b,16b)
+		       _ASM_EXTABLE(51b,16b)
+		       _ASM_EXTABLE(11b,16b)
+		       _ASM_EXTABLE(61b,16b)
+		       _ASM_EXTABLE(12b,16b)
+		       _ASM_EXTABLE(71b,16b)
+		       _ASM_EXTABLE(13b,16b)
+		       _ASM_EXTABLE(81b,16b)
+		       _ASM_EXTABLE(14b,16b)
+		       _ASM_EXTABLE(91b,16b)
+		       _ASM_EXTABLE(6b,9b)
+		       _ASM_EXTABLE(7b,16b)
 		       : "=&c"(size), "=&D" (d0), "=&S" (d1)
 		       :  "1"(to), "2"(from), "0"(size)
 		       : "eax", "edx", "memory");
@@ -414,29 +406,26 @@ static unsigned long __copy_user_zeroing_intel_nocache(void *to,
 	       "        popl %0\n"
 	       "        jmp 8b\n"
 	       ".previous\n"
-	       ".section __ex_table,\"a\"\n"
-	       "	.align 4\n"
-	       "	.long 0b,16b\n"
-	       "	.long 1b,16b\n"
-	       "	.long 2b,16b\n"
-	       "	.long 21b,16b\n"
-	       "	.long 3b,16b\n"
-	       "	.long 31b,16b\n"
-	       "	.long 4b,16b\n"
-	       "	.long 41b,16b\n"
-	       "	.long 10b,16b\n"
-	       "	.long 51b,16b\n"
-	       "	.long 11b,16b\n"
-	       "	.long 61b,16b\n"
-	       "	.long 12b,16b\n"
-	       "	.long 71b,16b\n"
-	       "	.long 13b,16b\n"
-	       "	.long 81b,16b\n"
-	       "	.long 14b,16b\n"
-	       "	.long 91b,16b\n"
-	       "	.long 6b,9b\n"
-	       "        .long 7b,16b\n"
-	       ".previous"
+	       _ASM_EXTABLE(0b,16b)
+	       _ASM_EXTABLE(1b,16b)
+	       _ASM_EXTABLE(2b,16b)
+	       _ASM_EXTABLE(21b,16b)
+	       _ASM_EXTABLE(3b,16b)
+	       _ASM_EXTABLE(31b,16b)
+	       _ASM_EXTABLE(4b,16b)
+	       _ASM_EXTABLE(41b,16b)
+	       _ASM_EXTABLE(10b,16b)
+	       _ASM_EXTABLE(51b,16b)
+	       _ASM_EXTABLE(11b,16b)
+	       _ASM_EXTABLE(61b,16b)
+	       _ASM_EXTABLE(12b,16b)
+	       _ASM_EXTABLE(71b,16b)
+	       _ASM_EXTABLE(13b,16b)
+	       _ASM_EXTABLE(81b,16b)
+	       _ASM_EXTABLE(14b,16b)
+	       _ASM_EXTABLE(91b,16b)
+	       _ASM_EXTABLE(6b,9b)
+	       _ASM_EXTABLE(7b,16b)
 	       : "=&c"(size), "=&D" (d0), "=&S" (d1)
 	       :  "1"(to), "2"(from), "0"(size)
 	       : "eax", "edx", "memory");
@@ -505,29 +494,26 @@ static unsigned long __copy_user_intel_nocache(void *to,
 	       "9:      lea 0(%%eax,%0,4),%0\n"
 	       "16:     jmp 8b\n"
 	       ".previous\n"
-	       ".section __ex_table,\"a\"\n"
-	       "	.align 4\n"
-	       "	.long 0b,16b\n"
-	       "	.long 1b,16b\n"
-	       "	.long 2b,16b\n"
-	       "	.long 21b,16b\n"
-	       "	.long 3b,16b\n"
-	       "	.long 31b,16b\n"
-	       "	.long 4b,16b\n"
-	       "	.long 41b,16b\n"
-	       "	.long 10b,16b\n"
-	       "	.long 51b,16b\n"
-	       "	.long 11b,16b\n"
-	       "	.long 61b,16b\n"
-	       "	.long 12b,16b\n"
-	       "	.long 71b,16b\n"
-	       "	.long 13b,16b\n"
-	       "	.long 81b,16b\n"
-	       "	.long 14b,16b\n"
-	       "	.long 91b,16b\n"
-	       "	.long 6b,9b\n"
-	       "        .long 7b,16b\n"
-	       ".previous"
+	       _ASM_EXTABLE(0b,16b)
+	       _ASM_EXTABLE(1b,16b)
+	       _ASM_EXTABLE(2b,16b)
+	       _ASM_EXTABLE(21b,16b)
+	       _ASM_EXTABLE(3b,16b)
+	       _ASM_EXTABLE(31b,16b)
+	       _ASM_EXTABLE(4b,16b)
+	       _ASM_EXTABLE(41b,16b)
+	       _ASM_EXTABLE(10b,16b)
+	       _ASM_EXTABLE(51b,16b)
+	       _ASM_EXTABLE(11b,16b)
+	       _ASM_EXTABLE(61b,16b)
+	       _ASM_EXTABLE(12b,16b)
+	       _ASM_EXTABLE(71b,16b)
+	       _ASM_EXTABLE(13b,16b)
+	       _ASM_EXTABLE(81b,16b)
+	       _ASM_EXTABLE(14b,16b)
+	       _ASM_EXTABLE(91b,16b)
+	       _ASM_EXTABLE(6b,9b)
+	       _ASM_EXTABLE(7b,16b)
 	       : "=&c"(size), "=&D" (d0), "=&S" (d1)
 	       :  "1"(to), "2"(from), "0"(size)
 	       : "eax", "edx", "memory");
@@ -574,12 +560,9 @@ do {									\
 		"3:	lea 0(%3,%0,4),%0\n"				\
 		"	jmp 2b\n"					\
 		".previous\n"						\
-		".section __ex_table,\"a\"\n"				\
-		"	.align 4\n"					\
-		"	.long 4b,5b\n"					\
-		"	.long 0b,3b\n"					\
-		"	.long 1b,2b\n"					\
-		".previous"						\
+		_ASM_EXTABLE(4b,5b)					\
+		_ASM_EXTABLE(0b,3b)					\
+		_ASM_EXTABLE(1b,2b)					\
 		: "=&c"(size), "=&D" (__d0), "=&S" (__d1), "=r"(__d2)	\
 		: "3"(size), "0"(size), "1"(to), "2"(from)		\
 		: "memory");						\
@@ -616,12 +599,9 @@ do {									\
 		"	popl %0\n"					\
 		"	jmp 2b\n"					\
 		".previous\n"						\
-		".section __ex_table,\"a\"\n"				\
-		"	.align 4\n"					\
-		"	.long 4b,5b\n"					\
-		"	.long 0b,3b\n"					\
-		"	.long 1b,6b\n"					\
-		".previous"						\
+		_ASM_EXTABLE(4b,5b)					\
+		_ASM_EXTABLE(0b,3b)					\
+		_ASM_EXTABLE(1b,6b)					\
 		: "=&c"(size), "=&D" (__d0), "=&S" (__d1), "=r"(__d2)	\
 		: "3"(size), "0"(size), "1"(to), "2"(from)		\
 		: "memory");						\
diff --git a/arch/x86/mm/extable.c b/arch/x86/mm/extable.c
index 1fb85db..903ec1e 100644
--- a/arch/x86/mm/extable.c
+++ b/arch/x86/mm/extable.c
@@ -1,11 +1,23 @@
 #include <linux/module.h>
 #include <linux/spinlock.h>
+#include <linux/sort.h>
 #include <asm/uaccess.h>
 
+static inline unsigned long
+ex_insn_addr(const struct exception_table_entry *x)
+{
+	return (unsigned long)&x->insn + x->insn;
+}
+static inline unsigned long
+ex_fixup_addr(const struct exception_table_entry *x)
+{
+	return (unsigned long)&x->fixup + x->fixup;
+}
 
 int fixup_exception(struct pt_regs *regs)
 {
 	const struct exception_table_entry *fixup;
+	unsigned long new_ip;
 
 #ifdef CONFIG_PNPBIOS
 	if (unlikely(SEGMENT_IS_PNP_CODE(regs->cs))) {
@@ -23,15 +35,135 @@ int fixup_exception(struct pt_regs *regs)
 
 	fixup = search_exception_tables(regs->ip);
 	if (fixup) {
-		/* If fixup is less than 16, it means uaccess error */
-		if (fixup->fixup < 16) {
+		new_ip = ex_fixup_addr(fixup);
+
+		if (fixup->fixup - fixup->insn >= 0x7ffffff0 - 4) {
+			/* Special hack for uaccess_err */
 			current_thread_info()->uaccess_err = 1;
-			regs->ip += fixup->fixup;
-			return 1;
+			new_ip -= 0x7ffffff0;
 		}
-		regs->ip = fixup->fixup;
+		regs->ip = new_ip;
 		return 1;
 	}
 
 	return 0;
 }
+
+/* Restricted version used during very early boot */
+int __init early_fixup_exception(unsigned long *ip)
+{
+	const struct exception_table_entry *fixup;
+	unsigned long new_ip;
+
+	fixup = search_exception_tables(*ip);
+	if (fixup) {
+		new_ip = ex_fixup_addr(fixup);
+
+		if (fixup->fixup - fixup->insn >= 0x7ffffff0 - 4) {
+			/* uaccess handling not supported during early boot */
+			return 0;
+		}
+
+		*ip = new_ip;
+		return 1;
+	}
+
+	return 0;
+}
+
+/*
+ * Search one exception table for an entry corresponding to the
+ * given instruction address, and return the address of the entry,
+ * or NULL if none is found.
+ * We use a binary search, and thus we assume that the table is
+ * already sorted.
+ */
+const struct exception_table_entry *
+search_extable(const struct exception_table_entry *first,
+	       const struct exception_table_entry *last,
+	       unsigned long value)
+{
+	while (first <= last) {
+		const struct exception_table_entry *mid;
+		unsigned long addr;
+
+		mid = ((last - first) >> 1) + first;
+		addr = ex_insn_addr(mid);
+		if (addr < value)
+			first = mid + 1;
+		else if (addr > value)
+			last = mid - 1;
+		else
+			return mid;
+        }
+        return NULL;
+}
+
+/*
+ * The exception table needs to be sorted so that the binary
+ * search that we use to find entries in it works properly.
+ * This is used both for the kernel exception table and for
+ * the exception tables of modules that get loaded.
+ *
+ */
+static int cmp_ex(const void *a, const void *b)
+{
+	const struct exception_table_entry *x = a, *y = b;
+
+	/*
+	 * This value will always end up fittin in an int, because on
+	 * both i386 and x86-64 the kernel symbol-reachable address
+	 * space is < 2 GiB.
+	 *
+	 * This compare is only valid after normalization.
+	 */
+	return x->insn - y->insn;
+}
+
+void sort_extable(struct exception_table_entry *start,
+		  struct exception_table_entry *finish)
+{
+	struct exception_table_entry *p;
+	int i;
+
+	/* Convert all entries to being relative to the start of the section */
+	i = 0;
+	for (p = start; p < finish; p++) {
+		p->insn += i;
+		i += 4;
+		p->fixup += i;
+		i += 4;
+	}
+
+	sort(start, finish - start, sizeof(struct exception_table_entry),
+	     cmp_ex, NULL);
+
+	/* Denormalize all entries */
+	i = 0;
+	for (p = start; p < finish; p++) {
+		p->insn -= i;
+		i += 4;
+		p->fixup -= i;
+		i += 4;
+	}
+}
+
+#ifdef CONFIG_MODULES
+/*
+ * If the exception table is sorted, any referring to the module init
+ * will be at the beginning or the end.
+ */
+void trim_init_extable(struct module *m)
+{
+	/*trim the beginning*/
+	while (m->num_exentries &&
+	       within_module_init(ex_insn_addr(&m->extable[0]), m)) {
+		m->extable++;
+		m->num_exentries--;
+	}
+	/*trim the end*/
+	while (m->num_exentries &&
+	       within_module_init(ex_insn_addr(&m->extable[m->num_exentries-1]), m))
+		m->num_exentries--;
+}
+#endif /* CONFIG_MODULES */
diff --git a/arch/x86/um/checksum_32.S b/arch/x86/um/checksum_32.S
index f058d2f..8d0c420 100644
--- a/arch/x86/um/checksum_32.S
+++ b/arch/x86/um/checksum_32.S
@@ -26,6 +26,7 @@
  */
 
 #include <asm/errno.h>
+#include <asm/asm.h>
 				
 /*
  * computes a partial checksum, e.g. for TCP/UDP fragments
@@ -232,15 +233,11 @@ unsigned int csum_partial_copy_generic (const char *src, char *dst,
 
 #define SRC(y...)			\
 	9999: y;			\
-	.section __ex_table, "a";	\
-	.long 9999b, 6001f	;	\
-	.previous
+	_ASM_EXTABLE(9999b, 6001f)
 
 #define DST(y...)			\
 	9999: y;			\
-	.section __ex_table, "a";	\
-	.long 9999b, 6002f	;	\
-	.previous
+	_ASM_EXTABLE(9999b, 6002f)
 
 .align 4
 
diff --git a/arch/x86/xen/xen-asm_32.S b/arch/x86/xen/xen-asm_32.S
index b040b0e..f9643fc 100644
--- a/arch/x86/xen/xen-asm_32.S
+++ b/arch/x86/xen/xen-asm_32.S
@@ -14,6 +14,7 @@
 #include <asm/thread_info.h>
 #include <asm/processor-flags.h>
 #include <asm/segment.h>
+#include <asm/asm.h>
 
 #include <xen/interface/xen.h>
 
@@ -137,10 +138,7 @@ iret_restore_end:
 
 1:	iret
 xen_iret_end_crit:
-.section __ex_table, "a"
-	.align 4
-	.long 1b, iret_exc
-.previous
+	_ASM_EXTABLE(1b, iret_exc)
 
 hyper_iret:
 	/* put this out of line since its very rarely used */
diff --git a/init/Kconfig b/init/Kconfig
index 6cfd71d..92a1296 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -27,6 +27,9 @@ config IRQ_WORK
 	bool
 	depends on HAVE_IRQ_WORK
 
+config BUILDTIME_EXTABLE_SORT
+	bool
+
 menu "General setup"
 
 config EXPERIMENTAL
diff --git a/kernel/extable.c b/kernel/extable.c
index 5339705..fe35a63 100644
--- a/kernel/extable.c
+++ b/kernel/extable.c
@@ -35,10 +35,16 @@ DEFINE_MUTEX(text_mutex);
 extern struct exception_table_entry __start___ex_table[];
 extern struct exception_table_entry __stop___ex_table[];
 
+/* Cleared by build time tools if the table is already sorted. */
+u32 __initdata main_extable_sort_needed = 1;
+
 /* Sort the kernel's built-in exception table */
 void __init sort_main_extable(void)
 {
-	sort_extable(__start___ex_table, __stop___ex_table);
+	if (main_extable_sort_needed)
+		sort_extable(__start___ex_table, __stop___ex_table);
+	else
+		pr_notice("__ex_table already sorted, skipping sort\n");
 }
 
 /* Given an address, look for it in the exception tables. */
diff --git a/scripts/.gitignore b/scripts/.gitignore
index 105b21f..65f362d 100644
--- a/scripts/.gitignore
+++ b/scripts/.gitignore
@@ -9,3 +9,4 @@ unifdef
 ihex2fw
 recordmcount
 docproc
+sortextable
diff --git a/scripts/Makefile b/scripts/Makefile
index df7678f..9eace52 100644
--- a/scripts/Makefile
+++ b/scripts/Makefile
@@ -13,6 +13,9 @@ hostprogs-$(CONFIG_LOGO)         += pnmtologo
 hostprogs-$(CONFIG_VT)           += conmakehash
 hostprogs-$(CONFIG_IKCONFIG)     += bin2c
 hostprogs-$(BUILD_C_RECORDMCOUNT) += recordmcount
+hostprogs-$(CONFIG_BUILDTIME_EXTABLE_SORT) += sortextable
+
+HOSTCFLAGS_sortextable.o = -I$(srctree)/tools/include
 
 always		:= $(hostprogs-y) $(hostprogs-m)
 
diff --git a/scripts/sortextable.c b/scripts/sortextable.c
new file mode 100644
index 0000000..1ca9ceb
--- /dev/null
+++ b/scripts/sortextable.c
@@ -0,0 +1,322 @@
+/*
+ * sortextable.c: Sort the kernel's exception table
+ *
+ * Copyright 2011 - 2012 Cavium, Inc.
+ *
+ * Based on code taken from recortmcount.c which is:
+ *
+ * Copyright 2009 John F. Reiser <jreiser@BitWagon.com>.  All rights reserved.
+ * Licensed under the GNU General Public License, version 2 (GPLv2).
+ *
+ * Restructured to fit Linux format, as well as other updates:
+ *  Copyright 2010 Steven Rostedt <srostedt@redhat.com>, Red Hat Inc.
+ */
+
+/*
+ * Strategy: alter the vmlinux file in-place.
+ */
+
+#include <sys/types.h>
+#include <sys/mman.h>
+#include <sys/stat.h>
+#include <getopt.h>
+#include <elf.h>
+#include <fcntl.h>
+#include <setjmp.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+
+#include <tools/be_byteshift.h>
+#include <tools/le_byteshift.h>
+
+static int fd_map;	/* File descriptor for file being modified. */
+static int mmap_failed; /* Boolean flag. */
+static void *ehdr_curr; /* current ElfXX_Ehdr *  for resource cleanup */
+static struct stat sb;	/* Remember .st_size, etc. */
+static jmp_buf jmpenv;	/* setjmp/longjmp per-file error escape */
+
+/* setjmp() return values */
+enum {
+	SJ_SETJMP = 0,  /* hardwired first return */
+	SJ_FAIL,
+	SJ_SUCCEED
+};
+
+/* Per-file resource cleanup when multiple files. */
+static void
+cleanup(void)
+{
+	if (!mmap_failed)
+		munmap(ehdr_curr, sb.st_size);
+	close(fd_map);
+}
+
+static void __attribute__((noreturn))
+fail_file(void)
+{
+	cleanup();
+	longjmp(jmpenv, SJ_FAIL);
+}
+
+static void __attribute__((noreturn))
+succeed_file(void)
+{
+	cleanup();
+	longjmp(jmpenv, SJ_SUCCEED);
+}
+
+
+/*
+ * Get the whole file as a programming convenience in order to avoid
+ * malloc+lseek+read+free of many pieces.  If successful, then mmap
+ * avoids copying unused pieces; else just read the whole file.
+ * Open for both read and write.
+ */
+static void *mmap_file(char const *fname)
+{
+	void *addr;
+
+	fd_map = open(fname, O_RDWR);
+	if (fd_map < 0 || fstat(fd_map, &sb) < 0) {
+		perror(fname);
+		fail_file();
+	}
+	if (!S_ISREG(sb.st_mode)) {
+		fprintf(stderr, "not a regular file: %s\n", fname);
+		fail_file();
+	}
+	addr = mmap(0, sb.st_size, PROT_READ|PROT_WRITE, MAP_SHARED,
+		    fd_map, 0);
+	if (addr == MAP_FAILED) {
+		mmap_failed = 1;
+		fprintf(stderr, "Could not mmap file: %s\n", fname);
+		fail_file();
+	}
+	return addr;
+}
+
+static uint64_t r8be(const uint64_t *x)
+{
+	return get_unaligned_be64(x);
+}
+static uint32_t rbe(const uint32_t *x)
+{
+	return get_unaligned_be32(x);
+}
+static uint16_t r2be(const uint16_t *x)
+{
+	return get_unaligned_be16(x);
+}
+static uint64_t r8le(const uint64_t *x)
+{
+	return get_unaligned_le64(x);
+}
+static uint32_t rle(const uint32_t *x)
+{
+	return get_unaligned_le32(x);
+}
+static uint16_t r2le(const uint16_t *x)
+{
+	return get_unaligned_le16(x);
+}
+
+static void w8be(uint64_t val, uint64_t *x)
+{
+	put_unaligned_be64(val, x);
+}
+static void wbe(uint32_t val, uint32_t *x)
+{
+	put_unaligned_be32(val, x);
+}
+static void w2be(uint16_t val, uint16_t *x)
+{
+	put_unaligned_be16(val, x);
+}
+static void w8le(uint64_t val, uint64_t *x)
+{
+	put_unaligned_le64(val, x);
+}
+static void wle(uint32_t val, uint32_t *x)
+{
+	put_unaligned_le32(val, x);
+}
+static void w2le(uint16_t val, uint16_t *x)
+{
+	put_unaligned_le16(val, x);
+}
+
+static uint64_t (*r8)(const uint64_t *);
+static uint32_t (*r)(const uint32_t *);
+static uint16_t (*r2)(const uint16_t *);
+static void (*w8)(uint64_t, uint64_t *);
+static void (*w)(uint32_t, uint32_t *);
+static void (*w2)(uint16_t, uint16_t *);
+
+typedef void (*table_sort_t)(char *, int);
+
+/* 32 bit and 64 bit are very similar */
+#include "sortextable.h"
+#define SORTEXTABLE_64
+#include "sortextable.h"
+
+static int compare_x86_table(const void *a, const void *b)
+{
+	int32_t av = (int32_t)r(a);
+	int32_t bv = (int32_t)r(b);
+
+	if (av < bv)
+		return -1;
+	if (av > bv)
+		return 1;
+	return 0;
+}
+
+static void sort_x86_table(char *extab_image, int image_size)
+{
+	int i;
+
+	/*
+	 * Do the same thing the runtime sort does, first normalize to
+	 * being relative to the start of the section.
+	 */
+	i = 0;
+	while (i < image_size) {
+		uint32_t *loc = (uint32_t *)(extab_image + i);
+		w(r(loc) + i, loc);
+		i += 4;
+	}
+
+	qsort(extab_image, image_size / 8, 8, compare_x86_table);
+
+	/* Now denormalize. */
+	i = 0;
+	while (i < image_size) {
+		uint32_t *loc = (uint32_t *)(extab_image + i);
+		w(r(loc) - i, loc);
+		i += 4;
+	}
+}
+
+static void
+do_file(char const *const fname)
+{
+	table_sort_t custom_sort;
+	Elf32_Ehdr *ehdr = mmap_file(fname);
+
+	ehdr_curr = ehdr;
+	switch (ehdr->e_ident[EI_DATA]) {
+	default:
+		fprintf(stderr, "unrecognized ELF data encoding %d: %s\n",
+			ehdr->e_ident[EI_DATA], fname);
+		fail_file();
+		break;
+	case ELFDATA2LSB:
+		r = rle;
+		r2 = r2le;
+		r8 = r8le;
+		w = wle;
+		w2 = w2le;
+		w8 = w8le;
+		break;
+	case ELFDATA2MSB:
+		r = rbe;
+		r2 = r2be;
+		r8 = r8be;
+		w = wbe;
+		w2 = w2be;
+		w8 = w8be;
+		break;
+	}  /* end switch */
+	if (memcmp(ELFMAG, ehdr->e_ident, SELFMAG) != 0
+	||  r2(&ehdr->e_type) != ET_EXEC
+	||  ehdr->e_ident[EI_VERSION] != EV_CURRENT) {
+		fprintf(stderr, "unrecognized ET_EXEC file %s\n", fname);
+		fail_file();
+	}
+
+	custom_sort = NULL;
+	switch (r2(&ehdr->e_machine)) {
+	default:
+		fprintf(stderr, "unrecognized e_machine %d %s\n",
+			r2(&ehdr->e_machine), fname);
+		fail_file();
+		break;
+	case EM_386:
+	case EM_X86_64:
+		custom_sort = sort_x86_table;
+		break;
+	case EM_MIPS:
+		break;
+	}  /* end switch */
+
+	switch (ehdr->e_ident[EI_CLASS]) {
+	default:
+		fprintf(stderr, "unrecognized ELF class %d %s\n",
+			ehdr->e_ident[EI_CLASS], fname);
+		fail_file();
+		break;
+	case ELFCLASS32:
+		if (r2(&ehdr->e_ehsize) != sizeof(Elf32_Ehdr)
+		||  r2(&ehdr->e_shentsize) != sizeof(Elf32_Shdr)) {
+			fprintf(stderr,
+				"unrecognized ET_EXEC file: %s\n", fname);
+			fail_file();
+		}
+		do32(ehdr, fname, custom_sort);
+		break;
+	case ELFCLASS64: {
+		Elf64_Ehdr *const ghdr = (Elf64_Ehdr *)ehdr;
+		if (r2(&ghdr->e_ehsize) != sizeof(Elf64_Ehdr)
+		||  r2(&ghdr->e_shentsize) != sizeof(Elf64_Shdr)) {
+			fprintf(stderr,
+				"unrecognized ET_EXEC file: %s\n", fname);
+			fail_file();
+		}
+		do64(ghdr, fname, custom_sort);
+		break;
+	}
+	}  /* end switch */
+
+	cleanup();
+}
+
+int
+main(int argc, char *argv[])
+{
+	int n_error = 0;  /* gcc-4.3.0 false positive complaint */
+	int i;
+
+	if (argc < 2) {
+		fprintf(stderr, "usage: sortextable vmlinux...\n");
+		return 0;
+	}
+
+	/* Process each file in turn, allowing deep failure. */
+	for (i = 1; i < argc; i++) {
+		char *file = argv[i];
+		int const sjval = setjmp(jmpenv);
+
+		switch (sjval) {
+		default:
+			fprintf(stderr, "internal error: %s\n", file);
+			exit(1);
+			break;
+		case SJ_SETJMP:    /* normal sequence */
+			/* Avoid problems if early cleanup() */
+			fd_map = -1;
+			ehdr_curr = NULL;
+			mmap_failed = 1;
+			do_file(file);
+			break;
+		case SJ_FAIL:    /* error in do_file or below */
+			++n_error;
+			break;
+		case SJ_SUCCEED:    /* premature success */
+			/* do nothing */
+			break;
+		}  /* end switch */
+	}
+	return !!n_error;
+}
diff --git a/scripts/sortextable.h b/scripts/sortextable.h
new file mode 100644
index 0000000..e4fd45b
--- /dev/null
+++ b/scripts/sortextable.h
@@ -0,0 +1,191 @@
+/*
+ * sortextable.h
+ *
+ * Copyright 2011 - 2012 Cavium, Inc.
+ *
+ * Some of this code was taken out of recordmcount.h written by:
+ *
+ * Copyright 2009 John F. Reiser <jreiser@BitWagon.com>.  All rights reserved.
+ * Copyright 2010 Steven Rostedt <srostedt@redhat.com>, Red Hat Inc.
+ *
+ *
+ * Licensed under the GNU General Public License, version 2 (GPLv2).
+ */
+
+#undef extable_ent_size
+#undef compare_extable
+#undef do_func
+#undef Elf_Addr
+#undef Elf_Ehdr
+#undef Elf_Shdr
+#undef Elf_Rel
+#undef Elf_Rela
+#undef Elf_Sym
+#undef ELF_R_SYM
+#undef Elf_r_sym
+#undef ELF_R_INFO
+#undef Elf_r_info
+#undef ELF_ST_BIND
+#undef ELF_ST_TYPE
+#undef fn_ELF_R_SYM
+#undef fn_ELF_R_INFO
+#undef uint_t
+#undef _r
+#undef _w
+
+#ifdef SORTEXTABLE_64
+# define extable_ent_size	16
+# define compare_extable	compare_extable_64
+# define do_func		do64
+# define Elf_Addr		Elf64_Addr
+# define Elf_Ehdr		Elf64_Ehdr
+# define Elf_Shdr		Elf64_Shdr
+# define Elf_Rel		Elf64_Rel
+# define Elf_Rela		Elf64_Rela
+# define Elf_Sym		Elf64_Sym
+# define ELF_R_SYM		ELF64_R_SYM
+# define Elf_r_sym		Elf64_r_sym
+# define ELF_R_INFO		ELF64_R_INFO
+# define Elf_r_info		Elf64_r_info
+# define ELF_ST_BIND		ELF64_ST_BIND
+# define ELF_ST_TYPE		ELF64_ST_TYPE
+# define fn_ELF_R_SYM		fn_ELF64_R_SYM
+# define fn_ELF_R_INFO		fn_ELF64_R_INFO
+# define uint_t			uint64_t
+# define _r			r8
+# define _w			w8
+#else
+# define extable_ent_size	8
+# define compare_extable	compare_extable_32
+# define do_func		do32
+# define Elf_Addr		Elf32_Addr
+# define Elf_Ehdr		Elf32_Ehdr
+# define Elf_Shdr		Elf32_Shdr
+# define Elf_Rel		Elf32_Rel
+# define Elf_Rela		Elf32_Rela
+# define Elf_Sym		Elf32_Sym
+# define ELF_R_SYM		ELF32_R_SYM
+# define Elf_r_sym		Elf32_r_sym
+# define ELF_R_INFO		ELF32_R_INFO
+# define Elf_r_info		Elf32_r_info
+# define ELF_ST_BIND		ELF32_ST_BIND
+# define ELF_ST_TYPE		ELF32_ST_TYPE
+# define fn_ELF_R_SYM		fn_ELF32_R_SYM
+# define fn_ELF_R_INFO		fn_ELF32_R_INFO
+# define uint_t			uint32_t
+# define _r			r
+# define _w			w
+#endif
+
+static int compare_extable(const void *a, const void *b)
+{
+	Elf_Addr av = _r(a);
+	Elf_Addr bv = _r(b);
+
+	if (av < bv)
+		return -1;
+	if (av > bv)
+		return 1;
+	return 0;
+}
+
+static void
+do_func(Elf_Ehdr *ehdr, char const *const fname, table_sort_t custom_sort)
+{
+	Elf_Shdr *shdr;
+	Elf_Shdr *shstrtab_sec;
+	Elf_Shdr *strtab_sec = NULL;
+	Elf_Shdr *symtab_sec = NULL;
+	Elf_Shdr *extab_sec = NULL;
+	Elf_Sym *sym;
+	Elf_Sym *sort_needed_sym;
+	Elf_Shdr *sort_needed_sec;
+	Elf_Rel *relocs = NULL;
+	int relocs_size;
+	uint32_t *sort_done_location;
+	const char *secstrtab;
+	const char *strtab;
+	char *extab_image;
+	int extab_index = 0;
+	int i;
+	int idx;
+
+	shdr = (Elf_Shdr *)((char *)ehdr + _r(&ehdr->e_shoff));
+	shstrtab_sec = shdr + r2(&ehdr->e_shstrndx);
+	secstrtab = (const char *)ehdr + _r(&shstrtab_sec->sh_offset);
+	for (i = 0; i < r2(&ehdr->e_shnum); i++) {
+		idx = r(&shdr[i].sh_name);
+		if (strcmp(secstrtab + idx, "__ex_table") == 0) {
+			extab_sec = shdr + i;
+			extab_index = i;
+		}
+		if ((r(&shdr[i].sh_type) == SHT_REL ||
+		     r(&shdr[i].sh_type) == SHT_RELA) &&
+		    r(&shdr[i].sh_info) == extab_index) {
+			relocs = (void *)ehdr + _r(&shdr[i].sh_offset);
+			relocs_size = _r(&shdr[i].sh_size);
+		}
+		if (strcmp(secstrtab + idx, ".symtab") == 0)
+			symtab_sec = shdr + i;
+		if (strcmp(secstrtab + idx, ".strtab") == 0)
+			strtab_sec = shdr + i;
+	}
+	if (strtab_sec == NULL) {
+		fprintf(stderr,	"no .strtab in  file: %s\n", fname);
+		fail_file();
+	}
+	if (symtab_sec == NULL) {
+		fprintf(stderr,	"no .symtab in  file: %s\n", fname);
+		fail_file();
+	}
+	if (extab_sec == NULL) {
+		fprintf(stderr,	"no __ex_table in  file: %s\n", fname);
+		fail_file();
+	}
+	strtab = (const char *)ehdr + _r(&strtab_sec->sh_offset);
+
+	extab_image = (void *)ehdr + _r(&extab_sec->sh_offset);
+
+	if (custom_sort) {
+		custom_sort(extab_image, _r(&extab_sec->sh_size));
+	} else {
+		int num_entries = _r(&extab_sec->sh_size) / extable_ent_size;
+		qsort(extab_image, num_entries,
+		      extable_ent_size, compare_extable);
+	}
+	/* If there were relocations, we no longer need them. */
+	if (relocs)
+		memset(relocs, 0, relocs_size);
+
+	/* find main_extable_sort_needed */
+	sort_needed_sym = NULL;
+	for (i = 0; i < _r(&symtab_sec->sh_size) / sizeof(Elf_Sym); i++) {
+		sym = (void *)ehdr + _r(&symtab_sec->sh_offset);
+		sym += i;
+		if (ELF_ST_TYPE(sym->st_info) != STT_OBJECT)
+			continue;
+		idx = r(&sym->st_name);
+		if (strcmp(strtab + idx, "main_extable_sort_needed") == 0) {
+			sort_needed_sym = sym;
+			break;
+		}
+	}
+	if (sort_needed_sym == NULL) {
+		fprintf(stderr,
+			"no main_extable_sort_needed symbol in  file: %s\n",
+			fname);
+		fail_file();
+	}
+	sort_needed_sec = &shdr[r2(&sort_needed_sym->st_shndx)];
+	sort_done_location = (void *)ehdr +
+		_r(&sort_needed_sec->sh_offset) +
+		_r(&sort_needed_sym->st_value) -
+		_r(&sort_needed_sec->sh_addr);
+
+#if 1
+	printf("sort done marker at %lx\n",
+	       (unsigned long)((char *)sort_done_location - (char *)ehdr));
+#endif
+	/* We sorted it, clear the flag. */
+	w(0, sort_done_location);
+}
