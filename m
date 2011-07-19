Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752301Ab1GSHJb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 03:09:31 -0400
Received: from mga03.intel.com ([143.182.124.21]:12618 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751551Ab1GSHJ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 03:09:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,227,1309762800"; 
   d="scan'208";a="28819251"
Subject: [PATCH]vmscan: fix a livelock in kswapd
From: Shaohua Li <shaohua.li@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mgorman@suse.de, linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Jul 2011 15:09:27 +0800
Message-ID: <1311059367.15392.299.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm running a workload which triggers a lot of swap in a machine with 4 nodes.
After I kill the workload, I found a kswapd livelock. Sometimes kswapd3 or
kswapd2 are keeping running and I can't access filesystem, but most memory is
free. This looks like a regression since commit 08951e545918c159.
Node 2 and 3 have only ZONE_NORMAL, but balance_pgdat() will return 0 for
classzone_idx. The reason is end_zone in balance_pgdat() is 0 by default, if
all zones have watermark ok, end_zone will keep 0.
Later sleeping_prematurely() always returns true. Because this is an order 3
wakeup, and if classzone_idx is 0, both balanced_pages and present_pages
in pgdat_balanced() are 0.
We add a special case here. If a zone has no page, we think it's balanced. This
fixes the livelock.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 5ed24b9..ad4056f 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2310,7 +2310,8 @@ static bool pgdat_balanced(pg_data_t *pgdat, unsigned long balanced_pages,
 	for (i = 0; i <= classzone_idx; i++)
 		present_pages += pgdat->node_zones[i].present_pages;
 
-	return balanced_pages > (present_pages >> 2);
+	/* A special case here: if zone has no page, we think it's balanced */
+	return balanced_pages >= (present_pages >> 2);
 }
 
 /* is kswapd sleeping prematurely? */


