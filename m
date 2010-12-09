Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757383Ab0LIVow (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 16:44:52 -0500
Received: from tundra.namei.org ([65.99.196.166]:34660 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754919Ab0LIVov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 16:44:51 -0500
Date: Fri, 10 Dec 2010 08:43:55 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Tavis Ormandy <taviso@cmpxchg8b.com>,
        Randy Dunlap <randy.dunlap@oracle.com>, security@kernel.org,
        kees@ubuntu.com, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, eugene@redhat.com,
        Linus Torvalds <torvalds@linux-foundation.org>, stable@kernel.org
Subject: Re: [Security] [PATCH] install_special_mapping skips security_file_mmap
 check.
In-Reply-To: <20101209122802.939938ca.akpm@linux-foundation.org>
Message-ID: <alpine.LRH.2.00.1012100843160.23392@tundra.namei.org>
References: <20101209142942.GB9267@cmpxchg8b.com> <20101209103853.89bd577b.randy.dunlap@oracle.com> <20101209191637.GD9267@cmpxchg8b.com> <20101209122802.939938ca.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Dec 2010, Andrew Morton wrote:

> This should return the security_file_mmap() errno rather than assuming
> EPERM.  Although it happens to be the case that EPERM is the only errno
> which security_file_mmap() presently returns, afacit.
> 
> Ditto insert_vm_struct(), with s/EPERM/ENOMEM/
> 
> Please review and test?

Reviewed-by: James Morris <jmorris@namei.org>


> 
> 
> --- a/mm/mmap.c~mm-install_special_mapping-skips-security_file_mmap-check-fix
> +++ a/mm/mmap.c
> @@ -2463,6 +2463,7 @@ int install_special_mapping(struct mm_st
>  			    unsigned long vm_flags, struct page **pages)
>  {
>  	struct vm_area_struct *vma;
> +	int ret;
>  
>  	vma = kmem_cache_zalloc(vm_area_cachep, GFP_KERNEL);
>  	if (unlikely(vma == NULL))
> @@ -2479,21 +2480,21 @@ int install_special_mapping(struct mm_st
>  	vma->vm_ops = &special_mapping_vmops;
>  	vma->vm_private_data = pages;
>  
> -	if (security_file_mmap(NULL, 0, 0, 0, vma->vm_start, 1)) {
> -		kmem_cache_free(vm_area_cachep, vma);
> -		return -EPERM;
> -	}
> -
> -	if (unlikely(insert_vm_struct(mm, vma))) {
> -		kmem_cache_free(vm_area_cachep, vma);
> -		return -ENOMEM;
> -	}
> +	ret = security_file_mmap(NULL, 0, 0, 0, vma->vm_start, 1);
> +	if (ret < 0)
> +		goto out;
> +
> +	ret = insert_vm_struct(mm, vma);
> +	if (ret < 0)
> +		goto out;
>  
>  	mm->total_vm += len >> PAGE_SHIFT;
>  
>  	perf_event_mmap(vma);
> -
>  	return 0;
> +out:
> +	kmem_cache_free(vm_area_cachep, vma);
> +	return ret;
>  }
>  
>  static DEFINE_MUTEX(mm_all_locks_mutex);
> _
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
James Morris
<jmorris@namei.org>
