Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864Ab0IITu6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 15:50:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:33127 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753108Ab0IITu4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 15:50:56 -0400
Date: Thu, 9 Sep 2010 19:50:29 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Remove the sysfs bits
Message-ID: <tip-15ac9a395a753cb28c674e7ea80386ffdff21785@git.kernel.org>
Git-Commit-ID: 15ac9a395a753cb28c674e7ea80386ffdff21785
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 09 Sep 2010 19:50:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  15ac9a395a753cb28c674e7ea80386ffdff21785
Gitweb:     http://git.kernel.org/tip/15ac9a395a753cb28c674e7ea80386ffdff21785
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 6 Sep 2010 15:51:45 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 9 Sep 2010 20:46:31 +0200

perf: Remove the sysfs bits

Neither the overcommit nor the reservation sysfs parameter were
actually working, remove them as they'll only get in the way.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: paulus <paulus@samba.org>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/alpha/kernel/perf_event.c   |    3 +-
 arch/arm/kernel/perf_event.c     |    9 +---
 arch/sparc/kernel/perf_event.c   |    9 +--
 arch/x86/kernel/cpu/perf_event.c |    1 -
 include/linux/perf_event.h       |    6 --
 kernel/perf_event.c              |  124 --------------------------------------
 6 files changed, 5 insertions(+), 147 deletions(-)

diff --git a/arch/alpha/kernel/perf_event.c b/arch/alpha/kernel/perf_event.c
index 380ef02..9bb8c02 100644
--- a/arch/alpha/kernel/perf_event.c
+++ b/arch/alpha/kernel/perf_event.c
@@ -808,7 +808,7 @@ static void alpha_perf_event_irq_handler(unsigned long la_ptr,
 	wrperfmon(PERFMON_CMD_DISABLE, cpuc->idx_mask);
 
 	/* la_ptr is the counter that overflowed. */
-	if (unlikely(la_ptr >= perf_max_events)) {
+	if (unlikely(la_ptr >= alpha_pmu->num_pmcs)) {
 		/* This should never occur! */
 		irq_err_count++;
 		pr_warning("PMI: silly index %ld\n", la_ptr);
@@ -879,7 +879,6 @@ void __init init_hw_perf_events(void)
 
 	/* And set up PMU specification */
 	alpha_pmu = &ev67_pmu;
-	perf_max_events = alpha_pmu->num_pmcs;
 
 	perf_pmu_register(&pmu);
 }
diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
index 448cfa6..45d6a35 100644
--- a/arch/arm/kernel/perf_event.c
+++ b/arch/arm/kernel/perf_event.c
@@ -534,7 +534,7 @@ static int armpmu_event_init(struct perf_event *event)
 	event->destroy = hw_perf_event_destroy;
 
 	if (!atomic_inc_not_zero(&active_events)) {
-		if (atomic_read(&active_events) > perf_max_events) {
+		if (atomic_read(&active_events) > armpmu.num_events) {
 			atomic_dec(&active_events);
 			return -ENOSPC;
 		}
@@ -2974,14 +2974,12 @@ init_hw_perf_events(void)
 			armpmu = &armv6pmu;
 			memcpy(armpmu_perf_cache_map, armv6_perf_cache_map,
 					sizeof(armv6_perf_cache_map));
-			perf_max_events	= armv6pmu.num_events;
 			break;
 		case 0xB020:	/* ARM11mpcore */
 			armpmu = &armv6mpcore_pmu;
 			memcpy(armpmu_perf_cache_map,
 			       armv6mpcore_perf_cache_map,
 			       sizeof(armv6mpcore_perf_cache_map));
-			perf_max_events = armv6mpcore_pmu.num_events;
 			break;
 		case 0xC080:	/* Cortex-A8 */
 			armv7pmu.id = ARM_PERF_PMU_ID_CA8;
@@ -2993,7 +2991,6 @@ init_hw_perf_events(void)
 			/* Reset PMNC and read the nb of CNTx counters
 			    supported */
 			armv7pmu.num_events = armv7_reset_read_pmnc();
-			perf_max_events = armv7pmu.num_events;
 			break;
 		case 0xC090:	/* Cortex-A9 */
 			armv7pmu.id = ARM_PERF_PMU_ID_CA9;
@@ -3005,7 +3002,6 @@ init_hw_perf_events(void)
 			/* Reset PMNC and read the nb of CNTx counters
 			    supported */
 			armv7pmu.num_events = armv7_reset_read_pmnc();
-			perf_max_events = armv7pmu.num_events;
 			break;
 		}
 	/* Intel CPUs [xscale]. */
@@ -3016,13 +3012,11 @@ init_hw_perf_events(void)
 			armpmu = &xscale1pmu;
 			memcpy(armpmu_perf_cache_map, xscale_perf_cache_map,
 					sizeof(xscale_perf_cache_map));
-			perf_max_events	= xscale1pmu.num_events;
 			break;
 		case 2:
 			armpmu = &xscale2pmu;
 			memcpy(armpmu_perf_cache_map, xscale_perf_cache_map,
 					sizeof(xscale_perf_cache_map));
-			perf_max_events	= xscale2pmu.num_events;
 			break;
 		}
 	}
@@ -3032,7 +3026,6 @@ init_hw_perf_events(void)
 				arm_pmu_names[armpmu->id], armpmu->num_events);
 	} else {
 		pr_info("no hardware support available\n");
-		perf_max_events = -1;
 	}
 
 	perf_pmu_register(&pmu);
