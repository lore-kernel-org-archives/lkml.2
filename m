Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745Ab1EIIsR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 04:48:17 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:40775 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959Ab1EIIsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 04:48:16 -0400
Date: Mon, 9 May 2011 04:47:46 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: avagin@gmail.com, Andrey Vagin <avagin@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Minchan Kim <minchan.kim@gmail.com>
Message-ID: <1491537913.283996.1304930866703.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
In-Reply-To: <20110509155612.1648.A69D9226@jp.fujitsu.com>
Subject: Re: [PATCH] mm: check zone->all_unreclaimable in
 all_unreclaimable()
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.5.71]
X-Mailer: Zimbra 6.0.9_GA_2686 (ZimbraWebClient - FF3.0 (Linux)/6.0.9_GA_2686)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----- Original Message -----
> >
> >
> > ----- Original Message -----
> > > On 03/05/2011 06:20 PM, Minchan Kim wrote:
> > > > On Sat, Mar 05, 2011 at 02:44:16PM +0300, Andrey Vagin wrote:
> > > >> Check zone->all_unreclaimable in all_unreclaimable(), otherwise
> > > >> the
> > > >> kernel may hang up, because shrink_zones() will do nothing, but
> > > >> all_unreclaimable() will say, that zone has reclaimable pages.
> > > >>
> > > >> do_try_to_free_pages()
> > > >> 	shrink_zones()
> > > >> 		 for_each_zone
> > > >> 			if (zone->all_unreclaimable)
> > > >> 				continue
> > > >> 	if !all_unreclaimable(zonelist, sc)
> > > >> 		return 1
> > > >>
> > > >> __alloc_pages_slowpath()
> > > >> retry:
> > > >> 	did_some_progress = do_try_to_free_pages(page)
> > > >> 	...
> > > >> 	if (!page&& did_some_progress)
> > > >> 		retry;
> > > >>
> > > >> Signed-off-by: Andrey Vagin<avagin@openvz.org>
> > > >> ---
> > > >>   mm/vmscan.c | 2 ++
> > > >>   1 files changed, 2 insertions(+), 0 deletions(-)
> > > >>
> > > >> diff --git a/mm/vmscan.c b/mm/vmscan.c
> > > >> index 6771ea7..1c056f7 100644
> > > >> --- a/mm/vmscan.c
> > > >> +++ b/mm/vmscan.c
> > > >> @@ -2002,6 +2002,8 @@ static bool all_unreclaimable(struct
> > > >> zonelist
> > > >> *zonelist,
> > > >>
> > > >>   	for_each_zone_zonelist_nodemask(zone, z, zonelist,
> > > >>   			gfp_zone(sc->gfp_mask), sc->nodemask) {
> > > >> + if (zone->all_unreclaimable)
> > > >> + continue;
> > > >>   		if (!populated_zone(zone))
> > > >>   			continue;
> > > >>   		if (!cpuset_zone_allowed_hardwall(zone, GFP_KERNEL))
> > > >
> > > > zone_reclaimable checks it. Isn't it enough?
> > > I sent one more patch [PATCH] mm: skip zombie in OOM-killer.
> > > This two patches are enough.
> > > > Does the hang up really happen or see it by code review?
> > > Yes. You can reproduce it for help the attached python program.
> > > It's
> > > not
> > > very clever:)
> > > It make the following actions in loop:
> > > 1. fork
> > > 2. mmap
> > > 3. touch memory
> > > 4. read memory
> > > 5. munmmap
> > >
> > > >> --
> > > >> 1.7.1
> > I have tested this for the latest mainline kernel using the
> > reproducer
> > attached, the system just hung or deadlock after oom. The whole oom
> > trace is here.
> > http://people.redhat.com/qcai/oom.log
> >
> > Did I miss anything?
> 
> Can you please try commit 929bea7c714220fc76ce3f75bef9056477c28e74?
As I have mentioned that I have tested the latest mainline which have
already included that fix. Also, does this problem only for x86? The
testing was done using x86_64. Not sure if that would be a problem.
