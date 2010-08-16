Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756743Ab0HPUsu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 16:48:50 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:49642 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756646Ab0HPUss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 16:48:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=Tqs10wgOb53/0M4D5Ham6N5s++FfGipDsx1dSk1ga6l5DSsu3p94xkBJIdLSRzuymk
         S0MrWKthlBdusU9xPbemKYjXii458wesNiobmu+xI2tSQMQ0Kj8JknNl3tv0lJ8UtS0y
         8EjbQnzhN48Fmz8KIuaA+Ug5mpycHGW6CROsA=
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
Subject: [RFC PATCH 3/6] perf: Generalize some arch callchain code
Date: Mon, 16 Aug 2010 22:48:32 +0200
Message-Id: <1281991715-10367-4-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1281991715-10367-1-git-send-regression-fweisbec@gmail.com>
References: <1281991715-10367-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Most archs use one callchain buffer per cpu, except x86 that needs
  to deal with NMIs. Provide a default perf_callchain_buffer()
  implementation that x86 overrides.

- Centralize all the kernel/user regs handling and invoke new arch
  handlers from there: perf_callchain_user() / perf_callchain_kernel()
  That avoid all the user_mode(), current->mm checks and so...

- Invert some parameters in perf_callchain_*() helpers: entry to the
  left, regs to the right, following the traditional (src, dst).

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
 arch/arm/kernel/perf_event.c         |   43 +++---------------------------
 arch/powerpc/kernel/perf_callchain.c |   49 +++++++++------------------------
 arch/sh/kernel/perf_callchain.c      |   37 +------------------------
 arch/sparc/kernel/perf_event.c       |   46 ++++++++++---------------------
 arch/x86/kernel/cpu/perf_event.c     |   45 +++++-------------------------
 include/linux/perf_event.h           |   10 ++++++-
 kernel/perf_event.c                  |   40 ++++++++++++++++++++++++++-
 7 files changed, 90 insertions(+), 180 deletions(-)

diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
index a07c3b1..0e3bbdb 100644
--- a/arch/arm/kernel/perf_event.c
+++ b/arch/arm/kernel/perf_event.c
@@ -3044,17 +3044,13 @@ user_backtrace(struct frame_tail *tail,
 	return buftail.fp - 1;
 }
 
