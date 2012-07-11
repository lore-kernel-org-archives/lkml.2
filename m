Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933161Ab2GKT5r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 15:57:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11775 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932444Ab2GKT5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 15:57:46 -0400
X-Authority-Analysis: v=2.0 cv=ZuBv2qHG c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=6TTbDjVKieAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=3nbZYyFuAAAA:8 a=l4rZkT0uxlpPlpUS7bMA:9 a=jEp0ucaQiEUA:10 a=EvKJbDF4Ut8A:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120711195745.379060003@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Jul 2012 15:50:50 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [RFC][PATCH 2/4 v4] ftrace/x86: Add save_regs for i386 function calls
References: <20120711195048.885039013@goodmis.org>
Content-Disposition: inline; filename=0002-ftrace-x86-Add-save_regs-for-i386-function-calls.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Add saving full regs for function tracing on i386.
The saving of regs was influenced by patches sent out by
Masami Hiramatsu.

Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/include/asm/ftrace.h |    2 --
 arch/x86/kernel/entry_32.S    |   58 +++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/ftrace.c      |    4 ---
 3 files changed, 58 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
index a847501..a6cae0c 100644
--- a/arch/x86/include/asm/ftrace.h
+++ b/arch/x86/include/asm/ftrace.h
@@ -40,10 +40,8 @@
 
 #ifdef CONFIG_DYNAMIC_FTRACE
 #define ARCH_SUPPORTS_FTRACE_OPS 1
-#ifdef CONFIG_X86_64
 #define ARCH_SUPPORTS_FTRACE_SAVE_REGS
 #endif
-#endif
 
 #ifndef __ASSEMBLY__
 extern void mcount(void);
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 5da11d1..8ef138f 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -1123,6 +1123,7 @@ ftrace_call:
 	popl %edx
 	popl %ecx
 	popl %eax
+ftrace_ret:
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 .globl ftrace_graph_call
 ftrace_graph_call:
@@ -1134,6 +1135,63 @@ ftrace_stub:
 	ret
 END(ftrace_caller)
 
+ENTRY(ftrace_regs_caller)
+	pushf	/* push flags before compare (in ss location) */
+	cmpl $0, function_trace_stop
+	jne ftrace_restore_flags
+
+	pushl %esp	/* Save stack in sp location */
+	subl $4, (%esp) /* Adjust saved stack to skip saved flags */
+	pushl 4(%esp)	/* Save flags in correct position */
+	movl $__KERNEL_DS, 8(%esp)	/* Save ss */
+	pushl $__KERNEL_CS
+	pushl 4*4(%esp)	/* Save the ip */
+	subl $MCOUNT_INSN_SIZE, (%esp)	/* Adjust ip */
+	pushl $0	/* Load 0 into orig_ax */
+
+	pushl %gs
+	pushl %fs
+	pushl %es
+	pushl %ds
+	pushl %eax
+	pushl %ebp
+	pushl %edi
+	pushl %esi
+	pushl %edx
+	pushl %ecx
+	pushl %ebx
+
+	movl 12*4(%esp), %eax	/* Load ip (1st parameter) */
+	movl 0x4(%ebp), %edx	/* Load parent ip (2cd parameter) */
+	lea  (%esp), %ecx
+	pushl %ecx		/* Save pt_regs as 4th parameter */
+	leal function_trace_op, %ecx /* Save ftrace_pos in 3rd parameter */
+
+GLOBAL(ftrace_regs_call)
+	call ftrace_stub
+
+	addl $4,%esp		/* Skip pt_regs */
+	movl 14*4(%esp), %eax	/* Move flags back into ss */
+	movl %eax, 16*4(%esp)	/* Needed to keep addl from modifying flags */
+
+	popl %ebx
+	popl %ecx
+	popl %edx
+	popl %esi
+	popl %edi
+	popl %ebp
+	popl %eax
+	popl %ds
+	popl %es
+	popl %fs
+	popl %gs
+	addl $(5*4), %esp	/* Skip orig_ax, ip, cs, flags and sp */
+	popf			/* Pop flags at end (no addl to corrupt flags) */
+	jmp ftrace_ret
+
+ftrace_restore_flags:
+	popf
+	jmp  ftrace_stub
 #else /* ! CONFIG_DYNAMIC_FTRACE */
 
 ENTRY(mcount)
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index b90eb1a..1d41402 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -206,7 +206,6 @@ static int
 ftrace_modify_code(unsigned long ip, unsigned const char *old_code,
 		   unsigned const char *new_code);
 
-#ifdef ARCH_SUPPORTS_FTRACE_SAVE_REGS
 /*
  * Should never be called:
  *  As it is only called by __ftrace_replace_code() which is called by
@@ -221,7 +220,6 @@ int ftrace_modify_call(struct dyn_ftrace *rec, unsigned long old_addr,
 	WARN_ON(1);
 	return -EINVAL;
 }
-#endif
 
 int ftrace_update_ftrace_func(ftrace_func_t func)
 {
@@ -237,7 +235,6 @@ int ftrace_update_ftrace_func(ftrace_func_t func)
 
 	ret = ftrace_modify_code(ip, old, new);
 
-#ifdef ARCH_SUPPORTS_FTRACE_SAVE_REGS
 	/* Also update the regs callback function */
 	if (!ret) {
 		ip = (unsigned long)(&ftrace_regs_call);
@@ -245,7 +242,6 @@ int ftrace_update_ftrace_func(ftrace_func_t func)
 		new = ftrace_call_replace(ip, (unsigned long)func);
 		ret = ftrace_modify_code(ip, old, new);
 	}
-#endif
 
 	atomic_dec(&modifying_ftrace_code);
 
-- 
1.7.10


