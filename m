Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562Ab0CTHXP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 03:23:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:34871 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752163Ab0CTHXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 03:23:14 -0400
Message-ID: <4BA449E2.3080707@kernel.org>
Date: Sat, 20 Mar 2010 13:06:58 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: graff.yang@gmail.com
CC: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH] mm/nommu.c:Dynamic alloc/free percpu area for nommu
References: <1268989324-7575-1-git-send-email-graff.yang@gmail.com>
In-Reply-To: <1268989324-7575-1-git-send-email-graff.yang@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 20 Mar 2010 07:22:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 03/19/2010 06:02 PM, graff.yang@gmail.com wrote:
> From: Graff Yang<graff.yang@gmail.com>
>
> This patch supports dynamic alloc/free percpu area for nommu arch like
> blackfin.
> It allocates contiguous pages in funtion pcpu_get_vm_areas() instead of
> getting none contiguous pages then vmap it in mmu arch.
> As we can not get the real page structure through vmalloc_to_page(), so
> it also modified the nommu version vmalloc_to_page()/vmalloc_to_pfn().
>
> Signed-off-by: Graff Yang<graff.yang@gmail.com>

Heh heh... I've never imagined there would be a SMP architecture w/o
mmu.  That's pretty interesting.  I mean, there is real estate for
multiple cores but not for mmu?

> diff --git a/mm/nommu.c b/mm/nommu.c
> index 605ace8..98bbdf4 100644
> --- a/mm/nommu.c
> +++ b/mm/nommu.c
> @@ -255,13 +255,15 @@ EXPORT_SYMBOL(vmalloc_user);
>
>   struct page *vmalloc_to_page(const void *addr)
>   {
> -	return virt_to_page(addr);
> +	return (struct page *)
> +			(virt_to_page(addr)->index) ? : virt_to_page(addr);

Nothing major but isn't it more usual to write ?: without the
intervening space?

> +#ifdef CONFIG_SMP
> +int map_kernel_range_noflush(unsigned long addr, unsigned long size,
> +					pgprot_t prot, struct page **pages)
> +{

More nitpicks.

> +	int i, nr_page = size>>  PAGE_SHIFT;

	       nr_pages = size >> PAGE_SHIFT;

> +	for (i = 0; i<  nr_page; i++, addr += PAGE_SIZE)

		    i < nr_pages

> +		virt_to_page(addr)->index = (pgoff_t)pages[i];
> +	return size>>  PAGE_SHIFT;

	return size >> PAGE_SHIFT;

I think checkpatch would whine about these too.

> +void unmap_kernel_range_noflush(unsigned long addr, unsigned long size)
> +{
> +	int i, nr_page = size>>  PAGE_SHIFT;
> +	for (i = 0; i<  nr_page; i++, addr += PAGE_SIZE)
> +		virt_to_page(addr)->index = 0;
> +}
> +
> +struct vm_struct **pcpu_get_vm_areas(const unsigned long *offsets,
> +					const size_t *sizes, int nr_vms,
> +						size_t align, gfp_t gfp_mask)

Hmmm... in general, one of the reasons the percpu allocation is
complex is to avoid contiguous allocations while avoiding additional
TLB / NUMA overhead on machines with rather complex memory
configuration (which is pretty common these days).  If the memory has
to be allocated contiguous anyway, it probably would be much simpler
to hook at higher level and simply allocate each chunk contiguously.
I'll look into it.

Thanks.

-- 
tejun
