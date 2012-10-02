Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757561Ab2JBA3a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 20:29:30 -0400
Received: from mail-yx0-f202.google.com ([209.85.213.202]:62333 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536Ab2JBA31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 20:29:27 -0400
Subject: [PATCH] [PATCH] x86: Don't clobber top of pt_regs in nested NMI
In-Reply-To: <20121002002613.26956.5744.stgit@dungbeetle.mtv.corp.google.com>
To: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
From: Salman Qazi <sqazi@google.com>
Date: Mon, 01 Oct 2012 17:29:25 -0700
Message-ID: <20121002002919.27236.14388.stgit@dungbeetle.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The nested NMI modifies the place (instruction, flags and stack)
that the first NMI will iret to.  However, the copy of registers
modified is exactly the one that is the part of pt_regs in
the first NMI.  This can change the behaviour of the first NMI.

In particular, Google's arch_trigger_all_cpu_backtrace handler
also prints regions of memory surrounding addresses appearing in
registers.  This results in handled exceptions, after which nested NMIs
start coming in.  These nested NMIs change the value of registers
in pt_regs.  This can cause the original NMI handler to produce
incorrect output.

We solve this problem by interchanging the position of the preserved
copy of the iret registers ("saved") and the copy subject to being
trampled by nested NMI ("copied").

Signed-off-by: Salman Qazi <sqazi@google.com>
---
 arch/x86/kernel/entry_64.S |   41 +++++++++++++++++++++++++++--------------
 1 files changed, 27 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 44531ac..b5d6e43 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1739,9 +1739,10 @@ nested_nmi:
 
 1:
 	/* Set up the interrupted NMIs stack to jump to repeat_nmi */
-	leaq -6*8(%rsp), %rdx
+	leaq -1*8(%rsp), %rdx
 	movq %rdx, %rsp
-	CFI_ADJUST_CFA_OFFSET 6*8
+	CFI_ADJUST_CFA_OFFSET 1*8
+	leaq -10*8(%rsp), %rdx
 	pushq_cfi $__KERNEL_DS
 	pushq_cfi %rdx
 	pushfq_cfi
@@ -1749,8 +1750,8 @@ nested_nmi:
 	pushq_cfi $repeat_nmi
 
 	/* Put stack back */
-	addq $(11*8), %rsp
-	CFI_ADJUST_CFA_OFFSET -11*8
+	addq $(6*8), %rsp
+	CFI_ADJUST_CFA_OFFSET -6*8
 
 nested_nmi_out:
 	popq_cfi %rdx
@@ -1776,18 +1777,18 @@ first_nmi:
 	 * +-------------------------+
 	 * | NMI executing variable  |
 	 * +-------------------------+
-	 * | Saved SS                |
-	 * | Saved Return RSP        |
-	 * | Saved RFLAGS            |
-	 * | Saved CS                |
-	 * | Saved RIP               |
-	 * +-------------------------+
 	 * | copied SS               |
 	 * | copied Return RSP       |
 	 * | copied RFLAGS           |
 	 * | copied CS               |
 	 * | copied RIP              |
 	 * +-------------------------+
+	 * | Saved SS                |
+	 * | Saved Return RSP        |
+	 * | Saved RFLAGS            |
+	 * | Saved CS                |
+	 * | Saved RIP               |
+	 * +-------------------------+
 	 * | pt_regs                 |
 	 * +-------------------------+
 	 *
@@ -1803,9 +1804,14 @@ first_nmi:
 	/* Set the NMI executing variable on the stack. */
 	pushq_cfi $1
 
+	/*
+	 * Leave room for the "copied" frame
+	 */
+	subq $(5*8), %rsp
+
 	/* Copy the stack frame to the Saved frame */
 	.rept 5
-	pushq_cfi 6*8(%rsp)
+	pushq_cfi 11*8(%rsp)
 	.endr
 	CFI_DEF_CFA_OFFSET SS+8-RIP
 
@@ -1826,12 +1832,15 @@ repeat_nmi:
 	 * is benign for the non-repeat case, where 1 was pushed just above
 	 * to this very stack slot).
 	 */
-	movq $1, 5*8(%rsp)
+	movq $1, 10*8(%rsp)
 
 	/* Make another copy, this one may be modified by nested NMIs */
+	addq $(10*8), %rsp
 	.rept 5
-	pushq_cfi 4*8(%rsp)
+	pushq_cfi -6*8(%rsp)
 	.endr
+	subq $(5*8), %rsp
+
 	CFI_DEF_CFA_OFFSET SS+8-RIP
 end_repeat_nmi:
 
@@ -1882,8 +1891,12 @@ nmi_swapgs:
 	SWAPGS_UNSAFE_STACK
 nmi_restore:
 	RESTORE_ALL 8
+
+	/* Pop the extra iret frame */
+	addq $(5*8), %rsp
+
 	/* Clear the NMI executing stack variable */
-	movq $0, 10*8(%rsp)
+	movq $0, 5*8(%rsp)
 	jmp irq_return
 	CFI_ENDPROC
 END(nmi)

