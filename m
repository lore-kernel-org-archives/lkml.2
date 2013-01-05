Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570Ab3AEIkw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 03:40:52 -0500
Received: from mga11.intel.com ([192.55.52.93]:44979 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754706Ab3AEIhd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 03:37:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,415,1355126400"; 
   d="scan'208";a="270210126"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de
Cc: vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        alex.shi@intel.com
Subject: [PATCH v3 13/22] sched: add sched_policy in kernel
Date: Sat,  5 Jan 2013 16:37:42 +0800
Message-Id: <1357375071-11793-14-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1357375071-11793-1-git-send-email-alex.shi@intel.com>
References: <1357375071-11793-1-git-send-email-alex.shi@intel.com>
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
 kernel/sched/fair.c  | 2 ++
 kernel/sched/sched.h | 6 ++++++
 2 files changed, 8 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 6fa10ac..f24aca6 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6100,6 +6100,8 @@ static unsigned int get_rr_interval_fair(struct rq *rq, struct task_struct *task
 	return rr_interval;
 }
 
+/* The default scheduler policy is 'performance'. */
+int __read_mostly sched_policy = SCHED_POLICY_PERFORMANCE;
 /*
  * All the scheduling class methods:
  */
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index ae3511e..66b08a1 100644
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
1.7.12

