Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541Ab1HSHtX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 03:49:23 -0400
Received: from smtp-out.google.com ([216.239.44.51]:45680 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343Ab1HSHs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 03:48:58 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:from:to:cc:subject:date:message-id:x-mailer:
	in-reply-to:references:x-system-of-record;
	b=meyCaSl6VqGOQg5X8hXxmh4DPpaeHrPRWViuLDOmYc5IumEKgEREgqxu+51lNyrPF
	ajXnyB95W9BcBRr/SXRng==
From: Michel Lespinasse <walken@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc: Andrea Arcangeli <aarcange@redhat.com>, Hugh Dickins <hughd@google.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Shaohua Li <shaohua.li@intel.com>
Subject: [PATCH 4/9] mm: use get_page in deactivate_page()
Date: Fri, 19 Aug 2011 00:48:26 -0700
Message-Id: <1313740111-27446-5-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1313740111-27446-1-git-send-email-walken@google.com>
References: <1313740111-27446-1-git-send-email-walken@google.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

deactivate_page() already holds a reference to the page, so it can
use get_page() instead of get_page_unless_zero().

Signed-off-by: Michel Lespinasse <walken@google.com>
---
 mm/swap.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/mm/swap.c b/mm/swap.c
index ac617dc..11574b1 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -517,6 +517,8 @@ static void drain_cpu_pagevecs(int cpu)
  */
 void deactivate_page(struct page *page)
 {
+	struct pagevec *pvec;
+
 	/*
 	 * In a workload with many unevictable page such as mprotect, unevictable
 	 * page deactivation for accelerating reclaim is pointless.
@@ -524,13 +526,11 @@ void deactivate_page(struct page *page)
 	if (PageUnevictable(page))
 		return;
 
-	if (likely(get_page_unless_zero(page))) {
-		struct pagevec *pvec = &get_cpu_var(lru_deactivate_pvecs);
-
-		if (!pagevec_add(pvec, page))
-			pagevec_lru_move_fn(pvec, lru_deactivate_fn, NULL);
-		put_cpu_var(lru_deactivate_pvecs);
-	}
+	get_page(page);
+	pvec = &get_cpu_var(lru_deactivate_pvecs);
+	if (!pagevec_add(pvec, page))
+		pagevec_lru_move_fn(pvec, lru_deactivate_fn, NULL);
+	put_cpu_var(lru_deactivate_pvecs);
 }
 
 void lru_add_drain(void)
-- 
1.7.3.1

