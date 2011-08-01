Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343Ab1HAXbo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 19:31:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38831 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754097Ab1HAX1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 19:27:09 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Aug  1 16:20:56 2011
Message-Id: <20110801232056.424528149@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 01 Aug 2011 16:19:13 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Andrea Arcangeli <aarcange@redhat.com>,
        Thomas Sattler <tsattler@gmx.de>, Mel Gorman <mgorman@suse.de>
Subject: [58/70] mm: compaction: ensure that the compaction free scanner does not move to the next zone
In-Reply-To: <20110801232124.GA15313@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mel Gorman <mgorman@suse.de>

commit: 7454f4ba40b419eb999a3c61a99da662bf1a2bb8 upstream

Compaction works with two scanners, a migration and a free scanner.  When
the scanners crossover, migration within the zone is complete.  The
location of the scanner is recorded on each cycle to avoid excesive
scanning.

When a zone is small and mostly reserved, it's very easy for the migration
scanner to be close to the end of the zone.  Then the following situation
can occurs

  o migration scanner isolates some pages near the end of the zone
  o free scanner starts at the end of the zone but finds that the
    migration scanner is already there
  o free scanner gets reinitialised for the next cycle as
    cc->migrate_pfn + pageblock_nr_pages
    moving the free scanner into the next zone
  o migration scanner moves into the next zone

When this happens, NR_ISOLATED accounting goes haywire because some of the
accounting happens against the wrong zone.  One zones counter remains
positive while the other goes negative even though the overall global
count is accurate.  This was reported on X86-32 with !SMP because !SMP
allows the negative counters to be visible.  The fact that it is the bug
should theoritically be possible there.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 mm/compaction.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -144,9 +144,20 @@ static void isolate_freepages(struct zon
 	int nr_freepages = cc->nr_freepages;
 	struct list_head *freelist = &cc->freepages;
 
+	/*
+	 * Initialise the free scanner. The starting point is where we last
+	 * scanned from (or the end of the zone if starting). The low point
+	 * is the end of the pageblock the migration scanner is using.
+	 */
 	pfn = cc->free_pfn;
 	low_pfn = cc->migrate_pfn + pageblock_nr_pages;
-	high_pfn = low_pfn;
+
+	/*
+	 * Take care that if the migration scanner is at the end of the zone
+	 * that the free scanner does not accidentally move to the next zone
+	 * in the next isolation cycle.
+	 */
+	high_pfn = min(low_pfn, pfn);
 
 	/*
 	 * Isolate free pages until enough are available to migrate the