diff --git a/arch/sparc/kernel/perf_event.c b/arch/sparc/kernel/perf_event.c
index 516be23..f9a7067 100644
--- a/arch/sparc/kernel/perf_event.c
+++ b/arch/sparc/kernel/perf_event.c
@@ -897,7 +897,7 @@ static int sparc_check_constraints(struct perf_event **evts,
 	if (!n_ev)
 		return 0;
 
-	if (n_ev > perf_max_events)
+	if (n_ev > MAX_HWEVENTS)
 		return -1;
 
 	msk0 = perf_event_get_msk(events[0]);
@@ -1014,7 +1014,7 @@ static int sparc_pmu_add(struct perf_event *event, int ef_flags)
 	perf_pmu_disable(event->pmu);
 
 	n0 = cpuc->n_events;
-	if (n0 >= perf_max_events)
+	if (n0 >= MAX_HWEVENTS)
 		goto out;
 
 	cpuc->event[n0] = event;
@@ -1097,7 +1097,7 @@ static int sparc_pmu_event_init(struct perf_event *event)
 	n = 0;
 	if (event->group_leader != event) {
 		n = collect_events(event->group_leader,
-				   perf_max_events - 1,
+				   MAX_HWEVENTS - 1,
 				   evts, events, current_idx_dmy);
 		if (n < 0)
 			return -EINVAL;
@@ -1309,9 +1309,6 @@ void __init init_hw_perf_events(void)
 
 	pr_cont("Supported PMU type is '%s'\n", sparc_pmu_type);
 
-	/* All sparc64 PMUs currently have 2 events.  */
-	perf_max_events = 2;
-
 	perf_pmu_register(&pmu);
 	register_die_notifier(&perf_event_nmi_notifier);
 }
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index dd6fec7..0fb1705 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1396,7 +1396,6 @@ void __init init_hw_perf_events(void)
 		x86_pmu.num_counters = X86_PMC_MAX_GENERIC;
 	}
 	x86_pmu.intel_ctrl = (1 << x86_pmu.num_counters) - 1;
-	perf_max_events = x86_pmu.num_counters;
 
 	if (x86_pmu.num_counters_fixed > X86_PMC_MAX_FIXED) {
 		WARN(1, KERN_ERR "hw perf events fixed %d > max(%d), clipping!",
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 402073c..b22176d 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -860,7 +860,6 @@ struct perf_cpu_context {
 	struct perf_event_context	ctx;
 	struct perf_event_context	*task_ctx;
 	int				active_oncpu;
-	int				max_pertask;
 	int				exclusive;
 	struct swevent_hlist		*swevent_hlist;
 	struct mutex			hlist_mutex;
@@ -883,11 +882,6 @@ struct perf_output_handle {
 
 #ifdef CONFIG_PERF_EVENTS
 
-/*
- * Set by architecture code:
- */
-extern int perf_max_events;
-
 extern int perf_pmu_register(struct pmu *pmu);
 extern void perf_pmu_unregister(struct pmu *pmu);
 
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 3bace4f..8462e69 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -39,10 +39,6 @@
  */
 static DEFINE_PER_CPU(struct perf_cpu_context, perf_cpu_context);
 
-int perf_max_events __read_mostly = 1;
-static int perf_reserved_percpu __read_mostly;
-static int perf_overcommit __read_mostly = 1;
-
 static atomic_t nr_events __read_mostly;
 static atomic_t nr_mmap_events __read_mostly;
 static atomic_t nr_comm_events __read_mostly;
@@ -66,11 +62,6 @@ int sysctl_perf_event_sample_rate __read_mostly = 100000;
 
 static atomic64_t perf_event_id;
 
-/*
- * Lock for (sysadmin-configurable) event reservations:
- */
-static DEFINE_SPINLOCK(perf_resource_lock);
-
 void __weak perf_event_print_debug(void)	{ }
 
 void perf_pmu_disable(struct pmu *pmu)
@@ -480,16 +471,6 @@ static void __perf_event_remove_from_context(void *info)
 
 	list_del_event(event, ctx);
 
-	if (!ctx->task) {
-		/*
-		 * Allow more per task events with respect to the
-		 * reservation:
-		 */
-		cpuctx->max_pertask =
-			min(perf_max_events - ctx->nr_events,
-			    perf_max_events - perf_reserved_percpu);
-	}
-
 	raw_spin_unlock(&ctx->lock);
 }
 
@@ -823,9 +804,6 @@ static void __perf_install_in_context(void *info)
 		}
 	}
 
-	if (!err && !ctx->task && cpuctx->max_pertask)
-		cpuctx->max_pertask--;
-
 unlock:
 	raw_spin_unlock(&ctx->lock);
 }
