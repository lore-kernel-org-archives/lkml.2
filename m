Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751338Ab2HLEgZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 00:36:25 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:33210 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743Ab2HLEgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 00:36:24 -0400
Date: Sun, 12 Aug 2012 00:36:21 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Cyril Chemparathy <cyril@ti.com>
cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        arnd@arndb.de, catalin.marinas@arm.com, grant.likely@secretlab.ca,
        linux@arm.linux.org.uk, will.deacon@arm.com,
        Vitaly Andrianov <vitalya@ti.com>
Subject: Re: [PATCH v2 16/22] ARM: mm: cleanup checks for membank overlap
 with vmalloc area
In-Reply-To: <1344648306-15619-17-git-send-email-cyril@ti.com>
Message-ID: <alpine.LFD.2.02.1208120034220.5231@xanadu.home>
References: <1344648306-15619-1-git-send-email-cyril@ti.com> <1344648306-15619-17-git-send-email-cyril@ti.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Aug 2012, Cyril Chemparathy wrote:

> On Keystone platforms, physical memory is entirely outside the 32-bit
> addressible range.  Therefore, the (bank->start > ULONG_MAX) check below marks
> the entire system memory as highmem, and this causes unpleasentness all over.
> 
> This patch eliminates the extra bank start check (against ULONG_MAX) by
> checking bank->start against the physical address corresponding to vmalloc_min
> instead.
> 
> In the process, this patch also cleans up parts of the highmem sanity check
> code by removing what has now become a redundant check for banks that entirely
> overlap with the vmalloc range.

Are you sure of this?  The code that you removed not only checks for 
banks that fall into the vmalloc area, but it also skipp them.  This is 
now lost.

> Signed-off-by: Cyril Chemparathy <cyril@ti.com>
> Signed-off-by: Vitaly Andrianov <vitalya@ti.com>
> ---
>  arch/arm/mm/mmu.c |   19 +------------------
>  1 file changed, 1 insertion(+), 18 deletions(-)
> 
> diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
> index f764c03..3d685c6 100644
> --- a/arch/arm/mm/mmu.c
> +++ b/arch/arm/mm/mmu.c
> @@ -901,15 +901,12 @@ void __init sanity_check_meminfo(void)
>  		struct membank *bank = &meminfo.bank[j];
>  		*bank = meminfo.bank[i];
>  
> -		if (bank->start > ULONG_MAX)
> -			highmem = 1;
> -
> -#ifdef CONFIG_HIGHMEM
>  		if (bank->start >= vmalloc_limit)
>  			highmem = 1;
>  
>  		bank->highmem = highmem;
>  
> +#ifdef CONFIG_HIGHMEM
>  		/*
>  		 * Split those memory banks which are partially overlapping
>  		 * the vmalloc area greatly simplifying things later.
> @@ -932,8 +929,6 @@ void __init sanity_check_meminfo(void)
>  			bank->size = vmalloc_limit - bank->start;
>  		}
>  #else
> -		bank->highmem = highmem;
> -
>  		/*
>  		 * Highmem banks not allowed with !CONFIG_HIGHMEM.
>  		 */
> @@ -946,18 +941,6 @@ void __init sanity_check_meminfo(void)
>  		}
>  
>  		/*
> -		 * Check whether this memory bank would entirely overlap
> -		 * the vmalloc area.
> -		 */
> -		if (bank->start >= vmalloc_limit) {
> -			printk(KERN_NOTICE "Ignoring RAM at %.8llx-%.8llx "
> -			       "(vmalloc region overlap).\n",
> -			       (unsigned long long)bank->start,
> -			       (unsigned long long)bank->start + bank->size - 1);
> -			continue;
> -		}
> -
> -		/*
>  		 * Check whether this memory bank would partially overlap
>  		 * the vmalloc area.
>  		 */
> -- 
> 1.7.9.5
> 
