Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688Ab1K2Kt6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 05:49:58 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:30284 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993Ab1K2Kty convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Tue, 29 Nov 2011 05:49:54 -0500
Message-Id: <4ED4C6DF0200007800064018@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Tue, 29 Nov 2011 10:49:51 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86-64: improve insn scheduling in SAVE_ARGS_IRQ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In one case, use an address register that was computed earlier (and
with a simpler instruction), thus reducing the risk of a stall.

In the second case, eliminate a branch by using a conditional move (as
is already done in call_softirq and xen_do_hypervisor_callback).

Signed-off-by: Jan Beulich <jbeulich@suse.com>

---
 arch/x86/kernel/entry_64.S |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- 3.2-rc3/arch/x86/kernel/entry_64.S
+++ 3.2-rc3-x86_64-entry-sched/arch/x86/kernel/entry_64.S
@@ -319,7 +319,7 @@ ENDPROC(native_usergs_sysret64)
 	movq %rsp, %rsi
 
 	leaq -RBP(%rsp),%rdi	/* arg1 for handler */
-	testl $3, CS(%rdi)
+	testl $3, CS-RBP(%rsi)
 	je 1f
 	SWAPGS
 	/*
@@ -329,11 +329,10 @@ ENDPROC(native_usergs_sysret64)
 	 * moving irq_enter into assembly, which would be too much work)
 	 */
 1:	incl PER_CPU_VAR(irq_count)
-	jne 2f
-	mov PER_CPU_VAR(irq_stack_ptr),%rsp
+	cmovzq PER_CPU_VAR(irq_stack_ptr),%rsp
 	CFI_DEF_CFA_REGISTER	rsi
 
-2:	/* Store previous stack value */
+	/* Store previous stack value */
 	pushq %rsi
 	CFI_ESCAPE	0x0f /* DW_CFA_def_cfa_expression */, 6, \
 			0x77 /* DW_OP_breg7 */, 0, \



