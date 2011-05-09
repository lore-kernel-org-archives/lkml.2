Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496Ab1EIGyj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 02:54:39 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57330 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114Ab1EIGyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 02:54:37 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: CAI Qian <caiqian@redhat.com>
Subject: Re: [PATCH] mm: check zone->all_unreclaimable in all_unreclaimable()
Cc: kosaki.motohiro@jp.fujitsu.com, avagin@gmail.com,
        Andrey Vagin <avagin@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Minchan Kim <minchan.kim@gmail.com>
In-Reply-To: <1593977838.225469.1304473119444.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
References: <4D72580D.4000208@gmail.com> <1593977838.225469.1304473119444.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
Message-Id: <20110509155612.1648.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Mon,  9 May 2011 15:54:34 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> 
> ----- Original Message -----
> > On 03/05/2011 06:20 PM, Minchan Kim wrote:
> > > On Sat, Mar 05, 2011 at 02:44:16PM +0300, Andrey Vagin wrote:
> > >> Check zone->all_unreclaimable in all_unreclaimable(), otherwise the
> > >> kernel may hang up, because shrink_zones() will do nothing, but
> > >> all_unreclaimable() will say, that zone has reclaimable pages.
> > >>
> > >> do_try_to_free_pages()
> > >> 	shrink_zones()
> > >> 		 for_each_zone
> > >> 			if (zone->all_unreclaimable)
> > >> 				continue
> > >> 	if !all_unreclaimable(zonelist, sc)
> > >> 		return 1
> > >>
> > >> __alloc_pages_slowpath()
> > >> retry:
> > >> 	did_some_progress = do_try_to_free_pages(page)
> > >> 	...
> > >> 	if (!page&& did_some_progress)
> > >> 		retry;
> > >>
> > >> Signed-off-by: Andrey Vagin<avagin@openvz.org>
> > >> ---
> > >>   mm/vmscan.c | 2 ++
> > >>   1 files changed, 2 insertions(+), 0 deletions(-)
> > >>
> > >> diff --git a/mm/vmscan.c b/mm/vmscan.c
> > >> index 6771ea7..1c056f7 100644
> > >> --- a/mm/vmscan.c
> > >> +++ b/mm/vmscan.c
> > >> @@ -2002,6 +2002,8 @@ static bool all_unreclaimable(struct zonelist
> > >> *zonelist,
> > >>
> > >>   	for_each_zone_zonelist_nodemask(zone, z, zonelist,
> > >>   			gfp_zone(sc->gfp_mask), sc->nodemask) {
> > >> + if (zone->all_unreclaimable)
> > >> + continue;
> > >>   		if (!populated_zone(zone))
> > >>   			continue;
> > >>   		if (!cpuset_zone_allowed_hardwall(zone, GFP_KERNEL))
> > >
> > > zone_reclaimable checks it. Isn't it enough?
> > I sent one more patch [PATCH] mm: skip zombie in OOM-killer.
> > This two patches are enough.
> > > Does the hang up really happen or see it by code review?
> > Yes. You can reproduce it for help the attached python program. It's
> > not
> > very clever:)
> > It make the following actions in loop:
> > 1. fork
> > 2. mmap
> > 3. touch memory
> > 4. read memory
> > 5. munmmap
> > 
> > >> --
> > >> 1.7.1
> I have tested this for the latest mainline kernel using the reproducer
> attached, the system just hung or deadlock after oom. The whole oom
> trace is here.
> http://people.redhat.com/qcai/oom.log
> 
> Did I miss anything?

Can you please try commit 929bea7c714220fc76ce3f75bef9056477c28e74?




