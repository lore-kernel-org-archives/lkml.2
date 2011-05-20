Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934193Ab1ETOAi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 10:00:38 -0400
Received: from smtp-out.google.com ([74.125.121.67]:41364 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756858Ab1ETOAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 10:00:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=lMyNfzJM7kjNeVfuZVIoT1GqJwTIJbirw7k8MeO1LASWRB4N8FXgSwMFlY2p+q0SlH
         9aLkDfFRmXLJqJjhidCg==
Date: Fri, 20 May 2011 16:00:29 +0200
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, peterz@infradead.org, andi@firstfloor.org,
        ming.m.lin@intel.com
Subject: [PATCH 2/3] perf_events: fix validation of events using an extra
 reg
Message-ID: <20110520140029.GA13451@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    
        The validate_group() function needs to validate events with
        extra shared regs. Within an event group, only events with
        the same value for the extra reg can co-exist. This was not
        checked by validate_group() because it was missing the
        shared_regs logic.
    
        This patch changes the allocation of the fake cpuc used for
        validation to also point to a fake shared_regs structure such
        that group events be properly testing.
    
        The is_fake field is necessary to avoid a lockdep issue having
        to do with interrupt masking and era->lock.
    
Signed-off-by: Stephane Eranian <eranian@google.com>
---

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 65eebe9..b0f0415 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -116,6 +116,7 @@ struct cpu_hw_events {
 	struct perf_event	*event_list[X86_PMC_IDX_MAX]; /* in enabled order */
 
 	unsigned int		group_flag;
+	bool			is_fake;	/* fake cpuc for validation purposes */
 
 	/*
 	 * Intel DebugStore bits
@@ -1662,6 +1663,42 @@ static int x86_pmu_commit_txn(struct pmu *pmu)
 	perf_pmu_enable(pmu);
 	return 0;
 }
+/*
+ * a fake_cpuc is used to validate event groups. Due to
+ * the extra reg logic, we need to also allocate a fake
+ * per_core and per_cpu structure. Otherwise, group events
+ * using extra reg may conflict without the kernel being
+ * able to catch this when the last event gets added to
+ * the group.
+ */
+static void free_fake_cpuc(struct cpu_hw_events *cpuc)
+{
+	kfree(cpuc->shared_regs);
+	kfree(cpuc);
+}
+
+static struct cpu_hw_events *allocate_fake_cpuc(void)
+{
+	struct cpu_hw_events *cpuc;
+	int cpu = smp_processor_id();
+
+	cpuc = kzalloc(sizeof(*cpuc), GFP_KERNEL);
+	if (!cpuc)
+		return ERR_PTR(-ENOMEM);
+
+	cpuc->is_fake = true;
+
+	/* only needed, if we have extra_regs */
+	if (x86_pmu.extra_regs) {
+		cpuc->shared_regs = allocate_shared_regs(cpu);
+		if (!cpuc->shared_regs)
+			goto error;
+	}
+	return cpuc;
+error:
+	free_fake_cpuc(cpuc);
+	return ERR_PTR(-ENOMEM);
+}
 
 /*
  * validate that we can schedule this event
@@ -1672,9 +1709,9 @@ static int validate_event(struct perf_event *event)
 	struct event_constraint *c;
 	int ret = 0;
 
-	fake_cpuc = kmalloc(sizeof(*fake_cpuc), GFP_KERNEL | __GFP_ZERO);
-	if (!fake_cpuc)
-		return -ENOMEM;
+	fake_cpuc = allocate_fake_cpuc();
+	if (IS_ERR(fake_cpuc))
+		return PTR_ERR(fake_cpuc);
 
 	c = x86_pmu.get_event_constraints(fake_cpuc, event);
 
@@ -1684,7 +1721,7 @@ static int validate_event(struct perf_event *event)
 	if (x86_pmu.put_event_constraints)
 		x86_pmu.put_event_constraints(fake_cpuc, event);
 
-	kfree(fake_cpuc);
+	free_fake_cpuc(fake_cpuc);
 
 	return ret;
 }
@@ -1704,35 +1741,32 @@ static int validate_group(struct perf_event *event)
 {
 	struct perf_event *leader = event->group_leader;
 	struct cpu_hw_events *fake_cpuc;
-	int ret, n;
+	int ret = -ENOSPC, n;
 
-	ret = -ENOMEM;
-	fake_cpuc = kmalloc(sizeof(*fake_cpuc), GFP_KERNEL | __GFP_ZERO);
-	if (!fake_cpuc)
-		goto out;
+	fake_cpuc = allocate_fake_cpuc();
+	if (IS_ERR(fake_cpuc))
+		return PTR_ERR(fake_cpuc);
 	/*
 	 * the event is not yet connected with its
 	 * siblings therefore we must first collect
 	 * existing siblings, then add the new event
 	 * before we can simulate the scheduling
 	 */
-	ret = -ENOSPC;
 	n = collect_events(fake_cpuc, leader, true);
 	if (n < 0)
-		goto out_free;
+		goto out;
 
 	fake_cpuc->n_events = n;
 	n = collect_events(fake_cpuc, event, false);
 	if (n < 0)
-		goto out_free;
+		goto out;
 
 	fake_cpuc->n_events = n;
 
 	ret = x86_pmu.schedule_events(fake_cpuc, n, NULL);
 
-out_free:
-	kfree(fake_cpuc);
 out:
+	free_fake_cpuc(fake_cpuc);
 	return ret;
 }
 
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index dd99f20..3e6459b 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1050,12 +1050,21 @@ __intel_shared_reg_get_constraints(struct cpu_hw_events *cpuc,
 	struct er_account *era;
 
 	/* already allocated shared msr */
-	if (reg->alloc || !cpuc->shared_regs)
+	if (reg->alloc)
 		return &unconstrained;
 
 	era = &cpuc->shared_regs->regs[reg->idx];
-
-	raw_spin_lock(&era->lock);
+	/*
+	 * we do not lock in case we come here via validate_group(), i.e.,
+	 * fake cpuc, otherwise we trigger a lockdep issue. Locking is not
+	 * necessary with the fakecpu, as we are simply trying to validate
+	 * co-scheduling within a group.
+	 *
+	 * Note that locking is done even when the register is not shared
+	 * between CPUs but there will never be contention.
+	 */
+	if (!cpuc->is_fake)
+		raw_spin_lock(&era->lock);
 
 	if (!atomic_read(&era->ref) || era->config == reg->config) {
 
@@ -1079,7 +1088,8 @@ __intel_shared_reg_get_constraints(struct cpu_hw_events *cpuc,
 		 */
 		c = &unconstrained;
 	}
-	raw_spin_unlock(&era->lock);
+	if (!cpuc->is_fake)
+		raw_spin_unlock(&era->lock);
 
 	return c;
 }
