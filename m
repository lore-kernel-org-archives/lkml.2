Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186Ab1KOCJF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 21:09:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5493 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753670Ab1KOCJC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 21:09:02 -0500
Date: Tue, 15 Nov 2011 03:08:31 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan.kim@gmail.com>,
        Jan Kara <jack@suse.cz>, Andy Isaacson <adi@hexapodia.org>,
        Johannes Weiner <jweiner@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] mm: Do not stall in synchronous compaction for THP
 allocations
Message-ID: <20111115020831.GF4414@redhat.com>
References: <20111110100616.GD3083@suse.de>
 <20111110142202.GE3083@suse.de>
 <CAEwNFnCRCxrru5rBk7FpypqeL8nD=SY5W3-TaA7Ap5o4CgDSbg@mail.gmail.com>
 <20111110161331.GG3083@suse.de>
 <20111110151211.523fa185.akpm@linux-foundation.org>
 <20111111100156.GI3083@suse.de>
 <20111114160345.01e94987.akpm@linux-foundation.org>
 <20111115020009.GE4414@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111115020009.GE4414@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 15, 2011 at 03:00:09AM +0100, Andrea Arcangeli wrote:
> I didn't fill that gap but I was reading the code again and I don't
> see why we keep retrying for -EAGAIN in the !sync case. Maybe the
> below is good (untested). I doubt it's good to spend cpu to retry the
> trylock or to retry the migrate on a pinned page by O_DIRECT. In fact
> as far as THP success rate is concerned maybe we should "goto out"
> instead of "goto fail" but I didn't change to that as compaction even
> if it fails a subpage may still be successful at creating order
> 1/2/3/4...8 pages. I only avoid 9 loops to retry a trylock or a page
> under O_DIRECT. Maybe that will save a bit of CPU, I doubt it can
> decrease the success rate in any significant way. I'll test it at the
> next build...

At the same time also noticed another minor cleanup (also untested,
will text at next build together with some other stuff).

===
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: [PATCH] compaction: move ISOLATE_CLEAN setting out of
 compaction_migratepages loop

cc->sync and mode cannot change within the loop so move it out.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 mm/compaction.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 899d956..be0be1d 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -291,6 +291,9 @@ static isolate_migrate_t isolate_migratepages(struct zone *zone,
 			return ISOLATE_ABORT;
 	}
 
+	if (!cc->sync)
+		mode |= ISOLATE_CLEAN;
+
 	/* Time to isolate some pages for migration */
 	cond_resched();
 	spin_lock_irq(&zone->lru_lock);
@@ -349,9 +352,6 @@ static isolate_migrate_t isolate_migratepages(struct zone *zone,
 			continue;
 		}
 
-		if (!cc->sync)
-			mode |= ISOLATE_CLEAN;
-
 		/* Try isolate the page */
 		if (__isolate_lru_page(page, mode, 0) != 0)
 			continue;