@@ -5930,10 +5908,6 @@ static void __cpuinit perf_event_init_cpu(int cpu)
 
 	cpuctx = &per_cpu(perf_cpu_context, cpu);
 
-	spin_lock(&perf_resource_lock);
-	cpuctx->max_pertask = perf_max_events - perf_reserved_percpu;
-	spin_unlock(&perf_resource_lock);
-
 	mutex_lock(&cpuctx->hlist_mutex);
 	if (cpuctx->hlist_refcount > 0) {
 		struct swevent_hlist *hlist;
@@ -6008,101 +5982,3 @@ void __init perf_event_init(void)
 	perf_tp_register();
 	perf_cpu_notifier(perf_cpu_notify);
 }
-
-static ssize_t perf_show_reserve_percpu(struct sysdev_class *class,
-					struct sysdev_class_attribute *attr,
-					char *buf)
-{
-	return sprintf(buf, "%d\n", perf_reserved_percpu);
-}
-
-static ssize_t
-perf_set_reserve_percpu(struct sysdev_class *class,
-			struct sysdev_class_attribute *attr,
-			const char *buf,
-			size_t count)
-{
-	struct perf_cpu_context *cpuctx;
-	unsigned long val;
-	int err, cpu, mpt;
-
-	err = strict_strtoul(buf, 10, &val);
-	if (err)
-		return err;
-	if (val > perf_max_events)
-		return -EINVAL;
-
-	spin_lock(&perf_resource_lock);
-	perf_reserved_percpu = val;
-	for_each_online_cpu(cpu) {
-		cpuctx = &per_cpu(perf_cpu_context, cpu);
-		raw_spin_lock_irq(&cpuctx->ctx.lock);
-		mpt = min(perf_max_events - cpuctx->ctx.nr_events,
-			  perf_max_events - perf_reserved_percpu);
-		cpuctx->max_pertask = mpt;
-		raw_spin_unlock_irq(&cpuctx->ctx.lock);
-	}
-	spin_unlock(&perf_resource_lock);
-
-	return count;
-}
-
-static ssize_t perf_show_overcommit(struct sysdev_class *class,
-				    struct sysdev_class_attribute *attr,
-				    char *buf)
-{
-	return sprintf(buf, "%d\n", perf_overcommit);
-}
-
-static ssize_t
-perf_set_overcommit(struct sysdev_class *class,
-		    struct sysdev_class_attribute *attr,
-		    const char *buf, size_t count)
-{
-	unsigned long val;
-	int err;
-
-	err = strict_strtoul(buf, 10, &val);
-	if (err)
-		return err;
-	if (val > 1)
-		return -EINVAL;
-
-	spin_lock(&perf_resource_lock);
-	perf_overcommit = val;
-	spin_unlock(&perf_resource_lock);
-
-	return count;
-}
-
-static SYSDEV_CLASS_ATTR(
-				reserve_percpu,
-				0644,
-				perf_show_reserve_percpu,
-				perf_set_reserve_percpu
-			);
-
-static SYSDEV_CLASS_ATTR(
-				overcommit,
-				0644,
-				perf_show_overcommit,
-				perf_set_overcommit
-			);
-
-static struct attribute *perfclass_attrs[] = {
-	&attr_reserve_percpu.attr,
-	&attr_overcommit.attr,
-	NULL
-};
-
-static struct attribute_group perfclass_attr_group = {
-	.attrs			= perfclass_attrs,
-	.name			= "perf_events",
-};
-
-static int __init perf_event_sysfs_init(void)
-{
-	return sysfs_create_group(&cpu_sysdev_class.kset.kobj,
-				  &perfclass_attr_group);
-}
-device_initcall(perf_event_sysfs_init);
