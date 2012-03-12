Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707Ab2CLHdA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 03:33:00 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:59982 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614Ab2CLHcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 03:32:51 -0400
Date: Mon, 12 Mar 2012 16:39:16 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
To: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Cc: avi@redhat.com, mtosatti@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] KVM: MMU: Split the main body of
 rmap_write_protect() off from others
Message-Id: <20120312163916.66bfd660.yoshikawa.takuya@oss.ntt.co.jp>
In-Reply-To: <20120301193122.f21dc089.yoshikawa.takuya@oss.ntt.co.jp>
References: <20120301193007.04b2db8e.yoshikawa.takuya@oss.ntt.co.jp>
	<20120301193122.f21dc089.yoshikawa.takuya@oss.ntt.co.jp>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp> wrote:

> -int kvm_mmu_rmap_write_protect(struct kvm *kvm, u64 gfn,
> -			       struct kvm_memory_slot *slot)
> +static int __rmap_write_protect(struct kvm *kvm, unsigned long *rmapp, int level)
>  {
> -	unsigned long *rmapp;
> -	u64 *spte;
> -	int i, write_protected = 0;
> +	u64 *spte = NULL;
> +	int write_protected = 0;
>  
> -	rmapp = __gfn_to_rmap(gfn, PT_PAGE_TABLE_LEVEL, slot);
> -	spte = rmap_next(rmapp, NULL);
> -	while (spte) {
> +	while ((spte = rmap_next(rmapp, spte))) {
>  		BUG_ON(!(*spte & PT_PRESENT_MASK));
>  		rmap_printk("rmap_write_protect: spte %p %llx\n", spte, *spte);
> -		if (is_writable_pte(*spte)) {
> +
> +		if (!is_writable_pte(*spte))
> +			continue;
> +
> +		if (level == PT_PAGE_TABLE_LEVEL) {
>  			mmu_spte_update(spte, *spte & ~PT_WRITABLE_MASK);
> -			write_protected = 1;
> +		} else {
> +			BUG_ON(!is_large_pte(*spte));
> +			drop_spte(kvm, spte);
> +			--kvm->stat.lpages;
> +			spte = NULL;
>  		}
> -		spte = rmap_next(rmapp, spte);
> +
> +		write_protected = 1;
>  	}

Something may change here: when level > PT_PAGE_TABLE_LEVEL, this loop
does not handle lower level mappings after dropping large-ptes.

This may be incorrect.

	Takuya
