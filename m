Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119Ab2ITOAd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 10:00:33 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:53753 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753310Ab2ITOA2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 10:00:28 -0400
Date: Thu, 20 Sep 2012 19:25:25 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] uprobes: Do not setup ->active_uprobe/state
 prematurely
Message-ID: <20120920135525.GB27880@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120914171513.GA29599@redhat.com>
 <20120914171554.GA29639@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120914171554.GA29639@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 12092014-5806-0000-0000-000019CB8D28
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2012-09-14 19:15:54]:

> handle_swbp() sets utask->active_uprobe before handler_chain(),
> and UTASK_SSTEP before pre_ssout(). This complicates the code
> for no reason,  arch_ hooks or consumer->handler() should not
> (and can't) use this info.
> 
> Change handle_swbp() to initialize them after pre_ssout(), and
> remove the no longer needed cleanup-utask code.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  kernel/events/uprobes.c |    9 +++------
>  1 files changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> index 760acc1..9893cba 100644
> --- a/kernel/events/uprobes.c
> +++ b/kernel/events/uprobes.c
> @@ -1496,22 +1496,19 @@ static void handle_swbp(struct pt_regs *regs)
>  		if (!utask)
>  			goto cleanup_ret;
>  	}
> -	utask->active_uprobe = uprobe;
> +
>  	handler_chain(uprobe, regs);
>  	if (uprobe->flags & UPROBE_SKIP_SSTEP && can_skip_sstep(uprobe, regs))
>  		goto cleanup_ret;
> 
> -	utask->state = UTASK_SSTEP;
>  	if (!pre_ssout(uprobe, regs, bp_vaddr)) {
>  		arch_uprobe_enable_step(&uprobe->arch);
> +		utask->active_uprobe = uprobe;
> +		utask->state = UTASK_SSTEP;
>  		return;
>  	}
> 
>  cleanup_ret:
> -	if (utask) {
> -		utask->active_uprobe = NULL;
> -		utask->state = UTASK_RUNNING;
> -	}
>  	if (!(uprobe->flags & UPROBE_SKIP_SSTEP))
> 
>  		/*

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

