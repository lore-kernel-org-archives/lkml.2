Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759378Ab1D0PXK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 11:23:10 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:36016 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759344Ab1D0PXI convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:3:1>);
	Wed, 27 Apr 2011 11:23:08 -0400
Message-Id: <4DB85145020000780003E6AB@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 27 Apr 2011 16:24:21 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] x86: unify rwlock assembly implementation
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/include/asm/asm.h   |    3 +-
 arch/x86/include/asm/frame.h |   11 +++++-----
 arch/x86/lib/Makefile        |    6 +++--
 arch/x86/lib/rwlock.S        |   44 +++++++++++++++++++++++++++++++++++++++++++
 arch/x86/lib/rwlock_64.S     |   38 -------------------------------------
 arch/x86/lib/semaphore_32.S  |   44 -------------------------------------------
 6 files changed, 56 insertions(+), 90 deletions(-)

--- 2.6.39-rc5-x86-rw.orig/arch/x86/include/asm/asm.h
+++ 2.6.39-rc5-x86-rw/arch/x86/include/asm/asm.h
@@ -15,7 +15,8 @@
 # define __ASM_SEL(a,b) __ASM_FORM(b)
 #endif
 
-#define __ASM_SIZE(inst)	__ASM_SEL(inst##l, inst##q)
+#define __ASM_SIZE(inst, ...)	__ASM_SEL(inst##l##__VA_ARGS__, \
+					  inst##q##__VA_ARGS__)
 #define __ASM_REG(reg)		__ASM_SEL(e##reg, r##reg)
 
 #define _ASM_PTR	__ASM_SEL(.long, .quad)
--- 2.6.39-rc5-x86-rw.orig/arch/x86/include/asm/frame.h
+++ 2.6.39-rc5-x86-rw/arch/x86/include/asm/frame.h
@@ -1,5 +1,6 @@
 #ifdef __ASSEMBLY__
 
+#include <asm/asm.h>
 #include <asm/dwarf2.h>
 
 /* The annotation hides the frame from the unwinder and makes it look
@@ -7,13 +8,13 @@
    frame pointer later */
 #ifdef CONFIG_FRAME_POINTER
 	.macro FRAME
-	pushl_cfi %ebp
-	CFI_REL_OFFSET ebp,0
-	movl %esp,%ebp
+	__ASM_SIZE(push,_cfi)	%__ASM_REG(bp)
+	CFI_REL_OFFSET		__ASM_REG(bp), 0
+	__ASM_SIZE(mov)		%__ASM_REG(sp), %__ASM_REG(bp)
 	.endm
 	.macro ENDFRAME
-	popl_cfi %ebp
-	CFI_RESTORE ebp
+	__ASM_SIZE(pop,_cfi)	%__ASM_REG(bp)
+	CFI_RESTORE		__ASM_REG(bp)
 	.endm
 #else
 	.macro FRAME
--- 2.6.39-rc5-x86-rw.orig/arch/x86/lib/Makefile
+++ 2.6.39-rc5-x86-rw/arch/x86/lib/Makefile
@@ -20,6 +20,7 @@ lib-y := delay.o
 lib-y += thunk_$(BITS).o
 lib-y += usercopy_$(BITS).o getuser.o putuser.o
 lib-y += memcpy_$(BITS).o
+lib-$(CONFIG_SMP) += rwlock.o
 lib-$(CONFIG_INSTRUCTION_DECODER) += insn.o inat.o
 
 obj-y += msr.o msr-reg.o msr-reg-export.o
@@ -29,7 +30,8 @@ ifeq ($(CONFIG_X86_32),y)
         lib-y += atomic64_cx8_32.o
         lib-y += checksum_32.o
         lib-y += strstr_32.o
-        lib-y += semaphore_32.o string_32.o
+        lib-$(CONFIG_RWSEM_XCHGADD_ALGORITHM) += semaphore_32.o
+        lib-y += string_32.o
         lib-y += cmpxchg.o
 ifneq ($(CONFIG_X86_CMPXCHG64),y)
         lib-y += cmpxchg8b_emu.o atomic64_386_32.o
@@ -40,7 +42,7 @@ else
         lib-y += csum-partial_64.o csum-copy_64.o csum-wrappers_64.o
         lib-y += thunk_64.o clear_page_64.o copy_page_64.o
         lib-y += memmove_64.o memset_64.o
-        lib-y += copy_user_64.o rwlock_64.o copy_user_nocache_64.o
+        lib-y += copy_user_64.o copy_user_nocache_64.o
 	lib-$(CONFIG_RWSEM_XCHGADD_ALGORITHM) += rwsem_64.o
 	lib-y += cmpxchg16b_emu.o
 endif
