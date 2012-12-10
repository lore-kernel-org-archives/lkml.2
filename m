Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab2LJI2Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 03:28:24 -0500
Received: from mga14.intel.com ([143.182.124.37]:14834 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469Ab2LJI01 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 03:26:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,250,1355126400"; 
   d="scan'208";a="178808745"
From: Alex Shi <alex.shi@intel.com>
To: rob@landley.net, mingo@redhat.com, peterz@infradead.org
Cc: gregkh@linuxfoundation.org, andre.przywara@amd.com, rjw@sisk.pl,
        paul.gortmaker@windriver.com, akpm@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        pjt@google.com, vincent.guittot@linaro.org
Subject: [PATCH 10/18] sched: add sched_policy in kernel
Date: Mon, 10 Dec 2012 16:22:26 +0800
Message-Id: <1355127754-8444-11-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1355127754-8444-1-git-send-email-alex.shi@intel.com>
References: <1355127754-8444-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current scheduler behavior is just consider the for larger performance
of system. So it try to spread tasks on more cpu sockets and cpu cores

To adding the consideration of power awareness, the patchset adds
2 kinds of scheduler policy: powersaving and balance, the old scheduling
was taken as performance.

performance: the current scheduling behaviour, try to spread tasks
                on more CPU sockets or cores.
powersaving: will shrink tasks into sched group until all LCPU in the
                group is nearly full.
balance    : will shrink tasks into sched group until group_capacity
                numbers CPU is nearly full.

The following patches will enable powersaving scheduling in CFS.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/fair.c  |    2 ++
 kernel/sched/sched.h |    6 ++++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 55c7e4f..2cf8673 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5869,6 +5869,8 @@ static unsigned int get_rr_interval_fair(struct rq *rq, struct task_struct *task
 	return rr_interval;
 }
 
+/* The default scheduler policy is 'performance'. */
+int __read_mostly sched_policy = SCHED_POLICY_PERFORMANCE;
 /*
  * All the scheduling class methods:
  */
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 0a75a43..7a5eae4 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -8,6 +8,12 @@
 
 extern __read_mostly int scheduler_running;
 
+#define SCHED_POLICY_PERFORMANCE	(0x1)
+#define SCHED_POLICY_POWERSAVING	(0x2)
+#define SCHED_POLICY_BALANCE		(0x4)
+
+extern int __read_mostly sched_policy;
+
 /*
  * Convert user-nice values [ -20 ... 0 ... 19 ]
  * to static priority [ MAX_RT_PRIO..MAX_PRIO-1 ],
-- 
1.7.5.1

