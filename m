Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757429Ab2INQrl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 12:47:41 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:55918 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757053Ab2INQrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 12:47:39 -0400
Date: Fri, 14 Sep 2012 22:13:24 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] uprobes: teach find_active_uprobe() to clear
 MMF_HAS_UPROBES
Message-ID: <20120914164324.GE28033@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120819164008.GA25454@redhat.com>
 <20120819164042.GA25490@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120819164042.GA25490@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 12091416-1618-0000-0000-0000027ACDE0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2012-08-19 18:40:42]:

> The wrong MMF_HAS_UPROBES doesn't really hurt, just it triggers
> the "slow" and unnecessary handle_swbp() path if the task hits
> the non-uprobe breakpoint.
> 
> So this patch changes find_active_uprobe() to check every valid
> vma and clear MMF_HAS_UPROBES if no uprobes were found. This is
> adds the slow O(n) path, but it is only called in unlikely case
> when the task hits the normal breakpoint first time after
> uprobe_unregister().
> 
> Note the "not strictly accurate" comment in mmf_recalc_uprobes().
> We can fix this, we only need to teach vma_has_uprobes() to return
> a bit more more info, but I am not sure this worth the trouble.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  kernel/events/uprobes.c |   22 ++++++++++++++++++++++
>  1 files changed, 22 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> index 176de8c..0b7918c 100644
> --- a/kernel/events/uprobes.c
> +++ b/kernel/events/uprobes.c
> @@ -1397,6 +1397,25 @@ static bool can_skip_sstep(struct uprobe *uprobe, struct pt_regs *regs)
>  	return false;
>  }
> 
> +static void mmf_recalc_uprobes(struct mm_struct *mm)
> +{
> +	struct vm_area_struct *vma;
> +
> +	for (vma = mm->mmap; vma; vma = vma->vm_next) {
> +		if (!valid_vma(vma, false))
> +			continue;
> +		/*
> +		 * This is not strictly accurate, we can race with
> +		 * uprobe_unregister() and see the already removed
> +		 * uprobe if delete_uprobe() was not yet called.
> +		 */
> +		if (vma_has_uprobes(vma, vma->vm_start, vma->vm_end))

Should we set the MMF_RECALC_UPROBES here?

Its harmless but my thought was if we indeed saw a uprobe that was
already deleted, then the next time we hit a non uprobe breakpoint in
the same process context, we will not come here because
MMF_RECALC_UPROBES is cleared.

The rest looks fine. 


Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>


> +			return;
> +	}
> +
> +	clear_bit(MMF_HAS_UPROBES, &mm->flags);
> +}
> +
>  static struct uprobe *find_active_uprobe(unsigned long bp_vaddr, int *is_swbp)
>  {
>  	struct mm_struct *mm = current->mm;
> @@ -1418,6 +1437,9 @@ static struct uprobe *find_active_uprobe(unsigned long bp_vaddr, int *is_swbp)
>  	} else {
>  		*is_swbp = -EFAULT;
>  	}
> +
> +	if (!uprobe && test_and_clear_bit(MMF_RECALC_UPROBES, &mm->flags))
> +		mmf_recalc_uprobes(mm);
>  	up_read(&mm->mmap_sem);
> 
>  	return uprobe;
> -- 
> 1.5.5.1
> 

