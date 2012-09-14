Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102Ab2INLm5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 07:42:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51348 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754137Ab2INLmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 07:42:51 -0400
Date: Fri, 14 Sep 2012 04:42:33 -0700
From: tip-bot for Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Message-ID: <tip-a5e37863ab31d78faddff15675c89979792bc0bd@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, masami.hiramatsu.pt@hitachi.com,
        rostedt@goodmis.org, a.p.zijlstra@chello.nl, tglx@linutronix.de
In-Reply-To: <20120905143100.10329.60109.stgit@localhost.localdomain>
References: <20120905143100.10329.60109.stgit@localhost.localdomain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] ftrace/x86: Adjust x86 regs.ip as like as x86-64
Git-Commit-ID: a5e37863ab31d78faddff15675c89979792bc0bd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 14 Sep 2012 04:42:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a5e37863ab31d78faddff15675c89979792bc0bd
Gitweb:     http://git.kernel.org/tip/a5e37863ab31d78faddff15675c89979792bc0bd
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Wed, 5 Sep 2012 23:31:00 +0900
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Thu, 13 Sep 2012 22:52:09 -0400

ftrace/x86: Adjust x86 regs.ip as like as x86-64

Adjust x86 regs.ip to ip + MCOUNT_INSN_SIZE as like as
on x86-64. This helps us to consolidate codes which use
regs->ip on both of x86/x86-64.

Link: http://lkml.kernel.org/r/20120905143100.10329.60109.stgit@localhost.localdomain

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
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
