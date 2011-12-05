Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505Ab1LESCM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 13:02:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59037 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755519Ab1LESCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 13:02:10 -0500
Date: Mon, 5 Dec 2011 10:01:46 -0800
From: tip-bot for Jan Beulich <JBeulich@suse.com>
Message-ID: <tip-46db09d3fd847f185a7d23a96bc8fe7a4be0cd05@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        jbeulich@suse.com, JBeulich@suse.com, ak@linux.intel.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        JBeulich@suse.com, jbeulich@suse.com, ak@linux.intel.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4ED4CD690200007800064075@nat28.tlf.novell.com>
References: <4ED4CD690200007800064075@nat28.tlf.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86-64: Slightly shorten line system call entry and exit paths
Git-Commit-ID: 46db09d3fd847f185a7d23a96bc8fe7a4be0cd05
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 05 Dec 2011 10:01:52 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  46db09d3fd847f185a7d23a96bc8fe7a4be0cd05
Gitweb:     http://git.kernel.org/tip/46db09d3fd847f185a7d23a96bc8fe7a4be0cd05
Author:     Jan Beulich <JBeulich@suse.com>
AuthorDate: Tue, 29 Nov 2011 11:17:45 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 5 Dec 2011 17:24:41 +0100

x86-64: Slightly shorten line system call entry and exit paths

GET_THREAD_INFO() involves a memory read immediately followed by
an "sub" on the value read, in turn (in several cases)
immediately followed by a use of the calculated value as the
base address of a memory access. This combination of
instructions has a non-negligible potential for stalls.

In the system call entry point code, however, the (fixed) offset
of the stack pointer from the end of the stack is generally
known, and hence we can instead avoid the memory load and
subtract, and instead do the memory reference using %rsp as the
base register. To do so in a legible fashion, introduce a
THREAD_INFO() macro which, provided a register (generally %rsp)
and the known offset from the end of the stack, produces a
suitable memory access operand.

The patch attempts to only touch the fast paths (no auditing and
alike), but manages to do so only in the 64-bit entry point
case; the compatibility mode entry points have so many
interdependencies between their various branch targets that it
was necessary to also adjust the slow paths to eliminate the
risk of having missed some register dependency during code
analysis.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/4ED4CD690200007800064075@nat28.tlf.novell.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/ia32/ia32entry.S          |   36 +++++++++++++++---------------------
 arch/x86/include/asm/thread_info.h |    6 ++++++
 arch/x86/kernel/entry_64.S         |    8 +++-----
 3 files changed, 24 insertions(+), 26 deletions(-)

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index a6253ec..0d5c279 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -134,7 +134,7 @@ ENTRY(ia32_sysenter_target)
 	CFI_REL_OFFSET rsp,0
 	pushfq_cfi
 	/*CFI_REL_OFFSET rflags,0*/
-	movl	8*3-THREAD_SIZE+TI_sysenter_return(%rsp), %r10d
+	movl	TI_sysenter_return+THREAD_INFO(%rsp,3*8-KERNEL_STACK_OFFSET),%r10d
 	CFI_REGISTER rip,r10
 	pushq_cfi $__USER32_CS
 	/*CFI_REL_OFFSET cs,0*/
@@ -150,9 +150,8 @@ ENTRY(ia32_sysenter_target)
  	.section __ex_table,"a"
  	.quad 1b,ia32_badarg
  	.previous	
-	GET_THREAD_INFO(%r10)
-	orl    $TS_COMPAT,TI_status(%r10)
-	testl  $_TIF_WORK_SYSCALL_ENTRY,TI_flags(%r10)
+	orl     $TS_COMPAT,TI_status+THREAD_INFO(%rsp,RIP-ARGOFFSET)
+	testl   $_TIF_WORK_SYSCALL_ENTRY,TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
 	CFI_REMEMBER_STATE
 	jnz  sysenter_tracesys
 	cmpq	$(IA32_NR_syscalls-1),%rax
