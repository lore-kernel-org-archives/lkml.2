Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089Ab0LAHyL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 02:54:11 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59832 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931Ab0LAHyJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 02:54:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fXZ+nEzW4Np4qdGxBfAgTMJFnaY8AjAZBL0nn/Z5PItrMsuL7ajwUbCG0cu602lp7M
         DsMa4Hw7llKHdmZLw/heekekOZkLBH7jlIOBMjYJBEx9ReKz/6q7QQGTyk9kx1uiikKI
         +X4BD5J5+AR5LHUdDhz4DcdlFNG0g+R4m1qVY=
MIME-Version: 1.0
In-Reply-To: <20101130101520.17475.79978.stgit@localhost6.localdomain6>
References: <20101130101126.17475.18729.stgit@localhost6.localdomain6>
	<20101130101520.17475.79978.stgit@localhost6.localdomain6>
Date: Wed, 1 Dec 2010 16:54:08 +0900
Message-ID: <AANLkTik59zL97EqpPSNiy122YFwXqWyRqAkMJDjRtfRE@mail.gmail.com>
Subject: Re: [PATCH 2/3] Refactor zone_reclaim
From: Minchan Kim <minchan.kim@gmail.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, Christoph Lameter <cl@linux.com>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Balbir,

On Tue, Nov 30, 2010 at 7:15 PM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> Refactor zone_reclaim, move reusable functionality outside
> of zone_reclaim. Make zone_reclaim_unmapped_pages modular
>
> Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
> ---
>  mm/vmscan.c |   35 +++++++++++++++++++++++------------
>  1 files changed, 23 insertions(+), 12 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 325443a..0ac444f 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2719,6 +2719,27 @@ static long zone_pagecache_reclaimable(struct zone *zone)
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
> +

I don't see any specific logic about naming
"zone_reclaim_unmapped_pages" in your function.
Maybe, caller of this function have to handle sc->may_unmap. So, this
function's naming
is not good.
As I see your logic, the function name would be just "zone_reclaim_pages"
If you want to name it with zone_reclaim_unmapped_pages, it could be
better with setting sc->may_unmap in this function.


-- 
Kind regards,
Minchan Kim
