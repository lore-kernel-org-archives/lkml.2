Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933200Ab1CXHDM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 03:03:12 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50772 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933048Ab1CXHDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 03:03:09 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 1/5] vmscan: remove all_unreclaimable check from direct reclaim path completely
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-mm <linux-mm@kvack.org>, Andrey Vagin <avagin@openvz.org>,
        Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Nick Piggin <npiggin@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>
In-Reply-To: <AANLkTim_C+aKtFAt6XWd9KHHmsA7JBMFWxmScZKRjknk@mail.gmail.com>
References: <20110324151701.CC7F.A69D9226@jp.fujitsu.com> <AANLkTim_C+aKtFAt6XWd9KHHmsA7JBMFWxmScZKRjknk@mail.gmail.com>
Message-Id: <20110324160349.CC83.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Thu, 24 Mar 2011 16:03:03 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Mar 24, 2011 at 3:16 PM, KOSAKI Motohiro
> <kosaki.motohiro@jp.fujitsu.com> wrote:
> > Hi
> >
> >> Thanks for your effort, Kosaki.
> >> But I still doubt this patch is good.
> >>
> >> This patch makes early oom killing in hibernation as it skip
> >> all_unreclaimable check.
> >> Normally,  hibernation needs many memory so page_reclaim pressure
> >> would be big in small memory system. So I don't like early give up.
> >
> > Wait. When occur big pressure? hibernation reclaim pressure
> > (sc->nr_to_recliam) depend on physical memory size. therefore
> > a pressure seems to don't depend on the size.
> 
> It depends on physical memory size and /sys/power/image_size.
> If you want to tune image size bigger, reclaim pressure would be big.

Ok, _If_ I want.
However, I haven't seen desktop people customize it.


> >> Do you think my patch has a problem? Personally, I think it's very
> >> simple and clear. :)
> >
> > To be honest, I dislike following parts. It's madness on madness.
> >
> >        static bool zone_reclaimable(struct zone *zone)
> >        {
> >                if (zone->all_unreclaimable)
> >                        return false;
> >
> >                return zone->pages_scanned < zone_reclaimable_pages(zone) * 6;
> >        }
> >
> >
> > The function require a reviewer know
> >
> >  o pages_scanned and all_unreclaimable are racy
> 
> Yes. That part should be written down of comment.
> 
> >  o at hibernation, zone->all_unreclaimable can be false negative,
> >   but can't be false positive.
> 
> The comment of all_unreclaimable already does explain it well, I think.

Where is?


> > And, a function comment of all_unreclaimable() says
> >
> >         /*
> >          * As hibernation is going on, kswapd is freezed so that it can't mark
> >          * the zone into all_unreclaimable. It can't handle OOM during hibernation.
> >          * So let's check zone's unreclaimable in direct reclaim as well as kswapd.
> >          */
> >
> > But, now it is no longer copy of kswapd algorithm.
> 
> The comment don't say it should be a copy of kswapd.

I meant the comments says

          * So let's check zone's unreclaimable in direct reclaim as well as kswapd.

but now it isn't aswell as kswapd.

I think it's critical important. If people can't understand why the
algorithm was choosed, anyone will break the code again sooner or later.


> > If you strongly prefer this idea even if you hear above explanation,
> > please consider to add much and much comments. I can't say
> > current your patch is enough readable/reviewable.
> 
> My patch isn't a formal patch for merge but just a concept to show.
> If you agree the idea, of course, I will add more concrete comment
> when I send formal patch.
> 
> Before, I would like to get a your agreement. :)
> If you solve my concern(early give up in hibernation) in your patch, I
> don't insist on my patch, either.

Ok. Let's try.

Please concern why priority=0 is not enough. zone_reclaimable_pages(zone) * 6 
is a conservative value of worry about multi thread race. While one task
is reclaiming, others can allocate/free memory concurrently. therefore,
even after priority=0, we have a chance getting reclaimable pages on lru.
But, in hibernation case, almost all tasks was freezed before hibernation
call shrink_all_memory(). therefore, there is no race. priority=0 reclaim
can cover all lru pages.

Is this enough explanation for you?


> 
> Thanks for the comment, Kosaki.