@@ -162,13 +161,12 @@ sysenter_do_call:
 sysenter_dispatch:
 	call	*ia32_sys_call_table(,%rax,8)
 	movq	%rax,RAX-ARGOFFSET(%rsp)
-	GET_THREAD_INFO(%r10)
 	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
-	testl	$_TIF_ALLWORK_MASK,TI_flags(%r10)
+	testl	$_TIF_ALLWORK_MASK,TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
 	jnz	sysexit_audit
 sysexit_from_sys_call:
-	andl    $~TS_COMPAT,TI_status(%r10)
+	andl    $~TS_COMPAT,TI_status+THREAD_INFO(%rsp,RIP-ARGOFFSET)
 	/* clear IF, that popfq doesn't enable interrupts early */
 	andl  $~0x200,EFLAGS-R11(%rsp) 
 	movl	RIP-R11(%rsp),%edx		/* User %eip */
@@ -205,7 +203,7 @@ sysexit_from_sys_call:
 	.endm
 
 	.macro auditsys_exit exit
-	testl $(_TIF_ALLWORK_MASK & ~_TIF_SYSCALL_AUDIT),TI_flags(%r10)
+	testl $(_TIF_ALLWORK_MASK & ~_TIF_SYSCALL_AUDIT),TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
 	jnz ia32_ret_from_sys_call
 	TRACE_IRQS_ON
 	sti
@@ -215,12 +213,11 @@ sysexit_from_sys_call:
 	movzbl %al,%edi		/* zero-extend that into %edi */
 	inc %edi /* first arg, 0->1(AUDITSC_SUCCESS), 1->2(AUDITSC_FAILURE) */
 	call audit_syscall_exit
-	GET_THREAD_INFO(%r10)
 	movl RAX-ARGOFFSET(%rsp),%eax	/* reload syscall return value */
 	movl $(_TIF_ALLWORK_MASK & ~_TIF_SYSCALL_AUDIT),%edi
 	cli
 	TRACE_IRQS_OFF
-	testl %edi,TI_flags(%r10)
+	testl %edi,TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
 	jz \exit
 	CLEAR_RREGS -ARGOFFSET
 	jmp int_with_check
@@ -238,7 +235,7 @@ sysexit_audit:
 
 sysenter_tracesys:
 #ifdef CONFIG_AUDITSYSCALL
-	testl	$(_TIF_WORK_SYSCALL_ENTRY & ~_TIF_SYSCALL_AUDIT),TI_flags(%r10)
+	testl	$(_TIF_WORK_SYSCALL_ENTRY & ~_TIF_SYSCALL_AUDIT),TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
 	jz	sysenter_auditsys
 #endif
 	SAVE_REST
@@ -309,9 +306,8 @@ ENTRY(ia32_cstar_target)
 	.section __ex_table,"a"
 	.quad 1b,ia32_badarg
 	.previous	
-	GET_THREAD_INFO(%r10)
-	orl   $TS_COMPAT,TI_status(%r10)
-	testl $_TIF_WORK_SYSCALL_ENTRY,TI_flags(%r10)
+	orl     $TS_COMPAT,TI_status+THREAD_INFO(%rsp,RIP-ARGOFFSET)
+	testl   $_TIF_WORK_SYSCALL_ENTRY,TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
 	CFI_REMEMBER_STATE
 	jnz   cstar_tracesys
 	cmpq $IA32_NR_syscalls-1,%rax
@@ -321,13 +317,12 @@ cstar_do_call:
 cstar_dispatch:
 	call *ia32_sys_call_table(,%rax,8)
 	movq %rax,RAX-ARGOFFSET(%rsp)
-	GET_THREAD_INFO(%r10)
 	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
-	testl $_TIF_ALLWORK_MASK,TI_flags(%r10)
+	testl $_TIF_ALLWORK_MASK,TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
 	jnz sysretl_audit
 sysretl_from_sys_call:
