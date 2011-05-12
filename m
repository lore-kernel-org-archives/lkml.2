Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758629Ab1ELUc1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 16:32:27 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:40208 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758615Ab1ELUcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 16:32:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=eS3i0x6fEEYz/1XQ00WhjQHuT49zFPdVD/U2wtWiT/Cv8Y/CCNRAG/39BWoxvUY4ZY
         7zVxc6ClpvhdkRmSX76ma+we5pb8C5j+2Gl2Occ2FeQCcZlo68UJKmeIaOhJKHguJBrn
         U3AGkgfkNPlFq1QOrB4S794IbPwxzHqncmFCk=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 2/2] x86: Make the x86-64 stacktrace code safely callable from scheduler
Date: Thu, 12 May 2011 22:32:06 +0200
Message-Id: <1305232326-9804-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1305232326-9804-1-git-send-email-fweisbec@gmail.com>
References: <1305232326-9804-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid potential scheduler recursion and deadlock from the
stacktrace code by avoiding rescheduling when we re-enable
preemption.

This robustifies some scheduler trace events like sched switch
when they are used to produce callchains in perf or ftrace.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/dumpstack_64.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index e71c98d..8e4f1d0 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -143,13 +143,16 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 		unsigned long *stack, unsigned long bp,
 		const struct stacktrace_ops *ops, void *data)
 {
-	const unsigned cpu = get_cpu();
-	unsigned long *irq_stack_end =
-		(unsigned long *)per_cpu(irq_stack_ptr, cpu);
+	unsigned long *irq_stack_end;
 	unsigned used = 0;
 	struct thread_info *tinfo;
 	int graph = 0;
 	unsigned long dummy;
+	int cpu;
+
+	preempt_disable();
+
+	cpu = smp_processor_id();
 
 	if (!task)
 		task = current;
@@ -168,6 +171,7 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 	 * exceptions
 	 */
 	tinfo = task_thread_info(task);
+	irq_stack_end = (unsigned long *)__get_cpu_var(irq_stack_ptr);
 	for (;;) {
 		char *id;
 		unsigned long *estack_end;
@@ -219,7 +223,9 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 	 * This handles the process stack:
 	 */
 	bp = ops->walk_stack(tinfo, stack, bp, ops, data, NULL, &graph);
-	put_cpu();
+
+	/* We want stacktrace to be computable anywhere, even in the scheduler */
+	preempt_enable_no_resched();
 }
 EXPORT_SYMBOL(dump_trace);
 
-- 
1.7.3.2

