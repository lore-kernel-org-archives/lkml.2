Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771Ab0GAPgO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 11:36:14 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57396 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756697Ab0GAPgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 11:36:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=DiicZqFt6U9hgRxdOccUvM+OyDPSw9W+hYLsp2vpHV7rId0kd2rqOjo30KqRTG26mG
         Y9eUJuMKoKcJUrc/yBfAEBp3m/N4jUEBZWmqmRD2OtjhqF5r7YQwJI0b0UQMedIBbpgR
         Molu2B8D/+kQNRgJJdq5R4PBv+Dx8k25+AvRY=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Stephane Eranian <eranian@google.com>,
       David Miller <davem@davemloft.net>, Paul Mundt <lethal@linux-sh.org>,
       Will Deacon <will.deacon@arm.com>, Borislav Petkov <bp@amd64.org>
Subject: [RFC PATCH 2/6] perf: Generalize callchain_store()
Date: Thu,  1 Jul 2010 17:35:58 +0200
Message-Id: <1277998562-21366-3-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1277998562-21366-1-git-send-regression-fweisbec@gmail.com>
References: <1277998562-21366-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

callchain_store() is the same on every archs, inline it in
perf_event.h and rename it to perf_callchain_store() to avoid
any collision.

This removes repetitive code.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: David Miller <davem@davemloft.net>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Borislav Petkov <bp@amd64.org>
---
 arch/arm/kernel/perf_event.c         |   15 +++---------
 arch/powerpc/kernel/perf_callchain.c |   40 ++++++++++++----------------------
 arch/sh/kernel/perf_callchain.c      |   11 ++------
 arch/sparc/kernel/perf_event.c       |   26 ++++++++-------------
 arch/x86/kernel/cpu/perf_event.c     |   20 ++++++-----------
 include/linux/perf_event.h           |    7 ++++++
 6 files changed, 45 insertions(+), 74 deletions(-)

diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
index 16519f6..41de647 100644
--- a/arch/arm/kernel/perf_event.c
+++ b/arch/arm/kernel/perf_event.c
@@ -3001,13 +3001,6 @@ arch_initcall(init_hw_perf_events);
 /*
  * Callchain handling code.
  */
