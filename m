Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018Ab0KFS0b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 14:26:31 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:60924 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752977Ab0KFS03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 14:26:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=T4Df7bPMCRpoR0htcKnw+Q+0OYfaxIA+fAdd2zSQSJf9BYXXuT6lbYjuNml6pWXj41
         ZhPmuMAgzLG0PiRl9dCXesowoMbLThiHjVNx70uPwULAU0Oja8yfHpQDB55+AGmnUaLh
         VyHzVN8oVCZhP2Y0LiLuYhvhxFrwIdfoPRYHw=
From: Rabin Vincent <rabin@rab.in>
To: linux-arm-kernel@lists.infradead.org
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Tim Bird <tim.bird@am.sony.com>, linux-kernel@vger.kernel.org,
        Rabin Vincent <rabin@rab.in>
Subject: [PATCH 5/6] ARM: ftrace: graph tracer + dynamic ftrace
Date: Sat,  6 Nov 2010 23:55:53 +0530
Message-Id: <1289067954-5080-5-git-send-email-rabin@rab.in>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1289067954-5080-1-git-send-email-rabin@rab.in>
References: <1289067954-5080-1-git-send-email-rabin@rab.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support the graph tracer + dynamic ftrace combination on ARM.

Signed-off-by: Rabin Vincent <rabin@rab.in>
---
 arch/arm/kernel/entry-common.S |   12 +++++++
 arch/arm/kernel/ftrace.c       |   69 +++++++++++++++++++++++++++++++++++++---
 2 files changed, 76 insertions(+), 5 deletions(-)

diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
index 9f17662..aae802e 100644
--- a/arch/arm/kernel/entry-common.S
+++ b/arch/arm/kernel/entry-common.S
@@ -183,12 +183,24 @@ ENDPROC(ret_from_fork)
 ftrace_call\suffix:
 	bl	ftrace_stub
 
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+	.globl ftrace_graph_call\suffix
+ftrace_graph_call\suffix:
+	mov	r0, r0
+#endif
+
 	mcount_exit
 .endm
 
 .macro __ftrace_graph_caller
 	sub	r0, fp, #4		@ &lr of instrumented routine (&parent)
+#ifdef CONFIG_DYNAMIC_FTRACE
+	@ called from __ftrace_caller, saved in mcount_enter
+	ldr	r1, [sp, #16]		@ instrumented routine (func)
+#else
+	@ called from __mcount, untouched in lr
 	mov	r1, lr			@ instrumented routine (func)
+#endif
 	sub	r1, r1, #MCOUNT_INSN_SIZE
 	mov	r2, fp			@ frame pointer
 	bl	prepare_ftrace_return
diff --git a/arch/arm/kernel/ftrace.c b/arch/arm/kernel/ftrace.c
index 7a702a5..c0062ad 100644
--- a/arch/arm/kernel/ftrace.c
+++ b/arch/arm/kernel/ftrace.c
@@ -60,9 +60,9 @@ static unsigned long adjust_address(struct dyn_ftrace *rec, unsigned long addr)
 }
 #endif
 
-/* construct a branch (BL) instruction to addr */
 #ifdef CONFIG_THUMB2_KERNEL
-static unsigned long ftrace_call_replace(unsigned long pc, unsigned long addr)
+static unsigned long ftrace_gen_branch(unsigned long pc, unsigned long addr,
+				       bool link)
 {
 	unsigned long s, j1, j2, i1, i2, imm10, imm11;
 	unsigned long first, second;
@@ -84,15 +84,22 @@ static unsigned long ftrace_call_replace(unsigned long pc, unsigned long addr)
 	j2 = (!i2) ^ s;
 
 	first = 0xf000 | (s << 10) | imm10;
-	second = 0xd000 | (j1 << 13) | (j2 << 11) | imm11;
+	second = 0x9000 | (j1 << 13) | (j2 << 11) | imm11;
+	if (link)
+		second |= 1 << 14;
 
 	return (second << 16) | first;
 }
 #else
-static unsigned long ftrace_call_replace(unsigned long pc, unsigned long addr)
+static unsigned long ftrace_gen_branch(unsigned long pc, unsigned long addr,
+				       bool link)
 {
+	unsigned long opcode = 0xea000000;
 	long offset;
 
+	if (link)
+		opcode |= 1 << 24;
+
 	offset = (long)addr - (long)(pc + 8);
 	if (unlikely(offset < -33554432 || offset > 33554428)) {
 		/* Can't generate branches that far (from ARM ARM). Ftrace
@@ -104,10 +111,15 @@ static unsigned long ftrace_call_replace(unsigned long pc, unsigned long addr)
 
 	offset = (offset >> 2) & 0x00ffffff;
 
-	return 0xeb000000 | offset;
+	return opcode | offset;
 }
 #endif
 
+static unsigned long ftrace_call_replace(unsigned long pc, unsigned long addr)
+{
+	return ftrace_gen_branch(pc, addr, true);
+}
+
 static int ftrace_modify_code(unsigned long pc, unsigned long old,
 			      unsigned long new)
 {
@@ -226,4 +238,51 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr,
 		*parent = old;
 	}
 }
+
+#ifdef CONFIG_DYNAMIC_FTRACE
+extern unsigned long ftrace_graph_call;
+extern unsigned long ftrace_graph_call_old;
+extern void ftrace_graph_caller_old(void);
+
+static int __ftrace_modify_caller(unsigned long *callsite,
+				  void (*func) (void), bool enable)
+{
+	unsigned long caller_fn = (unsigned long) func;
+	unsigned long pc = (unsigned long) callsite;
+	unsigned long branch = ftrace_gen_branch(pc, caller_fn, false);
+	unsigned long nop = 0xe1a00000;	/* mov r0, r0 */
+	unsigned long old = enable ? nop : branch;
+	unsigned long new = enable ? branch : nop;
+
+	return ftrace_modify_code(pc, old, new);
+}
+
+static int ftrace_modify_graph_caller(bool enable)
+{
+	int ret;
+
+	ret = __ftrace_modify_caller(&ftrace_graph_call,
+				     ftrace_graph_caller,
+				     enable);
+
+#ifdef CONFIG_OLD_MCOUNT
+	if (!ret)
+		ret = __ftrace_modify_caller(&ftrace_graph_call_old,
+					     ftrace_graph_caller_old,
+					     enable);
+#endif
+
+	return ret;
+}
+
+int ftrace_enable_ftrace_graph_caller(void)
+{
+	return ftrace_modify_graph_caller(true);
+}
+
+int ftrace_disable_ftrace_graph_caller(void)
+{
+	return ftrace_modify_graph_caller(false);
+}
+#endif /* CONFIG_DYNAMIC_FTRACE */
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
-- 
1.7.2.3

