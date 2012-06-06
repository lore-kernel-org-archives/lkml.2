Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756948Ab2FFP4S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 11:56:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40264 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756675Ab2FFP4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 11:56:15 -0400
Date: Wed, 6 Jun 2012 08:56:03 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-3lbhyj25sr169ha7z3qht5na@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Always initialize cpu-power
Git-Commit-ID: c3decf0dfbc95736b7c0ab68fa4e5854c4734da9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 06 Jun 2012 08:56:08 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c3decf0dfbc95736b7c0ab68fa4e5854c4734da9
Gitweb:     http://git.kernel.org/tip/c3decf0dfbc95736b7c0ab68fa4e5854c4734da9
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 31 May 2012 12:05:32 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Jun 2012 16:52:27 +0200

sched: Always initialize cpu-power

Often when we run into mis-shapen topologies the balance iteration
fails to update the cpu power properly and we'll end up in /0 traps.

Always initialize the cpu-power to a semi-sane value so that we can
at least boot the machine, even if the load-balancer might not
function correctly.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-3lbhyj25sr169ha7z3qht5na@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c |   13 ++++++++++++-
 kernel/sched/fair.c |    2 +-
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 781acb9..725ee7c 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5604,7 +5604,12 @@ static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
 			break;
 		}
 
-		if (!group->sgp->power) {
+		/*
+		 * Even though we initialize ->power to something semi-sane,
+		 * we leave power_orig unset. This allows us to detect if
+		 * domain iteration is still funny without causing /0 traps.
+		 */
+		if (!group->sgp->power_orig) {
 			printk(KERN_CONT "\n");
 			printk(KERN_ERR "ERROR: domain->cpu_power not "
 					"set\n");
@@ -6075,6 +6080,12 @@ build_overlap_sched_groups(struct sched_domain *sd, int cpu)
 		if (atomic_inc_return(&sg->sgp->ref) == 1)
 			build_group_mask(sd, sg);
 
+		/*
+		 * Initialize sgp->power such that even if we mess up the
+		 * domains and no possible iteration will get us here, we won't
+		 * die on a /0 trap.
+		 */
+		sg->sgp->power = SCHED_POWER_SCALE * cpumask_weight(sg_span);
 
 		/*
 		 * Make sure the first group of this domain contains the
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 54cbaa4..c9fd6d6 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3602,7 +3602,7 @@ void update_group_power(struct sched_domain *sd, int cpu)
 		} while (group != child->groups);
 	}
 
-	sdg->sgp->power = power;
+	sdg->sgp->power_orig = sdg->sgp->power = power;
 }
 
 /*
