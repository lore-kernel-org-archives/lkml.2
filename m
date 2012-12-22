Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751795Ab2LVQCo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 11:02:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43336 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511Ab2LVQCm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 11:02:42 -0500
Date: Sat, 22 Dec 2012 17:02:49 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Anton Arapov <anton@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>
Subject: Re: [RFC PATCH 3/6] uretprobes: return probe entry, prepare
	uretprobe
Message-ID: <20121222160249.GC18082@redhat.com>
References: <1356088596-17858-1-git-send-email-anton@redhat.com> <1356088596-17858-4-git-send-email-anton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356088596-17858-4-git-send-email-anton@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21, Anton Arapov wrote:
>
>  struct uprobe {
>  	struct rb_node		rb_node;	/* node in the rb tree */
>  	atomic_t		ref;
> @@ -70,12 +72,20 @@ struct uprobe {
>  	struct rw_semaphore	consumer_rwsem;
>  	struct list_head	pending_list;
>  	struct uprobe_consumer	*consumers;
> +	struct uprobe_consumer  *return_consumers;

Probably this needs more discussion, but when I look at the next patches
I think that yes, we should not add ->return_consumers and duplicate the
code add/del/each. Perhaps it would be better to add the RET_CONSUMER flag.

Better yet, we could add 2 bits perhaps... then a single consumer/register
can be used to track both events if needed, hit or/and return. But this
needs additional argument.

So perhaps we should simply add uprobe_consumer->ret_hanlder(). A user
can initialize ->hanlder or ->ret_hanlder or both before register. The
only complication is that we need the new bit in uprobe->flags for
prepare_uprobe(). consumer_add/del should set/clear this bit.

> @@ -424,6 +434,8 @@ static struct uprobe *alloc_uprobe(struct inode *inode, loff_t offset)
>
>  	uprobe->inode = igrab(inode);
>  	uprobe->offset = offset;
> +	uprobe->consumers = NULL;
> +	uprobe->return_consumers = NULL;

unneeded.

> +/*
> + * A longjmp may cause one or more uretprobed functions to terminate without
> + * returning.

Yes... Plus, we should protect against other attacks...

Those functions' return_instances need to be recycled.
> + * We detect this when any uretprobed function is subsequently called
> + * or returns. A bypassed return_instance's stack pointer is beyond the
> + * current stack.
> + */
> +static inline void uretprobe_bypass_instances(unsigned long cursp, struct uprobe_task *utask)
> +{
> +	struct hlist_node *r1, *r2;
> +	struct return_instance *ri;
> +	struct hlist_head *head = &utask->return_instances;
> +
> +	hlist_for_each_entry_safe(ri, r1, r2, head, hlist) {
> +		if (compare_stack_ptrs(cursp, ri->sp)) {
> +			hlist_del(&ri->hlist);
> +			kfree(ri);

Not sure this will always work, but lets discuss this later.

If nothing else, I wouldn't trust compare_stack_ptrs()... sigaltstack()
can fool this logic afaics.

So far I do not understand this code in details, but it seems that even
the trivial case like

	void ddos_uretpobe(void)
	{
		return ddos_uretpobe();
	}

can lead to the problem (without tail call optimization). The user-space
stack is huge, we should not allow ->return_instances to grow without
any limits, and note that this memory is not accounted.

> +static void prepare_uretprobe(struct uprobe *uprobe, struct pt_regs *regs)
> +{
> +	struct uprobe_task *utask;
> +	struct xol_area *area;
> +	struct return_instance *ri;
> +	unsigned long rp_trampoline_vaddr = 0;
> +
> +	utask = current->utask;
> +	area = get_xol_area(current->mm);
> +	if (area)
> +		rp_trampoline_vaddr = area->rp_trampoline_vaddr;
> +
> +	if (!rp_trampoline_vaddr) {
> +		rp_trampoline_vaddr = xol_get_trampoline_slot();

I already mentioned that we probably do not need xol_get_trampoline_slot().
But at least we need xol_alloc_area(), yes.

However, I do not think it is fine to call it here, under ->register_rwsem.
(xol_get_trampoline_slot is even worse btw) perhaps we should do this before
handler_chain().

I think we should refactor handle_swbp/pre_ssout a bit and do _alloc before
handler_chain(). OK, we will see.

> +		if (!rp_trampoline_vaddr)
> +			return;
> +	}
> +
> +	ri = (struct return_instance *)kzalloc(sizeof(struct return_instance),
> +						GFP_KERNEL);
> +	if (!ri)
> +		return;
> +
> +	ri->orig_return_vaddr = arch_uretprobe_hijack_return_addr(rp_trampoline_vaddr, regs);
> +	if (likely(ri->orig_return_vaddr)) {
> +		ri->sp = arch_uretprobe_predict_sp_at_return(regs, current);
> +		uretprobe_bypass_instances(ri->sp, utask);
> +		ri->uprobe = uprobe;

And what protects ri->uprobe? It can go away. See also my reply to 0/6.

Oleg.

