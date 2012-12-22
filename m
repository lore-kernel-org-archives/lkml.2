Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700Ab2LVQEJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 11:04:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21714 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511Ab2LVQEG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 11:04:06 -0500
Date: Sat, 22 Dec 2012 17:02:28 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Anton Arapov <anton@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>,
        Anithra P Janakiraman <anithra@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 2/6] uretprobes: trampoline implementation
Message-ID: <20121222160228.GB18082@redhat.com>
References: <1356088596-17858-1-git-send-email-anton@redhat.com> <1356088596-17858-3-git-send-email-anton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356088596-17858-3-git-send-email-anton@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21, Anton Arapov wrote:
>
> +static unsigned long xol_get_trampoline_slot(void)
> +{
> +	struct xol_area *area;
> +	unsigned long offset;
> +	void *vaddr;
> +	uprobe_opcode_t bp_insn = UPROBE_SWBP_INSN;
> +
> +	area = get_xol_area(current->mm);
> +	if (!area) {
> +		area = xol_alloc_area();
> +		if (!area)
> +			return 0;
> +	}
> +
> +	if (!area->rp_trampoline_vaddr)
> +		area->rp_trampoline_vaddr = xol_take_insn_slot(area);
> +
> +	/*
> +	 * Initialize the slot if rp_trampoline_vaddr points to valid
> +	 * instruction slot.
> +	 */
> +	if (unlikely(!area->rp_trampoline_vaddr))
> +		return 0;
> +
> +	offset = area->rp_trampoline_vaddr & ~PAGE_MASK;
> +	vaddr = kmap_atomic(area->page);
> +	memcpy(vaddr + offset, &bp_insn, UPROBE_SWBP_INSN_SIZE);
> +	kunmap_atomic(vaddr);
> +
> +	return area->rp_trampoline_vaddr;
> +}

Oh, this should be unified with xol_get_insn_slot(), we certainly do not
want to copy-and-paste it.

Or. Perhaps even better, do not add this helper at all. xol_alloc_area()
could reserve the first slot/bit for trampoline. And note that in this
case we do not need xol_area->rp_trampoline_vaddr, it is always equal
to xol_area->vaddr.

Oleg.

