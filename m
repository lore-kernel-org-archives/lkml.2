Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236Ab3ACL42 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 06:56:28 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:55194 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753039Ab3ACL4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 06:56:24 -0500
Date: Thu, 3 Jan 2013 17:26:13 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, Frank Eigler <fche@redhat.com>,
        Josh Stone <jistone@redhat.com>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] uprobes: Rationalize the usage of filter_chain()
Message-ID: <20130103115613.GD8140@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20121228181252.GA6120@redhat.com>
 <20121228181310.GA6138@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20121228181310.GA6138@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13010311-2398-0000-0000-00000FA772C7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2012-12-28 19:13:10]:

> filter_chain() was added into install_breakpoint/remove_breakpoint to
> simplify the initial changes but this is sub-optimal.
> 
> This patch shifts the callsite to the callers, register_for_each_vma()
> and uprobe_mmap(). This way:
> 
> - It will be easier to add the new arguments. This is the main reason,
>   we can do more optimizations later.
> 
> - register_for_each_vma(is_register => true) can be optimized, we only
>   need to consult the new consumer. The previous consumers were already
>   asked when they called uprobe_register().
> 
> This patch also moves the MMF_HAS_UPROBES check from remove_breakpoint(),
> this allows to avoid the potentionally costly filter_chain(). Note that
> register_for_each_vma(is_register => false) doesn't really need to take
> >consumer_rwsem, but I don't think it makes sense to optimize this and
> introduce filter_chain_lockless().
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

> ---
>  kernel/events/uprobes.c |   44 +++++++++++++++++++++-----------------------
>  1 files changed, 21 insertions(+), 23 deletions(-)
> 
> diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> index 105ac0d..60b0a90 100644
> --- a/kernel/events/uprobes.c
> +++ b/kernel/events/uprobes.c
> @@ -579,6 +579,11 @@ static int prepare_uprobe(struct uprobe *uprobe, struct file *file,
>  	return ret;
>  }
> 
> +static inline bool consumer_filter(struct uprobe_consumer *uc)
> +{
> +	return true; /* TODO: !uc->filter || uc->filter(...) */
> +}
> +
>  static bool filter_chain(struct uprobe *uprobe)
>  {
>  	struct uprobe_consumer *uc;
> @@ -586,8 +591,7 @@ static bool filter_chain(struct uprobe *uprobe)
> 
>  	down_read(&uprobe->consumer_rwsem);
>  	for (uc = uprobe->consumers; uc; uc = uc->next) {
> -		/* TODO: ret = uc->filter(...) */
> -		ret = true;
> +		ret = consumer_filter(uc);
>  		if (ret)
>  			break;
>  	}
> @@ -603,15 +607,6 @@ install_breakpoint(struct uprobe *uprobe, struct mm_struct *mm,
>  	bool first_uprobe;
>  	int ret;
> 
> -	/*
> -	 * If probe is being deleted, unregister thread could be done with
> -	 * the vma-rmap-walk through. Adding a probe now can be fatal since
> -	 * nobody will be able to cleanup. But in this case filter_chain()
> -	 * must return false, all consumers have gone away.
> -	 */
> -	if (!filter_chain(uprobe))
> -		return 0;
> -
>  	ret = prepare_uprobe(uprobe, vma->vm_file, mm, vaddr);
>  	if (ret)
>  		return ret;
> @@ -636,12 +631,6 @@ install_breakpoint(struct uprobe *uprobe, struct mm_struct *mm,
>  static int
>  remove_breakpoint(struct uprobe *uprobe, struct mm_struct *mm, unsigned long vaddr)
>  {
> -	if (!test_bit(MMF_HAS_UPROBES, &mm->flags))
> -		return 0;
> -
> -	if (filter_chain(uprobe))
> -		return 0;
> -
>  	set_bit(MMF_RECALC_UPROBES, &mm->flags);
>  	return set_orig_insn(&uprobe->arch, mm, vaddr);
>  }
> @@ -781,10 +770,14 @@ static int register_for_each_vma(struct uprobe *uprobe, bool is_register)
>  		    vaddr_to_offset(vma, info->vaddr) != uprobe->offset)
>  			goto unlock;
> 
> -		if (is_register)
> -			err = install_breakpoint(uprobe, mm, vma, info->vaddr);
> -		else
> -			err |= remove_breakpoint(uprobe, mm, info->vaddr);
> +		if (is_register) {
> +			/* consult only the "caller", new consumer. */
> +			if (consumer_filter(uprobe->consumers))
> +				err = install_breakpoint(uprobe, mm, vma, info->vaddr);
> +		} else if (test_bit(MMF_HAS_UPROBES, &mm->flags)) {
> +			if (!filter_chain(uprobe))
> +				err |= remove_breakpoint(uprobe, mm, info->vaddr);
> +		}
> 
>   unlock:
>  		up_write(&mm->mmap_sem);
> @@ -968,9 +961,14 @@ int uprobe_mmap(struct vm_area_struct *vma)
> 
>  	mutex_lock(uprobes_mmap_hash(inode));
>  	build_probe_list(inode, vma, vma->vm_start, vma->vm_end, &tmp_list);
> -
> +	/*
> +	 * We can race with uprobe_unregister(), this uprobe can be already
> +	 * removed. But in this case filter_chain() must return false, all
> +	 * consumers have gone away.
> +	 */
>  	list_for_each_entry_safe(uprobe, u, &tmp_list, pending_list) {
> -		if (!fatal_signal_pending(current)) {
> +		if (!fatal_signal_pending(current) &&
> +		    filter_chain(uprobe)) {
>  			unsigned long vaddr = offset_to_vaddr(vma, uprobe->offset);
>  			install_breakpoint(uprobe, vma->vm_mm, vma, vaddr);
>  		}
> -- 
> 1.5.5.1
> 

