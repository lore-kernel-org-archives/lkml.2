Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548Ab2FEUhu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 16:37:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28808 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994Ab2FEUht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 16:37:49 -0400
X-Authority-Analysis: v=2.0 cv=NbpkJh/4 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=MiGSmKHM__4A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=3nbZYyFuAAAA:8 a=aVOjOETgf3rEe_Vfb8cA:9 a=PUjeQqilurYA:10 a=EvKJbDF4Ut8A:10 a=jeBq3FmKZ4MA:10 a=uoZH0MwEq3niU4kx:21 a=hyM0h5-Zy7eqW4oA:21 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1338928666.13348.538.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH -tip v2 3/9] ftrace/x86: Support SAVE_REGS feature on
 i386
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com
Date: Tue, 05 Jun 2012 16:37:46 -0400
In-Reply-To: <20120605102802.27845.49309.stgit@localhost.localdomain>
References: <20120605102734.27845.43401.stgit@localhost.localdomain>
	 <20120605102802.27845.49309.stgit@localhost.localdomain>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-05 at 19:28 +0900, Masami Hiramatsu wrote:
> Add register saving/restoring sequence in ftrace_caller
> on i386 for enabling SAVE_REGS feature.
> 
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> ---
> 
>  arch/x86/include/asm/ftrace.h |    2 +
>  arch/x86/kernel/entry_32.S    |   64 +++++++++++++++++++++++++++++++++++------
>  2 files changed, 56 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
> index ffb9564..e2f7269 100644
> --- a/arch/x86/include/asm/ftrace.h
> +++ b/arch/x86/include/asm/ftrace.h
> @@ -32,7 +32,7 @@
>  #define MCOUNT_ADDR		((long)(mcount))
>  #define MCOUNT_INSN_SIZE	5 /* sizeof mcount call */
>  
> -#if defined(CONFIG_DYNAMIC_FTRACE) && defined(CONFIG_X86_64)
> +#if defined(CONFIG_DYNAMIC_FTRACE)
>  #define ARCH_SUPPORTS_FTRACE_SAVE_REGS 1
>  #endif
>  
> diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
> index 01ccf9b..79c45a2 100644
> --- a/arch/x86/kernel/entry_32.S
> +++ b/arch/x86/kernel/entry_32.S
> @@ -1095,24 +1095,66 @@ ENTRY(mcount)
>  	ret
>  END(mcount)
>  
> +	.macro FTRACE_SAVE_ALL
> +	/* eflags is saved on cs */
> +	subl $8, %esp		/* skip ip and orig_ax */
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
> +	movl 14*4(%esp), %eax	/* Load return address */
> +	pushl %eax		/* Save return address (+4) */
> +	subl $MCOUNT_INSN_SIZE, %eax
> +	movl %eax, 12*4+4(%esp)	/* Store IP */
> +	movl 13*4+4(%esp), %edx	/* Load flags */
> +	movl %edx, 14*4+4(%esp)	/* Store flags */
> +	movl $__KERNEL_CS, %edx
> +	movl %edx, 13*4+4(%esp)
> +	.endm
> +
> +	.macro FTRACE_RESTORE_ALL
> +	movl 14*4+4(%esp), %eax	/* Load flags */
> +	movl %eax, 13*4+4(%esp)	/* Restore flags */
> +	popl %eax
> +	movl %eax, 14*4(%esp)	/* Restore return address */

I'm not sure we really need to restore all the regs. I'll keep this for
now, but for an optimization, we can just restore the ones that mcount
mcount needs to.

Or do you expect kprobes to change any of theses?


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
> +	addl $8, %esp
> +	.endm
> +
>  ENTRY(ftrace_caller)
> +	pushf	/* flags on regs->cs */
>  	cmpl $0, function_trace_stop
> -	jne  ftrace_stub
> +	jne  ftrace_exit
> +
> +	FTRACE_SAVE_ALL
>  
> -	pushl %eax
> -	pushl %ecx
> -	pushl %edx
> -	movl 0xc(%esp), %eax
>  	movl 0x4(%ebp), %edx
> -	subl $MCOUNT_INSN_SIZE, %eax
> +	lea  4(%esp), %ecx
>  
>  .globl ftrace_call
>  ftrace_call:
>  	call ftrace_stub
>  
> -	popl %edx
> -	popl %ecx
> -	popl %eax
> +	FTRACE_RESTORE_ALL
> +
> +	popf

Flags do not need to be restored. mcount calls give no guarantee that
flags will be persistent.

-- Steve

>  #ifdef CONFIG_FUNCTION_GRAPH_TRACER
>  .globl ftrace_graph_call
>  ftrace_graph_call:
> @@ -1122,6 +1164,10 @@ ftrace_graph_call:
>  .globl ftrace_stub
>  ftrace_stub:
>  	ret
> +
> +ftrace_exit:
> +	popf
> +	ret
>  END(ftrace_caller)
>  
>  #else /* ! CONFIG_DYNAMIC_FTRACE */


