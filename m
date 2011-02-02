Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581Ab1BBUP0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 15:15:26 -0500
Received: from claw.goop.org ([74.207.240.146]:49444 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751587Ab1BBUPZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 15:15:25 -0500
Message-ID: <4D49BB59.8000303@goop.org>
Date: Wed, 02 Feb 2011 12:15:21 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jan Beulich <JBeulich@novell.com>
Subject: Re: [PATCH] x86/mm/init: respect memblock reserved regions when destroying
 mappings
References: <alpine.DEB.2.00.1101311514580.7277@kaball-desktop>
In-Reply-To: <alpine.DEB.2.00.1101311514580.7277@kaball-desktop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2011 07:18 AM, Stefano Stabellini wrote:
> x86/mm/init: respect memblock reserved regions when destroying mappings
>
> In init_memory_mapping we are destroying all the mappings between
> _brk_end and _end, no matter if some memory areas in that range have
> been reserved using memblock_x86_reserve_range.

What's reserving things in that range?  How do they get addresses
there?  I would have thought they should all be brk-allocated?

> Besides if _end is not pmd aligned we might destroy the
> mappings for valid memory between _end and the following pmd.

Yes, that could be messy.

    J

> In order to avoid this problem, before clearing any pmds we check if the
> corresponding memory area has been reserved and we only destroy the
> mapping if it hasn't.
>
> We found this problem because under Xen we have a valid mapping at _end,
> and if _end is not pmd aligned the current code destroys the initial
> part of it.
>
> In practice this fix does not have any impact on native.
>
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
>
> diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
> index 947f42a..66637bd 100644
> --- a/arch/x86/mm/init.c
> +++ b/arch/x86/mm/init.c
> @@ -283,6 +283,8 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
>  	if (!after_bootmem && !start) {
>  		pud_t *pud;
>  		pmd_t *pmd;
> +		unsigned long addr;
> +		u64 size, memblock_addr;
>  
>  		mmu_cr4_features = read_cr4();
>  
> @@ -291,11 +293,18 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
>  		 * located on different 2M pages. cleanup_highmap(), however,
>  		 * can only consider _end when it runs, so destroy any
>  		 * mappings beyond _brk_end here.
> +		 * Respect memblock reserved regions.
>  		 */
>  		pud = pud_offset(pgd_offset_k(_brk_end), _brk_end);
>  		pmd = pmd_offset(pud, _brk_end - 1);
> -		while (++pmd <= pmd_offset(pud, (unsigned long)_end - 1))
> -			pmd_clear(pmd);
> +		addr = (_brk_end + PMD_SIZE - 1) & PMD_MASK;
> +		while (++pmd <= pmd_offset(pud, (unsigned long)_end - 1)) {
> +			memblock_addr = memblock_x86_find_in_range_size(__pa(addr),
> +					&size, PMD_SIZE);
> +			if (memblock_addr == (u64) __pa(addr) && size >= PMD_SIZE)
> +				pmd_clear(pmd);
> +			addr += PMD_SIZE;
> +		}
>  	}
>  #endif
>  	__flush_tlb_all();

