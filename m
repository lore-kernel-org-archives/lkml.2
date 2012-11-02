Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134Ab2KBFa0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 01:30:26 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:36131 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818Ab2KBFaX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 01:30:23 -0400
Date: Fri, 2 Nov 2012 10:33:50 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Anton Arapov <anton@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Rabin Vincent <rabin@rab.in>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] uprobes/powerpc: Do not use arch_uprobe_*_step()
 helpers
Message-ID: <20121102050350.GE11125@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20121028173900.GA14621@redhat.com>
 <20121028173928.GA14649@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20121028173928.GA14649@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12110205-8974-0000-0000-0000107C95F4
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000294; HX=3.00000198; KW=3.00000007;
 PH=3.00000001; SC=3.00000008; SDB=6.00187712; UDB=6.00042514; UTC=2012-11-02
 05:00:13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2012-10-28 18:39:28]:

> No functional changes.
> 
> powerpc is the only user of arch_uprobe_enable/disable_step() helpers,
> but they should die. They can not be used correctly, every arch needs
> its own implementation (like x86 does). And they do not really help
> even as initial-and-almost-working code, arch_uprobe_*_xol() hooks can
> easily use user_enable/disable_single_step() directly.
> 
> Change arch_uprobe_*_step() to do nothing, and convert powerpc to use
> ptrace helpers. This is equally wrong, powerpc needs the arch-specific
> fixes.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>


Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

> ---
>  arch/powerpc/kernel/uprobes.c |    6 ++++++
>  kernel/events/uprobes.c       |    2 --
>  2 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/powerpc/kernel/uprobes.c b/arch/powerpc/kernel/uprobes.c
> index d2d46d1..bc77834 100644
> --- a/arch/powerpc/kernel/uprobes.c
> +++ b/arch/powerpc/kernel/uprobes.c
> @@ -64,6 +64,8 @@ int arch_uprobe_pre_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
>  	autask->saved_trap_nr = current->thread.trap_nr;
>  	current->thread.trap_nr = UPROBE_TRAP_NR;
>  	regs->nip = current->utask->xol_vaddr;
> +
> +	user_enable_single_step(current);
>  	return 0;
>  }
> 
> @@ -119,6 +121,8 @@ int arch_uprobe_post_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
>  	 * to be executed.
>  	 */
>  	regs->nip = utask->vaddr + MAX_UINSN_BYTES;
> +
> +	user_disable_single_step(current);
>  	return 0;
>  }
> 
> @@ -162,6 +166,8 @@ void arch_uprobe_abort_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
> 
>  	current->thread.trap_nr = utask->autask.saved_trap_nr;
>  	instruction_pointer_set(regs, utask->vaddr);
> +
> +	user_disable_single_step(current);
>  }
> 
>  /*
> diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> index 672227a..916391e 100644
> --- a/kernel/events/uprobes.c
> +++ b/kernel/events/uprobes.c
> @@ -1432,12 +1432,10 @@ static struct uprobe *find_active_uprobe(unsigned long bp_vaddr, int *is_swbp)
> 
>  void __weak arch_uprobe_enable_step(struct arch_uprobe *arch)
>  {
> -	user_enable_single_step(current);
>  }
> 
>  void __weak arch_uprobe_disable_step(struct arch_uprobe *arch)
>  {
> -	user_disable_single_step(current);
>  }
> 
>  /*
> -- 
> 1.5.5.1
> 

