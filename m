Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756287Ab2GBUSf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 16:18:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5649 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932693Ab2GBUS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 16:18:26 -0400
X-Authority-Analysis: v=2.0 cv=IOWA+3TG c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=KR1J_HyDvCoA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=3nbZYyFuAAAA:8 a=l4rZkT0uxlpPlpUS7bMA:9 a=jEp0ucaQiEUA:10 a=EvKJbDF4Ut8A:10 a=jeBq3FmKZ4MA:10 a=pM9c7EvoiGBdanE0:21 a=uKoEwvfOWz_ZQH4P:21 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120702201822.052770797@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 02 Jul 2012 16:03:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 6/6] ftrace/x86: Add save_regs for i386 function calls
References: <20120702200322.573660631@goodmis.org>
Content-Disposition: inline; filename=0006-ftrace-x86-Add-save_regs-for-i386-function-calls.patch
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
 arch/x86/kernel/entry_32.S    |   53 +++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/ftrace.c      |    4 ----
 3 files changed, 53 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
index fd10faf..2b396cf 100644
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
index acd4963..e18ea33 100644
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
@@ -1134,6 +1135,58 @@ ftrace_stub:
 	ret
 END(ftrace_caller)
 
+ENTRY(ftrace_regs_caller)
+	pushf	/* push flags before compare */
+	cmpl $0, function_trace_stop
+	jne ftrace_exit
+
+	subl $8, %esp	/* skip ip and orig_ax */
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
+	movl 14*4(%esp), %eax	/* Load return address */
+	pushl %eax		/* Save return address (+4) */
+	subl $MCOUNT_INSN_SIZE, %eax
+	movl %eax, 12*4+4(%esp)	/* Store IP */
+	movl 13*4+4(%esp), %edx	/* Load flags */
+	movl %edx, 14*4+4(%esp)	/* Store flags */
+	movl $__KERNEL_CS, %edx
+	movl %edx, 13*4+4(%esp)	/* Store CS */
+
+	movl 0x4(%ebp), %edx
+	lea  4(%esp), %ecx
+	pushl %ecx		/* Save pt_regs as 4th parameter */
+	leal function_trace_op, %ecx
+
+GLOBAL(ftrace_regs_call)
+	call ftrace_stub
+
+	addl $4,%esp		/* Skip pt_regs */
+	popl %eax
+	movl %eax, 14*4(%esp)	/* Restore return address */
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
+	addl $8, %esp
+ftrace_exit:
+	popf
+	jmp ftrace_ret
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


