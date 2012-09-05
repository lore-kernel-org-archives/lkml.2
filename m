Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757254Ab2IEOcd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 10:32:33 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:54134 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753883Ab2IEOca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 10:32:30 -0400
X-AuditID: b753bd60-900c0ba0000047ca-36-5047627cbab9
X-AuditID: b753bd60-900c0ba0000047ca-36-5047627cbab9
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -tip 1/4] [BUGFIX] ftrace/x86: Adjust x86 regs.ip as like as
 x86-64
To: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>
Date: Wed, 05 Sep 2012 23:31:00 +0900
Message-ID: <20120905143100.10329.60109.stgit@localhost.localdomain>
In-Reply-To: <20120905143045.10329.64502.stgit@localhost.localdomain>
References: <20120905143045.10329.64502.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adjust x86 regs.ip to ip + MCOUNT_INSN_SIZE as like as
on x86-64. This helps us to consolidate codes which use
regs->ip on both of x86/x86-64.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
---

 arch/x86/kernel/entry_32.S |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 061ac17..f438a44 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -1148,7 +1148,6 @@ ENTRY(ftrace_regs_caller)
 	 * ip location, and move flags into the return ip location.
 	 */
 	pushl 4(%esp)	/* save return ip into ip slot */
-	subl $MCOUNT_INSN_SIZE, (%esp)	/* Adjust ip */
 
 	pushl $0	/* Load 0 into orig_ax */
 	pushl %gs
@@ -1169,6 +1168,7 @@ ENTRY(ftrace_regs_caller)
 	movl $__KERNEL_CS,13*4(%esp)
 
 	movl 12*4(%esp), %eax	/* Load ip (1st parameter) */
+	subl $MCOUNT_INSN_SIZE, %eax	/* Adjust ip */
 	movl 0x4(%ebp), %edx	/* Load parent ip (2nd parameter) */
 	leal function_trace_op, %ecx /* Save ftrace_pos in 3rd parameter */
 	pushl %esp		/* Save pt_regs as 4th parameter */
@@ -1180,7 +1180,6 @@ GLOBAL(ftrace_regs_call)
 	movl 14*4(%esp), %eax	/* Move flags back into cs */
 	movl %eax, 13*4(%esp)	/* Needed to keep addl from modifying flags */
 	movl 12*4(%esp), %eax	/* Get return ip from regs->ip */
-	addl $MCOUNT_INSN_SIZE, %eax
 	movl %eax, 14*4(%esp)	/* Put return ip back for ret */
 
 	popl %ebx