-	andl $~TS_COMPAT,TI_status(%r10)
+	andl $~TS_COMPAT,TI_status+THREAD_INFO(%rsp,RIP-ARGOFFSET)
 	RESTORE_ARGS 0,-ARG_SKIP,0,0,0
 	movl RIP-ARGOFFSET(%rsp),%ecx
 	CFI_REGISTER rip,rcx
@@ -355,7 +350,7 @@ sysretl_audit:
 
 cstar_tracesys:
 #ifdef CONFIG_AUDITSYSCALL
-	testl $(_TIF_WORK_SYSCALL_ENTRY & ~_TIF_SYSCALL_AUDIT),TI_flags(%r10)
+	testl $(_TIF_WORK_SYSCALL_ENTRY & ~_TIF_SYSCALL_AUDIT),TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
 	jz cstar_auditsys
 #endif
 	xchgl %r9d,%ebp
@@ -420,9 +415,8 @@ ENTRY(ia32_syscall)
 	/* note the registers are not zero extended to the sf.
 	   this could be a problem. */
 	SAVE_ARGS 0,1,0
-	GET_THREAD_INFO(%r10)
-	orl   $TS_COMPAT,TI_status(%r10)
-	testl $_TIF_WORK_SYSCALL_ENTRY,TI_flags(%r10)
+	orl $TS_COMPAT,TI_status+THREAD_INFO(%rsp,RIP-ARGOFFSET)
+	testl $_TIF_WORK_SYSCALL_ENTRY,TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
 	jnz ia32_tracesys
 	cmpq $(IA32_NR_syscalls-1),%rax
 	ja ia32_badsys
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index 25ebd79..185b719 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -232,6 +232,12 @@ static inline struct thread_info *current_thread_info(void)
 	movq PER_CPU_VAR(kernel_stack),reg ; \
 	subq $(THREAD_SIZE-KERNEL_STACK_OFFSET),reg
 
+/*
+ * Same if PER_CPU_VAR(kernel_stack) is, perhaps with some offset, already in
+ * a certain register (to be used in assembler memory operands).
+ */
+#define THREAD_INFO(reg, off) KERNEL_STACK_OFFSET+(off)-THREAD_SIZE(reg)
+
 #endif
 
 #endif /* !X86_32 */
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 1581f19..75f72a5 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -478,8 +478,7 @@ ENTRY(system_call_after_swapgs)
 	movq  %rax,ORIG_RAX-ARGOFFSET(%rsp)
 	movq  %rcx,RIP-ARGOFFSET(%rsp)
 	CFI_REL_OFFSET rip,RIP-ARGOFFSET
-	GET_THREAD_INFO(%rcx)
-	testl $_TIF_WORK_SYSCALL_ENTRY,TI_flags(%rcx)
+	testl $_TIF_WORK_SYSCALL_ENTRY,TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
 	jnz tracesys
 system_call_fastpath:
 	cmpq $__NR_syscall_max,%rax
@@ -496,10 +495,9 @@ ret_from_sys_call:
 	/* edi:	flagmask */
 sysret_check:
 	LOCKDEP_SYS_EXIT
-	GET_THREAD_INFO(%rcx)
 	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
-	movl TI_flags(%rcx),%edx
+	movl TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET),%edx
 	andl %edi,%edx
 	jnz  sysret_careful
 	CFI_REMEMBER_STATE
@@ -583,7 +581,7 @@ sysret_audit:
 	/* Do syscall tracing */
 tracesys:
 #ifdef CONFIG_AUDITSYSCALL
-	testl $(_TIF_WORK_SYSCALL_ENTRY & ~_TIF_SYSCALL_AUDIT),TI_flags(%rcx)
+	testl $(_TIF_WORK_SYSCALL_ENTRY & ~_TIF_SYSCALL_AUDIT),TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
 	jz auditsys
 #endif
 	SAVE_REST
