Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837Ab0EJJ2r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 05:28:47 -0400
Received: from mga11.intel.com ([192.55.52.93]:46280 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755813Ab0EJJ2p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 05:28:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,361,1270450800"; 
   d="scan'208";a="565696478"
Subject: [RFC][PATCH 6/9] perf: powerpc, convert to new API pmu->init_event
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       "eranian@gmail.com" <eranian@gmail.com>,
       "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Paul Mundt <lethal@linux-sh.org>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 10 May 2010 17:28:12 +0800
Message-Id: <1273483692.15998.60.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf: powerpc, convert to new API pmu->init_event

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 arch/powerpc/kernel/perf_event.c         |   37 +++++++++++++++--------------
 arch/powerpc/kernel/perf_event_fsl_emb.c |   37 +++++++++++++++--------------
 2 files changed, 38 insertions(+), 36 deletions(-)

diff --git a/arch/powerpc/kernel/perf_event.c b/arch/powerpc/kernel/perf_event.c
index e02f2ee..5aa4a66 100644
--- a/arch/powerpc/kernel/perf_event.c
+++ b/arch/powerpc/kernel/perf_event.c
@@ -896,13 +896,6 @@ static void power_pmu_unthrottle(struct perf_event *event)
 	local_irq_restore(flags);
 }
 
-struct pmu power_pmu = {
-	.enable		= power_pmu_enable,
-	.disable	= power_pmu_disable,
-	.read		= power_pmu_read,
-	.unthrottle	= power_pmu_unthrottle,
-};
-
 /*
  * Return 1 if we might be able to put event on a limited PMC,
  * or 0 if not.
@@ -1003,7 +996,7 @@ static int hw_perf_cache_event(u64 config, u64 *eventp)
 	return 0;
 }
 
-struct pmu *hw_perf_event_init(struct perf_event *event)
+static int power_pmu_init_event(struct perf_event *event)
 {
 	u64 ev;
 	unsigned long flags;
@@ -1015,7 +1008,7 @@ struct pmu *hw_perf_event_init(struct perf_event *event)
 	struct cpu_hw_events *cpuhw;
 
 	if (!ppmu)
-		return ERR_PTR(-ENXIO);
+		return -ENXIO;
 	switch (event->attr.type) {
 	case PERF_TYPE_HARDWARE:
 		ev = event->attr.config;
@@ -1026,13 +1019,13 @@ struct pmu *hw_perf_event_init(struct perf_event *event)
 	case PERF_TYPE_HW_CACHE:
 		err = hw_perf_cache_event(event->attr.config, &ev);
 		if (err)
-			return ERR_PTR(err);
+			return err;
 		break;
 	case PERF_TYPE_RAW:
 		ev = event->attr.config;
 		break;
 	default:
-		return ERR_PTR(-EINVAL);
+		return -EINVAL;
 	}
 	event->hw.config_base = ev;
 	event->hw.idx = 0;
@@ -1070,7 +1063,7 @@ struct pmu *hw_perf_event_init(struct perf_event *event)
 			 */
 			ev = normal_pmc_alternative(ev, flags);
 			if (!ev)
-				return ERR_PTR(-EINVAL);
+				return -EINVAL;
 		}
 	}
 
@@ -1084,19 +1077,19 @@ struct pmu *hw_perf_event_init(struct perf_event *event)
 		n = collect_events(event->group_leader, ppmu->n_counter - 1,
 				   ctrs, events, cflags);
 		if (n < 0)
-			return ERR_PTR(-EINVAL);
+			return -EINVAL;
 	}
 	events[n] = ev;
 	ctrs[n] = event;
 	cflags[n] = flags;
 	if (check_excludes(ctrs, cflags, n, 1))
-		return ERR_PTR(-EINVAL);
+		return -EINVAL;
 
 	cpuhw = &get_cpu_var(cpu_hw_events);
 	err = power_check_constraints(cpuhw, events, cflags, n + 1);
 	put_cpu_var(cpu_hw_events);
 	if (err)
-		return ERR_PTR(-EINVAL);
+		return -EINVAL;
 
 	event->hw.config = events[n];
 	event->hw.event_base = cflags[n];
@@ -1121,11 +1114,17 @@ struct pmu *hw_perf_event_init(struct perf_event *event)
 	}
 	event->destroy = hw_perf_event_destroy;
 
-	if (err)
-		return ERR_PTR(err);
-	return &power_pmu;
+	return err;
 }
 
