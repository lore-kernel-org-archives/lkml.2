Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631Ab0HaCJ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 22:09:26 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36038 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756605Ab0HaCJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 22:09:25 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH] vmscan: prevent background aging of anon page in no swap system
Cc: kosaki.motohiro@jp.fujitsu.com, Ying Han <yinghan@google.com>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Venkatesh Pallipadi <venki@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>
In-Reply-To: <AANLkTinhVnMW8f7+jQdDyEzD=O2YPLSyTuGRE2JnRVzm@mail.gmail.com>
References: <20100831102557.87D3.A69D9226@jp.fujitsu.com> <AANLkTinhVnMW8f7+jQdDyEzD=O2YPLSyTuGRE2JnRVzm@mail.gmail.com>
Message-Id: <20100831110815.87D9.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 31 Aug 2010 11:09:21 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> How about this?
> 
> (Not formal patch. If we agree, I will post it later when I have a SMTP).
> 
> 
> Signed-off-by: Ying Han <yinghan@google.com>
> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 3109ff7..c3c44a8 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1579,7 +1579,7 @@ static void shrink_active_list(unsigned long
> nr_pages, struct zone *zone,
>         __mod_zone_page_state(zone, NR_ISOLATED_ANON + file, -nr_taken);
>         spin_unlock_irq(&zone->lru_lock);
>  }
> -
> +#if CONFIG_SWAP
>  static int inactive_anon_is_low_global(struct zone *zone)
>  {
>         unsigned long active, inactive;
> @@ -1605,12 +1605,21 @@ static int inactive_anon_is_low(struct zone
> *zone, struct scan_control *sc)
>  {
>         int low;
> 
> +       if (nr_swap_pages)
> +               return 0;

!nr_swap_pages ?



> +
>         if (scanning_global_lru(sc))
>                 low = inactive_anon_is_low_global(zone);
>         else
>                 low = mem_cgroup_inactive_anon_is_low(sc->mem_cgroup);
>         return low;
>  }
> +#else
> +static inline int inactive_anon_is_low(struct zone *zone, struct
> scan_control *sc)
> +{
> +       return 0;
> +}
> +#endif

Yup. I prefer this explicit #ifdef :)



