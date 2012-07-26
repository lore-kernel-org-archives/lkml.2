Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751678Ab2GZF1T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 01:27:19 -0400
Received: from mga14.intel.com ([143.182.124.37]:36914 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345Ab2GZF1Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 01:27:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="127018856"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com,
        alex.shi@intel.com
Subject: [PATCH 2/2] sched: fix a logical error in select_task_rq_fair
Date: Thu, 26 Jul 2012 13:27:26 +0800
Message-Id: <1343280446-24019-2-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1343280446-24019-1-git-send-email-alex.shi@intel.com>
References: <1343280446-24019-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If find_idlest_cpu() return '-1', and sd->child is NULL. The function
select_task_rq_fair will return -1. That is not the function's purpose.

The patch introduced a latest_cpu as temporay varible to store
find_idlest_cpu() return value, and let new_cpu to store the latest
workable cpu. If find_idlest_cpu() doesn't find idlest cpu, we still
have a latest workable cpu.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/fair.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 8a1db69..7e4bab48 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2730,6 +2730,7 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
 		int load_idx = sd->forkexec_idx;
 		struct sched_group *group;
 		int weight;
+		int latest_cpu;
 
 		if (!(sd->flags & sd_flag)) {
 			sd = sd->child;
@@ -2745,8 +2746,12 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
 			continue;
 		}
 
-		new_cpu = find_idlest_cpu(group, p, cpu);
-		if (new_cpu == -1 || new_cpu == cpu) {
+		latest_cpu = find_idlest_cpu(group, p, cpu);
+
+		if (latest_cpu != -1)
+			new_cpu = latest_cpu;
+
+		if (latest_cpu == -1 || latest_cpu == cpu) {
 			/* Now try balancing at a lower domain level of cpu */
 			sd = sd->child;
 			continue;
-- 
1.7.5.4

