Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752428Ab2KBThz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 15:37:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34209 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513Ab2KBThx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 15:37:53 -0400
Date: Fri, 2 Nov 2012 12:37:34 -0700
From: tip-bot for Salman Qazi <sqazi@google.com>
Message-ID: <tip-28696f434fef0efa97534b59986ad33b9c4df7f8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rostedt@goodmis.org, sqazi@google.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, sqazi@google.com, tglx@linutronix.de
In-Reply-To: <20121002002919.27236.14388.stgit@dungbeetle.mtv.corp.google.com>
References: <20121002002919.27236.14388.stgit@dungbeetle.mtv.corp.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86: Don't clobber top of pt_regs in nested NMI
Git-Commit-ID: 28696f434fef0efa97534b59986ad33b9c4df7f8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 02 Nov 2012 12:37:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  28696f434fef0efa97534b59986ad33b9c4df7f8
Gitweb:     http://git.kernel.org/tip/28696f434fef0efa97534b59986ad33b9c4df7f8
Author:     Salman Qazi <sqazi@google.com>
AuthorDate: Mon, 1 Oct 2012 17:29:25 -0700
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Fri, 2 Nov 2012 11:29:36 -0400

x86: Don't clobber top of pt_regs in nested NMI

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

Link: http://lkml.kernel.org/r/20121002002919.27236.14388.stgit@dungbeetle.mtv.corp.google.com

Signed-off-by: Salman Qazi <sqazi@google.com>
[ Added a needed CFI_ADJUST_CFA_OFFSET ]
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/entry_64.S |   41 +++++++++++++++++++++++++++--------------
 1 files changed, 27 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index b51b2c7..811795d 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1699,9 +1699,10 @@ nested_nmi:
 
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
@@ -1709,8 +1710,8 @@ nested_nmi:
 	pushq_cfi $repeat_nmi
 
 	/* Put stack back */
-	addq $(11*8), %rsp
-	CFI_ADJUST_CFA_OFFSET -11*8
+	addq $(6*8), %rsp
+	CFI_ADJUST_CFA_OFFSET -6*8
 
 nested_nmi_out:
 	popq_cfi %rdx
@@ -1736,18 +1737,18 @@ first_nmi:
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
@@ -1763,9 +1764,14 @@ first_nmi:
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
 
@@ -1786,12 +1792,15 @@ repeat_nmi:
 	 * is benign for the non-repeat case, where 1 was pushed just above
 	 * to this very stack slot).
 	 */
-	movq $1, 5*8(%rsp)
+	movq $1, 10*8(%rsp)
 
 	/* Make another copy, this one may be modified by nested NMIs */
+	addq $(10*8), %rsp
+	CFI_ADJUST_CFA_OFFSET -10*8
 	.rept 5
-	pushq_cfi 4*8(%rsp)
+	pushq_cfi -6*8(%rsp)
 	.endr
+	subq $(5*8), %rsp
 	CFI_DEF_CFA_OFFSET SS+8-RIP
 end_repeat_nmi:
 
@@ -1842,8 +1851,12 @@ nmi_swapgs:
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
