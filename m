Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752361Ab0K2JRj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 04:17:39 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:37445 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827Ab0K2JRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 04:17:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Nb33p9mo90lfbEqcMJGXpEElcxFX0Q0bLZjirCvjvZZE38YQ/3IKYj6ShV7QHHk6+O
         zaR6iNFF12HVIv3LdfVT8zIKFD0q4Jcg15AwKKrLNwGLZ5kSMugCh5Ld3tK+ElWy5KJ5
         ho0HyFQC/WwX0Cn7ePHNiJcEMrDsowgOzU5Ww=
From: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
To: ralf@linux-mips.org, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
        will.deacon@arm.com
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        wuzhangjin@gmail.com, paulus@samba.org, mingo@elte.hu, acme@redhat.com,
        dengcheng.zhu@gmail.com, matt@console-pimps.org, sshtylyov@mvista.com
Subject: [PATCH v3 4/5] MIPS/Perf-events: Work with the new callchain interface
Date: Mon, 29 Nov 2010 17:19:10 +0800
Message-Id: <1291022351-13152-5-git-send-email-dengcheng.zhu@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291022351-13152-1-git-send-email-dengcheng.zhu@gmail.com>
References: <1291022351-13152-1-git-send-email-dengcheng.zhu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the MIPS part of the following commits by Frederic Weisbecker:

- f72c1a931e311bb7780fee19e41a89ac42cab50e
    perf: Factorize callchain context handling

    Store the kernel and user contexts from the generic layer instead
    of archs, this gathers some repetitive code.

- 56962b4449af34070bb1994621ef4f0265eed4d8
    perf: Generalize some arch callchain code

    - Most archs use one callchain buffer per cpu, except x86 that needs
      to deal with NMIs. Provide a default perf_callchain_buffer()
      implementation that x86 overrides.

    - Centralize all the kernel/user regs handling and invoke new arch
      handlers from there: perf_callchain_user() / perf_callchain_kernel()
      That avoid all the user_mode(), current->mm checks and so...

    - Invert some parameters in perf_callchain_*() helpers: entry to the
      left, regs to the right, following the traditional (dst, src).

- 70791ce9ba68a5921c9905ef05d23f62a90bc10c
    perf: Generalize callchain_store()

    callchain_store() is the same on every archs, inline it in
    perf_event.h and rename it to perf_callchain_store() to avoid
    any collision.

    This removes repetitive code.

- c1a65932fd7216fdc9a0db8bbffe1d47842f862c
    perf: Drop unappropriate tests on arch callchains

    Drop the TASK_RUNNING test on user tasks for callchains as
    this check doesn't seem to make any sense.

    Also remove the tests for !current that is not supposed to
    happen and current->pid as this should be handled at the
    generic level, with exclude_idle attribute.

Reported-by: Wu Zhangjin <wuzhangjin@gmail.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
---
 arch/mips/kernel/perf_event.c |   63 ++++-------------------------------------
 1 files changed, 6 insertions(+), 57 deletions(-)

diff --git a/arch/mips/kernel/perf_event.c b/arch/mips/kernel/perf_event.c
index 3d55761..8f7d2f8 100644
--- a/arch/mips/kernel/perf_event.c
+++ b/arch/mips/kernel/perf_event.c
@@ -534,21 +534,13 @@ handle_associated_event(struct cpu_hw_events *cpuc,
 #include "perf_event_mipsxx.c"
 
 /* Callchain handling code. */
-static inline void
-callchain_store(struct perf_callchain_entry *entry,
-		u64 ip)
-{
-	if (entry->nr < PERF_MAX_STACK_DEPTH)
-		entry->ip[entry->nr++] = ip;
-}
 
 /*
  * Leave userspace callchain empty for now. When we find a way to trace
  * the user stack callchains, we add here.
  */
-static void
-perf_callchain_user(struct pt_regs *regs,
-		    struct perf_callchain_entry *entry)
+void perf_callchain_user(struct perf_callchain_entry *entry,
+		    struct pt_regs *regs)
 {
 }
 
@@ -561,23 +553,21 @@ static void save_raw_perf_callchain(struct perf_callchain_entry *entry,
 	while (!kstack_end(sp)) {
 		addr = *sp++;
 		if (__kernel_text_address(addr)) {
-			callchain_store(entry, addr);
+			perf_callchain_store(entry, addr);
 			if (entry->nr >= PERF_MAX_STACK_DEPTH)
 				break;
 		}
 	}
 }
 
-static void
-perf_callchain_kernel(struct pt_regs *regs,
-		      struct perf_callchain_entry *entry)
+void perf_callchain_kernel(struct perf_callchain_entry *entry,
+		      struct pt_regs *regs)
 {
 	unsigned long sp = regs->regs[29];
 #ifdef CONFIG_KALLSYMS
 	unsigned long ra = regs->regs[31];
 	unsigned long pc = regs->cp0_epc;
 
-	callchain_store(entry, PERF_CONTEXT_KERNEL);
 	if (raw_show_trace || !__kernel_text_address(pc)) {
 		unsigned long stack_page =
 			(unsigned long)task_stack_page(current);
@@ -587,53 +577,12 @@ perf_callchain_kernel(struct pt_regs *regs,
 		return;
 	}
 	do {
-		callchain_store(entry, pc);
+		perf_callchain_store(entry, pc);
 		if (entry->nr >= PERF_MAX_STACK_DEPTH)
 			break;
 		pc = unwind_stack(current, &sp, pc, &ra);
 	} while (pc);
 #else
-	callchain_store(entry, PERF_CONTEXT_KERNEL);
 	save_raw_perf_callchain(entry, sp);
 #endif
 }
-
-static void
-perf_do_callchain(struct pt_regs *regs,
-		  struct perf_callchain_entry *entry)
-{
-	int is_user;
-
-	if (!regs)
-		return;
-
-	is_user = user_mode(regs);
-
-	if (!current || !current->pid)
-		return;
-
-	if (is_user && current->state != TASK_RUNNING)
-		return;
-
-	if (!is_user) {
-		perf_callchain_kernel(regs, entry);
-		if (current->mm)
-			regs = task_pt_regs(current);
-		else
-			regs = NULL;
-	}
-	if (regs)
-		perf_callchain_user(regs, entry);
-}
-
-static DEFINE_PER_CPU(struct perf_callchain_entry, pmc_irq_entry);
-
-struct perf_callchain_entry *
-perf_callchain(struct pt_regs *regs)
-{
-	struct perf_callchain_entry *entry = &__get_cpu_var(pmc_irq_entry);
-
-	entry->nr = 0;
-	perf_do_callchain(regs, entry);
-	return entry;
-}
-- 
1.7.1

