Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757167Ab2BXLzG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 06:55:06 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:20746 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755332Ab2BXLzD convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Fri, 24 Feb 2012 06:55:03 -0500
Message-Id: <4F4788A50200007800074A26@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 24 Feb 2012 11:55:01 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <ak@linux.intel.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH, resend] x86-64: improve insn scheduling in
 SAVE_ARGS_IRQ
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
Reviewed-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/kernel/entry_64.S |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- 3.3-rc4/arch/x86/kernel/entry_64.S
+++ 3.3-rc4-x86_64-entry-sched/arch/x86/kernel/entry_64.S
@@ -320,7 +320,7 @@ ENDPROC(native_usergs_sysret64)
 	movq %rsp, %rsi
 
 	leaq -RBP(%rsp),%rdi	/* arg1 for handler */
-	testl $3, CS(%rdi)
+	testl $3, CS-RBP(%rsi)
 	je 1f
 	SWAPGS
 	/*
@@ -330,11 +330,10 @@ ENDPROC(native_usergs_sysret64)
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



