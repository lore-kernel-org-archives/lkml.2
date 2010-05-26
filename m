Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757732Ab0EZU37 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 16:29:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48661 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755000Ab0EZU36 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 16:29:58 -0400
Subject: Re: [PATCH 1/5] rename anon_vma_lock to vma_lock_anon_vma
From: Larry Woodman <lwoodman@redhat.com>
To: Rik van Riel <riel@redhat.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Mel Gorman <mel@csn.ul.ie>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
In-Reply-To: <20100526153853.55b72183@annuminas.surriel.com>
References: <20100526153819.6e5cec0d@annuminas.surriel.com>
	 <20100526153853.55b72183@annuminas.surriel.com>
Content-Type: text/plain
Date: Wed, 26 May 2010 16:33:12 -0400
Message-Id: <1274905992.20515.106.camel@dhcp-100-19-198.bos.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-26 at 15:38 -0400, Rik van Riel wrote:
> Subject: rename anon_vma_lock to vma_lock_anon_vma
> 
> Rename anon_vma_lock to vma_lock_anon_vma.  This matches the
> naming style used in page_lock_anon_vma and will come in really
> handy further down in this patch series.
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>
> Acked-by: Mel Gorman <mel@csn.ul.ie>
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Tested and Acked-by: Larry Woodman <lwoodman@redhat.com>

> ---
>  include/linux/rmap.h |    4 ++--
>  mm/mmap.c            |   14 +++++++-------
>  2 files changed, 9 insertions(+), 9 deletions(-)
> 
> Index: linux-2.6.34/include/linux/rmap.h
> ===================================================================
> --- linux-2.6.34.orig/include/linux/rmap.h
> +++ linux-2.6.34/include/linux/rmap.h
> @@ -99,14 +99,14 @@ static inline struct anon_vma *page_anon
>  	return page_rmapping(page);
>  }
>  
> -static inline void anon_vma_lock(struct vm_area_struct *vma)
> +static inline void vma_lock_anon_vma(struct vm_area_struct *vma)
>  {
>  	struct anon_vma *anon_vma = vma->anon_vma;
>  	if (anon_vma)
>  		spin_lock(&anon_vma->lock);
>  }
>  
> -static inline void anon_vma_unlock(struct vm_area_struct *vma)
> +static inline void vma_unlock_anon_vma(struct vm_area_struct *vma)
>  {
>  	struct anon_vma *anon_vma = vma->anon_vma;
>  	if (anon_vma)
> Index: linux-2.6.34/mm/mmap.c
> ===================================================================
> --- linux-2.6.34.orig/mm/mmap.c
> +++ linux-2.6.34/mm/mmap.c
> @@ -452,12 +452,12 @@ static void vma_link(struct mm_struct *m
>  		spin_lock(&mapping->i_mmap_lock);
>  		vma->vm_truncate_count = mapping->truncate_count;
>  	}
> -	anon_vma_lock(vma);
> +	vma_lock_anon_vma(vma);
>  
>  	__vma_link(mm, vma, prev, rb_link, rb_parent);
>  	__vma_link_file(vma);
>  
> -	anon_vma_unlock(vma);
> +	vma_unlock_anon_vma(vma);
>  	if (mapping)
>  		spin_unlock(&mapping->i_mmap_lock);
>  
> @@ -1710,7 +1710,7 @@ int expand_upwards(struct vm_area_struct
>  	 */
>  	if (unlikely(anon_vma_prepare(vma)))
>  		return -ENOMEM;
> -	anon_vma_lock(vma);
> +	vma_lock_anon_vma(vma);
>  
>  	/*
>  	 * vma->vm_start/vm_end cannot change under us because the caller
> @@ -1721,7 +1721,7 @@ int expand_upwards(struct vm_area_struct
>  	if (address < PAGE_ALIGN(address+4))
>  		address = PAGE_ALIGN(address+4);
>  	else {
> -		anon_vma_unlock(vma);
> +		vma_unlock_anon_vma(vma);
>  		return -ENOMEM;
>  	}
>  	error = 0;
> @@ -1737,7 +1737,7 @@ int expand_upwards(struct vm_area_struct
>  		if (!error)
>  			vma->vm_end = address;
>  	}
> -	anon_vma_unlock(vma);
> +	vma_unlock_anon_vma(vma);
>  	return error;
>  }
>  #endif /* CONFIG_STACK_GROWSUP || CONFIG_IA64 */
> @@ -1762,7 +1762,7 @@ static int expand_downwards(struct vm_ar
>  	if (error)
>  		return error;
>  
> -	anon_vma_lock(vma);
> +	vma_lock_anon_vma(vma);
>  
>  	/*
>  	 * vma->vm_start/vm_end cannot change under us because the caller
> @@ -1783,7 +1783,7 @@ static int expand_downwards(struct vm_ar
>  			vma->vm_pgoff -= grow;
>  		}
>  	}
> -	anon_vma_unlock(vma);
> +	vma_unlock_anon_vma(vma);
>  	return error;
>  }
>  
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

