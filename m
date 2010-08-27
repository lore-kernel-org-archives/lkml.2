Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096Ab0H0ALo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 20:11:44 -0400
Received: from smtp-out.google.com ([216.239.44.51]:49500 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015Ab0H0ALm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 20:11:42 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:x-system-of-record;
	b=kaksGX3vvWIuetTTbWy30SrH7f4OIvq5o6PI/PfYKQGlvUUo0nLYpB3+3unH16Fb9
	oXtwhDlzwr5WrcQCV8XXw==
From: Ying Han <yinghan@google.com>
To: minchan.kim@gmail.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH] vmscan: fix missing place to check nr_swap_pages.
Date: Thu, 26 Aug 2010 17:11:37 -0700
Message-Id: <1282867897-31201-1-git-send-email-yinghan@google.com>
X-Mailer: git-send-email 1.7.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a missed place where checks nr_swap_pages to do shrink_active_list. Make the
change that moves the check to common function inactive_anon_is_low.

Signed-off-by: Ying Han <yinghan@google.com>
---
 mm/vmscan.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 3109ff7..c7923e7 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1605,6 +1605,9 @@ static int inactive_anon_is_low(struct zone *zone, struct scan_control *sc)
 {
 	int low;
 
+	if (nr_swap_pages <= 0)
+		return 0;
+
 	if (scanning_global_lru(sc))
 		low = inactive_anon_is_low_global(zone);
 	else
@@ -1856,7 +1859,7 @@ static void shrink_zone(int priority, struct zone *zone,
 	 * Even if we did not try to evict anon pages at all, we want to
 	 * rebalance the anon lru active/inactive ratio.
 	 */
-	if (inactive_anon_is_low(zone, sc) && nr_swap_pages > 0)
+	if (inactive_anon_is_low(zone, sc))
 		shrink_active_list(SWAP_CLUSTER_MAX, zone, sc, priority, 0);
 
 	throttle_vm_writeout(sc->gfp_mask);
-- 
1.7.1

