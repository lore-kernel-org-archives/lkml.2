Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496Ab0IABpy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 21:45:54 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:52400 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969Ab0IABpv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 21:45:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=p5dBGB4WJ/STlaD21ycZu+MpcWXSjqqfqFaA9Y30AQneH/D/IlpZqCzxTpRFiKTUxe
         l91wm5bjjLISmzwe91ugwrPISGhb2a9Lp8bqbBHmZNTRPV4ZmpcKK3UPAICkfMvma2M7
         3esauhplSlaa1Qp/S3Rn6y6UqugjNMG/KaOOQ=
MIME-Version: 1.0
In-Reply-To: <20100901092430.9741.A69D9226@jp.fujitsu.com>
References: <20100901092430.9741.A69D9226@jp.fujitsu.com>
Date: Wed, 1 Sep 2010 10:45:48 +0900
Message-ID: <AANLkTikXfvEVXEyw_5_eJs2v-3J6Xhd=CT9X-0D+GMCA@mail.gmail.com>
Subject: Re: [BUGFIX][PATCH] vmscan: don't use return value trick when oom_killer_disabled
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "M. Vefa Bicakci" <bicave@superonline.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi KOSAKI,

On Wed, Sep 1, 2010 at 9:31 AM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
> M. Vefa Bicakci reported 2.6.35 kernel hang up when hibernation on his
> 32bit 3GB mem machine. (https://bugzilla.kernel.org/show_bug.cgi?id=16771)
> Also he was bisected first bad commit is below
>
>  commit bb21c7ce18eff8e6e7877ca1d06c6db719376e3c
>  Author: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>  Date:   Fri Jun 4 14:15:05 2010 -0700
>
>     vmscan: fix do_try_to_free_pages() return value when priority==0 reclaim failure
>
> At first impression, this seemed very strange because the above commit only
> chenged function return value and hibernate_preallocate_memory() ignore
> return value of shrink_all_memory(). But it's related.
>
> Now, page allocation from hibernation code may enter infinite loop if
> the system has highmem.
>
> The reasons are two. 1) hibernate_preallocate_memory() call
> alloc_pages() wrong order 2) vmscan don't care enough OOM case when
> oom_killer_disabled.
>
> This patch only fix (2). Why is oom_killer_disabled so special?
> because when hibernation case, zone->all_unreclaimable never be turned on.
> hibernation freeze all tasks at first, then kswapd can't works in this
> case, and zone->all_unreclaimable is only turned from kswapd.

Nice catch!!
There is some comment below.

>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Rik van Riel <riel@redhat.com>
> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> Cc: M. Vefa Bicakci <bicave@superonline.com>
> Cc: stable@kernel.org
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> ---
>  mm/vmscan.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index c391c32..1919d8a 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -40,6 +40,7 @@
>  #include <linux/memcontrol.h>
>  #include <linux/delayacct.h>
>  #include <linux/sysctl.h>
> +#include <linux/oom.h>
>
>  #include <asm/tlbflush.h>
>  #include <asm/div64.h>
> @@ -1931,7 +1932,7 @@ out:
>                return sc->nr_reclaimed;
>
>        /* top priority shrink_zones still had more to do? don't OOM, then */
> -       if (scanning_global_lru(sc) && !all_unreclaimable)
> +       if (scanning_global_lru(sc) && !all_unreclaimable && !oom_killer_disabled)
>                return 1;
>
>        return 0;
> --
> 1.6.5.2
>

I don't like use oom_killer_disabled directly.
That's because we have wrapper inline functions to handle the
variable(ex, oom_killer_[disable/enable]).
It means we are reluctant to use the global variable directly.
So should we make new function as is_oom_killer_disable?

I think NO.

As I read your description, this problem is related to only hibernation.
Since hibernation freezes all processes(include kswapd), this problem
happens. Of course, now oom_killer_disabled is used by only
hibernation. But it can be used others in future(Off-topic : I don't
want it). Others can use it without freezing processes. Then kswapd
can set zone->all_unreclaimable and the problem can't happen.

So I want to use sc->hibernation_mode which is already used
do_try_to_free_pages instead of oom_killer_disabled.

-- 
Kind regards,
Minchan Kim
