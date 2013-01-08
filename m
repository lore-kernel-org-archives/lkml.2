Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756940Ab3AHXtF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 18:49:05 -0500
Received: from ozlabs.org ([203.10.76.45]:58594 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755930Ab3AHXtA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 18:49:00 -0500
Date: Wed, 9 Jan 2013 10:48:59 +1100
From: Anton Blanchard <anton@samba.org>
To: eparis@redhat.com, viro@zeniv.linux.org.uk, benh@kernel.crashing.org,
        paulus@samba.org
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 4/4] powerpc: Optimise 64bit syscall auditing exit path
Message-ID: <20130109104859.0f475fa0@kryten>
In-Reply-To: <20130109104617.74e995a5@kryten>
References: <20130109104617.74e995a5@kryten>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.13; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add an assembly fast path for the syscall audit exit path on
64bit. Some distros enable auditing by default which forces us
through the syscall auditing path even if there are no rules.

With syscall auditing enabled we currently disable interrupts,
check the threadinfo flags then immediately re-enable interrupts
and call audit_syscall_exit. This patch splits the threadinfo
flag check into two so we can avoid the disable/reenable of
interrupts when handling trace flags. We must do the user work
flag check with interrupts off to avoid returning to userspace
without handling them.

The other big gain is that we don't have to save and restore
the non volatile registers or exit via the slow ret_from_except
path.

I wrote some test cases to validate the patch:

http://ozlabs.org/~anton/junkcode/audit_tests.tar.gz

And to test the performance I ran a simple null syscall
microbenchmark on a POWER7 box:

http://ozlabs.org/~anton/junkcode/null_syscall.c

Baseline: 920.6 cycles
Patched:  719.6 cycles

An improvement of 22%.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: b/arch/powerpc/kernel/entry_64.S
===================================================================
--- a/arch/powerpc/kernel/entry_64.S
+++ b/arch/powerpc/kernel/entry_64.S
@@ -195,6 +195,19 @@ syscall_exit:
 	andi.	r10,r8,MSR_RI
 	beq-	unrecov_restore
 #endif
+
+	/* We can handle some thread info flags with interrupts on */
+	ld	r9,TI_FLAGS(r12)
+	li	r11,-_LAST_ERRNO
+	andi.   r0,r9,(_TIF_SYSCALL_T_OR_A|_TIF_SINGLESTEP|_TIF_PERSYSCALL_MASK)
+	bne	syscall_exit_work
+
+	cmpld	r3,r11
+	ld	r5,_CCR(r1)
+	bge-	syscall_error
+
+.Lsyscall_exit_work_cont:
+
 	/*
 	 * Disable interrupts so current_thread_info()->flags can't change,
 	 * and so that we don't get interrupted after loading SRR0/1.
@@ -208,21 +221,19 @@ syscall_exit:
 	 * clear EE. We only need to clear RI just before we restore r13
 	 * below, but batching it with EE saves us one expensive mtmsrd call.
 	 * We have to be careful to restore RI if we branch anywhere from
-	 * here (eg syscall_exit_work).
+	 * here (eg syscall_exit_user_work).
 	 */
 	li	r9,MSR_RI
 	andc	r11,r10,r9
 	mtmsrd	r11,1
 #endif /* CONFIG_PPC_BOOK3E */
 
+	/* Recheck thread info flags with interrupts off */
 	ld	r9,TI_FLAGS(r12)
-	li	r11,-_LAST_ERRNO
-	andi.	r0,r9,(_TIF_SYSCALL_T_OR_A|_TIF_SINGLESTEP|_TIF_USER_WORK_MASK|_TIF_PERSYSCALL_MASK)
-	bne-	syscall_exit_work
-	cmpld	r3,r11
-	ld	r5,_CCR(r1)
-	bge-	syscall_error
-.Lsyscall_error_cont:
+
+	andi.   r0,r9,_TIF_USER_WORK_MASK
+	bne-	syscall_exit_user_work
+
 	ld	r7,_NIP(r1)
 BEGIN_FTR_SECTION
 	stdcx.	r0,0,r1			/* to clear the reservation */
@@ -246,7 +257,7 @@ syscall_error:
 	oris	r5,r5,0x1000	/* Set SO bit in CR */
 	neg	r3,r3
 	std	r5,_CCR(r1)
-	b	.Lsyscall_error_cont
+	b	.Lsyscall_exit_work_cont
 	
 /* Traced system call support */
 syscall_dotrace:
@@ -306,58 +317,79 @@ audit_entry:
 syscall_enosys:
 	li	r3,-ENOSYS
 	b	syscall_exit
-	
+
 syscall_exit_work:
