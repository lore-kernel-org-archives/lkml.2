Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048Ab1BWMEo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 07:04:44 -0500
Received: from hera.kernel.org ([140.211.167.34]:47718 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752985Ab1BWMEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 07:04:43 -0500
Date: Wed, 23 Feb 2011 12:03:58 GMT
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
Subject: [tip:sched/core] sched: Clean up remnants of sd_idle
Message-ID: <tip-c186fafe9aba87c1a93df8c7120a6ae01fe435ad@git.kernel.org>
Git-Commit-ID: c186fafe9aba87c1a93df8c7120a6ae01fe435ad
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 23 Feb 2011 12:04:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c186fafe9aba87c1a93df8c7120a6ae01fe435ad
Gitweb:     http://git.kernel.org/tip/c186fafe9aba87c1a93df8c7120a6ae01fe435ad
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 21 Feb 2011 18:52:53 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 23 Feb 2011 11:33:55 +0100

sched: Clean up remnants of sd_idle

With the wholesale removal of the sd_idle SMT logic we can clean up
some more.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Nikhil Rao <ncrao@google.com>
Cc: Venkatesh Pallipadi <venki@google.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c |   23 ++++++++++-------------
 1 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index d384e73..cd18600 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -3150,25 +3150,23 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 	if (sds.this_load >= sds.avg_load)
 		goto out_balanced;
 
-	/*
-	 * In the CPU_NEWLY_IDLE, use imbalance_pct to be conservative.
-	 * And to check for busy balance use !idle_cpu instead of
-	 * CPU_NOT_IDLE. This is because HT siblings will use CPU_NOT_IDLE
-	 * even when they are idle.
-	 */
-	if (idle == CPU_NEWLY_IDLE || !idle_cpu(this_cpu)) {
-		if (100 * sds.max_load <= sd->imbalance_pct * sds.this_load)
-			goto out_balanced;
-	} else {
+	if (idle == CPU_IDLE) {
 		/*
 		 * This cpu is idle. If the busiest group load doesn't
 		 * have more tasks than the number of available cpu's and
 		 * there is no imbalance between this and busiest group
 		 * wrt to idle cpu's, it is balanced.
 		 */
-		if ((sds.this_idle_cpus  <= sds.busiest_idle_cpus + 1) &&
+		if ((sds.this_idle_cpus <= sds.busiest_idle_cpus + 1) &&
 		    sds.busiest_nr_running <= sds.busiest_group_weight)
 			goto out_balanced;
+	} else {
+		/*
+		 * In the CPU_NEWLY_IDLE, CPU_NOT_IDLE cases, use
+		 * imbalance_pct to be conservative.
+		 */
+		if (100 * sds.max_load <= sd->imbalance_pct * sds.this_load)
+			goto out_balanced;
 	}
 
 force_balance:
@@ -3862,8 +3860,7 @@ static void rebalance_domains(int cpu, enum cpu_idle_type idle)
 			if (load_balance(cpu, rq, sd, idle, &balance)) {
 				/*
 				 * We've pulled tasks over so either we're no
-				 * longer idle, or one of our SMT siblings is
-				 * not idle.
+				 * longer idle.
 				 */
 				idle = CPU_NOT_IDLE;
 			}
