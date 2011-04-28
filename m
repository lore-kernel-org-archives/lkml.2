Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547Ab1D1IP7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 04:15:59 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:42951 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754783Ab1D1IPz convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:4:1>);
	Thu, 28 Apr 2011 04:15:55 -0400
Message-Id: <4DB93EA4020000780003E95C@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Thu, 28 Apr 2011 09:17:08 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <tony.luck@intel.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH, v2 1/3, resend] x86-64: use macros to generate
	 exception table entries
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert all open coded uses in x86-64 and common x86 code to use the
macros that are available, thus subsequently allowing to change the
actual implementation without having to touch dozens of places.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Tony Luck <tony.luck@intel.com>

---
 arch/x86/ia32/ia32entry.S           |    9 +----
 arch/x86/include/asm/kvm_host.h     |    4 --
 arch/x86/include/asm/xsave.h        |   10 +-----
 arch/x86/kernel/entry_64.S          |   14 ++------
 arch/x86/kernel/test_rodata.c       |   10 +-----
 arch/x86/lib/copy_user_64.S         |   58 +++++++++++++++---------------------
 arch/x86/lib/copy_user_nocache_64.S |   50 ++++++++++++++-----------------
 arch/x86/lib/csum-copy_64.S         |   16 ++-------
 arch/x86/lib/getuser.S              |    9 ++---
 arch/x86/lib/putuser.S              |   12 +++----
 10 files changed, 73 insertions(+), 119 deletions(-)

--- 2.6.39-rc5-extable.orig/arch/x86/ia32/ia32entry.S
+++ 2.6.39-rc5-extable/arch/x86/ia32/ia32entry.S
@@ -4,6 +4,7 @@
  * Copyright 2000-2002 Andi Kleen, SuSE Labs.
  */		 
 
+#include <asm/asm.h>
 #include <asm/dwarf2.h>
 #include <asm/calling.h>
 #include <asm/asm-offsets.h>
@@ -147,9 +148,7 @@ ENTRY(ia32_sysenter_target)
  	/* no need to do an access_ok check here because rbp has been
  	   32bit zero extended */ 
 1:	movl	(%rbp),%ebp
- 	.section __ex_table,"a"
- 	.quad 1b,ia32_badarg
- 	.previous	
+	_ASM_EXTABLE(1b, ia32_badarg)
 	GET_THREAD_INFO(%r10)
 	orl    $TS_COMPAT,TI_status(%r10)
 	testl  $_TIF_WORK_SYSCALL_ENTRY,TI_flags(%r10)
@@ -306,9 +305,7 @@ ENTRY(ia32_cstar_target)
 	   32bit zero extended */ 
 	/* hardware stack frame is complete now */	
 1:	movl	(%r8),%r9d
-	.section __ex_table,"a"
-	.quad 1b,ia32_badarg
-	.previous	
+	_ASM_EXTABLE(1b, ia32_badarg)
 	GET_THREAD_INFO(%r10)
 	orl   $TS_COMPAT,TI_status(%r10)
 	testl $_TIF_WORK_SYSCALL_ENTRY,TI_flags(%r10)
--- 2.6.39-rc5-extable.orig/arch/x86/include/asm/kvm_host.h
+++ 2.6.39-rc5-extable/arch/x86/include/asm/kvm_host.h
@@ -810,9 +810,7 @@ extern bool kvm_rebooting;
 	"jne 668b \n\t"      		      \
 	__ASM_SIZE(push) " $666b \n\t"	      \
 	"call kvm_spurious_fault \n\t"	      \
-	".popsection \n\t" \
-	".pushsection __ex_table, \"a\" \n\t" \
-	_ASM_PTR " 666b, 667b \n\t" \
+	_ASM_EXTABLE(666b, 667b) "\t" \
 	".popsection"
 
 #define KVM_ARCH_WANT_MMU_NOTIFIER
