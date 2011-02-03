Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756569Ab1BCRJ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 12:09:26 -0500
Received: from service87.mimecast.com ([94.185.240.25]:48959 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756490Ab1BCRJZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 12:09:25 -0500
Subject: Re: [PATCH v4 09/19] ARM: LPAE: Page table maintenance for the
 3-level format
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <1295891761-18366-10-git-send-email-catalin.marinas@arm.com>
References: <1295891761-18366-1-git-send-email-catalin.marinas@arm.com>
	 <1295891761-18366-10-git-send-email-catalin.marinas@arm.com>
Organization: ARM Limited
Date: Thu, 03 Feb 2011 17:09:20 +0000
Message-ID: <1296752960.28466.16.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1
X-OriginalArrivalTime: 03 Feb 2011 17:09:22.0073 (UTC) FILETIME=[19E6F090:01CBC3C5]
X-MC-Unique: 111020317092300401
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-24 at 17:55 +0000, Catalin Marinas wrote:
> --- a/arch/arm/mm/pgd.c
> +++ b/arch/arm/mm/pgd.c
> @@ -80,20 +98,36 @@ void pgd_free(struct mm_struct *mm, pgd_t *pgd_base)
>         if (!pgd_base)
>                 return;
> 
> -       pgd = pgd_base + pgd_index(0);
> -       if (pgd_none_or_clear_bad(pgd))
> -               goto no_pgd;
> +       if (!vectors_high()) {
> +               pgd = pgd_base + pgd_index(0);
> +               if (pgd_none_or_clear_bad(pgd))
> +                       goto no_pgd;
> 
> -       pmd = pmd_offset(pgd, 0);
> -       if (pmd_none_or_clear_bad(pmd))
> -               goto no_pmd;
> +               pmd = pmd_offset(pgd, 0);
> +               if (pmd_none_or_clear_bad(pmd))
> +                       goto no_pmd;
> 
> -       pte = pmd_pgtable(*pmd);
> -       pmd_clear(pmd);
> -       pte_free(mm, pte);
> +               pte = pmd_pgtable(*pmd);
> +               pmd_clear(pmd);
> +               pte_free(mm, pte);
>  no_pmd:
> -       pgd_clear(pgd);
> -       pmd_free(mm, pmd);
> +               pgd_clear(pgd);
> +               pmd_free(mm, pmd);
> +       }
>  no_pgd:

I pushed some fixups to the arm-lpae branch mentioned in the cover
letter.

The hunk above doesn't need to be applied since FIRST_USER_ADDRESS is
non-zero on ARM and free_pgtables() misses the first PMD when cleaning
up user page tables (hence leaking some memory).

-- 
Catalin


