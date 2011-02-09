Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755005Ab1BIUKk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 15:10:40 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:56145 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753851Ab1BIUKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 15:10:34 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=J-06X1p54oQA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=WfulkdPnAAAA:8 a=meVymXHHAAAA:8 a=RHwrXTnBX2QY_OcBMyIA:9 a=5st3kZkZh1QIbPRXH-YA:7 a=Gc_8wBNt-tI1EFh42fR3lPDSzv8A:4 a=jEp0ucaQiEUA:10 a=l29vjEC0CZ8A:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110209201030.363842508@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 09 Feb 2011 15:02:53 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andi Kleen <andi@firstfloor.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [RFC][PATCH 4/4] ftrace/x86: Add support for -mfentry to x86_64
References: <20110209200249.111932716@goodmis.org>
Content-Disposition: inline; filename=0004-ftrace-x86-Add-support-for-mfentry-to-x86_64.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

If the kernel is compiled with gcc 4.6.0 which supports -mfentry,
then use that instead of mcount.

Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/Kconfig                 |    1 +
 arch/x86/include/asm/ftrace.h    |    7 ++++++-
 arch/x86/kernel/entry_64.S       |   17 ++++++++++++++++-
 arch/x86/kernel/x8664_ksyms_64.c |    6 +++++-
 4 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index d5ed94d..ac1a47e 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -32,6 +32,7 @@ config X86
 	select HAVE_KRETPROBES
 	select HAVE_OPTPROBES
 	select HAVE_FTRACE_MCOUNT_RECORD
+	select HAVE_FENTRY if X86_64
 	select HAVE_C_RECORDMCOUNT
 	select HAVE_DYNAMIC_FTRACE
 	select HAVE_FUNCTION_TRACER
diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
index db24c22..b1386d8 100644
--- a/arch/x86/include/asm/ftrace.h
+++ b/arch/x86/include/asm/ftrace.h
@@ -29,11 +29,16 @@
 #endif
 
 #ifdef CONFIG_FUNCTION_TRACER
-#define MCOUNT_ADDR		((long)(mcount))
+#ifdef CC_HAS_FENTRY
+# define MCOUNT_ADDR		((long)(__fentry__))
+#else
+# define MCOUNT_ADDR		((long)(mcount))
+#endif
 #define MCOUNT_INSN_SIZE	5 /* sizeof mcount call */
 
 #ifndef __ASSEMBLY__
 extern void mcount(void);
+extern void __fentry__(void);
 
 static inline unsigned long ftrace_call_adjust(unsigned long addr)
 {
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index aed1ffb..44031ee 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -63,9 +63,16 @@
 	.code64
 #ifdef CONFIG_FUNCTION_TRACER
 #ifdef CONFIG_DYNAMIC_FTRACE
+
+#ifdef CC_HAS_FENTRY
+ENTRY(__fentry__)
+	retq
+END(__fentry__)
+#else
 ENTRY(mcount)
 	retq
 END(mcount)
+#endif
 
 ENTRY(ftrace_caller)
 	cmpl $0, function_trace_stop
@@ -74,7 +81,11 @@ ENTRY(ftrace_caller)
 	MCOUNT_SAVE_FRAME
 
 	movq 0x38(%rsp), %rdi
+#ifdef CC_HAS_FENTRY
+	movq 0x40(%rsp), %rsi
+#else
 	movq 8(%rbp), %rsi
+#endif
 	subq $MCOUNT_INSN_SIZE, %rdi
 
 GLOBAL(ftrace_call)
@@ -133,9 +144,13 @@ ENTRY(ftrace_graph_caller)
 
 	MCOUNT_SAVE_FRAME
 
+#ifdef CC_HAS_FENTRY
+	leaq 0x40(%rsp), %rdi
+#else
 	leaq 8(%rbp), %rdi
-	movq 0x38(%rsp), %rsi
 	movq (%rbp), %rdx
+#endif
+	movq 0x38(%rsp), %rsi
 	subq $MCOUNT_INSN_SIZE, %rsi
 
 	call	prepare_ftrace_return
diff --git a/arch/x86/kernel/x8664_ksyms_64.c b/arch/x86/kernel/x8664_ksyms_64.c
index 1b950d1..7fa3a78 100644
--- a/arch/x86/kernel/x8664_ksyms_64.c
+++ b/arch/x86/kernel/x8664_ksyms_64.c
@@ -13,9 +13,13 @@
 #include <asm/ftrace.h>
 
 #ifdef CONFIG_FUNCTION_TRACER
-/* mcount is defined in assembly */
+/* mcount and __fentry__ are defined in assembly */
+#ifdef CC_HAS_FENTRY
+EXPORT_SYMBOL(__fentry__);
+#else
 EXPORT_SYMBOL(mcount);
 #endif
+#endif
 
 EXPORT_SYMBOL(__get_user_1);
 EXPORT_SYMBOL(__get_user_2);
-- 
1.7.2.3


