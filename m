Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752370Ab2KTT4b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 14:56:31 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3277 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910Ab2KTT4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 14:56:30 -0500
X-Authority-Analysis: v=2.0 cv=dttZ+ic4 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=-cimSzYHk1gA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=vyFtrNk3kBQA:10 a=D19gQVrFAAAA:8 a=VwQbUJbxAAAA:8 a=ayC55rCoAAAA:8 a=3nbZYyFuAAAA:8 a=XAOngT6EEgHB6CX87MsA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=EvKJbDF4Ut8A:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1353441387.6276.25.camel@gandalf.local.home>
Subject: [PATCH][GIT PULL] x86_32: Return actual stack when requesting sp
 from regs
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Tue, 20 Nov 2012 14:56:27 -0500
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo, Peter,

I posted this back in July as an RFC and did get Masami's reviewed-by
tag. I'm currently cleaning out my inbox and realized I didn't push this
further. I didn't know which branch to base this on, so I just picked
the tip/x86/asm branch where I did my last x86 work in.

https://lkml.org/lkml/2012/7/13/351

Please pull the latest tip/x86/asm tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/x86/asm

Head SHA1: 6c8d8b3c69cef1330e0c5cbc2a8b9268024927a0


Steven Rostedt (1):
      x86_32: Return actual stack when requesting sp from regs

----
 arch/x86/include/asm/ptrace.h |    9 +++++++++
 1 file changed, 9 insertions(+)
---------------------------
commit 6c8d8b3c69cef1330e0c5cbc2a8b9268024927a0
Author: Steven Rostedt <rostedt@goodmis.org>
Date:   Fri Jul 13 15:44:14 2012 -0400

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
 


