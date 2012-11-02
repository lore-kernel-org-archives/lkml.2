Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762747Ab2KBLSB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 07:18:01 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:45304 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762691Ab2KBLR7 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Fri, 2 Nov 2012 07:17:59 -0400
Message-Id: <5093BA1F02000078000A600E@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 02 Nov 2012 11:18:39 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86-64: fix ordering of CFI directives and recent
 ASM_CLAC additions
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While these got added in the right place everywhere else, entry_64.S
is the odd one where they ended up before the initial CFI directive(s).
In order to cover the full code ranges, the CFI directive must be
first, though.

Signed-off-by: Jan Beulich <jbeulich@suse.com>

---
 arch/x86/kernel/entry_64.S |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- 3.7-rc3/arch/x86/kernel/entry_64.S
+++ 3.7-rc3-x86_64-unwind-vs-clac/arch/x86/kernel/entry_64.S
@@ -995,8 +995,8 @@ END(interrupt)
 	 */
 	.p2align CONFIG_X86_L1_CACHE_SHIFT
 common_interrupt:
-	ASM_CLAC
 	XCPT_FRAME
+	ASM_CLAC
 	addq $-0x80,(%rsp)		/* Adjust vector to [-256,-1] range */
 	interrupt do_IRQ
 	/* 0(%rsp): old_rsp-ARGOFFSET */
@@ -1135,8 +1135,8 @@ END(common_interrupt)
  */
 .macro apicinterrupt num sym do_sym
 ENTRY(\sym)
-	ASM_CLAC
 	INTR_FRAME
+	ASM_CLAC
 	pushq_cfi $~(\num)
 .Lcommon_\sym:
 	interrupt \do_sym
@@ -1190,8 +1190,8 @@ apicinterrupt IRQ_WORK_VECTOR \
  */
 .macro zeroentry sym do_sym
 ENTRY(\sym)
-	ASM_CLAC
 	INTR_FRAME
+	ASM_CLAC
 	PARAVIRT_ADJUST_EXCEPTION_FRAME
 	pushq_cfi $-1		/* ORIG_RAX: no syscall to restart */
 	subq $ORIG_RAX-R15, %rsp
@@ -1208,8 +1208,8 @@ END(\sym)
 
 .macro paranoidzeroentry sym do_sym
 ENTRY(\sym)
-	ASM_CLAC
 	INTR_FRAME
+	ASM_CLAC
 	PARAVIRT_ADJUST_EXCEPTION_FRAME
 	pushq_cfi $-1		/* ORIG_RAX: no syscall to restart */
 	subq $ORIG_RAX-R15, %rsp
@@ -1227,8 +1227,8 @@ END(\sym)
 #define INIT_TSS_IST(x) PER_CPU_VAR(init_tss) + (TSS_ist + ((x) - 1) * 8)
 .macro paranoidzeroentry_ist sym do_sym ist
 ENTRY(\sym)
-	ASM_CLAC
 	INTR_FRAME
+	ASM_CLAC
 	PARAVIRT_ADJUST_EXCEPTION_FRAME
 	pushq_cfi $-1		/* ORIG_RAX: no syscall to restart */
 	subq $ORIG_RAX-R15, %rsp
@@ -1247,8 +1247,8 @@ END(\sym)
 
 .macro errorentry sym do_sym
 ENTRY(\sym)
-	ASM_CLAC
 	XCPT_FRAME
+	ASM_CLAC
 	PARAVIRT_ADJUST_EXCEPTION_FRAME
 	subq $ORIG_RAX-R15, %rsp
 	CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15
@@ -1266,8 +1266,8 @@ END(\sym)
 	/* error code is on the stack already */
 .macro paranoiderrorentry sym do_sym
 ENTRY(\sym)
-	ASM_CLAC
 	XCPT_FRAME
+	ASM_CLAC
 	PARAVIRT_ADJUST_EXCEPTION_FRAME
 	subq $ORIG_RAX-R15, %rsp
 	CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15



