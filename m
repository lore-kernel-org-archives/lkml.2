Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab2JOQvJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 12:51:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29143 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722Ab2JOQvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 12:51:08 -0400
Date: Mon, 15 Oct 2012 18:52:18 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Rabin Vincent <rabin@rab.in>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/9] uprobes: allow ignoring of probe hits
Message-ID: <20121015165218.GA10239@redhat.com>
References: <1350242593-17761-1-git-send-email-rabin@rab.in> <1350242593-17761-3-git-send-email-rabin@rab.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350242593-17761-3-git-send-email-rabin@rab.in>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14, Rabin Vincent wrote:
>
> Allow arches to decided to ignore a probe hit.  ARM will use this to
> only call handlers if the conditions to execute a conditionally executed
> instruction are satisfied.

Not sure I understand why we shouldn't call handlers in this case,
but OK, I know nothing about arm.

>  static struct uprobe *find_active_uprobe(unsigned long bp_vaddr, int *is_swbp)
>  {
>  	struct mm_struct *mm = current->mm;
> @@ -1469,6 +1474,7 @@ static void handle_swbp(struct pt_regs *regs)
>  	struct uprobe *uprobe;
>  	unsigned long bp_vaddr;
>  	int uninitialized_var(is_swbp);
> +	bool ignored = false;
>  
>  	bp_vaddr = uprobe_get_swbp_addr(regs);
>  	uprobe = find_active_uprobe(bp_vaddr, &is_swbp);
> @@ -1499,6 +1505,12 @@ static void handle_swbp(struct pt_regs *regs)
>  			goto cleanup_ret;
>  	}
>  	utask->active_uprobe = uprobe;
> +
> +	if (arch_uprobe_ignore(&uprobe->arch, regs)) {
> +		ignored = true;
> +		goto cleanup_ret;
> +	}
> +
>  	handler_chain(uprobe, regs);
>  	if (uprobe->flags & UPROBE_SKIP_SSTEP && can_skip_sstep(uprobe, regs))
>  		goto cleanup_ret;
> @@ -1514,7 +1526,7 @@ cleanup_ret:
>  		utask->active_uprobe = NULL;
>  		utask->state = UTASK_RUNNING;
>  	}
> -	if (!(uprobe->flags & UPROBE_SKIP_SSTEP))
> +	if (!ignored && !(uprobe->flags & UPROBE_SKIP_SSTEP))
>  
>  		/*
>  		 * cannot singlestep; cannot skip instruction;

This conflicts with other changes in

	git://git.kernel.org/pub/scm/linux/kernel/git/oleg/misc uprobes/core

Could you re-diff?

I'll try to read 1-7 tomorrow.

Oleg.

