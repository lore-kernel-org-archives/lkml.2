Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956Ab1CJW0J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 17:26:09 -0500
Received: from hera.kernel.org ([140.211.167.34]:60989 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752388Ab1CJW0H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 17:26:07 -0500
Date: Thu, 10 Mar 2011 22:25:44 GMT
From: tip-bot for Namhyung Kim <namhyung@gmail.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, acme@ghostprotocols.net,
        namhyung@gmail.com, robert.richter@amd.com, fweisbec@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        acme@ghostprotocols.net, namhyung@gmail.com, robert.richter@amd.com,
        fweisbec@gmail.com, tglx@linutronix.de
In-Reply-To: <1299584662-24421-3-git-send-email-namhyung@gmail.com>
References: <1299584662-24421-3-git-send-email-namhyung@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] x86, dumpstack: Rename print_context_stack and friends
Message-ID: <tip-27f30f3e462f84e0a7c561d80e08d428e566db5e@git.kernel.org>
Git-Commit-ID: 27f30f3e462f84e0a7c561d80e08d428e566db5e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 10 Mar 2011 22:25:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  27f30f3e462f84e0a7c561d80e08d428e566db5e
Gitweb:     http://git.kernel.org/tip/27f30f3e462f84e0a7c561d80e08d428e566db5e
Author:     Namhyung Kim <namhyung@gmail.com>
AuthorDate: Tue, 8 Mar 2011 20:44:21 +0900
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 10 Mar 2011 23:20:30 +0100

x86, dumpstack: Rename print_context_stack and friends

print_context_stack* and print_ftrace_graph_addr are misnomers. They
don't print anything by themselves and call appropriate callback
routines. Actually save_stack_ops* use them just for saving return
addresses not for printing.

Rename them to walk_context_stack* will make more sense IMHO.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <1299584662-24421-3-git-send-email-namhyung@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/stacktrace.h |    4 ++--
 arch/x86/kernel/cpu/perf_event.c  |    2 +-
 arch/x86/kernel/dumpstack.c       |   18 +++++++++---------
 arch/x86/kernel/stacktrace.c      |    4 ++--
 arch/x86/oprofile/backtrace.c     |    2 +-
 5 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/stacktrace.h b/arch/x86/include/asm/stacktrace.h
index d7e89c8..73fc8e2 100644
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
index d19cdc2..9237e83 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1697,7 +1697,7 @@ static const struct stacktrace_ops backtrace_ops = {
 	.warning_symbol		= backtrace_warning_symbol,
 	.stack			= backtrace_stack,
 	.address		= backtrace_address,
-	.walk_stack		= print_context_stack_bp,
+	.walk_stack		= walk_context_stack_bp,
 };
 
 void
diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index c330160..38b74a5e 100644
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
index 6515733..2e44ee1 100644
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
index 72cbec1..f4b9fbb 100644
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
