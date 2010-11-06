Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948Ab0KFS00 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 14:26:26 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:60924 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889Ab0KFS0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 14:26:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=pRtioPB0iv+m0GtaEMATFDI44h7GZprL4g6j8otbhhbeINAtfzb+iIBZoP7o1YCD//
         6qxmv8TPvAOBKc6ELbvyU3V+rx3SIFcHpRsCusUubsbMnAT8B5GQ7SeeJfiHPAQr/k7D
         J3t8MA9tYX/xaCwVXpETrL9PL7kew0p+KZVB0=
From: Rabin Vincent <rabin@rab.in>
To: linux-arm-kernel@lists.infradead.org
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Tim Bird <tim.bird@am.sony.com>, linux-kernel@vger.kernel.org,
        Rabin Vincent <rabin@rab.in>
Subject: [PATCH 4/6] ARM: ftrace: function graph tracer support
Date: Sat,  6 Nov 2010 23:55:52 +0530
Message-Id: <1289067954-5080-4-git-send-email-rabin@rab.in>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1289067954-5080-1-git-send-email-rabin@rab.in>
References: <1289067954-5080-1-git-send-email-rabin@rab.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tim Bird <tim.bird@am.sony.com>

Cc: Tim Bird <tim.bird@am.sony.com>
[rabin@rab.in: rebase on top of latest code,
	       keep code in ftrace.c instead of separate file,
	       check for ftrace_graph_entry also]
Signed-off-by: Rabin Vincent <rabin@rab.in>
---
 arch/arm/kernel/Makefile       |    3 +-
 arch/arm/kernel/entry-common.S |   46 ++++++++++++++++++++++++++++++++++++++++
 arch/arm/kernel/ftrace.c       |   34 +++++++++++++++++++++++++++++
 3 files changed, 82 insertions(+), 1 deletions(-)

diff --git a/arch/arm/kernel/Makefile b/arch/arm/kernel/Makefile
index 078dd22..b3225d4 100644
--- a/arch/arm/kernel/Makefile
+++ b/arch/arm/kernel/Makefile
@@ -5,7 +5,7 @@
 CPPFLAGS_vmlinux.lds := -DTEXT_OFFSET=$(TEXT_OFFSET)
 AFLAGS_head.o        := -DTEXT_OFFSET=$(TEXT_OFFSET)
 
-ifdef CONFIG_DYNAMIC_FTRACE
+ifdef CONFIG_FUNCTION_TRACER
 CFLAGS_REMOVE_ftrace.o = -pg
 endif
 
@@ -33,6 +33,7 @@ obj-$(CONFIG_SMP)		+= smp.o
 obj-$(CONFIG_HAVE_ARM_SCU)	+= smp_scu.o
 obj-$(CONFIG_HAVE_ARM_TWD)	+= smp_twd.o
 obj-$(CONFIG_DYNAMIC_FTRACE)	+= ftrace.o
+obj-$(CONFIG_FUNCTION_GRAPH_TRACER)	+= ftrace.o
 obj-$(CONFIG_KEXEC)		+= machine_kexec.o relocate_kernel.o
 obj-$(CONFIG_KPROBES)		+= kprobes.o kprobes-decode.o
 obj-$(CONFIG_ATAGS_PROC)	+= atags.o
diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
index fe1d586..9f17662 100644
--- a/arch/arm/kernel/entry-common.S
+++ b/arch/arm/kernel/entry-common.S
@@ -148,6 +148,20 @@ ENDPROC(ret_from_fork)
 	adr	r0, .Lftrace_stub
 	cmp	r0, r2
 	bne	1f
+
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+	ldr     r1, =ftrace_graph_return
+	ldr     r2, [r1]
+	cmp     r0, r2
+	bne     ftrace_graph_caller\suffix
+
+	ldr     r1, =ftrace_graph_entry
+	ldr     r2, [r1]
+	ldr     r0, =ftrace_graph_entry_stub
+	cmp     r0, r2
+	bne     ftrace_graph_caller\suffix
+#endif
+
 	mcount_exit
 
 1: 	mcount_get_lr	r1			@ lr of instrumented func
@@ -172,6 +186,15 @@ ftrace_call\suffix:
 	mcount_exit
 .endm
 
+.macro __ftrace_graph_caller
+	sub	r0, fp, #4		@ &lr of instrumented routine (&parent)
+	mov	r1, lr			@ instrumented routine (func)
+	sub	r1, r1, #MCOUNT_INSN_SIZE
+	mov	r2, fp			@ frame pointer
+	bl	prepare_ftrace_return
+	mcount_exit
+.endm
+
 #ifdef CONFIG_OLD_MCOUNT
 /*
  * mcount
@@ -206,6 +229,12 @@ ENTRY(ftrace_caller_old)
 ENDPROC(ftrace_caller_old)
 #endif
 
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+ENTRY(ftrace_graph_caller_old)
+	__ftrace_graph_caller
+ENDPROC(ftrace_graph_caller_old)
+#endif
+
 .purgem mcount_enter
 .purgem mcount_get_lr
 .purgem mcount_exit
@@ -244,10 +273,27 @@ ENTRY(ftrace_caller)
 ENDPROC(ftrace_caller)
 #endif
 
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+ENTRY(ftrace_graph_caller)
+	__ftrace_graph_caller
+ENDPROC(ftrace_graph_caller)
+#endif
+
 .purgem mcount_enter
 .purgem mcount_get_lr
 .purgem mcount_exit
 
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+	.globl return_to_handler
+return_to_handler:
+	stmdb	sp!, {r0-r3}
+	mov	r0, fp			@ frame pointer
+	bl	ftrace_return_to_handler
+	mov	lr, r0			@ r0 has real ret addr
+	ldmia	sp!, {r0-r3}
+	mov	pc, lr
+#endif
+
 ENTRY(ftrace_stub)
 .Lftrace_stub:
 	mov	pc, lr
diff --git a/arch/arm/kernel/ftrace.c b/arch/arm/kernel/ftrace.c
index 971ac8c..7a702a5 100644
--- a/arch/arm/kernel/ftrace.c
+++ b/arch/arm/kernel/ftrace.c
@@ -24,6 +24,7 @@
 #define	NOP		0xe8bd4000	/* pop {lr} */
 #endif
 
+#ifdef CONFIG_DYNAMIC_FTRACE
 #ifdef CONFIG_OLD_MCOUNT
 #define OLD_MCOUNT_ADDR	((unsigned long) mcount)
 #define OLD_FTRACE_ADDR ((unsigned long) ftrace_caller_old)
@@ -193,3 +194,36 @@ int __init ftrace_dyn_arch_init(void *data)
 
 	return 0;
 }
+#endif /* CONFIG_DYNAMIC_FTRACE */
+
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr,
+			   unsigned long frame_pointer)
+{
+	unsigned long return_hooker = (unsigned long) &return_to_handler;
+	struct ftrace_graph_ent trace;
+	unsigned long old;
+	int err;
+
+	if (unlikely(atomic_read(&current->tracing_graph_pause)))
+		return;
+
+	old = *parent;
+	*parent = return_hooker;
+
+	err = ftrace_push_return_trace(old, self_addr, &trace.depth,
+				       frame_pointer);
+	if (err == -EBUSY) {
+		*parent = old;
+		return;
+	}
+
+	trace.func = self_addr;
+
+	/* Only trace if the calling function expects to */
+	if (!ftrace_graph_entry(&trace)) {
+		current->curr_ret_stack--;
+		*parent = old;
+	}
+}
+#endif /* CONFIG_FUNCTION_GRAPH_TRACER */
-- 
1.7.2.3

