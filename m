Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751717Ab3AJFfj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 00:35:39 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:60234 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188Ab3AJFfi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 00:35:38 -0500
Date: Thu, 10 Jan 2013 11:05:01 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, Frank Eigler <fche@redhat.com>,
        Josh Stone <jistone@redhat.com>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] uprobes: Teach handler_chain() to filter out the
 probed task
Message-ID: <20130110053501.GA26174@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20121229173554.GA2145@redhat.com>
 <20121229173614.GA2154@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20121229173614.GA2154@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011005-9360-0000-0000-00000EFE72DB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2012-12-29 18:36:14]:

> Currrently the are 2 problems with pre-filtering:
> 
> 1. It is not possible to add/remove a task (mm) after uprobe_register()
> 
> 2. A forked child inherits all breakpoints and uprobe_consumer can not
>    control this.
> 
> This patch does the first step to improve the filtering. handler_chain()
> removes the breakpoints installed by this uprobe from current->mm if all
> handlers return UPROBE_HANDLER_REMOVE.
> 
> Note that handler_chain() relies on ->register_rwsem to avoid the race
> with uprobe_register/unregister which can add/del a consumer, or even
> remove and then insert the new uprobe at the same address.
> 
> Perhaps we will add uprobe_apply_mm(uprobe, mm, is_register) and teach
> copy_mm() to do filter(UPROBE_FILTER_FORK), but I think this change makes
> sense anyway.
> 
> Note: instead of checking the retcode from uc->handler, we could add
> uc->filter(UPROBE_FILTER_BPHIT). But I think this is not optimal to
> call 2 hooks in a row. This buys nothing, and if handler/filter do
> something nontrivial they will probably do the same work twice.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

> ---
>  include/linux/uprobes.h |    3 ++
>  kernel/events/uprobes.c |   58 ++++++++++++++++++++++++++++++++++++++--------
>  2 files changed, 51 insertions(+), 10 deletions(-)
> 
> diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
> index c2df693..95d0002 100644
> --- a/include/linux/uprobes.h
> +++ b/include/linux/uprobes.h
> @@ -35,6 +35,9 @@ struct inode;
>  # include <asm/uprobes.h>
>  #endif
> 
> +#define UPROBE_HANDLER_REMOVE		1
> +#define UPROBE_HANDLER_MASK		1
> +
>  enum uprobe_filter_ctx {
>  	UPROBE_FILTER_REGISTER,
>  	UPROBE_FILTER_UNREGISTER,
> diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> index e2ebb6f..59b6e97 100644
> --- a/kernel/events/uprobes.c
> +++ b/kernel/events/uprobes.c
> @@ -440,16 +440,6 @@ static struct uprobe *alloc_uprobe(struct inode *inode, loff_t offset)
>  	return uprobe;
>  }
> 
> -static void handler_chain(struct uprobe *uprobe, struct pt_regs *regs)
> -{
> -	struct uprobe_consumer *uc;
> -
> -	down_read(&uprobe->register_rwsem);
> -	for (uc = uprobe->consumers; uc; uc = uc->next)
> -		uc->handler(uc, regs);
> -	up_read(&uprobe->register_rwsem);
> -}
> -
>  static void consumer_add(struct uprobe *uprobe, struct uprobe_consumer *uc)
>  {
>  	down_write(&uprobe->consumer_rwsem);
> @@ -882,6 +872,33 @@ void uprobe_unregister(struct inode *inode, loff_t offset, struct uprobe_consume
>  	put_uprobe(uprobe);
>  }
> 
> +static int unapply_uprobe(struct uprobe *uprobe, struct mm_struct *mm)
> +{
> +	struct vm_area_struct *vma;
> +	int err = 0;
> +
> +	down_read(&mm->mmap_sem);
> +	for (vma = mm->mmap; vma; vma = vma->vm_next) {
> +		unsigned long vaddr;
> +		loff_t offset;
> +
> +		if (!valid_vma(vma, false) ||
> +		    vma->vm_file->f_mapping->host != uprobe->inode)
> +			continue;
> +
> +		offset = (loff_t)vma->vm_pgoff << PAGE_SHIFT;
> +		if (uprobe->offset <  offset ||
> +		    uprobe->offset >= offset + vma->vm_end - vma->vm_start)
> +			continue;
> +
> +		vaddr = offset_to_vaddr(vma, uprobe->offset);
> +		err |= remove_breakpoint(uprobe, mm, vaddr);
> +	}
> +	up_read(&mm->mmap_sem);
> +
> +	return err;
> +}
> +
>  static struct rb_node *
>  find_node_in_range(struct inode *inode, loff_t min, loff_t max)
>  {
> @@ -1435,6 +1452,27 @@ static struct uprobe *find_active_uprobe(unsigned long bp_vaddr, int *is_swbp)
>  	return uprobe;
>  }
> 
> +static void handler_chain(struct uprobe *uprobe, struct pt_regs *regs)
> +{
> +	struct uprobe_consumer *uc;
> +	int remove = UPROBE_HANDLER_REMOVE;
> +
> +	down_read(&uprobe->register_rwsem);
> +	for (uc = uprobe->consumers; uc; uc = uc->next) {
> +		int rc = uc->handler(uc, regs);
> +
> +		WARN(rc & ~UPROBE_HANDLER_MASK,
> +			"bad rc=0x%x from %pf()\n", rc, uc->handler);
> +		remove &= rc;
> +	}
> +
> +	if (remove && uprobe->consumers) {
> +		WARN_ON(!uprobe_is_active(uprobe));
> +		unapply_uprobe(uprobe, current->mm);
> +	}
> +	up_read(&uprobe->register_rwsem);
> +}
> +
>  /*
>   * Run handler and ask thread to singlestep.
>   * Ensure all non-fatal signals cannot interrupt thread while it singlesteps.
> -- 
> 1.5.5.1
> 
> 