-#ifdef CONFIG_PPC_BOOK3S
-	mtmsrd	r10,1		/* Restore RI */
-#endif
-	/* If TIF_RESTOREALL is set, don't scribble on either r3 or ccr.
-	 If TIF_NOERROR is set, just save r3 as it is. */
+	li	r6,1		/* r6 contains syscall success */
+	mr	r7,r3
+	ld	r5,_CCR(r1)
 
+	/*
+	 * If TIF_RESTOREALL is set, don't scribble on either r3 or ccr.
+	 * If TIF_NOERROR is set, just save r3 as it is.
+	 */
 	andi.	r0,r9,_TIF_RESTOREALL
 	beq+	0f
 	REST_NVGPRS(r1)
 	b	2f
-0:	cmpld	r3,r11		/* r10 is -LAST_ERRNO */
+0:	cmpld	r3,r11		/* r11 is -LAST_ERRNO */
 	blt+	1f
 	andi.	r0,r9,_TIF_NOERROR
 	bne-	1f
-	ld	r5,_CCR(r1)
+	li	r6,0		/* syscall failed */
 	neg	r3,r3
 	oris	r5,r5,0x1000	/* Set SO bit in CR */
 	std	r5,_CCR(r1)
 1:	std	r3,GPR3(r1)
-2:	andi.	r0,r9,(_TIF_PERSYSCALL_MASK)
+
+2:	andi.	r0,r9,_TIF_SYSCALL_AUDIT
 	beq	4f
 
-	/* Clear per-syscall TIF flags if any are set.  */
+	mr	r3,r6
+	mr	r4,r7
+	bl	.__audit_syscall_exit
+	CURRENT_THREAD_INFO(r12, r1)
+	ld	r9,TI_FLAGS(r12)
+	ld	r3,GPR3(r1)
+	ld	r5,_CCR(r1)
+	ld	r8,_MSR(r1)
+
+4:	andi.	r0,r9,(_TIF_PERSYSCALL_MASK)
+	beq	6f
 
+	/* Clear per-syscall TIF flags if any are set.  */
 	li	r11,_TIF_PERSYSCALL_MASK
 	addi	r12,r12,TI_FLAGS
-3:	ldarx	r10,0,r12
+5:	ldarx	r10,0,r12
 	andc	r10,r10,r11
 	stdcx.	r10,0,r12
-	bne-	3b
+	bne-	5b
 	subi	r12,r12,TI_FLAGS
 
-4:	/* Anything else left to do? */
-	andi.	r0,r9,(_TIF_SYSCALL_T_OR_A|_TIF_SINGLESTEP)
-	beq	.ret_from_except_lite
+	/*
+	 * We can use the fast path if no other trace flags are on and
+	 * _TIF_RESTOREALL wasn't set.
+	 */
+6:      andi.   r0,r9,((_TIF_SYSCALL_T_OR_A|_TIF_SINGLESTEP|_TIF_RESTOREALL) & ~_TIF_SYSCALL_AUDIT)
+	mr	r9,r10
+	beq	.Lsyscall_exit_work_cont
 
-	/* Re-enable interrupts */
-#ifdef CONFIG_PPC_BOOK3E
-	wrteei	1
-#else
-	ld	r10,PACAKMSR(r13)
-	ori	r10,r10,MSR_EE
-	mtmsrd	r10,1
-#endif /* CONFIG_PPC_BOOK3E */
+	andi.	r0,r9,((_TIF_SYSCALL_T_OR_A|_TIF_SINGLESTEP) & ~_TIF_SYSCALL_AUDIT)
+	beq	7f
 
 	bl	.save_nvgprs
 	addi	r3,r1,STACK_FRAME_OVERHEAD
 	bl	.do_syscall_trace_leave
 	b	.ret_from_except
 
+7:	b	.ret_from_except_lite
+
+syscall_exit_user_work:
+#ifdef CONFIG_PPC_BOOK3S
+	mtmsrd	r10,1		/* Restore RI */
+#endif
+	std	r3,GPR3(r1)
+	b	.ret_from_except_lite
+
 /* Save non-volatile GPRs, if not already saved. */
 _GLOBAL(save_nvgprs)
 	ld	r11,_TRAP(r1)
Index: b/arch/powerpc/kernel/ptrace.c
===================================================================
--- a/arch/powerpc/kernel/ptrace.c
+++ b/arch/powerpc/kernel/ptrace.c
@@ -1781,7 +1781,9 @@ void do_syscall_trace_leave(struct pt_re
 {
 	int step;
 
+#ifdef CONFIG_PPC32
 	audit_syscall_exit(regs);
+#endif
 
 	if (unlikely(test_thread_flag(TIF_SYSCALL_TRACEPOINT)))
 		trace_sys_exit(regs, regs->result);
