Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068Ab1KOCAn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 21:00:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30319 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754819Ab1KOCAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 21:00:42 -0500
Date: Tue, 15 Nov 2011 03:00:09 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan.kim@gmail.com>,
        Jan Kara <jack@suse.cz>, Andy Isaacson <adi@hexapodia.org>,
        Johannes Weiner <jweiner@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] mm: Do not stall in synchronous compaction for THP
 allocations
Message-ID: <20111115020009.GE4414@redhat.com>
References: <20111110100616.GD3083@suse.de>
 <20111110142202.GE3083@suse.de>
 <CAEwNFnCRCxrru5rBk7FpypqeL8nD=SY5W3-TaA7Ap5o4CgDSbg@mail.gmail.com>
 <20111110161331.GG3083@suse.de>
 <20111110151211.523fa185.akpm@linux-foundation.org>
 <20111111100156.GI3083@suse.de>
 <20111114160345.01e94987.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111114160345.01e94987.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 14, 2011 at 04:03:45PM -0800, Andrew Morton wrote:
> On Fri, 11 Nov 2011 10:01:56 +0000
> Mel Gorman <mgorman@suse.de> wrote:
> > A 1000-hour compute job will have its pages collapsed into hugepages by
> > khugepaged so they might not have the huge pages at the very beginning
> > but they get them. With khugepaged in place, there should be no need for
> > an additional tuneable.
> 
> OK...

It's good idea to keep it monitored. But I guess the reduced rate will
only materialize at temporary VM stress times.

> Fair enough.  One slight problem though:
> 
> akpm:/usr/src/25> grep -r thp_collapse_alloc_failed Documentation 
> akpm:/usr/src/25> 

I didn't fill that gap but I was reading the code again and I don't
see why we keep retrying for -EAGAIN in the !sync case. Maybe the
below is good (untested). I doubt it's good to spend cpu to retry the
trylock or to retry the migrate on a pinned page by O_DIRECT. In fact
as far as THP success rate is concerned maybe we should "goto out"
instead of "goto fail" but I didn't change to that as compaction even
if it fails a subpage may still be successful at creating order
1/2/3/4...8 pages. I only avoid 9 loops to retry a trylock or a page
under O_DIRECT. Maybe that will save a bit of CPU, I doubt it can
decrease the success rate in any significant way. I'll test it at the
next build...

====
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: [PATCH] migrate: !sync don't retry

For !sync it's not worth retrying because we won't lock_page even
after the second pass. So make -EAGAIN behave like -EBUSY in the !sync
should be faster. The difference between -EAGAIN and -EBUSY remains as
usual for the sync case, where -EAGAIN will retry, while -EBUSY will
not.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 mm/migrate.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 578e291..7d97a14 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -680,11 +680,7 @@ static int __unmap_and_move(struct page *page, struct page *newpage,
 		 * For !sync, there is no point retrying as the retry loop
 		 * is expected to be too short for PageWriteback to be cleared
 		 */
-		if (!sync) {
-			rc = -EBUSY;
-			goto uncharge;
-		}
-		if (!force)
+		if (!force || !sync)
 			goto uncharge;
 		wait_on_page_writeback(page);
 	}
@@ -794,7 +790,7 @@ static int unmap_and_move(new_page_t get_new_page, unsigned long private,
 
 	rc = __unmap_and_move(page, newpage, force, offlining, sync);
 out:
-	if (rc != -EAGAIN) {
+	if (rc != -EAGAIN || !sync) {
 		/*
 		 * A page that has been migrated has all references
 		 * removed and will be freed. A page that has not been
@@ -874,7 +870,7 @@ static int unmap_and_move_huge_page(new_page_t get_new_page,
 out:
 	unlock_page(hpage);
 
-	if (rc != -EAGAIN) {
+	if (rc != -EAGAIN || !sync) {
 		list_del(&hpage->lru);
 		put_page(hpage);
 	}
@@ -934,11 +930,14 @@ int migrate_pages(struct list_head *from,
 			case -ENOMEM:
 				goto out;
 			case -EAGAIN:
+				if (!sync)
+					goto fail;
 				retry++;
 				break;
 			case 0:
 				break;
 			default:
+			fail:
 				/* Permanent failure */
 				nr_failed++;
 				break;
@@ -981,11 +980,14 @@ int migrate_huge_pages(struct list_head *from,
 			case -ENOMEM:
 				goto out;
 			case -EAGAIN:
+				if (!sync)
+					goto fail;
 				retry++;
 				break;
 			case 0:
 				break;
 			default:
+			fail:
 				/* Permanent failure */
 				nr_failed++;
 				break;
