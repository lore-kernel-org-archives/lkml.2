Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751498Ab2IZCs3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 22:48:29 -0400
Received: from mga11.intel.com ([192.55.52.93]:45571 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751165Ab2IZCs2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 22:48:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,487,1344236400"; 
   d="scan'208";a="226489841"
Date: Wed, 26 Sep 2012 10:47:54 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi.kleen@intel.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pagemap: fix wrong KPF_THP on slab pages
Message-ID: <20120926024754.GA12716@localhost>
References: <alpine.DEB.2.00.1209251719400.21751@chino.kir.corp.google.com>
 <1348625168-28983-1-git-send-email-n-horiguchi@ah.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348625168-28983-1-git-send-email-n-horiguchi@ah.jp.nec.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 10:06:08PM -0400, Naoya Horiguchi wrote:
> On Tue, Sep 25, 2012 at 05:20:48PM -0700, David Rientjes wrote:
> > On Tue, 25 Sep 2012, Naoya Horiguchi wrote:
> > 
> > > KPF_THP can be set on non-huge compound pages like slab pages, because
> > > PageTransCompound only sees PG_head and PG_tail. Obviously this is a bug
> > > and breaks user space applications which look for thp via /proc/kpageflags.
> > > Currently thp is constructed only on anonymous pages, so this patch makes
> > > KPF_THP be set when both of PageAnon and PageTransCompound are true.
> > > 
> > > Changelog in v2:
> > >   - add a comment in code
> > > 
> > > Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> > 
> > Wouldn't PageTransCompound(page) && !PageHuge(page) && !PageSlab(page) be 
> > better for a future extension of thp support?
> 
> Yes, this saves us an additional change when thp starts handling pagecaches.
> Andrew, can you replace the previous version in -mm tree with new one below?
> 
> Thanks,
> Naoya
> ---
> From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Date: Tue, 25 Sep 2012 21:30:25 -0400
> Subject: [PATCH v3] kpageflags: fix wrong KPF_THP on slab pages
> 
> KPF_THP can be set on non-huge compound pages like slab pages, because
> PageTransCompound only sees PG_head and PG_tail. Obviously this is a bug

s/sees/checks/

> and breaks user space applications which look for thp via /proc/kpageflags.
> This patch rules out setting KPF_THP wrongly by additional PageSlab check.
> 
> Changelog in v3:
>   - check PageSlab instead of PageAnon
>   - fix patch subject
> 
> Changelog in v2:
>   - add a comment in code
> 
> Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> ---
>  fs/proc/page.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/proc/page.c b/fs/proc/page.c
> index 7fcd0d6..e36d1f3 100644
> --- a/fs/proc/page.c
> +++ b/fs/proc/page.c
> @@ -115,7 +115,12 @@ u64 stable_page_flags(struct page *page)
>  		u |= 1 << KPF_COMPOUND_TAIL;
>  	if (PageHuge(page))
>  		u |= 1 << KPF_HUGE;
> -	else if (PageTransCompound(page))
> +	/*
> +	 * PageTransCompound can be true for slab pages because it just sees

s/sees/checks/

> +	 * PG_head/PG_head, so we need to check PageSlab to make sure the given

PG_head/PG_head should be PG_head/PG_tail.

> +	 * page is a thp, not a non-huge compound page.
> +	 */
> +	else if (PageTransCompound(page) && !PageSlab(page))
>  		u |= 1 << KPF_THP;

Good catch!

Will this report THP for the various drivers that do __GFP_COMP
page allocations?

Thanks,
Fengguang
