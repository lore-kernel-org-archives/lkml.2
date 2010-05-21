Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758216Ab0EUILX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 04:11:23 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:51412 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758162Ab0EUILR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 04:11:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=Zy27Ikit1n2wSA5PaREoDBwDeCuSjoi9QyYyoobN9VGZcjfnpddkC0dKaroJj2SCuU
         2jIOkn7l0/WDbm/OLKr1XStX2v/8A/L0jauEd8jYCnKns6Pg8amgqYK/bdn5cYUGmWRx
         6k/wnb0UBQ/EP0iCV/YJoMBzWTSXOiyEvF3uE=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       David Miller <davem@davemloft.net>
Subject: [PATCH 2/2] perf: Drop the skip argument from perf_arch_fetch_regs_caller
Date: Fri, 21 May 2010 10:11:17 +0200
Message-Id: <1274429477-21531-3-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1274429477-21531-1-git-send-regression-fweisbec@gmail.com>
References: <1274429477-21531-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drop this argument now that we always want to rewind only to the
state of the first caller.
It means frame pointers are not necessary anymore to reliably get
the source of an event. But this also means we need this helper
to be a macro now, as an inline function is not an option since
we need to know when to provide a default implentation.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: David Miller <davem@davemloft.net>
---
 arch/powerpc/include/asm/perf_event.h |   12 ++++++++++++
 arch/powerpc/kernel/misc.S            |   26 --------------------------
 arch/sparc/include/asm/perf_event.h   |    4 ++++
 arch/sparc/kernel/helpers.S           |    6 +++---
 arch/x86/include/asm/perf_event.h     |    9 +++++++++
 arch/x86/include/asm/stacktrace.h     |    7 ++-----
 arch/x86/kernel/cpu/perf_event.c      |   12 ------------
 include/linux/perf_event.h            |   32 +++++++-------------------------
 include/trace/ftrace.h                |    2 +-
 kernel/perf_event.c                   |    5 -----
 kernel/trace/trace_event_perf.c       |    2 --
 11 files changed, 38 insertions(+), 79 deletions(-)

diff --git a/arch/powerpc/include/asm/perf_event.h b/arch/powerpc/include/asm/perf_event.h
index e6d4ce6..5c16b89 100644
--- a/arch/powerpc/include/asm/perf_event.h
+++ b/arch/powerpc/include/asm/perf_event.h
@@ -21,3 +21,15 @@
 #ifdef CONFIG_FSL_EMB_PERF_EVENT
 #include <asm/perf_event_fsl_emb.h>
 #endif
+
+#ifdef CONFIG_PERF_EVENTS
+#include <asm/ptrace.h>
+#include <asm/reg.h>
+
+#define perf_arch_fetch_caller_regs(regs, __ip)			\
+	do {							\
+		(regs)->nip = __ip;				\
+		(regs)->gpr[1] = *(unsigned long *)__get_SP();	\
+		asm volatile("mfmsr %0" : "=r" ((regs)->msr));	\
+	} while (0)
+#endif
diff --git a/arch/powerpc/kernel/misc.S b/arch/powerpc/kernel/misc.S
index 22e507c..2d29752 100644
--- a/arch/powerpc/kernel/misc.S
+++ b/arch/powerpc/kernel/misc.S
@@ -127,29 +127,3 @@ _GLOBAL(__setup_cpu_power7)
 _GLOBAL(__restore_cpu_power7)
 	/* place holder */
 	blr