+struct pmu power_pmu = {
+	.enable		= power_pmu_enable,
+	.disable	= power_pmu_disable,
+	.read		= power_pmu_read,
+	.unthrottle	= power_pmu_unthrottle,
+	.init_event	= power_pmu_init_event,
+};
+
 /*
  * A counter has overflowed; update its count and record
  * things if requested.  Note that interrupts are hard-disabled
@@ -1333,5 +1332,7 @@ int register_power_pmu(struct power_pmu *pmu)
 
 	perf_cpu_notifier(power_pmu_notifier);
 
+	perf_event_register_pmu(power_pmu);
+
 	return 0;
 }
diff --git a/arch/powerpc/kernel/perf_event_fsl_emb.c b/arch/powerpc/kernel/perf_event_fsl_emb.c
index cf8554e..2d8db33 100644
--- a/arch/powerpc/kernel/perf_event_fsl_emb.c
+++ b/arch/powerpc/kernel/perf_event_fsl_emb.c
@@ -378,13 +378,6 @@ static void fsl_emb_pmu_unthrottle(struct perf_event *event)
 	local_irq_restore(flags);
 }
 
-static struct pmu fsl_emb_pmu = {
-	.enable		= fsl_emb_pmu_enable,
-	.disable	= fsl_emb_pmu_disable,
-	.read		= fsl_emb_pmu_read,
-	.unthrottle	= fsl_emb_pmu_unthrottle,
-};
-
 /*
  * Release the PMU if this is the last perf_event.
  */
@@ -428,7 +421,7 @@ static int hw_perf_cache_event(u64 config, u64 *eventp)
 	return 0;
 }
 
-struct pmu *hw_perf_event_init(struct perf_event *event)
+static int fsl_emb_pmu_init_event(struct perf_event *event)
 {
 	u64 ev;
 	struct perf_event *events[MAX_HWEVENTS];
@@ -441,14 +434,14 @@ struct pmu *hw_perf_event_init(struct perf_event *event)
 	case PERF_TYPE_HARDWARE:
 		ev = event->attr.config;
 		if (ev >= ppmu->n_generic || ppmu->generic_events[ev] == 0)
-			return ERR_PTR(-EOPNOTSUPP);
+			return -EOPNOTSUPP;
 		ev = ppmu->generic_events[ev];
 		break;
 
 	case PERF_TYPE_HW_CACHE:
 		err = hw_perf_cache_event(event->attr.config, &ev);
 		if (err)
-			return ERR_PTR(err);
+			return err;
 		break;
 
 	case PERF_TYPE_RAW:
@@ -456,12 +449,12 @@ struct pmu *hw_perf_event_init(struct perf_event *event)
 		break;
 
 	default:
-		return ERR_PTR(-EINVAL);
+		return -EINVAL;
 	}
 
 	event->hw.config = ppmu->xlate_event(ev);
 	if (!(event->hw.config & FSL_EMB_EVENT_VALID))
-		return ERR_PTR(-EINVAL);
+		return -EINVAL;
 
 	/*
 	 * If this is in a group, check if it can go on with all the
@@ -473,7 +466,7 @@ struct pmu *hw_perf_event_init(struct perf_event *event)
 		n = collect_events(event->group_leader,
 		                   ppmu->n_counter - 1, events);
 		if (n < 0)
-			return ERR_PTR(-EINVAL);
+			return -EINVAL;
 	}
 
 	if (event->hw.config & FSL_EMB_EVENT_RESTRICTED) {
@@ -484,7 +477,7 @@ struct pmu *hw_perf_event_init(struct perf_event *event)
 		}
 
 		if (num_restricted >= ppmu->n_restricted)
-			return ERR_PTR(-EINVAL);
+			return -EINVAL;
 	}
 
 	event->hw.idx = -1;
@@ -497,7 +490,7 @@ struct pmu *hw_perf_event_init(struct perf_event *event)
 	if (event->attr.exclude_kernel)
 		event->hw.config_base |= PMLCA_FCS;
 	if (event->attr.exclude_idle)
-		return ERR_PTR(-ENOTSUPP);
+		return -ENOTSUPP;
 
 	event->hw.last_period = event->hw.sample_period;
 	atomic64_set(&event->hw.period_left, event->hw.last_period);
@@ -523,11 +516,17 @@ struct pmu *hw_perf_event_init(struct perf_event *event)
 	}
 	event->destroy = hw_perf_event_destroy;
 
-	if (err)
-		return ERR_PTR(err);
-	return &fsl_emb_pmu;
+	return err;
 }
 
+static struct pmu fsl_emb_pmu = {
+	.enable		= fsl_emb_pmu_enable,
+	.disable	= fsl_emb_pmu_disable,
+	.read		= fsl_emb_pmu_read,
+	.unthrottle	= fsl_emb_pmu_unthrottle,
+	.init_event	= fsl_emb_pmu_init_event,
+};
+
 /*
  * A counter has overflowed; update its count and record
  * things if requested.  Note that interrupts are hard-disabled
@@ -650,5 +649,7 @@ int register_fsl_emb_pmu(struct fsl_emb_pmu *pmu)
 	pr_info("%s performance monitor hardware support registered\n",
 		pmu->name);
 
+	perf_event_register_pmu(&fsl_emb_pmu);
+
 	return 0;
 }


