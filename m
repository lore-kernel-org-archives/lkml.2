Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757518Ab2KICgo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 21:36:44 -0500
Received: from mga01.intel.com ([192.55.52.88]:19210 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757410Ab2KICgn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 21:36:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,741,1344236400"; 
   d="scan'208";a="246224362"
Date: Fri, 9 Nov 2012 10:36:38 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Sonny Rao <sonnyrao@chromium.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        Mandeep Singh Baines <msb@chromium.org>,
        Johannes Weiner <jweiner@redhat.com>,
        Olof Johansson <olofj@chromium.org>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>, Aaron Durbin <adurbin@chromium.org>,
        Puneet Kumar <puneetster@chromium.org>
Subject: Re: [PATCHv2] mm: Fix calculation of dirtyable memory
Message-ID: <20121109023638.GA11105@localhost>
References: <CAPz6YkVruULzvmn4a8G05xPJUEXdhHqAZnW4sZAHCWMZpW338g@mail.gmail.com>
 <1352422353-11229-1-git-send-email-sonnyrao@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352422353-11229-1-git-send-email-sonnyrao@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 08, 2012 at 04:52:33PM -0800, Sonny Rao wrote:
> The system uses global_dirtyable_memory() to calculate
> number of dirtyable pages/pages that can be allocated
> to the page cache.  A bug causes an underflow thus making
> the page count look like a big unsigned number.  This in turn
> confuses the dirty writeback throttling to aggressively write
> back pages as they become dirty (usually 1 page at a time).
> 
> Fix is to ensure there is no underflow while doing the math.

Good catch, thanks!

> Signed-off-by: Sonny Rao <sonnyrao@chromium.org>
> Signed-off-by: Puneet Kumar <puneetster@chromium.org>
> ---
>  v2: added apkm's suggestion to make the highmem calculation better
>  mm/page-writeback.c |   17 +++++++++++++++--
>  1 files changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 830893b..ce62442 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -201,6 +201,18 @@ static unsigned long highmem_dirtyable_memory(unsigned long total)
>  		     zone_reclaimable_pages(z) - z->dirty_balance_reserve;
>  	}
>  	/*
> +	 * Unreclaimable memory (kernel memory or anonymous memory
> +	 * without swap) can bring down the dirtyable pages below
> +	 * the zone's dirty balance reserve and the above calculation
> +	 * will underflow.  However we still want to add in nodes
> +	 * which are below threshold (negative values) to get a more
> +	 * accurate calculation but make sure that the total never
> +	 * underflows.
> +	 */
> +	if ((long)x < 0)
> +		x = 0;
> +
> +	/*
>  	 * Make sure that the number of highmem pages is never larger
>  	 * than the number of the total dirtyable memory. This can only
>  	 * occur in very strange VM situations but we want to make sure
> @@ -222,8 +234,9 @@ static unsigned long global_dirtyable_memory(void)
>  {
>  	unsigned long x;
>  
> -	x = global_page_state(NR_FREE_PAGES) + global_reclaimable_pages() -
> -	    dirty_balance_reserve;
> +	x = global_page_state(NR_FREE_PAGES) + global_reclaimable_pages();
> +	if (x >= dirty_balance_reserve)
> +		x -= dirty_balance_reserve;

That can be converted to "if ((long)x < 0) x = 0;", too.

And I suspect zone_dirtyable_memory() needs similar fix, too.

Thanks,
Fengguang
