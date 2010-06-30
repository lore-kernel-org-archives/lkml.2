Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410Ab0F3NpY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 09:45:24 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:52987 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986Ab0F3NpW convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:3:1>);
	Wed, 30 Jun 2010 09:45:22 -0400
Message-Id: <4C2B66AD0200007800008D77@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 30 Jun 2010 14:45:49 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86-64: use symbolics instead of raw numbers in
	 entry_64.S
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

--- linux-2.6.35-rc3/arch/x86/kernel/entry_64.S
+++ 2.6.35-rc3-x86_64-unwind-annotations/arch/x86/kernel/entry_64.S
@@ -796,8 +795,8 @@ END(interrupt)
 
 /* 0(%rsp): ~(interrupt number) */
 	.macro interrupt func
-	subq $10*8, %rsp
-	CFI_ADJUST_CFA_OFFSET 10*8
+	subq $ORIG_RAX-ARGOFFSET+8, %rsp
+	CFI_ADJUST_CFA_OFFSET ORIG_RAX-ARGOFFSET+8
 	call save_args
 	PARTIAL_FRAME 0
 	call \func
@@ -1036,8 +1035,8 @@ ENTRY(\sym)
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
@@ -1052,9 +1051,9 @@ END(\sym)
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
@@ -1069,9 +1068,9 @@ END(\sym)
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
@@ -1089,8 +1088,8 @@ END(\sym)
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
@@ -1107,8 +1106,8 @@ END(\sym)
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
@@ -1495,8 +1494,8 @@ ENTRY(nmi)
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