-
-/*
- * Get a minimal set of registers for our caller's nth caller.
- * r3 = regs pointer, r5 = n.
- *
- * We only get R1 (stack pointer), NIP (next instruction pointer)
- * and LR (link register).  These are all we can get in the
- * general case without doing complicated stack unwinding, but
- * fortunately they are enough to do a stack backtrace, which
- * is all we need them for.
- */
-_GLOBAL(perf_arch_fetch_caller_regs)
-	mr	r6,r1
-	cmpwi	r5,0
-	mflr	r4
-	ble	2f
-	mtctr	r5
-1:	PPC_LL	r6,0(r6)
-	bdnz	1b
-	PPC_LL	r4,PPC_LR_STKOFF(r6)
-2:	PPC_LL	r7,0(r6)
-	PPC_LL	r7,PPC_LR_STKOFF(r7)
-	PPC_STL	r6,GPR1-STACK_FRAME_OVERHEAD(r3)
-	PPC_STL	r4,_NIP-STACK_FRAME_OVERHEAD(r3)
-	PPC_STL	r7,_LINK-STACK_FRAME_OVERHEAD(r3)
-	blr
diff --git a/arch/sparc/include/asm/perf_event.h b/arch/sparc/include/asm/perf_event.h
index 7e26698..7e7d4de 100644
--- a/arch/sparc/include/asm/perf_event.h
+++ b/arch/sparc/include/asm/perf_event.h
@@ -7,6 +7,10 @@ extern void set_perf_event_pending(void);
 
 #ifdef CONFIG_PERF_EVENTS
 extern void init_hw_perf_events(void);
+
+#define perf_arch_fetch_caller_regs(pt_regs, ip)	\
+	__perf_arch_fetch_caller_regs(pt_regs, ip, 1);
+#endif
 #else
 static inline void init_hw_perf_events(void)	{ }
 #endif
diff --git a/arch/sparc/kernel/helpers.S b/arch/sparc/kernel/helpers.S
index 92090cc..682fee0 100644
--- a/arch/sparc/kernel/helpers.S
+++ b/arch/sparc/kernel/helpers.S
@@ -47,9 +47,9 @@ stack_trace_flush:
 	.size		stack_trace_flush,.-stack_trace_flush
 
 #ifdef CONFIG_PERF_EVENTS
-	.globl		perf_arch_fetch_caller_regs
-	.type		perf_arch_fetch_caller_regs,#function
-perf_arch_fetch_caller_regs:
+	.globl		__perf_arch_fetch_caller_regs
+	.type		__perf_arch_fetch_caller_regs,#function
+__perf_arch_fetch_caller_regs:
 	/* We always read the %pstate into %o5 since we will use
 	 * that to construct a fake %tstate to store into the regs.
 	 */
diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 254883d..ea871a5 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -140,6 +140,15 @@ extern unsigned long perf_instruction_pointer(struct pt_regs *regs);
 extern unsigned long perf_misc_flags(struct pt_regs *regs);
 #define perf_misc_flags(regs)	perf_misc_flags(regs)
 
+#include <asm/stacktrace.h>
+
+#define perf_arch_fetch_caller_regs(regs, __ip)		{	\
+	(regs)->ip = (__ip);					\
+	(regs)->bp = caller_frame_pointer();			\
+	(regs)->cs = __KERNEL_CS;				\
+	local_save_flags((regs)->flags);			\
+}
+
 #else
 static inline void init_hw_perf_events(void)		{ }
 static inline void perf_events_lapic_init(void)	{ }
diff --git a/arch/x86/include/asm/stacktrace.h b/arch/x86/include/asm/stacktrace.h
index a957463..2b16a2a 100644
--- a/arch/x86/include/asm/stacktrace.h
+++ b/arch/x86/include/asm/stacktrace.h
@@ -78,17 +78,14 @@ struct stack_frame_ia32 {
     u32 return_address;
 };
 
-static inline unsigned long rewind_frame_pointer(int n)
+static inline unsigned long caller_frame_pointer(void)
 {
 	struct stack_frame *frame;
 
 	get_bp(frame);
 
 #ifdef CONFIG_FRAME_POINTER
-	while (n--) {
-		if (probe_kernel_address(&frame->next_frame, frame))
-			break;
-	}
+	frame = frame->next_frame;
 #endif
 
 	return (unsigned long)frame;
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 2ae6112..2c075fe 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1706,18 +1706,6 @@ struct perf_callchain_entry *perf_callchain(struct pt_regs *regs)
 	return entry;
 }
 
