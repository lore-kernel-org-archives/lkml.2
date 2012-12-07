Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933181Ab2LGK0Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 05:26:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42457 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933111Ab2LGKZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 05:25:16 -0500
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Ingo Molnar <mingo@kernel.org>
Cc: Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Hugh Dickins <hughd@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Paul Turner <pjt@google.com>, Hillf Danton <dhillf@gmail.com>,
        David Rientjes <rientjes@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Alex Shi <lkml.alex@gmail.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 46/49] mm: numa: Account for failed allocations and isolations as migration failures
Date: Fri,  7 Dec 2012 10:23:49 +0000
Message-Id: <1354875832-9700-47-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1354875832-9700-1-git-send-email-mgorman@suse.de>
References: <1354875832-9700-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject says it all. Allocation failures and a failure to isolate should
be accounted as a migration failure. This is partially another
difference between base page and transhuge page migration. A base page
migration makes multiple attempts for these conditions before it would
be accounted for as a failure.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/migrate.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index b6fe2d2..eb155c9 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1635,12 +1635,15 @@ int migrate_misplaced_transhuge_page(struct mm_struct *mm,
 
 	new_page = alloc_pages_node(node,
 		(GFP_TRANSHUGE | GFP_THISNODE) & ~__GFP_WAIT, HPAGE_PMD_ORDER);
-	if (!new_page)
+	if (!new_page) {
+		count_vm_events(PGMIGRATE_FAIL, HPAGE_PMD_NR);
 		goto out_dropref;
+	}
 	page_xchg_last_nid(new_page, page_last_nid(page));
 
 	isolated = numamigrate_isolate_page(pgdat, page);
 	if (!isolated) {
+		count_vm_events(PGMIGRATE_FAIL, HPAGE_PMD_NR);
 		put_page(new_page);
 		goto out_keep_locked;
 	}
-- 
1.7.9.2

