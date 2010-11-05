Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754375Ab0KENHt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 09:07:49 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:44300 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629Ab0KENHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 09:07:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=PhJztgmS/6g5O2EPC0h1zJN1abugRFP3LFVT0RoUZ4kn1GaN8Oyq4A2/dqZ+iSWwMF
         ZqmzP4SCB6tYOGVBA/lR8IyWHsQVaQiTq3xuL4vJcgSrwSXgFQHi53YZvDPhCYjVWXoK
         /KrSMNho0EDC5BaeNXoE59w1Ij/LiUzylKjiU=
Date: Fri, 5 Nov 2010 14:07:10 +0100
From: Andreas Herrmann <herrmann.der.user@googlemail.com>
To: Jan Beulich <JBeulich@novell.com>
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
        Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86-64: more fixes and cleanup to AMD Fam10 MMCONF
 enabling
Message-ID: <20101105130710.GA32266@alberich.amd.com>
References: <4CD3F18E0200007800020B6D@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CD3F18E0200007800020B6D@vpn.id2.novell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 05, 2010 at 10:59:10AM +0000, Jan Beulich wrote:
> Unfortunately it turned out the original code had more issues: We want
> to place the region above 4G in any case (even if TOM2 isn't enabled
> or invalid), and the base mask definition was improperly typed (thus

I am just curios. Do you actually have access to a system where TOM2
isn't properly configured?


Thanks,

Andreas

> causing shifts by FAM10H_MMIO_CONF_BASE_SHIFT to produce other than
> the intended result). Fixing this in turn allowed simplifying the MMIO
> region detection code, as regions ending below TOM2 now aren't of
> interest anymore.
> 
> This will only apply cleanly on top of yesterday's patch titled
> "x86-64: fix and clean up AMD Fam10 MMCONF enabling".
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> Cc: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/include/asm/msr-index.h   |    2 +-
>  arch/x86/kernel/mmconf-fam10h_64.c |   12 ++++++------
>  2 files changed, 7 insertions(+), 7 deletions(-)
> 
> --- 2.6.37-rc1/arch/x86/include/asm/msr-index.h
> +++ 2.6.37-rc1-x86_64-mmconf-fam10h/arch/x86/include/asm/msr-index.h
> @@ -128,7 +128,7 @@
>  #define FAM10H_MMIO_CONF_ENABLE		(1<<0)
>  #define FAM10H_MMIO_CONF_BUSRANGE_MASK	0xf
>  #define FAM10H_MMIO_CONF_BUSRANGE_SHIFT 2
> -#define FAM10H_MMIO_CONF_BASE_MASK	0xfffffff
> +#define FAM10H_MMIO_CONF_BASE_MASK	0xfffffffULL
>  #define FAM10H_MMIO_CONF_BASE_SHIFT	20
>  #define MSR_FAM10H_NODE_ID		0xc001100c
>  
> --- 2.6.37-rc1-x86_64-mmconf-fam10h.orig/arch/x86/kernel/mmconf-fam10h_64.c
> +++ 2.6.37-rc1-x86_64-mmconf-fam10h/arch/x86/kernel/mmconf-fam10h_64.c
> @@ -43,7 +43,7 @@ static int __cpuinit cmp_range(const voi
>  	return start1 - start2;
>  }
>  
> -#define UNIT (1ULL << (5 + 3 + 12))
> +#define UNIT (1ULL << FAM10H_MMIO_CONF_BASE_SHIFT)
>  #define MASK (~(UNIT - 1))
>  #define SIZE (UNIT << 8)
>  /* need to avoid (0xfd<<32) and (0xfe<<32), ht used space */
> @@ -99,12 +99,12 @@ static void __cpuinit get_fam10h_pci_mmc
>  
>  	/* TOP_MEM2 is not enabled? */
>  	if (!(val & (1<<21))) {
> -		tom2 = 0;
> +		tom2 = 1ULL << 32;
>  	} else {
>  		/* TOP_MEM2 */
>  		address = MSR_K8_TOP_MEM2;
>  		rdmsrl(address, val);
> -		tom2 = val & 0xffffff800000ULL;
> +		tom2 = max(val & 0xffffff800000ULL, 1ULL << 32);
>  	}
>  
>  	if (base <= tom2)
> @@ -127,7 +127,7 @@ static void __cpuinit get_fam10h_pci_mmc
>  		reg = read_pci_config(bus, slot, 1, 0x84 + (i << 3));
>  		end = ((u64)(reg & 0xffffff00) << 8) | 0xffff; /* 39:16 on 31:8*/
>  
> -		if (!end)
> +		if (end < tom2)
>  			continue;
>  
>  		range[hi_mmio_num].start = start;
> @@ -151,13 +151,13 @@ static void __cpuinit get_fam10h_pci_mmc
>  	if ((base > tom2) && BASE_VALID(base))
>  		goto out;
>  	base = (range[hi_mmio_num - 1].end + UNIT) & MASK;
> -	if ((base > tom2) && BASE_VALID(base))
> +	if (BASE_VALID(base))
>  		goto out;
>  	/* need to find window between ranges */
>  	for (i = 1; i < hi_mmio_num; i++) {
>  		base = (range[i - 1].end + UNIT) & MASK;
>  		val = range[i].start & MASK;
> -		if (val >= base + SIZE && base > tom2 && BASE_VALID(base))
> +		if (val >= base + SIZE && BASE_VALID(base))
>  			goto out;
>  	}
>  	return;
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
