Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738Ab0IBMzP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 08:55:15 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:39310 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810Ab0IBMzN convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:3:1>);
	Thu, 2 Sep 2010 08:55:13 -0400
Message-Id: <4C7FBACF0200007800013F6A@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Thu, 02 Sep 2010 13:55:11 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Resend: [PATCH] x86-64: use symbolics instead of raw numbers
	 in entry_64.S
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... making the code a little less fragile.

Also use pushq_cfi instead of raw CFI annotations in two more places,
and add two missing annotations after stack pointer adjustments which
got modified here anyway.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/kernel/entry_64.S |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

--- linux-2.6.36-rc3/arch/x86/kernel/entry_64.S
+++ 2.6.36-rc3-x86_64-unwind-annotations/arch/x86/kernel/entry_64.S
@@ -796,8 +796,8 @@ END(interrupt)
 
 /* 0(%rsp): ~(interrupt number) */
 	.macro interrupt func
-	subq $10*8, %rsp
-	CFI_ADJUST_CFA_OFFSET 10*8
+	subq $ORIG_RAX-ARGOFFSET+8, %rsp
+	CFI_ADJUST_CFA_OFFSET ORIG_RAX-ARGOFFSET+8
 	call save_args
 	PARTIAL_FRAME 0
 	call \func
@@ -1036,8 +1036,8 @@ ENTRY(\sym)
 	INTR_FRAME
 	PARAVIRT_ADJUST_EXCEPTION_FRAME
 	pushq_cfi $-1		/* ORIG_RAX: no syscall to restart */
-	subq $15*8,%rsp
-	CFI_ADJUST_CFA_OFFSET 15*8
+	subq $ORIG_RAX-R15, %rsp
+	CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15
 	call error_entry
 	DEFAULT_FRAME 0
 	movq %rsp,%rdi		/* pt_regs pointer */
@@ -1052,9 +1052,9 @@ END(\sym)
 ENTRY(\sym)
 	INTR_FRAME
 	PARAVIRT_ADJUST_EXCEPTION_FRAME
-	pushq $-1		/* ORIG_RAX: no syscall to restart */
-	CFI_ADJUST_CFA_OFFSET 8
-	subq $15*8, %rsp
+	pushq_cfi $-1		/* ORIG_RAX: no syscall to restart */
+	subq $ORIG_RAX-R15, %rsp
+	CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15
 	call save_paranoid
 	TRACE_IRQS_OFF
 	movq %rsp,%rdi		/* pt_regs pointer */
@@ -1070,9 +1070,9 @@ END(\sym)
 ENTRY(\sym)
 	INTR_FRAME
 	PARAVIRT_ADJUST_EXCEPTION_FRAME
-	pushq $-1		/* ORIG_RAX: no syscall to restart */
-	CFI_ADJUST_CFA_OFFSET 8
-	subq $15*8, %rsp
+	pushq_cfi $-1		/* ORIG_RAX: no syscall to restart */
+	subq $ORIG_RAX-R15, %rsp
+	CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15
 	call save_paranoid
 	TRACE_IRQS_OFF
 	movq %rsp,%rdi		/* pt_regs pointer */
@@ -1089,8 +1089,8 @@ END(\sym)
 ENTRY(\sym)
 	XCPT_FRAME
 	PARAVIRT_ADJUST_EXCEPTION_FRAME
-	subq $15*8,%rsp
-	CFI_ADJUST_CFA_OFFSET 15*8
+	subq $ORIG_RAX-R15, %rsp
+	CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15
 	call error_entry
 	DEFAULT_FRAME 0
 	movq %rsp,%rdi			/* pt_regs pointer */
@@ -1107,8 +1107,8 @@ END(\sym)
 ENTRY(\sym)
 	XCPT_FRAME
 	PARAVIRT_ADJUST_EXCEPTION_FRAME
-	subq $15*8,%rsp
-	CFI_ADJUST_CFA_OFFSET 15*8
+	subq $ORIG_RAX-R15, %rsp
+	CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15
 	call save_paranoid
 	DEFAULT_FRAME 0
 	TRACE_IRQS_OFF
@@ -1498,8 +1498,8 @@ ENTRY(nmi)
 	INTR_FRAME
 	PARAVIRT_ADJUST_EXCEPTION_FRAME
 	pushq_cfi $-1
-	subq $15*8, %rsp
-	CFI_ADJUST_CFA_OFFSET 15*8
+	subq $ORIG_RAX-R15, %rsp
+	CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15
 	call save_paranoid
 	DEFAULT_FRAME 0
 	/* paranoidentry do_nmi, 0; without TRACE_IRQS_OFF */



