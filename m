Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917Ab2LJI31 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 03:29:27 -0500
Received: from mga14.intel.com ([143.182.124.37]:14834 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752735Ab2LJI0P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 03:26:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,250,1355126400"; 
   d="scan'208";a="178808709"
From: Alex Shi <alex.shi@intel.com>
To: rob@landley.net, mingo@redhat.com, peterz@infradead.org
Cc: gregkh@linuxfoundation.org, andre.przywara@amd.com, rjw@sisk.pl,
        paul.gortmaker@windriver.com, akpm@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        pjt@google.com, vincent.guittot@linaro.org
Subject: [PATCH 05/18] sched: load tracking bug fix
Date: Mon, 10 Dec 2012 16:22:21 +0800
Message-Id: <1355127754-8444-6-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1355127754-8444-1-git-send-email-alex.shi@intel.com>
References: <1355127754-8444-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need initialize the se.avg.{decay_count, load_avg_contrib} to zero
after a new task forked.
Otherwise random values of above variable cause mess when do new task
enqueue:
    enqueue_task_fair
        enqueue_entity
            enqueue_entity_load_avg

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/core.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 5dae0d2..e6533e1 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1534,6 +1534,8 @@ static void __sched_fork(struct task_struct *p)
 #if defined(CONFIG_SMP) && defined(CONFIG_FAIR_GROUP_SCHED)
 	p->se.avg.runnable_avg_period = 0;
 	p->se.avg.runnable_avg_sum = 0;
+	p->se.avg.decay_count = 0;
+	p->se.avg.load_avg_contrib = 0;
 #endif
 #ifdef CONFIG_SCHEDSTATS
 	memset(&p->se.statistics, 0, sizeof(p->se.statistics));
-- 
1.7.5.1

