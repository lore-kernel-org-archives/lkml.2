Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645Ab0GIKxP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 06:53:15 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:54364 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753687Ab0GIKxO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 06:53:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=aygL7VIFe1fgf5ueSONPIZ7cawP1gRvYs7714ExY85S3vcp2tLdkou++3dqiGRj2fQ
         rVWKDRh1YvsJQut5u7VY3KjLHa4ed363AuBbBFKGjpX7JpRkoms/xMNJVNwAK8X059O0
         vRqVSyJZ2Sfa3prXDQtIrsUOHyQmOMDUgEIAs=
MIME-Version: 1.0
In-Reply-To: <20100709191308.FA25.A69D9226@jp.fujitsu.com>
References: <20100708133152.5e556508.akpm@linux-foundation.org>
	<20100709171850.FA22.A69D9226@jp.fujitsu.com>
	<20100709191308.FA25.A69D9226@jp.fujitsu.com>
Date: Fri, 9 Jul 2010 19:53:13 +0900
Message-ID: <AANLkTins0OMGnj3JmUjIctO0dSnXPsQV1AUsbMEVt2D1@mail.gmail.com>
Subject: Re: [PATCH] vmscan: stop meaningless loop iteration when no 
	reclaimable slab
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@redhat.com>,
       Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 9, 2010 at 7:13 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
> If number of reclaimable slabs are zero, shrink_icache_memory() and
> shrink_dcache_memory() return 0. but strangely shrink_slab() ignore
> it and continue meaningless loop iteration.
>
> This patch fixes it.
>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> ---
>  mm/vmscan.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 0f9f624..8f61adb 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -243,6 +243,11 @@ unsigned long shrink_slab(unsigned long scanned, gfp_t gfp_mask,
>                        int nr_before;
>
>                        nr_before = (*shrinker->shrink)(0, gfp_mask);
> +                       /* no slab objects, no more reclaim. */
> +                       if (nr_before == 0) {
> +                               total_scan = 0;

Why do you reset totoal_scan to 0?
I don't know exact meaning of shrinker->nr.
AFAIU, it can affect next shrinker's total_scan.
Isn't it harmful?

-- 
Kind regards,
Minchan Kim
