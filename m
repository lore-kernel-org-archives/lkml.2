Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012Ab0GAXOK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 19:14:10 -0400
Received: from smtp-out.google.com ([74.125.121.35]:37572 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792Ab0GAXOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 19:14:08 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:x-system-of-record;
	b=IYUHWLuJv6Y3e2qvIzHhWcXR+lWCK4VPRpmIUK0UVW3dLiPgySZOWxWDBpprYLHyf
	I+vhG+zoJqjhkLSJGwHsA==
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>, Gautham R Shenoy <ego@in.ibm.com>,
       Joel Schopp <jschopp@austin.ibm.com>,
       Venkatesh Pallipadi <venki@google.com>
Subject: [PATCH] sched: Call update_group_power only for local_group
Date: Thu,  1 Jul 2010 16:12:22 -0700
Message-Id: <1278025942-6750-1-git-send-email-venki@google.com>
X-Mailer: git-send-email 1.7.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 871e35b moved update_group_power() call in update_sg_lb_stats(),
resulting in it being called for each group, even though it only updates
the power of local group. As a result we have frequent redundant
update_group_power() calls.

Move it back under "if (local_group)" condition.

This reduces the number of calls to update_group_power by a factor of 4
on my 4 core in 4 NUMA nodes test system.

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
---
 kernel/sched_fair.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index a878b53..369d53d 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -2359,8 +2359,11 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
 	unsigned int balance_cpu = -1, first_idle_cpu = 0;
 	unsigned long avg_load_per_task = 0;
 
-	if (local_group)
+	if (local_group) {
 		balance_cpu = group_first_cpu(group);
+		update_group_power(sd, this_cpu);
+	}
+
 
 	/* Tally up the load of all CPUs in the group */
 	max_cpu_load = 0;
@@ -2406,8 +2409,6 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
 		return;
 	}
 
-	update_group_power(sd, this_cpu);
-
 	/* Adjust by relative CPU power of the group */
 	sgs->avg_load = (sgs->group_load * SCHED_LOAD_SCALE) / group->cpu_power;
 
-- 
1.7.1

