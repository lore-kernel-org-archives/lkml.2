Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756355Ab2EHVjl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 17:39:41 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:15001 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595Ab2EHVjk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 17:39:40 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 08 May 2012 14:39:34 -0700
From: Diwakar Tundlam <dtundlam@nvidia.com>
To: "'Peter Zijlstra'" <a.p.zijlstra@chello.nl>
CC: "'Ingo Molnar'" <mingo@kernel.org>,
        "'David Rientjes'" <rientjes@google.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
Date: Tue, 8 May 2012 14:39:33 -0700
Subject: [PATCH] sched: Make nr_uninterruptible count a signed value
Thread-Topic: [PATCH] sched: Make nr_uninterruptible count a signed value
Thread-Index: Ac0tYw6MPjl3rbxeTTCBDHNlFfmqhw==
Message-ID: <1DD7BFEDD3147247B1355BEFEFE46652379C3DF10C@HQMAIL04.nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Declare nr_uninterruptible as a signed long to avoid garbage values
seen in cat /proc/sched_debug when a task is moved to the run queue of
a newly online core. This is part of a global counter where only the
total sum over all CPUs matters.

Signed-off-by: Diwakar Tundlam <dtundlam@nvidia.com>
---
 kernel/sched/core.c  |    7 ++++---
 kernel/sched/sched.h |    2 +-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 8d5eef6..7a64b5b 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2114,7 +2114,8 @@ unsigned long nr_running(void)
 
 unsigned long nr_uninterruptible(void)
 {
-	unsigned long i, sum = 0;
+	unsigned long i;
+	long sum = 0;
 
 	for_each_possible_cpu(i)
 		sum += cpu_rq(i)->nr_uninterruptible;
@@ -2123,7 +2124,7 @@ unsigned long nr_uninterruptible(void)
 	 * Since we read the counters lockless, it might be slightly
 	 * inaccurate. Do not allow it to go below zero though:
 	 */
-	if (unlikely((long)sum < 0))
+	if (unlikely(sum < 0))
 		sum = 0;
 
 	return sum;
@@ -2174,7 +2175,7 @@ static long calc_load_fold_active(struct rq *this_rq)
 	long nr_active, delta = 0;
 
 	nr_active = this_rq->nr_running;
-	nr_active += (long) this_rq->nr_uninterruptible;
+	nr_active += this_rq->nr_uninterruptible;
 
 	if (nr_active != this_rq->calc_load_active) {
 		delta = nr_active - this_rq->calc_load_active;
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index fb3acba..2668b07 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -385,7 +385,7 @@ struct rq {
 	 * one CPU and if it got migrated afterwards it may decrease
 	 * it on another CPU. Always updated under the runqueue lock:
 	 */
-	unsigned long nr_uninterruptible;
+	long nr_uninterruptible;
 
 	struct task_struct *curr, *idle, *stop;
 	unsigned long next_balance;
-- 
1.7.4.1
