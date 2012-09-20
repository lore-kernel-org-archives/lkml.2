Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329Ab2ITOKS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 10:10:18 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:55296 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753851Ab2ITOKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 10:10:15 -0400
Date: Thu, 20 Sep 2012 19:35:29 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] uprobes: Fix UPROBE_SKIP_SSTEP checks in
 handle_swbp()
Message-ID: <20120920140529.GC27880@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120914171513.GA29599@redhat.com>
 <20120914171557.GA29642@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120914171557.GA29642@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 12092014-7182-0000-0000-000002AA4557
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2012-09-14 19:15:57]:

> If handle_swbp()->add_utask() fails but UPROBE_SKIP_SSTEP is set,
> cleanup_ret: path do not restart the insn, this is wrong. Remove
> this check and add the additional label for can_skip_sstep() = T
> case.
> 
> Note also that UPROBE_SKIP_SSTEP can be false positive, we simply
> can not trust it unless arch_uprobe_skip_sstep() was already called.
> 
> Also, move another UPROBE_SKIP_SSTEP check before can_skip_sstep()
> into this helper, this looks more clean and understandable.
> 
> Note: probably we should rename "skip" to "emulate" and I think

yes we can rename can_skip_step to can_emulate_insn and
arch_uprobe_skip_step() to arch_uprobe_emulate_insn

Similarly UPROBE_SKIP_SSTEP can be renamed as UPROBE_EMULATE_INSN

> that "clear UPROBE_SKIP_SSTEP" should be moved to arch_can_skip.
> 

Currently struct uprobe is not exposed to arch specific code as
suggested by Ingo. Adding a flag in arch_uprobe just for this and
expecting all archs to define one is probably an overhead.
Hence I am not sure moving the clear flag to arch is a good idea.

> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

> ---
>  kernel/events/uprobes.c |   31 +++++++++++++++----------------
>  1 files changed, 15 insertions(+), 16 deletions(-)
> 
> diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> index 9893cba..403d2e0 100644
> --- a/kernel/events/uprobes.c
> +++ b/kernel/events/uprobes.c
> @@ -1389,10 +1389,11 @@ bool uprobe_deny_signal(void)
>   */
>  static bool can_skip_sstep(struct uprobe *uprobe, struct pt_regs *regs)
>  {
> -	if (arch_uprobe_skip_sstep(&uprobe->arch, regs))
> -		return true;
> -
> -	uprobe->flags &= ~UPROBE_SKIP_SSTEP;
> +	if (uprobe->flags & UPROBE_SKIP_SSTEP) {
> +		if (arch_uprobe_skip_sstep(&uprobe->arch, regs))
> +			return true;
> +		uprobe->flags &= ~UPROBE_SKIP_SSTEP;
> +	}
>  	return false;
>  }
> 
> @@ -1494,12 +1495,12 @@ static void handle_swbp(struct pt_regs *regs)
>  		utask = add_utask();
>  		/* Cannot allocate; re-execute the instruction. */
>  		if (!utask)
> -			goto cleanup_ret;
> +			goto restart;
>  	}
> 
>  	handler_chain(uprobe, regs);
> -	if (uprobe->flags & UPROBE_SKIP_SSTEP && can_skip_sstep(uprobe, regs))
> -		goto cleanup_ret;
> +	if (can_skip_sstep(uprobe, regs))
> +		goto out;
> 
>  	if (!pre_ssout(uprobe, regs, bp_vaddr)) {
>  		arch_uprobe_enable_step(&uprobe->arch);
> @@ -1508,15 +1509,13 @@ static void handle_swbp(struct pt_regs *regs)
>  		return;
>  	}
> 
> -cleanup_ret:
> -	if (!(uprobe->flags & UPROBE_SKIP_SSTEP))
> -
> -		/*
> -		 * cannot singlestep; cannot skip instruction;
> -		 * re-execute the instruction.
> -		 */
> -		instruction_pointer_set(regs, bp_vaddr);
> -
> +restart:
> +	/*
> +	 * cannot singlestep; cannot skip instruction;
> +	 * re-execute the instruction.
> +	 */
> +	instruction_pointer_set(regs, bp_vaddr);
> +out:
>  	put_uprobe(uprobe);
>  }
> 
> -- 
> 1.5.5.1
> 

