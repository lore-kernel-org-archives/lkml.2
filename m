Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050Ab0GKNFv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 09:05:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42721 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752452Ab0GKNFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 09:05:50 -0400
Message-ID: <4C39C1AB.6000606@redhat.com>
Date: Sun, 11 Jul 2010 16:05:47 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v5 6/9] KVM: MMU: introduce pte_prefetch_topup_memory_cache()
References: <4C330918.6040709@cn.fujitsu.com> <4C330A37.8080709@cn.fujitsu.com>
In-Reply-To: <4C330A37.8080709@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/2010 01:49 PM, Xiao Guangrong wrote:
> Introduce this function to topup prefetch cache
>
>
>
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 3dcd55d..cda4587 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -89,6 +89,8 @@ module_param(oos_shadow, bool, 0644);
>   	}
>   #endif
>
> +#define PTE_PREFETCH_NUM		16
>    

Let's make it 8 to start with...  It's frightening enough.

(8 = one cache line in both guest and host)

> @@ -316,15 +318,16 @@ static void update_spte(u64 *sptep, u64 new_spte)
>   	}
>   }
>
> -static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache,
> -				  struct kmem_cache *base_cache, int min)
> +static int __mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache,
> +				    struct kmem_cache *base_cache, int min,
> +				    int max, gfp_t flags)
>   {
>   	void *obj;
>
>   	if (cache->nobjs>= min)
>   		return 0;
> -	while (cache->nobjs<  ARRAY_SIZE(cache->objects)) {
> -		obj = kmem_cache_zalloc(base_cache, GFP_KERNEL);
> +	while (cache->nobjs<  max) {
> +		obj = kmem_cache_zalloc(base_cache, flags);
>   		if (!obj)
>   			return -ENOMEM;
>   		cache->objects[cache->nobjs++] = obj;
> @@ -332,6 +335,20 @@ static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache,
>   	return 0;
>   }
>
> +static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache,
> +				  struct kmem_cache *base_cache, int min)
> +{
> +	return __mmu_topup_memory_cache(cache, base_cache, min,
> +				      ARRAY_SIZE(cache->objects), GFP_KERNEL);
> +}
> +
> +static int pte_prefetch_topup_memory_cache(struct kvm_vcpu *vcpu)
> +{
> +	return __mmu_topup_memory_cache(&vcpu->arch.mmu_rmap_desc_cache,
> +					rmap_desc_cache, PTE_PREFETCH_NUM,
> +					PTE_PREFETCH_NUM, GFP_ATOMIC);
> +}
> +
>    

Just make the ordinary topup sufficient for prefetch.  If we allocate 
too much, we don't lose anything, the memory remains for the next time 
around.

Note for shadow pages or pte chains you don't need extra pages, since 
the prefetch fits in just one shadow page.  You only need extra for rmap.

-- 
error compiling committee.c: too many arguments to function

