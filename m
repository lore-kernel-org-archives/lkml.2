Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751709Ab1AJF4v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 00:56:51 -0500
Received: from gate.crashing.org ([63.228.1.57]:34427 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009Ab1AJF4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 00:56:50 -0500
Subject: Re: [PATCH] memblock: Don't adjust size in memblock_find_base()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>
In-Reply-To: <4D277A8C.5010502@kernel.org>
References: <AANLkTikknHfA4TQw+SMH-EyJBHoNHXk8Rheq4=K4jNWA@mail.gmail.com>
	 <alpine.DEB.2.00.1012291637270.6040@chino.kir.corp.google.com>
	 <4D1BD928.50701@zytor.com>
	 <alpine.DEB.2.00.1012291702180.7374@chino.kir.corp.google.com>
	 <4D1BE615.4000700@zytor.com> <20101230090648.GB7306@elte.hu>
	 <20101230102815.GA29822@elte.hu> <20101230103002.GA30020@elte.hu>
	 <AANLkTimeqrLzDuqBoSvmkSJWMc7u3PeRf37vjzBca2Lh@mail.gmail.com>
	 <AANLkTimpyRXS9dNFATh4GqtA46uynutAvK7Qb5S7WPFO@mail.gmail.com>
	 <20110105134434.GA22816@elte.hu>  <4D277A8C.5010502@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 Jan 2011 16:56:29 +1100
Message-ID: <1294638989.17779.296.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-07 at 12:41 -0800, Yinghai Lu wrote:
> While applying patch to use memblock to find aperture for 64bit x86.
> Ingo found system with 1g + force_iommu

Please run that through DaveM. I seem to remember that he relies on the
size alignment to ensure that a lot of tiny allocations get properly
coalesced or he runs out of regions at boot time.

A better option would be to use a fixed alignment, or sized based but
with a max threshold such as PAGE_SIZE.

Cheers,
Ben.

> > No AGP bridge found
> > Node 0: aperture @ 38000000 size 32 MB
> > Aperture pointing to e820 RAM. Ignoring.
> > Your BIOS doesn't leave a aperture memory hole
> > Please enable the IOMMU option in the BIOS setup
> > This costs you 64 MB of RAM
> > Cannot allocate aperture memory hole (0,65536K)
> 
> the corresponding code:
> 	addr = memblock_find_in_range(0, 1ULL<<32, aper_size, 512ULL<<20);
> 	if (addr == MEMBLOCK_ERROR || addr + aper_size > 0xffffffff) {
> 		printk(KERN_ERR
> 			"Cannot allocate aperture memory hole (%lx,%uK)\n",
> 				addr, aper_size>>10);
> 		return 0;
> 	}
> 	memblock_x86_reserve_range(addr, addr + aper_size, "aperture64")
> 
> it fails because memblock core code align the size with 512M. that could make
> size way too big.
> 
> So don't align the size in that case.
> 
> actually __memblock_alloc_base, the another caller already align that before calling that function.
> 
> BTW. x86 does not use __memblock_alloc_base...
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  mm/memblock.c |    2 --
>  1 file changed, 2 deletions(-)
> 
> Index: linux-2.6/mm/memblock.c
> ===================================================================
> --- linux-2.6.orig/mm/memblock.c
> +++ linux-2.6/mm/memblock.c
> @@ -137,8 +137,6 @@ static phys_addr_t __init_memblock membl
>  
>  	BUG_ON(0 == size);
>  
> -	size = memblock_align_up(size, align);
> -
>  	/* Pump up max_addr */
>  	if (end == MEMBLOCK_ALLOC_ACCESSIBLE)
>  		end = memblock.current_limit;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


