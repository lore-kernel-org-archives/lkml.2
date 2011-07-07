Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006Ab1GGRlL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 13:41:11 -0400
Received: from relais.videotron.ca ([24.201.245.36]:49863 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237Ab1GGRlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 13:41:08 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Thu, 07 Jul 2011 13:41:05 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv2] arm: mm: Poison freed init memory
In-reply-to: <1310057247-4933-1-git-send-email-sboyd@codeaurora.org>
Message-id: <alpine.LFD.2.00.1107071340420.14596@xanadu.home>
References: <20110706210106.GX8286@n2100.arm.linux.org.uk>
 <1310057247-4933-1-git-send-email-sboyd@codeaurora.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jul 2011, Stephen Boyd wrote:

> Poisoning __init marked memory can be useful when tracking down
> obscure memory corruption bugs. Therefore, poison init memory
> with 0xe7fddef0 to catch bugs earlier. The poison value is an
> undefined instruction in ARM mode and branch to an undefined
> instruction in Thumb mode.
> 
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

Acked-by: Nicolas Pitre <nicolas.pitre@linaro.org>



> ---
> 
> On 7/6/2011 2:01 PM, Russell King - ARM Linux wrote:
> > On Wed, Jul 06, 2011 at 01:55:54PM -0700, Stephen Boyd wrote:
> >> Should it include the initrd too? At least x86 poisons that memory but I
> >> don't know who would be using that incorrectly.
> >
> > It could do - I don't see any harm in not doing so.  The only issue
> > is that people may want to disable this stuff if they're after
> > squeezing every last ms out of the boot time.
> 
> I haven't done this. I hope a follow up patch will suffice.
> 
> >
> >> How about a free_init_area() function which calls free_area() after
> >> poisoning the memory?
> >
> > I need to go back and look at the Integrator etc situation with regard
> > to reorganizing the vmlinux layout - it may be that the omission of
> > freeing .init memory can now be removed (it was there to stop the
> > memory being used as the first K of memory wasn't DMA-able.)
> >
> > Assuming it has to stay though, we still should arrange for the initrd
> > memory to be poisoned even if it isn't freed.
> 
> Is this is patch what you're saying? I would have liked to do a
> free_init_area() wrapper, but until the Integrator situation can be
> sorted it doesn't look worthwhile.
> 
>  arch/arm/mm/init.c |   17 ++++++++++++++++-
>  1 files changed, 16 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
> index c19571c..d6360b1 100644
> --- a/arch/arm/mm/init.c
> +++ b/arch/arm/mm/init.c
> @@ -422,6 +422,17 @@ static inline int free_area(unsigned long pfn, unsigned long end, char *s)
>  	return pages;
>  }
>  
> +/*
> + * Poison init memory with an undefined instruction (ARM) or a branch to an
> + * undefined instruction (Thumb).
> + */
> +static inline void poison_init_mem(void *s, size_t count)
> +{
> +	u32 *p = (u32 *)s;
> +	while ((count = count - 4))
> +		*p++ = 0xe7fddef0;
> +}
> +
>  static inline void
>  free_memmap(unsigned long start_pfn, unsigned long end_pfn)
>  {
> @@ -704,11 +715,13 @@ void free_initmem(void)
>  #ifdef CONFIG_HAVE_TCM
>  	extern char __tcm_start, __tcm_end;
>  
> +	poison_init_mem(&__tcm_start, &__tcm_end - &__tcm_start);
>  	totalram_pages += free_area(__phys_to_pfn(__pa(&__tcm_start)),
>  				    __phys_to_pfn(__pa(&__tcm_end)),
>  				    "TCM link");
>  #endif
>  
> +	poison_init_mem(__init_begin, __init_end - __init_begin);
>  	if (!machine_is_integrator() && !machine_is_cintegrator())
>  		totalram_pages += free_area(__phys_to_pfn(__pa(__init_begin)),
>  					    __phys_to_pfn(__pa(__init_end)),
> @@ -721,10 +734,12 @@ static int keep_initrd;
>  
>  void free_initrd_mem(unsigned long start, unsigned long end)
>  {
> -	if (!keep_initrd)
> +	if (!keep_initrd) {
> +		poison_init_mem((void *)start, PAGE_ALIGN(end) - start);
>  		totalram_pages += free_area(__phys_to_pfn(__pa(start)),
>  					    __phys_to_pfn(__pa(end)),
>  					    "initrd");
> +	}
>  }
>  
>  static int __init keepinitrd_setup(char *__unused)
> -- 
> Sent by an employee of the Qualcomm Innovation Center, Inc.
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
