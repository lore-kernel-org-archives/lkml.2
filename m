Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933284Ab1FAKEd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 06:04:33 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64398 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755861Ab1FAKEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 06:04:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=KROavVBtXMt3W0LV2zu+S8JwG09+1Zz/cZIi+CCrqImoHLjNATlehd/MOPV5lBSKmD
         mzzouFFxgBBLQ8cQtscKdYWd8D/F1eISFr7RuirWG3w/oGMnHcWhiaKIjf7xvkirqbPr
         wtmmZEHZBxyeDfOlv8xwWWcJehItsWvbEyMS8=
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mel Gorman <mel@csn.ul.ie>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Make GFP_DMA allocations w/o ZONE_DMA emit a warning instead of failing
Date: Wed,  1 Jun 2011 14:04:32 +0400
Message-Id: <1306922672-9012-1-git-send-email-dbaryshkov@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please be more polite to other people. After a197b59ae6 all allocations
with GFP_DMA set on nodes without ZONE_DMA fail nearly silently (only
one warning during bootup is emited, no matter how many things fail).
This is a very crude change on behaviour. To be more civil, instead of
failing emit noisy warnings each time smbd. tries to allocate a GFP_DMA
memory on non-ZONE_DMA node.

This change should be reverted after one or two major releases, but
we should be more accurate rather than hoping for the best.

Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 mm/page_alloc.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index a4e1db3..e22dd4e 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2248,8 +2248,9 @@ __alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order,
 	if (should_fail_alloc_page(gfp_mask, order))
 		return NULL;
 #ifndef CONFIG_ZONE_DMA
-	if (WARN_ON_ONCE(gfp_mask & __GFP_DMA))
-		return NULL;
+	/* Change this back to hard failure after 3.0 or 3.1. For now give
+	 * drivers people a chance to fix their drivers w/o causing breakage. */
+	WARN_ON(gfp_mask & __GFP_DMA);
 #endif
 
 	/*
-- 
1.7.4.4

