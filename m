Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796Ab2H0RGh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 13:06:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34350 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420Ab2H0RGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 13:06:35 -0400
Date: Mon, 27 Aug 2012 10:06:18 -0700
From: tip-bot for Steven Rostedt <srostedt@redhat.com>
Message-ID: <tip-d57c5d51a30152f3175d2344cb6395f08bf8ee0c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        andi@firstfloor.org, masami.hiramatsu.pt@hitachi.com,
        rostedt@goodmis.org, srostedt@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, andi@firstfloor.org,
        rostedt@goodmis.org, srostedt@redhat.com, tglx@linutronix.de
In-Reply-To: <20120807194100.130477900@goodmis.org>
References: <20120807194100.130477900@goodmis.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] ftrace/x86: Add support for -mfentry to x86_64
Git-Commit-ID: d57c5d51a30152f3175d2344cb6395f08bf8ee0c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 27 Aug 2012 10:06:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d57c5d51a30152f3175d2344cb6395f08bf8ee0c
Gitweb:     http://git.kernel.org/tip/d57c5d51a30152f3175d2344cb6395f08bf8ee0c
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Wed, 9 Feb 2011 13:32:18 -0500
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Thu, 23 Aug 2012 11:26:36 -0400

ftrace/x86: Add support for -mfentry to x86_64

If the kernel is compiled with gcc 4.6.0 which supports -mfentry,
then use that instead of mcount.

With mcount, frame pointers are forced with the -pg option and we
get something like:

<can_vma_merge_before>:
       55                      push   %rbp
       48 89 e5                mov    %rsp,%rbp
       53                      push   %rbx
       41 51                   push   %r9
       e8 fe 6a 39 00          callq  ffffffff81483d00 <mcount>
       31 c0                   xor    %eax,%eax
       48 89 fb                mov    %rdi,%rbx
       48 89 d7                mov    %rdx,%rdi
       48 33 73 30             xor    0x30(%rbx),%rsi
       48 f7 c6 ff ff ff f7    test   $0xfffffffff7ffffff,%rsi

With -mfentry, frame pointers are no longer forced and the call looks
like this:

<can_vma_merge_before>:
       e8 33 af 37 00          callq  ffffffff81461b40 <__fentry__>
       53                      push   %rbx
       48 89 fb                mov    %rdi,%rbx
       31 c0                   xor    %eax,%eax
       48 89 d7                mov    %rdx,%rdi
       41 51                   push   %r9
       48 33 73 30             xor    0x30(%rbx),%rsi
       48 f7 c6 ff ff ff f7    test   $0xfffffffff7ffffff,%rsi

This adds the ftrace hook at the beginning of the function before a
frame is set up, and allows the function callbacks to be able to access
parameters. As kprobes now can use function tracing (at least on x86)
this speeds up the kprobe hooks that are at the beginning of the
function.

Link: http://lkml.kernel.org/r/20120807194100.130477900@goodmis.org

Acked-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/Kconfig                 |    1 +
 arch/x86/include/asm/ftrace.h    |    7 ++++++-
 arch/x86/kernel/entry_64.S       |   32 +++++++++++++++++++++++++++-----
 arch/x86/kernel/x8664_ksyms_64.c |    6 +++++-
 4 files changed, 39 insertions(+), 7 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index a2d19ee..28dd891 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -36,6 +36,7 @@ config X86
 	select HAVE_KRETPROBES
 	select HAVE_OPTPROBES
 	select HAVE_FTRACE_MCOUNT_RECORD
+	select HAVE_FENTRY if X86_64
 	select HAVE_C_RECORDMCOUNT
 	select HAVE_DYNAMIC_FTRACE
 	select HAVE_FUNCTION_TRACER
diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
index a6cae0c..9a25b52 100644
--- a/arch/x86/include/asm/ftrace.h
+++ b/arch/x86/include/asm/ftrace.h
@@ -35,7 +35,11 @@
 #endif
 
 #ifdef CONFIG_FUNCTION_TRACER
