Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756611Ab1BPDhD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 22:37:03 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:58991 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706Ab1BPDg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 22:36:57 -0500
X-AuditID: b753bd60-a24c5ba0000066fd-88-4d5b4656808e
X-AuditID: b753bd60-a24c5ba0000066fd-88-4d5b4656808e
Message-ID: <4D5B4654.30407@hitachi.com>
Date: Wed, 16 Feb 2011 12:36:52 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
Cc: mingo@elte.hu, ananth@in.ibm.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kprobes - do not allow optimized kprobes in entry code
References: <1297696354-6990-1-git-send-email-jolsa@redhat.com> <4D5A4A66.4010503@hitachi.com> <20110215123058.GB3135@jolsa.brq.redhat.com> <4D5AA209.7070309@hitachi.com> <20110215170507.GD3135@jolsa.brq.redhat.com>
In-Reply-To: <20110215170507.GD3135@jolsa.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/02/16 2:05), Jiri Olsa wrote:
> You can crash the kernel using kprobe tracer by running:
> 
> echo "p system_call_after_swapgs" > ./kprobe_events
> echo 1 > ./events/kprobes/enable
> 
> The reason is that at the system_call_after_swapgs label, the kernel
> stack is not set up. If optimized kprobes are enabled, the user space
> stack is being used in this case (see optimized kprobe template) and
> this might result in a crash.
> 
> There are several places like this over the entry code (entry_$BIT).
> As it seems there's no any reasonable/maintainable way to disable only
> those places where the stack is not ready, I switched off the whole
> entry code from kprobe optimizing.

Agreed, and this could be the best way, because kprobes can not
know where the kernel stack is ready without this text section.

> 
> wbr,
> jirka
> 
>
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>

Looks good for me :)

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

> ---
>  arch/x86/ia32/ia32entry.S         |    2 ++
>  arch/x86/kernel/entry_32.S        |    6 ++++--
>  arch/x86/kernel/entry_64.S        |    6 ++++--
>  arch/x86/kernel/kprobes.c         |    8 ++++++++
>  arch/x86/kernel/vmlinux.lds.S     |    1 +
>  include/asm-generic/sections.h    |    1 +
>  include/asm-generic/vmlinux.lds.h |    6 ++++++
>  7 files changed, 26 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
> index 0ed7896..50f1630 100644
> --- a/arch/x86/ia32/ia32entry.S
> +++ b/arch/x86/ia32/ia32entry.S
> @@ -25,6 +25,8 @@
>  #define sysretl_audit ia32_ret_from_sys_call
>  #endif
>  
> +	.section .entry.text, "ax"
> +
>  #define IA32_NR_syscalls ((ia32_syscall_end - ia32_sys_call_table)/8)
>  
>  	.macro IA32_ARG_FIXUP noebp=0
> diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
> index c8b4efa..f5accf8 100644
> --- a/arch/x86/kernel/entry_32.S
> +++ b/arch/x86/kernel/entry_32.S
> @@ -65,6 +65,8 @@
>  #define sysexit_audit	syscall_exit_work
>  #endif
>  
> +	.section .entry.text, "ax"
> +
>  /*
>   * We use macros for low-level operations which need to be overridden
>   * for paravirtualization.  The following will never clobber any registers:
> @@ -788,7 +790,7 @@ ENDPROC(ptregs_clone)
>   */
>  .section .init.rodata,"a"
>  ENTRY(interrupt)
> -.text
> +.section .entry.text, "ax"
>  	.p2align 5
>  	.p2align CONFIG_X86_L1_CACHE_SHIFT
>  ENTRY(irq_entries_start)
> @@ -807,7 +809,7 @@ vector=FIRST_EXTERNAL_VECTOR
>        .endif
>        .previous
>  	.long 1b
> -      .text
> +      .section .entry.text, "ax"
>  vector=vector+1
>      .endif
>    .endr
> diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
> index 891268c..39f8d21 100644
> --- a/arch/x86/kernel/entry_64.S
> +++ b/arch/x86/kernel/entry_64.S
> @@ -61,6 +61,8 @@
>  #define __AUDIT_ARCH_LE	   0x40000000
>  
>  	.code64
> +	.section .entry.text, "ax"
> +
>  #ifdef CONFIG_FUNCTION_TRACER
>  #ifdef CONFIG_DYNAMIC_FTRACE
>  ENTRY(mcount)
> @@ -744,7 +746,7 @@ END(stub_rt_sigreturn)
>   */
>  	.section .init.rodata,"a"
>  ENTRY(interrupt)
> -	.text
> +	.section .entry.text
>  	.p2align 5
>  	.p2align CONFIG_X86_L1_CACHE_SHIFT
>  ENTRY(irq_entries_start)
> @@ -763,7 +765,7 @@ vector=FIRST_EXTERNAL_VECTOR
>        .endif
>        .previous
>  	.quad 1b
> -      .text
> +      .section .entry.text
>  vector=vector+1
>      .endif
>    .endr
> diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
> index d91c477..d03bc1e 100644
> --- a/arch/x86/kernel/kprobes.c
> +++ b/arch/x86/kernel/kprobes.c
> @@ -1276,6 +1276,14 @@ static int __kprobes can_optimize(unsigned long paddr)
>  	if (!kallsyms_lookup_size_offset(paddr, &size, &offset))
>  		return 0;
>  
> +	/*
> +	 * Do not optimize in the entry code due to the unstable
> +	 * stack handling.
> +	 */
> +	if ((paddr >= (unsigned long ) __entry_text_start) &&
> +	    (paddr <  (unsigned long ) __entry_text_end))
> +		return 0;
> +
>  	/* Check there is enough space for a relative jump. */
>  	if (size - offset < RELATIVEJUMP_SIZE)
>  		return 0;
> diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
> index e9f7a3c..0381e1f 100644
> --- a/arch/x86/kernel/vmlinux.lds.S
> +++ b/arch/x86/kernel/vmlinux.lds.S
> @@ -105,6 +105,7 @@ SECTIONS
>  		SCHED_TEXT
>  		LOCK_TEXT
>  		KPROBES_TEXT
> +		ENTRY_TEXT
>  		IRQENTRY_TEXT
>  		*(.fixup)
>  		*(.gnu.warning)
> diff --git a/include/asm-generic/sections.h b/include/asm-generic/sections.h
> index b3bfabc..c1a1216 100644
> --- a/include/asm-generic/sections.h
> +++ b/include/asm-generic/sections.h
> @@ -11,6 +11,7 @@ extern char _sinittext[], _einittext[];
>  extern char _end[];
>  extern char __per_cpu_load[], __per_cpu_start[], __per_cpu_end[];
>  extern char __kprobes_text_start[], __kprobes_text_end[];
> +extern char __entry_text_start[], __entry_text_end[];
>  extern char __initdata_begin[], __initdata_end[];
>  extern char __start_rodata[], __end_rodata[];
>  
> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> index fe77e33..906c3ce 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -424,6 +424,12 @@
>  		*(.kprobes.text)					\
>  		VMLINUX_SYMBOL(__kprobes_text_end) = .;
>  
> +#define ENTRY_TEXT							\
> +		ALIGN_FUNCTION();					\
> +		VMLINUX_SYMBOL(__entry_text_start) = .;			\
> +		*(.entry.text)						\
> +		VMLINUX_SYMBOL(__entry_text_end) = .;
> +
>  #ifdef CONFIG_FUNCTION_GRAPH_TRACER
>  #define IRQENTRY_TEXT							\
>  		ALIGN_FUNCTION();					\


-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
