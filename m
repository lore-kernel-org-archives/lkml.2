Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933007Ab2IUSmQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 14:42:16 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:47285 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932414Ab2IUSmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 14:42:14 -0400
Date: Fri, 21 Sep 2012 14:42:12 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Cyril Chemparathy <cyril@ti.com>
cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        arnd@arndb.de, catalin.marinas@arm.com, grant.likely@secretlab.ca,
        linux@arm.linux.org.uk, will.deacon@arm.com,
        Vitaly Andrianov <vitalya@ti.com>
Subject: Re: [PATCH v3 17/17] ARM: mm: clean up membank size limit checks
In-Reply-To: <1347385155-11643-18-git-send-email-cyril@ti.com>
Message-ID: <alpine.LFD.2.02.1209211441520.6667@xanadu.home>
References: <1347385155-11643-1-git-send-email-cyril@ti.com> <1347385155-11643-18-git-send-email-cyril@ti.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Sep 2012, Cyril Chemparathy wrote:

> This patch cleans up the highmem sanity check code by simplifying the range
> checks with a pre-calculated size_limit.  This patch should otherwise have no
> functional impact on behavior.
> 
> This patch also removes a redundant (bank->start < vmalloc_limit) check, since
> this is already covered by the !highmem condition.
> 
> Signed-off-by: Cyril Chemparathy <cyril@ti.com>
> Signed-off-by: Vitaly Andrianov <vitalya@ti.com>

Acked-by: Nicolas Pitre <nico@linaro.org>

> ---
>  arch/arm/mm/mmu.c |   19 +++++++++++--------
>  1 file changed, 11 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
> index 6c35483..50d9df5 100644
> --- a/arch/arm/mm/mmu.c
> +++ b/arch/arm/mm/mmu.c
> @@ -917,10 +917,15 @@ void __init sanity_check_meminfo(void)
>  
>  	for (i = 0, j = 0; i < meminfo.nr_banks; i++) {
>  		struct membank *bank = &meminfo.bank[j];
> +		phys_addr_t size_limit;
> +
>  		*bank = meminfo.bank[i];
> +		size_limit = bank->size;
>  
>  		if (bank->start >= vmalloc_limit)
>  			highmem = 1;
> +		else
> +			size_limit = vmalloc_limit - bank->start;
>  
>  		bank->highmem = highmem;
>  
> @@ -929,8 +934,7 @@ void __init sanity_check_meminfo(void)
>  		 * Split those memory banks which are partially overlapping
>  		 * the vmalloc area greatly simplifying things later.
>  		 */
> -		if (!highmem && bank->start < vmalloc_limit &&
> -		    bank->size > vmalloc_limit - bank->start) {
> +		if (!highmem && bank->size > size_limit) {
>  			if (meminfo.nr_banks >= NR_BANKS) {
>  				printk(KERN_CRIT "NR_BANKS too low, "
>  						 "ignoring high memory\n");
> @@ -939,12 +943,12 @@ void __init sanity_check_meminfo(void)
>  					(meminfo.nr_banks - i) * sizeof(*bank));
>  				meminfo.nr_banks++;
>  				i++;
> -				bank[1].size -= vmalloc_limit - bank->start;
> +				bank[1].size -= size_limit;
>  				bank[1].start = vmalloc_limit;
>  				bank[1].highmem = highmem = 1;
>  				j++;
>  			}
> -			bank->size = vmalloc_limit - bank->start;
> +			bank->size = size_limit;
>  		}
>  #else
>  		/*
> @@ -962,14 +966,13 @@ void __init sanity_check_meminfo(void)
>  		 * Check whether this memory bank would partially overlap
>  		 * the vmalloc area.
>  		 */
> -		if (bank->start + bank->size > vmalloc_limit)
> -			unsigned long newsize = vmalloc_limit - bank->start;
> +		if (bank->size > size_limit) {
>  			printk(KERN_NOTICE "Truncating RAM at %.8llx-%.8llx "
>  			       "to -%.8llx (vmalloc region overlap).\n",
>  			       (unsigned long long)bank->start,
>  			       (unsigned long long)bank->start + bank->size - 1,
> -			       (unsigned long long)bank->start + newsize - 1);
> -			bank->size = newsize;
> +			       (unsigned long long)bank->start + size_limit - 1);
> +			bank->size = size_limit;
>  		}
>  #endif
>  		if (!bank->highmem && bank->start + bank->size > arm_lowmem_limit)
> -- 
> 1.7.9.5
> 
