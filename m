Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622Ab1CHLo6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 06:44:58 -0500
Received: from mail-gw0-f51.google.com ([74.125.83.51]:34472 "EHLO
	mail-gw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754574Ab1CHLo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 06:44:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=HyCQEAfHanwMAEcX58Fai9K91/+J2vtBuIba98/ySQui4sUNEY/TfATywlMsFkZxdB
         U/gVvSRtOqATp5vTxVrchqWlIxdXy0/YTLUkrzKVlp9pNZMIyA7cKSqWX3agGo1oBG1o
         rhlYSpc5GdL1Bbxk0nXS4XRJkhuAyFl0RR1nY=
From: Namhyung Kim <namhyung@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH v4 -tip 3/4] x86, dumpstack: Rename print_context_stack and friends
Date: Tue,  8 Mar 2011 20:44:21 +0900
Message-Id: <1299584662-24421-3-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1299584662-24421-1-git-send-email-namhyung@gmail.com>
References: <1299584662-24421-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

print_context_stack* and print_ftrace_graph_addr are misnomer.
They don't print anything by themselves and calls appropriate
callback routines. Actually save_stack_ops* use them just for
saving return addresses not for printing.

Rename them to walk_context_stack* will make more sense IMHO.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Robert Richter <robert.richter@amd.com>
---
 arch/x86/include/asm/stacktrace.h |    4 ++--
 arch/x86/kernel/cpu/perf_event.c  |    2 +-
 arch/x86/kernel/dumpstack.c       |   18 +++++++++---------
 arch/x86/kernel/stacktrace.c      |    4 ++--
 arch/x86/oprofile/backtrace.c     |    2 +-
 5 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/stacktrace.h b/arch/x86/include/asm/stacktrace.h
index d7e89c83645d..73fc8e2c4872 100644
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
index d19cdc2d602e..9237e83ccaa1 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1779,7 +1779,7 @@ static const struct stacktrace_ops backtrace_ops = {
 	.warning_symbol		= backtrace_warning_symbol,
 	.stack			= backtrace_stack,
 	.address		= backtrace_address,
-	.walk_stack		= print_context_stack_bp,
+	.walk_stack		= walk_context_stack_bp,
 };
 
 void
diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index c330160b6da3..38b74a5e59aba 100644
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
index 6515733a289d..2e44ee13637f 100644
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

