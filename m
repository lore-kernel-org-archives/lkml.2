Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447Ab2GZSRm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 14:17:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12065 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752192Ab2GZSRk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 14:17:40 -0400
Date: Thu, 26 Jul 2012 19:31:26 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: Re: [PATCH] uprobes: don't enable/disable signle step if the user
	did it
Message-ID: <20120726173126.GA5787@redhat.com>
References: <1343316043-13475-1-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343316043-13475-1-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well. I agree, this needs changes. To begin with, uprobe should avoid
user_enable_single_step() which does access_process_vm(). And I suspect
uprobes have the problems with TIF_FORCED_TF logic.

But I am not sure about this patch...

On 07/26, Sebastian Andrzej Siewior wrote:
>
> @@ -1528,7 +1528,10 @@ static void handle_swbp(struct pt_regs *regs)
>
>  	utask->state = UTASK_SSTEP;
>  	if (!pre_ssout(uprobe, regs, bp_vaddr)) {
> -		user_enable_single_step(current);
> +		if (test_tsk_thread_flag(current, TIF_SINGLESTEP))
> +			uprobe->flags |= UPROBE_USER_SSTEP;
> +		else
> +			user_enable_single_step(current);

This is x86 specific, TIF_SINGLESTEP is not defined on every arch.

> @@ -1569,7 +1572,10 @@ static void handle_singlestep(struct uprobe_task *utask, struct pt_regs *regs)
>  	put_uprobe(uprobe);
>  	utask->active_uprobe = NULL;
>  	utask->state = UTASK_RUNNING;
> -	user_disable_single_step(current);
> +	if (uprobe->flags & UPROBE_USER_SSTEP)
> +		uprobe->flags &= ~UPROBE_USER_SSTEP;
> +	else
> +		user_disable_single_step(current);

This is not enough (and I am not sure this is portable).

If SINGLESTEP was set, we should send SIGTRAP here. With this patch
we return with X86_EFLAGS_TF set, gdb will be notified only after the
next insn. And if we notify gdb, there is no need to keep X86_EFLAGS_TF.

I'm afraid this needs more thinking and new arch-dependant helpers.

Oleg.

