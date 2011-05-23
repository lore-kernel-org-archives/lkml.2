Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226Ab1EWQNB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 12:13:01 -0400
Received: from smtp-out.google.com ([74.125.121.67]:45552 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755576Ab1EWQM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 12:12:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=ndEOqEQClS2bsQHnvWf/xiHf+TETYZuyeKIz0RaYXsWUycJsJdSnKCEzD34ib7YjCI
         9p0r5JFmdgd96qwZrKUw==
Date: Mon, 23 May 2011 18:12:52 +0200
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, peterz@infradead.org, andi@firstfloor.org,
        ming.m.lin@intel.com
Subject: [PATCH 2/3] perf_events: fix validation of events using an extra
 reg (v3)
Message-ID: <20110523161252.GA11607@quad>
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

It modifies __intel_shared_reg_get_constraints() to use
spin_lock_irqsave() to avoid lockdep issues.

Signed-off-by: Stephane Eranian <eranian@google.com>
---

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 0f8d3ff..ed6af75 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1682,6 +1682,40 @@ static int x86_pmu_commit_txn(struct pmu *pmu)
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
@@ -1692,9 +1726,9 @@ static int validate_event(struct perf_event *event)
 	struct event_constraint *c;
 	int ret = 0;
 
-	fake_cpuc = kmalloc(sizeof(*fake_cpuc), GFP_KERNEL | __GFP_ZERO);
-	if (!fake_cpuc)
-		return -ENOMEM;
+	fake_cpuc = allocate_fake_cpuc();
+	if (IS_ERR(fake_cpuc))
+		return PTR_ERR(fake_cpuc);
 
 	c = x86_pmu.get_event_constraints(fake_cpuc, event);
 
@@ -1704,7 +1738,7 @@ static int validate_event(struct perf_event *event)
 	if (x86_pmu.put_event_constraints)
 		x86_pmu.put_event_constraints(fake_cpuc, event);
 
-	kfree(fake_cpuc);
+	free_fake_cpuc(fake_cpuc);
 
 	return ret;
 }
@@ -1724,35 +1758,32 @@ static int validate_group(struct perf_event *event)
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
index 2d40f33..4ae1e99 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1027,14 +1027,18 @@ __intel_shared_reg_get_constraints(struct cpu_hw_events *cpuc,
 {
 	struct event_constraint *c = &emptyconstraint;
 	struct er_account *era;
+	unsigned long flags;
 
 	/* already allocated shared msr */
-	if (reg->alloc || !cpuc->shared_regs)
+	if (reg->alloc)
 		return &unconstrained;
 
 	era = &cpuc->shared_regs->regs[reg->idx];
-
-	raw_spin_lock(&era->lock);
+	/*
+	 * we use spin_lock_irqsave() to avoid lockdep issues when
+	 * passing a fake cpuc
+	 */
+	raw_spin_lock_irqsave(&era->lock, flags);
 
 	if (!atomic_read(&era->ref) || era->config == reg->config) {
 
@@ -1058,7 +1062,7 @@ __intel_shared_reg_get_constraints(struct cpu_hw_events *cpuc,
 		 */
 		c = &unconstrained;
 	}
-	raw_spin_unlock(&era->lock);
+	raw_spin_unlock_irqrestore(&era->lock, flags);
 
 	return c;
 }
