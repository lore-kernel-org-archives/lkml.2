Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751539Ab0DHEeH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 00:34:07 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:53755 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784Ab0DHEeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 00:34:04 -0400
Message-ID: <4BBD5BEF.3000406@oracle.com>
Date: Wed, 07 Apr 2010 21:30:39 -0700
From: Yinghai <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Liang Li <liang.li@windriver.com>
CC: Yinghai <yinghai.lu@oracle.com>, akpm@linux-foundation.org, hpa@zytor.com,
       mingo@elte.hu, tglx@linutronix.de, wangchen@cn.fujitsu.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: + x86-fix-handling-of-the-reservetop-boot-option.patch added
 to -mm tree
References: <201004072200.o37M0d19009878@imap1.linux-foundation.org> <4BBD1AA3.4000204@oracle.com> <20100408010558.GA4053@localhost> <4BBD2DD4.1060101@oracle.com> <20100408015353.GB4053@localhost>
In-Reply-To: <20100408015353.GB4053@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4BBD5C9E.00EB:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/2010 06:53 PM, Liang Li wrote:
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
<
> +		WARN_ON(1);
BUG_ON()
> +
> +	for (i = 0; i < FIX_BTMAPS_SLOTS; i++)
> +		slot_virt[i] = __fix_to_virt(FIX_BTMAP_BEGIN - NR_FIX_BTMAPS * i);
> +
need to clear the old PMD, and set new PMD.

so you can clear old PMD and call early_ioremap_init() in fixup_early_ioremap()


Thanks

Yinghai
