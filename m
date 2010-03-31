Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756973Ab0CaCxn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 22:53:43 -0400
Received: from mail.windriver.com ([147.11.1.11]:36624 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756161Ab0CaCxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 22:53:42 -0400
Date: Wed, 31 Mar 2010 10:49:44 +0800
From: Liang Li <liang.li@windriver.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, wangchen@cn.fujitsu.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH] x86: let 'reservetop' functioning right
Message-ID: <20100331024944.GB9847@localhost>
Reply-To: Liang Li <liang.li@windriver.com>
References: <1269478445-4335-1-git-send-email-liang.li@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269478445-4335-1-git-send-email-liang.li@windriver.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-OriginalArrivalTime: 31 Mar 2010 02:52:47.0372 (UTC) FILETIME=[3EA12CC0:01CAD07D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Seems the problem still there in 2.6.34-rc3. When pass
'reservetop=0x1000' to x86_32 kernel, kernel hangs on
very early boot stage.

Do we have any plan to abandon 'reservetop' or due to
some reason that the patch is non-acceptable?

Thanks,
		-Liang Li

On Thu, Mar 25, 2010 at 08:54:05AM +0800, Liang Li wrote:
> When specify 'reservetop=0xabc000' kernel parameter, kernel will hang
> on boot due to a early_ioremap bug that relate to commit 8827247ff.
> 
> The root cause of boot failure problem is the value of 'slot_virt[i]'
> was initialized in setup_arch->early_ioremap_init. But later in
> setup_arch, the function 'parse_early_param' will modify 'FIXADDR_TOP'
> when 'reservetop=0xbadc0de' being specified.
> 
> The simplest fix might be use __fix_to_virt(idx0) to get updated value
> of 'FIXADDR_TOP' in '__early_ioremap' instead of reference old value
> from slot_virt[slot] directly.
> 
> Signed-off-by: Liang Li <liang.li@windriver.com>
> ---
>  arch/x86/mm/ioremap.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
> index 5eb1ba7..ea82ef0 100644
> --- a/arch/x86/mm/ioremap.c
> +++ b/arch/x86/mm/ioremap.c
> @@ -537,9 +537,9 @@ __early_ioremap(resource_size_t phys_addr, unsigned long size, pgprot_t prot)
>  		--nrpages;
>  	}
>  	if (early_ioremap_debug)
> -		printk(KERN_CONT "%08lx + %08lx\n", offset, slot_virt[slot]);
> +		printk(KERN_CONT "%08lx + %08lx\n", offset, __fix_to_virt(idx0));
>  
> -	prev_map[slot] = (void __iomem *)(offset + slot_virt[slot]);
> +	prev_map[slot] = (void __iomem *)(offset + __fix_to_virt(idx0));
>  	return prev_map[slot];
>  }
>  
> -- 
> 1.6.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
