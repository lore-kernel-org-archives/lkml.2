Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761762Ab2FEK2A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 06:28:00 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:50088 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761719Ab2FEK15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 06:27:57 -0400
X-AuditID: b753bd60-a0885ba000000655-a0-4fcddf2b8210
X-AuditID: b753bd60-a0885ba000000655-a0-4fcddf2b8210
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -tip v2 2/9] ftrace/x86-64: support SAVE_REGS feature on x86-64
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>
Date: Tue, 05 Jun 2012 19:27:56 +0900
Message-ID: <20120605102756.27845.86750.stgit@localhost.localdomain>
In-Reply-To: <20120605102734.27845.43401.stgit@localhost.localdomain>
References: <20120605102734.27845.43401.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add register saving/restoring sequence in ftrace_caller
on x86-64 for enabling SAVE_REGS feature.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
---

 arch/x86/include/asm/ftrace.h |    4 ++++
 arch/x86/kernel/entry_64.S    |   38 +++++++++++++++++++++++++++++++++-----
 2 files changed, 37 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
index 18d9005..ffb9564 100644
--- a/arch/x86/include/asm/ftrace.h
+++ b/arch/x86/include/asm/ftrace.h
@@ -32,6 +32,10 @@
 #define MCOUNT_ADDR		((long)(mcount))
 #define MCOUNT_INSN_SIZE	5 /* sizeof mcount call */
 
+#if defined(CONFIG_DYNAMIC_FTRACE) && defined(CONFIG_X86_64)
+#define ARCH_SUPPORTS_FTRACE_SAVE_REGS 1
+#endif
+
 #ifndef __ASSEMBLY__
 extern void mcount(void);
 extern int modifying_ftrace_code;
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 320852d..6d0545b 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -73,21 +73,44 @@ ENTRY(mcount)
 	retq
 END(mcount)
 
+	.macro MCOUNT_SAVE_ALL
+	SAVE_ARGS (RSP-ORIG_RAX)
+	SAVE_REST
+	/* Adjust eflags, rsp and rip */
+	movq RSP(%rsp), %rdx
+	movq %rdx, EFLAGS(%rsp)
+	leaq SS+8(%rsp), %rdx
+	movq %rdx, RSP(%rsp)
+	movq SS(%rsp), %rdi
+	subq $MCOUNT_INSN_SIZE, %rdi
+	movq %rdi, RIP(%rsp)
+	.endm
+
+	.macro MCOUNT_RESTORE_ALL
+	/* store eflags into regs->rsp */
+	movq EFLAGS(%rsp), %rax
+	movq %rax, RSP(%rsp)
+	RESTORE_REST
+	RESTORE_ARGS 1, (RSP-ORIG_RAX)
+	.endm
+
 ENTRY(ftrace_caller)
+	CFI_STARTPROC	simple
+	pushfq_cfi
 	cmpl $0, function_trace_stop
-	jne  ftrace_stub
+	jne  ftrace_exit
 
-	MCOUNT_SAVE_FRAME
+	MCOUNT_SAVE_ALL
 
-	movq 0x38(%rsp), %rdi
 	movq 8(%rbp), %rsi
-	subq $MCOUNT_INSN_SIZE, %rdi
+	movq %rsp, %rdx
 
 GLOBAL(ftrace_call)
 	call ftrace_stub
 
-	MCOUNT_RESTORE_FRAME
+	MCOUNT_RESTORE_ALL
 
+	popfq_cfi
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 GLOBAL(ftrace_graph_call)
 	jmp ftrace_stub
@@ -95,6 +118,11 @@ GLOBAL(ftrace_graph_call)
 
 GLOBAL(ftrace_stub)
 	retq
+
+ftrace_exit:
+	popfq_cfi
+	retq
+	CFI_ENDPROC
 END(ftrace_caller)
 
 #else /* ! CONFIG_DYNAMIC_FTRACE */

