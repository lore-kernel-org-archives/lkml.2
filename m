Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759900Ab0GQLMt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jul 2010 07:12:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:41425 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754462Ab0GQLMr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jul 2010 07:12:47 -0400
Date: Sat, 17 Jul 2010 11:12:19 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, suresh.b.siddha@intel.com, tglx@linutronix.de,
        venki@google.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, suresh.b.siddha@intel.com, tglx@linutronix.de,
        venki@google.com, mingo@elte.hu
In-Reply-To: <1278612989.1900.176.camel@laptop>
References: <1278612989.1900.176.camel@laptop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Reduce update_group_power() calls
Message-ID: <tip-bbc8cb5baead9607309583b20873ab0cc8d89eaf@git.kernel.org>
Git-Commit-ID: bbc8cb5baead9607309583b20873ab0cc8d89eaf
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 17 Jul 2010 11:12:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bbc8cb5baead9607309583b20873ab0cc8d89eaf
Gitweb:     http://git.kernel.org/tip/bbc8cb5baead9607309583b20873ab0cc8d89eaf
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 9 Jul 2010 15:15:43 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 17 Jul 2010 12:05:14 +0200

sched: Reduce update_group_power() calls

Currently we update cpu_power() too often, update_group_power() only
updates the local group's cpu_power but it gets called for all groups.

Furthermore, CPU_NEWLY_IDLE invocations will result in all cpus
calling it, even though a slow update of cpu_power is sufficient.

Therefore move the update under 'idle != CPU_NEWLY_IDLE &&
local_group' to reduce superfluous invocations.

Reported-by: Venkatesh Pallipadi <venki@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
LKML-Reference: <1278612989.1900.176.camel@laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index e44a591..c9ac097 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -2425,14 +2425,14 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
 	 * domains. In the newly idle case, we will allow all the cpu's
 	 * to do the newly idle load balance.
 	 */
-	if (idle != CPU_NEWLY_IDLE && local_group &&
-	    balance_cpu != this_cpu) {
-		*balance = 0;
-		return;
+	if (idle != CPU_NEWLY_IDLE && local_group) {
+		if (balance_cpu != this_cpu) {
+			*balance = 0;
+			return;
+		}
+		update_group_power(sd, this_cpu);
 	}
 
-	update_group_power(sd, this_cpu);
-
 	/* Adjust by relative CPU power of the group */
 	sgs->avg_load = (sgs->group_load * SCHED_LOAD_SCALE) / group->cpu_power;
 
