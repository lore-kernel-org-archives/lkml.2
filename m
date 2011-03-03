Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758051Ab1CCMmi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 07:42:38 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:52760 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753Ab1CCMmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 07:42:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=g1iBwCuQbeRxFvYTsWrRfPrsV9skHMKb/NCePjuPlNy3ulnjYqub9R6Ao2oM1B821b
         fKcN7klMp52C6UU++7It0ZIznJI1CRBdFHz4Eiyww1gAc9uZFH7TubH0otmhBehzoXGD
         pLvOk/mXWdv6lBbC4HygoRhBtXMx8TAm5BYgE=
From: Namhyung Kim <namhyung@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Robert Richter <robert.richter@amd.com>, oprofile-list@lists.sf.net
Subject: [PATCH/RFC -tip 1/2] x86, dumpstack: Rename print_context_stack and friends
Date: Thu,  3 Mar 2011 21:42:28 +0900
Message-Id: <1299156149-10929-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

print_context_stack* and print_ftrace_graph_addr are misnomer.
They don't print anything by themselves and calls appropriate
callback routines. Actually save_stack_ops* use them just for
saving retrun addresses not for printing.

Rename them to walk_context_stack* will make more sense IMHO.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Robert Richter <robert.richter@amd.com>
Cc: oprofile-list@lists.sf.net
---
 arch/x86/include/asm/stacktrace.h |    4 ++--
 arch/x86/kernel/cpu/perf_event.c  |    2 +-
 arch/x86/kernel/dumpstack.c       |   18 +++++++++---------
 arch/x86/kernel/stacktrace.c      |    4 ++--
 arch/x86/oprofile/backtrace.c     |    2 +-
 5 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/stacktrace.h b/arch/x86/include/asm/stacktrace.h
index 86146000a46d..33f82cb16336 100644
--- a/arch/x86/include/asm/stacktrace.h
+++ b/arch/x86/include/asm/stacktrace.h
@@ -23,13 +23,13 @@ typedef unsigned long (*walk_stack_t)(struct thread_info *tinfo,
 				      int *graph);
 
 extern unsigned long
