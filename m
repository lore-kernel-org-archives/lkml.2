Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963Ab1G1IKR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 04:10:17 -0400
Received: from mga14.intel.com ([143.182.124.37]:6074 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754238Ab1G1IKL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 04:10:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,281,1309762800"; 
   d="scan'208";a="32451885"
From: Alex Shi <alex.shi@intel.com>
To: mgorman@suse.de
Cc: minchan.kim@gmail.com, stable@kernel.org, linux-kernel@vger.kernel.org,
        andrea@cpushare.com, tim.c.chen@intel.com, shaohua.li@intel.com
Subject: [PATCH] kswapd: assign new_order and new_classzone_idx after wakeup in sleeping
Date: Thu, 28 Jul 2011 16:11:28 +0800
Message-Id: <1311840688-11388-1-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There 2 place to read pgdat in kswapd. One is return from a successful
balance, another is waked up from sleeping. But the new_order and
new_classzone_idx are not assigned after kswapd_try_to_sleep(), that
will cause a bug in the following scenario.

After the last time successful balance, kswapd goes to sleep. So the
new_order and new_classzone_idx were assigned to 0 and MAX-1 since there
is no new wakeup during last time balancing. Now, a new wakeup came and
finish balancing successful with order > 0. But since new_order is still
0, this time successful balancing were judged as a failed balance. so,
if there is another new wakeup coming during balancing, kswapd cann't
read this and still want to try to sleep. And if the new wakeup is a
tighter request, kswapd may goes to sleep, not to do balancing. That is
incorrect.

So, to avoid above problem, the new_order and new_classzone_idx need to
be assigned for later successful comparison.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 mm/vmscan.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 7ef6912..eb7bcce 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2850,6 +2850,8 @@ static int kswapd(void *p)
 			kswapd_try_to_sleep(pgdat, order, classzone_idx);
 			order = pgdat->kswapd_max_order;
 			classzone_idx = pgdat->classzone_idx;
+			new_order = order;
+			new_classzone_idx = classzone_idx;
 			pgdat->kswapd_max_order = 0;
 			pgdat->classzone_idx = pgdat->nr_zones - 1;
 		}
-- 
1.6.3.3

