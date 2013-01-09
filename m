Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933310Ab3AIUii (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:38:38 -0500
Received: from mail.kernel.org ([198.145.19.201]:42222 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933274Ab3AIUic (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:38:32 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sonny Rao <sonnyrao@chromium.org>,
        Puneet Kumar <puneetster@chromium.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Damien Wyart <damien.wyart@free.fr>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 20/80] mm: fix calculation of dirtyable memory
Date: Wed,  9 Jan 2013 12:35:12 -0800
Message-Id: <20130109201502.967841937@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201500.410171651@linuxfoundation.org>
References: <20130109201500.410171651@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sonny Rao <sonnyrao@chromium.org>

commit c8b74c2f6604923de91f8aa6539f8bb934736754 upstream.

The system uses global_dirtyable_memory() to calculate number of
dirtyable pages/pages that can be allocated to the page cache.  A bug
causes an underflow thus making the page count look like a big unsigned
number.  This in turn confuses the dirty writeback throttling to
aggressively write back pages as they become dirty (usually 1 page at a
time).  This generally only affects systems with highmem because the
underflowed count gets subtracted from the global count of dirtyable
memory.

The problem was introduced with v3.2-4896-gab8fabd

Fix is to ensure we don't get an underflowed total of either highmem or
global dirtyable memory.

Signed-off-by: Sonny Rao <sonnyrao@chromium.org>
Signed-off-by: Puneet Kumar <puneetster@chromium.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Tested-by: Damien Wyart <damien.wyart@free.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/page-writeback.c |   25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -187,6 +187,18 @@ static unsigned long highmem_dirtyable_m
 		     zone_reclaimable_pages(z) - z->dirty_balance_reserve;
 	}
 	/*
+	 * Unreclaimable memory (kernel memory or anonymous memory
+	 * without swap) can bring down the dirtyable pages below
+	 * the zone's dirty balance reserve and the above calculation
+	 * will underflow.  However we still want to add in nodes
+	 * which are below threshold (negative values) to get a more
+	 * accurate calculation but make sure that the total never
+	 * underflows.
+	 */
+	if ((long)x < 0)
+		x = 0;
+
+	/*
 	 * Make sure that the number of highmem pages is never larger
 	 * than the number of the total dirtyable memory. This can only
 	 * occur in very strange VM situations but we want to make sure
@@ -208,8 +220,8 @@ unsigned long global_dirtyable_memory(vo
 {
 	unsigned long x;
 
-	x = global_page_state(NR_FREE_PAGES) + global_reclaimable_pages() -
-	    dirty_balance_reserve;
+	x = global_page_state(NR_FREE_PAGES) + global_reclaimable_pages();
+	x -= min(x, dirty_balance_reserve);
 
 	if (!vm_highmem_is_dirtyable)
 		x -= highmem_dirtyable_memory(x);
@@ -276,9 +288,12 @@ static unsigned long zone_dirtyable_memo
 	 * highmem zone can hold its share of dirty pages, so we don't
 	 * care about vm_highmem_is_dirtyable here.
 	 */
-	return zone_page_state(zone, NR_FREE_PAGES) +
-	       zone_reclaimable_pages(zone) -
-	       zone->dirty_balance_reserve;
+	unsigned long nr_pages = zone_page_state(zone, NR_FREE_PAGES) +
+		zone_reclaimable_pages(zone);
+
+	/* don't allow this to underflow */
+	nr_pages -= min(nr_pages, zone->dirty_balance_reserve);
+	return nr_pages;
 }
 
 /**


