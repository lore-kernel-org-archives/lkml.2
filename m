Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755619Ab2K0OHK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 09:07:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48374 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754675Ab2K0OHJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 09:07:09 -0500
Date: Tue, 27 Nov 2012 14:07:05 +0000
From: Mel Gorman <mgorman@suse.de>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 1/3] balancenuma: put page if avoid migrating page
Message-ID: <20121127140705.GP8218@suse.de>
References: <CAJd=RBB+SGundq6jOR0n01jQhAnEf0T5br7_3SQB7-OPuGkgzg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <CAJd=RBB+SGundq6jOR0n01jQhAnEf0T5br7_3SQB7-OPuGkgzg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 09:23:59PM +0800, Hillf Danton wrote:
> If we have to avoid migrating to a node that is nearly full, put page
> and return zero.
> 
> Signed-off-by: Hillf Danton <dhillf@gmail.com>

Correct. In this series, the bug was actually introduced back in "mm:
migrate: Introduce migrate_misplaced_page()" so I'm working the fix to
be a fix on top of that patch and will ensure it gets carried through
properly in the THP patch that happens at the end of the series. This will
work out better in terms of bisection if the tree gets merged and allows
a partial tree to be properly tested. Can I get your signed off on this
patch please? This would be applied on top of "mm: migrate: Introduce
migrate_misplaced_page()"

Thanks.

---8<---
Subject: [PATCH] mm: migrate: Drop the misplaced pages reference count if the
 target node is full

If we have to avoid migrating to a node that is nearly full, put page
and return zero.

[dhillf@gmail.com: Original patch, signed-off is preferred]
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/migrate.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index a2c4567..49878d7 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1489,18 +1489,21 @@ int migrate_misplaced_page(struct page *page, int node)
 		}
 		isolated = 1;
 
-		/*
-		 * Page is isolated which takes a reference count so now the
-		 * callers reference can be safely dropped without the page
-		 * disappearing underneath us during migration
-		 */
-		put_page(page);
-
 		page_lru = page_is_file_cache(page);
 		inc_zone_page_state(page, NR_ISOLATED_ANON + page_lru);
 		list_add(&page->lru, &migratepages);
 	}
 
+	/*
+	 * Page is either isolated or there is not enough space on the target
+	 * node. If isolated, then it has taken a reference count and the
+	 * callers reference can be safely dropped without the page
+	 * disappearing underneath us during migration. Otherwise the page is
+	 * not to be migrated but the callers reference should still be
+	 * dropped so it does not leak.
+	 */
+	put_page(page);
+
 	if (isolated) {
 		int nr_remaining;
 
