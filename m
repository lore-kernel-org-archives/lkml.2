Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573Ab2GLMjr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 08:39:47 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:56840 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026Ab2GLMjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 08:39:46 -0400
X-AuditID: b753bd60-967eaba000006894-2c-4ffec58fe3d0
X-AuditID: b753bd60-967eaba000006894-2c-4ffec58fe3d0
Message-ID: <4FFEC58E.5070202@hitachi.com>
Date: Thu, 12 Jul 2012 21:39:42 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, yrl.pp-manager.tt@hitachi.com
Subject: Re: [RFC][PATCH 2/4 v4] ftrace/x86: Add save_regs for i386 function
 calls
References: <20120711195048.885039013@goodmis.org> <20120711195745.379060003@goodmis.org>
In-Reply-To: <20120711195745.379060003@goodmis.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/07/12 4:50), Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> Add saving full regs for function tracing on i386.
> The saving of regs was influenced by patches sent out by
> Masami Hiramatsu.
> 
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  arch/x86/include/asm/ftrace.h |    2 --
>  arch/x86/kernel/entry_32.S    |   58 +++++++++++++++++++++++++++++++++++++++++
>  arch/x86/kernel/ftrace.c      |    4 ---
>  3 files changed, 58 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
> index a847501..a6cae0c 100644
> --- a/arch/x86/include/asm/ftrace.h
> +++ b/arch/x86/include/asm/ftrace.h
> @@ -40,10 +40,8 @@
>  
>  #ifdef CONFIG_DYNAMIC_FTRACE
>  #define ARCH_SUPPORTS_FTRACE_OPS 1
> -#ifdef CONFIG_X86_64
>  #define ARCH_SUPPORTS_FTRACE_SAVE_REGS
>  #endif
> -#endif
>  
>  #ifndef __ASSEMBLY__
>  extern void mcount(void);
> diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
> index 5da11d1..8ef138f 100644
> --- a/arch/x86/kernel/entry_32.S
> +++ b/arch/x86/kernel/entry_32.S
> @@ -1123,6 +1123,7 @@ ftrace_call:
>  	popl %edx
>  	popl %ecx
>  	popl %eax
> +ftrace_ret:
>  #ifdef CONFIG_FUNCTION_GRAPH_TRACER
>  .globl ftrace_graph_call
>  ftrace_graph_call:
> @@ -1134,6 +1135,63 @@ ftrace_stub:
>  	ret
>  END(ftrace_caller)
>  
> +ENTRY(ftrace_regs_caller)
> +	pushf	/* push flags before compare (in ss location) */
> +	cmpl $0, function_trace_stop
> +	jne ftrace_restore_flags
> +
> +	pushl %esp	/* Save stack in sp location */
> +	subl $4, (%esp) /* Adjust saved stack to skip saved flags */
> +	pushl 4(%esp)	/* Save flags in correct position */
> +	movl $__KERNEL_DS, 8(%esp)	/* Save ss */
> +	pushl $__KERNEL_CS
> +	pushl 4*4(%esp)	/* Save the ip */
> +	subl $MCOUNT_INSN_SIZE, (%esp)	/* Adjust ip */
> +	pushl $0	/* Load 0 into orig_ax */

Oops, you might forget that the i386's interrupt stack layout is a bit
different from x86-64.

On x86-64, regs->sp directly points the top of stack.
On the other hand (i386), regs->sp IS the top of stack. You can see
below code in arch/x86/include/asm/ptrace.h
---
/*
 * X86_32 CPUs don't save ss and esp if the CPU is already in kernel mode
 * when it traps.  The previous stack will be directly underneath the saved
 * registers, and 'sp/ss' won't even have been saved. Thus the '&regs->sp'.
 *
 * This is valid only for kernel mode traps.
 */
static inline unsigned long kernel_stack_pointer(struct pt_regs *regs)
{
#ifdef CONFIG_X86_32
        return (unsigned long)(&regs->sp);
#else
        return regs->sp;
#endif
}
---

This means that you need a trick here.

	 sp-> [retaddr]
	(*)-> [orig_stack]

Here is the stack layout when the ftrace_regs_caller is called.
(*) points the original stack pointer. this means that regs->sp has
placed at (*). After doing pushf, it changed as below.

	                    (what user expects)
	 sp-> [flags]      <- regs.cs
	      [retaddr]    <- regs.flags
	(*)-> [orig_stack] <- regs.sp

So we have to change this stack layout as the user expected. That is
what I did it in my previous series;

https://lkml.org/lkml/2012/6/5/119

In this patch, I clobbered the return address on the stack and
stores it in the local stack because of that reason.

+	movl 14*4(%esp), %eax	/* Load return address */
+	pushl %eax		/* Save return address (+4) */
+	subl $MCOUNT_INSN_SIZE, %eax
+	movl %eax, 12*4+4(%esp)	/* Store IP */
+	movl 13*4+4(%esp), %edx	/* Load flags */
+	movl %edx, 14*4+4(%esp)	/* Store flags */
+	movl $__KERNEL_CS, %edx
+	movl %edx, 13*4+4(%esp)

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


