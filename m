Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757245Ab1D2Ona (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 10:43:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23197 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756761Ab1D2OnX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 10:43:23 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: rostedt@goodmis.org, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: [RFC 2/3] tracing: adding statical callers
Date: Fri, 29 Apr 2011 16:43:13 +0200
Message-Id: <1304088194-6214-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1304088194-6214-1-git-send-email-jolsa@redhat.com>
References: <1304088194-6214-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

adding statically generated code for 'mcount callback' providing
unique bitmask

---
 arch/x86/include/asm/ftrace.h |    2 ++
 arch/x86/kernel/entry_64.S    |   22 +++++++++++++++++-----
 arch/x86/kernel/ftrace.c      |   13 +++++++++++++
 include/linux/ftrace.h        |    4 +---
 kernel/trace/ftrace.c         |    2 +-
 5 files changed, 34 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
index 45ae1fa..6ef436b 100644
--- a/arch/x86/include/asm/ftrace.h
+++ b/arch/x86/include/asm/ftrace.h
@@ -2,6 +2,7 @@
 #define _ASM_X86_FTRACE_H
 
 #define FTRACE_TRACERS_MAX 4
+#define FTRACE_CALLERS_MAX ((1 << FTRACE_TRACERS_MAX) - 1)
 
 #ifdef __ASSEMBLY__
 
@@ -36,6 +37,7 @@
 
 #ifndef __ASSEMBLY__
 extern void mcount(void);
+extern unsigned long ftrace_callers[FTRACE_CALLERS_MAX];
 
 static inline unsigned long ftrace_call_adjust(unsigned long addr)
 {
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index e0ba7d9..1ec1668 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -69,19 +69,31 @@ ENTRY(mcount)
 	retq
 END(mcount)
 
-ENTRY(ftrace_caller)
+	.section .rodata,"a"
+ENTRY(ftrace_callers)
+	.section .entry.text
+.macro FTRACE_GEN_CALLERS num
+i=1
+.rept (1 << \num) - 1
+1:
 	cmpl $0, function_trace_stop
 	jne  ftrace_stub
-
 	MCOUNT_SAVE_FRAME
+	movq $i, %rdx
+	jmp ftrace_caller
+	.previous
+	.quad 1b
+	.section .entry.text
+i=i+1
+.endr
+.endm
+	FTRACE_GEN_CALLERS FTRACE_TRACERS_MAX
 
+ENTRY(ftrace_caller)
 	movq 0x38(%rsp), %rdi
 	movq 8(%rbp), %rsi
 	subq $MCOUNT_INSN_SIZE, %rdi
 
-	/* by default call all registered handlers */
-	movq $-1, %rdx
-
 	call ftrace_call
 
 	MCOUNT_RESTORE_FRAME
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index dc92378..5a8e679 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -328,6 +328,19 @@ int __init ftrace_dyn_arch_init(void *data)
 
 	return 0;
 }
+
+unsigned long ftrace_arch_tracer_addr(int mask)
+{
+	if (!mask)
+		return 0L;
+
+	/* tracer 1 is index 0 in ftrace_callers */
+	--mask;
+
+	BUG_ON(mask >= FTRACE_CALLERS_MAX);
+	return ftrace_callers[mask];
+}
+
 #endif
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index b7ab09d..b12f5df 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -180,10 +180,8 @@ extern void ftrace_caller(void);
 extern void ftrace_call(unsigned long ip, unsigned long parent_ip,
 			unsigned long flags);
 extern void mcount_call(void);
+extern unsigned long ftrace_arch_tracer_addr(int mask);
 
-#ifndef FTRACE_ADDR
-#define FTRACE_ADDR ((unsigned long)ftrace_caller)
-#endif
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 extern void ftrace_graph_caller(void);
 extern int ftrace_enable_ftrace_graph_caller(void);
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index f1eedda..b39dd52 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -963,7 +963,7 @@ __ftrace_replace_code(struct dyn_ftrace *rec, int enable)
 	unsigned long ftrace_addr;
 	unsigned long flag = 0UL;
 
-	ftrace_addr = (unsigned long)FTRACE_ADDR;
+	ftrace_addr = ftrace_arch_tracer_addr(FTRACE_CALLERS_MAX);
 
 	/*
 	 * If this record is not to be traced or we want to disable it,
-- 
1.7.1