-static void
-perf_callchain_user(struct pt_regs *regs,
-		    struct perf_callchain_entry *entry)
+void
+perf_callchain_user(struct perf_callchain_entry *entry, struct pt_regs *regs)
 {
 	struct frame_tail *tail;
 
 	perf_callchain_store(entry, PERF_CONTEXT_USER);
 
-	if (!user_mode(regs))
-		regs = task_pt_regs(current);
-
 	tail = (struct frame_tail *)regs->ARM_fp - 1;
 
 	while (tail && !((unsigned long)tail & 0x3))
@@ -3075,9 +3071,8 @@ callchain_trace(struct stackframe *fr,
 	return 0;
 }
 
-static void
-perf_callchain_kernel(struct pt_regs *regs,
-		      struct perf_callchain_entry *entry)
+void
+perf_callchain_kernel(struct perf_callchain_entry *entry, struct pt_regs *regs)
 {
 	struct stackframe fr;
 
@@ -3088,33 +3083,3 @@ perf_callchain_kernel(struct pt_regs *regs,
 	fr.pc = regs->ARM_pc;
 	walk_stackframe(&fr, callchain_trace, entry);
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
-	if (!is_user)
-		perf_callchain_kernel(regs, entry);
-
-	if (current->mm)
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
diff --git a/arch/powerpc/kernel/perf_callchain.c b/arch/powerpc/kernel/perf_callchain.c
index a286c2e..f7a85ed 100644
--- a/arch/powerpc/kernel/perf_callchain.c
+++ b/arch/powerpc/kernel/perf_callchain.c
@@ -46,8 +46,8 @@ static int valid_next_sp(unsigned long sp, unsigned long prev_sp)
 	return 0;
 }
 
-static void perf_callchain_kernel(struct pt_regs *regs,
-				  struct perf_callchain_entry *entry)
+void
+perf_callchain_kernel(struct perf_callchain_entry *entry, struct pt_regs *regs)
 {
 	unsigned long sp, next_sp;
 	unsigned long next_ip;
@@ -221,8 +221,8 @@ static int sane_signal_64_frame(unsigned long sp)
 		puc == (unsigned long) &sf->uc;
 }
 
-static void perf_callchain_user_64(struct pt_regs *regs,
-				   struct perf_callchain_entry *entry)
+static void perf_callchain_user_64(struct perf_callchain_entry *entry,
+				   struct pt_regs *regs)
 {
 	unsigned long sp, next_sp;
 	unsigned long next_ip;
@@ -303,8 +303,8 @@ static int read_user_stack_32(unsigned int __user *ptr, unsigned int *ret)
 	return __get_user_inatomic(*ret, ptr);
 }
 
-static inline void perf_callchain_user_64(struct pt_regs *regs,
-					  struct perf_callchain_entry *entry)
+static inline void perf_callchain_user_64(struct perf_callchain_entry *entry,
+					  struct pt_regs *regs)
 {
 }
 
@@ -423,8 +423,8 @@ static unsigned int __user *signal_frame_32_regs(unsigned int sp,
 	return mctx->mc_gregs;
 }
 
-static void perf_callchain_user_32(struct pt_regs *regs,
-				   struct perf_callchain_entry *entry)
+static void perf_callchain_user_32(struct perf_callchain_entry *entry,
+				   struct pt_regs *regs)
 {
 	unsigned int sp, next_sp;
 	unsigned int next_ip;
@@ -471,32 +471,11 @@ static void perf_callchain_user_32(struct pt_regs *regs,
 	}
 }
 
-/*
- * Since we can't get PMU interrupts inside a PMU interrupt handler,
- * we don't need separate irq and nmi entries here.
- */
-static DEFINE_PER_CPU(struct perf_callchain_entry, cpu_perf_callchain);
-
-struct perf_callchain_entry *perf_callchain(struct pt_regs *regs)
+void
+perf_callchain_user(struct perf_callchain_entry *entry, struct pt_regs *regs)
 {
-	struct perf_callchain_entry *entry = &__get_cpu_var(cpu_perf_callchain);
-
-	entry->nr = 0;
-
-	if (!user_mode(regs)) {
-		perf_callchain_kernel(regs, entry);
-		if (current->mm)
-			regs = task_pt_regs(current);
-		else
-			regs = NULL;
-	}
-
-	if (regs) {
-		if (current_is_64bit())
-			perf_callchain_user_64(regs, entry);
-		else
-			perf_callchain_user_32(regs, entry);
-	}
-
-	return entry;
+	if (current_is_64bit())
+		perf_callchain_user_64(entry, regs);
+	else
+		perf_callchain_user_32(entry, regs);
 }
diff --git a/arch/sh/kernel/perf_callchain.c b/arch/sh/kernel/perf_callchain.c
index 00143f3..ef076a9 100644
--- a/arch/sh/kernel/perf_callchain.c
+++ b/arch/sh/kernel/perf_callchain.c
@@ -44,44 +44,11 @@ static const struct stacktrace_ops callchain_ops = {
 	.address	= callchain_address,
 };
 
-static void
-perf_callchain_kernel(struct pt_regs *regs, struct perf_callchain_entry *entry)
+void
+perf_callchain_kernel(struct perf_callchain_entry *entry, struct pt_regs *regs)
 {
 	perf_callchain_store(entry, PERF_CONTEXT_KERNEL);
 	perf_callchain_store(entry, regs->pc);
 
 	unwind_stack(NULL, regs, NULL, &callchain_ops, entry);
 }
-
-static void
-perf_do_callchain(struct pt_regs *regs, struct perf_callchain_entry *entry)
-{
-	int is_user;
-
-	if (!regs)
-		return;
-
-	is_user = user_mode(regs);
-
-	/*
-	 * Only the kernel side is implemented for now.
-	 */
-	if (!is_user)
-		perf_callchain_kernel(regs, entry);
-}
-
-/*
- * No need for separate IRQ and NMI entries.
- */
-static DEFINE_PER_CPU(struct perf_callchain_entry, callchain);
-
-struct perf_callchain_entry *perf_callchain(struct pt_regs *regs)
-{
-	struct perf_callchain_entry *entry = &__get_cpu_var(callchain);
-
-	entry->nr = 0;
-
-	perf_do_callchain(regs, entry);
-
-	return entry;
-}
diff --git a/arch/sparc/kernel/perf_event.c b/arch/sparc/kernel/perf_event.c
index 2a95a90..460162d 100644
--- a/arch/sparc/kernel/perf_event.c
+++ b/arch/sparc/kernel/perf_event.c
@@ -1283,14 +1283,16 @@ void __init init_hw_perf_events(void)
 	register_die_notifier(&perf_event_nmi_notifier);
 }
 
-static void perf_callchain_kernel(struct pt_regs *regs,
-				  struct perf_callchain_entry *entry)
+void perf_callchain_kernel(struct perf_callchain_entry *entry,
+			   struct pt_regs *regs)
 {
 	unsigned long ksp, fp;
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 	int graph = 0;
 #endif
 
+	stack_trace_flush();
+
 	perf_callchain_store(entry, PERF_CONTEXT_KERNEL);
 	perf_callchain_store(entry, regs->tpc);
 
@@ -1330,8 +1332,8 @@ static void perf_callchain_kernel(struct pt_regs *regs,
 	} while (entry->nr < PERF_MAX_STACK_DEPTH);
 }
 
-static void perf_callchain_user_64(struct pt_regs *regs,
-				   struct perf_callchain_entry *entry)
+static void perf_callchain_user_64(struct perf_callchain_entry *entry,
+				   struct pt_regs *regs)
 {
 	unsigned long ufp;
 
@@ -1353,8 +1355,8 @@ static void perf_callchain_user_64(struct pt_regs *regs,
 	} while (entry->nr < PERF_MAX_STACK_DEPTH);
 }
 
-static void perf_callchain_user_32(struct pt_regs *regs,
-				   struct perf_callchain_entry *entry)
+static void perf_callchain_user_32(struct perf_callchain_entry *entry,
+				   struct pt_regs *regs)
 {
 	unsigned long ufp;
 
@@ -1376,30 +1378,12 @@ static void perf_callchain_user_32(struct pt_regs *regs,
 	} while (entry->nr < PERF_MAX_STACK_DEPTH);
 }
 
-/* Like powerpc we can't get PMU interrupts within the PMU handler,
- * so no need for separate NMI and IRQ chains as on x86.
- */
-static DEFINE_PER_CPU(struct perf_callchain_entry, callchain);
-
-struct perf_callchain_entry *perf_callchain(struct pt_regs *regs)
+void
+perf_callchain_user(struct perf_callchain_entry *entry, struct pt_regs *regs)
 {
-	struct perf_callchain_entry *entry = &__get_cpu_var(callchain);
-
-	entry->nr = 0;
-	if (!user_mode(regs)) {
-		stack_trace_flush();
-		perf_callchain_kernel(regs, entry);
-		if (current->mm)
-			regs = task_pt_regs(current);
-		else
-			regs = NULL;
-	}
-	if (regs) {
-		flushw_user();
-		if (test_thread_flag(TIF_32BIT))
-			perf_callchain_user_32(regs, entry);
-		else
-			perf_callchain_user_64(regs, entry);
-	}
-	return entry;
+	flushw_user();
+	if (test_thread_flag(TIF_32BIT))
+		perf_callchain_user_32(entry, regs);
+	else
+		perf_callchain_user_64(entry, regs);
 }
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 8af28ca..39f8421 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1571,9 +1571,7 @@ const struct pmu *hw_perf_event_init(struct perf_event *event)
  * callchain support
  */
 
-
-static DEFINE_PER_CPU(struct perf_callchain_entry, pmc_irq_entry);
-static DEFINE_PER_CPU(struct perf_callchain_entry, pmc_nmi_entry);
+static DEFINE_PER_CPU(struct perf_callchain_entry, perf_callchain_entry_nmi);
 
 
 static void
@@ -1607,8 +1605,8 @@ static const struct stacktrace_ops backtrace_ops = {
 	.walk_stack		= print_context_stack_bp,
 };
 
-static void
-perf_callchain_kernel(struct pt_regs *regs, struct perf_callchain_entry *entry)
+void
+perf_callchain_kernel(struct perf_callchain_entry *entry, struct pt_regs *regs)
 {
 	perf_callchain_store(entry, PERF_CONTEXT_KERNEL);
 	perf_callchain_store(entry, regs->ip);
@@ -1653,14 +1651,12 @@ perf_callchain_user32(struct pt_regs *regs, struct perf_callchain_entry *entry)
 }
 #endif
 
-static void
-perf_callchain_user(struct pt_regs *regs, struct perf_callchain_entry *entry)
+void
+perf_callchain_user(struct perf_callchain_entry *entry, struct pt_regs *regs)
 {
 	struct stack_frame frame;
 	const void __user *fp;
 
-	if (!user_mode(regs))
-		regs = task_pt_regs(current);
 
 	fp = (void __user *)regs->bp;
 
@@ -1687,42 +1683,17 @@ perf_callchain_user(struct pt_regs *regs, struct perf_callchain_entry *entry)
 	}
 }
 
