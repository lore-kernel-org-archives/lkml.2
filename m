Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307Ab2LJI11 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 03:27:27 -0500
Received: from mga14.intel.com ([143.182.124.37]:14834 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753075Ab2LJI0m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 03:26:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,250,1355126400"; 
   d="scan'208";a="178808785"
From: Alex Shi <alex.shi@intel.com>
To: rob@landley.net, mingo@redhat.com, peterz@infradead.org
Cc: gregkh@linuxfoundation.org, andre.przywara@amd.com, rjw@sisk.pl,
        paul.gortmaker@windriver.com, akpm@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        pjt@google.com, vincent.guittot@linaro.org
Subject: [PATCH 16/18] sched: pull all tasks from source group
Date: Mon, 10 Dec 2012 16:22:32 +0800
Message-Id: <1355127754-8444-17-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1355127754-8444-1-git-send-email-alex.shi@intel.com>
References: <1355127754-8444-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In power balance, we hope some sched groups are fully empty to save
CPU power of them. So, we want to move all tasks from them.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/fair.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index fe0ba07..27630ae 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4843,7 +4843,9 @@ static struct rq *find_busiest_queue(struct lb_env *env,
 		 * When comparing with imbalance, use weighted_cpuload()
 		 * which is not scaled with the cpu power.
 		 */
-		if (capacity && rq->nr_running == 1 && wl > env->imbalance)
+		if (rq->nr_running == 0 ||
+			(!env->power_lb && capacity &&
+				rq->nr_running == 1 && wl > env->imbalance))
 			continue;
 
 		/*
@@ -4947,7 +4949,8 @@ redo:
 
 	ld_moved = 0;
 	lb_iterations = 1;
-	if (busiest->nr_running > 1) {
+	if (busiest->nr_running > 1 ||
+		(busiest->nr_running == 1 && env.power_lb)) {
 		/*
 		 * Attempt to move tasks. If find_busiest_group has found
 		 * an imbalance but busiest->nr_running <= 1, the group is
-- 
1.7.5.1

