Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757091Ab2IVAQm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 20:16:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54464 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753744Ab2IVAQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 20:16:40 -0400
Date: Fri, 21 Sep 2012 17:16:26 -0700
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Message-ID: <tip-e59d1b0a24199db01978e6c1e89859eda93ce683@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1348256595-29119-9-git-send-email-hpa@linux.intel.com>
References: <1348256595-29119-9-git-send-email-hpa@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/smap] x86-32, smap: Add STAC/
 CLAC instructions to 32-bit kernel entry
Git-Commit-ID: e59d1b0a24199db01978e6c1e89859eda93ce683
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 21 Sep 2012 17:16:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e59d1b0a24199db01978e6c1e89859eda93ce683
Gitweb:     http://git.kernel.org/tip/e59d1b0a24199db01978e6c1e89859eda93ce683
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Fri, 21 Sep 2012 13:58:10 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 21 Sep 2012 14:04:27 -0700

x86-32, smap: Add STAC/CLAC instructions to 32-bit kernel entry

The changes to entry_32.S got missed in checkin:

63bcff2a x86, smap: Add STAC and CLAC instructions to control user space access

The resulting kernel was largely functional but SMAP protection could
have been bypassed.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Link: http://lkml.kernel.org/r/1348256595-29119-9-git-send-email-hpa@linux.intel.com
---
 arch/x86/kernel/entry_32.S |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 623f288..9ebbeca 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -57,6 +57,7 @@
 #include <asm/cpufeature.h>
 #include <asm/alternative-asm.h>
 #include <asm/asm.h>
+#include <asm/smap.h>
 
 /* Avoid __ASSEMBLER__'ifying <linux/audit.h> just for this.  */
 #include <linux/elf-em.h>
@@ -407,7 +408,9 @@ sysenter_past_esp:
  */
 	cmpl $__PAGE_OFFSET-3,%ebp
 	jae syscall_fault
+	ASM_STAC
 1:	movl (%ebp),%ebp
+	ASM_CLAC
 	movl %ebp,PT_EBP(%esp)
 	_ASM_EXTABLE(1b,syscall_fault)
 
@@ -488,6 +491,7 @@ ENDPROC(ia32_sysenter_target)
 	# system call handler stub
 ENTRY(system_call)
 	RING0_INT_FRAME			# can't unwind into user space anyway
+	ASM_CLAC
 	pushl_cfi %eax			# save orig_eax
 	SAVE_ALL
 	GET_THREAD_INFO(%ebp)
@@ -670,6 +674,7 @@ END(syscall_exit_work)
 
 	RING0_INT_FRAME			# can't unwind into user space anyway
 syscall_fault:
+	ASM_CLAC
 	GET_THREAD_INFO(%ebp)
 	movl $-EFAULT,PT_EAX(%esp)
 	jmp resume_userspace
@@ -825,6 +830,7 @@ END(interrupt)
  */
 	.p2align CONFIG_X86_L1_CACHE_SHIFT
 common_interrupt:
+	ASM_CLAC
 	addl $-0x80,(%esp)	/* Adjust vector into the [-256,-1] range */
 	SAVE_ALL
 	TRACE_IRQS_OFF
@@ -841,6 +847,7 @@ ENDPROC(common_interrupt)
 #define BUILD_INTERRUPT3(name, nr, fn)	\
 ENTRY(name)				\
 	RING0_INT_FRAME;		\
+	ASM_CLAC;			\
 	pushl_cfi $~(nr);		\
 	SAVE_ALL;			\
 	TRACE_IRQS_OFF			\
@@ -857,6 +864,7 @@ ENDPROC(name)
 
 ENTRY(coprocessor_error)
 	RING0_INT_FRAME
+	ASM_CLAC
 	pushl_cfi $0
 	pushl_cfi $do_coprocessor_error
 	jmp error_code
@@ -865,6 +873,7 @@ END(coprocessor_error)
 
 ENTRY(simd_coprocessor_error)
 	RING0_INT_FRAME
+	ASM_CLAC
 	pushl_cfi $0
 #ifdef CONFIG_X86_INVD_BUG
 	/* AMD 486 bug: invd from userspace calls exception 19 instead of #GP */
@@ -886,6 +895,7 @@ END(simd_coprocessor_error)
 
 ENTRY(device_not_available)
 	RING0_INT_FRAME
+	ASM_CLAC
 	pushl_cfi $-1			# mark this as an int
 	pushl_cfi $do_device_not_available
 	jmp error_code
