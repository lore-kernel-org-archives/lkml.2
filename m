Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677Ab0JNFsj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 01:48:39 -0400
Received: from smtp-out.google.com ([74.125.121.35]:47653 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754605Ab0JNFsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 01:48:38 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=A1KgPT3wEHKyh6RUplJtvM/4cKItDgDRZPuVfqmDsd0rBUGBukC7sgxO9W7JSIAdM
	RlD1YVlp5uHOKCX+ALnMQ==
From: Nikhil Rao <ncrao@google.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <efault@gmx.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Venkatesh Pallipadi <venki@google.com>
Cc: linux-kernel@vger.kernel.org, Nikhil Rao <ncrao@google.com>
Subject: [PATCH 3/4] sched: drop group_capacity to 1 only if local group has extra capacity
Date: Wed, 13 Oct 2010 22:48:01 -0700
Message-Id: <1287035281-25579-1-git-send-email-ncrao@google.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1286996978-7007-4-git-send-email-ncrao@google.com>
References: <1286996978-7007-4-git-send-email-ncrao@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resending this patch since the original patch was munged. Thanks to Mike
Galbraith for pointing this out.

When SD_PREFER_SIBLING is set on a sched domain, drop group_capacity to 1
only if the local group has extra capacity. For niced task balancing, we pull
low weight tasks away from a sched group as long as there is capacity in other
groups. When all other groups are saturated, we do not drop capacity of the
niced group down to 1. This prevents active balance from kicking out the low
weight threads and which hurts system utilization.

Signed-off-by: Nikhil Rao <ncrao@google.com>
---
 kernel/sched_fair.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 0dd1021..da0c688 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -2030,6 +2030,7 @@ struct sd_lb_stats {
 	unsigned long this_load;
 	unsigned long this_load_per_task;
 	unsigned long this_nr_running;
+	unsigned long this_group_capacity;
 
 	/* Statistics of the busiest group */
 	unsigned long max_load;
@@ -2546,15 +2547,18 @@ static inline void update_sd_lb_stats(struct sched_domain *sd, int this_cpu,
 		/*
 		 * In case the child domain prefers tasks go to siblings
 		 * first, lower the sg capacity to one so that we'll try
-		 * and move all the excess tasks away.
+		 * and move all the excess tasks away. We lower capacity only
+		 * if the local group can handle the extra capacity.
 		 */
-		if (prefer_sibling)
+		if (prefer_sibling && !local_group &&
+		    sds->this_nr_running < sds->this_group_capacity)
 			sgs.group_capacity = min(sgs.group_capacity, 1UL);
 
 		if (local_group) {
 			sds->this_load = sgs.avg_load;
 			sds->this = sg;
 			sds->this_nr_running = sgs.sum_nr_running;
+			sds->this_group_capacity = sgs.group_capacity;
 			sds->this_load_per_task = sgs.sum_weighted_load;
 		} else if (update_sd_pick_busiest(sd, sds, sg, &sgs, this_cpu)) {
 			sds->max_load = sgs.avg_load;
-- 
1.7.1

