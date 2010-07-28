Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751578Ab0G1Ewo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 00:52:44 -0400
Received: from gate.crashing.org ([63.228.1.57]:39616 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944Ab0G1Ewl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 00:52:41 -0400
Subject: Re: [PATCH 02/16] bootmem, x86: Add weak version of
 reserve_bootmem_generic
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
In-Reply-To: <1279824241-17582-3-git-send-email-yinghai@kernel.org>
References: <1279824241-17582-1-git-send-email-yinghai@kernel.org>
	 <1279824241-17582-3-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Jul 2010 14:51:56 +1000
Message-ID: <1280292716.1970.225.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-22 at 11:43 -0700, Yinghai Lu wrote:
> It will be used memblock_x86_to_bootmem converting

The above doesn't make much sense.

Appart from that, no objection.

Ben.

> It is an wrapper for reserve_bootmem, and x86 64bit is using special one.
> 
> Also clean up that version for x86_64. We don't need to take care of numa
> path for that, bootmem can handle it how
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  arch/x86/mm/init_32.c |    6 ------
>  arch/x86/mm/init_64.c |   20 ++------------------
>  mm/bootmem.c          |    6 ++++++
>  3 files changed, 8 insertions(+), 24 deletions(-)
> 
> diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
> index bca7909..90e0545 100644
> --- a/arch/x86/mm/init_32.c
> +++ b/arch/x86/mm/init_32.c
> @@ -1069,9 +1069,3 @@ void mark_rodata_ro(void)
>  #endif
>  }
>  #endif
> -
> -int __init reserve_bootmem_generic(unsigned long phys, unsigned long len,
> -				   int flags)
> -{
> -	return reserve_bootmem(phys, len, flags);
> -}
> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> index ee41bba..634fa08 100644
> --- a/arch/x86/mm/init_64.c
> +++ b/arch/x86/mm/init_64.c
> @@ -799,13 +799,10 @@ void mark_rodata_ro(void)
>  
>  #endif
>  
> +#ifndef CONFIG_NO_BOOTMEM
>  int __init reserve_bootmem_generic(unsigned long phys, unsigned long len,
>  				   int flags)
>  {
> -#ifdef CONFIG_NUMA
> -	int nid, next_nid;
> -	int ret;
> -#endif
>  	unsigned long pfn = phys >> PAGE_SHIFT;
>  
>  	if (pfn >= max_pfn) {
> @@ -821,21 +818,7 @@ int __init reserve_bootmem_generic(unsigned long phys, unsigned long len,
>  		return -EFAULT;
>  	}
>  
> -	/* Should check here against the e820 map to avoid double free */
> -#ifdef CONFIG_NUMA
> -	nid = phys_to_nid(phys);
> -	next_nid = phys_to_nid(phys + len - 1);
> -	if (nid == next_nid)
> -		ret = reserve_bootmem_node(NODE_DATA(nid), phys, len, flags);
> -	else
> -		ret = reserve_bootmem(phys, len, flags);
> -
> -	if (ret != 0)
> -		return ret;
> -
> -#else
>  	reserve_bootmem(phys, len, flags);
> -#endif
>  
>  	if (phys+len <= MAX_DMA_PFN*PAGE_SIZE) {
>  		dma_reserve += len / PAGE_SIZE;
> @@ -844,6 +827,7 @@ int __init reserve_bootmem_generic(unsigned long phys, unsigned long len,
>  
>  	return 0;
>  }
> +#endif
>  
>  int kern_addr_valid(unsigned long addr)
>  {
> diff --git a/mm/bootmem.c b/mm/bootmem.c
> index 142c84a..bde170d 100644
> --- a/mm/bootmem.c
> +++ b/mm/bootmem.c
> @@ -526,6 +526,12 @@ int __init reserve_bootmem(unsigned long addr, unsigned long size,
>  }
>  
>  #ifndef CONFIG_NO_BOOTMEM
> +int __weak __init reserve_bootmem_generic(unsigned long phys, unsigned long len,
> +				   int flags)
> +{
> +	return reserve_bootmem(phys, len, flags);
> +}
> +
>  static unsigned long __init align_idx(struct bootmem_data *bdata,
>  				      unsigned long idx, unsigned long step)
>  {