@@ -906,6 +916,7 @@ END(native_irq_enable_sysexit)
 
 ENTRY(overflow)
 	RING0_INT_FRAME
+	ASM_CLAC
 	pushl_cfi $0
 	pushl_cfi $do_overflow
 	jmp error_code
@@ -914,6 +925,7 @@ END(overflow)
 
 ENTRY(bounds)
 	RING0_INT_FRAME
+	ASM_CLAC
 	pushl_cfi $0
 	pushl_cfi $do_bounds
 	jmp error_code
@@ -922,6 +934,7 @@ END(bounds)
 
 ENTRY(invalid_op)
 	RING0_INT_FRAME
+	ASM_CLAC
 	pushl_cfi $0
 	pushl_cfi $do_invalid_op
 	jmp error_code
@@ -930,6 +943,7 @@ END(invalid_op)
 
 ENTRY(coprocessor_segment_overrun)
 	RING0_INT_FRAME
+	ASM_CLAC
 	pushl_cfi $0
 	pushl_cfi $do_coprocessor_segment_overrun
 	jmp error_code
@@ -938,6 +952,7 @@ END(coprocessor_segment_overrun)
 
 ENTRY(invalid_TSS)
 	RING0_EC_FRAME
+	ASM_CLAC
 	pushl_cfi $do_invalid_TSS
 	jmp error_code
 	CFI_ENDPROC
@@ -945,6 +960,7 @@ END(invalid_TSS)
 
 ENTRY(segment_not_present)
 	RING0_EC_FRAME
+	ASM_CLAC
 	pushl_cfi $do_segment_not_present
 	jmp error_code
 	CFI_ENDPROC
@@ -952,6 +968,7 @@ END(segment_not_present)
 
 ENTRY(stack_segment)
 	RING0_EC_FRAME
+	ASM_CLAC
 	pushl_cfi $do_stack_segment
 	jmp error_code
 	CFI_ENDPROC
@@ -959,6 +976,7 @@ END(stack_segment)
 
 ENTRY(alignment_check)
 	RING0_EC_FRAME
+	ASM_CLAC
 	pushl_cfi $do_alignment_check
 	jmp error_code
 	CFI_ENDPROC
@@ -966,6 +984,7 @@ END(alignment_check)
 
 ENTRY(divide_error)
 	RING0_INT_FRAME
+	ASM_CLAC
 	pushl_cfi $0			# no error code
 	pushl_cfi $do_divide_error
 	jmp error_code
@@ -975,6 +994,7 @@ END(divide_error)
 #ifdef CONFIG_X86_MCE
 ENTRY(machine_check)
 	RING0_INT_FRAME
+	ASM_CLAC
 	pushl_cfi $0
 	pushl_cfi machine_check_vector
 	jmp error_code
@@ -984,6 +1004,7 @@ END(machine_check)
 
 ENTRY(spurious_interrupt_bug)
 	RING0_INT_FRAME
+	ASM_CLAC
 	pushl_cfi $0
 	pushl_cfi $do_spurious_interrupt_bug
 	jmp error_code
@@ -1207,6 +1228,7 @@ return_to_handler:
 
 ENTRY(page_fault)
 	RING0_EC_FRAME
+	ASM_CLAC
 	pushl_cfi $do_page_fault
 	ALIGN
 error_code:
@@ -1279,6 +1301,7 @@ END(page_fault)
 
 ENTRY(debug)
 	RING0_INT_FRAME
+	ASM_CLAC
 	cmpl $ia32_sysenter_target,(%esp)
 	jne debug_stack_correct
 	FIX_STACK 12, debug_stack_correct, debug_esp_fix_insn
@@ -1303,6 +1326,7 @@ END(debug)
  */
 ENTRY(nmi)
 	RING0_INT_FRAME
+	ASM_CLAC
 	pushl_cfi %eax
 	movl %ss, %eax
 	cmpw $__ESPFIX_SS, %ax
@@ -1373,6 +1397,7 @@ END(nmi)
 
 ENTRY(int3)
 	RING0_INT_FRAME
+	ASM_CLAC
 	pushl_cfi $-1			# mark this as an int
 	SAVE_ALL
 	TRACE_IRQS_OFF
@@ -1393,6 +1418,7 @@ END(general_protection)
 #ifdef CONFIG_KVM_GUEST
 ENTRY(async_page_fault)
 	RING0_EC_FRAME
+	ASM_CLAC
 	pushl_cfi $do_async_page_fault
 	jmp error_code
 	CFI_ENDPROC
