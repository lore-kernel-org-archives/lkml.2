Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030853Ab2GMSsi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 14:48:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24293 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932362Ab2GMSrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 14:47:55 -0400
X-Authority-Analysis: v=2.0 cv=ZuBv2qHG c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=kEgnM1vrZgIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=D19gQVrFAAAA:8 a=20KFwNOVAAAA:8 a=3nbZYyFuAAAA:8 a=7K6oyXyB5EfG9VQoveUA:9 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=EvKJbDF4Ut8A:10 a=jeBq3FmKZ4MA:10 a=d6axiJYY_VfI_Dl1:21 a=ERzC0ZoU8Uans6XQ:21 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Message-ID: <1342205273.30075.19.camel@gandalf.stny.rr.com>
Subject: Re: [RFC][PATCH 2/4 v4] ftrace/x86: Add save_regs for i386 function
 calls
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, yrl.pp-manager.tt@hitachi.com
Date: Fri, 13 Jul 2012 14:47:53 -0400
In-Reply-To: <4FFEC58E.5070202@hitachi.com>
References: <20120711195048.885039013@goodmis.org>
	 <20120711195745.379060003@goodmis.org> <4FFEC58E.5070202@hitachi.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-12 at 21:39 +0900, Masami Hiramatsu wrote:

> /*
>  * X86_32 CPUs don't save ss and esp if the CPU is already in kernel mode
>  * when it traps.  The previous stack will be directly underneath the saved
>  * registers, and 'sp/ss' won't even have been saved. Thus the '&regs->sp'.
>  *
>  * This is valid only for kernel mode traps.
>  */
> static inline unsigned long kernel_stack_pointer(struct pt_regs *regs)
> {
> #ifdef CONFIG_X86_32
>         return (unsigned long)(&regs->sp);
> #else
>         return regs->sp;
> #endif
> }

I found that regs_get_register() doesn't honor this either. Thus,
kprobes in tracing gets this:

 # echo 'p:ftrace sys_read+4 s=%sp' > /debug/tracing/kprobe_events
 # echo 1 > /debug/tracing/events/kprobes/enable
 # cat trace
            sshd-1345  [000] d...   489.117168: ftrace: (sys_read+0x4/0x70) s=b7e96768
            sshd-1345  [000] d...   489.117191: ftrace: (sys_read+0x4/0x70) s=b7e96768
             cat-1447  [000] d...   489.117392: ftrace: (sys_read+0x4/0x70) s=5a7
             cat-1447  [001] d...   489.118023: ftrace: (sys_read+0x4/0x70) s=b77ad05f
            less-1448  [000] d...   489.118079: ftrace: (sys_read+0x4/0x70) s=b7762e06
            less-1448  [000] d...   489.118117: ftrace: (sys_read+0x4/0x70) s=b7764970

Note, I added +4 (which is still a normal kprobe, and not a ftrace one)
because it updates the stack where regs->sp would definitely not be a
kernel stack.

This patch fixes it:

