Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757839Ab1D2AdL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 20:33:11 -0400
Received: from www.linutronix.de ([62.245.132.108]:34780 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754900Ab1D2AdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 20:33:09 -0400
Date: Fri, 29 Apr 2011 02:33:04 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Vaibhav Nagarnaik <vnagarnaik@google.com>
cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Jiaying Zhang <jiayingz@google.com>
Subject: Re: [PATCH 1/2] trace: Add trap entry/exit tracepoints
In-Reply-To: <1303513438-26519-1-git-send-email-vnagarnaik@google.com>
Message-ID: <alpine.LFD.2.02.1104290215290.3005@ionos>
References: <1303513438-26519-1-git-send-email-vnagarnaik@google.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Apr 2011, Vaibhav Nagarnaik wrote:
>  #include <asm/uaccess.h>
>  #include <asm/pgtable.h>
>  #include <asm/system.h>
> @@ -1330,8 +1332,10 @@ void send_sigtrap(struct task_struct *tsk, struct pt_regs *regs,
>  	struct siginfo info;
>  
>  	fill_sigtrap_info(tsk, regs, error_code, si_code, &info);
> +	trace_trap_entry(tsk->thread.trap_no);

What the heck? How is that a trap? The code is sending SIGTRAP not
entering a trap at all. What are you trying to measure ? The time it
takes to send SIGTRAP? So how is that useful as an extra event? 

>  	/* Send us the fake SIGTRAP */
>  	force_sig_info(SIGTRAP, &info, tsk);
> +	trace_trap_exit(tsk->thread.trap_no);
>  }
>  
>  
> diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
> index 4857ff6..d450349 100644
> --- a/arch/x86/kernel/traps.c
> +++ b/arch/x86/kernel/traps.c
> @@ -33,6 +33,9 @@
>  #include <linux/io.h>
>  #include <trace/events/irq.h>
>  
> +#define CREATE_TRACE_POINTS
> +#include <trace/events/trap.h>
> +
>  #ifdef CONFIG_EISA
>  #include <linux/ioport.h>
>  #include <linux/eisa.h>
> @@ -123,6 +126,7 @@ do_trap(int trapnr, int signr, char *str, struct pt_regs *regs,
>  {
>  	struct task_struct *tsk = current;
>  
> +	trace_trap_entry(trapnr);

While the event of do_trap() itself might be interesting, it does not
matter at all how long it takes to handle it. That code is really not
so interesting.

> @@ -286,7 +293,9 @@ do_general_protection(struct pt_regs *regs, long error_code)
>  		printk("\n");
>  	}
>  
> +	trace_trap_entry(tsk->thread.trap_no);
>  	force_sig(SIGSEGV, tsk);
> +	trace_trap_exit(tsk->thread.trap_no);

We really do not care how long the force_sig() call takes. It's
irrelevant. The only interesting thing here is that we ran into a GP
trap.

> +
> +dotraplinkage void __kprobes
> +do_page_fault(struct pt_regs *regs, unsigned long error_code)
> +{
> +	trace_trap_entry(14);

Yuck. Magic number 14 ? Why not 42 ?

> +	__do_page_fault(regs, error_code);
> +	trace_trap_exit(14);
> +}

That page fault thing is the only interesting event in terms of
runtime, but I have yet to see a proper rationale for the whole thing
aside of that completly bogus changelog which tells what output I can
produce, but not why the hell it is a good idea to add all that trace
points.

Thanks,

	tglx
 
