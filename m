Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559Ab0FMPEP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 11:04:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26788 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752730Ab0FMPEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 11:04:08 -0400
From: Avi Kivity <avi@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] x86, fpu: run device not available trap with interrupts enabled
Date: Sun, 13 Jun 2010 18:03:45 +0300
Message-Id: <1276441427-31514-3-git-send-email-avi@redhat.com>
In-Reply-To: <1276441427-31514-1-git-send-email-avi@redhat.com>
References: <1276441427-31514-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to allow a task's fpu state to fully float, we may need to
bring it back from another processor.  To do that, we need interrupts to
be enabled so we can fire off an IPI to that processor.

May break 80386/7 combos with FERR# wired through the interrupt controller.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kernel/traps.c |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 142d70c..c7d67cb 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -740,7 +740,6 @@ asmlinkage void math_state_restore(void)
 	struct task_struct *tsk = thread->task;
 
 	if (!tsk_used_math(tsk)) {
-		local_irq_enable();
 		/*
 		 * does a slab alloc which can sleep
 		 */
@@ -751,7 +750,6 @@ asmlinkage void math_state_restore(void)
 			do_group_exit(SIGKILL);
 			return;
 		}
-		local_irq_disable();
 	}
 
 	clts();				/* Allow maths ops (or we recurse) */
@@ -774,21 +772,20 @@ void math_emulate(struct math_emu_info *info)
 dotraplinkage void __kprobes
 do_device_not_available(struct pt_regs *regs, long error_code)
 {
+	preempt_disable();
+	local_irq_enable();
 #ifdef CONFIG_X86_32
 	if (read_cr0() & X86_CR0_EM) {
 		struct math_emu_info info = { };
 
-		conditional_sti(regs);
-
 		info.regs = regs;
 		math_emulate(&info);
-	} else {
-		math_state_restore(); /* interrupts still off */
-		conditional_sti(regs);
-	}
+	} else
+		math_state_restore();
 #else
 	math_state_restore();
 #endif
+	preempt_enable();
 }
 
 #ifdef CONFIG_X86_32
-- 
1.7.1

