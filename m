Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756390Ab1KVO3c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 09:29:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42496 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756343Ab1KVO32 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 09:29:28 -0500
Subject: [patch 5/7] sched: ratelimit select_idle_sibling()for sync wakeups
From: Mike Galbraith <mgalbraith@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Paul Turner <pjt@google.com>
In-Reply-To: <1321971445.6855.14.camel@marge.simson.net>
References: <1321350377.1421.55.camel@twins>
	 <1321406062.16760.60.camel@sbsiddha-desk.sc.intel.com>
	 <1321435455.5072.64.camel@marge.simson.net>
	 <1321468646.11680.2.camel@sbsiddha-desk.sc.intel.com>
	 <1321495153.5100.7.camel@marge.simson.net>
	 <1321544313.6308.25.camel@marge.simson.net>
	 <1321545376.2495.1.camel@laptop>
	 <1321547917.6308.48.camel@marge.simson.net>
	 <1321551381.15339.21.camel@sbsiddha-desk.sc.intel.com>
	 <1321629267.7080.13.camel@marge.simson.net>
	 <1321629441.7080.15.camel@marge.simson.net>
	 <1321630552.2197.15.camel@twins>
	 <1321971445.6855.14.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Nov 2011 15:23:46 +0100
Message-ID: <1321971826.6855.22.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


select_idle_sibling() injures synchromous loads horribly
on processors with L3 (ala westmere) when called at high
Frequency.  Cut it off at 40 KHz (25usec event rate) when
waking sync, in lieu of an inter-domain cache penalty.

Signed-off-by: Mike Galbraith <efault@gmx.de>

---
 kernel/sched/fair.c     |   20 ++++++++++++++++++--
 kernel/sched/features.h |    6 ++++++
 2 files changed, 24 insertions(+), 2 deletions(-)

Index: linux-3.0-tip/kernel/sched/fair.c
===================================================================
--- linux-3.0-tip.orig/kernel/sched/fair.c
+++ linux-3.0-tip/kernel/sched/fair.c
@@ -2643,6 +2643,21 @@ find_idlest_cpu(struct sched_group *grou
 }
 
 /*
+ * select_idle_sibling() injures synchromous loads horribly
+ * on processors with L3 (ala westmere) when called at high
+ * Frequency.  Cut it off at 40 KHz (25usec event rate) when
+ * waking sync, in lieu of an inter-domain cache penalty.
+ */
+#define SIBLING_SYNC_CUTOFF_NS (NSEC_PER_SEC/40000UL)
+
+static int idle_sibling_limit(int target, int sync)
+{
+	if (!sync || !sched_feat(SIBLING_LIMIT_SYNC))
+		return 0;
+	return cpu_rq(target)->avg_event < SIBLING_SYNC_CUTOFF_NS;
+}
+
+/*
  * Try and locate an idle CPU in the sched_domain.
  */
 static int select_idle_sibling(struct task_struct *p, int target)
@@ -2790,9 +2805,10 @@ select_task_rq_fair(struct task_struct *
 
 	if (affine_sd) {
 		if (cpu == prev_cpu || wake_affine(affine_sd, p, sync))
-			prev_cpu = cpu;
+			new_cpu = cpu;
 
-		new_cpu = select_idle_sibling(p, prev_cpu);
+		if (!idle_sibling_limit(new_cpu, sync))
+			new_cpu = select_idle_sibling(p, new_cpu);
 		goto unlock;
 	}
 
Index: linux-3.0-tip/kernel/sched/features.h
===================================================================
--- linux-3.0-tip.orig/kernel/sched/features.h
+++ linux-3.0-tip/kernel/sched/features.h
@@ -68,3 +68,9 @@ SCHED_FEAT(TTWU_QUEUE, 1)
 
 SCHED_FEAT(FORCE_SD_OVERLAP, 0)
 SCHED_FEAT(RT_RUNTIME_SHARE, 1)
+
+/*
+ * Restrict the frequency at which select_idle_sibling() may be called
+ * for synchronous wakeups.
+ */
+SCHED_FEAT(SIBLING_LIMIT_SYNC, 1)


