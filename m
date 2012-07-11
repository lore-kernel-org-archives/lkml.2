Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933177Ab2GKT5t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 15:57:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14164 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933138Ab2GKT5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 15:57:47 -0400
X-Authority-Analysis: v=2.0 cv=StQSGYy0 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=HjMDWSI4d1IA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=WX7KA47Jz1oKHXR-l54A:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120711195745.813990644@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Jul 2012 15:50:52 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [RFC][PATCH 4/4 v4] ftrace/x86_64: Add recursion protection inside mcount caller
References: <20120711195048.885039013@goodmis.org>
Content-Disposition: inline; filename=0004-ftrace-x86_64-Add-recursion-protection-inside-mcount.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

As more users of function tracing is occurring (perf, kprobes, etc)
there's more chances that the users do not sufficiently protect against
recursion. As it is simple to protect against it either at the mcount
call site, or by the "list function", an arch can now add protection
inside the mcount trampoline and define ARCH_SUPPORTS_FTRACE_RECURSION.

If ARCH_SUPPORTS_FTRACE_RECURSION is not defined by the arch (inside
the asm/ftrace.h), the FTRACE_FORCE_LIST_FUNC is set to 1, which will
always enable the list function (the function used to call
multiple function trace callbacks when more than one is register)
even if there's only one function register. This is because the list
function provides all the required features (like recursion protection)
for function tracing. If the arch does not support all features, the
list function is used to make sure they are supported.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/include/asm/ftrace.h |    2 ++
 arch/x86/kernel/entry_32.S    |   28 ++++++++++++++++++++++++++--
 arch/x86/kernel/entry_64.S    |   30 +++++++++++++++++++++++++++---
 arch/x86/kernel/ftrace.c      |    7 +++++--
 include/linux/ftrace.h        |    2 +-
 5 files changed, 61 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
index a6cae0c..fdaee7c 100644
--- a/arch/x86/include/asm/ftrace.h
+++ b/arch/x86/include/asm/ftrace.h
@@ -43,6 +43,8 @@
 #define ARCH_SUPPORTS_FTRACE_SAVE_REGS
 #endif
 
+#define ARCH_SUPPORTS_FTRACE_RECURSION
+
 #ifndef __ASSEMBLY__
 extern void mcount(void);
 extern atomic_t modifying_ftrace_code;
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 9019806..f61a15c 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -1106,6 +1106,12 @@ ENTRY(ftrace_caller)
 	cmpl $0, function_trace_stop
 	jne  ftrace_stub
 
+	/* Check for recursion */
+	cmpl $0, PER_CPU_VAR(ftrace_recursion)
+	jne  ftrace_stub
+
+	movl $1, PER_CPU_VAR(ftrace_recursion)
+
 	pushl %eax
 	pushl %ecx
 	pushl %edx
@@ -1127,8 +1133,11 @@ ftrace_ret:
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 .globl ftrace_graph_call
 ftrace_graph_call:
-	jmp ftrace_stub
+	jmp ftrace_graph_finish
+.globl ftrace_graph_finish
+ftrace_graph_finish:
 #endif
+	movl $0, PER_CPU_VAR(ftrace_recursion)
 
 .globl ftrace_stub
 ftrace_stub:
@@ -1140,6 +1149,12 @@ ENTRY(ftrace_regs_caller)
 	cmpl $0, function_trace_stop
 	jne ftrace_restore_flags
 
+	/* Check for recursion */
+	cmpl $0, PER_CPU_VAR(ftrace_recursion)
+	jne  ftrace_restore_flags
+
+	movl $1, PER_CPU_VAR(ftrace_recursion)
+
 	pushl %esp	/* Save stack in sp location */
 	subl $4, (%esp) /* Adjust saved stack to skip saved flags */
 	pushl 4(%esp)	/* Save flags in correct position */
@@ -1198,6 +1213,12 @@ ENTRY(mcount)
 	cmpl $0, function_trace_stop
 	jne  ftrace_stub
 
+	/* Check for recursion */
+	cmpl $0, PER_CPU_VAR(ftrace_recursion)
+	jne  ftrace_stub
+
+	movl $1, PER_CPU_VAR(ftrace_recursion)
+
 	cmpl $ftrace_stub, ftrace_trace_function
 	jnz trace
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
@@ -1206,7 +1227,10 @@ ENTRY(mcount)
 
 	cmpl $ftrace_graph_entry_stub, ftrace_graph_entry
 	jnz ftrace_graph_caller
+ftrace_graph_finish:
 #endif
+	movl $0, PER_CPU_VAR(ftrace_recursion)
+
 .globl ftrace_stub
 ftrace_stub:
 	ret
@@ -1243,7 +1267,7 @@ ENTRY(ftrace_graph_caller)
 	popl %edx
 	popl %ecx
 	popl %eax
-	ret
+	jmp ftrace_graph_finish
 END(ftrace_graph_caller)
 
 .globl return_to_handler
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 38308fa..7b6d14b 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -77,6 +77,8 @@ END(mcount)
 .macro ftrace_caller_setup skip=0
 	MCOUNT_SAVE_FRAME \skip
 
+	movl $1, PER_CPU_VAR(ftrace_recursion)
+
 	/* Load the ftrace_ops into the 3rd parameter */
 	leaq function_trace_op, %rdx
 
