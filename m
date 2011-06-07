Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751250Ab1FGKN3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 06:13:29 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:49320 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815Ab1FGKN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 06:13:28 -0400
Subject: [PATCH] sched: remove rcu_read_lock from wake_affine
To: peterz@infradead.org, mingo@elte.hu
From: "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org
Date: Tue, 07 Jun 2011 15:43:22 +0530
Message-ID: <20110607101251.777.34547.stgit@IBM-009124035060.in.ibm.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wake_affine is called from one path: select_task_rq_fair, which already has
rcu read lock held.

Signed-off-by: Nikunj A. Dadhania <nikunj@linux.vnet.ibm.com>
---
 kernel/sched_fair.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 354e26b..0bfec93 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1461,6 +1461,7 @@ static inline unsigned long effective_load(struct task_group *tg, int cpu,
 
 #endif
 
+/* Assumes rcu_read_lock is held */
 static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 {
 	s64 this_load, load;
@@ -1481,7 +1482,6 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 	 * effect of the currently running task from the load
 	 * of the current CPU:
 	 */
-	rcu_read_lock();
 	if (sync) {
 		tg = task_group(current);
 		weight = current->se.load.weight;
@@ -1517,7 +1517,6 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 		balanced = this_eff_load <= prev_eff_load;
 	} else
 		balanced = true;
-	rcu_read_unlock();
 
 	/*
 	 * If the currently running task will sleep within

