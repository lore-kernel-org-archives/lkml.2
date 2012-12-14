Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939Ab2LNDHZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 22:07:25 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:48346 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754383Ab2LNDHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 22:07:23 -0500
Message-ID: <50CA97D0.4020401@huawei.com>
Date: Fri, 14 Dec 2012 11:06:56 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Tony Luck <tony.luck@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Jiang Liu <jiang.liu@huawei.com>, Borislav Petkov <bp@alien8.de>,
        Simon Jeons <simon.jeons@gmail.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: clean up soft_offline_page()
References: <1355439706-23726-1-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1355439706-23726-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.196]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012/12/14 7:01, Naoya Horiguchi wrote:

> Hi,
> 
> I wrote this patch inspired by the discussion about fixing mce_bad_pages bug.
> https://lkml.org/lkml/2012/12/7/66
> As mentioned by Andrew, this bug seemed to be undetected because of the
> messiness of soft_offline_page(), so with this patch we can deal with the problem.
> 
> Thanks,
> Naoya
> ---
> From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Date: Thu, 13 Dec 2012 16:08:54 -0500
> Subject: [PATCH] mm: clean up soft_offline_page()
> 
> Currently soft_offline_page() is hard to maintain because it has many
> return points and goto statements. All of this mess come from get_any_page().
> This function should only get page refcount as the name implies, but it does
> some page isolating actions like SetPageHWPoison() and dequeuing hugepage.
> This patch corrects it and introduces some internal subroutines to make
> soft offlining code more readable and maintainable.
> 
> Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> ---
>  mm/memory-failure.c | 189 ++++++++++++++++++++++++++++------------------------
>  1 file changed, 101 insertions(+), 88 deletions(-)
> 
> diff --git v3.7.orig/mm/memory-failure.c v3.7/mm/memory-failure.c
> index 8b20278..8cef032 100644
> --- v3.7.orig/mm/memory-failure.c
> +++ v3.7/mm/memory-failure.c
> @@ -1368,7 +1368,7 @@ static struct page *new_page(struct page *p, unsigned long private, int **x)
>   * that is not free, and 1 for any other page type.
>   * For 1 the page is returned with increased page count, otherwise not.
>   */
> -static int get_any_page(struct page *p, unsigned long pfn, int flags)
> +static int __get_any_page(struct page *p, unsigned long pfn, int flags)
>  {
>  	int ret;
>  
> @@ -1393,11 +1393,9 @@ static int get_any_page(struct page *p, unsigned long pfn, int flags)
>  	if (!get_page_unless_zero(compound_head(p))) {
>  		if (PageHuge(p)) {
>  			pr_info("%s: %#lx free huge page\n", __func__, pfn);
> -			ret = dequeue_hwpoisoned_huge_page(compound_head(p));
> +			ret = 0;
>  		} else if (is_free_buddy_page(p)) {
>  			pr_info("%s: %#lx free buddy page\n", __func__, pfn);
> -			/* Set hwpoison bit while page is still isolated */
> -			SetPageHWPoison(p);
>  			ret = 0;
>  		} else {
>  			pr_info("%s: %#lx: unknown zero refcount page type %lx\n",
> @@ -1413,23 +1411,45 @@ static int get_any_page(struct page *p, unsigned long pfn, int flags)
>  	return ret;
>  }
>  
> +static int get_any_page(struct page *page, unsigned long pfn, int flags)
> +{
> +	int ret = __get_any_page(page, pfn, flags);
> +
> +	if (ret == 1 && !PageHuge(page) && !PageLRU(page)) {
> +		/*
> +		 * Try to free it.
> +		 */
> +		put_page(page);
> +		shake_page(page, 1);
> +
> +		/*
> +		 * Did it turn free?
> +		 */
> +		ret = __get_any_page(page, pfn, 0);
> +		if (!PageLRU(page)) {
> +			pr_info("soft_offline: %#lx: unknown non LRU page type %lx\n",
> +				pfn, page->flags);
> +			return -EIO;
> +		}
> +	}
> +	return ret;
> +}
> +
>  static int soft_offline_huge_page(struct page *page, int flags)
>  {
>  	int ret;
>  	unsigned long pfn = page_to_pfn(page);
>  	struct page *hpage = compound_head(page);
>  
> -	ret = get_any_page(page, pfn, flags);
> -	if (ret < 0)
> -		return ret;
> -	if (ret == 0)
> -		goto done;
> -
> +	/* Synchronized using the page lock with memory_failure() */
> +	lock_page(hpage);
>  	if (PageHWPoison(hpage)) {
> +		unlock_page(hpage);
>  		put_page(hpage);
>  		pr_info("soft offline: %#lx hugepage already poisoned\n", pfn);
>  		return -EBUSY;
>  	}
> +	unlock_page(hpage);
>  
>  	/* Keep page count to indicate a given hugepage is isolated. */
>  	ret = migrate_huge_page(hpage, new_page, MPOL_MF_MOVE_ALL, false,
> @@ -1439,85 +1459,19 @@ static int soft_offline_huge_page(struct page *page, int flags)
>  		pr_info("soft offline: %#lx: migration failed %d, type %lx\n",
>  			pfn, ret, page->flags);
>  		return ret;
> +	} else {
> +		set_page_hwpoison_huge_page(hpage);
> +		dequeue_hwpoisoned_huge_page(hpage);
> +		atomic_long_add(1<<compound_trans_order(hpage), &mce_bad_pages);
>  	}
> -done:
> -	if (!PageHWPoison(hpage))
> -		atomic_long_add(1 << compound_trans_order(hpage),
> -				&mce_bad_pages);
> -	set_page_hwpoison_huge_page(hpage);
> -	dequeue_hwpoisoned_huge_page(hpage);
>  	/* keep elevated page count for bad page */
>  	return ret;
>  }
>  
> -/**
> - * soft_offline_page - Soft offline a page.
> - * @page: page to offline
> - * @flags: flags. Same as memory_failure().
> - *
> - * Returns 0 on success, otherwise negated errno.
> - *
> - * Soft offline a page, by migration or invalidation,
> - * without killing anything. This is for the case when
> - * a page is not corrupted yet (so it's still valid to access),
> - * but has had a number of corrected errors and is better taken
> - * out.
> - *
> - * The actual policy on when to do that is maintained by
> - * user space.
> - *
> - * This should never impact any application or cause data loss,
> - * however it might take some time.
> - *
> - * This is not a 100% solution for all memory, but tries to be
> - * ``good enough'' for the majority of memory.
> - */
> -int soft_offline_page(struct page *page, int flags)
> +int __soft_offline_page(struct page *page, int flags)
>  {
>  	int ret;
>  	unsigned long pfn = page_to_pfn(page);
> -	struct page *hpage = compound_trans_head(page);
> -
> -	if (PageHuge(page))
> -		return soft_offline_huge_page(page, flags);
> -	if (PageTransHuge(hpage)) {
> -		if (PageAnon(hpage) && unlikely(split_huge_page(hpage))) {
> -			pr_info("soft offline: %#lx: failed to split THP\n",
> -				pfn);
> -			return -EBUSY;
> -		}
> -	}
> -
> -	ret = get_any_page(page, pfn, flags);
> -	if (ret < 0)
> -		return ret;
> -	if (ret == 0)
> -		goto done;
> -
> -	/*
> -	 * Page cache page we can handle?
> -	 */
> -	if (!PageLRU(page)) {
> -		/*
> -		 * Try to free it.
> -		 */
> -		put_page(page);
> -		shake_page(page, 1);
> -
> -		/*
> -		 * Did it turn free?
> -		 */
> -		ret = get_any_page(page, pfn, 0);
> -		if (ret < 0)
> -			return ret;
> -		if (ret == 0)
> -			goto done;
> -	}
> -	if (!PageLRU(page)) {
> -		pr_info("soft_offline: %#lx: unknown non LRU page type %lx\n",
> -			pfn, page->flags);
> -		return -EIO;
> -	}
>  
>  	lock_page(page);
>  	wait_on_page_writeback(page);
> @@ -1544,9 +1498,10 @@ int soft_offline_page(struct page *page, int flags)
>  	 */
>  	if (ret == 1) {
>  		put_page(page);
> -		ret = 0;
>  		pr_info("soft_offline: %#lx: invalidated\n", pfn);
> -		goto done;
> +		SetPageHWPoison(page);
> +		atomic_long_inc(&mce_bad_pages);
> +		return 0;
>  	}
>  
>  	/*
> @@ -1573,17 +1528,75 @@ int soft_offline_page(struct page *page, int flags)
>  				pfn, ret, page->flags);
>  			if (ret > 0)
>  				ret = -EIO;
> +		} else {
> +			SetPageHWPoison(page);
> +			atomic_long_inc(&mce_bad_pages);
>  		}
>  	} else {
>  		pr_info("soft offline: %#lx: isolation failed: %d, page count %d, type %lx\n",
>  			pfn, ret, page_count(page), page->flags);
>  	}
> -	if (ret)
> -		return ret;
> +	return ret;
> +}
> +
> +/**
> + * soft_offline_page - Soft offline a page.
> + * @page: page to offline
> + * @flags: flags. Same as memory_failure().
> + *
> + * Returns 0 on success, otherwise negated errno.
> + *
> + * Soft offline a page, by migration or invalidation,
> + * without killing anything. This is for the case when
> + * a page is not corrupted yet (so it's still valid to access),
> + * but has had a number of corrected errors and is better taken
> + * out.
> + *
> + * The actual policy on when to do that is maintained by
> + * user space.
> + *
> + * This should never impact any application or cause data loss,
> + * however it might take some time.
> + *
> + * This is not a 100% solution for all memory, but tries to be
> + * ``good enough'' for the majority of memory.
> + */
> +int soft_offline_page(struct page *page, int flags)
> +{
> +	int ret;
> +	unsigned long pfn = page_to_pfn(page);
> +	struct page *hpage = compound_trans_head(page);
>  
> -done:
> -	atomic_long_add(1, &mce_bad_pages);
> -	SetPageHWPoison(page);
> +	if (PageHWPoison(page)) {
> +		pr_info("soft offline: %#lx page already poisoned\n", pfn);
> +		return -EBUSY;
> +	}
> +	if (!PageHuge(page) && PageTransHuge(hpage)) {
> +		if (PageAnon(hpage) && unlikely(split_huge_page(hpage))) {
> +			pr_info("soft offline: %#lx: failed to split THP\n",
> +				pfn);
> +			return -EBUSY;
> +		}
> +	}
> +	ret = get_any_page(page, pfn, flags);
> +	if (ret < 0)
> +		return ret;
> +	if (ret) { /* for in-use pages */
> +		if (PageHuge(page))
> +			soft_offline_huge_page(page, flags);

ret = soft_offline_huge_page(page, flags);

> +		else
> +			__soft_offline_page(page, flags);

ret = __soft_offline_page(page, flags); right?

Thanks
Xishi Qiu

> +	} else { /* for free pages */
> +		if (PageHuge(page)) {
> +			set_page_hwpoison_huge_page(hpage);
> +			dequeue_hwpoisoned_huge_page(hpage);
> +			atomic_long_add(1 << compound_trans_order(hpage),
> +					&mce_bad_pages);
> +		} else {
> +			SetPageHWPoison(page);
> +			atomic_long_inc(&mce_bad_pages);
> +		}
> +	}
>  	/* keep elevated page count for bad page */
>  	return ret;
>  }



