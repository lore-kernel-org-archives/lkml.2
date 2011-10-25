Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322Ab1JYGk3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 02:40:29 -0400
Received: from smtp-out.google.com ([74.125.121.67]:17643 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436Ab1JYGk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 02:40:28 -0400
From: Colin Cross <ccross@android.com>
To: linux-kernel@vger.kernel.org
Cc: Colin Cross <ccross@android.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org
Subject: [PATCH] mm: avoid livelock on !__GFP_FS allocations
Date: Mon, 24 Oct 2011 23:39:49 -0700
Message-Id: <1319524789-22818-1-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.4.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Under the following conditions, __alloc_pages_slowpath can loop
forever:
gfp_mask & __GFP_WAIT is true
gfp_mask & __GFP_FS is false
reclaim and compaction make no progress
order <= PAGE_ALLOC_COSTLY_ORDER

These conditions happen very often during suspend and resume,
when pm_restrict_gfp_mask() effectively converts all GFP_KERNEL
allocations into __GFP_WAIT.

The oom killer is not run because gfp_mask & __GFP_FS is false,
but should_alloc_retry will always return true when order is less
than PAGE_ALLOC_COSTLY_ORDER.

Fix __alloc_pages_slowpath to skip retrying when oom killer is
not allowed by the GFP flags, the same way it would skip if the
oom killer was allowed but disabled.

Signed-off-by: Colin Cross <ccross@android.com>
---

An alternative patch would add a did_some_progress argument to
__alloc_pages_may_oom, and remove the checks in
__alloc_pages_slowpath that require knowledge of when
__alloc_pages_may_oom chooses to run out_of_memory. If
did_some_progress was still zero, it would goto nopage whether
or not __alloc_pages_may_oom was actually called.

 mm/page_alloc.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index fef8dc3..dcd99b3 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2193,6 +2193,10 @@ rebalance:
 			}
 
 			goto restart;
+		} else {
+			/* If we aren't going to try the OOM killer, give up */
+			if (!(gfp_mask & __GFP_NOFAIL))
+				goto nopage;
 		}
 	}
 
-- 
1.7.4.1

