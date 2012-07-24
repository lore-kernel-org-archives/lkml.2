Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725Ab2GXBMn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 21:12:43 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:57351 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755490Ab2GXBKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 21:10:20 -0400
X-AuditID: 9c93016f-b7b08ae00000790d-f7-500df5f8721c
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Minchan Kim <minchan@kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>
Subject: [PATCH 2/3] mm: Warn if pg_data_t isn't initialized with zero
Date: Tue, 24 Jul 2012 10:10:34 +0900
Message-Id: <1343092235-13399-2-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343092235-13399-1-git-send-email-minchan@kernel.org>
References: <1343092235-13399-1-git-send-email-minchan@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch warns if memory-hotplug/boot code doesn't initialize
pg_data_t with zero when it's allocated. As I looked arch code and
memory hotplug, they already seem to initiailize pg_data_t.
So this warning should be never happen. It needs double check and
let's add checking garbage with warn. I select fields randomly
nearyby begin/middle/end of pg_data_t for checking garbage.
If we are very unlucky, those garbage might be zero but it's very unlikely,
I hope.

This patch isn't for performance but removing initialization code
which is necessary to add whenever we adds new field to pg_data_t or zone.
It's rather bothersome and error-prone about compile at least as I had
experienced.

Firstly, Andrew suggested clearing out of pg_data_t in MM core part but
Tejun doesn't like it because in the future, some archs can initialize
some fields in arch code and pass them into general MM part so blindly clearing
it out in mm core part would be very annoying.

Cc: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-arch <linux-arch@vger.kernel.org>
Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 mm/page_alloc.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index b65c362..2037eeb 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4517,6 +4517,9 @@ void __paginginit free_area_init_node(int nid, unsigned long *zones_size,
 {
 	pg_data_t *pgdat = NODE_DATA(nid);
 
+	/* pg_data_t should be reset to zero when it's allocated */
+	WARN_ON(pgdat->nr_zones || pgdat->node_start_pfn || pgdat->classzone_idx);
+
 	pgdat->node_id = nid;
 	pgdat->node_start_pfn = node_start_pfn;
 	calculate_node_totalpages(pgdat, zones_size, zholes_size);
-- 
1.7.9.5

