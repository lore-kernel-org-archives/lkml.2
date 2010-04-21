Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292Ab0DUIpe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 04:45:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37818 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753106Ab0DUIpc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 04:45:32 -0400
Message-ID: <4BCEBB26.1060308@redhat.com>
Date: Wed, 21 Apr 2010 11:45:26 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       kvm@vger.kernel.org
Subject: Re: [PATCH] kvm: don not fail when cache is sufficient
References: <4BC9790F.1070403@cn.fujitsu.com>
In-Reply-To: <4BC9790F.1070403@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2010 12:02 PM, Lai Jiangshan wrote:
> cleanup: don not fail when cache is sufficient
>
> Signed-off-by: Lai Jiangshan<laijs@cn.fujitsu.com>
> ---
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index c8c074c..90f666e 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -304,7 +304,7 @@ static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache,
>   	while (cache->nobjs<  ARRAY_SIZE(cache->objects)) {
>   		obj = kmem_cache_zalloc(base_cache, GFP_KERNEL);
>   		if (!obj)
> -			return -ENOMEM;
> +			return cache->nobjs>= min ? 0 : -ENOMEM;
>   		cache->objects[cache->nobjs++] = obj;
>   	}
>   	return 0;
> @@ -326,7 +326,7 @@ static int mmu_topup_memory_cache_page(struct kvm_mmu_memory_cache *cache,
>   	while (cache->nobjs<  ARRAY_SIZE(cache->objects)) {
>   		page = alloc_page(GFP_KERNEL);
>   		if (!page)
> -			return -ENOMEM;
> +			return  cache->nobjs>= min ? 0 : -ENOMEM;
>   		set_page_private(page, 0);
>   		cache->objects[cache->nobjs++] = page_address(page);
>   	}
>
>    

Have you ever observed this?  My feeling is that if we're a few pages 
from -ENOMEM, it doesn't really matter if we die now or a few calls 
away.  Note alloc_page() can call back into kvm via the shrinker to free 
pages, so an OOM will be external to kvm and we won't really be able to 
handle it.

-- 
error compiling committee.c: too many arguments to function

