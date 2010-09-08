Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758398Ab0IHHnN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 03:43:13 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:53781 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758239Ab0IHHnL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 03:43:11 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 3/3] mm: page allocator: Drain per-cpu lists after direct reclaim allocation fails
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel List <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1283504926-2120-4-git-send-email-mel@csn.ul.ie>
References: <1283504926-2120-1-git-send-email-mel@csn.ul.ie> <1283504926-2120-4-git-send-email-mel@csn.ul.ie>
Message-Id: <20100908163956.C930.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed,  8 Sep 2010 16:43:03 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	/*
> +	 * If an allocation failed after direct reclaim, it could be because
> +	 * pages are pinned on the per-cpu lists. Drain them and try again
> +	 */
> +	if (!page && !drained) {
> +		drain_all_pages();
> +		drained = true;
> +		goto retry;
> +	}

nit: when slub, get_page_from_freelist() failure is frequently happen
than slab because slub try to allocate high order page at first.
So, I guess we have to avoid drain_all_pages() if __GFP_NORETRY is passed.




>From 9209ceb1d48446b031576ba9360036ddabc1a0e5 Mon Sep 17 00:00:00 2001
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Fri, 10 Sep 2010 03:29:05 +0900
Subject: [PATCH] mm: don't call drain_all_pages() when __GFP_NORETRY

SLUB try to allocate high order pages at first. therefore page allocator
eventually call drain_all_pages() frequently. We don't hope IPI storm.
Thus, we don't call drain_all_pages() when caller passed __GFP_NORETRY.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/page_alloc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 8587c10..b9eafb1 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1878,7 +1878,7 @@ retry:
 	 * If an allocation failed after direct reclaim, it could be because
 	 * pages are pinned on the per-cpu lists. Drain them and try again
 	 */
-	if (!page && !drained) {
+	if (!page && !drained && !(gfp_mask & __GFP_NORETRY)) {
 		drain_all_pages();
 		drained = true;
 		goto retry;
-- 
1.6.5.2



