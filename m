Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501Ab0KVNLb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 08:11:31 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43027 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067Ab0KVNLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 08:11:30 -0500
Date: Mon, 22 Nov 2010 13:11:14 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 09/20] ARM: LPAE: Change setup_mm_for_reboot() to
	work with LPAE
Message-ID: <20101122131114.GE31227@n2100.arm.linux.org.uk>
References: <1289584840-18097-1-git-send-email-catalin.marinas@arm.com> <1289584840-18097-10-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289584840-18097-10-git-send-email-catalin.marinas@arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 12, 2010 at 06:00:29PM +0000, Catalin Marinas wrote:
> diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
> index 4147cc6..3784acc 100644
> --- a/arch/arm/mm/mmu.c
> +++ b/arch/arm/mm/mmu.c
> @@ -1098,13 +1098,16 @@ void setup_mm_for_reboot(char mode)
>  	if (cpu_architecture() <= CPU_ARCH_ARMv5TEJ && !cpu_is_xscale())
>  		base_pmdval |= PMD_BIT4;
>  
> -	for (i = 0; i < FIRST_USER_PGD_NR + USER_PTRS_PER_PGD; i++, pgd++) {
> +	for (i = 0; i < TASK_SIZE >> PMD_SHIFT; i++) {
>  		unsigned long pmdval = (i << PMD_SHIFT) | base_pmdval;
>  		pmd_t *pmd;
> +		unsigned long addr = i << PMD_SHIFT;
>  
> -		pmd = pmd_off(pgd, i << PMD_SHIFT);
> +		pmd = pmd_off(pgd + pgd_index(addr), addr);
>  		pmd[0] = __pmd(pmdval);
> +#ifndef CONFIG_ARM_LPAE
>  		pmd[1] = __pmd(pmdval + (1 << (PMD_SHIFT - 1)));
> +#endif
>  		flush_pmd_entry(pmd);
>  	}

The same is required for the identity mapping code.  If this uses that
code, the problem becomes localized there.