-void perf_arch_fetch_caller_regs(struct pt_regs *regs, unsigned long ip, int skip)
-{
-	regs->ip = ip;
-	/*
-	 * perf_arch_fetch_caller_regs adds another call, we need to increment
-	 * the skip level
-	 */
-	regs->bp = rewind_frame_pointer(skip + 1);
-	regs->cs = __KERNEL_CS;
-	local_save_flags(regs->flags);
-}
-
 unsigned long perf_instruction_pointer(struct pt_regs *regs)
 {
 	unsigned long ip;
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index fe50347..49d441e 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -903,8 +903,10 @@ extern atomic_t perf_swevent_enabled[PERF_COUNT_SW_MAX];
 
 extern void __perf_sw_event(u32, u64, int, struct pt_regs *, u64);
 
-extern void
-perf_arch_fetch_caller_regs(struct pt_regs *regs, unsigned long ip, int skip);
+#ifndef perf_arch_fetch_caller_regs
+static inline void
+perf_arch_fetch_caller_regs(struct regs *regs, unsigned long ip) { }
+#endif
 
 /*
  * Take a snapshot of the regs. Skip ip and frame pointer to
@@ -914,31 +916,11 @@ perf_arch_fetch_caller_regs(struct pt_regs *regs, unsigned long ip, int skip);
  * - bp for callchains
  * - eflags, for future purposes, just in case
  */
-static inline void perf_fetch_caller_regs(struct pt_regs *regs, int skip)
+static inline void perf_fetch_caller_regs(struct pt_regs *regs)
 {
-	unsigned long ip;
-
 	memset(regs, 0, sizeof(*regs));
 
-	switch (skip) {
-	case 1 :
-		ip = CALLER_ADDR0;
-		break;
-	case 2 :
-		ip = CALLER_ADDR1;
-		break;
-	case 3 :
-		ip = CALLER_ADDR2;
-		break;
-	case 4:
-		ip = CALLER_ADDR3;
-		break;
-	/* No need to support further for now */
-	default:
-		ip = 0;
-	}
-
-	return perf_arch_fetch_caller_regs(regs, ip, skip);
+	perf_arch_fetch_caller_regs(regs, CALLER_ADDR0);
 }
 
 static inline void
@@ -948,7 +930,7 @@ perf_sw_event(u32 event_id, u64 nr, int nmi, struct pt_regs *regs, u64 addr)
 		struct pt_regs hot_regs;
 
 		if (!regs) {
-			perf_fetch_caller_regs(&hot_regs, 1);
+			perf_fetch_caller_regs(&hot_regs);
 			regs = &hot_regs;
 		}
 		__perf_sw_event(event_id, nr, nmi, regs, addr);
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 1016b21..976cc09 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -801,7 +801,7 @@ static notrace void perf_trace_##call(proto)				\
 	struct ftrace_event_call *event_call = &event_##call;		\
 	struct pt_regs *__regs = &get_cpu_var(perf_trace_regs);		\
 									\
-	perf_fetch_caller_regs(__regs, 1);				\
+	perf_fetch_caller_regs(__regs);					\
 									\
 	perf_trace_templ_##template(event_call, __regs, args);		\
 									\
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 45b7aec..77387fa 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -2842,11 +2842,6 @@ __weak struct perf_callchain_entry *perf_callchain(struct pt_regs *regs)
 	return NULL;
 }
 
-__weak
-void perf_arch_fetch_caller_regs(struct pt_regs *regs, unsigned long ip, int skip)
-{
-}
-
 
 /*
  * We assume there is only KVM supporting the callbacks.
diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index 89b780a..924bab2 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -12,8 +12,6 @@
 DEFINE_PER_CPU(struct pt_regs, perf_trace_regs);
 EXPORT_PER_CPU_SYMBOL_GPL(perf_trace_regs);
 
-EXPORT_SYMBOL_GPL(perf_arch_fetch_caller_regs);
-
 static char *perf_trace_buf;
 static char *perf_trace_buf_nmi;
 
-- 
1.6.2.3

