Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828Ab0DHCUe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 22:20:34 -0400
Received: from mail.windriver.com ([147.11.1.11]:57538 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878Ab0DHCUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 22:20:31 -0400
Date: Thu, 8 Apr 2010 10:18:07 +0800
From: Liang Li <liang.li@windriver.com>
To: Yinghai <yinghai.lu@oracle.com>
Cc: akpm@linux-foundation.org, hpa@zytor.com, mingo@elte.hu,
       tglx@linutronix.de, wangchen@cn.fujitsu.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: + x86-fix-handling-of-the-reservetop-boot-option.patch added to
 -mm tree
Message-ID: <20100408021807.GA26543@localhost>
Reply-To: Liang Li <liang.li@windriver.com>
References: <201004072200.o37M0d19009878@imap1.linux-foundation.org>
 <4BBD1AA3.4000204@oracle.com>
 <20100408010558.GA4053@localhost>
 <4BBD2DD4.1060101@oracle.com>
 <20100408015353.GB4053@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100408015353.GB4053@localhost>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-OriginalArrivalTime: 08 Apr 2010 02:19:26.0726 (UTC) FILETIME=[E974D260:01CAD6C1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 08, 2010 at 09:53:53AM +0800, Liang Li wrote:
> On Wed, Apr 07, 2010 at 06:13:56PM -0700, Yinghai wrote:
> > On 04/07/2010 06:05 PM, Liang Li wrote:
> > > On Wed, Apr 07, 2010 at 04:52:03PM -0700, Yinghai wrote:
> > >> On 04/07/2010 03:00 PM, akpm@linux-foundation.org wrote:
> > >>> The patch titled
> > >>>      x86: fix handling of the 'reservetop' boot option
> > >>> has been added to the -mm tree.  Its filename is
> > >>>      x86-fix-handling-of-the-reservetop-boot-option.patch
> > >>>
> > >>> Before you just go and hit "reply", please:
> > >>>    a) Consider who else should be cc'ed
> > >>>    b) Prefer to cc a suitable mailing list as well
> > >>>    c) Ideally: find the original patch on the mailing list and do a
> > >>>       reply-to-all to that, adding suitable additional cc's
> > >>>
> > >>> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> > >>>
> > >>> See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
> > >>> out what to do about this
> > >>>
> > >>> The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/
> > >>>
> > >>> ------------------------------------------------------
> > >>> Subject: x86: fix handling of the 'reservetop' boot option
> > >>> From: Liang Li <liang.li@windriver.com>
> > >>>
> > >>> When specifying the 'reservetop=0xbadc0de' kernel parameter, the kernel
> > >>> will stop booting due to a early_ioremap bug that relate to commit
> > >>> 8827247ff ("x86: don't define __this_fixmap_does_not_exist()").
> > >>>
> > >>> The root cause of boot failure problem is the value of 'slot_virt[i]' was
> > >>> initialized in setup_arch->early_ioremap_init.  But later in setup_arch,
> > >>> the function 'parse_early_param' will modify 'FIXADDR_TOP' when
> > >>> 'reservetop=0xbadc0de' being specified.
> > >>>
> > >>> The simplest fix might be use __fix_to_virt(idx0) to get updated value
> > >>> of 'FIXADDR_TOP' in '__early_ioremap' instead of reference old value
> > >>> from slot_virt[slot] directly.
> > >>>
> > >>> Signed-off-by: Liang Li <liang.li@windriver.com>
> > >>> Cc: Wang Chen <wangchen@cn.fujitsu.com>
> > >>> Cc: Ingo Molnar <mingo@elte.hu>
> > >>> Cc: Thomas Gleixner <tglx@linutronix.de>
> > >>> Cc: "H. Peter Anvin" <hpa@zytor.com>
> > >>> Cc: Yinghai Lu <yinghai@kernel.org>
> > >>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > >>> ---
> > >>>
> > >>>  arch/x86/mm/ioremap.c |    4 ++--
> > >>>  1 file changed, 2 insertions(+), 2 deletions(-)
> > >>>
> > >>> diff -puN arch/x86/mm/ioremap.c~x86-fix-handling-of-the-reservetop-boot-option arch/x86/mm/ioremap.c
> > >>> --- a/arch/x86/mm/ioremap.c~x86-fix-handling-of-the-reservetop-boot-option
> > >>> +++ a/arch/x86/mm/ioremap.c
> > >>> @@ -537,9 +537,9 @@ __early_ioremap(resource_size_t phys_add
> > >>>  		--nrpages;
> > >>>  	}
> > >>>  	if (early_ioremap_debug)
> > >>> -		printk(KERN_CONT "%08lx + %08lx\n", offset, slot_virt[slot]);
> > >>> +		printk(KERN_CONT "%08lx + %08lx\n", offset, __fix_to_virt(idx0));
> > >>>  
> > >>> -	prev_map[slot] = (void __iomem *)(offset + slot_virt[slot]);
> > >>> +	prev_map[slot] = (void __iomem *)(offset + __fix_to_virt(idx0));
> > >>>  	return prev_map[slot];
> > >>>  }
> > >>>  
> > >>> _
> > >>
> > >> not that simple. but it looks like correct direction.
> > >>
> > >> please consider:
> > >> when early_parsing reserve_top, double check if there is left over in prev_map[], and 
> > >> reinitialize slot_virt[] and clear old PMD and  setup new PMD if needed.
> > > 
> > > Hi Yinghai,
> > > 
> > > Thanks for your reply, its better to have eyes on then being ignored. :)
> > > 
> > > Your suggestions were considered before the patch to public, let me try
> > > to explain:
> > > 
> > > #1 check/adjust prev_map[]?
> > > In my tests, seems early_ioremap is untouched between early_ioremap_init
> > > and parse_early_param so I did not check prev_map. Even its get touched,
> > > I think we could do nothing to this mapping, since prev_map[i] just
> > > record virt addr for clients of early_ioremap. We can check and adjust
> > > prev_map but clients of early_ioremap won't realize the fact so nothing
> > > being fixed or broken.
> > 
> > efi related code need them
> > 
> > dmi 
> > 
> > you need to add bug_on if there is still have left over, and need the caller to re map it again later.
> > 
> > > 
> > > #2 reinitialize slot_virt and update PMD
> > > I actually tried this approach, call early_ioremap_init again after
> > > parse_early_param will do that work, it also works but I am not sure
> > > that is the better solution or too heavy for solve the problem? So I
> > > tend to say 'simplest' solution in git commit log.
> > 
> > how about PMD? you don't need set PMD again.
> > 
> > YH
> 
> Hi Yinghai,
> 
> Does this similar modification like this is more preferred?
> 
> diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
> index a1dcfa3..30a3e97 100644
> --- a/arch/x86/include/asm/io.h
> +++ b/arch/x86/include/asm/io.h
> @@ -347,6 +347,7 @@ extern void __iomem *early_ioremap(resource_size_t phys_addr,
>  extern void __iomem *early_memremap(resource_size_t phys_addr,
>  				    unsigned long size);
>  extern void early_iounmap(void __iomem *addr, unsigned long size);
> +extern void fixup_early_ioremap(void);
>  
>  #define IO_SPACE_LIMIT 0xffff
>  
> diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
> index ea82ef0..fe06296 100644
> --- a/arch/x86/mm/ioremap.c
> +++ b/arch/x86/mm/ioremap.c
> @@ -448,6 +448,23 @@ static inline void __init early_clear_fixmap(enum fixed_addresses idx)
>  static void __iomem *prev_map[FIX_BTMAPS_SLOTS] __initdata;
>  static unsigned long prev_size[FIX_BTMAPS_SLOTS] __initdata;
>  
> +void __init fixup_early_ioremap(void)
> +{
> +	int i;
> +	for (i = 0; i < FIX_BTMAPS_SLOTS; i++) {
> +		if (prev_map[i])
> +			break;
> +	}
> +
> +	if (i == FIX_BTMAPS_SLOTS)
> +		WARN_ON(1);

Should be:
	if (i < FIX_BTMAPS_SLOTS)
		WARN_ON(1);