-static void
-perf_do_callchain(struct pt_regs *regs, struct perf_callchain_entry *entry)
-{
-	int is_user;
-
-	if (!regs)
-		return;
-
-	is_user = user_mode(regs);
-
-	if (!is_user)
-		perf_callchain_kernel(regs, entry);
-
-	if (current->mm)
-		perf_callchain_user(regs, entry);
-}
-
-struct perf_callchain_entry *perf_callchain(struct pt_regs *regs)
+struct perf_callchain_entry *perf_callchain_buffer(void)
 {
-	struct perf_callchain_entry *entry;
-
 	if (perf_guest_cbs && perf_guest_cbs->is_in_guest()) {
 		/* TODO: We don't support guest os callchain now */
 		return NULL;
 	}
 
 	if (in_nmi())
-		entry = &__get_cpu_var(pmc_nmi_entry);
-	else
-		entry = &__get_cpu_var(pmc_irq_entry);
-
-	entry->nr = 0;
-
-	perf_do_callchain(regs, entry);
+		return &__get_cpu_var(perf_callchain_entry_nmi);
 
-	return entry;
+	return &__get_cpu_var(perf_callchain_entry);
 }
 
 unsigned long perf_instruction_pointer(struct pt_regs *regs)
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 3588804..4db61dd 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -976,7 +976,15 @@ extern int perf_unregister_guest_info_callbacks(struct perf_guest_info_callbacks
 extern void perf_event_comm(struct task_struct *tsk);
 extern void perf_event_fork(struct task_struct *tsk);
 
-extern struct perf_callchain_entry *perf_callchain(struct pt_regs *regs);
+/* Callchains */
+DECLARE_PER_CPU(struct perf_callchain_entry, perf_callchain_entry);
+
+extern void perf_callchain_user(struct perf_callchain_entry *entry,
+				struct pt_regs *regs);
+extern void perf_callchain_kernel(struct perf_callchain_entry *entry,
+				  struct pt_regs *regs);
+extern struct perf_callchain_entry *perf_callchain_buffer(void);
+
 
 static inline void
 perf_callchain_store(struct perf_callchain_entry *entry, u64 ip)
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index c772a3d..02efde6 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -2937,13 +2937,49 @@ void perf_event_do_pending(void)
 	__perf_pending_run();
 }
 