--- /dev/null
+++ 2.6.39-rc5-x86-rw/arch/x86/lib/rwlock.S
@@ -0,0 +1,44 @@
+/* Slow paths of read/write spinlocks. */
+
+#include <linux/linkage.h>
+#include <asm/alternative-asm.h>
+#include <asm/frame.h>
+#include <asm/rwlock.h>
+
+#ifdef CONFIG_X86_32
+# define __lock_ptr eax
+#else
+# define __lock_ptr rdi
+#endif
+
+ENTRY(__write_lock_failed)
+	CFI_STARTPROC
+	FRAME
+0:	LOCK_PREFIX
+	addl	$RW_LOCK_BIAS, (%__lock_ptr)
+1:	rep; nop
+	cmpl	$RW_LOCK_BIAS, (%__lock_ptr)
+	jne	1b
+	LOCK_PREFIX
+	subl	$RW_LOCK_BIAS, (%__lock_ptr)
+	jnz	0b
+	ENDFRAME
+	ret
+	CFI_ENDPROC
+END(__write_lock_failed)
+
+ENTRY(__read_lock_failed)
+	CFI_STARTPROC
+	FRAME
+0:	LOCK_PREFIX
+	incl	(%__lock_ptr)
+1:	rep; nop
+	cmpl	$1, (%__lock_ptr)
+	js	1b
+	LOCK_PREFIX
+	decl	(%__lock_ptr)
+	js	0b
+	ENDFRAME
+	ret
+	CFI_ENDPROC
+END(__read_lock_failed)
--- 2.6.39-rc5-x86-rw.orig/arch/x86/lib/rwlock_64.S
+++ /dev/null
@@ -1,38 +0,0 @@
-/* Slow paths of read/write spinlocks. */
-
-#include <linux/linkage.h>
-#include <asm/rwlock.h>
-#include <asm/alternative-asm.h>
-#include <asm/dwarf2.h>
-
-/* rdi:	pointer to rwlock_t */
-ENTRY(__write_lock_failed)
-	CFI_STARTPROC
-	LOCK_PREFIX
-	addl $RW_LOCK_BIAS,(%rdi)
-1:	rep
-	nop
-	cmpl $RW_LOCK_BIAS,(%rdi)
-	jne 1b
-	LOCK_PREFIX
-	subl $RW_LOCK_BIAS,(%rdi)
-	jnz  __write_lock_failed
-	ret
-	CFI_ENDPROC
-END(__write_lock_failed)
-
-/* rdi:	pointer to rwlock_t */
-ENTRY(__read_lock_failed)
-	CFI_STARTPROC
-	LOCK_PREFIX
-	incl (%rdi)
-1:	rep
-	nop
-	cmpl $1,(%rdi)
-	js 1b
-	LOCK_PREFIX
-	decl (%rdi)
-	js __read_lock_failed
-	ret
-	CFI_ENDPROC
-END(__read_lock_failed)
--- 2.6.39-rc5-x86-rw.orig/arch/x86/lib/semaphore_32.S
+++ 2.6.39-rc5-x86-rw/arch/x86/lib/semaphore_32.S
@@ -14,8 +14,6 @@
  */
 
 #include <linux/linkage.h>
-#include <asm/rwlock.h>
-#include <asm/alternative-asm.h>
 #include <asm/frame.h>
 #include <asm/dwarf2.h>
 
@@ -31,46 +29,6 @@
  */
 	.section .sched.text, "ax"
 
-/*
- * rw spinlock fallbacks
- */
-#ifdef CONFIG_SMP
-ENTRY(__write_lock_failed)
-	CFI_STARTPROC
-	FRAME
-2: 	LOCK_PREFIX
-	addl	$ RW_LOCK_BIAS,(%eax)
-1:	rep; nop
-	cmpl	$ RW_LOCK_BIAS,(%eax)
-	jne	1b
-	LOCK_PREFIX
-	subl	$ RW_LOCK_BIAS,(%eax)
-	jnz	2b
-	ENDFRAME
-	ret
-	CFI_ENDPROC
-	ENDPROC(__write_lock_failed)
-
-ENTRY(__read_lock_failed)
-	CFI_STARTPROC
-	FRAME
-2: 	LOCK_PREFIX
-	incl	(%eax)
-1:	rep; nop
-	cmpl	$1,(%eax)
-	js	1b
-	LOCK_PREFIX
-	decl	(%eax)
-	js	2b
-	ENDFRAME
-	ret
-	CFI_ENDPROC
-	ENDPROC(__read_lock_failed)
-
-#endif
-
-#ifdef CONFIG_RWSEM_XCHGADD_ALGORITHM
-
 /* Fix up special calling conventions */
 ENTRY(call_rwsem_down_read_failed)
 	CFI_STARTPROC
@@ -120,5 +78,3 @@ ENTRY(call_rwsem_downgrade_wake)
 	ret
 	CFI_ENDPROC
 	ENDPROC(call_rwsem_downgrade_wake)
-
-#endif