diff --git a/arch/x86/include/asm/ptrace.h b/arch/x86/include/asm/ptrace.h
index dcfde52..b1e0f53 100644
--- a/arch/x86/include/asm/ptrace.h
+++ b/arch/x86/include/asm/ptrace.h
@@ -246,6 +246,11 @@ static inline unsigned long regs_get_register(struct pt_regs *regs,
 {
 	if (unlikely(offset > MAX_REG_OFFSET))
 		return 0;
+#ifdef CONFIG_X86_32
+	if (offset == offsetof(struct pt_regs, sp) &&
+	    regs->cs == __KERNEL_CS)
+		return kernel_stack_pointer(regs);
+#endif
 	return *(unsigned long *)((unsigned long)regs + offset);
 }
 
            sshd-1352  [000] d...   362.348016: ftrace: (sys_read+0x4/0x70) s=f3febfa8
            sshd-1352  [000] d...   362.348048: ftrace: (sys_read+0x4/0x70) s=f3febfa8
            bash-1355  [001] d...   362.348081: ftrace: (sys_read+0x4/0x70) s=f5075fa8
            sshd-1352  [000] d...   362.348082: ftrace: (sys_read+0x4/0x70) s=f3febfa8
            sshd-1352  [000] d...   362.690950: ftrace: (sys_read+0x4/0x70) s=f3febfa8
            bash-1355  [001] d...   362.691033: ftrace: (sys_read+0x4/0x70) s=f5075fa8

I'll post that patch separately.

> ---
> 
> This means that you need a trick here.
> 
> 	 sp-> [retaddr]
> 	(*)-> [orig_stack]
> 
> Here is the stack layout when the ftrace_regs_caller is called.
> (*) points the original stack pointer. this means that regs->sp has
> placed at (*). After doing pushf, it changed as below.
> 
> 	                    (what user expects)
> 	 sp-> [flags]      <- regs.cs
> 	      [retaddr]    <- regs.flags
> 	(*)-> [orig_stack] <- regs.sp
> 
> So we have to change this stack layout as the user expected. That is
> what I did it in my previous series;
> 
> https://lkml.org/lkml/2012/6/5/119
> 
> In this patch, I clobbered the return address on the stack and
> stores it in the local stack because of that reason.
> 
> +	movl 14*4(%esp), %eax	/* Load return address */
> +	pushl %eax		/* Save return address (+4) */
> +	subl $MCOUNT_INSN_SIZE, %eax
> +	movl %eax, 12*4+4(%esp)	/* Store IP */
> +	movl 13*4+4(%esp), %edx	/* Load flags */
> +	movl %edx, 14*4+4(%esp)	/* Store flags */
> +	movl $__KERNEL_CS, %edx
> +	movl %edx, 13*4+4(%esp)

I did something slightly different but basically the same. Here's the
new version:

-- Steve

From: Steven Rostedt <srostedt@redhat.com>
Date: Tue, 5 Jun 2012 20:00:11 -0400
Subject: [PATCH] ftrace/x86: Add save_regs for i386 function calls

Add saving full regs for function tracing on i386.
The saving of regs was influenced by patches sent out by
Masami Hiramatsu.

Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/include/asm/ftrace.h |    2 -
 arch/x86/kernel/entry_32.S    |   68 +++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/ftrace.c      |    4 --
 3 files changed, 68 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
index a847501..a6cae0c 100644
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
index 5da11d1..46caa56 100644
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
@@ -1134,6 +1135,73 @@ ftrace_stub:
 	ret
 END(ftrace_caller)
 
+ENTRY(ftrace_regs_caller)
+	pushf	/* push flags before compare (in cs location) */
+	cmpl $0, function_trace_stop
+	jne ftrace_restore_flags
+
+	/*
+	 * i386 does not save SS and ESP when coming from kernel.
+	 * Instead, to get sp, &regs->sp is used (see ptrace.h).
+	 * Unfortunately, that means eflags must be at the same location
+	 * as the current return ip is. We move the return ip into the
+	 * ip location, and move flags into the return ip location.
+	 */
+	pushl 4(%esp)	/* save return ip into ip slot */
+	subl $MCOUNT_INSN_SIZE, (%esp)	/* Adjust ip */
+
+	pushl $0	/* Load 0 into orig_ax */
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
+
+	movl 13*4(%esp), %eax	/* Get the saved flags */
+	movl %eax, 14*4(%esp)	/* Move saved flags into regs->flags location */
+				/* clobbering return ip */
+	movl $__KERNEL_CS,13*4(%esp)
+
+	movl 12*4(%esp), %eax	/* Load ip (1st parameter) */
+	movl 0x4(%ebp), %edx	/* Load parent ip (2cd parameter) */
+	lea  (%esp), %ecx
+	pushl %ecx		/* Save pt_regs as 4th parameter */
+	leal function_trace_op, %ecx /* Save ftrace_pos in 3rd parameter */
+
+GLOBAL(ftrace_regs_call)
+	call ftrace_stub
+
+	addl $4, %esp		/* Skip pt_regs */
+	movl 14*4(%esp), %eax	/* Move flags back into cs */
+	movl %eax, 13*4(%esp)	/* Needed to keep addl from modifying flags */
+	movl 12*4(%esp), %eax	/* Get return ip from regs->ip */
+	addl $MCOUNT_INSN_SIZE, %eax
+	movl %eax, 14*4(%esp)	/* Put return ip back for ret */
+
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
+	addl $8, %esp		/* Skip orig_ax and ip */
+	popf			/* Pop flags at end (no addl to corrupt flags) */
+	jmp ftrace_ret
+
+ftrace_restore_flags:
+	popf
+	jmp  ftrace_stub
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
1.7.3.4



