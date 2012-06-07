Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751299Ab2FGEM7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 00:12:59 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:54648 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705Ab2FGEM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 00:12:58 -0400
X-AuditID: 9c93016f-b7c3cae000001954-73-4fd02a47558c
Message-ID: <4FD02A66.6030705@kernel.org>
Date: Thu, 07 Jun 2012 13:13:26 +0900
From: Minchan Kim <minchan@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.mm,gmane.linux.kernel
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
CC: KOSAKI Motohiro <kosaki.motohiro@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <amwang@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: [PATCH v9] mm: compaction: handle incorrect MIGRATE_UNMOVABLE
 type pageblocks
References: <201206041543.56917.b.zolnierkie@samsung.com> <4FCD6806.7070609@kernel.org> <4FCD713D.3020100@kernel.org> <201206061206.12759.b.zolnierkie@samsung.com>
In-Reply-To: <201206061206.12759.b.zolnierkie@samsung.com>
Content-Type: multipart/mixed;
 boundary="------------040400010104090007070307"
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040400010104090007070307
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

On 06/06/2012 07:06 PM, Bartlomiej Zolnierkiewicz wrote:

> On Tuesday 05 June 2012 04:38:53 Minchan Kim wrote:
>> On 06/05/2012 10:59 AM, Minchan Kim wrote:
>>
>>> On 06/05/2012 05:22 AM, KOSAKI Motohiro wrote:
>>>
>>>>> +/*
>>>>> + * Returns true if MIGRATE_UNMOVABLE pageblock can be successfully
>>>>> + * converted to MIGRATE_MOVABLE type, false otherwise.
>>>>> + */
>>>>> +static bool can_rescue_unmovable_pageblock(struct page *page, bool
>>>>> locked)
>>>>> +{
>>>>> +    unsigned long pfn, start_pfn, end_pfn;
>>>>> +    struct page *start_page, *end_page, *cursor_page;
>>>>> +
>>>>> +    pfn = page_to_pfn(page);
>>>>> +    start_pfn = pfn&  ~(pageblock_nr_pages - 1);
>>>>> +    end_pfn = start_pfn + pageblock_nr_pages - 1;
>>>>> +
>>>>> +    start_page = pfn_to_page(start_pfn);
>>>>> +    end_page = pfn_to_page(end_pfn);
>>>>> +
>>>>> +    for (cursor_page = start_page, pfn = start_pfn; cursor_page<=
>>>>> end_page;
>>>>> +        pfn++, cursor_page++) {
>>>>> +        struct zone *zone = page_zone(start_page);
>>>>> +        unsigned long flags;
>>>>> +
>>>>> +        if (!pfn_valid_within(pfn))
>>>>> +            continue;
>>>>> +
>>>>> +        /* Do not deal with pageblocks that overlap zones */
>>>>> +        if (page_zone(cursor_page) != zone)
>>>>> +            return false;
>>>>> +
>>>>> +        if (!locked)
>>>>> +            spin_lock_irqsave(&zone->lock, flags);
>>>>> +
>>>>> +        if (PageBuddy(cursor_page)) {
>>>>> +            int order = page_order(cursor_page);
>>>>>
>>>>> -/* Returns true if the page is within a block suitable for migration
>>>>> to */
>>>>> -static bool suitable_migration_target(struct page *page)
>>>>> +            pfn += (1<<  order) - 1;
>>>>> +            cursor_page += (1<<  order) - 1;
>>>>> +
>>>>> +            if (!locked)
>>>>> +                spin_unlock_irqrestore(&zone->lock, flags);
>>>>> +            continue;
>>>>> +        } else if (page_count(cursor_page) == 0 ||
>>>>> +               PageLRU(cursor_page)) {
>>>>> +            if (!locked)
>>>>> +                spin_unlock_irqrestore(&zone->lock, flags);
>>>>> +            continue;
>>>>> +        }
>>>>> +
>>>>> +        if (!locked)
>>>>> +            spin_unlock_irqrestore(&zone->lock, flags);
>>>>> +
>>>>> +        return false;
>>>>> +    }
>>>>> +
>>>>> +    return true;
>>>>> +}
>>>>
>>>> Minchan, are you interest this patch? If yes, can you please rewrite it?
>>>
>>>
>>> Can do it but I want to give credit to Bartlomiej.
>>> Bartlomiej, if you like my patch, could you resend it as formal patch after you do broad testing?
> 
> Sure.


