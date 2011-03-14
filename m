Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757244Ab1CNUzF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 16:55:05 -0400
Received: from smtp-out.google.com ([216.239.44.51]:29968 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757133Ab1CNUy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 16:54:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=RJLsN4oFbQGcoztmue3ogFEt9MEvB3eFLIVTcSrB0dkpVc9cNfhf1Cl8/MS0KHjls9
         4wM88MeadqPsL55eV45A==
Date: Mon, 14 Mar 2011 13:54:54 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Prasad Joshi <prasadjoshi124@gmail.com>
cc: Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>, linux-alpha@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [RFC][PATCH v2 00/23] (alpha) __vmalloc: add gfp flags variant
 of pte and pmd allocation
In-Reply-To: <AANLkTik3qn-RVUTZp5+gTk+wB9SO_MsxySHEwE8Yzi-e@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1103141351210.31514@chino.kir.corp.google.com>
References: <AANLkTik3qn-RVUTZp5+gTk+wB9SO_MsxySHEwE8Yzi-e@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Mar 2011, Prasad Joshi wrote:

> __vmalloc: propagating GFP allocation flag.
> 

This isn't the correct title of the patch.  You don't need to actually 
give them titles, the subject line will be used instead.

The subject line should also indicate this as patch 01/2 and it should 
read "mm, alpha: add gfp flags variant of pte and pmd allocations".

> - adds functions to allow caller to pass the GFP flag for memory allocation
> - helps in fixing the Bug 30702 (__vmalloc(GFP_NOFS) can callback
>   file system evict_inode).
> 
> Signed-off-by: Anand Mitra <mitra@kqinfotech.com>
> Signed-off-by: Prasad Joshi <prasadjoshi124@gmail.com>

The first signed-off-by line usually indicates the author of the change in 
which case this would require the first line of the email to be

From: Anand Mitra <mitra@kqinfotech.com>

if that's the correct attribution.

> ---
> Chnagelog:
> arch/alpha/include/asm/pgalloc.h |   18 ++++++++++++++----
> 1 files changed, 14 insertions(+), 4 deletions(-)
> ---
> diff --git a/arch/alpha/include/asm/pgalloc.h b/arch/alpha/include/asm/pgalloc.h
> index bc2a0da..d05dfc2 100644
> --- a/arch/alpha/include/asm/pgalloc.h
> +++ b/arch/alpha/include/asm/pgalloc.h
> @@ -38,10 +38,15 @@ pgd_free(struct mm_struct *mm, pgd_t *pgd)
>  }
> 
>  static inline pmd_t *
> +__pmd_alloc_one(struct mm_struct *mm, unsigned long address, gfp_t gfp_mask)
> +{
> +	return (pmd_t *)__get_free_page(gfp_mask | __GFP_ZERO);
> +}
> +
> +static inline pmd_t *
>  pmd_alloc_one(struct mm_struct *mm, unsigned long address)
>  {
> -	pmd_t *ret = (pmd_t *)__get_free_page(GFP_KERNEL|__GFP_REPEAT|__GFP_ZERO);
> -	return ret;
> +	return __pmd_alloc_one(mm, address, GFP_KERNEL | __GFP_REPEAT);
>  }
> 
>  static inline void
> @@ -51,10 +56,15 @@ pmd_free(struct mm_struct *mm, pmd_t *pmd)
>  }
> 
>  static inline pte_t *
> +__pte_alloc_one_kernel(struct mm_struct *mm, unsigned long addressi,
> gfp_t gfp_mask)

This patch is corrupt probably because of your email client (and all other 
patches in this series are corrupt, as well).  Please see 
Documentation/email-clients.txt and try sending test patches to a 
colleague and git-apply them first.

BTW, s/addressi/address/ for this function definition.

> +{
> +	return (pte_t *)__get_free_page(gfp_mask | __GFP_ZERO);
> +}
> +
> +static inline pte_t *
>  pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address)
>  {
> -	pte_t *pte = (pte_t *)__get_free_page(GFP_KERNEL|__GFP_REPEAT|__GFP_ZERO);
> -	return pte;
> +	return __pte_alloc_one_kernel(mm, address, GFP_KERNEL | __GFP_REPEAT);
>  }
> 
>  static inline void
