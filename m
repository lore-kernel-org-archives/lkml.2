Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753617Ab1BVDWx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 22:22:53 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:47816 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535Ab1BVDWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 22:22:52 -0500
X-AuditID: b753bd60-a5abcba000004916-d7-4d632c09420f
X-AuditID: b753bd60-a5abcba000004916-d7-4d632c09420f
Message-ID: <4D632C07.6090205@hitachi.com>
Date: Tue, 22 Feb 2011 12:22:47 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
Cc: mingo@elte.hu, acme@redhat.com, fweisbec@gmail.com, hpa@zytor.com,
        ananth@in.ibm.com, davem@davemloft.net, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, a.p.zijlstra@chello.nl, eric.dumazet@gmail.com,
        2nddept-manager@sdl.hitachi.co.jp,
        "2nddept-manager@sdl.hitachi.co.jp" 
	<2nddept-manager@sdl.hitachi.co.jp>
Subject: Re: [PATCH 1/2] x86: separating entry text section
References: <20110220125948.GC25700@elte.hu> <1298298313-5980-1-git-send-email-jolsa@redhat.com> <1298298313-5980-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1298298313-5980-2-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/02/21 23:25), Jiri Olsa wrote:
> Putting x86 entry code to the separate section: .entry.text.
> 
> Separating the entry text section seems to have performance
> benefits with regards to the instruction cache usage.
> 
> Running hackbench showed that the change compresses the icache
> footprint. The icache miss rate went down by about 8%:
> 
> before patch:
>      26282174  L1-icache-load-misses      ( +-   0.099% )  (scaled from 81.00%)
> 
> after patch:
>      24237651  L1-icache-load-misses      ( +-   0.117% )  (scaled from 80.96%)
> 
> 
> Whole perf output follows.
> 
> - results for current tip tree:
> 
>  Performance counter stats for './hackbench/hackbench 10' (500 runs):
> 
>     817646684  L1-icache-loads            ( +-   0.150% )  (scaled from 80.99%)
>      26282174  L1-icache-load-misses      ( +-   0.099% )  (scaled from 81.00%)
>        211864  L1-icache-prefetches       ( +-   0.616% )  (scaled from 80.99%)
> <not counted>  L1-icache-prefetch-misses
>     817646737  iTLB-loads                 ( +-   0.151% )  (scaled from 80.98%)
>         82368  iTLB-load-misses           ( +-   0.451% )  (scaled from 80.98%)
> 
>   0.206651959  seconds time elapsed   ( +-   0.152% )
> 
> 
> - results for current tip tree with the patch applied are:
> 
>  Performance counter stats for './hackbench/hackbench 10' (500 runs):
> 
>     960162049  L1-icache-loads            ( +-   0.114% )  (scaled from 80.95%)
>      24237651  L1-icache-load-misses      ( +-   0.117% )  (scaled from 80.96%)
>        179800  L1-icache-prefetches       ( +-   0.530% )  (scaled from 80.95%)
> <not counted>  L1-icache-prefetch-misses
>     960352725  iTLB-loads                 ( +-   0.114% )  (scaled from 80.93%)
>         84410  iTLB-load-misses           ( +-   0.491% )  (scaled from 80.92%)
> 
>   0.210509948  seconds time elapsed   ( +-   0.140% )
> 
> 
> wbr,
> jirka
> 
> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thanks!

> ---
>  arch/x86/ia32/ia32entry.S         |    2 ++
>  arch/x86/kernel/entry_32.S        |    6 ++++--
>  arch/x86/kernel/entry_64.S        |    6 ++++--
>  arch/x86/kernel/vmlinux.lds.S     |    1 +
>  include/asm-generic/sections.h    |    1 +
>  include/asm-generic/vmlinux.lds.h |    6 ++++++
>  6 files changed, 18 insertions(+), 4 deletions(-)
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
> diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
> index e70cc3d..459dce2 100644
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
