Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751788Ab2LVQ3U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 11:29:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51243 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751668Ab2LVQ3S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 11:29:18 -0500
Date: Sat, 22 Dec 2012 17:29:24 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Anton Arapov <anton@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>
Subject: Re: [RFC PATCH 4/6] uretprobes: invoke return probe handlers
Message-ID: <20121222162924.GD18082@redhat.com>
References: <1356088596-17858-1-git-send-email-anton@redhat.com> <1356088596-17858-5-git-send-email-anton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356088596-17858-5-git-send-email-anton@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21, Anton Arapov wrote:
>
> +static unsigned long uretprobe_run_handlers(struct pt_regs *regs)
> +{
> +	struct hlist_head *head;
> +	struct hlist_node *r1, *r2;
> +
> +	struct return_instance *ri;
> +	struct uprobe_task *utask;
> +
> +	struct xol_area *area;
> +	unsigned long rp_trampoline_vaddr;
> +	unsigned long orig_return_vaddr, cur_sp;
> +
> +	cur_sp = (unsigned long)regs->sp;

This depends on arch/.

BTW, this series will break the compilation on powerpc, I guess.

> +	hlist_for_each_entry_safe(ri, r1, r2, head, hlist) {
> +		if (ri->uprobe

it should never be NULL, no?

> && ri->uprobe->return_consumers)
> +			uretprobe_handler_chain(ri->uprobe, ri->orig_return_vaddr, regs);
                                                                ^^^^^^^^^^^^^^^^^
->orig_return_vaddr can be rp_trampoline_vaddr. Not sure ->handler()
wants this value ;)

> @@ -1567,12 +1625,23 @@ static void handle_swbp(struct pt_regs *regs)
>  {
>  	struct uprobe_task *utask;
>  	struct uprobe *uprobe;
> -	unsigned long bp_vaddr;
> +	struct xol_area *area;
> +	unsigned long bp_vaddr, orig_return_vaddr;
>  	int uninitialized_var(is_swbp);
>
>  	bp_vaddr = uprobe_get_swbp_addr(regs);
> -	uprobe = find_active_uprobe(bp_vaddr, &is_swbp);
> +	area = get_xol_area(current->mm);
> +	if (area) {
> +		if (bp_vaddr == area->rp_trampoline_vaddr) {
> +			orig_return_vaddr = uretprobe_run_handlers(regs);
> +			instruction_pointer_set(regs, orig_return_vaddr);
> +			if (current->utask->doomed)
> +				send_sig(SIGSEGV, current, 0);

Just move this send_sig() into uretprobe_run_handlers() and kill
the ugly utask->doomed.

Oleg.

