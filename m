Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758063Ab2GMToS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 15:44:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2048 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190Ab2GMToQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 15:44:16 -0400
X-Authority-Analysis: v=2.0 cv=AtpsLZBP c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=m_VzdanGAVkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=PSFjnz9KlFBXcQplrC8A:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Message-ID: <1342208654.30075.22.camel@gandalf.stny.rr.com>
Subject: [RFC][PATCH] x86_32: Return actual stack when requesting sp from
 regs
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, stable <stable@vger.kernel.org>
Date: Fri, 13 Jul 2012 15:44:14 -0400
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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

[ I wonder if this should also go to stable? ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Index: linux-trace.git/arch/x86/include/asm/ptrace.h
===================================================================
--- linux-trace.git.orig/arch/x86/include/asm/ptrace.h
+++ linux-trace.git/arch/x86/include/asm/ptrace.h
@@ -246,6 +246,15 @@ static inline unsigned long regs_get_reg
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
 


