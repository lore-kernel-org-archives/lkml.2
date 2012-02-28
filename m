Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965008Ab2B1Khn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 05:37:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52150 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964817Ab2B1Khm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 05:37:42 -0500
Date: Tue, 28 Feb 2012 02:37:06 -0800
From: tip-bot for Jan Beulich <JBeulich@suse.com>
Message-ID: <tip-626109130267713cac020515504ec341e47c96f9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rostedt@goodmis.org, jbeulich@suse.com, JBeulich@suse.com,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, JBeulich@suse.com, jbeulich@suse.com,
        tglx@linutronix.de
In-Reply-To: <4F478B630200007800074A31@nat28.tlf.novell.com>
References: <4F478B630200007800074A31@nat28.tlf.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86-64: Fix CFI annotations for NMI nesting code
Git-Commit-ID: 626109130267713cac020515504ec341e47c96f9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 28 Feb 2012 02:37:32 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  626109130267713cac020515504ec341e47c96f9
Gitweb:     http://git.kernel.org/tip/626109130267713cac020515504ec341e47c96f9
Author:     Jan Beulich <JBeulich@suse.com>
AuthorDate: Fri, 24 Feb 2012 14:54:37 +0000
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Fri, 24 Feb 2012 14:05:14 -0500

x86-64: Fix CFI annotations for NMI nesting code

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

Link: http://lkml.kernel.org/r/4F478B630200007800074A31@nat28.tlf.novell.com

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/entry_64.S |   52 +++++++++++++++++++++++--------------------
 1 files changed, 28 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 1333d98..e0eca00 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1530,6 +1530,7 @@ ENTRY(nmi)
 
 	/* Use %rdx as out temp variable throughout */
 	pushq_cfi %rdx
+	CFI_REL_OFFSET rdx, 0
 
 	/*
 	 * If %cs was not the kernel segment, then the NMI triggered in user
@@ -1554,6 +1555,7 @@ ENTRY(nmi)
 	 */
 	lea 6*8(%rsp), %rdx
 	test_in_nmi rdx, 4*8(%rsp), nested_nmi, first_nmi
+	CFI_REMEMBER_STATE
 
 nested_nmi:
 	/*
@@ -1585,10 +1587,12 @@ nested_nmi:
 
 nested_nmi_out:
 	popq_cfi %rdx
+	CFI_RESTORE rdx
 
 	/* No need to check faults here */
 	INTERRUPT_RETURN
 
+	CFI_RESTORE_STATE
 first_nmi:
 	/*
 	 * Because nested NMIs will use the pushed location that we
@@ -1624,6 +1628,10 @@ first_nmi:
 	 * NMI may zero out. The original stack frame and the temp storage
 	 * is also used by nested NMIs and can not be trusted on exit.
 	 */
+	/* Do not pop rdx, nested NMIs will corrupt it */
+	movq (%rsp), %rdx
+	CFI_RESTORE rdx
+
 	/* Set the NMI executing variable on the stack. */
 	pushq_cfi $1
 
@@ -1631,14 +1639,31 @@ first_nmi:
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
@@ -1646,7 +1671,6 @@ first_nmi:
 	 * caused by an exception and nested NMI will start here, and
 	 * can still be preempted by another NMI.
 	 */
-restart_nmi:
 	pushq_cfi $-1		/* ORIG_RAX: no syscall to restart */
 	subq $ORIG_RAX-R15, %rsp
 	CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15
@@ -1675,26 +1699,6 @@ nmi_restore:
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
