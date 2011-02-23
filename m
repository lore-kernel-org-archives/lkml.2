Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab1BWMFZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 07:05:25 -0500
Received: from hera.kernel.org ([140.211.167.34]:56424 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752985Ab1BWMFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 07:05:23 -0500
Date: Wed, 23 Feb 2011 12:04:52 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        ncrao@google.com, a.p.zijlstra@chello.nl, efault@gmx.de,
        suresh.b.siddha@intel.com, tglx@linutronix.de, mingo@elte.hu,
        venki@google.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, ncrao@google.com, efault@gmx.de,
        suresh.b.siddha@intel.com, tglx@linutronix.de, mingo@elte.hu,
        venki@google.com
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix the group_imb logic
Message-ID: <tip-866ab43efd325fae8889ea77a744d03f2b957e38@git.kernel.org>
Git-Commit-ID: 866ab43efd325fae8889ea77a744d03f2b957e38
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 23 Feb 2011 12:04:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  866ab43efd325fae8889ea77a744d03f2b957e38
Gitweb:     http://git.kernel.org/tip/866ab43efd325fae8889ea77a744d03f2b957e38
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 21 Feb 2011 18:56:47 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 23 Feb 2011 11:33:57 +0100

sched: Fix the group_imb logic

On a 2*6*2 machine something like:

 taskset -c 3-11 bash -c 'for ((i=0;i<9;i++)) do while :; do :; done & done'

_should_ result in 9 busy CPUs, each running 1 task.

However it didn't quite work reliably, most of the time one cpu of the
second socket (6-11) would be idle and one cpu of the first socket
(0-5) would have two tasks on it.

The group_imb logic is supposed to deal with this and detect when a
particular group is imbalanced (like in our case, 0-2 are idle but 3-5
will have 4 tasks on it).

The detection phase needed a bit of a tweak as it was too weak and
required more than 2 avg weight tasks difference between idle and busy
cpus in the group which won't trigger for our test-case. So cure that
to be one or more avg task weight difference between cpus.

Once the detection phase worked, it was then defeated by the f_b_g()
tests trying to avoid ping-pongs. In particular, this_load >= max_load
triggered because the pulling cpu (the (first) idle cpu in on the
second socket, say 6) would find this_load to be 5 and max_load to be
4 (there'd be 5 tasks running on our socket and only 4 on the other
socket).

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Nikhil Rao <ncrao@google.com>
Cc: Venkatesh Pallipadi <venki@google.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 03496eb..3a88dee 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -2743,7 +2743,7 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
 
 	/*
 	 * Consider the group unbalanced when the imbalance is larger
-	 * than the average weight of two tasks.
+	 * than the average weight of a task.
 	 *
 	 * APZ: with cgroup the avg task weight can vary wildly and
 	 *      might not be a suitable number - should we keep a
@@ -2753,7 +2753,7 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
 	if (sgs->sum_nr_running)
 		avg_load_per_task = sgs->sum_weighted_load / sgs->sum_nr_running;
 
-	if ((max_cpu_load - min_cpu_load) > 2*avg_load_per_task && max_nr_running > 1)
+	if ((max_cpu_load - min_cpu_load) >= avg_load_per_task && max_nr_running > 1)
 		sgs->group_imb = 1;
 
 	sgs->group_capacity = DIV_ROUND_CLOSEST(group->cpu_power, SCHED_LOAD_SCALE);
@@ -3128,6 +3128,14 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 	if (!sds.busiest || sds.busiest_nr_running == 0)
 		goto out_balanced;
 
+	/*
+	 * If the busiest group is imbalanced the below checks don't
+	 * work because they assumes all things are equal, which typically
+	 * isn't true due to cpus_allowed constraints and the like.
+	 */
+	if (sds.group_imb)
+		goto force_balance;
+
 	/* SD_BALANCE_NEWIDLE trumps SMP nice when underutilized */
 	if (idle == CPU_NEWLY_IDLE && sds.this_has_capacity &&
 			!sds.busiest_has_capacity)
