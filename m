Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649Ab2I0BRm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 21:17:42 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:61294 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509Ab2I0BRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 21:17:41 -0400
Date: Wed, 26 Sep 2012 18:17:39 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
cc: Wu Fengguang <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi.kleen@intel.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] kpageflags: fix wrong KPF_THP on non-huge compound
 pages
In-Reply-To: <1348691234-31729-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Message-ID: <alpine.DEB.2.00.1209261817200.7072@chino.kir.corp.google.com>
References: <1348691234-31729-1-git-send-email-n-horiguchi@ah.jp.nec.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Sep 2012, Naoya Horiguchi wrote:

> diff --git v3.6-rc6.orig/fs/proc/page.c v3.6-rc6/fs/proc/page.c
> index 7fcd0d6..b8730d9 100644
> --- v3.6-rc6.orig/fs/proc/page.c
> +++ v3.6-rc6/fs/proc/page.c
> @@ -115,7 +115,13 @@ u64 stable_page_flags(struct page *page)
>  		u |= 1 << KPF_COMPOUND_TAIL;
>  	if (PageHuge(page))
>  		u |= 1 << KPF_HUGE;
> -	else if (PageTransCompound(page))
> +	/*
> +	 * PageTransCompound can be true for non-huge compound pages (slab
> +	 * pages or pages allocated by drivers with __GFP_COMP) because it
> +	 * just checks PG_head/PG_tail, so we need to check PageLRU to make
> +	 * sure a given page is a thp, not a non-huge compound page.
> +	 */
> +	else if (PageTransCompound(page) && PageLRU(compound_trans_head(page)))
>  		u |= 1 << KPF_THP;
>  
>  	/*

Yes, that looks good.  Nice catch by Fengguang.
