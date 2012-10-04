Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933392Ab2JDOA1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 10:00:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38491 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933158Ab2JDOAZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 10:00:25 -0400
Date: Thu, 4 Oct 2012 15:00:17 +0100
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: [PATCH] mm: compaction: Iron out isolate_freepages_block() and
 isolate_freepages_range() -fix1
Message-ID: <20121004140017.GW29125@suse.de>
References: <20120927112911.GA25959@avionic-0098.mockup.avionic-design.de>
 <20120927151159.4427fc8f.akpm@linux-foundation.org>
 <20120928054330.GA27594@bbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20120928054330.GA27594@bbox>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch is still missing from linux-next/akpm so am
resending in case it got lost in the mess.


CMA is reported to be broken in next-20120926. Minchan Kim pointed out
that this was due to nr_scanned != total_isolated in the case of CMA
because PageBuddy pages are one scan but many isolations in CMA. This
patch should address the problem.

This patch is a fix for
mm-compaction-acquire-the-zone-lock-as-late-as-possible-fix-2.patch

Signed-off-by: Mel Gorman <mgorman@suse.de>

diff --git a/mm/compaction.c b/mm/compaction.c
index 136debd..ed3b8f1 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -282,6 +282,7 @@ static unsigned long isolate_freepages_block(struct compact_control *cc,
 {
 	int nr_scanned = 0, total_isolated = 0;
 	struct page *cursor, *valid_page = NULL;
+	unsigned long nr_strict_required = end_pfn - blockpfn;
 	unsigned long flags;
 	bool locked = false;
 
@@ -342,10 +343,10 @@ static unsigned long isolate_freepages_block(struct compact_control *cc,
 
 	/*
 	 * If strict isolation is requested by CMA then check that all the
-	 * pages scanned were isolated. If there were any failures, 0 is
+	 * pages requested were isolated. If there were any failures, 0 is
 	 * returned and CMA will fail.
 	 */
-	if (strict && nr_scanned != total_isolated)
+	if (strict && nr_strict_required != total_isolated)
 		total_isolated = 0;
 
 	if (locked)
