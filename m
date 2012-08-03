Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576Ab2HCQdU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 12:33:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64899 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753475Ab2HCQdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 12:33:17 -0400
Date: Fri, 3 Aug 2012 18:29:54 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Roland McGrath <roland@hack.frob.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] ptrace: fix set_task_blockstep()->update_debugctlmsr()
	logic
Message-ID: <20120803162954.GA19806@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120803162912.GA19767@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Afaics the usage of update_debugctlmsr() in step.c was always
very wrong.

1. update_debugctlmsr() was simply unneeded. The child sleeps
   TASK_TRACED, __switch_to_xtra(next_p => child) should notice
   TIF_BLOCKSTEP and set/clear DEBUGCTLMSR_BTF after resume if
   needed.

2. It is wrong. The state of DEBUGCTLMSR_BTF bit in CPU register
   should always match the state of current's TIF_BLOCKSTEP bit.

3. Even get_debugctlmsr() + update_debugctlmsr() itself does not
   look right. Irq can change other bits in MSR_IA32_DEBUGCTLMSR
   register or the caller can be preempted in between.

However, now that uprobes uses user_enable_single_step(current)
we can't simply remove update_debugctlmsr(). So this patch adds
the additional "task == current" check and disables irqs to avoid
the race with interrupts/preemption.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/kernel/step.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/step.c b/arch/x86/kernel/step.c
index afa60db..636402e 100644
--- a/arch/x86/kernel/step.c
+++ b/arch/x86/kernel/step.c
@@ -166,12 +166,18 @@ static void set_task_blockstep(struct task_struct *task, bool on)
 	else
 		clear_tsk_thread_flag(task, TIF_BLOCKSTEP);
 
+	if (task != current)
+		return;
+
+	/* ensure irq/preemption can't change debugctl in between */
+	local_irq_disable();
 	debugctl = get_debugctlmsr();
 	if (on)
 		debugctl |= DEBUGCTLMSR_BTF;
 	else
 		debugctl &= ~DEBUGCTLMSR_BTF;
 	update_debugctlmsr(debugctl);
+	local_irq_enable();
 }
 
 /*
-- 
1.5.5.1

