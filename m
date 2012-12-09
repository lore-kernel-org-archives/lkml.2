Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933897Ab2LILdK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 06:33:10 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56302 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933438Ab2LILdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 06:33:08 -0500
Date: Sun, 9 Dec 2012 03:32:49 -0800
From: tip-bot for Steven Rostedt <rostedt@goodmis.org>
Message-ID: <tip-6c8d8b3c69cef1330e0c5cbc2a8b9268024927a0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        masami.hiramatsu.pt@hitachi.com, rostedt@goodmis.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, rostedt@goodmis.org,
        tglx@linutronix.de
In-Reply-To: <1342208654.30075.22.camel@gandalf.stny.rr.com>
References: <1342208654.30075.22.camel@gandalf.stny.rr.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86_32:
  Return actual stack when requesting sp from regs
Git-Commit-ID: 6c8d8b3c69cef1330e0c5cbc2a8b9268024927a0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sun, 09 Dec 2012 03:32:55 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6c8d8b3c69cef1330e0c5cbc2a8b9268024927a0
Gitweb:     http://git.kernel.org/tip/6c8d8b3c69cef1330e0c5cbc2a8b9268024927a0
Author:     Steven Rostedt <rostedt@goodmis.org>
AuthorDate: Fri, 13 Jul 2012 15:44:14 -0400
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Mon, 19 Nov 2012 05:31:37 -0500

x86_32: Return actual stack when requesting sp from regs

As x86_32 traps do not save sp when taken in kernel mode, we need to
accommodate the sp when requesting to get the register.

This affects kprobes.

Before:

 # echo 'p:ftrace sys_read+4 s=%sp' > /debug/tracing/kprobe_events
 # echo 1 > /debug/tracing/events/kprobes/enable
 # cat trace
            sshd-1345  [000] d...   489.117168: ftrace: (sys_read+0x4/0x70) s=b7e96768
            sshd-1345  [000] d...   489.117191: ftrace: (sys_read+0x4/0x70) s=b7e96768
             cat-1447  [000] d...   489.117392: ftrace: (sys_read+0x4/0x70) s=5a7
             cat-1447  [001] d...   489.118023: ftrace: (sys_read+0x4/0x70) s=b77ad05f
            less-1448  [000] d...   489.118079: ftrace: (sys_read+0x4/0x70) s=b7762e06
            less-1448  [000] d...   489.118117: ftrace: (sys_read+0x4/0x70) s=b7764970

After:
            sshd-1352  [000] d...   362.348016: ftrace: (sys_read+0x4/0x70) s=f3febfa8
            sshd-1352  [000] d...   362.348048: ftrace: (sys_read+0x4/0x70) s=f3febfa8
            bash-1355  [001] d...   362.348081: ftrace: (sys_read+0x4/0x70) s=f5075fa8
            sshd-1352  [000] d...   362.348082: ftrace: (sys_read+0x4/0x70) s=f3febfa8
            sshd-1352  [000] d...   362.690950: ftrace: (sys_read+0x4/0x70) s=f3febfa8
            bash-1355  [001] d...   362.691033: ftrace: (sys_read+0x4/0x70) s=f5075fa8

Link: http://lkml.kernel.org/r/1342208654.30075.22.camel@gandalf.stny.rr.com

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/include/asm/ptrace.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/include/asm/ptrace.h b/arch/x86/include/asm/ptrace.h
index dcfde52..2233713 100644
--- a/arch/x86/include/asm/ptrace.h
+++ b/arch/x86/include/asm/ptrace.h
@@ -246,6 +246,15 @@ static inline unsigned long regs_get_register(struct pt_regs *regs,
 {
 	if (unlikely(offset > MAX_REG_OFFSET))
 		return 0;
+#ifdef CONFIG_X86_32
+	/*
+	 * Traps from the kernel do not save sp and ss.
+	 * Use the helper function to retrieve sp.
+	 */
+	if (offset == offsetof(struct pt_regs, sp) &&
+	    regs->cs == __KERNEL_CS)
+		return kernel_stack_pointer(regs);
+#endif
 	return *(unsigned long *)((unsigned long)regs + offset);
 }
 