+DEFINE_PER_CPU(struct perf_callchain_entry, perf_callchain_entry);
+
 /*
  * Callchain support -- arch specific
  */
 
-__weak struct perf_callchain_entry *perf_callchain(struct pt_regs *regs)
+__weak struct perf_callchain_entry *perf_callchain_buffer(void)
 {
-	return NULL;
+	return &__get_cpu_var(perf_callchain_entry);
+}
+
+__weak void perf_callchain_kernel(struct perf_callchain_entry *entry,
+				  struct pt_regs *regs)
+{
+}
+
+__weak void perf_callchain_user(struct perf_callchain_entry *entry,
+				struct pt_regs *regs)
+{
+}
+
+static struct perf_callchain_entry *perf_callchain(struct pt_regs *regs)
+{
+	struct perf_callchain_entry *entry;
+
+	entry = perf_callchain_buffer();
+	if (!entry)
+		return NULL;
+
+	entry->nr = 0;
+
+	if (!user_mode(regs)) {
+		perf_callchain_kernel(entry, regs);
+		if (current->mm)
+			regs = task_pt_regs(current);
+		else
+			regs = NULL;
+	}
+
+	if (regs)
+		perf_callchain_user(entry, regs);
+
+	return entry;
 }
 
 
-- 
1.6.2.3

