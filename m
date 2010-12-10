Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757668Ab0LJBQV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 20:16:21 -0500
Received: from mail-iw0-f172.google.com ([209.85.214.172]:63260 "EHLO
	mail-iw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755020Ab0LJBQU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 20:16:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=n2NPUt8MEcWVw4LKqZtUu0I8zuxm/tsInvGXd1CujjTLbPYGFEw0XU8FAvYlqKv2Cn
         p8dvcJjmAZqib8TrHLk5XYeTaYJozLKNvz+OL4e0OTGkOQnnFkebIc0/Aaj1Br8CB2uG
         im/f1DeXpAbI4nOuvyV6pj6/u05pTPug/e/cI=
MIME-Version: 1.0
In-Reply-To: <1291893500-12342-4-git-send-email-mel@csn.ul.ie>
References: <1291893500-12342-1-git-send-email-mel@csn.ul.ie>
	<1291893500-12342-4-git-send-email-mel@csn.ul.ie>
Date: Fri, 10 Dec 2010 10:16:19 +0900
Message-ID: <AANLkTi=2LYh04DMagfEQ6dtsfrzzLtopPG--BW+SGtpy@mail.gmail.com>
Subject: Re: [PATCH 3/6] mm: kswapd: Use the order that kswapd was reclaiming
 at for sleeping_prematurely()
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Simon Kirby <sim@hostway.ca>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Shaohua Li <shaohua.li@intel.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 9, 2010 at 8:18 PM, Mel Gorman <mel@csn.ul.ie> wrote:
> Before kswapd goes to sleep, it uses sleeping_prematurely() to check if
> there was a race pushing a zone below its watermark. If the race
> happened, it stays awake. However, balance_pgdat() can decide to reclaim
> at a lower order if it decides that high-order reclaim is not working as

Could you specify "order-0" explicitly instead of "a lower order"?
It makes more clear to me.

> expected. This information is not passed back to sleeping_prematurely().
> The impact is that kswapd remains awake reclaiming pages long after it
> should have gone to sleep. This patch passes the adjusted order to
> sleeping_prematurely and uses the same logic as balance_pgdat to decide
> if it's ok to go to sleep.
>
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

A comment below.

> ---
>  mm/vmscan.c |   14 ++++++++++----
>  1 files changed, 10 insertions(+), 4 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index b4472a1..52e229e 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2132,7 +2132,7 @@ static bool pgdat_balanced(pg_data_t *pgdat, unsigned long balanced)
>  }
>
>  /* is kswapd sleeping prematurely? */
> -static int sleeping_prematurely(pg_data_t *pgdat, int order, long remaining)
> +static bool sleeping_prematurely(pg_data_t *pgdat, int order, long remaining)
>  {
>        int i;
>        unsigned long balanced = 0;
> @@ -2142,7 +2142,7 @@ static int sleeping_prematurely(pg_data_t *pgdat, int order, long remaining)
>        if (remaining)
>                return 1;
>
> -       /* If after HZ/10, a zone is below the high mark, it's premature */
> +       /* Check the watermark levels */
>        for (i = 0; i < pgdat->nr_zones; i++) {
>                struct zone *zone = pgdat->node_zones + i;
>
> @@ -2427,7 +2427,13 @@ out:
>                }
>        }
>
> -       return sc.nr_reclaimed;
> +       /*
> +        * Return the order we were reclaiming at so sleeping_prematurely()
> +        * makes a decision on the order we were last reclaiming at. However,
> +        * if another caller entered the allocator slow path while kswapd
> +        * was awake, order will remain at the higher level
> +        */
> +       return order;
>  }

Please change return value description of balance_pgdat.
"Returns the number of pages which were actually freed"


-- 
Kind regards,
Minchan Kim
