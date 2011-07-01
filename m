Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794Ab1GAPWw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 11:22:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:57576 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753090Ab1GAPWt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 11:22:49 -0400
Date: Fri, 1 Jul 2011 15:22:37 GMT
From: tip-bot for Stephane Eranian <eranian@google.com>
Message-ID: <tip-cd8a38d33e2528998998bae70a45ad27e442f114@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110606145708.GA7279@quad>
References: <20110606145708.GA7279@quad>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf_events: Fix validation of events using an extra reg
Git-Commit-ID: cd8a38d33e2528998998bae70a45ad27e442f114
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 01 Jul 2011 15:22:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cd8a38d33e2528998998bae70a45ad27e442f114
Gitweb:     http://git.kernel.org/tip/cd8a38d33e2528998998bae70a45ad27e442f114
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Mon, 6 Jun 2011 16:57:08 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 1 Jul 2011 11:06:36 +0200

perf_events: Fix validation of events using an extra reg

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
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20110606145708.GA7279@quad
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c       |   59 ++++++++++++++++++++++++-------
 arch/x86/kernel/cpu/perf_event_intel.c |   16 ++++++--
 2 files changed, 57 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 019fda7..9a0f55c 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1689,6 +1689,40 @@ static int x86_pmu_commit_txn(struct pmu *pmu)
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
+	int cpu = raw_smp_processor_id();
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
@@ -1699,9 +1733,9 @@ static int validate_event(struct perf_event *event)
 	struct event_constraint *c;
 	int ret = 0;
 
-	fake_cpuc = kmalloc(sizeof(*fake_cpuc), GFP_KERNEL | __GFP_ZERO);
-	if (!fake_cpuc)
-		return -ENOMEM;
+	fake_cpuc = allocate_fake_cpuc();
+	if (IS_ERR(fake_cpuc))
+		return PTR_ERR(fake_cpuc);
 
 	c = x86_pmu.get_event_constraints(fake_cpuc, event);
 
@@ -1711,7 +1745,7 @@ static int validate_event(struct perf_event *event)
 	if (x86_pmu.put_event_constraints)
 		x86_pmu.put_event_constraints(fake_cpuc, event);
 
-	kfree(fake_cpuc);
+	free_fake_cpuc(fake_cpuc);
 
 	return ret;
 }
@@ -1731,35 +1765,32 @@ static int validate_group(struct perf_event *event)
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
index 6ad95ba..ac02b83 100644
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
@@ -1524,4 +1528,8 @@ static int intel_pmu_init(void)
 	return 0;
 }
 
+static struct intel_shared_regs *allocate_shared_regs(int cpu)
+{
+	return NULL;
+}
 #endif /* CONFIG_CPU_SUP_INTEL */