-print_context_stack(struct thread_info *tinfo,
+walk_context_stack(struct thread_info *tinfo,
 		    unsigned long *stack, unsigned long bp,
 		    const struct stacktrace_ops *ops, void *data,
 		    unsigned long *end, int *graph);
 
 extern unsigned long
-print_context_stack_bp(struct thread_info *tinfo,
+walk_context_stack_bp(struct thread_info *tinfo,
 		       unsigned long *stack, unsigned long bp,
 		       const struct stacktrace_ops *ops, void *data,
 		       unsigned long *end, int *graph);
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 9d977a2ea693..7a1b88f26fdd 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1707,7 +1707,7 @@ static const struct stacktrace_ops backtrace_ops = {
 	.warning_symbol		= backtrace_warning_symbol,
 	.stack			= backtrace_stack,
 	.address		= backtrace_address,
-	.walk_stack		= print_context_stack_bp,
+	.walk_stack		= walk_context_stack_bp,
 };
 
 void
diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index df20723a6a1b..a613a5f9ee79 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -33,7 +33,7 @@ void printk_address(unsigned long address, int reliable)
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 static void
-print_ftrace_graph_addr(unsigned long addr, void *data,
+walk_ftrace_graph_addr(unsigned long addr, void *data,
 			const struct stacktrace_ops *ops,
 			struct thread_info *tinfo, int *graph)
 {
@@ -56,7 +56,7 @@ print_ftrace_graph_addr(unsigned long addr, void *data,
 }
 #else
 static inline void
-print_ftrace_graph_addr(unsigned long addr, void *data,
+walk_ftrace_graph_addr(unsigned long addr, void *data,
 			const struct stacktrace_ops *ops,
 			struct thread_info *tinfo, int *graph)
 { }
@@ -83,7 +83,7 @@ static inline int valid_stack_ptr(struct thread_info *tinfo,
 }
 
 unsigned long
-print_context_stack(struct thread_info *tinfo,
+walk_context_stack(struct thread_info *tinfo,
 		unsigned long *stack, unsigned long bp,
 		const struct stacktrace_ops *ops, void *data,
 		unsigned long *end, int *graph)
@@ -102,16 +102,16 @@ print_context_stack(struct thread_info *tinfo,
 			} else {
 				ops->address(data, addr, 0);
 			}
-			print_ftrace_graph_addr(addr, data, ops, tinfo, graph);
+			walk_ftrace_graph_addr(addr, data, ops, tinfo, graph);
 		}
 		stack++;
 	}
 	return bp;
 }
-EXPORT_SYMBOL_GPL(print_context_stack);
+EXPORT_SYMBOL_GPL(walk_context_stack);
 
 unsigned long
-print_context_stack_bp(struct thread_info *tinfo,
+walk_context_stack_bp(struct thread_info *tinfo,
 		       unsigned long *stack, unsigned long bp,
 		       const struct stacktrace_ops *ops, void *data,
 		       unsigned long *end, int *graph)
@@ -128,12 +128,12 @@ print_context_stack_bp(struct thread_info *tinfo,
 		ops->address(data, addr, 1);
 		frame = frame->next_frame;
 		ret_addr = &frame->return_address;
-		print_ftrace_graph_addr(addr, data, ops, tinfo, graph);
+		walk_ftrace_graph_addr(addr, data, ops, tinfo, graph);
 	}
 
 	return (unsigned long)frame;
 }
-EXPORT_SYMBOL_GPL(print_context_stack_bp);
+EXPORT_SYMBOL_GPL(walk_context_stack_bp);
 
 
 static void
@@ -170,7 +170,7 @@ static const struct stacktrace_ops print_trace_ops = {
 	.warning_symbol		= print_trace_warning_symbol,
 	.stack			= print_trace_stack,
 	.address		= print_trace_address,
-	.walk_stack		= print_context_stack,
+	.walk_stack		= walk_context_stack,
 };
 
 void
diff --git a/arch/x86/kernel/stacktrace.c b/arch/x86/kernel/stacktrace.c
index 938c8e10a19a..306305038333 100644
--- a/arch/x86/kernel/stacktrace.c
+++ b/arch/x86/kernel/stacktrace.c
@@ -57,7 +57,7 @@ static const struct stacktrace_ops save_stack_ops = {
 	.warning_symbol	= save_stack_warning_symbol,
 	.stack		= save_stack_stack,
 	.address	= save_stack_address,
-	.walk_stack	= print_context_stack,
+	.walk_stack	= walk_context_stack,
 };
 
 static const struct stacktrace_ops save_stack_ops_nosched = {
@@ -65,7 +65,7 @@ static const struct stacktrace_ops save_stack_ops_nosched = {
 	.warning_symbol	= save_stack_warning_symbol,
 	.stack		= save_stack_stack,
 	.address	= save_stack_address_nosched,
-	.walk_stack	= print_context_stack,
+	.walk_stack	= walk_context_stack,
 };
 
 /*
diff --git a/arch/x86/oprofile/backtrace.c b/arch/x86/oprofile/backtrace.c
index 72cbec14d783..f4b9fbb8de2b 100644
--- a/arch/x86/oprofile/backtrace.c
+++ b/arch/x86/oprofile/backtrace.c
@@ -46,7 +46,7 @@ static struct stacktrace_ops backtrace_ops = {
 	.warning_symbol	= backtrace_warning_symbol,
 	.stack		= backtrace_stack,
 	.address	= backtrace_address,
-	.walk_stack	= print_context_stack,
+	.walk_stack	= walk_context_stack,
 };
 
 #ifdef CONFIG_COMPAT
-- 
1.7.4