-static inline void
-callchain_store(struct perf_callchain_entry *entry,
-		u64 ip)
-{
-	if (entry->nr < PERF_MAX_STACK_DEPTH)
-		entry->ip[entry->nr++] = ip;
-}
 
 /*
  * The registers we're interested in are at the end of the variable
@@ -3039,7 +3032,7 @@ user_backtrace(struct frame_tail *tail,
 	if (__copy_from_user_inatomic(&buftail, tail, sizeof(buftail)))
 		return NULL;
 
-	callchain_store(entry, buftail.lr);
+	perf_callchain_store(entry, buftail.lr);
 
 	/*
 	 * Frame pointers should strictly progress back up the stack
@@ -3057,7 +3050,7 @@ perf_callchain_user(struct pt_regs *regs,
 {
 	struct frame_tail *tail;
 
-	callchain_store(entry, PERF_CONTEXT_USER);
+	perf_callchain_store(entry, PERF_CONTEXT_USER);
 
 	if (!user_mode(regs))
 		regs = task_pt_regs(current);
@@ -3078,7 +3071,7 @@ callchain_trace(struct stackframe *fr,
 		void *data)
 {
 	struct perf_callchain_entry *entry = data;
-	callchain_store(entry, fr->pc);
+	perf_callchain_store(entry, fr->pc);
 	return 0;
 }
 
@@ -3088,7 +3081,7 @@ perf_callchain_kernel(struct pt_regs *regs,
 {
 	struct stackframe fr;
 
-	callchain_store(entry, PERF_CONTEXT_KERNEL);
+	perf_callchain_store(entry, PERF_CONTEXT_KERNEL);
 	fr.fp = regs->ARM_fp;
 	fr.sp = regs->ARM_sp;
 	fr.lr = regs->ARM_lr;
diff --git a/arch/powerpc/kernel/perf_callchain.c b/arch/powerpc/kernel/perf_callchain.c
index 95ad9da..a286c2e 100644
--- a/arch/powerpc/kernel/perf_callchain.c
+++ b/arch/powerpc/kernel/perf_callchain.c
@@ -23,18 +23,6 @@
 #include "ppc32.h"
 #endif
 
-/*
- * Store another value in a callchain_entry.
- */
-static inline void callchain_store(struct perf_callchain_entry *entry, u64 ip)
-{
-	unsigned int nr = entry->nr;
-
-	if (nr < PERF_MAX_STACK_DEPTH) {
-		entry->ip[nr] = ip;
-		entry->nr = nr + 1;
-	}
-}
 
 /*
  * Is sp valid as the address of the next kernel stack frame after prev_sp?
@@ -69,8 +57,8 @@ static void perf_callchain_kernel(struct pt_regs *regs,
 
 	lr = regs->link;
 	sp = regs->gpr[1];
-	callchain_store(entry, PERF_CONTEXT_KERNEL);
-	callchain_store(entry, regs->nip);
+	perf_callchain_store(entry, PERF_CONTEXT_KERNEL);
+	perf_callchain_store(entry, regs->nip);
 
 	if (!validate_sp(sp, current, STACK_FRAME_OVERHEAD))
 		return;
@@ -89,7 +77,7 @@ static void perf_callchain_kernel(struct pt_regs *regs,
 			next_ip = regs->nip;
 			lr = regs->link;
 			level = 0;
-			callchain_store(entry, PERF_CONTEXT_KERNEL);
+			perf_callchain_store(entry, PERF_CONTEXT_KERNEL);
 
 		} else {
 			if (level == 0)
@@ -111,7 +99,7 @@ static void perf_callchain_kernel(struct pt_regs *regs,
 			++level;
 		}
 
-		callchain_store(entry, next_ip);
+		perf_callchain_store(entry, next_ip);
 		if (!valid_next_sp(next_sp, sp))
 			return;
 		sp = next_sp;
@@ -246,8 +234,8 @@ static void perf_callchain_user_64(struct pt_regs *regs,
 	next_ip = regs->nip;
 	lr = regs->link;
 	sp = regs->gpr[1];
-	callchain_store(entry, PERF_CONTEXT_USER);
-	callchain_store(entry, next_ip);
+	perf_callchain_store(entry, PERF_CONTEXT_USER);
+	perf_callchain_store(entry, next_ip);
 
 	for (;;) {
 		fp = (unsigned long __user *) sp;
@@ -276,14 +264,14 @@ static void perf_callchain_user_64(struct pt_regs *regs,
 			    read_user_stack_64(&uregs[PT_R1], &sp))
 				return;
 			level = 0;
-			callchain_store(entry, PERF_CONTEXT_USER);
-			callchain_store(entry, next_ip);
+			perf_callchain_store(entry, PERF_CONTEXT_USER);
+			perf_callchain_store(entry, next_ip);
 			continue;
 		}
 
 		if (level == 0)
 			next_ip = lr;
-		callchain_store(entry, next_ip);
+		perf_callchain_store(entry, next_ip);
 		++level;
 		sp = next_sp;
 	}
@@ -447,8 +435,8 @@ static void perf_callchain_user_32(struct pt_regs *regs,
 	next_ip = regs->nip;
 	lr = regs->link;
 	sp = regs->gpr[1];
-	callchain_store(entry, PERF_CONTEXT_USER);
-	callchain_store(entry, next_ip);
+	perf_callchain_store(entry, PERF_CONTEXT_USER);
+	perf_callchain_store(entry, next_ip);
 
 	while (entry->nr < PERF_MAX_STACK_DEPTH) {
 		fp = (unsigned int __user *) (unsigned long) sp;
@@ -470,14 +458,14 @@ static void perf_callchain_user_32(struct pt_regs *regs,
 			    read_user_stack_32(&uregs[PT_R1], &sp))
 				return;
 			level = 0;
-			callchain_store(entry, PERF_CONTEXT_USER);
-			callchain_store(entry, next_ip);
+			perf_callchain_store(entry, PERF_CONTEXT_USER);
+			perf_callchain_store(entry, next_ip);
 			continue;
 		}
 
 		if (level == 0)
 			next_ip = lr;
-		callchain_store(entry, next_ip);
+		perf_callchain_store(entry, next_ip);
 		++level;
 		sp = next_sp;
 	}
diff --git a/arch/sh/kernel/perf_callchain.c b/arch/sh/kernel/perf_callchain.c
index 1d6dbce..00143f3 100644
--- a/arch/sh/kernel/perf_callchain.c
+++ b/arch/sh/kernel/perf_callchain.c
@@ -14,11 +14,6 @@
 #include <asm/unwinder.h>
 #include <asm/ptrace.h>
 
-static inline void callchain_store(struct perf_callchain_entry *entry, u64 ip)
-{
-	if (entry->nr < PERF_MAX_STACK_DEPTH)
-		entry->ip[entry->nr++] = ip;
-}
 
 static void callchain_warning(void *data, char *msg)
 {
@@ -39,7 +34,7 @@ static void callchain_address(void *data, unsigned long addr, int reliable)
 	struct perf_callchain_entry *entry = data;
 
 	if (reliable)
-		callchain_store(entry, addr);
+		perf_callchain_store(entry, addr);
 }
 
 static const struct stacktrace_ops callchain_ops = {
@@ -52,8 +47,8 @@ static const struct stacktrace_ops callchain_ops = {
 static void
 perf_callchain_kernel(struct pt_regs *regs, struct perf_callchain_entry *entry)
 {
-	callchain_store(entry, PERF_CONTEXT_KERNEL);
-	callchain_store(entry, regs->pc);
+	perf_callchain_store(entry, PERF_CONTEXT_KERNEL);
+	perf_callchain_store(entry, regs->pc);
 
 	unwind_stack(NULL, regs, NULL, &callchain_ops, entry);
 }
diff --git a/arch/sparc/kernel/perf_event.c b/arch/sparc/kernel/perf_event.c
index 8a6660d..fbac5ad 100644
--- a/arch/sparc/kernel/perf_event.c
+++ b/arch/sparc/kernel/perf_event.c
@@ -1282,12 +1282,6 @@ void __init init_hw_perf_events(void)
 	register_die_notifier(&perf_event_nmi_notifier);
 }
 
-static inline void callchain_store(struct perf_callchain_entry *entry, u64 ip)
-{
-	if (entry->nr < PERF_MAX_STACK_DEPTH)
-		entry->ip[entry->nr++] = ip;
-}
-
 static void perf_callchain_kernel(struct pt_regs *regs,
 				  struct perf_callchain_entry *entry)
 {
@@ -1296,8 +1290,8 @@ static void perf_callchain_kernel(struct pt_regs *regs,
 	int graph = 0;
 #endif
 
-	callchain_store(entry, PERF_CONTEXT_KERNEL);
-	callchain_store(entry, regs->tpc);
+	perf_callchain_store(entry, PERF_CONTEXT_KERNEL);
+	perf_callchain_store(entry, regs->tpc);
 
 	ksp = regs->u_regs[UREG_I6];
 	fp = ksp + STACK_BIAS;
@@ -1321,13 +1315,13 @@ static void perf_callchain_kernel(struct pt_regs *regs,
 			pc = sf->callers_pc;
 			fp = (unsigned long)sf->fp + STACK_BIAS;
 		}
-		callchain_store(entry, pc);
+		perf_callchain_store(entry, pc);
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 		if ((pc + 8UL) == (unsigned long) &return_to_handler) {
 			int index = current->curr_ret_stack;
 			if (current->ret_stack && index >= graph) {
 				pc = current->ret_stack[index - graph].ret;
-				callchain_store(entry, pc);
+				perf_callchain_store(entry, pc);
 				graph++;
 			}
 		}
@@ -1340,8 +1334,8 @@ static void perf_callchain_user_64(struct pt_regs *regs,
 {
 	unsigned long ufp;
 
-	callchain_store(entry, PERF_CONTEXT_USER);
-	callchain_store(entry, regs->tpc);
+	perf_callchain_store(entry, PERF_CONTEXT_USER);
+	perf_callchain_store(entry, regs->tpc);
 
 	ufp = regs->u_regs[UREG_I6] + STACK_BIAS;
 	do {
@@ -1354,7 +1348,7 @@ static void perf_callchain_user_64(struct pt_regs *regs,
 
 		pc = sf.callers_pc;
 		ufp = (unsigned long)sf.fp + STACK_BIAS;
-		callchain_store(entry, pc);
+		perf_callchain_store(entry, pc);
 	} while (entry->nr < PERF_MAX_STACK_DEPTH);
 }
 
@@ -1363,8 +1357,8 @@ static void perf_callchain_user_32(struct pt_regs *regs,
 {
 	unsigned long ufp;
 
-	callchain_store(entry, PERF_CONTEXT_USER);
-	callchain_store(entry, regs->tpc);
+	perf_callchain_store(entry, PERF_CONTEXT_USER);
+	perf_callchain_store(entry, regs->tpc);
 
 	ufp = regs->u_regs[UREG_I6] & 0xffffffffUL;
 	do {
@@ -1377,7 +1371,7 @@ static void perf_callchain_user_32(struct pt_regs *regs,
 
 		pc = sf.callers_pc;
 		ufp = (unsigned long)sf.fp;
-		callchain_store(entry, pc);
+		perf_callchain_store(entry, pc);
 	} while (entry->nr < PERF_MAX_STACK_DEPTH);
 }
 
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 4a4d191..8af28ca 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1571,12 +1571,6 @@ const struct pmu *hw_perf_event_init(struct perf_event *event)
  * callchain support
  */
 
