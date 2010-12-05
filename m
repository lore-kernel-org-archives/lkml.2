Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123Ab0LEXfV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 18:35:21 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59357 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931Ab0LEXfT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 18:35:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=MudmQrRrjD2d1f9Q97EfP99r/tke6lH4DaBt2WvOWE0hKKrkoGJqxH9kVczi9BKT9O
         tZL1EfCJcjUmNlLSpJTKOgxvwuxC0NwzpXJRyJgiepmvvA7Chc5tkUm9fGlZHri/Dvy6
         rYtOktn4rFqrwKWFWVoFjBg0iKj0UyHbGVA2w=
MIME-Version: 1.0
In-Reply-To: <1291376734-30202-2-git-send-email-mel@csn.ul.ie>
References: <1291376734-30202-1-git-send-email-mel@csn.ul.ie>
	<1291376734-30202-2-git-send-email-mel@csn.ul.ie>
Date: Mon, 6 Dec 2010 08:35:18 +0900
Message-ID: <AANLkTi=ZXBXS2m0WCTNWT1t6EFi=Vji5t-yQG=fTJQgs@mail.gmail.com>
Subject: Re: [PATCH 1/5] mm: kswapd: Stop high-order balancing when any
 suitable zone is balanced
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Simon Kirby <sim@hostway.ca>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Shaohua Li <shaohua.li@intel.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mel,

On Fri, Dec 3, 2010 at 8:45 PM, Mel Gorman <mel@csn.ul.ie> wrote:
> When the allocator enters its slow path, kswapd is woken up to balance the
> node. It continues working until all zones within the node are balanced. For
> order-0 allocations, this makes perfect sense but for higher orders it can
> have unintended side-effects. If the zone sizes are imbalanced, kswapd may
> reclaim heavily within a smaller zone discarding an excessive number of
> pages. The user-visible behaviour is that kswapd is awake and reclaiming
> even though plenty of pages are free from a suitable zone.
>
> This patch alters the "balance" logic for high-order reclaim allowing kswapd
> to stop if any suitable zone becomes balanced to reduce the number of pages
> it reclaims from other zones. kswapd still tries to ensure that order-0
> watermarks for all zones are met before sleeping.
>
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>

<snip>

> -       if (!all_zones_ok) {
> +       if (!(all_zones_ok || (order && any_zone_ok))) {
>                cond_resched();
>
>                try_to_freeze();
> @@ -2361,6 +2366,31 @@ out:
>                goto loop_again;
>        }
>
> +       /*
> +        * If kswapd was reclaiming at a higher order, it has the option of
> +        * sleeping without all zones being balanced. Before it does, it must
> +        * ensure that the watermarks for order-0 on *all* zones are met and
> +        * that the congestion flags are cleared
> +        */
> +       if (order) {
> +               for (i = 0; i <= end_zone; i++) {
> +                       struct zone *zone = pgdat->node_zones + i;
> +
> +                       if (!populated_zone(zone))
> +                               continue;
> +
> +                       if (zone->all_unreclaimable && priority != DEF_PRIORITY)
> +                               continue;
> +
> +                       zone_clear_flag(zone, ZONE_CONGESTED);

Why clear ZONE_CONGESTED?
If you have a cause, please, write down the comment.

<snip>

First impression on this patch is that it changes scanning behavior as
well as reclaiming on high order reclaim.
I can't say old behavior is right but we can't say this behavior is
right, too although this patch solves the problem. At least, we might
need some data that shows this patch doesn't have a regression. It's
not easy but I believe you can do very well as like having done until
now. I didn't see whole series so I might miss something.

-- 
Kind regards,
Minchan Kim
