Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757092Ab2I1Ihd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 04:37:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51871 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757034Ab2I1Ih3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 04:37:29 -0400
Date: Fri, 28 Sep 2012 09:37:22 +0100
From: Mel Gorman <mgorman@suse.de>
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: Re: CMA broken in next-20120926
Message-ID: <20120928083722.GM3429@suse.de>
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

> I hope this patch fixes the bug. If this patch fixes the problem
> but has some problem about description or someone has better idea,
> feel free to modify and resend to akpm, Please.
> 

A full revert is overkill. Can the following patch be tested as a
potential replacement please?

---8<---
mm: compaction: Iron out isolate_freepages_block() and isolate_freepages_range() -fix1

CMA is reported to be broken in next-20120926. Minchan Kim pointed out
that this was due to nr_scanned != total_isolated in the case of CMA
because PageBuddy pages are one scan but many isolations in CMA. This
patch should address the problem.

This patch is a fix for
mm-compaction-acquire-the-zone-lock-as-late-as-possible-fix-2.patch

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/compaction.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 8250b69..d6e260a 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -282,6 +282,7 @@ static unsigned long isolate_freepages_block(struct compact_control *cc,
 {
 	int nr_scanned = 0, total_isolated = 0;
 	struct page *cursor, *valid_page = NULL;
+	unsigned long nr_strict_required = end_pfn - blockpfn;
 	unsigned long flags;
 	bool locked = false;
 
@@ -343,10 +344,10 @@ static unsigned long isolate_freepages_block(struct compact_control *cc,
 
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
