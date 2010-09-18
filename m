Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757364Ab0IRTYG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:24:06 -0400
Received: from kroah.org ([198.145.64.141]:43697 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757056Ab0IRTPw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:15:52 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:13:04 2010
Message-Id: <20100918191304.793209000@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 12:13:05 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
        Wu Fengguang <fengguang.wu@intel.com>
Subject: [087/129] mm: compaction: handle active and inactive fairly in too_many_isolated
In-Reply-To: <20100918191317.GA11386@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Minchan Kim <minchan.kim@gmail.com>

commit bc6930457460788e14b2c0808ed4632a1592bd61 upstream.

Iram reported that compaction's too_many_isolated() loops forever.
(http://www.spinics.net/lists/linux-mm/msg08123.html)

The meminfo when the situation happened was inactive anon is zero.  That's
because the system has no memory pressure until then.  While all anon
pages were in the active lru, compaction could select active lru as well
as inactive lru.  That's a different thing from vmscan's isolated.  So we
has been two too_many_isolated.

While compaction can isolate pages in both active and inactive, current
implementation of too_many_isolated only considers inactive.  It made
Iram's problem.

This patch handles active and inactive fairly.  That's because we can't
expect where from and how many compaction would isolated pages.

This patch changes (nr_isolated > nr_inactive) with
nr_isolated > (nr_active + nr_inactive) / 2.

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Reported-by: Iram Shahzad <iram.shahzad@jp.fujitsu.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/compaction.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -214,15 +214,16 @@ static void acct_isolated(struct zone *z
 /* Similar to reclaim, but different enough that they don't share logic */
 static bool too_many_isolated(struct zone *zone)
 {
-
-	unsigned long inactive, isolated;
+	unsigned long active, inactive, isolated;
 
 	inactive = zone_page_state(zone, NR_INACTIVE_FILE) +
 					zone_page_state(zone, NR_INACTIVE_ANON);
+	active = zone_page_state(zone, NR_ACTIVE_FILE) +
+					zone_page_state(zone, NR_ACTIVE_ANON);
 	isolated = zone_page_state(zone, NR_ISOLATED_FILE) +
 					zone_page_state(zone, NR_ISOLATED_ANON);
 
-	return isolated > inactive;
+	return isolated > (inactive + active) / 2;
 }
 
 /*