-static inline
-void callchain_store(struct perf_callchain_entry *entry, u64 ip)
-{
-	if (entry->nr < PERF_MAX_STACK_DEPTH)
-		entry->ip[entry->nr++] = ip;
-}
 
 static DEFINE_PER_CPU(struct perf_callchain_entry, pmc_irq_entry);
 static DEFINE_PER_CPU(struct perf_callchain_entry, pmc_nmi_entry);
@@ -1602,7 +1596,7 @@ static void backtrace_address(void *data, unsigned long addr, int reliable)
 {
 	struct perf_callchain_entry *entry = data;
 
-	callchain_store(entry, addr);
+	perf_callchain_store(entry, addr);
 }
 
 static const struct stacktrace_ops backtrace_ops = {
@@ -1616,8 +1610,8 @@ static const struct stacktrace_ops backtrace_ops = {
 static void
 perf_callchain_kernel(struct pt_regs *regs, struct perf_callchain_entry *entry)
 {
-	callchain_store(entry, PERF_CONTEXT_KERNEL);
-	callchain_store(entry, regs->ip);
+	perf_callchain_store(entry, PERF_CONTEXT_KERNEL);
+	perf_callchain_store(entry, regs->ip);
 
 	dump_trace(NULL, regs, NULL, regs->bp, &backtrace_ops, entry);
 }
@@ -1646,7 +1640,7 @@ perf_callchain_user32(struct pt_regs *regs, struct perf_callchain_entry *entry)
 		if (fp < compat_ptr(regs->sp))
 			break;
 
-		callchain_store(entry, frame.return_address);
+		perf_callchain_store(entry, frame.return_address);
 		fp = compat_ptr(frame.next_frame);
 	}
 	return 1;
@@ -1670,8 +1664,8 @@ perf_callchain_user(struct pt_regs *regs, struct perf_callchain_entry *entry)
 
 	fp = (void __user *)regs->bp;
 
-	callchain_store(entry, PERF_CONTEXT_USER);
-	callchain_store(entry, regs->ip);
+	perf_callchain_store(entry, PERF_CONTEXT_USER);
+	perf_callchain_store(entry, regs->ip);
 
 	if (perf_callchain_user32(regs, entry))
 		return;
@@ -1688,7 +1682,7 @@ perf_callchain_user(struct pt_regs *regs, struct perf_callchain_entry *entry)
 		if ((unsigned long)fp < regs->sp)
 			break;
 
-		callchain_store(entry, frame.return_address);
+		perf_callchain_store(entry, frame.return_address);
 		fp = frame.next_frame;
 	}
 }
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 937495c..3588804 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -978,6 +978,13 @@ extern void perf_event_fork(struct task_struct *tsk);
 
 extern struct perf_callchain_entry *perf_callchain(struct pt_regs *regs);
 
+static inline void
+perf_callchain_store(struct perf_callchain_entry *entry, u64 ip)
+{
+	if (entry->nr < PERF_MAX_STACK_DEPTH)
+		entry->ip[entry->nr++] = ip;
+}
+
 extern int sysctl_perf_event_paranoid;
 extern int sysctl_perf_event_mlock;
 extern int sysctl_perf_event_sample_rate;
-- 
1.6.2.3

