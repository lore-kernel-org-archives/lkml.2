Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932778Ab0FBSRM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 14:17:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49431 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932464Ab0FBSRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 14:17:11 -0400
Date: Wed, 2 Jun 2010 11:16:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, Wu Fengguang <fengguang.wu@intel.com>,
       Mel Gorman <mel@csn.ul.ie>, Andrea Arcangeli <aarcange@redhat.com>,
       Larry Woodman <lwoodman@redhat.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [PATCH 2/8] hugetlb, rmap: add reverse mapping for hugepage
Message-Id: <20100602111617.0c292178.akpm@linux-foundation.org>
In-Reply-To: <1275006562-18946-3-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1275006562-18946-1-git-send-email-n-horiguchi@ah.jp.nec.com>
	<1275006562-18946-3-git-send-email-n-horiguchi@ah.jp.nec.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 May 2010 09:29:16 +0900
Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> wrote:

> +#ifdef CONFIG_HUGETLBFS
> +/*
> + * The following three functions are for anonymous (private mapped) hugepages.
> + * Unlike common anonymous pages, anonymous hugepages have no accounting code
> + * and no lru code, because we handle hugepages differently from common pages.
> + */
> +static void __hugepage_set_anon_rmap(struct page *page,
> +	struct vm_area_struct *vma, unsigned long address, int exclusive)
> +{
> +	struct anon_vma *anon_vma = vma->anon_vma;
> +	BUG_ON(!anon_vma);
> +	if (!exclusive) {
> +		struct anon_vma_chain *avc;
> +		avc = list_entry(vma->anon_vma_chain.prev,
> +				 struct anon_vma_chain, same_vma);
> +		anon_vma = avc->anon_vma;
> +	}
> +	anon_vma = (void *) anon_vma + PAGE_MAPPING_ANON;
> +	page->mapping = (struct address_space *) anon_vma;
> +	page->index = linear_page_index(vma, address);
> +}
> +
> +void hugepage_add_anon_rmap(struct page *page,
> +			    struct vm_area_struct *vma, unsigned long address)
> +{
> +	struct anon_vma *anon_vma = vma->anon_vma;
> +	int first;
> +	BUG_ON(!anon_vma);
> +	BUG_ON(address < vma->vm_start || address >= vma->vm_end);
> +	first = atomic_inc_and_test(&page->_mapcount);
> +	if (first)
> +		__hugepage_set_anon_rmap(page, vma, address, 0);
> +}
> +
> +void hugepage_add_new_anon_rmap(struct page *page,
> +			struct vm_area_struct *vma, unsigned long address)
> +{
> +	BUG_ON(address < vma->vm_start || address >= vma->vm_end);
> +	atomic_set(&page->_mapcount, 0);
> +	__hugepage_set_anon_rmap(page, vma, address, 1);
> +}
> +#endif /* CONFIG_HUGETLBFS */

This code still make sense if CONFIG_HUGETLBFS=n, I think?  Should it
instead depend on CONFIG_HUGETLB_PAGE?

I have a feeling that we make that confusion relatively often.  Perhaps
CONFIG_HUGETLB_PAGE=y && CONFIG_HUGETLBFS=n makes no sense and we
should unify them...  
