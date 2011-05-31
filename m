Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089Ab1EaMQ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 08:16:29 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:55452 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614Ab1EaMQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 08:16:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=A0yU+m/mhjeGb3HMQ4U9GRCS47up1snI9VyAgXetAK2d2ImpDaWeEUHJM0LqWRs4iX
         UHdL4c93mxIwcRITJxsvP4u0LYWHmegKxIupfLh7ggs4kqusKW5ChqDy5c3YbtvBMJfk
         ls0gk3McNqMh0IHr5nUXpi2CxXUUSQQiioiX0=
Date: Tue, 31 May 2011 21:16:20 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>, Mel Gorman <mel@csn.ul.ie>,
        akpm@linux-foundation.org, Ury Stankevich <urykhy@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, stable@kernel.org
Subject: Re: [PATCH] mm: compaction: Abort compaction if too many pages are
 isolated and caller is asynchronous
Message-ID: <20110531121620.GA3490@barrios-laptop>
References: <20110530131300.GQ5044@csn.ul.ie>
 <20110530143109.GH19505@random.random>
 <20110530153748.GS5044@csn.ul.ie>
 <20110530165546.GC5118@suse.de>
 <20110530175334.GI19505@random.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110530175334.GI19505@random.random>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrea,

On Mon, May 30, 2011 at 07:53:34PM +0200, Andrea Arcangeli wrote:
> On Mon, May 30, 2011 at 05:55:46PM +0100, Mel Gorman wrote:
> > Even with drift issues, -1 there should be "impossible". Assuming this
> > is a zoneinfo file, that figure is based on global_page_state() which
> > looks like
> 
> The two cases reproducing this long hang in D state, had from SMP=n
> PREEMPT=y. Clearly not common config these days. Also it didn't seem
> apparent that any task was running in a code path that kept pages
> isolated.
> 
> > unsigned long, and callers are using unsigned long, is there any
> > possibility the "if (x < 0)" is being optimised out? If you aware
> 
> It was eliminated by cpp.
> 
> > of users reporting this problem (like the users in thread "iotop:
> > khugepaged at 99.99% (2.6.38.3)"), do you know if they had a particular
> > compiler in common?
> 
> I had no reason to worry about the compiler yet but that's always good
> idea to keep in mind. The thread were the bug is reported is the
> "iotop" one you mentioned, and there's a tarball attached to one of
> the last emails of the thread with the debug data I grepped. It was
> /proc/zoneinfo file yes. That's the file I asked when I noticed
> something had to be wrong with too_many_isolated and I expected either
> nr_isolated or nr_inactive going wrong, it turned out it was
> nr_isolated (apparently, I don't have full picture on the problem
> yet). I added you in CC to a few emails but you weren't in all
> replies.
> 
> The debug data you can find on lkml in this email: Message-Id:
> <201105232005.56840.johannes.hirte@fem.tu-ilmenau.de>.
> 
> The other relevant sysrq+t here http://pastebin.com/raw.php?i=VG28YRbi
> 
> better save the latter (I did) as I'm worried it has a timeout on it.
> 
> Your patch was for reports with CONFIG_SMP=y? I'd prefer to clear out
> this error before improving the too_many_isolated, in fact while
> reviewing this code I was not impressed by too_many_isolated. For
> vmscan.c if there's an huge nr_active* list and a tiny nr_inactive
> (like after a truncate of filebacked pages or munmap of anon memory)
> there's no reason to stall, it's better to go ahead and let it refile
> more active pages. The too_many_isolated in compaction.c looks a whole
> lot better than the vmscan.c one as that takes into account the active
> pages too... But I refrained to make any change in this area as I
> don't think the bug is in too_many_isolated itself.
> 
> I noticed the count[] array is unsigned int, but it looks ok
> (especially for 32bit ;) because the isolation is limited.
> 
> Both bugs were reported on 32bit x86 UP builds with PREEMPT=y. The
> stat accounting seem to use atomics on UP so irqs on off or
> PREEMPT=y/n shouldn't matter if the increment is 1 insn long (plus no
> irq code should ever mess with nr_isolated)... If it wasn't atomic and
> irqs or preempt aren't disabled it could be preempt. To avoid
> confusion: it's not proven that PREEMPT is related, it may be an
> accident both .config had it on. I'm also unsure why it moves from
> -1,0,1 I wouldn't expect a single page to be isolated like -1 pages to
> be isolated, it just looks weird...

I am not sure this is related to the problem you have seen.
If he used hwpoison by madivse, it is possible.
Anyway, we can see negative value by count mismatch in UP build.
Let's fix it.

>From 1d3ebce2e8aa79dcc912da16b7a8d0611b6f9f1a Mon Sep 17 00:00:00 2001
From: Minchan Kim <minchan.kim@gmail.com>
Date: Tue, 31 May 2011 21:11:58 +0900
Subject: [PATCH] Fix page isolated count mismatch

If migration is failed, normally we call putback_lru_pages which
decreases NR_ISOLATE_[ANON|FILE].
It means we should increase NR_ISOLATE_[ANON|FILE] before calling
putback_lru_pages. But soft_offline_page dosn't it.

It can make NR_ISOLATE_[ANON|FILE] with negative value and in UP build,
zone_page_state will say huge isolated pages so too_many_isolated
functions be deceived completely. At last, some process stuck in D state
as it expect while loop ending with congestion_wait.
But it's never ending story.

If it is right, it would be -stable stuff.

Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
---
 mm/memory-failure.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 5c8f7e0..eac0ba5 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -52,6 +52,7 @@
 #include <linux/swapops.h>
 #include <linux/hugetlb.h>
 #include <linux/memory_hotplug.h>
+#include <linux/mm_inline.h>
 #include "internal.h"
 
 int sysctl_memory_failure_early_kill __read_mostly = 0;
@@ -1468,7 +1469,8 @@ int soft_offline_page(struct page *page, int flags)
 	put_page(page);
 	if (!ret) {
 		LIST_HEAD(pagelist);
-
+		inc_zone_page_state(page, NR_ISOLATED_ANON +
+					    page_is_file_cache(page));
 		list_add(&page->lru, &pagelist);
 		ret = migrate_pages(&pagelist, new_page, MPOL_MF_MOVE_ALL,
 								0, true);
-- 
1.7.0.4

-- 
Kind regards
Minchan Kim
