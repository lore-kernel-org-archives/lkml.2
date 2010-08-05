Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759819Ab0HEJ2y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 05:28:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41221 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751667Ab0HEJ2v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 05:28:51 -0400
Message-ID: <4C5A844C.60105@redhat.com>
Date: Thu, 05 Aug 2010 12:28:44 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [PATCH] kvm: make mmu_shrink() fit shrinker's requirement
References: <4C591313.50402@cn.fujitsu.com>
In-Reply-To: <4C591313.50402@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 08/04/2010 10:13 AM, Lai Jiangshan wrote:
> mmu_shrink() should attempt to free @nr_to_scan entries.
>

This conflicts with Dave's patchset.

Dave, what's going on with those patches?  They're starting to smell.

> @@ -3138,37 +3138,51 @@ static int mmu_shrink(struct shrinker *shrink, int nr_to_scan, gfp_t gfp_mask)
>   {
>   	struct kvm *kvm;
>   	struct kvm *kvm_freed = NULL;
> +	struct kvm *kvm_last;
>   	int cache_count = 0;
>
>   	spin_lock(&kvm_lock);
>
> -	list_for_each_entry(kvm,&vm_list, vm_list) {
> +	if (list_empty(&vm_list))
> +		goto out;
> +
> +	kvm_last = list_entry(vm_list.prev, struct kvm, vm_list);
> +
> +	for (;;) {
>   		int npages, idx, freed_pages;
>   		LIST_HEAD(invalid_list);
>
> +		kvm = list_first_entry(&vm_list, struct kvm, vm_list);
>   		idx = srcu_read_lock(&kvm->srcu);
>   		spin_lock(&kvm->mmu_lock);
>   		npages = kvm->arch.n_alloc_mmu_pages -
>   			 kvm->arch.n_free_mmu_pages;
> -		cache_count += npages;
> -		if (!kvm_freed&&  nr_to_scan>  0&&  npages>  0) {
> +		if (kvm_last)
> +			cache_count += npages;
> +		if (nr_to_scan>  0&&  npages>  0) {
>   			freed_pages = kvm_mmu_remove_some_alloc_mmu_pages(kvm,
>   							&invalid_list);
> +			kvm_mmu_commit_zap_page(kvm,&invalid_list);
>   			cache_count -= freed_pages;
>   			kvm_freed = kvm;
> -		}
> -		nr_to_scan--;
> +			nr_to_scan -= freed_pages;
> +		} else if (kvm == kvm_freed)
> +			nr_to_scan = 0; /* no more page to be freed, break */
>
> -		kvm_mmu_commit_zap_page(kvm,&invalid_list);
>   		spin_unlock(&kvm->mmu_lock);
>   		srcu_read_unlock(&kvm->srcu, idx);
> -	}
> -	if (kvm_freed)
>   		list_move_tail(&kvm_freed->vm_list,&vm_list);
>
> +		if (kvm == kvm_last) /* just scaned all vms */
> +			kvm_last = NULL;
> +		if (!kvm_last&&  (nr_to_scan<= 0 || !kvm_freed))
> +			break;
> +	}
> +
> +out:
>   	spin_unlock(&kvm_lock);
>
> -	return cache_count;
> +	return cache_count<  0 ? 0 : cache_count;
>   }
>
>   static struct shrinker mmu_shrinker = {
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
error compiling committee.c: too many arguments to function

