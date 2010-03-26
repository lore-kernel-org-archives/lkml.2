Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753765Ab0CZBxZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 21:53:25 -0400
Received: from mail-px0-f194.google.com ([209.85.216.194]:39839 "EHLO
	mail-px0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753540Ab0CZBxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 21:53:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=EnCRRrZOvALBl7a+yWm6sEkpR9AbL3/VExFV8obnadyvtjVo+RTJzQiuw6ReFK9kRT
         +mF+SvquZPfoDkV0qaCxUBaVIDhn5keVPed/tLaVhb4/bO7r1nKicKQj05iKjR/z1JaW
         Wb/QRufp8gycaHXMNg51a2zJi2Vt7eybLucnE=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>, Archs <linux-arch@vger.kernel.org>
Subject: [PATCH 4/7] perf: Move perf_arch_fetch_caller_regs into a macro
Date: Fri, 26 Mar 2010 02:52:39 +0100
Message-Id: <1269568362-13690-5-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1269568362-13690-1-git-send-regression-fweisbec@gmail.com>
References: <1269568362-13690-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Having perf_arch_fetch_caller_regs() as a weak function overridable
by macros makes it hard to export its symbol for modules, as we
need to export the symbol in another file than the generic weak
definition to deal with compiler bugs.

Currently it's not a problem because we can define the symbol in
trace_event_perf.c as only trace events use it. But we are going
to make some generic software events to use this new facility,
so the symbol must be available even if trace events are not built.

This patch fixes the problem by making perf_arch_fetch_caller_regs
a macro that archs can define in their <asm/perf_event.h>

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: David Miller <davem@davemloft.net>
Cc: Archs <linux-arch@vger.kernel.org>
---
 arch/x86/include/asm/perf_event.h |   10 +++++++++-
 arch/x86/kernel/cpu/perf_event.c  |   13 -------------
 include/linux/perf_event.h        |    8 +++++---
 kernel/perf_event.c               |    7 -------
 kernel/trace/trace_event_perf.c   |    2 --
 5 files changed, 14 insertions(+), 26 deletions(-)

diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 124dddd..4bf3d37 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -155,7 +155,15 @@ extern void perf_events_lapic_init(void);
 
 #define perf_instruction_pointer(regs)	((regs)->ip)
 
-#else
+#include <asm/stacktrace.h>
+
+#define perf_arch_fetch_caller_regs(regs, ip, skip)	\
+	(regs)->ip = ip;				\
+	(regs)->bp = rewind_frame_pointer(skip);	\
+	(regs)->cs = __KERNEL_CS;			\
+	local_save_flags((regs)->flags);
+
+#else /* !CONFIG_PERF_EVENTS */
 static inline void init_hw_perf_events(void)		{ }
 static inline void perf_events_lapic_init(void)	{ }
 #endif
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index c3f203e..43fae02 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1691,16 +1691,3 @@ struct perf_callchain_entry *perf_callchain(struct pt_regs *regs)
 	return entry;
 }
 
-#ifdef CONFIG_EVENT_TRACING
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
-#endif
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 2bccb7b..76b680f 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -867,8 +867,10 @@ perf_sw_event(u32 event_id, u64 nr, int nmi, struct pt_regs *regs, u64 addr)
 		__perf_sw_event(event_id, nr, nmi, regs, addr);
 }
 
-extern void
-perf_arch_fetch_caller_regs(struct pt_regs *regs, unsigned long ip, int skip);
+#ifndef perf_arch_fetch_caller_regs
+static inline void
+perf_arch_fetch_caller_regs(struct pt_regs *regs, unsigned long ip, int skip){ }
+#endif
 
 /*
  * Take a snapshot of the regs. Skip ip and frame pointer to
@@ -902,7 +904,7 @@ static inline void perf_fetch_caller_regs(struct pt_regs *regs, int skip)
 		ip = 0;
 	}
 
-	return perf_arch_fetch_caller_regs(regs, ip, skip);
+	perf_arch_fetch_caller_regs(regs, ip, skip);
 }
 
 extern void __perf_event_mmap(struct vm_area_struct *vma);
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 455393e..bbed6f0 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -2790,13 +2790,6 @@ __weak struct perf_callchain_entry *perf_callchain(struct pt_regs *regs)
 	return NULL;
 }
 
-#ifdef CONFIG_EVENT_TRACING
-__weak
-void perf_arch_fetch_caller_regs(struct pt_regs *regs, unsigned long ip, int skip)
-{
-}
-#endif
-
 /*
  * Output
  */
diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index 81f691e..8e9edcd 100644
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

