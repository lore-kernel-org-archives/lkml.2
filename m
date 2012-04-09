Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751645Ab2DIFtW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 01:49:22 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47516 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112Ab2DIFtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 01:49:19 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4F8277ED.8040904@jp.fujitsu.com>
Date: Mon, 09 Apr 2012 14:47:25 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
CC: linux-mm@kvack.org, mgorman@suse.de, dhillf@gmail.com, aarcange@redhat.com,
        mhocko@suse.cz, akpm@linux-foundation.org, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH -V5 06/14] hugetlb: Simplify migrate_huge_page
References: <1333738260-1329-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1333738260-1329-7-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
In-Reply-To: <1333738260-1329-7-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/04/07 3:50), Aneesh Kumar K.V wrote:

> From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
> 
> Since we migrate only one hugepage don't use linked list for passing
> the page around. Directly pass page that need to be migrated as argument.
> This also remove the usage page->lru in migrate path.
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>


seems good to me. I have one question below.


> ---
>  include/linux/migrate.h |    4 +--
>  mm/memory-failure.c     |   13 ++--------
>  mm/migrate.c            |   65 +++++++++++++++--------------------------------
>  3 files changed, 25 insertions(+), 57 deletions(-)
> 
> diff --git a/include/linux/migrate.h b/include/linux/migrate.h
> index 855c337..ce7e667 100644
> --- a/include/linux/migrate.h
> +++ b/include/linux/migrate.h
> @@ -15,7 +15,7 @@ extern int migrate_page(struct address_space *,
>  extern int migrate_pages(struct list_head *l, new_page_t x,
>  			unsigned long private, bool offlining,
>  			enum migrate_mode mode);
> -extern int migrate_huge_pages(struct list_head *l, new_page_t x,
> +extern int migrate_huge_page(struct page *, new_page_t x,
>  			unsigned long private, bool offlining,
>  			enum migrate_mode mode);
>  
> @@ -36,7 +36,7 @@ static inline void putback_lru_pages(struct list_head *l) {}
>  static inline int migrate_pages(struct list_head *l, new_page_t x,
>  		unsigned long private, bool offlining,
>  		enum migrate_mode mode) { return -ENOSYS; }
> -static inline int migrate_huge_pages(struct list_head *l, new_page_t x,
> +static inline int migrate_huge_page(struct page *page, new_page_t x,
>  		unsigned long private, bool offlining,
>  		enum migrate_mode mode) { return -ENOSYS; }
>  
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index 97cc273..1f092db 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -1414,7 +1414,6 @@ static int soft_offline_huge_page(struct page *page, int flags)
>  	int ret;
>  	unsigned long pfn = page_to_pfn(page);
>  	struct page *hpage = compound_head(page);
> -	LIST_HEAD(pagelist);
>  
>  	ret = get_any_page(page, pfn, flags);
>  	if (ret < 0)
> @@ -1429,19 +1428,11 @@ static int soft_offline_huge_page(struct page *page, int flags)
>  	}
>  
>  	/* Keep page count to indicate a given hugepage is isolated. */
> -
> -	list_add(&hpage->lru, &pagelist);
> -	ret = migrate_huge_pages(&pagelist, new_page, MPOL_MF_MOVE_ALL, 0,
> -				true);
> +	ret = migrate_huge_page(page, new_page, MPOL_MF_MOVE_ALL, 0, true);
> +	put_page(page);
>  	if (ret) {
> -		struct page *page1, *page2;
> -		list_for_each_entry_safe(page1, page2, &pagelist, lru)
> -			put_page(page1);
> -
>  		pr_info("soft offline: %#lx: migration failed %d, type %lx\n",
>  			pfn, ret, page->flags);
> -		if (ret > 0)
> -			ret = -EIO;
>  		return ret;
>  	}
>  done:
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 51c08a0..d7eb82d 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -929,15 +929,8 @@ static int unmap_and_move_huge_page(new_page_t get_new_page,
>  	if (anon_vma)
>  		put_anon_vma(anon_vma);
>  	unlock_page(hpage);
> -
>  out:
> -	if (rc != -EAGAIN) {
> -		list_del(&hpage->lru);
> -		put_page(hpage);
> -	}
> -
>  	put_page(new_hpage);
> -
>  	if (result) {
>  		if (rc)
>  			*result = rc;
> @@ -1013,48 +1006,32 @@ out:
>  	return nr_failed + retry;
>  }
>  
> -int migrate_huge_pages(struct list_head *from,
> -		new_page_t get_new_page, unsigned long private, bool offlining,
> -		enum migrate_mode mode)
> +int migrate_huge_page(struct page *hpage, new_page_t get_new_page,
> +		      unsigned long private, bool offlining,
> +		      enum migrate_mode mode)
>  {
> -	int retry = 1;
> -	int nr_failed = 0;
> -	int pass = 0;
> -	struct page *page;
> -	struct page *page2;
> -	int rc;
> -
> -	for (pass = 0; pass < 10 && retry; pass++) {
> -		retry = 0;
> -
> -		list_for_each_entry_safe(page, page2, from, lru) {
> +	int pass, rc;
> +
> +	for (pass = 0; pass < 10; pass++) {
> +		rc = unmap_and_move_huge_page(get_new_page,
> +					      private, hpage, pass > 2, offlining,
> +					      mode);
> +		switch (rc) {
> +		case -ENOMEM:
> +			goto out;
> +		case -EAGAIN:
> +			/* try again */
>  			cond_resched();
> -
> -			rc = unmap_and_move_huge_page(get_new_page,
> -					private, page, pass > 2, offlining,
> -					mode);
> -
> -			switch(rc) {
> -			case -ENOMEM:
> -				goto out;
> -			case -EAGAIN:
> -				retry++;
> -				break;
> -			case 0:
> -				break;
> -			default:
> -				/* Permanent failure */
> -				nr_failed++;
> -				break;
> -			}
> +			break;
> +		case 0:
> +			goto out;
> +		default:
> +			rc = -EIO;
> +			goto out;


why -EIO ? Isn't this BUG() ??

Thanks,
-Kame

>  		}
>  	}
> -	rc = 0;
>  out:
> -	if (rc)
> -		return rc;
> -
> -	return nr_failed + retry;
> +	return rc;
>  }
>  
>  #ifdef CONFIG_NUMA



