Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838Ab2L0Sv3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 13:51:29 -0500
Received: from mail.skyhub.de ([78.46.96.112]:47948 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752738Ab2L0Sv1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 13:51:27 -0500
Date: Thu, 27 Dec 2012 19:51:26 +0100
From: Borislav Petkov <bp@alien8.de>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86, mm: add generic kernel/ident mapping helper
Message-ID: <20121227185126.GA10207@x1.alien8.de>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
	LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> commit bb3cda32f9586e13c5d3dde6c83a914bb2d7f87f
> Author: Yinghai Lu <yinghai@kernel.org>
> Date:   Mon Dec 24 18:00:21 2012 -0800
> 
>     x86, mm: add generic kernel/ident mapping helper
>     
>     It is simple version for kernel_physical_mapping_init.
>     it will work to build one page table that will be put effectiv later.
>     
>     Use mapping_info to control
>             1. alloc method
>             2. if PMD is EXEC,
>             3. if pgd is with kernel low mapping or ident mapping.
>     
>     Will use to replace some local versions in kexec, hibernation and etc.
>     
>     Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> diff --git a/arch/x86/include/asm/init.h b/arch/x86/include/asm/init.h
> index bac770b7cbc4..66a368190139 100644
> --- a/arch/x86/include/asm/init.h
> +++ b/arch/x86/include/asm/init.h
> @@ -1,5 +1,17 @@
>  #ifndef _ASM_X86_INIT_H
>  #define _ASM_X86_INIT_H
>  
> +struct mapping_info {
> +	void *(*alloc)(void *);

		alloc_page

> +	void *data;
> +	unsigned long flag;

		page_flags;

> +	bool kernel;

	kernel_space?

In general, all those members could use more meaningful names and some
commenting explaining what they are, instead of people having to deduce
what they mean from their usage in the code.

Also, struct name 'mapping_info' is too generic. Maybe
ident_mapping_info?

> +};
> +
> +int kernel_ident_mapping_init(struct mapping_info *info, pgd_t *pgd_page,
> +				unsigned long addr, unsigned long end);
> +
> +int kernel_mapping_init(pgd_t *pgd_page,
> +				unsigned long addr, unsigned long end);
>  
>  #endif /* _ASM_X86_INIT_H */
> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> index b1178eb7af22..6e1c063c49d2 100644
> --- a/arch/x86/mm/init_64.c
> +++ b/arch/x86/mm/init_64.c
> @@ -56,6 +56,99 @@
>  
>  #include "mm_internal.h"
>  
> +static void ident_pmd_init(unsigned long flag, pmd_t *pmd_page,
> +			  unsigned long addr, unsigned long end)
> +{
> +	addr &= PMD_MASK;
> +	for (; addr < end; addr += PMD_SIZE) {
> +		pmd_t *pmd = pmd_page + pmd_index(addr);
> +
> +		if (!pmd_present(*pmd))
> +			set_pmd(pmd, __pmd(addr | flag));
> +	}
> +}
> +static int ident_pud_init(struct mapping_info *info,
> +			  pud_t *pud_page,
> +			  unsigned long addr, unsigned long end)
> +{
> +	unsigned long next;
> +
> +	for (; addr < end; addr = next) {
> +		pud_t *pud = pud_page + pud_index(addr);
> +		pmd_t *pmd;
> +
> +		next = (addr & PUD_MASK) + PUD_SIZE;
> +		if (next > end)
> +			next = end;
> +
> +		if (pud_present(*pud)) {
> +			pmd = pmd_offset(pud, 0);
> +			ident_pmd_init(info->flag, pmd, addr, next);
> +			continue;
> +		}
> +		pmd = (pmd_t *)info->alloc(info->data);
> +		if (!pmd)
> +			return -ENOMEM;
> +		ident_pmd_init(info->flag, pmd, addr, next);
> +		set_pud(pud, __pud(__pa(pmd) | _KERNPG_TABLE));
> +	}
> +
> +	return 0;
> +}
> +
> +int kernel_ident_mapping_init(struct mapping_info *info,
> +		       pgd_t *pgd_page, unsigned long addr, unsigned long end)

that's some funny argument alignment.

> +{
> +	unsigned long next;
> +	int result;
> +	int off = info->kernel ? pgd_index(__PAGE_OFFSET) : 0;
> +
> +	for (; addr < end; addr = next) {
> +		pgd_t *pgd = pgd_page + pgd_index(addr) + off;
> +		pud_t *pud;
> +
> +		next = (addr & PGDIR_MASK) + PGDIR_SIZE;
> +		if (next > end)
> +			next = end;
> +
> +		if (pgd_present(*pgd)) {
> +			pud = pud_offset(pgd, 0);
> +			result = ident_pud_init(info, pud, addr, next);
> +			if (result)
> +				return result;
> +			continue;
> +		}
> +
> +		pud = (pud_t *)info->alloc(info->data);
> +		if (!pud)
> +			return -ENOMEM;
> +		result = ident_pud_init(info, pud, addr, next);
> +		if (result)
> +			return result;
> +		set_pgd(pgd, __pgd(__pa(pud) | _KERNPG_TABLE));
> +	}
> +
> +	return 0;
> +}
> +
> +static void *alloc_pgt_page(void *data)
> +{
> +	return alloc_low_page();
> +}
> +
> +int kernel_mapping_init(pgd_t *pgd_page,
> +				unsigned long addr, unsigned long end)

ditto.

> +{
> +	struct mapping_info info = {
> +		.alloc = alloc_pgt_page,
> +		.data = NULL,
> +		.flag = __PAGE_KERNEL_LARGE,
> +		.kernel = true,
> +	};
> +
> +	return kernel_ident_mapping_init(&info, pgd_page, addr, end);
> +}
> +
>  static int __init parse_direct_gbpages_off(char *arg)
>  {
>  	direct_gbpages = 0;

-- 
Regards/Gruss,
Boris.
