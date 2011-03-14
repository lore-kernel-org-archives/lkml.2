Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757427Ab1CNW1C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 18:27:02 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:43720 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756505Ab1CNW1A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 18:27:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=NBu3ixcYDtwHG1gKWuE4Qk7H0jnb+JZOwqU5Xa7VCN0ldEtlgQ17Po3STXjmKU7kcH
         SfHPkja3GItveNR+ElQfLEstG5wx1lByKuv9MBhv3u8TaSTeIbcdQ5eNpMGiolS85Krw
         ml1dG2XzoLTWapuKQEsjYKBesIFkkxl61hHgA=
MIME-Version: 1.0
In-Reply-To: <AANLkTim8nHe1jXagKg-5g0ZLh7J61LzAi0ww__Kgaerx@mail.gmail.com>
References: <AANLkTim8nHe1jXagKg-5g0ZLh7J61LzAi0ww__Kgaerx@mail.gmail.com>
Date: Mon, 14 Mar 2011 23:26:58 +0100
Message-ID: <AANLkTi=C-LRv_aRAc9mpdMJXkyGEQLtYQ_E82hwYUjgi@mail.gmail.com>
Subject: Re: [RFC][PATCH v2 21/23] (um) __vmalloc: add gfp flags variant of
 pte and pmd allocation
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Prasad Joshi <prasadjoshi124@gmail.com>
Cc: Jeff Dike <jdike@addtoit.com>, Tejun Heo <tj@kernel.org>,
        user-mode-linux-devel@lists.sourceforge.net,
        UML Mailing List <user-mode-linux-user@lists.sourceforge.net>,
        Anand Mitra <mitra@kqinfotech.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 14, 2011 at 7:12 PM, Prasad Joshi <prasadjoshi124@gmail.com> wrote:
> diff --git a/arch/um/include/asm/pgalloc.h b/arch/um/include/asm/pgalloc.h
> index 32c8ce4..8b6257e 100644
> --- a/arch/um/include/asm/pgalloc.h
> +++ b/arch/um/include/asm/pgalloc.h
> @@ -27,6 +27,7 @@ extern pgd_t *pgd_alloc(struct mm_struct *);
>  extern void pgd_free(struct mm_struct *mm, pgd_t *pgd);
>
>  extern pte_t *pte_alloc_one_kernel(struct mm_struct *, unsigned long);
> +extern pte_t *__pte_alloc_one_kernel(struct mm_struct *, unsigned long, gfp_t);
>  extern pgtable_t pte_alloc_one(struct mm_struct *, unsigned long);
>
>  static inline void pte_free_kernel(struct mm_struct *mm, pte_t *pte)
> diff --git a/arch/um/kernel/mem.c b/arch/um/kernel/mem.c
> index 8137ccc..e4caf17 100644
> --- a/arch/um/kernel/mem.c
> +++ b/arch/um/kernel/mem.c
> @@ -284,12 +284,15 @@ void pgd_free(struct mm_struct *mm, pgd_t *pgd)
>    free_page((unsigned long) pgd);
>  }
>
> -pte_t *pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address)
> +pte_t *
> +__pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address,
> gfp_t gfp_mask)
>  {
> -   pte_t *pte;
> +   return (pte_t *)__get_free_page(gfp_mask | __GFP_ZERO);
> +}
>
> -   pte = (pte_t *)__get_free_page(GFP_KERNEL|__GFP_REPEAT|__GFP_ZERO);
> -   return pte;
> +pte_t *pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address)
> +{
> +   return __pte_alloc_one_kernel(mm, address, GFP_KERNEL | __GFP_REPEAT);
>  }
>
>  pgtable_t pte_alloc_one(struct mm_struct *mm, unsigned long address)
> @@ -303,15 +306,21 @@ pgtable_t pte_alloc_one(struct mm_struct *mm,
> unsigned long address)
>  }
>
>  #ifdef CONFIG_3_LEVEL_PGTABLES
> -pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long address)
> +pmd_t *
> +__pmd_alloc_one(struct mm_struct *mm, unsigned long address, gfp_t gfp_mask)
>  {
> -   pmd_t *pmd = (pmd_t *) __get_free_page(GFP_KERNEL);
> +   pmd_t *pmd = (pmd_t *) __get_free_page(gfp_mask);
>
>    if (pmd)
>        memset(pmd, 0, PAGE_SIZE);
>
>    return pmd;
>  }
> +
> +pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long address)
> +{
> +   return __pmd_alloc_one(mm, address, GFP_KERNEL);
> +}
>  #endif
>
>  void *uml_kmalloc(int size, int flags)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

Sorry, this patch seems damaged.

-- 
Thanks,
//richard
