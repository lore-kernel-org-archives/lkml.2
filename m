Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292Ab2DTV5Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 17:57:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34012 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754475Ab2DTV5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 17:57:22 -0400
Date: Fri, 20 Apr 2012 14:57:12 -0700
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Message-ID: <tip-6837a54dd6127f055dcb26d00fee0df05c07a674@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        david.daney@cavium.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        david.daney@cavium.com, tglx@linutronix.de
In-Reply-To: <CA+55aFyijf43qSu3N9nWHEBwaGbb7T2Oq9A=9EyR=Jtyqfq_cQ@mail.gmail.com>
References: <CA+55aFyijf43qSu3N9nWHEBwaGbb7T2Oq9A=9EyR=Jtyqfq_cQ@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/extable] x86, extable:
  Remove open-coded exception table entries in arch/x86/kernel/entry_32.S
Git-Commit-ID: 6837a54dd6127f055dcb26d00fee0df05c07a674
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 20 Apr 2012 14:57:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6837a54dd6127f055dcb26d00fee0df05c07a674
Gitweb:     http://git.kernel.org/tip/6837a54dd6127f055dcb26d00fee0df05c07a674
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Fri, 20 Apr 2012 12:19:50 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 20 Apr 2012 13:51:38 -0700

x86, extable: Remove open-coded exception table entries in arch/x86/kernel/entry_32.S

Remove open-coded exception table entries in arch/x86/kernel/entry_32.S,
and replace them with _ASM_EXTABLE() macros; this will allow us to
change the format and type of the exception table entries.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: David Daney <david.daney@cavium.com>
Link: http://lkml.kernel.org/r/CA%2B55aFyijf43qSu3N9nWHEBwaGbb7T2Oq9A=9EyR=Jtyqfq_cQ@mail.gmail.com
---
 arch/x86/kernel/entry_32.S |   47 +++++++++++++------------------------------
 1 files changed, 14 insertions(+), 33 deletions(-)

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
