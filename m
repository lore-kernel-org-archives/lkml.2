Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755681Ab3AHLj3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 06:39:29 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:32826 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754171Ab3AHLj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 06:39:28 -0500
Date: Tue, 8 Jan 2013 17:09:01 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, Frank Eigler <fche@redhat.com>,
        Josh Stone <jistone@redhat.com>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] uprobes: Change handle_swbp() to expose bp_vaddr
 to handler_chain()
Message-ID: <20130108113901.GC1325@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20121230154657.GA28488@redhat.com>
 <20121230154722.GA28513@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20121230154722.GA28513@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13010811-3620-0000-0000-000000D6B059
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2012-12-30 16:47:22]:

> Change handle_swbp() to set regs->ip = bp_vaddr in advance, this is
> what consumer->handler() needs but uprobe_get_swbp_addr() is not
> exported.
> 
> This also simplifies the code and makes it more consistent across
> the supported architectures. handle_swbp() becomes the only caller
> of uprobe_get_swbp_addr().
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

> ---
>  arch/x86/kernel/uprobes.c   |    1 -
>  kernel/events/uprobes.c     |   15 +++++++--------
>  kernel/trace/trace_uprobe.c |    4 ++--
>  3 files changed, 9 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
> index 4e33a35..0ba4cfb 100644
> --- a/arch/x86/kernel/uprobes.c
> +++ b/arch/x86/kernel/uprobes.c
> @@ -681,7 +681,6 @@ static bool __skip_sstep(struct arch_uprobe *auprobe, struct pt_regs *regs)
>  			continue;
> 
>  		if (auprobe->insn[i] == 0x90) {
> -			regs->ip = uprobe_get_swbp_addr(regs);
>  			regs->ip += i + 1;
>  			return true;
>  		}
> diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> index 59b6e97..f883813 100644
> --- a/kernel/events/uprobes.c
> +++ b/kernel/events/uprobes.c
> @@ -1504,6 +1504,10 @@ static void handle_swbp(struct pt_regs *regs)
>  		}
>  		return;
>  	}
> +
> +	/* change it in advance for ->handler() and restart */
> +	instruction_pointer_set(regs, bp_vaddr);
> +
>  	/*
>  	 * TODO: move copy_insn/etc into _register and remove this hack.
>  	 * After we hit the bp, _unregister + _register can install the
> @@ -1511,14 +1515,14 @@ static void handle_swbp(struct pt_regs *regs)
>  	 */
>  	smp_rmb(); /* pairs with wmb() in install_breakpoint() */
>  	if (unlikely(!test_bit(UPROBE_COPY_INSN, &uprobe->flags)))
> -		goto restart;
> +		goto out;
> 
>  	utask = current->utask;
>  	if (!utask) {
>  		utask = add_utask();
>  		/* Cannot allocate; re-execute the instruction. */
>  		if (!utask)
> -			goto restart;
> +			goto out;
>  	}
> 
>  	handler_chain(uprobe, regs);
> @@ -1531,12 +1535,7 @@ static void handle_swbp(struct pt_regs *regs)
>  		return;
>  	}
> 
> -restart:
> -	/*
> -	 * cannot singlestep; cannot skip instruction;
> -	 * re-execute the instruction.
> -	 */
> -	instruction_pointer_set(regs, bp_vaddr);
> +	/* can_skip_sstep() succeeded, or restart if can't singlestep */
>  out:
>  	put_uprobe(uprobe);
>  }
> diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
> index 38eee92..52caead 100644
> --- a/kernel/trace/trace_uprobe.c
> +++ b/kernel/trace/trace_uprobe.c
> @@ -488,7 +488,7 @@ static void uprobe_trace_func(struct trace_uprobe *tu, struct pt_regs *regs)
>  		return;
> 
>  	entry = ring_buffer_event_data(event);
> -	entry->ip = uprobe_get_swbp_addr(task_pt_regs(current));
> +	entry->ip = instruction_pointer(task_pt_regs(current));
>  	data = (u8 *)&entry[1];
>  	for (i = 0; i < tu->nr_args; i++)
>  		call_fetch(&tu->args[i].fetch, regs, data + tu->args[i].offset);
> @@ -663,7 +663,7 @@ static void uprobe_perf_func(struct trace_uprobe *tu, struct pt_regs *regs)
>  	if (!entry)
>  		goto out;
> 
> -	entry->ip = uprobe_get_swbp_addr(task_pt_regs(current));
> +	entry->ip = instruction_pointer(task_pt_regs(current));
>  	data = (u8 *)&entry[1];
>  	for (i = 0; i < tu->nr_args; i++)
>  		call_fetch(&tu->args[i].fetch, regs, data + tu->args[i].offset);
> -- 
> 1.5.5.1
> 

