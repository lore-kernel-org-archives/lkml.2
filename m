Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755027Ab1CXGQb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 02:16:31 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36626 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753772Ab1CXGQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 02:16:30 -0400
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
In-Reply-To: <AANLkTik0AUXX2O9-=7dpF2-_CovqXtqenieZA9HRanEc@mail.gmail.com>
References: <20110324143541.CC78.A69D9226@jp.fujitsu.com> <AANLkTik0AUXX2O9-=7dpF2-_CovqXtqenieZA9HRanEc@mail.gmail.com>
Message-Id: <20110324151701.CC7F.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Thu, 24 Mar 2011 15:16:25 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> Thanks for your effort, Kosaki.
> But I still doubt this patch is good.
> 
> This patch makes early oom killing in hibernation as it skip
> all_unreclaimable check.
> Normally,  hibernation needs many memory so page_reclaim pressure
> would be big in small memory system. So I don't like early give up.

Wait. When occur big pressure? hibernation reclaim pressure
(sc->nr_to_recliam) depend on physical memory size. therefore
a pressure seems to don't depend on the size.


> Do you think my patch has a problem? Personally, I think it's very
> simple and clear. :)

To be honest, I dislike following parts. It's madness on madness.

	static bool zone_reclaimable(struct zone *zone)
	{
	        if (zone->all_unreclaimable)
	                return false;
	
	        return zone->pages_scanned < zone_reclaimable_pages(zone) * 6;
	}


The function require a reviewer know 

 o pages_scanned and all_unreclaimable are racy
 o at hibernation, zone->all_unreclaimable can be false negative,
   but can't be false positive.

And, a function comment of all_unreclaimable() says

	 /*
	  * As hibernation is going on, kswapd is freezed so that it can't mark
	  * the zone into all_unreclaimable. It can't handle OOM during hibernation.
	  * So let's check zone's unreclaimable in direct reclaim as well as kswapd.
	  */

But, now it is no longer copy of kswapd algorithm. 

If you strongly prefer this idea even if you hear above explanation,
please consider to add much and much comments. I can't say
current your patch is enough readable/reviewable.

Thanks.