--- 2.6.39-rc5-extable.orig/arch/x86/include/asm/xsave.h
+++ 2.6.39-rc5-extable/arch/x86/include/asm/xsave.h
@@ -80,10 +80,7 @@ static inline int xsave_user(struct xsav
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
@@ -106,10 +103,7 @@ static inline int xrestore_user(struct x
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
--- 2.6.39-rc5-extable.orig/arch/x86/kernel/entry_64.S
+++ 2.6.39-rc5-extable/arch/x86/kernel/entry_64.S
@@ -43,6 +43,7 @@
 #include <asm/errno.h>
 #include <asm/dwarf2.h>
 #include <asm/calling.h>
+#include <asm/asm.h>
 #include <asm/asm-offsets.h>
 #include <asm/msr.h>
 #include <asm/unistd.h>
@@ -863,17 +864,13 @@ restore_args:
 irq_return:
 	INTERRUPT_RETURN
 
-	.section __ex_table, "a"
-	.quad irq_return, bad_iret
-	.previous
+	_ASM_EXTABLE(irq_return, bad_iret)
 
 #ifdef CONFIG_PARAVIRT
 ENTRY(native_iret)
 	iretq
 
-	.section __ex_table,"a"
-	.quad native_iret, bad_iret
-	.previous
+	_ASM_EXTABLE(native_iret, bad_iret)
 #endif
 
 	.section .fixup,"ax"
@@ -1138,10 +1135,7 @@ gs_change:
 	CFI_ENDPROC
 END(native_load_gs_index)
 
-	.section __ex_table,"a"
-	.align 8
-	.quad gs_change,bad_gs
-	.previous
+	_ASM_EXTABLE(gs_change, bad_gs)
 	.section .fixup,"ax"
 	/* running with kernelgs */
 bad_gs:
--- 2.6.39-rc5-extable.orig/arch/x86/kernel/test_rodata.c
+++ 2.6.39-rc5-extable/arch/x86/kernel/test_rodata.c
@@ -10,6 +10,7 @@
  * of the License.
  */
 #include <linux/module.h>
+#include <asm/asm.h>
 #include <asm/cacheflush.h>
 #include <asm/sections.h>
 
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
--- 2.6.39-rc5-extable.orig/arch/x86/lib/copy_user_64.S
+++ 2.6.39-rc5-extable/arch/x86/lib/copy_user_64.S
@@ -7,6 +7,7 @@
  */
 
 #include <linux/linkage.h>
+#include <asm/asm.h>
 #include <asm/dwarf2.h>
 
 #define FIX_ALIGNMENT 1
@@ -56,11 +57,8 @@
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
 
@@ -180,29 +178,26 @@ ENTRY(copy_user_generic_unrolled)
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
 
@@ -248,10 +243,7 @@ ENTRY(copy_user_generic_string)
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
--- 2.6.39-rc5-extable.orig/arch/x86/lib/copy_user_nocache_64.S
+++ 2.6.39-rc5-extable/arch/x86/lib/copy_user_nocache_64.S
@@ -7,6 +7,7 @@
  */
 
 #include <linux/linkage.h>
+#include <asm/asm.h>
 #include <asm/dwarf2.h>
 
 #define FIX_ALIGNMENT 1
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
--- 2.6.39-rc5-extable.orig/arch/x86/lib/csum-copy_64.S
+++ 2.6.39-rc5-extable/arch/x86/lib/csum-copy_64.S
@@ -6,6 +6,7 @@
  * for more details. No warranty for anything given at all.
  */
 #include <linux/linkage.h>
+#include <asm/asm.h>
 #include <asm/dwarf2.h>
 #include <asm/errno.h>
 
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
 
 
--- 2.6.39-rc5-extable.orig/arch/x86/lib/getuser.S
+++ 2.6.39-rc5-extable/arch/x86/lib/getuser.S
@@ -95,10 +95,9 @@ bad_get_user:
 	CFI_ENDPROC
 END(bad_get_user)
 
-.section __ex_table,"a"
-	_ASM_PTR 1b,bad_get_user
-	_ASM_PTR 2b,bad_get_user
-	_ASM_PTR 3b,bad_get_user
+	_ASM_EXTABLE(1b, bad_get_user)
+	_ASM_EXTABLE(2b, bad_get_user)
+	_ASM_EXTABLE(3b, bad_get_user)
 #ifdef CONFIG_X86_64
-	_ASM_PTR 4b,bad_get_user
+	_ASM_EXTABLE(4b, bad_get_user)
 #endif
--- 2.6.39-rc5-extable.orig/arch/x86/lib/putuser.S
+++ 2.6.39-rc5-extable/arch/x86/lib/putuser.S
@@ -86,12 +86,10 @@ bad_put_user:
 	EXIT
 END(bad_put_user)
 
-.section __ex_table,"a"
-	_ASM_PTR 1b,bad_put_user
-	_ASM_PTR 2b,bad_put_user
-	_ASM_PTR 3b,bad_put_user
-	_ASM_PTR 4b,bad_put_user
+	_ASM_EXTABLE(1b, bad_put_user)
+	_ASM_EXTABLE(2b, bad_put_user)
+	_ASM_EXTABLE(3b, bad_put_user)
+	_ASM_EXTABLE(4b, bad_put_user)
 #ifdef CONFIG_X86_32
-	_ASM_PTR 5b,bad_put_user
+	_ASM_EXTABLE(5b, bad_put_user)
 #endif
-.previous


