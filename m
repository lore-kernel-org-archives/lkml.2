Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138Ab2HVNxK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 09:53:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37102 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751879Ab2HVNxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 09:53:07 -0400
Date: Wed, 22 Aug 2012 15:48:37 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakaynahalli <ananth@in.ibm.com>, stan_shebs@mentor.com,
        gdb-patches@sourceware.org
Subject: Re: [RFC 5/5 v2] uprobes: add global breakpoints
Message-ID: <20120822134837.GA28878@redhat.com>
References: <1344355952-2382-1-git-send-email-bigeasy@linutronix.de> <1344355952-2382-6-git-send-email-bigeasy@linutronix.de> <1344857686.31459.25.camel@twins> <20120821194200.GA32293@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120821194200.GA32293@linutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21, Sebastian Andrzej Siewior wrote:
>
> This patch adds the ability to hold the program once this point has been
> passed and the user may attach to the program via ptrace.

Sorry Sebastian, I didn't even try to read the patch ;) Fortunately I am
not maintainer, I can only reapeat that you do not need to convince me.

> Oleg: The change in ptrace_attach() is still as it was. I tried to
> address Peter concern here.
> Now what options do I have here:
> - not putting the task in TASK_TRACED but simply halt. This would work
>   without a change to ptrace_attach() but the task continues on any
>   signal. So a signal friendly task would continue and not notice a
>   thing.

TASK_KILLABLE

> - putting the TASK_TRACED

This is simply wrong, in many ways.

For example, what if the probed task is already ptraced? Or debugger
attaches via PTRACE_SEIZE? How can debugger know it is stopped?
uprobe_wait_traced() goes to sleep in TASK_TRACED without notification.
And it does not set ->exit_code, this means do_wait() won't work.
And note ptrace_stop()->recalc_sigpending_tsk().

> @@ -76,6 +79,7 @@ struct uprobe_task {
>
>  	unsigned long			xol_vaddr;
>  	unsigned long			vaddr;
> +	int				skip_handler;

I am trying to guess what this skip_handler does...

> --- a/kernel/events/uprobes.c
> +++ b/kernel/events/uprobes.c
> @@ -1513,7 +1513,16 @@ static void handle_swbp(struct pt_regs *regs)
>  			goto cleanup_ret;
>  	}
>  	utask->active_uprobe = uprobe;
> -	handler_chain(uprobe, regs);
> +	if (utask->skip_handler)
> +		utask->skip_handler = 0;
> +	else
> +		handler_chain(uprobe, regs);
> +
> +	if (utask->state == UTASK_TRACE_WOKEUP_TRACED) {
> +		send_sig(SIGTRAP, current, 0);
> +		utask->skip_handler = 1;
> +		goto cleanup_ret;
> +	}
>  	if (uprobe->flags & UPROBE_SKIP_SSTEP && can_skip_sstep(uprobe, regs))
>  		goto cleanup_ret;
>  
> @@ -1528,7 +1537,7 @@ cleanup_ret:
>  		utask->active_uprobe = NULL;
>  		utask->state = UTASK_RUNNING;
>  	}
> -	if (!(uprobe->flags & UPROBE_SKIP_SSTEP))
> +	if (!(uprobe->flags & UPROBE_SKIP_SSTEP) || utask->skip_handler)

Am I understand correctly?

If it was woken by PTRACE_ATTACH we set utask->skip_handler = 1 and
re-execute the instruction (yes, SIGTRAP, but this doesn't matter).
When the task hits this bp again we skip handler_chain() because it
was already reported.

Yes? If yes, I don't think this can work. Suppose that the task
dequeues a signal before it returns to the usermode to re-execute
and enters the signal handler which can hit another uprobe.

And this can race with uprobe_register() afaics.

Oleg.

