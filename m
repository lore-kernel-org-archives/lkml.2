Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756859Ab1KJWza (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 17:55:30 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51350 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081Ab1KJWz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 17:55:29 -0500
Date: Thu, 10 Nov 2011 22:55:17 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 13/16] ARM: LPAE: Add identity mapping support for
	the 3-level page table format
Message-ID: <20111110225517.GW12913@n2100.arm.linux.org.uk>
References: <1320682618-1182-1-git-send-email-catalin.marinas@arm.com> <1320682618-1182-14-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320682618-1182-14-git-send-email-catalin.marinas@arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 07, 2011 at 04:16:55PM +0000, Catalin Marinas wrote:
> With LPAE, the pgd is a separate page table with entries pointing to the
> pmd. The identity_mapping_add() function needs to ensure that the pgd is
> populated before populating the pmd level. The do..while blocks now loop
> over the pmd in order to have the same implementation for the two page
> table formats. The pmd_addr_end() definition has been removed and the
> generic one used instead. The pmd clean-up is done in the pgd_free()
> function.
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> ---
>  arch/arm/mm/idmap.c |   36 ++++++++++++++++++++++++++++++++++--
>  1 files changed, 34 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/mm/idmap.c b/arch/arm/mm/idmap.c
> index 2be9139..24e0655 100644
> --- a/arch/arm/mm/idmap.c
> +++ b/arch/arm/mm/idmap.c
> @@ -1,9 +1,36 @@
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +

I don't like this kind of thing in core files, it doesn't really provide
much additional inforamtion above the message given.

>  #include <linux/kernel.h>
>  
>  #include <asm/cputype.h>
>  #include <asm/pgalloc.h>
>  #include <asm/pgtable.h>
>  
> +#ifdef CONFIG_ARM_LPAE
> +static void idmap_add_pmd(pud_t *pud, unsigned long addr, unsigned long end,
> +	unsigned long prot)
> +{
> +	pmd_t *pmd;
> +	unsigned long next;
> +
> +	if (pud_none_or_clear_bad(pud) || (pud_val(*pud) & L_PGD_SWAPPER)) {
> +		pmd = pmd_alloc_one(NULL, addr);

This should be &init_mm, not NULL.

> +		if (!pmd) {
> +			pr_warning("Failed to allocate identity pmd.\n");

This message implies its from idmap - "identity pmd".

> +			return;
> +		}
> +		pud_populate(NULL, pud, pmd);

This should be &init_mm, not NULL.

> +		pmd += pmd_index(addr);
> +	} else
> +		pmd = pmd_offset(pud, addr);
> +
> +	do {
> +		next = pmd_addr_end(addr, end);
> +		*pmd = __pmd((addr & PMD_MASK) | prot);
> +		flush_pmd_entry(pmd);
> +	} while (pmd++, addr = next, addr != end);
> +}
> +#else	/* !CONFIG_ARM_LPAE */

I'm not convinced about the wiseness of this.  One of the places where
this code is called is from the reboot paths, which can happen in atomic
context.  Trying to allocate memory in such a context is going to lead
to problems, especially if support for panic'ing on OOM, and rebooting
on panic'ing are both enabled.

Therefore, I think this patch depends on the work Will has been doing to
re-structure the kexec and restart support.
