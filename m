Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734Ab2KSSon (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 13:44:43 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:35094 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754719Ab2KSSoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 13:44:39 -0500
MIME-Version: 1.0
In-Reply-To: <1353350518-32623-1-git-send-email-sonnyrao@chromium.org>
References: <20121119134001.GA2799@cmpxchg.org> <1353350518-32623-1-git-send-email-sonnyrao@chromium.org>
From: Sonny Rao <sonnyrao@chromium.org>
Date: Mon, 19 Nov 2012 10:44:17 -0800
X-Google-Sender-Auth: BMQQMpJ893FJOzJER0Xke5a3VZM
Message-ID: <CAPz6YkXazpiJgKHnQx=dpr4XOCo8J_PBeffDG7mfPk7rPy2a-g@mail.gmail.com>
Subject: Re: [PATCHv5] mm: Fix calculation of dirtyable memory
To: damien.wyart@gmail.com
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        Mandeep Singh Baines <msb@chromium.org>,
        Johannes Weiner <jweiner@redhat.com>,
        Olof Johansson <olofj@chromium.org>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>, Aaron Durbin <adurbin@chromium.org>,
        stable@vger.kernel.org, Sonny Rao <sonnyrao@chromium.org>,
        Puneet Kumar <puneetster@chromium.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2012 at 10:41 AM, Sonny Rao <sonnyrao@chromium.org> wrote:
> The system uses global_dirtyable_memory() to calculate
> number of dirtyable pages/pages that can be allocated
> to the page cache.  A bug causes an underflow thus making
> the page count look like a big unsigned number.  This in turn
> confuses the dirty writeback throttling to aggressively write
> back pages as they become dirty (usually 1 page at a time).
> This generally only affects systems with highmem because the
> underflowed count gets subtracted from the global count of
> dirtyable memory.
>
> The problem was introduced with v3.2-4896-gab8fabd
>
> Fix is to ensure we don't get an underflowed total of either highmem
> or global dirtyable memory.
>
> Signed-off-by: Sonny Rao <sonnyrao@chromium.org>
> Signed-off-by: Puneet Kumar <puneetster@chromium.org>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> CC: stable@vger.kernel.org
> ---
>  v2: added apkm's suggestion to make the highmem calculation better
>  v3: added Fengguang Wu's suggestions fix zone_dirtyable_memory() and
>      (offlist mail) to use max() in global_dirtyable_memory()
>  v4: Added suggestions to description clarifying the role of highmem
>       and the commit which originally caused the problem
>  v5: Fix bug where max() was used instead of min()
>  mm/page-writeback.c |   25 ++++++++++++++++++++-----
>  1 files changed, 20 insertions(+), 5 deletions(-)
>
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 830893b..f9efbe8 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -201,6 +201,18 @@ static unsigned long highmem_dirtyable_memory(unsigned long total)
>                      zone_reclaimable_pages(z) - z->dirty_balance_reserve;
>         }
>         /*
> +        * Unreclaimable memory (kernel memory or anonymous memory
> +        * without swap) can bring down the dirtyable pages below
> +        * the zone's dirty balance reserve and the above calculation
> +        * will underflow.  However we still want to add in nodes
> +        * which are below threshold (negative values) to get a more
> +        * accurate calculation but make sure that the total never
> +        * underflows.
> +        */
> +       if ((long)x < 0)
> +               x = 0;
> +
> +       /*
>          * Make sure that the number of highmem pages is never larger
>          * than the number of the total dirtyable memory. This can only
>          * occur in very strange VM situations but we want to make sure
> @@ -222,8 +234,8 @@ static unsigned long global_dirtyable_memory(void)
>  {
>         unsigned long x;
>
> -       x = global_page_state(NR_FREE_PAGES) + global_reclaimable_pages() -
> -           dirty_balance_reserve;
> +       x = global_page_state(NR_FREE_PAGES) + global_reclaimable_pages();
> +       x -= min(x, dirty_balance_reserve);
>
>         if (!vm_highmem_is_dirtyable)
>                 x -= highmem_dirtyable_memory(x);
> @@ -290,9 +302,12 @@ static unsigned long zone_dirtyable_memory(struct zone *zone)
>          * highmem zone can hold its share of dirty pages, so we don't
>          * care about vm_highmem_is_dirtyable here.
>          */
> -       return zone_page_state(zone, NR_FREE_PAGES) +
> -              zone_reclaimable_pages(zone) -
> -              zone->dirty_balance_reserve;
> +       unsigned long nr_pages = zone_page_state(zone, NR_FREE_PAGES) +
> +               zone_reclaimable_pages(zone);
> +
> +       /* don't allow this to underflow */
> +       nr_pages -= min(nr_pages, zone->dirty_balance_reserve);
> +       return nr_pages;
>  }
>
>  /**
> --
> 1.7.7.3
>

Damien, thanks for testing and finding that bug.  If you could, please
give this version a try, thanks.
