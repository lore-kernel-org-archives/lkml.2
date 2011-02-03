Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932292Ab1BCPnS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 10:43:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9663 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932249Ab1BCPnL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 10:43:11 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: mingo@elte.hu, rostedt@goodmis.org, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, masami.hiramatsu.pt@hitachi.com
Subject: [PATCH 4/4] ktrace - function graph trace support
Date: Thu,  3 Feb 2011 16:42:41 +0100
Message-Id: <1296747761-9082-5-git-send-email-jolsa@redhat.com>
In-Reply-To: <1296747761-9082-1-git-send-email-jolsa@redhat.com>
References: <1296747761-9082-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

adding function graph support

wbr,
jirka
---
 arch/x86/Kconfig           |    2 +-
 arch/x86/kernel/entry_64.S |   27 +++++++++++++++++++++++++++
 kernel/trace/ftrace.c      |   10 ++++++++++
 3 files changed, 38 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index a02718c..befe1e0 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -36,7 +36,7 @@ config X86
 	select HAVE_DYNAMIC_FTRACE
 	select HAVE_FUNCTION_TRACER
 	select HAVE_FUNCTION_GRAPH_TRACER
-	select HAVE_FUNCTION_GRAPH_FP_TEST
+	select HAVE_FUNCTION_GRAPH_FP_TEST if !KTRACE
 	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
 	select HAVE_FTRACE_NMI_ENTER if DYNAMIC_FTRACE || KTRACE
 	select HAVE_SYSCALL_TRACEPOINTS
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 4d70019..ec9e234 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -69,6 +69,14 @@ ENTRY(ktrace_callback)
 
 	cmpq $ftrace_stub, ftrace_trace_function
 	jnz ktrace_trace
+
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+	cmpq $ftrace_stub, ftrace_graph_return
+	jnz ktrace_graph_caller
+
+	cmpq $ftrace_graph_entry_stub, ftrace_graph_entry
+	jnz ktrace_graph_caller
+#endif
 	retq
 
 ktrace_trace:
@@ -83,6 +91,25 @@ ktrace_trace:
 
 	retq
 END(ktrace_callback)
+
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+ENTRY(ktrace_graph_caller)
+	cmpl $0, function_trace_stop
+	jne ftrace_stub
+
+	MCOUNT_SAVE_FRAME
+
+	leaq 0x50(%rsp), %rdi
+	movq 0x48(%rsp), %rsi
+	movq $0, %rdx
+
+	call	prepare_ftrace_return
+
+	MCOUNT_RESTORE_FRAME
+
+	retq
+END(ktrace_graph_caller)
+#endif /* CONFIG_FUNCTION_GRAPH_TRACER */
 #endif /* CONFIG_KTRACE */
 
 #ifdef CONFIG_DYNAMIC_FTRACE
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 762e2b3..f6e30a8 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3404,7 +3404,11 @@ int register_ftrace_graph(trace_func_graph_ret_t retfunc,
 	ftrace_graph_return = retfunc;
 	ftrace_graph_entry = entryfunc;
 
+#ifdef CONFIG_KTRACE
+	ktrace_startup();
+#else
 	ftrace_startup(FTRACE_START_FUNC_RET);
+#endif
 
 out:
 	mutex_unlock(&ftrace_lock);
@@ -3421,7 +3425,13 @@ void unregister_ftrace_graph(void)
 	ftrace_graph_active--;
 	ftrace_graph_return = (trace_func_graph_ret_t)ftrace_stub;
 	ftrace_graph_entry = ftrace_graph_entry_stub;
+
+#ifdef CONFIG_KTRACE
+	ktrace_shutdown();
+#else
 	ftrace_shutdown(FTRACE_STOP_FUNC_RET);
+#endif
+
 	unregister_pm_notifier(&ftrace_suspend_notifier);
 	unregister_trace_sched_switch(ftrace_graph_probe_sched_switch, NULL);
 
-- 
1.7.1

