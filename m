Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632Ab2JJOHX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 10:07:23 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:36574 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756330Ab2JJOHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 10:07:19 -0400
Date: Wed, 10 Oct 2012 09:55:30 -0400
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] x86, mm: Break down init_all_memory_mapping
Message-ID: <20121010135529.GD4005@phenom.dumpdata.com>
References: <1349827115-16600-1-git-send-email-yinghai@kernel.org>
 <1349827115-16600-6-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349827115-16600-6-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2012 at 04:58:33PM -0700, Yinghai Lu wrote:
> Will replace that will top-down page table initialization.

s/will/with?

> new one need to take range.

Huh? I have no idea what this patch does from your description.
It says it will replace something (not identified) with
top-down table initialization.

And the code is not that simple - you should explain _how_ you
are changing it. From what it did before to what it does _now_.

Think of the audience of kernel engineers who have memory loss
and will forget everything in three months - the perfect time when
the merge window opens and bugs start appearing. They (ok, maybe
it is only me who is needs this) need the documentation to figure
out what went wrong. Please explain it.


> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  arch/x86/mm/init.c |   41 +++++++++++++++++++----------------------
>  1 files changed, 19 insertions(+), 22 deletions(-)
> 
> diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
> index ebf76ce..23ce4db 100644
> --- a/arch/x86/mm/init.c
> +++ b/arch/x86/mm/init.c
> @@ -393,40 +393,30 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
>   * Depending on the alignment of E820 ranges, this may possibly result in using
>   * smaller size (i.e. 4K instead of 2M or 1G) page tables.
>   */
> -static void __init init_all_memory_mapping(void)
> +static void __init init_all_memory_mapping(unsigned long all_start,
> +					   unsigned long all_end)
>  {
>  	unsigned long start_pfn, end_pfn;
>  	int i;
>  
> -	/* the ISA range is always mapped regardless of memory holes */
> -	init_memory_mapping(0, ISA_END_ADDRESS);
> -
>  	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, NULL) {
>  		u64 start = start_pfn << PAGE_SHIFT;
>  		u64 end = end_pfn << PAGE_SHIFT;
>  
> -		if (end <= ISA_END_ADDRESS)
> +		if (end <= all_start)
>  			continue;
>  
> -		if (start < ISA_END_ADDRESS)
> -			start = ISA_END_ADDRESS;
> -#ifdef CONFIG_X86_32
> -		/* on 32 bit, we only map up to max_low_pfn */
> -		if ((start >> PAGE_SHIFT) >= max_low_pfn)
> +		if (start < all_start)
> +			start = all_start;
> +
> +		if (start >= all_end)
>  			continue;
>  
> -		if ((end >> PAGE_SHIFT) > max_low_pfn)
> -			end = max_low_pfn << PAGE_SHIFT;
> -#endif
> -		init_memory_mapping(start, end);
> -	}
> +		if (end > all_end)
> +			end = all_end;
>  
> -#ifdef CONFIG_X86_64
> -	if (max_pfn > max_low_pfn) {
> -		/* can we preseve max_low_pfn ?*/
> -		max_low_pfn = max_pfn;
> +		init_memory_mapping(start, end);
>  	}
> -#endif
>  }
>  
>  void __init init_mem_mapping(void)
> @@ -456,8 +446,15 @@ void __init init_mem_mapping(void)
>  		(pgt_buf_top << PAGE_SHIFT) - 1);
>  
>  	max_pfn_mapped = 0; /* will get exact value next */
> -	init_all_memory_mapping();
> -
> +	/* the ISA range is always mapped regardless of memory holes */
> +	init_memory_mapping(0, ISA_END_ADDRESS);
> +	init_all_memory_mapping(ISA_END_ADDRESS, end);
> +#ifdef CONFIG_X86_64
> +	if (max_pfn > max_low_pfn) {
> +		/* can we preseve max_low_pfn ?*/
> +		max_low_pfn = max_pfn;
> +	}
> +#endif
>  	/*
>  	 * Reserve the kernel pagetable pages we used (pgt_buf_start -
>  	 * pgt_buf_end) and free the other ones (pgt_buf_end - pgt_buf_top)
> -- 
> 1.7.7
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
