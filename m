Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932187Ab3AIQR7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 11:17:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48630 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932081Ab3AIQR6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 11:17:58 -0500
Date: Wed, 9 Jan 2013 17:17:01 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Anton Arapov <anton@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [RFC PATCH v2 3/4] uretprobes: return probe entry, prepare
	uretprobe
Message-ID: <20130109161701.GC27722@redhat.com>
References: <1357730692-3928-1-git-send-email-anton@redhat.com> <1357730692-3928-4-git-send-email-anton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357730692-3928-4-git-send-email-anton@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09, Anton Arapov wrote:
>
> todo:
>   protect uprobe

Yep ;)

>  static struct uprobe_task *get_utask(void)
>  {
> -	if (!current->utask)
> +	if (!current->utask) {
>  		current->utask = kzalloc(sizeof(struct uprobe_task), GFP_KERNEL);
> +		INIT_HLIST_HEAD(&current->utask->return_uprobes);

What if kzalloc() fails?

> +static void prepare_uretprobe(struct uprobe *uprobe, struct pt_regs *regs)
> +{
> +	struct return_uprobe_i *ri;
> +	struct uprobe_task *utask;
> +	struct xol_area *area;
> +	unsigned long rp_trampoline_vaddr = 0;
> +
> +	area = get_xol_area();
> +	if (area)
> +		rp_trampoline_vaddr = area->rp_trampoline_vaddr;
> +	if (!rp_trampoline_vaddr) {
> +		rp_trampoline_vaddr = xol_get_trampoline_slot();

This is obviously racy. But again, so far I think we can simply remove
this.

>  static void handler_chain(struct uprobe *uprobe, struct pt_regs *regs)
>  {
> +	int rc = 0;
>  	struct uprobe_consumer *uc;
>  	int remove = UPROBE_HANDLER_REMOVE;
>  
>  	down_read(&uprobe->register_rwsem);
>  	for (uc = uprobe->consumers; uc; uc = uc->next) {
> -		int rc = uc->handler(uc, regs);
> +		if (uc->handler)
> +			rc = uc->handler(uc, regs);
> +
> +		if (uc->rp_handler)
> +			prepare_uretprobe(uprobe, regs); /* put bp at return */

This doesn't look right. prepare_uretprobe() should not be called
multiple times.

Oleg.

