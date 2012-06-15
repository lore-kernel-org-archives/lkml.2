Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692Ab2FOGD4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 02:03:56 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:44630 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469Ab2FOGDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 02:03:54 -0400
X-AuditID: b753bd60-9f483ba000000655-cf-4fdad0474b27
X-AuditID: b753bd60-9f483ba000000655-cf-4fdad0474b27
Message-ID: <4FDAD044.7020706@hitachi.com>
Date: Fri, 15 Jun 2012 15:03:48 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [RFC][PATCH 06/13 v2] ftrace/x86: Add save_regs for i386 function
 calls
References: <20120612224327.426900129@goodmis.org> <20120612225425.673392850@goodmis.org>
In-Reply-To: <20120612225425.673392850@goodmis.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/06/13 7:43), Steven Rostedt wrote:
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
>  arch/x86/kernel/entry_32.S    |   53 +++++++++++++++++++++++++++++++++++++++++
>  arch/x86/kernel/ftrace.c      |    4 ----
>  3 files changed, 53 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
> index fd10faf..2b396cf 100644
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
> index acd4963..f22802c 100644
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
> @@ -1134,6 +1135,58 @@ ftrace_stub:
>  	ret
>  END(ftrace_caller)
>  
> +ENTRY(ftrace_regs_caller)
> +	pushf	/* push flags before compare */
> +	cmpl $0, function_trace_stop
> +	jne ftrace_exit
> +
> +	subl $8, %esp	/* skip ip and orig_ax */
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
> +	movl %edx, 13*4+4(%esp)	/* Store CS */
> +
> +	movl 0x4(%ebp), %edx
> +	lea  4(%esp), %ecx
> +	pushl %ecx		/* Save pt_regs as 4th parameter */
> +	leal function_trace_op, %ecx
> +
> +GLOBAL(ftrace_regs_call)
> +	call ftrace_stub
> +
> +	addl $4,%esp		/* Skip pt_regs */
> +	popl %eax
> +	movl %eax, 14*4(%esp)	/* Restore return address */
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
> +ftrace_exit:
> +	addl $4, %esp		/* Skip eflags */

Hmm, why don't you recover eflags, as x86-64 has done?
IMHO, it should be recovered if ftrace-based kprobe is
a transparent acceleration.

Thank you,



-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
