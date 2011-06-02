Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240Ab1FBSXg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 14:23:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55059 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754112Ab1FBSXf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 14:23:35 -0400
Date: Thu, 2 Jun 2011 20:23:02 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>, Mel Gorman <mel@csn.ul.ie>,
        akpm@linux-foundation.org, Ury Stankevich <urykhy@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: compaction: Abort compaction if too many pages are
 isolated and caller is asynchronous
Message-ID: <20110602182302.GA2802@random.random>
References: <20110530143109.GH19505@random.random>
 <20110530153748.GS5044@csn.ul.ie>
 <20110530165546.GC5118@suse.de>
 <20110530175334.GI19505@random.random>
 <20110531121620.GA3490@barrios-laptop>
 <20110531122437.GJ19505@random.random>
 <20110531133340.GB3490@barrios-laptop>
 <20110531141402.GK19505@random.random>
 <20110531143734.GB13418@barrios-laptop>
 <20110531143830.GC13418@barrios-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110531143830.GC13418@barrios-laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 31, 2011 at 11:38:30PM +0900, Minchan Kim wrote:
> > Yes. You find a new BUG.
> > It seems to be related to this problem but it should be solved although
> 
>  typo : It doesn't seem to be.

This should fix it, but I doubt it matters for this problem.

===
Subject: mm: no page_count without a page pin

From: Andrea Arcangeli <aarcange@redhat.com>

It's unsafe to run page_count during the physical pfn scan.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---

diff --git a/mm/vmscan.c b/mm/vmscan.c
index faa0a08..e41e78a 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1124,8 +1124,18 @@ static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
 					nr_lumpy_dirty++;
 				scan++;
 			} else {
-				/* the page is freed already. */
-				if (!page_count(cursor_page))
+				/*
+				 * We can't use page_count() as that
+				 * requires compound_head and we don't
+				 * have a pin on the page here. If a
+				 * page is tail, we may or may not
+				 * have isolated the head, so assume
+				 * it's not free, it'd be tricky to
+				 * track the head status without a
+				 * page pin.
+				 */
+				if (!PageTail(cursor_page) &&
+				    !atomic_read(&cursor_page->_count))
 					continue;
 				break;
 			}
