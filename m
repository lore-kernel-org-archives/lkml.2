Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517Ab1ABHW7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:22:59 -0500
Received: from mail.windriver.com ([147.11.1.11]:35174 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753465Ab1ABHW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:22:56 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Daniel J Blueman <daniel.blueman@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 092/260] rcu: apply RCU protection to wake_affine()
Date: Sun,  2 Jan 2011 02:16:28 -0500
Message-Id: <1293952756-15010-93-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:21:51.0102 (UTC) FILETIME=[B977A1E0:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel J Blueman <daniel.blueman@gmail.com>

commit f3b577dec1f2ce32d2db6d2ca6badff7002512af upstream.

The task_group() function returns a pointer that must be protected
by either RCU, the ->alloc_lock, or the cgroup lock (see the
rcu_dereference_check() in task_subsys_state(), which is invoked by
task_group()).  The wake_affine() function currently does none of these,
which means that a concurrent update would be within its rights to free
the structure returned by task_group().  Because wake_affine() uses this
structure only to compute load-balancing heuristics, there is no reason
to acquire either of the two locks.

Therefore, this commit introduces an RCU read-side critical section that
starts before the first call to task_group() and ends after the last use
of the "tg" pointer returned from task_group().  Thanks to Li Zefan for
pointing out the need to extend the RCU read-side critical section from
that proposed by the original patch.

Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 kernel/sched_fair.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 461d312..94993ac 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1272,6 +1272,7 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 	 * effect of the currently running task from the load
 	 * of the current CPU:
 	 */
+	rcu_read_lock();
 	if (sync) {
 		tg = task_group(current);
 		weight = current->se.load.weight;
@@ -1297,6 +1298,7 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 	balanced = !this_load ||
 		100*(this_load + effective_load(tg, this_cpu, weight, weight)) <=
 		imbalance*(load + effective_load(tg, prev_cpu, 0, weight));
+	rcu_read_unlock();
 
 	/*
 	 * If the currently running task will sleep within
-- 
1.7.3.3

