Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317Ab1EBBT4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 21:19:56 -0400
Received: from smtp-out.google.com ([216.239.44.51]:54517 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754361Ab1EBBTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 21:19:45 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=ru15TcBw87oTPlcnCfUkd2u/FoU2tCNMK7VbEuQwbAYMwXbJBCrAWj2jFMXtxJgAc
	KkNWQZxqPNcBBTHShbEdQ==
From: Nikhil Rao <ncrao@google.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Stephan Barwolf <stephan.baerwolf@tu-ilmenau.de>,
        Nikhil Rao <ncrao@google.com>
Subject: [PATCH v1 08/19] sched: update find_idlest_group() to use u64
Date: Sun,  1 May 2011 18:19:06 -0700
Message-Id: <1304299157-25769-9-git-send-email-ncrao@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1304299157-25769-1-git-send-email-ncrao@google.com>
References: <1304299157-25769-1-git-send-email-ncrao@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update find_idlest_group() to use u64 to accumulate and maintain cpu_load
weights.

Signed-off-by: Nikhil Rao <ncrao@google.com>
---
 kernel/sched_fair.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index c08324b..49e1eeb 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1527,11 +1527,11 @@ find_idlest_group(struct sched_domain *sd, struct task_struct *p,
 		  int this_cpu, int load_idx)
 {
 	struct sched_group *idlest = NULL, *group = sd->groups;
-	unsigned long min_load = ULONG_MAX, this_load = 0;
+	u64 min_load = ULLONG_MAX, this_load = 0;
 	int imbalance = 100 + (sd->imbalance_pct-100)/2;
 
 	do {
-		unsigned long load, avg_load;
+		u64 load, avg_load;
 		int local_group;
 		int i;
 
@@ -1557,7 +1557,8 @@ find_idlest_group(struct sched_domain *sd, struct task_struct *p,
 		}
 
 		/* Adjust by relative CPU power of the group */
-		avg_load = (avg_load * SCHED_POWER_SCALE) / group->cpu_power;
+		avg_load *= SCHED_POWER_SCALE;
+		avg_load = div_u64(avg_load, group->cpu_power);
 
 		if (local_group) {
 			this_load = avg_load;
-- 
1.7.3.1

