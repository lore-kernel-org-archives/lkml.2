Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341Ab2FNIyj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 04:54:39 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:39131 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987Ab2FNIyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 04:54:37 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FD9A625.1050300@jp.fujitsu.com>
Date: Thu, 14 Jun 2012 17:51:49 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: kosaki.motohiro@gmail.com
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Nick Piggin <npiggin@gmail.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mel@csn.ul.ie>,
        Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [resend][PATCH] mm, vmscan: fix do_try_to_free_pages() livelock
References: <1339661592-3915-1-git-send-email-kosaki.motohiro@gmail.com>
In-Reply-To: <1339661592-3915-1-git-send-email-kosaki.motohiro@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/06/14 17:13), kosaki.motohiro@gmail.com wrote:
> From: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>
> 
> Currently, do_try_to_free_pages() can enter livelock. Because of,
> now vmscan has two conflicted policies.
> 
> 1) kswapd sleep when it couldn't reclaim any page when reaching
>     priority 0. This is because to avoid kswapd() infinite
>     loop. That said, kswapd assume direct reclaim makes enough
>     free pages to use either regular page reclaim or oom-killer.
>     This logic makes kswapd ->  direct-reclaim dependency.
> 2) direct reclaim continue to reclaim without oom-killer until
>     kswapd turn on zone->all_unreclaimble. This is because
>     to avoid too early oom-kill.
>     This logic makes direct-reclaim ->  kswapd dependency.
> 
> In worst case, direct-reclaim may continue to page reclaim forever
> when kswapd sleeps forever.
> 
> We can't turn on zone->all_unreclaimable from direct reclaim path
> because direct reclaim path don't take any lock and this way is racy.
> 
> Thus this patch removes zone->all_unreclaimable field completely and
> recalculates zone reclaimable state every time.
> 
> Note: we can't take the idea that direct-reclaim see zone->pages_scanned
> directly and kswapd continue to use zone->all_unreclaimable. Because, it
> is racy. commit 929bea7c71 (vmscan: all_unreclaimable() use
> zone->all_unreclaimable as a name) describes the detail.
> 
> Reported-by: Aaditya Kumar<aaditya.kumar.30@gmail.com>
> Reported-by: Ying Han<yinghan@google.com>
> Cc: Nick Piggin<npiggin@gmail.com>
> Acked-by: Rik van Riel<riel@redhat.com>
> Cc: Michal Hocko<mhocko@suse.cz>
> Cc: Johannes Weiner<hannes@cmpxchg.org>
> Cc: Mel Gorman<mel@csn.ul.ie>
> Cc: KAMEZAWA Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Minchan Kim<minchan.kim@gmail.com>
> Signed-off-by: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>

I like this.
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

