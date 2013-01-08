Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810Ab3AHLqh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 06:46:37 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:59458 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755370Ab3AHLqf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 06:46:35 -0500
Date: Tue, 8 Jan 2013 17:16:07 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, Frank Eigler <fche@redhat.com>,
        Josh Stone <jistone@redhat.com>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] uprobes: Move alloc_page() from xol_add_vma() to
 xol_alloc_area()
Message-ID: <20130108114607.GD1325@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20121231175150.GA32066@redhat.com>
 <20121231175212.GA32088@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20121231175212.GA32088@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13010811-7182-0000-0000-000004415C10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2012-12-31 18:52:12]:

> Move alloc_page() from xol_add_vma() to xol_alloc_area() to cleanup
> the code. This separates the memory allocations and consolidates the
> -EALREADY cleanups and the error handling.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

(One simple check below)

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>


> ---
>  kernel/events/uprobes.c |   32 +++++++++++++-------------------
>  1 files changed, 13 insertions(+), 19 deletions(-)
> 
> diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> index f883813..1456f7d 100644
> --- a/kernel/events/uprobes.c
> +++ b/kernel/events/uprobes.c
> @@ -1041,22 +1041,14 @@ void uprobe_munmap(struct vm_area_struct *vma, unsigned long start, unsigned lon
>  /* Slot allocation for XOL */
>  static int xol_add_vma(struct xol_area *area)
>  {
> -	struct mm_struct *mm;
> -	int ret;
> -
> -	area->page = alloc_page(GFP_HIGHUSER);
> -	if (!area->page)
> -		return -ENOMEM;
> -
> -	ret = -EALREADY;
> -	mm = current->mm;
> +	struct mm_struct *mm = current->mm;
> +	int ret = -EALREADY;
> 
>  	down_write(&mm->mmap_sem);
>  	if (mm->uprobes_state.xol_area)
>  		goto fail;
> 
>  	ret = -ENOMEM;
> -
>  	/* Try to map as high as possible, this is only a hint. */
>  	area->vaddr = get_unmapped_area(NULL, TASK_SIZE - PAGE_SIZE, PAGE_SIZE, 0, 0);
>  	if (area->vaddr & ~PAGE_MASK) {
> @@ -1072,11 +1064,8 @@ static int xol_add_vma(struct xol_area *area)
>  	smp_wmb();	/* pairs with get_xol_area() */
>  	mm->uprobes_state.xol_area = area;
>  	ret = 0;
> -
> -fail:
> + fail:

Not sure if the space before label is intentional?
Its true of other labels below also.

>  	up_write(&mm->mmap_sem);
> -	if (ret)
> -		__free_page(area->page);
> 
>  	return ret;
>  }
> @@ -1104,21 +1093,26 @@ static struct xol_area *xol_alloc_area(void)
> 
>  	area = kzalloc(sizeof(*area), GFP_KERNEL);
>  	if (unlikely(!area))
> -		return NULL;
> +		goto out;
> 
>  	area->bitmap = kzalloc(BITS_TO_LONGS(UINSNS_PER_PAGE) * sizeof(long), GFP_KERNEL);
> -
>  	if (!area->bitmap)
> -		goto fail;
> +		goto free_area;
> +
> +	area->page = area->page = alloc_page(GFP_HIGHUSER);
> +	if (!area->page)
> +		goto free_bitmap;
> 
>  	init_waitqueue_head(&area->wq);
>  	if (!xol_add_vma(area))
>  		return area;
> 
> -fail:
> +	__free_page(area->page);
> + free_bitmap:
>  	kfree(area->bitmap);
> + free_area:
>  	kfree(area);
> -
> + out:
>  	return get_xol_area(current->mm);
>  }
> 
> -- 
> 1.5.5.1
> 

