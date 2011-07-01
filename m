Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756490Ab1GANTM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 09:19:12 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:57414 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756462Ab1GANTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 09:19:09 -0400
X-AuditID: b753bd60-a50caba000003bac-bc-4e0dc94a415e
X-AuditID: b753bd60-a50caba000003bac-bc-4e0dc94a415e
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [RFC PATCH -tip ] [BUGFIX] x86: Remove preempt disabling from kprobes
To: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Date: Fri, 01 Jul 2011 22:14:08 +0900
Message-ID: <20110701131408.30886.45766.stgit@localhost.localdomain>
In-Reply-To: <4E0DC859.6050405@hitachi.com>
References: <4E0DC859.6050405@hitachi.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt reported that putting kprobe on the instruction which
loads preempt_count causes the wrong result, as below.

Kprobes requires preemption to be disabled as it single steps the code
it replaced with a breakpoint. But because the code that is single
stepped could be reading the preempt count, the kprobe disabling of the
preempt count can cause the wrong value to end up as a result. Here's an
example:

If we add a kprobe on a inc_preempt_count() call:

	[ preempt_count = 0 ]

	ld preempt_count, %eax	<<--- trap

		<trap>
		preempt_disable();
		[ preempt_count = 1]
		setup_singlestep();
		<trap return>

	[ preempt_count = 1 ]

	ld preempt_count, %eax

	[ %eax = 1 ]

		<trap>
		post_kprobe_handler()
			preempt_enable_no_resched();
			[ preempt_count = 0 ]
		<trap return>

	[ %eax = 1 ]

	add %eax,1

	[ %eax = 2 ]

	st %eax, preempt_count

	[ preempt_count = 2 ]


We just caused preempt count to increment twice when it should have only
incremented once, and this screws everything else up.

To solve this, I've removed preempt disabling code from kprobes,
since the breakpoint exception and kprobes single step routine
disables interrupts, it doesn't need to disable preemption while
single-stepping anymore.

This patch is for -tip tree, and it can be applied to linus tree too.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Reported-by: Steven Rostedt <rostedt@goodmis.org>
---

 arch/x86/kernel/kprobes.c |   18 ++++++------------
 1 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index f1a6244..5de9cfb 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -475,7 +475,6 @@ static void __kprobes setup_singlestep(struct kprobe *p, struct pt_regs *regs,
 		 * stepping.
 		 */
 		regs->ip = (unsigned long)p->ainsn.insn;
-		preempt_enable_no_resched();
 		return;
 	}
 #endif
@@ -542,12 +541,13 @@ static int __kprobes kprobe_handler(struct pt_regs *regs)
 
 	addr = (kprobe_opcode_t *)(regs->ip - sizeof(kprobe_opcode_t));
 	/*
-	 * We don't want to be preempted for the entire
-	 * duration of kprobe processing. We conditionally
-	 * re-enable preemption at the end of this function,
-	 * and also in reenter_kprobe() and setup_singlestep().
+	 * We don't want to be preempted for the entire duration of kprobe
+	 * processing. This should be done by disabling interrupts instead
+	 * of incrementing preempt_count, because if the probed instruction
+	 * reads the count, it will get a wrong value.
+	 * Disabling irq is done by breakpoint exception.
 	 */
-	preempt_disable();
+	BUG_ON(!irqs_disabled());
 
 	kcb = get_kprobe_ctlblk();
 	p = get_kprobe(addr);
@@ -583,7 +583,6 @@ static int __kprobes kprobe_handler(struct pt_regs *regs)
 		 * the original instruction.
 		 */
 		regs->ip = (unsigned long)addr;
-		preempt_enable_no_resched();
 		return 1;
 	} else if (kprobe_running()) {
 		p = __this_cpu_read(current_kprobe);
@@ -593,7 +592,6 @@ static int __kprobes kprobe_handler(struct pt_regs *regs)
 		}
 	} /* else: not a kprobe fault; let the kernel handle it */
 
-	preempt_enable_no_resched();
 	return 0;
 }
 
@@ -917,7 +915,6 @@ static int __kprobes post_kprobe_handler(struct pt_regs *regs)
 	}
 	reset_current_kprobe();
 out:
-	preempt_enable_no_resched();
 
 	/*
 	 * if somebody else is singlestepping across a probe point, flags
@@ -951,7 +948,6 @@ int __kprobes kprobe_fault_handler(struct pt_regs *regs, int trapnr)
 			restore_previous_kprobe(kcb);
 		else
 			reset_current_kprobe();
-		preempt_enable_no_resched();
 		break;
 	case KPROBE_HIT_ACTIVE:
 	case KPROBE_HIT_SSDONE:
@@ -1098,7 +1094,6 @@ int __kprobes longjmp_break_handler(struct kprobe *p, struct pt_regs *regs)
 		memcpy((kprobe_opcode_t *)(kcb->jprobe_saved_sp),
 		       kcb->jprobes_stack,
 		       MIN_STACK_SIZE(kcb->jprobe_saved_sp));
-		preempt_enable_no_resched();
 		return 1;
 	}
 	return 0;
@@ -1530,7 +1525,6 @@ static int  __kprobes setup_detour_execution(struct kprobe *p,
 		regs->ip = (unsigned long)op->optinsn.insn + TMPL_END_IDX;
 		if (!reenter)
 			reset_current_kprobe();
-		preempt_enable_no_resched();
 		return 1;
 	}
 	return 0;

