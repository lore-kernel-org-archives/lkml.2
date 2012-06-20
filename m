Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568Ab2FTLlV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 07:41:21 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:36702 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753566Ab2FTLky (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 07:40:54 -0400
From: Glauber Costa <glommer@parallels.com>
To: <linux-kernel@vger.kernel.org>
Cc: <cgroups@vger.kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Turner <pjt@google.com>, <devel@openvz.org>,
        Glauber Costa <glommer@parallels.com>
Subject: [PATCH 1/2] account guest time per-cgroup as well.
Date: Wed, 20 Jun 2012 15:38:15 +0400
Message-Id: <1340192296-15939-2-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.10.2
In-Reply-To: <1340192296-15939-1-git-send-email-glommer@parallels.com>
References: <1340192296-15939-1-git-send-email-glommer@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We already track multiple tick statistics per-cgroup, using
the task_group_account_field facility. This patch accounts
guest_time in that manner as well.

Signed-off-by: Glauber Costa <glommer@parallels.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Paul Turner <pjt@google.com>
---
 kernel/sched/core.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index f442060..4ce68f6 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2689,8 +2689,6 @@ void account_user_time(struct task_struct *p, cputime_t cputime,
 static void account_guest_time(struct task_struct *p, cputime_t cputime,
 			       cputime_t cputime_scaled)
 {
-	u64 *cpustat = kcpustat_this_cpu->cpustat;
-
 	/* Add guest time to process. */
 	p->utime += cputime;
 	p->utimescaled += cputime_scaled;
@@ -2699,11 +2697,11 @@ static void account_guest_time(struct task_struct *p, cputime_t cputime,
 
 	/* Add guest time to cpustat. */
 	if (TASK_NICE(p) > 0) {
-		cpustat[CPUTIME_NICE] += (__force u64) cputime;
-		cpustat[CPUTIME_GUEST_NICE] += (__force u64) cputime;
+		task_group_account_field(p, CPUTIME_NICE, (__force u64) cputime);
+		task_group_account_field(p, CPUTIME_GUEST, (__force u64) cputime);
 	} else {
-		cpustat[CPUTIME_USER] += (__force u64) cputime;
-		cpustat[CPUTIME_GUEST] += (__force u64) cputime;
+		task_group_account_field(p, CPUTIME_USER, (__force u64) cputime);
+		task_group_account_field(p, CPUTIME_GUEST, (__force u64) cputime);
 	}
 }
 
-- 
1.7.10.2

