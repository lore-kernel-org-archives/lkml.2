Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934076Ab0D3TZ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 15:25:56 -0400
Received: from mail.windriver.com ([147.11.1.11]:56959 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759536Ab0D3TZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 15:25:42 -0400
Date: Fri, 30 Apr 2010 23:34:42 +0800
From: Liang Li <liang.li@windriver.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       wangchen@cn.fujitsu.com, tglx@linutronix.de, hpa@zytor.com,
       yinghai@kernel.org, jeremy.fitzhardinge@citrix.com,
       konrad.wilk@oracle.com
Subject: Re: [v3 PATCH] x86: let 'reservetop' functioning right
Message-ID: <20100430153442.GA18064@localhost>
Reply-To: Liang Li <liang.li@windriver.com>
References: <1272621711-8683-1-git-send-email-liang.li@windriver.com>
 <20100430102205.GE14202@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100430102205.GE14202@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-OriginalArrivalTime: 30 Apr 2010 15:36:38.0039 (UTC) FILETIME=[EC3A7A70:01CAE87A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 30, 2010 at 12:22:05PM +0200, Ingo Molnar wrote:
> 
> * Liang Li <liang.li@windriver.com> wrote:
> 
> > When specify 'reservetop=0xbadc0de' kernel parameter, the kernel will
> > stop booting due to a early_ioremap bug that relate to commit 8827247ff.
> > 
> > The root cause of boot failure problem is the value of 'slot_virt[i]'
> > was initialized in setup_arch->early_ioremap_init. But later in
> > setup_arch, the function 'parse_early_param' will modify 'FIXADDR_TOP'
> > when 'reservetop=0xbadc0de' being specified.
> > 
> > The simplest fix might be use __fix_to_virt(idx0) to get updated value
> > of 'FIXADDR_TOP' in '__early_ioremap' instead of reference old value
> > from slot_virt[slot] directly.
> > 
> > Changelog since v0:
> > 
> > -v1: When reservetop being handled then FIXADDR_TOP get adjusted, Hence
> > check prev_map then re-initialize slot_virt and PMD based on new
> > FIXADDR_TOP.
> > 
> > -v2: place fixup_early_ioremap hence call early_ioremap_init in
> > reserve_top_address  to re-initialize slot_virt and corresponding PMD
> > when parse_reservertop
> > 
> > -v3: move fixup_early_ioremap out of reserve_top_address to make sure
> > other clients of reserve_top_address like xen/lguest won't broken
> > 
> > Signed-off-by: Liang Li <liang.li@windriver.com>
> > Cc: Wang Chen <wangchen@cn.fujitsu.com>
> > Cc: Ingo Molnar <mingo@elte.hu>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: "H. Peter Anvin" <hpa@zytor.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Acked-by: Yinghai Lu <yinghai@kernel.org>
> > Acked-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> > Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > ---
> > Hi all,
> > 
> > Just resend the patch according to Ingo's demand.
> > Thanks.
> > 
> >  arch/x86/include/asm/io.h |    1 +
> >  arch/x86/mm/ioremap.c     |   15 +++++++++++++++
> >  arch/x86/mm/pgtable_32.c  |    1 +
> >  3 files changed, 17 insertions(+), 0 deletions(-)
> 
> Applied, thanks. Note, i cleaned up the fixup_early_ioremap() code (and 
> changed the BUG_ON to WARN_ON - we dont want to crash the box), mind double 
> checking the end result? See the commit below.

Checked. It is fine. Thanks. :)

Regards,
		-Liang Li

> 
> 	Ingo
> 
> ----------------->
> >From e67a807f3d9a82fa91817871f1c0e2e04da993b8 Mon Sep 17 00:00:00 2001
> From: Liang Li <liang.li@windriver.com>
> Date: Fri, 30 Apr 2010 18:01:51 +0800
> Subject: [PATCH] x86: Fix 'reservetop=' functionality
> 
> When specifying the 'reservetop=0xbadc0de' kernel parameter,
> the kernel will stop booting due to a early_ioremap bug that
> relates to commit 8827247ff.
> 
> The root cause of boot failure problem is the value of
> 'slot_virt[i]' was initialized in setup_arch->early_ioremap_init().
> But later in setup_arch, the function 'parse_early_param' will
> modify 'FIXADDR_TOP' when 'reservetop=0xbadc0de' being specified.
> 
> The simplest fix might be use __fix_to_virt(idx0) to get updated
> value of 'FIXADDR_TOP' in '__early_ioremap' instead of reference
> old value from slot_virt[slot] directly.
> 
> Changelog since v0:
> 
> -v1: When reservetop being handled then FIXADDR_TOP get
>      adjusted, Hence check prev_map then re-initialize slot_virt and
>      PMD based on new FIXADDR_TOP.
> 
> -v2: place fixup_early_ioremap hence call early_ioremap_init in
>      reserve_top_address  to re-initialize slot_virt and
>      corresponding PMD when parse_reservertop
> 
> -v3: move fixup_early_ioremap out of reserve_top_address to make
>      sure other clients of reserve_top_address like xen/lguest won't
>      broken
> 
> Signed-off-by: Liang Li <liang.li@windriver.com>
> Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Acked-by: Yinghai Lu <yinghai@kernel.org>
> Acked-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> Cc: Wang Chen <wangchen@cn.fujitsu.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> LKML-Reference: <1272621711-8683-1-git-send-email-liang.li@windriver.com>
> [ fixed three small cleanliness details in fixup_early_ioremap() ]
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/include/asm/io.h |    1 +
>  arch/x86/mm/ioremap.c     |   14 ++++++++++++++
>  arch/x86/mm/pgtable_32.c  |    1 +
>  3 files changed, 16 insertions(+), 0 deletions(-)
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
> index 5eb1ba7..12e4d2d 100644
> --- a/arch/x86/mm/ioremap.c
> +++ b/arch/x86/mm/ioremap.c
> @@ -448,6 +448,20 @@ static inline void __init early_clear_fixmap(enum fixed_addresses idx)
>  static void __iomem *prev_map[FIX_BTMAPS_SLOTS] __initdata;
>  static unsigned long prev_size[FIX_BTMAPS_SLOTS] __initdata;
>  
> +void __init fixup_early_ioremap(void)
> +{
> +	int i;
> +
> +	for (i = 0; i < FIX_BTMAPS_SLOTS; i++) {
> +		if (prev_map[i]) {
> +			WARN_ON(1);
> +			break;
> +		}
> +	}
> +
> +	early_ioremap_init();
> +}
> +
>  static int __init check_early_ioremap_leak(void)
>  {
>  	int count = 0;
> diff --git a/arch/x86/mm/pgtable_32.c b/arch/x86/mm/pgtable_32.c
> index 1a8faf0..26eadaa 100644
> --- a/arch/x86/mm/pgtable_32.c
> +++ b/arch/x86/mm/pgtable_32.c
> @@ -128,6 +128,7 @@ static int __init parse_reservetop(char *arg)
>  
>  	address = memparse(arg, &arg);
>  	reserve_top_address(address);
> +	fixup_early_ioremap();
>  	return 0;
>  }
>  early_param("reservetop", parse_reservetop);
