Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757723Ab2ILMkK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 08:40:10 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:38700 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755256Ab2ILMkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 08:40:07 -0400
Date: Wed, 12 Sep 2012 18:06:00 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Roland McGrath <roland@hack.frob.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/7] uprobes: Fix arch_uprobe_disable_step() &&
 UTASK_SSTEP_TRAPPED interaction
Message-ID: <20120912123600.GD9582@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120903152525.GA9028@redhat.com>
 <20120908170623.GB19311@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120908170623.GB19311@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12091212-5518-0000-0000-0000079A8D27
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2012-09-08 19:06:23]:

> arch_uprobe_disable_step() should also take UTASK_SSTEP_TRAPPED into
> account. In this case the probed insn was not executed, we need to
> clear X86_EFLAGS_TF if it was set by us and that is all.
> 
> Again, this code will look more clean when we move it into
> arch_uprobe_post_xol() and arch_uprobe_abort_xol().
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>



Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

note:
I also think this should be merged into 6/7 patch if possible

-- 
thanks and regards
Srikar

> ---
>  arch/x86/kernel/uprobes.c |   14 ++++++++++----
>  1 files changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
> index 7e993d1..9538f00 100644
> --- a/arch/x86/kernel/uprobes.c
> +++ b/arch/x86/kernel/uprobes.c
> @@ -706,14 +706,20 @@ void arch_uprobe_disable_step(struct arch_uprobe *auprobe)
>  {
>  	struct task_struct *task = current;
>  	struct arch_uprobe_task	*autask	= &task->utask->autask;
> +	bool trapped = (task->utask->state == UTASK_SSTEP_TRAPPED);
>  	struct pt_regs *regs = task_pt_regs(task);
>  	/*
>  	 * The state of TIF_BLOCKSTEP was not saved so we can get an extra
>  	 * SIGTRAP if we do not clear TF. We need to examine the opcode to
>  	 * make it right.
>  	 */
> -	if (autask->saved_tf)
> -		send_sig(SIGTRAP, task, 0);
> -	else if (!(auprobe->fixups & UPROBE_FIX_SETF))
> -		regs->flags &= ~X86_EFLAGS_TF;
> +	if (unlikely(trapped)) {
> +		if (!autask->saved_tf)
> +			regs->flags &= ~X86_EFLAGS_TF;
> +	} else {
> +		if (autask->saved_tf)
> +			send_sig(SIGTRAP, task, 0);
> +		else if (!(auprobe->fixups & UPROBE_FIX_SETF))
> +			regs->flags &= ~X86_EFLAGS_TF;
> +	}
>  }
> -- 
> 1.5.5.1
> 
> 

