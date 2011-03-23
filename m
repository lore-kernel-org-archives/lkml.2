Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583Ab1CWHr4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 03:47:56 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55386 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981Ab1CWHrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 03:47:55 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 23 Mar 2011 16:41:22 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-mm <linux-mm@kvack.org>, Andrey Vagin <avagin@openvz.org>,
        Hugh Dickins <hughd@google.com>, Nick Piggin <npiggin@kernel.dk>,
        Minchan Kim <minchan.kim@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 1/5] vmscan: remove all_unreclaimable check from direct
 reclaim path completely
Message-Id: <20110323164122.ea25bdf0.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110322200523.B061.A69D9226@jp.fujitsu.com>
References: <20110315153801.3526.A69D9226@jp.fujitsu.com>
	<20110322194721.B05E.A69D9226@jp.fujitsu.com>
	<20110322200523.B061.A69D9226@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Mar 2011 20:05:55 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> all_unreclaimable check in direct reclaim has been introduced at 2.6.19
> by following commit.
> 
> 	2006 Sep 25; commit 408d8544; oom: use unreclaimable info
> 
> And it went through strange history. firstly, following commit broke
> the logic unintentionally.
> 
> 	2008 Apr 29; commit a41f24ea; page allocator: smarter retry of
> 				      costly-order allocations
> 
> Two years later, I've found obvious meaningless code fragment and
> restored original intention by following commit.
> 
> 	2010 Jun 04; commit bb21c7ce; vmscan: fix do_try_to_free_pages()
> 				      return value when priority==0
> 
> But, the logic didn't works when 32bit highmem system goes hibernation
> and Minchan slightly changed the algorithm and fixed it .
> 
> 	2010 Sep 22: commit d1908362: vmscan: check all_unreclaimable
> 				      in direct reclaim path
> 
> But, recently, Andrey Vagin found the new corner case. Look,
> 
> 	struct zone {
> 	  ..
> 	        int                     all_unreclaimable;
> 	  ..
> 	        unsigned long           pages_scanned;
> 	  ..
> 	}
> 
> zone->all_unreclaimable and zone->pages_scanned are neigher atomic
> variables nor protected by lock. Therefore a zone can become a state
> of zone->page_scanned=0 and zone->all_unreclaimable=1. In this case,
> current all_unreclaimable() return false even though
> zone->all_unreclaimabe=1.
> 
> Is this ignorable minor issue? No. Unfortunatelly, x86 has very
> small dma zone and it become zone->all_unreclamble=1 easily. and
> if it becase all_unreclaimable, it never return all_unreclaimable=0
> beucase it typicall don't have reclaimable pages.
> 
> Eventually, oom-killer never works on such systems.  Let's remove
> this problematic logic completely.
> 
> Reported-by: Andrey Vagin <avagin@openvz.org>
> Cc: Nick Piggin <npiggin@kernel.dk>
> Cc: Minchan Kim <minchan.kim@gmail.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Rik van Riel <riel@redhat.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

IIUC, I saw the pehnomenon which you pointed out, as
 - all zone->all_unreclaimable = yes
 - zone_reclaimable() returns true
 - no pgscan proceeds.

on a swapless system. So, I'd like to vote for this patch.

But hmm...what happens all of pages are isolated or locked and now under freeing ?
I think we should have alternative safe-guard logic for avoiding to call
oom-killer. Hmm.

Thanks,
-Kame

