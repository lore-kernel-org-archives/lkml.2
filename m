Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336Ab2ISB3j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 21:29:39 -0400
Received: from mail-wi0-f202.google.com ([209.85.212.202]:44642 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996Ab2ISB3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 21:29:37 -0400
Subject: [PATCH] x86: Don't clobber top of pt_regs in nested NMI
To: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
From: Salman Qazi <sqazi@google.com>
Date: Tue, 18 Sep 2012 18:29:35 -0700
Message-ID: <20120919012935.23551.12099.stgit@dungbeetle.mtv.corp.google.com>
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

We solve this problem by introducing an extra copy of the iret
registers that are exclusively a part of pt_regs and are not modified
elsewhere.  The downside is that the do_nmi function can no longer
change the control flow, as any values it writes to these five
registers will be discarded.

Signed-off-by: Salman Qazi <sqazi@google.com>
---
 arch/x86/kernel/entry_64.S |   20 +++++++++++++++++++-
 1 files changed, 19 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 69babd8..40ddb6d 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1724,6 +1724,18 @@ repeat_nmi:
 end_repeat_nmi:
 
 	/*
+	 * We went a running NMI handling routine to have a consistent
+	 * picture of register state.  This should hold true even if
+	 * there is a nested NMI.  Therefore, we let the nested NMI
+	 * play with the previous copy of these registers and leave this
+	 * new copy unmodified for do_nmi()
+	 */
+	.rept 5
+	pushq_cfi 4*8(%rsp)
+	.endr
+	CFI_DEF_CFA_OFFSET SS+8-RIP
+
+	/*
 	 * Everything below this point can be preempted by a nested
 	 * NMI if the first NMI took an exception and reset our iret stack
 	 * so that we repeat another NMI.
@@ -1771,7 +1783,13 @@ nmi_swapgs:
 nmi_restore:
 	RESTORE_ALL 8
 	/* Clear the NMI executing stack variable */
-	movq $0, 10*8(%rsp)
+	movq $0, 15*8(%rsp)
+
+	/* Pop the extra copy of iret context that was saved above
+	 * just for do_nmi()
+	 */
+	addq $5*8, %rsp
+
 	jmp irq_return
 	CFI_ENDPROC
 END(nmi)