Please use attached one instead of buggy old version. :(
This patch fix THP racing, remove unnecessary lock and add more comment.

> 
>>>> This one are
>>>> not fixed our pointed issue and can_rescue_unmovable_pageblock() still
>>>> has plenty bugs.
>>>> We can't ack it.
>>>>
>>>
>>>
>>> Frankly speaking, I don't want to merge it without any data which prove it's really good for real practice.
>>>
>>> When the patch firstly was submitted, it wasn't complicated so I was okay at that time but it has been complicated
>>> than my expectation. So if Andrew might pass the decision to me, I'm totally NACK if author doesn't provide
>>> any real data or VOC of some client.
> 
> I found this issue by accident while testing compaction code so unfortunately
> I don't have any real bugreport to back it up.  It is just a corner case which
> is more likely to happen in situation where there is rather small number of
> pageblocks and quite heavy kernel memory allocation/freeing activity in
> kernel going on.  I would presume that the issue can happen on some embedded
> configurations but they are not your typical machine and it is not likely
> to see a real bugreport for it.
> 
> I'm also quite unhappy with the increasing complexity of what seemed as
> a quite simple fix initially and I tend to agree that the patch may stay
> out-of-tree until there is a more proven need for it (maybe with documenting
> the issue in the code for the time being).  Still, I would like to have
> all outstanding issues fixed so I can merge the patch locally (and to -mm
> if Andrew agrees) and just wait to see if the patch is ever needed in
> practice.
> 
> I've attached the code that I use to trigger the issue at the bottom of this
> mail so people can reproduce the problem and see for themselves whether it
> is worth to fix it or not.
> 
>>> 1) Any comment?
>>>
>>> Anyway, I fixed some bugs and clean up something I found during review.
> 
> Thanks for doing this.
> 
>>> Minor thing.
>>> 1. change smt_result naming - I never like such long non-consistent naming. How about this?
>>> 2. fix can_rescue_unmovable_pageblock 
>>>    2.1 pfn valid check for page_zone
>>>
>>> Major thing.
>>>
>>>    2.2 add lru_lock for stablizing PageLRU
>>>        If we don't hold lru_lock, there is possibility that unmovable(non-LRU) page can put in movable pageblock.
>>>        It can make compaction/CMA's regression. But there is a concern about deadlock between lru_lock and lock.
>>>        As I look the code, I can't find allocation trial with holding lru_lock so it might be safe(but not sure,
>>>        I didn't test it. It need more careful review/testing) but it makes new locking dependency(not sure, too.
>>>        We already made such rule but I didn't know that until now ;-) ) Why I thought so is we can allocate
>>>        GFP_ATOMIC with holding lru_lock, logically which might be crazy idea.
>>>
>>>    2.3 remove zone->lock in first phase.
>>>        We do rescue unmovable pageblock by 2-phase. In first-phase, we just peek pages so we don't need locking.
>>>        If we see non-stablizing value, it would be caught by 2-phase with needed lock or 
>>>        can_rescue_unmovable_pageblock can return out of loop by stale page_order(cursor_page).
>>>        It couldn't make unmovable pageblock to movable but we can do it next time, again.
>>>        It's not critical.
>>>
>>> 2) Any comment?
>>>
>>> Now I can't inline the code so sorry but attach patch.
>>> It's not a formal patch/never tested.
>>>
>>
>>
>> Attached patch has a BUG in can_rescue_unmovable_pageblock.
>> Resend. I hope it is fixed.
> 
> @@ -399,10 +399,14 @@
>  		} else if (page_count(cursor_page) == 0) {
>  			continue;
>  		} else if (PageLRU(cursor_page)) {
> -			if (!lru_locked && need_lrulock) {
> +			if (!need_lrulock)
> +				continue;
> +			else if (lru_locked)
> +				continue;
> +			else {
>  				spin_lock(&zone->lru_lock);
>  				lru_locked = true;
> -				if (PageLRU(cursor_page))
> +				if (PageLRU(page))
>  					continue;
>  			}
>  		}
> 
> Could you please explain why do we need to check page and not cursor_page
> here?


Slaps self.
That's because I was brain-dead typo.

Please consider attached one and of course, it's totally untested. :(

> 
> Best regards,
> --
> Bartlomiej Zolnierkiewicz
> Samsung Poland R&D Center



> -- 

Kind regards,
Minchan Kim

--------------040400010104090007070307
Content-Type: text/x-patch;
 name="0001-1.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-1.patch"

>From ad4f07fe0da971fe8ef841aa4a2a5bc107fa8548 Mon Sep 17 00:00:00 2001
From: Minchan Kim <minchan@kernel.org>
Date: Thu, 7 Jun 2012 13:12:14 +0900
Subject: [PATCH] 1

Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 include/linux/compaction.h |   19 +++++
 mm/compaction.c            |  170 ++++++++++++++++++++++++++++++++++++++------
 mm/internal.h              |    9 ++-
 mm/page_alloc.c            |    8 +--
 4 files changed, 178 insertions(+), 28 deletions(-)

diff --git a/include/linux/compaction.h b/include/linux/compaction.h
index 51a90b7..e988037 100644
--- a/include/linux/compaction.h
+++ b/include/linux/compaction.h
@@ -1,6 +1,8 @@
 #ifndef _LINUX_COMPACTION_H
 #define _LINUX_COMPACTION_H
 
+#include <linux/node.h>
+
 /* Return values for compact_zone() and try_to_compact_pages() */
 /* compaction didn't start as it was not possible or direct reclaim was more suitable */
 #define COMPACT_SKIPPED		0
@@ -11,6 +13,23 @@
 /* The full zone was compacted */
 #define COMPACT_COMPLETE	3
 
+/*
+ * compaction supports three modes
+ *
+ * COMPACT_ASYNC_MOVABLE uses asynchronous migration and only scans
+ *    MIGRATE_MOVABLE pageblocks as migration sources and targets.
+ * COMPACT_ASYNC_UNMOVABLE uses asynchronous migration and only scans
+ *    MIGRATE_MOVABLE pageblocks as migration sources.
+ *    MIGRATE_UNMOVABLE pageblocks are scanned as potential migration
+ *    targets and convers them to MIGRATE_MOVABLE if possible
+ * COMPACT_SYNC uses synchronous migration and scans all pageblocks
+ */
+enum compact_mode {
+	COMPACT_ASYNC_MOVABLE,
+	COMPACT_ASYNC_UNMOVABLE,
+	COMPACT_SYNC,
+};
+
 #ifdef CONFIG_COMPACTION
 extern int sysctl_compact_memory;
 extern int sysctl_compaction_handler(struct ctl_table *table, int write,
diff --git a/mm/compaction.c b/mm/compaction.c
index 7ea259d..a5c9141 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -236,7 +236,7 @@ isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
 	 */
 	while (unlikely(too_many_isolated(zone))) {
 		/* async migration should just abort */
-		if (!cc->sync)
+		if (cc->mode != COMPACT_SYNC)
 			return 0;
 
 		congestion_wait(BLK_RW_ASYNC, HZ/10);
@@ -304,7 +304,8 @@ isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
 		 * satisfies the allocation
 		 */
 		pageblock_nr = low_pfn >> pageblock_order;
-		if (!cc->sync && last_pageblock_nr != pageblock_nr &&
+		if (cc->mode != COMPACT_SYNC &&
+		    last_pageblock_nr != pageblock_nr &&
 		    !migrate_async_suitable(get_pageblock_migratetype(page))) {
 			low_pfn += pageblock_nr_pages;
 			low_pfn = ALIGN(low_pfn, pageblock_nr_pages) - 1;
@@ -325,7 +326,7 @@ isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
 			continue;
 		}
 
-		if (!cc->sync)
+		if (cc->mode != COMPACT_SYNC)
 			mode |= ISOLATE_ASYNC_MIGRATE;
 
 		lruvec = mem_cgroup_page_lruvec(page, zone);
@@ -360,27 +361,116 @@ isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
 
 #endif /* CONFIG_COMPACTION || CONFIG_CMA */
 #ifdef CONFIG_COMPACTION
+/*
+ * Returns true if MIGRATE_UNMOVABLE pageblock can be successfully
+ * converted to MIGRATE_MOVABLE type, false otherwise.
+ */
+static bool can_rescue_unmovable_pageblock(struct page *page)
+{
+	struct zone *zone;
+	unsigned long pfn, start_pfn, end_pfn;
+	struct page *start_page, *end_page, *cursor_page;
+
+	zone = page_zone(page);
+	pfn = page_to_pfn(page);
+	start_pfn = pfn & ~(pageblock_nr_pages - 1);
+	end_pfn = start_pfn + pageblock_nr_pages - 1;
+
+	start_page = pfn_to_page(start_pfn);
+	end_page = pfn_to_page(end_pfn);
+
+	for (cursor_page = start_page, pfn = start_pfn; cursor_page <= end_page;
+		pfn++, cursor_page++) {
+
+		if (!pfn_valid_within(pfn))
+			continue;
+
+		/* Do not deal with pageblocks that overlap zones */
+		if (page_zone(cursor_page) != zone)
+			return false;
+
+		/*
+		 * Race with page allocator/reclaimer can happen so that
+		 * it can deceive unmovable block to migratable type
+		 * on this pageblock. It could regress on anti-fragmentation
+		 * but it's rare and not critical.
+		 */
+		if (PageBuddy(cursor_page)) {
+			unsigned long order = page_order(cursor_page);
+
+			pfn += (1 << order) - 1;
+			cursor_page += (1 << order) - 1;
+			continue;
+		} else if (PageLRU(cursor_page)) {
+			continue;
+		/*
+		 * We can't use page_count which does compound_head
+		 * as we don't have a pin a page.
+		 */
+		} else if (!atomic_read(&cursor_page->_count)) {
+			continue;
+		}
+
+		return false;
+	}
+
+	return true;
+}
+
+static void rescue_unmovable_pageblock(struct page *page)
+{
+	set_pageblock_migratetype(page, MIGRATE_MOVABLE);
+	move_freepages_block(page_zone(page), page, MIGRATE_MOVABLE);
+}
+
+/*
+ * MIGRATE_TARGET : good for migration target
+ * RESCUE_UNMOVABLE_TARTET : good only if we can rescue the unmovable pageblock.
+ * UNMOVABLE_TARGET : can't migrate because it's a page in unmovable pageblock.
+ * SKIP_TARGET : can't migrate by another reasons.
+ */
+enum smt_result {
+	MIGRATE_TARGET,
+	RESCUE_UNMOVABLE_TARGET,
+	UNMOVABLE_TARGET,
+	SKIP_TARGET,
+};
 
-/* Returns true if the page is within a block suitable for migration to */
-static bool suitable_migration_target(struct page *page)
+/*
+ * Returns MIGRATE_TARGET if the page is within a block
+ * suitable for migration to, UNMOVABLE_TARGET if the page
+ * is within a MIGRATE_UNMOVABLE block, SKIP_TARGET otherwise.
+ */
+static enum smt_result suitable_migration_target(struct page *page,
+			      struct compact_control *cc)
 {
 
 	int migratetype = get_pageblock_migratetype(page);
 
 	/* Don't interfere with memory hot-remove or the min_free_kbytes blocks */
 	if (migratetype == MIGRATE_ISOLATE || migratetype == MIGRATE_RESERVE)
-		return false;
+		return SKIP_TARGET;
 
 	/* If the page is a large free page, then allow migration */
 	if (PageBuddy(page) && page_order(page) >= pageblock_order)
-		return true;
+		return MIGRATE_TARGET;
 
 	/* If the block is MIGRATE_MOVABLE or MIGRATE_CMA, allow migration */
-	if (migrate_async_suitable(migratetype))
-		return true;
+	if (cc->mode != COMPACT_ASYNC_UNMOVABLE &&
+	    migrate_async_suitable(migratetype))
+		return MIGRATE_TARGET;
+
+	if (cc->mode == COMPACT_ASYNC_MOVABLE &&
+	    migratetype == MIGRATE_UNMOVABLE)
+		return UNMOVABLE_TARGET;
+
+	if (cc->mode != COMPACT_ASYNC_MOVABLE &&
+	    migratetype == MIGRATE_UNMOVABLE &&
+	    can_rescue_unmovable_pageblock(page))
+		return RESCUE_UNMOVABLE_TARGET;
 
 	/* Otherwise skip the block */
-	return false;
+	return SKIP_TARGET;
 }
 
 /*
@@ -414,6 +504,13 @@ static void isolate_freepages(struct zone *zone,
 	zone_end_pfn = zone->zone_start_pfn + zone->spanned_pages;
 
 	/*
+	 * isolate_freepages() may be called more than once during
+	 * compact_zone_order() run and we want only the most recent
+	 * count.
+	 */
+	cc->nr_unmovable_pageblock = 0;
+
+	/*
 	 * Isolate free pages until enough are available to migrate the
 	 * pages on cc->migratepages. We stop searching if the migrate
 	 * and free page scanners meet or enough free pages are isolated.
@@ -421,6 +518,7 @@ static void isolate_freepages(struct zone *zone,
 	for (; pfn > low_pfn && cc->nr_migratepages > nr_freepages;
 					pfn -= pageblock_nr_pages) {
 		unsigned long isolated;
+		enum smt_result ret;
 
 		if (!pfn_valid(pfn))
 			continue;
@@ -437,9 +535,12 @@ static void isolate_freepages(struct zone *zone,
 			continue;
 
 		/* Check the block is suitable for migration */
-		if (!suitable_migration_target(page))
+		ret = suitable_migration_target(page, cc);
+		if (ret != MIGRATE_TARGET && ret != RESCUE_UNMOVABLE_TARGET) {
+			if (ret == UNMOVABLE_TARGET)
+				cc->nr_unmovable_pageblock++;
 			continue;
-
+		}
 		/*
 		 * Found a block suitable for isolating free pages from. Now
 		 * we disabled interrupts, double check things are ok and
@@ -448,12 +549,16 @@ static void isolate_freepages(struct zone *zone,
 		 */
 		isolated = 0;
 		spin_lock_irqsave(&zone->lock, flags);
-		if (suitable_migration_target(page)) {
+		ret = suitable_migration_target(page, cc);
+		if (ret == MIGRATE_TARGET || ret == RESCUE_UNMOVABLE_TARGET) {
+			if (ret == RESCUE_UNMOVABLE_TARGET)
+				rescue_unmovable_pageblock(page);
 			end_pfn = min(pfn + pageblock_nr_pages, zone_end_pfn);
 			isolated = isolate_freepages_block(pfn, end_pfn,
 							   freelist, false);
 			nr_freepages += isolated;
-		}
+		} else if (ret == UNMOVABLE_TARGET)
+			cc->nr_unmovable_pageblock++;
 		spin_unlock_irqrestore(&zone->lock, flags);
 
 		/*
@@ -685,8 +790,9 @@ static int compact_zone(struct zone *zone, struct compact_control *cc)
 
 		nr_migrate = cc->nr_migratepages;
 		err = migrate_pages(&cc->migratepages, compaction_alloc,
-				(unsigned long)cc, false,
-				cc->sync ? MIGRATE_SYNC_LIGHT : MIGRATE_ASYNC);
+			(unsigned long)&cc->freepages, false,
+			(cc->mode == COMPACT_SYNC) ? MIGRATE_SYNC_LIGHT
+						      : MIGRATE_ASYNC);
 		update_nr_listpages(cc);
 		nr_remaining = cc->nr_migratepages;
 
@@ -715,7 +821,8 @@ out:
 
 static unsigned long compact_zone_order(struct zone *zone,
 				 int order, gfp_t gfp_mask,
-				 bool sync)
+				 enum compact_mode mode,
+				 unsigned long *nr_pageblocks_skipped)
 {
 	struct compact_control cc = {
 		.nr_freepages = 0,
@@ -723,12 +830,17 @@ static unsigned long compact_zone_order(struct zone *zone,
 		.order = order,
 		.migratetype = allocflags_to_migratetype(gfp_mask),
 		.zone = zone,
-		.sync = sync,
+		.mode = mode,
 	};
+	unsigned long rc;
+
 	INIT_LIST_HEAD(&cc.freepages);
 	INIT_LIST_HEAD(&cc.migratepages);
 
-	return compact_zone(zone, &cc);
+	rc = compact_zone(zone, &cc);
+	*nr_pageblocks_skipped = cc.nr_unmovable_pageblock;
+
+	return rc;
 }
 
 int sysctl_extfrag_threshold = 500;
@@ -753,6 +865,8 @@ unsigned long try_to_compact_pages(struct zonelist *zonelist,
 	struct zoneref *z;
 	struct zone *zone;
 	int rc = COMPACT_SKIPPED;
+	unsigned long nr_pageblocks_skipped;
+	enum compact_mode mode;
 
 	/*
 	 * Check whether it is worth even starting compaction. The order check is
@@ -769,12 +883,22 @@ unsigned long try_to_compact_pages(struct zonelist *zonelist,
 								nodemask) {
 		int status;
 
-		status = compact_zone_order(zone, order, gfp_mask, sync);
+		mode = sync ? COMPACT_SYNC : COMPACT_ASYNC_MOVABLE;
+retry:
+		status = compact_zone_order(zone, order, gfp_mask, mode,
+						&nr_pageblocks_skipped);
 		rc = max(status, rc);
 
 		/* If a normal allocation would succeed, stop compacting */
 		if (zone_watermark_ok(zone, order, low_wmark_pages(zone), 0, 0))
 			break;
+
+		if (rc == COMPACT_COMPLETE && mode == COMPACT_ASYNC_MOVABLE) {
+			if (nr_pageblocks_skipped) {
+				mode = COMPACT_ASYNC_UNMOVABLE;
+				goto retry;
+			}
+		}
 	}
 
 	return rc;
@@ -808,7 +932,7 @@ static int __compact_pgdat(pg_data_t *pgdat, struct compact_control *cc)
 			if (ok && cc->order > zone->compact_order_failed)
 				zone->compact_order_failed = cc->order + 1;
 			/* Currently async compaction is never deferred. */
-			else if (!ok && cc->sync)
+			else if (!ok && cc->mode == COMPACT_SYNC)
 				defer_compaction(zone, cc->order);
 		}
 
@@ -823,7 +947,7 @@ int compact_pgdat(pg_data_t *pgdat, int order)
 {
 	struct compact_control cc = {
 		.order = order,
-		.sync = false,
+		.mode = COMPACT_ASYNC_MOVABLE,
 	};
 
 	return __compact_pgdat(pgdat, &cc);
@@ -833,7 +957,7 @@ static int compact_node(int nid)
 {
 	struct compact_control cc = {
 		.order = -1,
-		.sync = true,
+		.mode = COMPACT_SYNC,
 	};
 
 	return __compact_pgdat(NODE_DATA(nid), &cc);
diff --git a/mm/internal.h b/mm/internal.h
index 2ba87fb..061fde7 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -94,6 +94,9 @@ extern void putback_lru_page(struct page *page);
 /*
  * in mm/page_alloc.c
  */
+extern void set_pageblock_migratetype(struct page *page, int migratetype);
+extern int move_freepages_block(struct zone *zone, struct page *page,
+				int migratetype);
 extern void __free_pages_bootmem(struct page *page, unsigned int order);
 extern void prep_compound_page(struct page *page, unsigned long order);
 #ifdef CONFIG_MEMORY_FAILURE
@@ -101,6 +104,7 @@ extern bool is_free_buddy_page(struct page *page);
 #endif
 
 #if defined CONFIG_COMPACTION || defined CONFIG_CMA
+#include <linux/compaction.h>
 
 /*
  * in mm/compaction.c
@@ -119,11 +123,14 @@ struct compact_control {
 	unsigned long nr_migratepages;	/* Number of pages to migrate */
 	unsigned long free_pfn;		/* isolate_freepages search base */
 	unsigned long migrate_pfn;	/* isolate_migratepages search base */
-	bool sync;			/* Synchronous migration */
+	enum compact_mode mode;		/* Compaction mode */
 
 	int order;			/* order a direct compactor needs */
 	int migratetype;		/* MOVABLE, RECLAIMABLE etc */
 	struct zone *zone;
+
+	/* Number of UNMOVABLE destination pageblocks skipped during scan */
+	unsigned long nr_unmovable_pageblock;
 };
 
 unsigned long
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 476ae3e..d40e4c7 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -219,7 +219,7 @@ EXPORT_SYMBOL(nr_online_nodes);
 
 int page_group_by_mobility_disabled __read_mostly;
 
-static void set_pageblock_migratetype(struct page *page, int migratetype)
+void set_pageblock_migratetype(struct page *page, int migratetype)
 {
 
 	if (unlikely(page_group_by_mobility_disabled))
@@ -954,8 +954,8 @@ static int move_freepages(struct zone *zone,
 	return pages_moved;
 }
 
-static int move_freepages_block(struct zone *zone, struct page *page,
-				int migratetype)
+int move_freepages_block(struct zone *zone, struct page *page,
+			 int migratetype)
 {
 	unsigned long start_pfn, end_pfn;
 	struct page *start_page, *end_page;
@@ -5651,7 +5651,7 @@ static int __alloc_contig_migrate_range(unsigned long start, unsigned long end)
 		.nr_migratepages = 0,
 		.order = -1,
 		.zone = page_zone(pfn_to_page(start)),
-		.sync = true,
+		.mode = COMPACT_SYNC,
 	};
 	INIT_LIST_HEAD(&cc.migratepages);
 
-- 
1.7.9.5


--------------040400010104090007070307--
