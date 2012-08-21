Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545Ab2HUPIg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 11:08:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59352 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506Ab2HUPIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 11:08:34 -0400
Date: Tue, 21 Aug 2012 08:03:43 -0700
From: tip-bot for Uros Bizjak <ubizjak@gmail.com>
Message-ID: <tip-e4ea3f6b1bf3d489674a3660db652636e50186f9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        masami.hiramatsu.pt@hitachi.com, rostedt@goodmis.org,
        tglx@linutronix.de, ubizjak@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, rostedt@goodmis.org,
        tglx@linutronix.de, ubizjak@gmail.com
In-Reply-To: <1342702344.12353.16.camel@gandalf.stny.rr.com>
References: <1342702344.12353.16.camel@gandalf.stny.rr.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] ftrace/x86_32:
  Simplify parameter setup for ftrace_regs_caller
Git-Commit-ID: e4ea3f6b1bf3d489674a3660db652636e50186f9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 21 Aug 2012 08:03:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e4ea3f6b1bf3d489674a3660db652636e50186f9
Gitweb:     http://git.kernel.org/tip/e4ea3f6b1bf3d489674a3660db652636e50186f9
Author:     Uros Bizjak <ubizjak@gmail.com>
AuthorDate: Thu, 19 Jul 2012 13:04:47 -0400
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Tue, 31 Jul 2012 10:29:34 -0400

ftrace/x86_32: Simplify parameter setup for ftrace_regs_caller

The final position of the stack after saving regs and setting up
the parameters for ftrace_regs_call, is the position of the pt_regs
needed for the 4th parameter. Instead of saving it into a temporary
reg and pushing the reg, simply push the stack pointer.

Link: http://lkml.kernel.org/r/1342702344.12353.16.camel@gandalf.stny.rr.com

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/entry_32.S |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 46caa56..4dc3017 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -1169,10 +1169,9 @@ ENTRY(ftrace_regs_caller)
 	movl $__KERNEL_CS,13*4(%esp)
 
 	movl 12*4(%esp), %eax	/* Load ip (1st parameter) */
-	movl 0x4(%ebp), %edx	/* Load parent ip (2cd parameter) */
-	lea  (%esp), %ecx
-	pushl %ecx		/* Save pt_regs as 4th parameter */
+	movl 0x4(%ebp), %edx	/* Load parent ip (2nd parameter) */
 	leal function_trace_op, %ecx /* Save ftrace_pos in 3rd parameter */
+	pushl %esp		/* Save pt_regs as 4th parameter */
 
 GLOBAL(ftrace_regs_call)
 	call ftrace_stub
