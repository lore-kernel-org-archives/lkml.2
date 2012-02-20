Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261Ab2BTLtH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 06:49:07 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33375 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687Ab2BTLtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 06:49:04 -0500
Date: Mon, 20 Feb 2012 03:47:57 -0800
From: tip-bot for Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <tip-986cb48c5a4de0085db94d343b4e7dcf54355ec1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <alpine.LFD.2.02.1202191139260.10000@i5.linux-foundation.org>
References: <alpine.LFD.2.02.1202191139260.10000@i5.linux-foundation.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] x86-32/irq: Don'
 t switch to irq stack for a user-mode irq
Git-Commit-ID: 986cb48c5a4de0085db94d343b4e7dcf54355ec1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 20 Feb 2012 03:48:37 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  986cb48c5a4de0085db94d343b4e7dcf54355ec1
Gitweb:     http://git.kernel.org/tip/986cb48c5a4de0085db94d343b4e7dcf54355ec1
Author:     Linus Torvalds <torvalds@linux-foundation.org>
AuthorDate: Sun, 19 Feb 2012 11:46:36 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 20 Feb 2012 09:30:18 +0100

x86-32/irq: Don't switch to irq stack for a user-mode irq

If the irq happens in user mode, our kernel stack is empty
(apart from the pt_regs themselves, of course), so there's no
need or advantage to switch.

And it really doesn't save any stack space, quite the reverse:
it means that a nested interrupt cannot switch irq stacks. So
instead of saving kernel stack space, it actually causes the
potential for *more* stack usage.

Also simplify the preemption count copy when we do switch
stacks: just copy the whole preemption count, rather than just
the softirq parts of it.  There is no advantage to the partial
copy: it is more effort to get a less correct result.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/alpine.LFD.2.02.1202191139260.10000@i5.linux-foundation.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/irq_32.c |   11 +++--------
 1 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/irq_32.c b/arch/x86/kernel/irq_32.c
index 40fc861..58b7f27 100644
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
