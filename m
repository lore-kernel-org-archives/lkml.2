Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932364Ab2ICPYH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 11:24:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25069 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932350Ab2ICPYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 11:24:05 -0400
Date: Mon, 3 Sep 2012 17:26:09 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Roland McGrath <roland@hack.frob.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/7] ptrace: Partly fix
	set_task_blockstep()->update_debugctlmsr() logic
Message-ID: <20120903152609.GA9071@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120903152525.GA9028@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Afaics the usage of update_debugctlmsr() and TIF_BLOCKSTEP in
step.c was always very wrong.

1. update_debugctlmsr() was simply unneeded. The child sleeps
   TASK_TRACED, __switch_to_xtra(next_p => child) should notice
   TIF_BLOCKSTEP and set/clear DEBUGCTLMSR_BTF after resume if
   needed.

2. It is wrong. The state of DEBUGCTLMSR_BTF bit in CPU register
   should always match the state of current's TIF_BLOCKSTEP bit.

3. Even get_debugctlmsr() + update_debugctlmsr() itself does not
   look right. Irq can change other bits in MSR_IA32_DEBUGCTLMSR
   register or the caller can be preempted in between.

4. It is not safe to play with TIF_BLOCKSTEP if task != current.
   DEBUGCTLMSR_BTF and TIF_BLOCKSTEP should always match each
   other if the task is running. The tracee is stopped but it
   can be SIGKILL'ed right before set/clear_tsk_thread_flag().

However, now that uprobes uses user_enable_single_step(current)
we can't simply remove update_debugctlmsr(). So this patch adds
the additional "task == current" check and disables irqs to avoid
the race with interrupts/preemption.

Unfortunately this patch doesn't solve the last problem, we need
another fix. Probably we should teach ptrace_stop() to set/clear
single/block stepping after resume.

And afaics there is yet another problem: perf can play with
MSR_IA32_DEBUGCTLMSR from nmi, this obviously means that even
__switch_to_xtra() has problems.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/kernel/step.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/step.c b/arch/x86/kernel/step.c
index 7a51498..f89cdc6 100644
--- a/arch/x86/kernel/step.c
+++ b/arch/x86/kernel/step.c
@@ -161,6 +161,16 @@ static void set_task_blockstep(struct task_struct *task, bool on)
 {
 	unsigned long debugctl;
 
+	/*
+	 * Ensure irq/preemption can't change debugctl in between.
+	 * Note also that both TIF_BLOCKSTEP and debugctl should
+	 * be changed atomically wrt preemption.
+	 * FIXME: this means that set/clear TIF_BLOCKSTEP is simply
+	 * wrong if task != current, SIGKILL can wakeup the stopped
+	 * tracee and set/clear can play with the running task, this
+	 * can confuse the next __switch_to_xtra().
+	 */
+	local_irq_disable();
 	debugctl = get_debugctlmsr();
 	if (on) {
 		debugctl |= DEBUGCTLMSR_BTF;
@@ -169,7 +179,9 @@ static void set_task_blockstep(struct task_struct *task, bool on)
 		debugctl &= ~DEBUGCTLMSR_BTF;
 		clear_tsk_thread_flag(task, TIF_BLOCKSTEP);
 	}
-	update_debugctlmsr(debugctl);
+	if (task == current)
+		update_debugctlmsr(debugctl);
+	local_irq_enable();
 }
 
 /*
-- 
1.5.5.1

