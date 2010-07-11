Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902Ab0GKM7d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 08:59:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56422 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752452Ab0GKM7b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 08:59:31 -0400
Message-ID: <4C39C030.6080009@redhat.com>
Date: Sun, 11 Jul 2010 15:59:28 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v5 5/9] KVM: MMU: introduce gfn_to_page_many_atomic()
 function
References: <4C330918.6040709@cn.fujitsu.com> <4C330A00.50108@cn.fujitsu.com>
In-Reply-To: <4C330A00.50108@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/2010 01:48 PM, Xiao Guangrong wrote:
> This function not only return the gfn's page but also the page number
> after @gfn in the slot
>
>
> @@ -923,15 +923,25 @@ static unsigned long gfn_to_hva_memslot(struct kvm_memory_slot *slot, gfn_t gfn)
>   	return slot->userspace_addr + (gfn - slot->base_gfn) * PAGE_SIZE;
>   }
>
> -unsigned long gfn_to_hva(struct kvm *kvm, gfn_t gfn)
> +static unsigned long gfn_to_hva_many(struct kvm *kvm, gfn_t gfn, int *entry)
>   {
>    

'entry' better be gfn_t.  We limit gfns in a slot, but that's 
artificial, let's use the correct type.

Also suggest nr_pages as the name.

> @@ -1011,6 +1021,23 @@ pfn_t gfn_to_pfn_memslot(struct kvm *kvm,
>   	return hva_to_pfn(kvm, addr, false);
>   }
>
> +int gfn_to_page_many_atomic(struct kvm *kvm, gfn_t gfn,
> +			    struct page **pages, int nr_pages, bool *enough)
> +{
> +	unsigned long addr;
> +	int entry, ret;
> +
> +	addr = gfn_to_hva_many(kvm, gfn,&entry);
> +	if (kvm_is_error_hva(addr))
> +		return -1;
> +
> +	entry = min(entry, nr_pages);
> +	*enough = (entry == nr_pages) ? true : false;
>    

s/ ? true : false//; :)

Why not return 0 if !enough?

> +	ret = __get_user_pages_fast(addr, entry, 1, pages);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(gfn_to_page_many_atomic);
> +
>   struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn)
>   {
>   	pfn_t pfn;
>    


-- 
error compiling committee.c: too many arguments to function

