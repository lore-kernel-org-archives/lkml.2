Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933222Ab2FEK2P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 06:28:15 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:60471 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761682Ab2FEK2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 06:28:03 -0400
X-AuditID: b753bd60-96eedba000000f6c-3a-4fcddf31bcb5
X-AuditID: b753bd60-96eedba000000f6c-3a-4fcddf31bcb5
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -tip v2 3/9] ftrace/x86: Support SAVE_REGS feature on i386
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
Date: Tue, 05 Jun 2012 19:28:02 +0900
Message-ID: <20120605102802.27845.49309.stgit@localhost.localdomain>
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
on i386 for enabling SAVE_REGS feature.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
---

 arch/x86/include/asm/ftrace.h |    2 +
 arch/x86/kernel/entry_32.S    |   64 +++++++++++++++++++++++++++++++++++------
 2 files changed, 56 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
index ffb9564..e2f7269 100644
--- a/arch/x86/include/asm/ftrace.h
+++ b/arch/x86/include/asm/ftrace.h
@@ -32,7 +32,7 @@
 #define MCOUNT_ADDR		((long)(mcount))
 #define MCOUNT_INSN_SIZE	5 /* sizeof mcount call */
 
-#if defined(CONFIG_DYNAMIC_FTRACE) && defined(CONFIG_X86_64)
+#if defined(CONFIG_DYNAMIC_FTRACE)
 #define ARCH_SUPPORTS_FTRACE_SAVE_REGS 1
 #endif
 
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 01ccf9b..79c45a2 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -1095,24 +1095,66 @@ ENTRY(mcount)
 	ret
 END(mcount)
 
+	.macro FTRACE_SAVE_ALL
+	/* eflags is saved on cs */
+	subl $8, %esp		/* skip ip and orig_ax */
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
+	movl %edx, 13*4+4(%esp)
+	.endm
+
+	.macro FTRACE_RESTORE_ALL
+	movl 14*4+4(%esp), %eax	/* Load flags */
+	movl %eax, 13*4+4(%esp)	/* Restore flags */
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
+	.endm
+
 ENTRY(ftrace_caller)
+	pushf	/* flags on regs->cs */
 	cmpl $0, function_trace_stop
-	jne  ftrace_stub
+	jne  ftrace_exit
+
+	FTRACE_SAVE_ALL
 
-	pushl %eax
-	pushl %ecx
-	pushl %edx
-	movl 0xc(%esp), %eax
 	movl 0x4(%ebp), %edx
-	subl $MCOUNT_INSN_SIZE, %eax
+	lea  4(%esp), %ecx
 
 .globl ftrace_call
 ftrace_call:
 	call ftrace_stub
 
-	popl %edx
-	popl %ecx
-	popl %eax
+	FTRACE_RESTORE_ALL
+
+	popf
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 .globl ftrace_graph_call
 ftrace_graph_call:
@@ -1122,6 +1164,10 @@ ftrace_graph_call:
 .globl ftrace_stub
 ftrace_stub:
 	ret
+
+ftrace_exit:
+	popf
+	ret
 END(ftrace_caller)
 
 #else /* ! CONFIG_DYNAMIC_FTRACE */

