Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932134Ab0GVNRA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 09:17:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13297 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753345Ab0GVNQ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 09:16:57 -0400
Message-ID: <4C4844BC.4090709@redhat.com>
Date: Thu, 22 Jul 2010 09:16:44 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        kosaki.motohiro@jp.fujitsu.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [BUGFIX][PATCH] Fix false positive BUG_ON in __page_set_anon_rmap
References: <20100722164118.d500b850.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100722164118.d500b850.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2010 03:41 AM, KAMEZAWA Hiroyuki wrote:
> Rik, how do you think ?
>
> ==
> From: KAMEZAWA Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com>
>
> Problem: wrong BUG_ON() in  __page_set_anon_rmap().
> Kernel version: mmotm-0719

> Description:
>    Even if SwapCache is fully unmapped and mapcount goes down to 0,
>    page->mapping is not cleared and will remain on memory until kswapd or some
>    finds it. If a thread cause a page fault onto such "unmapped-but-not-discarded"
>    swapcache, it will see a swap cache whose mapcount is 0 but page->mapping has a
>    valid value.
>
>    When it's reused at do_swap_page(), __page_set_anon_rmap() is called with
>    "exclusive==1" and hits BUG_ON(). But this BUG_ON() is wrong. Nothing bad
>    with rmapping a page which has page->mapping isn't 0.

Yes, you are absolutely right.

Acked-by: Rik van Riel <riel@redhat.com>

> Index: mmotm-2.6.35-0719/mm/rmap.c
> ===================================================================
> --- mmotm-2.6.35-0719.orig/mm/rmap.c
> +++ mmotm-2.6.35-0719/mm/rmap.c
> @@ -783,8 +783,16 @@ static void __page_set_anon_rmap(struct
>   		if (PageAnon(page))
>   			return;
>   		anon_vma = anon_vma->root;
> -	} else
> -		BUG_ON(PageAnon(page));
> +	} else {
> +		/*
> + 		 * In this case, swapped-out-but-not-discarded swap-cache
> + 		 * is remapped. So, no need to update page->mapping here.
> + 		 * We convice anon_vma poitned by page->mapping is not obsolete
> + 		 * because vma->anon_vma is necessary to be a family of it.
> + 		 */
> +		if (PageAnon(page))
> +			return;
> +	}
>
>   	anon_vma = (void *) anon_vma + PAGE_MAPPING_ANON;
>   	page->mapping = (struct address_space *) anon_vma;
>


-- 
All rights reversed
