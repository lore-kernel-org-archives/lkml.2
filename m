Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932493Ab1LEQOp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 11:14:45 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38282 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932447Ab1LEQOo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 11:14:44 -0500
Date: Mon, 5 Dec 2011 17:14:43 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Wang Sheng-Hui <shhuiw@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Question about __zone_watermark_ok: why there is a "+ 1" in
 computing free_pages?
Message-ID: <20111205161443.GA20663@tiehlicka.suse.cz>
References: <CAKXJSOHu+sQ1NeMsRvFyp2GYoB6g+50boUu=-QvbxxjcqgOAVA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKXJSOHu+sQ1NeMsRvFyp2GYoB6g+50boUu=-QvbxxjcqgOAVA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 25-11-11 09:21:35, Wang Sheng-Hui wrote:
> In line 1459, we have "free_pages -= (1 << order) + 1;".
> Suppose allocating one 0-order page, here we'll get
>     free_pages -= 1 + 1
> I wonder why there is a "+ 1"?

Good spot. Check the patch bellow.
---
>From 38a1cf351b111e8791d2db538c8b0b912f5df8b8 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Mon, 5 Dec 2011 17:04:23 +0100
Subject: [PATCH] mm: fix off-by-two in __zone_watermark_ok

88f5acf8 [mm: page allocator: adjust the per-cpu counter threshold when
memory is low] changed the form how free_pages is calculated but it
forgot that we used to do free_pages - ((1 << order) - 1) so we ended up
with off-by-two when calculating free_pages.

Spotted-by: Wang Sheng-Hui <shhuiw@gmail.com>
Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 mm/page_alloc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 9dd443d..8a2f1b6 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1457,7 +1457,7 @@ static bool __zone_watermark_ok(struct zone *z, int order, unsigned long mark,
 	long min = mark;
 	int o;
 
-	free_pages -= (1 << order) + 1;
+	free_pages -= (1 << order) - 1;
 	if (alloc_flags & ALLOC_HIGH)
 		min -= min / 2;
 	if (alloc_flags & ALLOC_HARDER)
-- 
1.7.7.3

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
