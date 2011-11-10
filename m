Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932386Ab1KJVxz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 16:53:55 -0500
Received: from relais.videotron.ca ([24.201.245.36]:50410 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754040Ab1KJVxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 16:53:54 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Thu, 10 Nov 2011 16:53:53 -0500 (EST)
From: Nicolas Pitre <nico@fluxnic.net>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 07/16] ARM: LPAE: Introduce the 3-level page table
 format definitions
In-reply-to: <1320682618-1182-8-git-send-email-catalin.marinas@arm.com>
Message-id: <alpine.LFD.2.02.1111101638550.3307@xanadu.home>
References: <1320682618-1182-1-git-send-email-catalin.marinas@arm.com>
 <1320682618-1182-8-git-send-email-catalin.marinas@arm.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Nov 2011, Catalin Marinas wrote:

> This patch introduces the pgtable-3level*.h files with definitions
> specific to the LPAE page table format (3 levels of page tables).
[...]
> diff --git a/arch/arm/include/asm/pgtable-3level-hwdef.h b/arch/arm/include/asm/pgtable-3level-hwdef.h
> new file mode 100644
> index 0000000..7c238a3
> --- /dev/null
> +++ b/arch/arm/include/asm/pgtable-3level-hwdef.h
[...]
> +#ifdef __ASSEMBLY__
> +/* avoid 'shift count out of range' warning */
> +#define PMD_SECT_XN		(0)
> +#else
> +#define PMD_SECT_XN		((pmdval_t)1 << 54)
> +#endif

Please don't do that.  Having a symbol that changes value depending on 
the type of code is evil.  If PMD_SECT_XN is actually used in assembly 
code then you have to deal with it, not blindly redefine it as zero.
In my compilation test I didn't see any such warning anyway.

> diff --git a/arch/arm/include/asm/pgtable-3level-types.h b/arch/arm/include/asm/pgtable-3level-types.h
> new file mode 100644
> index 0000000..921aa30
> --- /dev/null
> +++ b/arch/arm/include/asm/pgtable-3level-types.h
> @@ -0,0 +1,70 @@
[...]
> +typedef u64 pteval_t;
> +typedef u64 pmdval_t;
> +typedef u64 pgdval_t;
> +
> +#undef STRICT_MM_TYPECHECKS
> +
> +#ifdef STRICT_MM_TYPECHECKS
> +
> +/*
> + * These are used to make use of C type-checking..
> + */
> +typedef struct { pteval_t pte; } pte_t;
> +typedef struct { pmdval_t pmd; } pmd_t;
> +typedef struct { pgdval_t pgd; } pgd_t;
> +typedef struct { pteval_t pgprot; } pgprot_t;
> +
> +#define pte_val(x)      ((x).pte)
> +#define pmd_val(x)      ((x).pmd)
> +#define pgd_val(x)	((x).pgd)
> +#define pgprot_val(x)   ((x).pgprot)
> +
> +#define __pte(x)        ((pte_t) { (x) } )
> +#define __pmd(x)        ((pmd_t) { (x) } )
> +#define __pgd(x)	((pgd_t) { (x) } )
> +#define __pgprot(x)     ((pgprot_t) { (x) } )
> +
> +#else	/* !STRICT_MM_TYPECHECKS */
> +
> +typedef pteval_t pte_t;
> +typedef pmdval_t pmd_t;
> +typedef pgdval_t pgd_t;
> +typedef pteval_t pgprot_t;
> +
> +#define pte_val(x)	(x)
> +#define pmd_val(x)	(x)
> +#define pgd_val(x)	(x)
> +#define pgprot_val(x)	(x)
> +
> +#define __pte(x)	(x)
> +#define __pmd(x)	(x)
> +#define __pgd(x)	(x)
> +#define __pgprot(x)	(x)
> +
> +#endif	/* STRICT_MM_TYPECHECKS */

Isn't the vast majority of this file actually common with the content of 
pgtable-2level-types.h?  Except for the basic types and pgd handling, 
this looks pretty similar.


Nicolas
