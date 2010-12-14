Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759019Ab0LNKB3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 05:01:29 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40414 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758651Ab0LNKB1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 05:01:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xdf3Yd47ROB6Rzq4OUAOEqNwkPq/vcuuBeh7JKoyTGER0XSAHxYoMGhn/Mn/TYWDOr
         Kq3/t6AvnUfbHpA95nx3jMzbFNFysKWeY+ZpVw4PU3xA4b0jC9VC5HeVQcKJrIp/9daM
         XFLg3zHEZwBEB1xy19oLHjr1cMPm9tSPXjiBQ=
MIME-Version: 1.0
In-Reply-To: <20101210143018.29934.11893.stgit@localhost6.localdomain6>
References: <20101210142745.29934.29186.stgit@localhost6.localdomain6>
	<20101210143018.29934.11893.stgit@localhost6.localdomain6>
Date: Tue, 14 Dec 2010 19:01:26 +0900
Message-ID: <AANLkTimeecObDMQMbWzNhL1mE+UT9D3o1WWS4bmxtR4U@mail.gmail.com>
Subject: Re: [PATCH 2/3] Refactor zone_reclaim (v2)
From: Minchan Kim <minchan.kim@gmail.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, npiggin@kernel.dk,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kosaki.motohiro@jp.fujitsu.com, cl@linux.com,
        kamezawa.hiroyu@jp.fujitsu.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Balbir,

On Fri, Dec 10, 2010 at 11:31 PM, Balbir Singh
<balbir@linux.vnet.ibm.com> wrote:
> Move reusable functionality outside of zone_reclaim.
> Make zone_reclaim_unmapped_pages modular
>
> Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
> ---
>  mm/vmscan.c |   35 +++++++++++++++++++++++------------
>  1 files changed, 23 insertions(+), 12 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index e841cae..4e2ad05 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2815,6 +2815,27 @@ static long zone_pagecache_reclaimable(struct zone *zone)
>  }
>
>  /*
> + * Helper function to reclaim unmapped pages, we might add something
> + * similar to this for slab cache as well. Currently this function
> + * is shared with __zone_reclaim()
> + */
> +static inline void
> +zone_reclaim_unmapped_pages(struct zone *zone, struct scan_control *sc,
> +                               unsigned long nr_pages)
> +{
> +       int priority;
> +       /*
> +        * Free memory by calling shrink zone with increasing
> +        * priorities until we have enough memory freed.
> +        */
> +       priority = ZONE_RECLAIM_PRIORITY;
> +       do {
> +               shrink_zone(priority, zone, sc);
> +               priority--;
> +       } while (priority >= 0 && sc->nr_reclaimed < nr_pages);
> +}

As I said previous version, zone_reclaim_unmapped_pages doesn't have
any functions related to reclaim unmapped pages.
The function name is rather strange.
It would be better to add scan_control setup in function inner to
reclaim only unmapped pages.

-- 
Kind regards,
Minchan Kim
