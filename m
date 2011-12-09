Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150Ab1LIVfb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 16:35:31 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:53744 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750761Ab1LIVfa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 16:35:30 -0500
Message-ID: <1323466526.27746.29.camel@joe2Laptop>
Subject: Re: [PATCH v2] mm: simplify find_vma_prev
From: Joe Perches <joe@perches.com>
To: kosaki.motohiro@gmail.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Shaohua Li <shaohua.li@intel.com>
Date: Fri, 09 Dec 2011 13:35:26 -0800
In-Reply-To: <1323465781-2976-1-git-send-email-kosaki.motohiro@gmail.com>
References: <1323465781-2976-1-git-send-email-kosaki.motohiro@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-12-09 at 16:23 -0500, kosaki.motohiro@gmail.com wrote:
> commit 297c5eee37 (mm: make the vma list be doubly linked) added
> vm_prev member into vm_area_struct. Therefore we can simplify
> find_vma_prev() by using it. Also, this change help to improve
> page fault performance because it has strong locality of reference.

trivia:

> diff --git a/mm/mmap.c b/mm/mmap.c
[]
> @@ -1603,39 +1603,21 @@ struct vm_area_struct *find_vma(struct mm_struct *mm, unsigned long addr)
>  
>  EXPORT_SYMBOL(find_vma);
>  
> -/* Same as find_vma, but also return a pointer to the previous VMA in *pprev. */
> +/*
> + * Same as find_vma, but also return a pointer to the previous VMA in *pprev.
> + * Note: pprev is set to NULL when return value is NULL.
> + */
>  struct vm_area_struct *
> -find_vma_prev(struct mm_struct *mm, unsigned long addr,
> -			struct vm_area_struct **pprev)

> +find_vma_prev(struct mm_struct *mm, unsigned long addr, struct vm_area_struct **pprev)

eh.  This declaration change seems gratuitous and it exceeds 80 columns.

> +	*pprev = NULL;
> +	vma = find_vma(mm, addr);
> +	if (vma)
> +		*pprev = vma->vm_prev;

There's no need to possibly set *pprev twice.

Maybe
{
	struct vm_area_struct *vma = find_vma(mm, addr);

	*pprev = vma ? vma->vm_prev : NULL;
or
	if (vma)
		*pprev = vma->vm_prev;
	else
		*pprev = NULL;

	return vma;
}
 
> -out:
> -	*pprev = prev;
> -	return prev ? prev->vm_next : vma;
> +	return vma;
>  }
>  
>  /*