-#define MCOUNT_ADDR		((long)(mcount))
+#ifdef CC_USING_FENTRY
+# define MCOUNT_ADDR		((long)(__fentry__))
+#else
+# define MCOUNT_ADDR		((long)(mcount))
+#endif
 #define MCOUNT_INSN_SIZE	5 /* sizeof mcount call */
 
 #ifdef CONFIG_DYNAMIC_FTRACE
@@ -46,6 +50,7 @@
 #ifndef __ASSEMBLY__
 extern void mcount(void);
 extern atomic_t modifying_ftrace_code;
+extern void __fentry__(void);
 
 static inline unsigned long ftrace_call_adjust(unsigned long addr)
 {
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index b7a81dc..ed767b7 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -68,10 +68,18 @@
 	.section .entry.text, "ax"
 
 #ifdef CONFIG_FUNCTION_TRACER
+
+#ifdef CC_USING_FENTRY
+# define function_hook	__fentry__
+#else
+# define function_hook	mcount
+#endif
+
 #ifdef CONFIG_DYNAMIC_FTRACE
-ENTRY(mcount)
+
+ENTRY(function_hook)
 	retq
-END(mcount)
+END(function_hook)
 
 /* skip is set if stack has been adjusted */
 .macro ftrace_caller_setup skip=0
@@ -84,7 +92,11 @@ END(mcount)
 	movq RIP(%rsp), %rdi
 	subq $MCOUNT_INSN_SIZE, %rdi
 	/* Load the parent_ip into the second parameter */
+#ifdef CC_USING_FENTRY
+	movq SS+16(%rsp), %rsi
+#else
 	movq 8(%rbp), %rsi
+#endif
 .endm
 
 ENTRY(ftrace_caller)
@@ -177,7 +189,8 @@ END(ftrace_regs_caller)
 
 
 #else /* ! CONFIG_DYNAMIC_FTRACE */
-ENTRY(mcount)
+
+ENTRY(function_hook)
 	cmpl $0, function_trace_stop
 	jne  ftrace_stub
 
@@ -199,7 +212,11 @@ trace:
 	MCOUNT_SAVE_FRAME
 
 	movq RIP(%rsp), %rdi
+#ifdef CC_USING_FENTRY
+	movq SS+16(%rsp), %rsi
+#else
 	movq 8(%rbp), %rsi
+#endif
 	subq $MCOUNT_INSN_SIZE, %rdi
 
 	call   *ftrace_trace_function
@@ -207,7 +224,7 @@ trace:
 	MCOUNT_RESTORE_FRAME
 
 	jmp ftrace_stub
-END(mcount)
+END(function_hook)
 #endif /* CONFIG_DYNAMIC_FTRACE */
 #endif /* CONFIG_FUNCTION_TRACER */
 
@@ -215,9 +232,14 @@ END(mcount)
 ENTRY(ftrace_graph_caller)
 	MCOUNT_SAVE_FRAME
 
+#ifdef CC_USING_FENTRY
+	leaq SS+16(%rsp), %rdi
+	movq $0, %rdx	/* No framepointers needed */
+#else
 	leaq 8(%rbp), %rdi
-	movq RIP(%rsp), %rsi
 	movq (%rbp), %rdx
+#endif
+	movq RIP(%rsp), %rsi
 	subq $MCOUNT_INSN_SIZE, %rsi
 
 	call	prepare_ftrace_return
diff --git a/arch/x86/kernel/x8664_ksyms_64.c b/arch/x86/kernel/x8664_ksyms_64.c
index 6020f6f..1330dd1 100644
--- a/arch/x86/kernel/x8664_ksyms_64.c
+++ b/arch/x86/kernel/x8664_ksyms_64.c
@@ -13,9 +13,13 @@
 #include <asm/ftrace.h>
 
 #ifdef CONFIG_FUNCTION_TRACER
-/* mcount is defined in assembly */
+/* mcount and __fentry__ are defined in assembly */
+#ifdef CC_USING_FENTRY
+EXPORT_SYMBOL(__fentry__);
+#else
 EXPORT_SYMBOL(mcount);
 #endif
+#endif
 
 EXPORT_SYMBOL(__get_user_1);
 EXPORT_SYMBOL(__get_user_2);
