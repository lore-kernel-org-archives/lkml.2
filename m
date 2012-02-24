Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143Ab2BXOyk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 09:54:40 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:32926 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408Ab2BXOyj convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Fri, 24 Feb 2012 09:54:39 -0500
Message-Id: <4F47B2BD0200007800074AD7@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 24 Feb 2012 14:54:37 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <srostedt@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH, v2] x86-64: fix CFI annotations for NMI nesting code
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The saving and restoring of %rdx wasn't annotated at all, and the
jumping over sections where state gets partly restored wasn't handled
either.

Further, by folding the pushing of the previous frame in repeat_nmi
into that which so far was immediately preceding restart_nmi (after
moving the restore of %rdx ahead of that, since it doesn't get used
anymore when pushing prior frames), annotations of the replicated
frame creations can be made consistent too.

v2: Fully fold repeat_nmi into the normal code flow (adding a single
    redundant instruction to the "normal" code path), thus retaining
    the special protection of all instructions between repeat_nmi and
    end_repeat_nmi.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: Steven Rostedt <srostedt@redhat.com>

---
 arch/x86/kernel/entry_64.S |   52 ++++++++++++++++++++++++---------------------
 1 file changed, 28 insertions(+), 24 deletions(-)

--- 3.3-rc4/arch/x86/kernel/entry_64.S
+++ 3.3-rc4-x86_64-nmi-cfi/arch/x86/kernel/entry_64.S
@@ -1530,6 +1530,7 @@ ENTRY(nmi)
 
 	/* Use %rdx as out temp variable throughout */
 	pushq_cfi %rdx
+	CFI_REL_OFFSET rdx, 0
 
 	/*
 	 * Check the special variable on the stack to see if NMIs are
@@ -1547,6 +1548,7 @@ ENTRY(nmi)
 	 */
 	lea 6*8(%rsp), %rdx
 	test_in_nmi rdx, 4*8(%rsp), nested_nmi, first_nmi
+	CFI_REMEMBER_STATE
 
 nested_nmi:
 	/*
@@ -1578,10 +1580,12 @@ nested_nmi:
 
 nested_nmi_out:
 	popq_cfi %rdx
+	CFI_RESTORE rdx
 
 	/* No need to check faults here */
 	INTERRUPT_RETURN
 
+	CFI_RESTORE_STATE
 first_nmi:
 	/*
 	 * Because nested NMIs will use the pushed location that we
@@ -1617,6 +1621,10 @@ first_nmi:
 	 * NMI may zero out. The original stack frame and the temp storage
 	 * is also used by nested NMIs and can not be trusted on exit.
 	 */
+	/* Do not pop rdx, nested NMIs will corrupt it */
+	movq (%rsp), %rdx
+	CFI_RESTORE rdx
+
 	/* Set the NMI executing variable on the stack. */
 	pushq_cfi $1
 
@@ -1624,14 +1632,31 @@ first_nmi:
 	.rept 5
 	pushq_cfi 6*8(%rsp)
 	.endr
+	CFI_DEF_CFA_OFFSET SS+8-RIP
+
+	/*
+	 * If there was a nested NMI, the first NMI's iret will return
+	 * here. But NMIs are still enabled and we can take another
+	 * nested NMI. The nested NMI checks the interrupted RIP to see
+	 * if it is between repeat_nmi and end_repeat_nmi, and if so
+	 * it will just return, as we are about to repeat an NMI anyway.
+	 * This makes it safe to copy to the stack frame that a nested
+	 * NMI will update.
+	 */
+repeat_nmi:
+	/*
+	 * Update the stack variable to say we are still in NMI (the update
+	 * is benign for the non-repeat case, where 1 was pushed just above
+	 * to this very stack slot).
+	 */
+	movq $1, 5*8(%rsp)
 
 	/* Make another copy, this one may be modified by nested NMIs */
 	.rept 5
 	pushq_cfi 4*8(%rsp)
 	.endr
-
-	/* Do not pop rdx, nested NMIs will corrupt it */
-	movq 11*8(%rsp), %rdx
+	CFI_DEF_CFA_OFFSET SS+8-RIP
+end_repeat_nmi:
 
 	/*
 	 * Everything below this point can be preempted by a nested
@@ -1639,7 +1664,6 @@ first_nmi:
 	 * caused by an exception and nested NMI will start here, and
 	 * can still be preempted by another NMI.
 	 */
-restart_nmi:
 	pushq_cfi $-1		/* ORIG_RAX: no syscall to restart */
 	subq $ORIG_RAX-R15, %rsp
 	CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15
@@ -1668,26 +1692,6 @@ nmi_restore:
 	CFI_ENDPROC
 END(nmi)
 
-	/*
-	 * If an NMI hit an iret because of an exception or breakpoint,
-	 * it can lose its NMI context, and a nested NMI may come in.
-	 * In that case, the nested NMI will change the preempted NMI's
-	 * stack to jump to here when it does the final iret.
-	 */
-repeat_nmi:
-	INTR_FRAME
-	/* Update the stack variable to say we are still in NMI */
-	movq $1, 5*8(%rsp)
-
-	/* copy the saved stack back to copy stack */
-	.rept 5
-	pushq_cfi 4*8(%rsp)
-	.endr
-
-	jmp restart_nmi
-	CFI_ENDPROC
-end_repeat_nmi:
-
 ENTRY(ignore_sysret)
 	CFI_STARTPROC
 	mov $-ENOSYS,%eax



