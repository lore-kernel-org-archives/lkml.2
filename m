Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731Ab1CGOYg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 09:24:36 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55875 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021Ab1CGOYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 09:24:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=F92bL7tY4J27yhYWk9L9T7GBG5er5RVr2x+f8WzoRCn4luw27hA8LszdszzvuI0lA+
         gAr3nsSMq72cFjZxL93M7ViiIlkNQfHsc4mO14/zVseOe8OEMC9GiXCJUVTzTAXA/4mL
         s08sYSL2i0BP/uRgbrrduchI92d30TRy30fdI=
Date: Mon, 7 Mar 2011 15:24:28 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Soren Sandmann <ssp@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH v3 -tip] x86, dumpstack: Correct stack dump info when
 frame pointer is available
Message-ID: <20110307142424.GC1873@nowhere>
References: <1299238879-27792-1-git-send-email-namhyung@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299238879-27792-1-git-send-email-namhyung@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 04, 2011 at 08:41:19PM +0900, Namhyung Kim wrote:
> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> index 9d977a2ea693..53a770ef4eaf 100644
> --- a/arch/x86/kernel/cpu/perf_event.c
> +++ b/arch/x86/kernel/cpu/perf_event.c
> @@ -1722,7 +1722,7 @@ perf_callchain_kernel(struct perf_callchain_entry *entry, struct pt_regs *regs)
>  
>  	perf_callchain_store(entry, regs->ip);
>  
> -	dump_trace(NULL, regs, NULL, &backtrace_ops, entry);
> +	dump_trace(NULL, regs, NULL, regs->bp, &backtrace_ops, entry);

I think this should be fine to push 0 instead of regs->bp because
stack_frame() will retrieve the value already.

That doesn't change anything except for the reviewer who won't need
to stick at trying to understand why we override the stack frame over the
default one in regs.

> diff --git a/arch/x86/kernel/dumpstack_32.c b/arch/x86/kernel/dumpstack_32.c
> index 74cc1eda384b..c99f9ed013d5 100644
> --- a/arch/x86/kernel/dumpstack_32.c
> +++ b/arch/x86/kernel/dumpstack_32.c
> @@ -17,12 +17,11 @@
>  #include <asm/stacktrace.h>
>  
>  
> -void dump_trace(struct task_struct *task,
> -		struct pt_regs *regs, unsigned long *stack,
> +void dump_trace(struct task_struct *task, struct pt_regs *regs,
> +		unsigned long *stack, unsigned long bp,
>  		const struct stacktrace_ops *ops, void *data)
>  {
>  	int graph = 0;
> -	unsigned long bp;
>  
>  	if (!task)
>  		task = current;
> @@ -35,7 +34,9 @@ void dump_trace(struct task_struct *task,
>  			stack = (unsigned long *)task->thread.sp;
>  	}
>  
> -	bp = stack_frame(task, regs);
> +	if (!bp)
> +		bp = stack_frame(task, regs);
> +
>  	for (;;) {
>  		struct thread_info *context;
>  
> @@ -55,7 +56,7 @@ EXPORT_SYMBOL(dump_trace);
>  
>  void
>  show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
> -		   unsigned long *sp, char *log_lvl)
> +		   unsigned long *sp, unsigned long bp, char *log_lvl)
>  {
>  	unsigned long *stack;
>  	int i;
> @@ -77,7 +78,7 @@ show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
>  		touch_nmi_watchdog();
>  	}
>  	printk(KERN_CONT "\n");
> -	show_trace_log_lvl(task, regs, sp, log_lvl);
> +	show_trace_log_lvl(task, regs, sp, bp, log_lvl);
>  }
>  
>  
> @@ -102,7 +103,7 @@ void show_registers(struct pt_regs *regs)
>  		u8 *ip;
>  
>  		printk(KERN_EMERG "Stack:\n");
> -		show_stack_log_lvl(NULL, regs, &regs->sp, KERN_EMERG);
> +		show_stack_log_lvl(NULL, regs, &regs->sp, 0, KERN_EMERG);

&regs->sp ? That looks wrong. But that's outside the scope of this patch.

>  
>  		printk(KERN_EMERG "Code: ");
>  
> @@ -115,16 +116,16 @@ void show_registers(struct pt_regs *regs)
>  		for (i = 0; i < code_len; i++, ip++) {
>  			if (ip < (u8 *)PAGE_OFFSET ||
>  					probe_kernel_address(ip, c)) {
> -				printk(" Bad EIP value.");
> +				printk(KERN_CONT " Bad EIP value.");

All these KERN_CONT changes need to be in a separate patch.

>  				break;
>  			}
>  			if (ip == (u8 *)regs->ip)
> -				printk("<%02x> ", c);
> +				printk(KERN_CONT "<%02x> ", c);
>  			else
> -				printk("%02x ", c);
> +				printk(KERN_CONT "%02x ", c);
>  		}
>  	}
> -	printk("\n");
> +	printk(KERN_CONT "\n");
>  }
>  
>  int is_valid_bugaddr(unsigned long ip)
> diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
> index a6b6fcf7f0ae..c316e23471a8 100644
> --- a/arch/x86/kernel/dumpstack_64.c
> +++ b/arch/x86/kernel/dumpstack_64.c
> @@ -139,8 +139,8 @@ fixup_bp_irq_link(unsigned long bp, unsigned long *stack,
>   * severe exception (double fault, nmi, stack fault, debug, mce) hardware stack
>   */
>  
> -void dump_trace(struct task_struct *task,
> -		struct pt_regs *regs, unsigned long *stack,
> +void dump_trace(struct task_struct *task, struct pt_regs *regs,
> +		unsigned long *stack, unsigned long bp,
>  		const struct stacktrace_ops *ops, void *data)
>  {
>  	const unsigned cpu = get_cpu();
> @@ -150,7 +150,6 @@ void dump_trace(struct task_struct *task,
>  	struct thread_info *tinfo;
>  	int graph = 0;
>  	unsigned long dummy;
> -	unsigned long bp;
>  
>  	if (!task)
>  		task = current;
> @@ -161,7 +160,8 @@ void dump_trace(struct task_struct *task,
>  			stack = (unsigned long *)task->thread.sp;
>  	}
>  
> -	bp = stack_frame(task, regs);
> +	if (!bp)
> +		bp = stack_frame(task, regs);
>  	/*
>  	 * Print function call entries in all stacks, starting at the
>  	 * current stack address. If the stacks consist of nested
> @@ -180,7 +180,7 @@ void dump_trace(struct task_struct *task,
>  
>  			bp = ops->walk_stack(tinfo, stack, bp, ops,
>  					     data, estack_end, &graph);
> -			ops->stack(data, "<EOE>");
> +			ops->stack(data, "EOE");

That needs to be in a seperate patch as well.

Thanks.
