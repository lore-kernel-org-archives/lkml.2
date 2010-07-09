Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771Ab0GILEn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 07:04:43 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:55388 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755302Ab0GILEm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 07:04:42 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH] vmscan: stop meaningless loop iteration when no  reclaimable slab
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@redhat.com>,
       Johannes Weiner <hannes@cmpxchg.org>
In-Reply-To: <AANLkTins0OMGnj3JmUjIctO0dSnXPsQV1AUsbMEVt2D1@mail.gmail.com>
References: <20100709191308.FA25.A69D9226@jp.fujitsu.com> <AANLkTins0OMGnj3JmUjIctO0dSnXPsQV1AUsbMEVt2D1@mail.gmail.com>
Message-Id: <20100709195625.FA28.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri,  9 Jul 2010 20:04:36 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, Jul 9, 2010 at 7:13 PM, KOSAKI Motohiro
> <kosaki.motohiro@jp.fujitsu.com> wrote:
> > If number of reclaimable slabs are zero, shrink_icache_memory() and
> > shrink_dcache_memory() return 0. but strangely shrink_slab() ignore
> > it and continue meaningless loop iteration.
> >
> > This patch fixes it.
> >
> > Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > ---
> >  mm/vmscan.c |    5 +++++
> >  1 files changed, 5 insertions(+), 0 deletions(-)
> >
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 0f9f624..8f61adb 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -243,6 +243,11 @@ unsigned long shrink_slab(unsigned long scanned, gfp_t gfp_mask,
> >                        int nr_before;
> >
> >                        nr_before = (*shrinker->shrink)(0, gfp_mask);
> > +                       /* no slab objects, no more reclaim. */
> > +                       if (nr_before == 0) {
> > +                               total_scan = 0;
> 
> Why do you reset totoal_scan to 0?

If shab objects are zero, we don't need more reclaim. 

> I don't know exact meaning of shrinker->nr.

similar meaning of reclaim_stat->nr_saved_scan.
If total_scan can't divide SHRINK_BATCH(128), saving remainder and using at next shrink_slab().

> AFAIU, it can affect next shrinker's total_scan.
> Isn't it harmful?

No.  This loop is

                total_scan = shrinker->nr;		/* Reset and init total_scan */
                shrinker->nr = 0;

                while (total_scan >= SHRINK_BATCH) {
                        nr_before = (*shrinker->shrink)(0, gfp_mask);
                        /* no slab objects, no more reclaim. */
                        if (nr_before == 0) {
                                total_scan = 0;
                                break;
                        }
                        shrink_ret = (*shrinker->shrink)(this_scan, gfp_mask);
                        if (shrink_ret == -1)
                                break;
                        if (shrink_ret < nr_before)
                                ret += nr_before - shrink_ret;
                        total_scan -= this_scan;
                }

                shrinker->nr += total_scan;		/* save remainder #of-scan */



