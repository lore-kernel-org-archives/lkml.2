Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945936Ab2KNWdt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 17:33:49 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:60090 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945915Ab2KNWds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 17:33:48 -0500
Date: Wed, 14 Nov 2012 14:33:44 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH v5 03/11] thp: copy_huge_pmd(): copy huge zero page
In-Reply-To: <1352300463-12627-4-git-send-email-kirill.shutemov@linux.intel.com>
Message-ID: <alpine.DEB.2.00.1211141433150.13515@chino.kir.corp.google.com>
References: <1352300463-12627-1-git-send-email-kirill.shutemov@linux.intel.com> <1352300463-12627-4-git-send-email-kirill.shutemov@linux.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Nov 2012, Kirill A. Shutemov wrote:

> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index ff834ea..0d903bf 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -701,6 +701,18 @@ static inline struct page *alloc_hugepage(int defrag)
>  }
>  #endif
>  
> +static void set_huge_zero_page(pgtable_t pgtable, struct mm_struct *mm,
> +		struct vm_area_struct *vma, unsigned long haddr, pmd_t *pmd)
> +{
> +	pmd_t entry;
> +	entry = pfn_pmd(huge_zero_pfn, vma->vm_page_prot);
> +	entry = pmd_wrprotect(entry);
> +	entry = pmd_mkhuge(entry);
> +	set_pmd_at(mm, haddr, pmd, entry);
> +	pgtable_trans_huge_deposit(mm, pgtable);
> +	mm->nr_ptes++;
> +}
> +
>  int do_huge_pmd_anonymous_page(struct mm_struct *mm, struct vm_area_struct *vma,
>  			       unsigned long address, pmd_t *pmd,
>  			       unsigned int flags)
> @@ -778,6 +790,11 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
>  		pte_free(dst_mm, pgtable);
>  		goto out_unlock;
>  	}
> +	if (is_huge_zero_pmd(pmd)) {
> +		set_huge_zero_page(pgtable, dst_mm, vma, addr, dst_pmd);
> +		ret = 0;
> +		goto out_unlock;
> +	}

You said in the introduction message in this series that you still allow 
splitting of the pmd, so why no check for pmd_trans_splitting() before 
this?
