Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751643Ab2GSM6G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 08:58:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3019 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab2GSM6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 08:58:03 -0400
X-Authority-Analysis: v=2.0 cv=ZuBv2qHG c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=XNQpylE1qVEA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=U3rUCODqTWbS5THb3CUA:9 a=PUjeQqilurYA:10 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Message-ID: <1342702682.12353.20.camel@gandalf.stny.rr.com>
Subject: Re: Re: [RFC][PATCH 2/4 v4] ftrace/x86: Add save_regs for i386
 function calls
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, yrl.pp-manager.tt@hitachi.com
Date: Thu, 19 Jul 2012 08:58:02 -0400
In-Reply-To: <1342702344.12353.16.camel@gandalf.stny.rr.com>
References: <20120711195048.885039013@goodmis.org>
	 <20120711195745.379060003@goodmis.org> <4FFEC58E.5070202@hitachi.com>
	 <1342205273.30075.19.camel@gandalf.stny.rr.com>
	 <1342627145.11900.7.camel@gandalf.stny.rr.com>
	 <50076ED9.3000100@hitachi.com>
	 <1342702344.12353.16.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-19 at 08:52 -0400, Steven Rostedt wrote:
>  
>  GLOBAL(ftrace_regs_call)
>  	call ftrace_stub
> @@ -1195,8 +1194,8 @@ GLOBAL(ftrace_regs_call)
>  	popl %es
>  	popl %fs
>  	popl %gs
> -	addl $8, %esp		/* Skip orig_ax and ip */
> -	popf			/* Pop flags at end (no addl to corrupt flags) */
> +	lea 8(%esp), %esp	/* Skip orig_ax and ip */
> +	popf			/* Pop flags at end */
>  	jmp ftrace_ret
>  
>  ftrace_restore_flags:
> 
> 
> Because we no longer have that 4 byte offset on the stack when we need
> to load the 4th parameter, we can just load the current stack pointer
> into the stack (pushl %esp), without the save to %ecx step.
> 
> also, because lea is faster than add (and doesn't even modify flags), I
> changed the last part to use lea instead of addl.

Now I'm told that this is not always the case (at least not for Atom),
so I reverted this part and put back the addl. But can you still give
you reviewed by for the first part?

> 
> Can you give your reviewed-by tag for this too? I'd like to push this
> out today so we can still make 3.6.
> 
> Thanks!
> 
> -- Steve
> 
> here's the full patch:
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
> index 5da11d1..ca5a146 100644
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
> @@ -1134,6 +1135,72 @@ ftrace_stub:
>  	ret
>  END(ftrace_caller)
>  
> +ENTRY(ftrace_regs_caller)
> +	pushf	/* push flags before compare (in cs location) */
> +	cmpl $0, function_trace_stop
> +	jne ftrace_restore_flags
> +
> +	/*
> +	 * i386 does not save SS and ESP when coming from kernel.
> +	 * Instead, to get sp, &regs->sp is used (see ptrace.h).
> +	 * Unfortunately, that means eflags must be at the same location
> +	 * as the current return ip is. We move the return ip into the
> +	 * ip location, and move flags into the return ip location.
> +	 */
> +	pushl 4(%esp)	/* save return ip into ip slot */
> +	subl $MCOUNT_INSN_SIZE, (%esp)	/* Adjust ip */
> +
> +	pushl $0	/* Load 0 into orig_ax */
> +	pushl %gs
> +	pushl %fs
> +	pushl %es
> +	pushl %ds
> +	pushl %eax
> +	pushl %ebp
> +	pushl %edi
> +	pushl %esi
> +	pushl %edx
> +	pushl %ecx
> +	pushl %ebx
> +
> +	movl 13*4(%esp), %eax	/* Get the saved flags */
> +	movl %eax, 14*4(%esp)	/* Move saved flags into regs->flags location */
> +				/* clobbering return ip */
> +	movl $__KERNEL_CS,13*4(%esp)
> +
> +	movl 12*4(%esp), %eax	/* Load ip (1st parameter) */
> +	movl 0x4(%ebp), %edx	/* Load parent ip (2nd parameter) */
> +	leal function_trace_op, %ecx /* Save ftrace_pos in 3rd parameter */
> +	pushl %esp		/* Save pt_regs as 4th parameter */
> +
> +GLOBAL(ftrace_regs_call)
> +	call ftrace_stub
> +
> +	addl $4, %esp		/* Skip pt_regs */
> +	movl 14*4(%esp), %eax	/* Move flags back into cs */
> +	movl %eax, 13*4(%esp)	/* Needed to keep addl from modifying flags */
> +	movl 12*4(%esp), %eax	/* Get return ip from regs->ip */
> +	addl $MCOUNT_INSN_SIZE, %eax
> +	movl %eax, 14*4(%esp)	/* Put return ip back for ret */
> +
> +	popl %ebx
> +	popl %ecx
> +	popl %edx
> +	popl %esi
> +	popl %edi
> +	popl %ebp
> +	popl %eax
> +	popl %ds
> +	popl %es
> +	popl %fs
> +	popl %gs
+	addl $8, %esp		/* Skip orig_ax and ip */
+	popf			/* Pop flags at end (no addl to corrupt flags) */

The above has been changed to this again.

-- Steve

> +	jmp ftrace_ret
> +
> +ftrace_restore_flags:
> +	popf
> +	jmp  ftrace_stub
>  #else /* ! CONFIG_DYNAMIC_FTRACE */
>  
>  ENTRY(mcount)
> diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
> index b90eb1a..1d41402 100644
> --- a/arch/x86/kernel/ftrace.c
> +++ b/arch/x86/kernel/ftrace.c
> @@ -206,7 +206,6 @@ static int
>  ftrace_modify_code(unsigned long ip, unsigned const char *old_code,
>  		   unsigned const char *new_code);
>  
> -#ifdef ARCH_SUPPORTS_FTRACE_SAVE_REGS
>  /*
>   * Should never be called:
>   *  As it is only called by __ftrace_replace_code() which is called by
> @@ -221,7 +220,6 @@ int ftrace_modify_call(struct dyn_ftrace *rec, unsigned long old_addr,
>  	WARN_ON(1);
>  	return -EINVAL;
>  }
> -#endif
>  
>  int ftrace_update_ftrace_func(ftrace_func_t func)
>  {
> @@ -237,7 +235,6 @@ int ftrace_update_ftrace_func(ftrace_func_t func)
>  
>  	ret = ftrace_modify_code(ip, old, new);
>  
> -#ifdef ARCH_SUPPORTS_FTRACE_SAVE_REGS
>  	/* Also update the regs callback function */
>  	if (!ret) {
>  		ip = (unsigned long)(&ftrace_regs_call);
> @@ -245,7 +242,6 @@ int ftrace_update_ftrace_func(ftrace_func_t func)
>  		new = ftrace_call_replace(ip, (unsigned long)func);
>  		ret = ftrace_modify_code(ip, old, new);
>  	}
> -#endif
>  
>  	atomic_dec(&modifying_ftrace_code);
>  
> 
> 


