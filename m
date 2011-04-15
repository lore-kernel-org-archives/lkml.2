Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283Ab1DOCzC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 22:55:02 -0400
Received: from mga11.intel.com ([192.55.52.93]:30429 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755033Ab1DOCzB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 22:55:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,215,1301900400"; 
   d="scan'208";a="679320128"
From: Alex Shi <alex.shi@intel.com>
To: a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org
Cc: tim.c.chen@intel.com, suresh.b.siddha@intel.com
Subject: [PATCH] sched:make ads.avg_load update in time
Date: Fri, 15 Apr 2011 10:11:37 +0800
Message-Id: <1302833497-19506-1-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 866ab43efd325fae cause hackbench benchmark process mode
performance dropping about 15% on our x86_64 machines. The patch works
as its origin purpose, but it cause nearly double context switch on
hackbench running.  The sds.avg_load was not updated in time cause this.
So when move the sds.avg_load update before group_imb checking,
performance recovered totally.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched_fair.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 7f00772..036b660 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -3127,6 +3127,8 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 	if (!sds.busiest || sds.busiest_nr_running == 0)
 		goto out_balanced;
 
+	sds->avg_load = (SCHED_LOAD_SCALE * sds->total_load) / sds->total_pwr;
+
 	/*
 	 * If the busiest group is imbalanced the below checks don't
 	 * work because they assumes all things are equal, which typically
@@ -3151,7 +3153,6 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 	 * Don't pull any tasks if this group is already above the domain
 	 * average load.
 	 */
-	sds.avg_load = (SCHED_LOAD_SCALE * sds.total_load) / sds.total_pwr;
 	if (sds.this_load >= sds.avg_load)
 		goto out_balanced;
 
-- 
1.7.0

