Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544Ab2APQXp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 11:23:45 -0500
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:51500 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564Ab2APQXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 11:23:44 -0500
Subject: [RFC PATCH v1 2/2] sched: fix group_capacity for thread level
 consolidation
To: Vincent Guittot <vincent.guittot@linaro.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Indan Zupancic <indan@nul.nu>,
        Youquan Song <youquan.song@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Date: Mon, 16 Jan 2012 21:52:55 +0530
Message-ID: <20120116162255.29759.6264.stgit@localhost>
In-Reply-To: <20120116161740.29759.4679.stgit@localhost>
References: <20120116161740.29759.4679.stgit@localhost>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12011606-6102-0000-0000-000000A6649D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sched_powersavings for threaded systems need this fix for
consolidation to sibling threads to work.  Since threads have
fractional capacity, group_capacity will turn out to be one
always and not accommodate another task in the sibling thread.

This fix makes group_capacity a function of cpumask_weight that
will enable the power saving load balancer to pack tasks among
sibling threads and keep more cores idle.

Signed-off-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
---
 kernel/sched/fair.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index bae6ec8..c94e768 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4012,6 +4012,21 @@ static inline void update_sd_lb_stats(struct sched_domain *sd, int this_cpu,
 		 */
 		if (prefer_sibling && !local_group && sds->this_has_capacity)
 			sgs.group_capacity = min(sgs.group_capacity, 1UL);
+		/*
+		 * If power savings balance is set at this domain, then
+		 * make capacity equal to number of hardware threads to
+		 * accommodate more tasks until capacity is reached.
+		 */
+		else if (sd->flags & SD_POWERSAVINGS_BALANCE)
+			sgs.group_capacity =
+				cpumask_weight(sched_group_cpus(sg));
+
+			/*
+			 * The default group_capacity is rounded from sum of
+			 * fractional cpu_powers of sibling hardware threads
+			 * in order to enable fair use of available hardware
+			 * resources.
+			 */
 
 		if (local_group) {
 			sds->this_load = sgs.avg_load;

