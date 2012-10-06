Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751535Ab2JFRiU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 13:38:20 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:59870 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750762Ab2JFRiR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 13:38:17 -0400
Date: Sat, 6 Oct 2012 23:08:49 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] uprobes: Introduce uprobe_copy_insn()
Message-ID: <20121006173849.GB9143@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120930194119.GA11278@redhat.com>
 <20120930194217.GA11340@redhat.com>
 <20121006094528.GC9145@linux.vnet.ibm.com>
 <20121006171010.GA9819@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20121006171010.GA9819@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 12100617-5112-0000-0000-00000D279636
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > uprobe_copy_insn.
> 
> Yes ;) plus it is not only "copy", it does _analyze
> 
> > Not sure test_and_copy_insn() is a good alternative.
> 
> perhaps prepare_uprobe()... But I agree with any naming, just tell me
> what you prefer and I'll update the patch again.


Yeah prepare_uprobe() looks good for me. 



Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

> 
> ==============================================================================
> [PATCH 5/7] uprobes: Introduce uprobe_copy_insn()
> 
> Preparation. Extract the copy_insn/arch_uprobe_analyze_insn code
> from install_breakpoint() into the new helper, uprobe_copy_insn().
> 
> And move uprobe->flags defines from uprobes.h to uprobes.c, nobody
> else can use them anyway.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  include/linux/uprobes.h |   10 --------
>  kernel/events/uprobes.c |   60 ++++++++++++++++++++++++++++++++---------------
>  2 files changed, 41 insertions(+), 29 deletions(-)
> 
> diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
> index 18d839d..2459457 100644
> --- a/include/linux/uprobes.h
> +++ b/include/linux/uprobes.h
> @@ -35,16 +35,6 @@ struct inode;
>  # include <asm/uprobes.h>
>  #endif
> 
> -/* flags that denote/change uprobes behaviour */
> -
> -/* Have a copy of original instruction */
> -#define UPROBE_COPY_INSN	0x1
> -
> -/* Dont run handlers when first register/ last unregister in progress*/
> -#define UPROBE_RUN_HANDLER	0x2
> -/* Can skip singlestep */
> -#define UPROBE_SKIP_SSTEP	0x4
> -
>  struct uprobe_consumer {
>  	int (*handler)(struct uprobe_consumer *self, struct pt_regs *regs);
>  	/*
> diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> index dd44311..98b60bc 100644
> --- a/kernel/events/uprobes.c
> +++ b/kernel/events/uprobes.c
> @@ -78,6 +78,13 @@ static struct mutex uprobes_mmap_mutex[UPROBES_HASH_SZ];
>   */
>  static atomic_t uprobe_events = ATOMIC_INIT(0);
> 
> +/* Have a copy of original instruction */
> +#define UPROBE_COPY_INSN	0x1
> +/* Dont run handlers when first register/ last unregister in progress*/
> +#define UPROBE_RUN_HANDLER	0x2
> +/* Can skip singlestep */
> +#define UPROBE_SKIP_SSTEP	0x4
> +
>  struct uprobe {
>  	struct rb_node		rb_node;	/* node in the rb tree */
>  	atomic_t		ref;
> @@ -563,6 +570,37 @@ static int copy_insn(struct uprobe *uprobe, struct file *filp)
>  	return __copy_insn(mapping, filp, uprobe->arch.insn, bytes, uprobe->offset);
>  }
> 
> +static int uprobe_copy_insn(struct uprobe *uprobe, struct file *file,
> +				struct mm_struct *mm, unsigned long vaddr)
> +{
> +	int ret = 0;
> +
> +	if (uprobe->flags & UPROBE_COPY_INSN)
> +		return ret;
> +
> +	ret = copy_insn(uprobe, file);
> +	if (ret)
> +		goto out;
> +
> +	ret = -ENOTSUPP;
> +	if (is_swbp_insn((uprobe_opcode_t *)uprobe->arch.insn))
> +		goto out;
> +
> +	ret = arch_uprobe_analyze_insn(&uprobe->arch, mm, vaddr);
> +	if (ret)
> +		goto out;
> +
> +	/* write_opcode() assumes we don't cross page boundary */
> +	BUG_ON((uprobe->offset & ~PAGE_MASK) +
> +			UPROBE_SWBP_INSN_SIZE > PAGE_SIZE);
> +
> +	smp_wmb(); /* pairs with rmb() in find_active_uprobe() */
> +	uprobe->flags |= UPROBE_COPY_INSN;
> +
> + out:
> +	return ret;
> +}
> +
>  static int
>  install_breakpoint(struct uprobe *uprobe, struct mm_struct *mm,
>  			struct vm_area_struct *vma, unsigned long vaddr)
> @@ -580,25 +618,9 @@ install_breakpoint(struct uprobe *uprobe, struct mm_struct *mm,
>  	if (!uprobe->consumers)
>  		return 0;
> 
> -	if (!(uprobe->flags & UPROBE_COPY_INSN)) {
> -		ret = copy_insn(uprobe, vma->vm_file);
> -		if (ret)
> -			return ret;
> -
> -		if (is_swbp_insn((uprobe_opcode_t *)uprobe->arch.insn))
> -			return -ENOTSUPP;
> -
> -		ret = arch_uprobe_analyze_insn(&uprobe->arch, mm, vaddr);
> -		if (ret)
> -			return ret;
> -
> -		/* write_opcode() assumes we don't cross page boundary */
> -		BUG_ON((uprobe->offset & ~PAGE_MASK) +
> -				UPROBE_SWBP_INSN_SIZE > PAGE_SIZE);
> -
> -		smp_wmb(); /* pairs with rmb() in find_active_uprobe() */
> -		uprobe->flags |= UPROBE_COPY_INSN;
> -	}
> +	ret = uprobe_copy_insn(uprobe, vma->vm_file, mm, vaddr);
> +	if (ret)
> +		return ret;
> 
>  	/*
>  	 * set MMF_HAS_UPROBES in advance for uprobe_pre_sstep_notifier(),
> -- 
> 1.5.5.1
> 
> 
> 

