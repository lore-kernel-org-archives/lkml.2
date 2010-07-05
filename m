Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197Ab0GEK2s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 06:28:48 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35153 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754272Ab0GEK2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 06:28:46 -0400
Date: Mon, 5 Jul 2010 12:28:44 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Wu Fengguang <fengguang.wu@intel.com>,
       "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
       linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/7] hugetlb, HWPOISON: soft offlining for hugepage
Message-ID: <20100705102844.GD8510@basil.fritz.box>
References: <1278049646-29769-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1278049646-29769-8-git-send-email-n-horiguchi@ah.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278049646-29769-8-git-send-email-n-horiguchi@ah.jp.nec.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +void isolate_hwpoisoned_huge_page(struct page *hpage)
> +{
> +	lock_page(hpage);
> +	__isolate_hwpoisoned_huge_page(hpage);
> +	unlock_page(hpage);
> +}

This assumes all other users (even outside this file)
who lock always do so on the head page too.  Needs some double-checking?

>  	} else {
>  		pr_debug("soft offline: %#lx: isolation failed: %d, page count %d, type %lx\n",
>  				pfn, ret, page_count(page), page->flags);
> @@ -1351,8 +1380,8 @@ int soft_offline_page(struct page *page, int flags)
>  		return ret;
>  
>  done:
> -	atomic_long_add(1, &mce_bad_pages);
> -	SetPageHWPoison(page);
> +	atomic_long_add(1 << compound_order(hpage), &mce_bad_pages);

Probably should add a separate counter too?

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
