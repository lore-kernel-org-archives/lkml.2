Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847Ab2BSTqu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 14:46:50 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44655 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753998Ab2BSTqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 14:46:49 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus971@gmail.com designates 10.68.195.99 as permitted sender) smtp.mail=linus971@gmail.com; dkim=pass header.i=linus971@gmail.com
Date: Sun, 19 Feb 2012 11:46:36 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@i5.linux-foundation.org
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
cc: x86@kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86-32: don't switch to irq stack for a user-mode irq
Message-ID: <alpine.LFD.2.02.1202191139260.10000@i5.linux-foundation.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun Feb 19 11:35:34 2012 -0800

x86-32: don't switch to irq stack for a user-mode irq

If the irq happens in user mode, our kernel stack is empty (apart from the 
pt_regs themselves, of course), so there's no need or advantage to switch.

And it really doesn't save any stack space, quite the reverse: it means 
that a nested interrupt cannot switch irq stacks. So instead of saving 
kernel stack space, it actually causes the potential for *more* stack 
usage.

Also simplify the preemption count copy when we do switch stacks: just 
copy the whole preemption count, rather than just the softirq parts of it.  
There is no advantage to the partial copy: it is more effort to get a less 
correct result.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---

This came up during the i387 work. It's not a bug, but I do believe that 
we do stupid things on x86-32 when we get an interrupt in user mode.

I'm throwing this patch out here because I think it's the right thing to 
do, but I won't commit it myself or push it any more than this.

 arch/x86/kernel/irq_32.c |   11 +++--------
 1 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/irq_32.c b/arch/x86/kernel/irq_32.c
index 40fc86161d92..58b7f27cb3e9 100644
--- a/arch/x86/kernel/irq_32.c
+++ b/arch/x86/kernel/irq_32.c
@@ -100,13 +100,8 @@ execute_on_irq_stack(int overflow, struct irq_desc *desc, int irq)
 	irqctx->tinfo.task = curctx->tinfo.task;
 	irqctx->tinfo.previous_esp = current_stack_pointer;
 
-	/*
-	 * Copy the softirq bits in preempt_count so that the
-	 * softirq checks work in the hardirq context.
-	 */
-	irqctx->tinfo.preempt_count =
-		(irqctx->tinfo.preempt_count & ~SOFTIRQ_MASK) |
-		(curctx->tinfo.preempt_count & SOFTIRQ_MASK);
+	/* Copy the preempt_count so that the [soft]irq checks work. */
+	irqctx->tinfo.preempt_count = curctx->tinfo.preempt_count;
 
 	if (unlikely(overflow))
 		call_on_stack(print_stack_overflow, isp);
@@ -196,7 +191,7 @@ bool handle_irq(unsigned irq, struct pt_regs *regs)
 	if (unlikely(!desc))
 		return false;
 
-	if (!execute_on_irq_stack(overflow, desc, irq)) {
+	if (user_mode_vm(regs) || !execute_on_irq_stack(overflow, desc, irq)) {
 		if (unlikely(overflow))
 			print_stack_overflow();
 		desc->handle_irq(irq, desc);