@@ -92,6 +94,10 @@ ENTRY(ftrace_caller)
 	cmpl $0, function_trace_stop
 	jne  ftrace_stub
 
+	/* Check for recursion */
+	cmpl $0, PER_CPU_VAR(ftrace_recursion)
+	jne  ftrace_stub
+
 	ftrace_caller_setup
 	/* regs go into 4th parameter (but make it NULL) */
 	movq $0, %rcx
@@ -104,9 +110,12 @@ ftrace_return:
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 GLOBAL(ftrace_graph_call)
-	jmp ftrace_stub
+	jmp ftrace_graph_finish
+GLOBAL(ftrace_graph_finish)
 #endif
 
+	movl $0, PER_CPU_VAR(ftrace_recursion)
+
 GLOBAL(ftrace_stub)
 	retq
 END(ftrace_caller)
@@ -119,6 +128,10 @@ ENTRY(ftrace_regs_caller)
 	cmpl $0, function_trace_stop
 	jne  ftrace_restore_flags
 
+	/* Check for recursion */
+	cmpl $0, PER_CPU_VAR(ftrace_recursion)
+	jne  ftrace_restore_flags
+
 	/* skip=8 to skip flags saved in SS */
 	ftrace_caller_setup 8
 
@@ -181,17 +194,28 @@ ENTRY(mcount)
 	cmpl $0, function_trace_stop
 	jne  ftrace_stub
 
+	/* Check for recursion */
+	cmpl $0, PER_CPU_VAR(ftrace_recursion)
+	jne  ftrace_stub
+
+	movl $1, PER_CPU_VAR(ftrace_recursion)
+
 	cmpq $ftrace_stub, ftrace_trace_function
 	jnz trace
 
+ftrace_return:
+
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 	cmpq $ftrace_stub, ftrace_graph_return
 	jnz ftrace_graph_caller
 
 	cmpq $ftrace_graph_entry_stub, ftrace_graph_entry
 	jnz ftrace_graph_caller
+ftrace_graph_finish:
 #endif
 
+	movl $0, PER_CPU_VAR(ftrace_recursion)
+
 GLOBAL(ftrace_stub)
 	retq
 
@@ -206,7 +230,7 @@ trace:
 
 	MCOUNT_RESTORE_FRAME
 
-	jmp ftrace_stub
+	jmp ftrace_return
 END(mcount)
 #endif /* CONFIG_DYNAMIC_FTRACE */
 #endif /* CONFIG_FUNCTION_TRACER */
@@ -224,7 +248,7 @@ ENTRY(ftrace_graph_caller)
 
 	MCOUNT_RESTORE_FRAME
 
-	retq
+	jmp ftrace_graph_finish
 END(ftrace_graph_caller)
 
 GLOBAL(return_to_handler)
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 1d41402..28807ff 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -28,6 +28,8 @@
 #include <asm/ftrace.h>
 #include <asm/nops.h>
 
+DEFINE_PER_CPU(int, ftrace_recursion);
+
 #ifdef CONFIG_DYNAMIC_FTRACE
 
 int ftrace_arch_code_modify_prepare(void)
@@ -664,6 +666,7 @@ int __init ftrace_dyn_arch_init(void *data)
 
 #ifdef CONFIG_DYNAMIC_FTRACE
 extern void ftrace_graph_call(void);
+extern void ftrace_graph_finish(void);
 
 static int ftrace_mod_jmp(unsigned long ip,
 			  int old_offset, int new_offset)
@@ -689,7 +692,7 @@ int ftrace_enable_ftrace_graph_caller(void)
 	unsigned long ip = (unsigned long)(&ftrace_graph_call);
 	int old_offset, new_offset;
 
-	old_offset = (unsigned long)(&ftrace_stub) - (ip + MCOUNT_INSN_SIZE);
+	old_offset = (unsigned long)(&ftrace_graph_finish) - (ip + MCOUNT_INSN_SIZE);
 	new_offset = (unsigned long)(&ftrace_graph_caller) - (ip + MCOUNT_INSN_SIZE);
 
 	return ftrace_mod_jmp(ip, old_offset, new_offset);
@@ -701,7 +704,7 @@ int ftrace_disable_ftrace_graph_caller(void)
 	int old_offset, new_offset;
 
 	old_offset = (unsigned long)(&ftrace_graph_caller) - (ip + MCOUNT_INSN_SIZE);
-	new_offset = (unsigned long)(&ftrace_stub) - (ip + MCOUNT_INSN_SIZE);
+	new_offset = (unsigned long)(&ftrace_graph_finish) - (ip + MCOUNT_INSN_SIZE);
 
 	return ftrace_mod_jmp(ip, old_offset, new_offset);
 }
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index ab39990..087bdd5 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -34,7 +34,7 @@
  * does. Or at least does enough to prevent any unwelcomed side effects.
  */
 #if !defined(CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST) || \
-	!ARCH_SUPPORTS_FTRACE_OPS
+	!ARCH_SUPPORTS_FTRACE_OPS || !defined(ARCH_SUPPORTS_FTRACE_RECURSION)
 # define FTRACE_FORCE_LIST_FUNC 1
 #else
 # define FTRACE_FORCE_LIST_FUNC 0
-- 
1.7.10


