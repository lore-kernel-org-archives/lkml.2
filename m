Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934Ab2E2XFb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 19:05:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20131 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755844Ab2E2XF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 19:05:29 -0400
X-Authority-Analysis: v=2.0 cv=PqgRnnw3 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=75BMjhiLndgA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=3nbZYyFuAAAA:8 a=82JP02mcxBk9sS2aJ_AA:9 a=PUjeQqilurYA:10 a=EvKJbDF4Ut8A:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1338332727.13348.301.camel@gandalf.stny.rr.com>
Subject: Re: [RFC PATCH -tip 2/9] ftrace/x86-64: support SAVE_REGS feature
 on x86-64
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com
Date: Tue, 29 May 2012 19:05:27 -0400
In-Reply-To: <20120529124905.9191.91563.stgit@localhost.localdomain>
References: <20120529124833.9191.23007.stgit@localhost.localdomain>
	 <20120529124905.9191.91563.stgit@localhost.localdomain>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-29 at 21:49 +0900, Masami Hiramatsu wrote:
> Add register saving/restoring sequence in ftrace_caller
> on x86-64 for enabling SAVE_REGS feature.
> 
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> ---
> 
>  arch/x86/include/asm/ftrace.h |    4 ++++
>  arch/x86/kernel/entry_64.S    |   38 +++++++++++++++++++++++++++++++++-----
>  2 files changed, 37 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
> index 18d9005..ffb9564 100644
> --- a/arch/x86/include/asm/ftrace.h
> +++ b/arch/x86/include/asm/ftrace.h
> @@ -32,6 +32,10 @@
>  #define MCOUNT_ADDR		((long)(mcount))
>  #define MCOUNT_INSN_SIZE	5 /* sizeof mcount call */
>  
> +#if defined(CONFIG_DYNAMIC_FTRACE) && defined(CONFIG_X86_64)
> +#define ARCH_SUPPORTS_FTRACE_SAVE_REGS 1
> +#endif
> +
>  #ifndef __ASSEMBLY__
>  extern void mcount(void);
>  extern int modifying_ftrace_code;
> diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
> index 320852d..6d0545b 100644
> --- a/arch/x86/kernel/entry_64.S
> +++ b/arch/x86/kernel/entry_64.S
> @@ -73,21 +73,44 @@ ENTRY(mcount)
>  	retq
>  END(mcount)
>  
> +	.macro MCOUNT_SAVE_ALL
> +	SAVE_ARGS (RSP-ORIG_RAX)
> +	SAVE_REST
> +	/* Adjust eflags, rsp and rip */
> +	movq RSP(%rsp), %rdx
> +	movq %rdx, EFLAGS(%rsp)
> +	leaq SS+8(%rsp), %rdx
> +	movq %rdx, RSP(%rsp)
> +	movq SS(%rsp), %rdi
> +	subq $MCOUNT_INSN_SIZE, %rdi
> +	movq %rdi, RIP(%rsp)
> +	.endm
> +
> +	.macro MCOUNT_RESTORE_ALL
> +	/* store eflags into regs->rsp */
> +	movq EFLAGS(%rsp), %rax
> +	movq %rax, RSP(%rsp)
> +	RESTORE_REST
> +	RESTORE_ARGS 1, (RSP-ORIG_RAX)
> +	.endm
> +
>  ENTRY(ftrace_caller)
> +	CFI_STARTPROC	simple
> +	pushfq_cfi
>  	cmpl $0, function_trace_stop
> -	jne  ftrace_stub
> +	jne  ftrace_exit
>  
> -	MCOUNT_SAVE_FRAME
> +	MCOUNT_SAVE_ALL

No! Please do not make ftrace save all regs for everyone. This is
critical. This will slow down function tracing even more. We do not need
to save all regs for every function call, unless it is asked for.

It should only save all regs if the ftrace_ops that is registered asked
for it. I had code that actually does that. I can merge your patches
with them if you would like.

Thanks,

-- Steve

>  
> -	movq 0x38(%rsp), %rdi
>  	movq 8(%rbp), %rsi
> -	subq $MCOUNT_INSN_SIZE, %rdi
> +	movq %rsp, %rdx
>  
>  GLOBAL(ftrace_call)
>  	call ftrace_stub
>  
> -	MCOUNT_RESTORE_FRAME
> +	MCOUNT_RESTORE_ALL
>  
> +	popfq_cfi
>  #ifdef CONFIG_FUNCTION_GRAPH_TRACER
>  GLOBAL(ftrace_graph_call)
>  	jmp ftrace_stub
> @@ -95,6 +118,11 @@ GLOBAL(ftrace_graph_call)
>  
>  GLOBAL(ftrace_stub)
>  	retq
> +
> +ftrace_exit:
> +	popfq_cfi
> +	retq
> +	CFI_ENDPROC
>  END(ftrace_caller)
>  
>  #else /* ! CONFIG_DYNAMIC_FTRACE */


