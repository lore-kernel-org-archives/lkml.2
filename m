Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404Ab0GIKOE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 06:14:04 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60152 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754787Ab0GIKOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 06:14:01 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@redhat.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH] vmscan: stop meaningless loop iteration when no reclaimable slab
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20100709171850.FA22.A69D9226@jp.fujitsu.com>
References: <20100708133152.5e556508.akpm@linux-foundation.org> <20100709171850.FA22.A69D9226@jp.fujitsu.com>
Message-Id: <20100709191308.FA25.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri,  9 Jul 2010 19:13:58 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If number of reclaimable slabs are zero, shrink_icache_memory() and
shrink_dcache_memory() return 0. but strangely shrink_slab() ignore
it and continue meaningless loop iteration.

This patch fixes it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/vmscan.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 0f9f624..8f61adb 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -243,6 +243,11 @@ unsigned long shrink_slab(unsigned long scanned, gfp_t gfp_mask,
 			int nr_before;
 
 			nr_before = (*shrinker->shrink)(0, gfp_mask);
+			/* no slab objects, no more reclaim. */
+			if (nr_before == 0) {
+				total_scan = 0;
+				break;
+			}
 			shrink_ret = (*shrinker->shrink)(this_scan, gfp_mask);
 			if (shrink_ret == -1)
 				break;
-- 
1.6.5.2



