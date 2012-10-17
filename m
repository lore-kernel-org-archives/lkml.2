Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757484Ab2JQQvA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 12:51:00 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:33941 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756469Ab2JQQu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 12:50:58 -0400
Date: Wed, 17 Oct 2012 22:22:18 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Rabin Vincent <rabin@rab.in>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Peter Zijlstra <peterz@infradead.org>, oleg@redhat.com
Subject: Re: [PATCH 3/9] uprobes: allow ignoring of probe hits
Message-ID: <20121017165218.GG11096@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <1350242593-17761-1-git-send-email-rabin@rab.in>
 <1350242593-17761-3-git-send-email-rabin@rab.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1350242593-17761-3-git-send-email-rabin@rab.in>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12101716-7606-0000-0000-000004944EBD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

With Oleg's changes, this should become simple. Something like:

	if (arch_uprobe_ignore(&uprobe->arch, regs))
		goto out;

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
> -- 
> 1.7.9.5
> 

