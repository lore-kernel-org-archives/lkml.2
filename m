Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856Ab1BUJrh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 04:47:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1035 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753147Ab1BUJrg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 04:47:36 -0500
Date: Mon, 21 Feb 2011 11:47:31 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH] kvm: allow RO page when atomic && !write_fault
Message-ID: <20110221094731.GI14984@redhat.com>
References: <4D61E058.9080201@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D61E058.9080201@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 21, 2011 at 11:47:36AM +0800, Lai Jiangshan wrote:
> 
> Atomic-able hva_to_pfn() patches and allow-read-only-page patches
> are merged almost the same time. But hva_to_pfn() does not handle
> these two issues well together.
> 
> When @atomic && !@write_fault && host-is-read-only-page-mapped
> the code will return fault_page, actually, it will be better
> if we return the pfn of the read-only-page.
> 
This patch will conflict with not yet applied https://lkml.org/lkml/2011/2/1/94
What it the status of that patch?

> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 1fa0d29..f49cfc0 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1060,31 +1060,27 @@ static pfn_t hva_to_pfn(struct kvm *kvm, unsigned long addr, bool atomic,
>  	BUG_ON(!write_fault && !writable);
>  
>  	if (writable)
> -		*writable = true;
> +		*writable = write_fault;
>  
>  	if (atomic || async)
> -		npages = __get_user_pages_fast(addr, 1, 1, page);
> +		npages = __get_user_pages_fast(addr, 1, write_fault, page);
>  
>  	if (unlikely(npages != 1) && !atomic) {
>  		might_sleep();
> -
> -		if (writable)
> -			*writable = write_fault;
> -
>  		npages = get_user_pages_fast(addr, 1, write_fault, page);
> +	}
>  
> -		/* map read fault as writable if possible */
> -		if (unlikely(!write_fault) && npages == 1) {
> -			struct page *wpage[1];
> +	/* map read fault as writable if possible */
> +	if (unlikely(!write_fault) && npages == 1) {
> +		struct page *wpage[1];
>  
> -			npages = __get_user_pages_fast(addr, 1, 1, wpage);
> -			if (npages == 1) {
> -				*writable = true;
> -				put_page(page[0]);
> -				page[0] = wpage[0];
> -			}
> -			npages = 1;
> +		npages = __get_user_pages_fast(addr, 1, 1, wpage);
> +		if (npages == 1) {
> +			*writable = true;
> +			put_page(page[0]);
> +			page[0] = wpage[0];
>  		}
> +		npages = 1;
>  	}
>  
>  	if (unlikely(npages != 1)) {
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--
			Gleb.
