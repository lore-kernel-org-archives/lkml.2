Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784Ab0CZBx2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 21:53:28 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:44324 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753577Ab0CZBxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 21:53:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=I2ZtdoEC69DwCZVUVeeOSxLnj1SVPkSbFerAPaAZrmtkD/Cjvn+QW6QliGaMnxcprn
         3WezsGBkYgvC7JYctksYjilprevRuj8CG+iLHGIYQtUxuoJD5sLoA0KUZtiPVTRuDDAI
         b9AUGlsp+rkp3LdBRUy90wyE49uf6WisjRGxk=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>, Archs <linux-arch@vger.kernel.org>
Subject: [PATCH 5/7] perf: Make perf_fetch_caller_regs rewind to the first caller only
Date: Fri, 26 Mar 2010 02:52:40 +0100
Message-Id: <1269568362-13690-6-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1269568362-13690-1-git-send-regression-fweisbec@gmail.com>
References: <1269568362-13690-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trace events now only need to rewind the regs to the immediate
caller, so we don't need anymore to implement the support for
further stack walking.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: David Miller <davem@davemloft.net>
Cc: Archs <linux-arch@vger.kernel.org>
---
 arch/x86/include/asm/perf_event.h |    6 +++---
 arch/x86/include/asm/stacktrace.h |    5 ++---
 include/linux/perf_event.h        |   30 +++++-------------------------
 include/trace/ftrace.h            |    2 +-
 4 files changed, 11 insertions(+), 32 deletions(-)

diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 4bf3d37..1df2317 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -157,9 +157,9 @@ extern void perf_events_lapic_init(void);
 
 #include <asm/stacktrace.h>
 
-#define perf_arch_fetch_caller_regs(regs, ip, skip)	\
-	(regs)->ip = ip;				\
-	(regs)->bp = rewind_frame_pointer(skip);	\
+#define perf_arch_fetch_caller_regs(regs, __ip)		\
+	(regs)->ip = __ip;				\
+	(regs)->bp = caller_frame_pointer();		\
 	(regs)->cs = __KERNEL_CS;			\
 	local_save_flags((regs)->flags);
 
diff --git a/arch/x86/include/asm/stacktrace.h b/arch/x86/include/asm/stacktrace.h
index 8fb70b7..62c9897 100644
--- a/arch/x86/include/asm/stacktrace.h
+++ b/arch/x86/include/asm/stacktrace.h
@@ -74,15 +74,14 @@ struct stack_frame {
 	unsigned long return_address;
 };
 
-static inline unsigned long rewind_frame_pointer(int n)
+static inline unsigned long caller_frame_pointer(void)
 {
 	struct stack_frame *frame;
 
 	get_bp(frame);
 
 #ifdef CONFIG_FRAME_POINTER
-	while (n--)
-		frame = frame->next_frame;
+	frame = frame->next_frame;
 #endif
 
 	return (unsigned long)frame;
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 76b680f..3b59cf7 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -869,42 +869,22 @@ perf_sw_event(u32 event_id, u64 nr, int nmi, struct pt_regs *regs, u64 addr)
 
 #ifndef perf_arch_fetch_caller_regs
 static inline void
-perf_arch_fetch_caller_regs(struct pt_regs *regs, unsigned long ip, int skip){ }
+perf_arch_fetch_caller_regs(struct pt_regs *regs, unsigned long ip) { }
 #endif
 
 /*
- * Take a snapshot of the regs. Skip ip and frame pointer to
- * the nth caller. We only need a few of the regs:
+ * Take a snapshot of the regs. Rewind ip and frame pointer to
+ * the caller. We only need a few of the regs:
  * - ip for PERF_SAMPLE_IP
  * - cs for user_mode() tests
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
-	perf_arch_fetch_caller_regs(regs, ip, skip);
+	perf_arch_fetch_caller_regs(regs, CALLER_ADDR0);
 }
 
 extern void __perf_event_mmap(struct vm_area_struct *vma);
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 882c648..82e9977 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -795,7 +795,7 @@ static notrace void perf_trace_##call(proto)				\
 	struct ftrace_event_call *event_call = &event_##call;		\
 	struct pt_regs *__regs = &get_cpu_var(perf_trace_regs);		\
 									\
-	perf_fetch_caller_regs(__regs, 1);				\
+	perf_fetch_caller_regs(__regs);					\
 									\
 	perf_trace_templ_##template(event_call, __regs, args);		\
 									\
-- 
1.6.2.3

