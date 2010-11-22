Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807Ab0KVMoi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 07:44:38 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41531 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755510Ab0KVMoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 07:44:37 -0500
Date: Mon, 22 Nov 2010 12:43:53 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 01/20] ARM: LPAE: Use PMD_(SHIFT|SIZE|MASK) instead
	of PGDIR_*
Message-ID: <20101122124353.GB31227@n2100.arm.linux.org.uk>
References: <1289584840-18097-1-git-send-email-catalin.marinas@arm.com> <1289584840-18097-2-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289584840-18097-2-git-send-email-catalin.marinas@arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 12, 2010 at 06:00:21PM +0000, Catalin Marinas wrote:
> diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
> index 8c19595..40b386c 100644
> --- a/arch/arm/kernel/smp.c
> +++ b/arch/arm/kernel/smp.c
> @@ -78,7 +78,7 @@ static inline void identity_mapping_add(pgd_t *pgd, unsigned long start,
>  	if (cpu_architecture() <= CPU_ARCH_ARMv5TEJ && !cpu_is_xscale())
>  		prot |= PMD_BIT4;
>  
> -	for (addr = start & PGDIR_MASK; addr < end;) {
> +	for (addr = start & PMD_MASK; addr < end;) {
>  		pmd = pmd_offset(pgd + pgd_index(addr), addr);
>  		pmd[0] = __pmd(addr | prot);
>  		addr += SECTION_SIZE;
> @@ -95,7 +95,7 @@ static inline void identity_mapping_del(pgd_t *pgd, unsigned long start,
>  	unsigned long addr;
>  	pmd_t *pmd;
>  
> -	for (addr = start & PGDIR_MASK; addr < end; addr += PGDIR_SIZE) {
> +	for (addr = start & PMD_MASK; addr < end; addr += PMD_SIZE) {
>  		pmd = pmd_offset(pgd + pgd_index(addr), addr);
>  		pmd[0] = __pmd(0);
>  		pmd[1] = __pmd(0);
...
> @@ -1068,12 +1068,12 @@ void setup_mm_for_reboot(char mode)
>  		base_pmdval |= PMD_BIT4;
>  
>  	for (i = 0; i < FIRST_USER_PGD_NR + USER_PTRS_PER_PGD; i++, pgd++) {
> -		unsigned long pmdval = (i << PGDIR_SHIFT) | base_pmdval;
> +		unsigned long pmdval = (i << PMD_SHIFT) | base_pmdval;
>  		pmd_t *pmd;
>  
> -		pmd = pmd_off(pgd, i << PGDIR_SHIFT);
> +		pmd = pmd_off(pgd, i << PMD_SHIFT);
>  		pmd[0] = __pmd(pmdval);
> -		pmd[1] = __pmd(pmdval + (1 << (PGDIR_SHIFT - 1)));
> +		pmd[1] = __pmd(pmdval + (1 << (PMD_SHIFT - 1)));
>  		flush_pmd_entry(pmd);
>  	}
>  

This lot really does need unifying - and in any case this last addition
should be using 'SECTION SIZE' not something related to PMD shifts.

Strangely, it's something I've done over the weekend...
