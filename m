Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758040Ab2BXUUb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 15:20:31 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34316 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756104Ab2BXUUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 15:20:30 -0500
Date: Fri, 24 Feb 2012 12:17:38 -0800
From: tip-bot for Jan Beulich <JBeulich@suse.com>
Message-ID: <tip-69466466ce889cd2cbc8cda9ff1c6083f48cc7f9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        jbeulich@suse.com, JBeulich@suse.com, ak@linux.intel.com,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        JBeulich@suse.com, jbeulich@suse.com, ak@linux.intel.com,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <4F4788A50200007800074A26@nat28.tlf.novell.com>
References: <4F4788A50200007800074A26@nat28.tlf.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86-64: Improve insn scheduling in SAVE_ARGS_IRQ
Git-Commit-ID: 69466466ce889cd2cbc8cda9ff1c6083f48cc7f9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 24 Feb 2012 12:18:05 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  69466466ce889cd2cbc8cda9ff1c6083f48cc7f9
Gitweb:     http://git.kernel.org/tip/69466466ce889cd2cbc8cda9ff1c6083f48cc7f9
Author:     Jan Beulich <JBeulich@suse.com>
AuthorDate: Fri, 24 Feb 2012 11:55:01 +0000
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 24 Feb 2012 11:46:28 -0800

x86-64: Improve insn scheduling in SAVE_ARGS_IRQ

In one case, use an address register that was computed earlier (and
with a simpler instruction), thus reducing the risk of a stall.

In the second case, eliminate a branch by using a conditional move (as
is already done in call_softirq and xen_do_hypervisor_callback).

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Link: http://lkml.kernel.org/r/4F4788A50200007800074A26@nat28.tlf.novell.com
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/entry_64.S |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index a20e1cb..211b2e1 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
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
