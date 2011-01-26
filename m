Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795Ab1AZIou (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 03:44:50 -0500
Received: from gir.skynet.ie ([193.1.99.77]:60025 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751685Ab1AZIos (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 03:44:48 -0500
Date: Wed, 26 Jan 2011 08:44:23 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Luca Tettamanti <kronos.it@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] compaction: don't depend on HUGETLB_PAGE
Message-ID: <20110126084423.GO18984@csn.ul.ie>
References: <AANLkTikdwZp1r_MD4TH7bsLjzPAtHzq7XWoLZmFwdK=S@mail.gmail.com> <20110122183800.GU9506@random.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20110122183800.GU9506@random.random>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 22, 2011 at 07:38:00PM +0100, Andrea Arcangeli wrote:
> Hello,
> 
> On Sat, Jan 22, 2011 at 03:48:03PM +0100, Luca Tettamanti wrote:
> > Hello Andrea,
> > this commit:
> > 
> > commit 5d6892407cab23d4bf2f6de065ca351a53849323
> > Author: Andrea Arcangeli <aarcange@redhat.com>
> > Date:   Thu Jan 13 15:47:07 2011 -0800
> > 
> >     thp: select CONFIG_COMPACTION if TRANSPARENT_HUGEPAGE enabled
> > 
> > causes this warning during the configuration process:
> > 
> > warning: (TRANSPARENT_HUGEPAGE) selects COMPACTION which has unmet
> > direct dependencies (EXPERIMENTAL && HUGETLB_PAGE && MMU)
> > 
> > This happens because 'select' does not enable the dependencies of its
> > target, so when I selected THP it also enabled COMPATION but I don't
> > have HUGETLBFS (=HUGETLB_PAGE) enabled.
> > Making THP select HUGETLB_PAGE fixes the warning but I'm not 100% sure
> > that's correct (does it work without HUGETLBFS?).
> 
> Mel, what's your take about this issue?
> 

The dependencies were only in the name of being conservative. Hugetlbfs was
initially the only expected user of compaction so making it depend was meant
to restrict who might enable it and is not a true dependency. It was marked
experimental at the start for obvious reasons.

> Luca does the below fix all your .config problems?
> 
> ====
> Subject: compaction: don't depend on HUGETLB_PAGE
> 
> From: Andrea Arcangeli <aarcange@redhat.com>
> 
> COMPACTION doesn't depend on HUGETLB_PAGE, it doesn't depend on THP
> either, it is also useful for regular alloc_pages(order > 0) including
> the very kernel stack during fork (THREAD_ORDER = 1). It's always
> better to enable COMPACTION.
> 
> The warning should be an error because we would end up with MIGRATION
> not selected, and COMPACTION wouldn't work without migration (despite
> it seems to build with an inline migrate_pages returning -ENOSYS).
> 
> I'd also like to remove EXPERIMENTAL: compaction has been in the
> kernel for some releases (for full safety the default remains
> disabled which I think is enough).
> 
> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>

I think this is reasonable;

Acked-by: Mel Gorman <mel@csn.ul.ie>

> ---
> 
> diff --git a/mm/Kconfig b/mm/Kconfig
> index 3ad483b..e9c0c61 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -179,7 +179,7 @@ config SPLIT_PTLOCK_CPUS
>  config COMPACTION
>  	bool "Allow for memory compaction"
>  	select MIGRATION
> -	depends on EXPERIMENTAL && HUGETLB_PAGE && MMU
> +	depends on MMU
>  	help
>  	  Allows the compaction of memory for the allocation of huge pages.
>  
> 

-- 
Mel Gorman
Linux Technology Center
IBM Dublin Software Lab
