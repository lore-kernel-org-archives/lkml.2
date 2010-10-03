Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398Ab0JCSJF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 14:09:05 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:52286 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754322Ab0JCSJB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 14:09:01 -0400
Date: Sun, 3 Oct 2010 23:38:56 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: "Steven J. Magnani" <steve@digidescorp.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, dhowells@redhat.com,
        kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH][RESEND] nommu: add anonymous page memcg accounting
Message-ID: <20101003180856.GF7896@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <1285929315-2856-1-git-send-email-steve@digidescorp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1285929315-2856-1-git-send-email-steve@digidescorp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven J. Magnani <steve@digidescorp.com> [2010-10-01 05:35:15]:

> Add the necessary calls to track VM anonymous page usage.
>

Is there a motivation to have these changes for nommu as well? 
 
> Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
> ---
> diff -uprN a/mm/nommu.c b/mm/nommu.c
> --- a/mm/nommu.c	2010-09-02 19:47:43.000000000 -0500
> +++ b/mm/nommu.c	2010-09-02 20:07:02.000000000 -0500
> @@ -524,8 +524,10 @@ static void delete_nommu_region(struct v
>  /*
>   * free a contiguous series of pages
>   */
> -static void free_page_series(unsigned long from, unsigned long to)
> +static void free_page_series(unsigned long from, unsigned long to,
> +			     const struct file *file)
>  {
> +	mem_cgroup_uncharge_start();
>  	for (; from < to; from += PAGE_SIZE) {
>  		struct page *page = virt_to_page(from);
> 
> @@ -534,8 +536,12 @@ static void free_page_series(unsigned lo
>  		if (page_count(page) != 1)
>  			kdebug("free page %p: refcount not one: %d",
>  			       page, page_count(page));
> +		if (!file)
> +			mem_cgroup_uncharge_page(page);
> +

I don't understand the if !file bits, do you want to selectively
enable memcg for !file for nommu?

>  		put_page(page);
>  	}
> +	mem_cgroup_uncharge_end();
>  }
> 
>  /*
> @@ -563,7 +569,8 @@ static void __put_nommu_region(struct vm
>  		 * from ramfs/tmpfs mustn't be released here */
>  		if (region->vm_flags & VM_MAPPED_COPY) {
>  			kdebug("free series");
> -			free_page_series(region->vm_start, region->vm_top);
> +			free_page_series(region->vm_start, region->vm_top,
> +					 region->vm_file);
>  		}
>  		kmem_cache_free(vm_region_jar, region);
>  	} else {
> @@ -1117,9 +1124,26 @@ static int do_mmap_private(struct vm_are
>  		set_page_refcounted(&pages[point]);
> 
>  	base = page_address(pages);
> -	region->vm_flags = vma->vm_flags |= VM_MAPPED_COPY;
> +
>  	region->vm_start = (unsigned long) base;
>  	region->vm_end   = region->vm_start + rlen;
> +
> +	if (!vma->vm_file) {
> +		for (point = 0; point < total; point++) {
> +			int charge_failed =
> +				mem_cgroup_newpage_charge(&pages[point],
> +							  current->mm,
> +							  GFP_KERNEL);
> +			if (charge_failed) {
> +				free_page_series(region->vm_start,
> +						 region->vm_end, NULL);
> +				region->vm_start = region->vm_end = 0;
> +				goto enomem;
> +			}
> +		}
> +	}
> +
> +	region->vm_flags = vma->vm_flags |= VM_MAPPED_COPY;
>  	region->vm_top   = region->vm_start + (total << PAGE_SHIFT);
> 
>  	vma->vm_start = region->vm_start;
> @@ -1150,7 +1174,7 @@ static int do_mmap_private(struct vm_are
>  	return 0;
> 
>  error_free:
> -	free_page_series(region->vm_start, region->vm_end);
> +	free_page_series(region->vm_start, region->vm_end, vma->vm_file);
>  	region->vm_start = vma->vm_start = 0;
>  	region->vm_end   = vma->vm_end = 0;
>  	region->vm_top   = 0;
> @@ -1555,7 +1579,7 @@ static int shrink_vma(struct mm_struct *
>  	add_nommu_region(region);
>  	up_write(&nommu_region_sem);
> 
> -	free_page_series(from, to);
> +	free_page_series(from, to, vma->vm_file);
>  	return 0;
>  }
> 
>

Could you please add more details on your use and update the
Documentation/cgroups/memory.txt file as well. 

-- 
	Three Cheers,
	Balbir
