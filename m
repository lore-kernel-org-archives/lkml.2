Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093Ab2K1UsK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 15:48:10 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:53049 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754453Ab2K1UsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 15:48:08 -0500
Date: Wed, 28 Nov 2012 12:48:08 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Mel Gorman <mgorman@suse.de>
cc: Hillf Danton <dhillf@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 1/3] balancenuma: put page if avoid migrating page
In-Reply-To: <20121127141615.GA20087@suse.de>
Message-ID: <alpine.LNX.2.00.1211281238390.14968@eggly.anvils>
References: <CAJd=RBB+SGundq6jOR0n01jQhAnEf0T5br7_3SQB7-OPuGkgzg@mail.gmail.com> <20121127140705.GP8218@suse.de> <20121127141615.GA20087@suse.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Nov 2012, Mel Gorman wrote:
> On Tue, Nov 27, 2012 at 02:07:05PM +0000, Mel Gorman wrote:
> > On Tue, Nov 27, 2012 at 09:23:59PM +0800, Hillf Danton wrote:
> > > If we have to avoid migrating to a node that is nearly full, put page
> > > and return zero.
> > > 
> > > Signed-off-by: Hillf Danton <dhillf@gmail.com>
> > 
> > Correct. In this series, the bug was actually introduced back in "mm:
> > migrate: Introduce migrate_misplaced_page()" so I'm working the fix to
> > be a fix on top of that patch and will ensure it gets carried through
> > properly in the THP patch that happens at the end of the series. This will
> > work out better in terms of bisection if the tree gets merged and allows
> > a partial tree to be properly tested. Can I get your signed off on this
> > patch please? This would be applied on top of "mm: migrate: Introduce
> > migrate_misplaced_page()"
> > 
> > Thanks.
> > 
> 
> After slotting the fix into the right place in the series and resolving
> the conflict, the overall diff looks like;

A big thankyou to Hillf for this.

Fixing the missed-putpage leak is nice, but much more important is that
it (either his or your rework) fixes the way numamigrate_isolate_page()'s
return value was claiming to have isolated a page when it had not done so.

I never found time to investigate, but applying the patch shows that was
what caused the page->lru corruptions and crashes (and bad page states)
that I mentioned to you last week.

Hugh

> 
> diff --git a/mm/migrate.c b/mm/migrate.c
> index b0c1585..ed0bdea 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -1515,6 +1515,8 @@ bool numamigrate_update_ratelimit(pg_data_t *pgdat)
>  
>  int numamigrate_isolate_page(pg_data_t *pgdat, struct page *page)
>  {
> +	int ret = 0;
> +
>  	/* Avoid migrating to a node that is nearly full */
>  	if (migrate_balanced_pgdat(pgdat, 1)) {
>  		int page_lru;
> @@ -1524,13 +1526,8 @@ int numamigrate_isolate_page(pg_data_t *pgdat, struct page *page)
>  			return 0;
>  		}
>  
> -		/*
> -		 * Page is isolated which takes a reference count so now the
> -		 * callers reference can be safely dropped without the page
> -		 * disappearing underneath us during migration
> -		 */
> -		put_page(page);
> -
> +		/* Page is isolated */
> +		ret = 1;
>  		page_lru = page_is_file_cache(page);
>  		if (!PageTransHuge(page))
>  			inc_zone_page_state(page, NR_ISOLATED_ANON + page_lru);
> @@ -1540,7 +1537,17 @@ int numamigrate_isolate_page(pg_data_t *pgdat, struct page *page)
>  					HPAGE_PMD_NR);
>  	}
>  
> -	return 1;
> +	/*
> +	 * Page is either isolated or there is not enough space on the target
> +	 * node. If isolated, then it has taken a reference count and the
> +	 * callers reference can be safely dropped without the page
> +	 * disappearing underneath us during migration. Otherwise the page is
> +	 * not to be migrated but the callers reference should still be
> +	 * dropped so it does not leak.
> +	 */
> +	put_page(page);
> +
> +	return ret;
>  }
>  
>  /*
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
