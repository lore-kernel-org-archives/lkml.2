Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836Ab2F0KGz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 06:06:55 -0400
Received: from merlin.infradead.org ([205.233.59.134]:32949 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754512Ab2F0KGy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 06:06:54 -0400
Message-ID: <1340791604.10063.10.camel@twins>
Subject: Re: [PATCH 2/2] perf/x86: Uncore Filter support for SandyBridge-EP
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: eranian@google.com, mingo@elte.hu, andi@firstfloor.org,
        linux-kernel@vger.kernel.org
Date: Wed, 27 Jun 2012 12:06:44 +0200
In-Reply-To: <1340780953-21130-2-git-send-email-zheng.z.yan@intel.com>
References: <1340780953-21130-1-git-send-email-zheng.z.yan@intel.com>
	 <1340780953-21130-2-git-send-email-zheng.z.yan@intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-27 at 15:09 +0800, Yan, Zheng wrote:
> @@ -1048,10 +1190,9 @@ static int uncore_validate_group(struct intel_uncore_pmu *pmu,
>  {
>         struct perf_event *leader = event->group_leader;
>         struct intel_uncore_box *fake_box;
> -       int assign[UNCORE_PMC_IDX_MAX];
>         int ret = -EINVAL, n;
>  
> -       fake_box = uncore_alloc_box(smp_processor_id());
> +       fake_box = uncore_alloc_box(pmu->type, smp_processor_id());
>         if (!fake_box)
>                 return -ENOMEM;
>  
> @@ -1073,7 +1214,7 @@ static int uncore_validate_group(struct intel_uncore_pmu *pmu,
>  
>         fake_box->n_events = n;
>  
> -       ret = uncore_assign_events(fake_box, assign, n);
> +       ret = uncore_assign_events(fake_box, NULL, n);
>  out:
>         kfree(fake_box);
>         return ret; 

Isn't the uncore now suffering the same problem you found for the
regular extra stuff?

---
commit 5a425294ee7d4ab5a374248e85838dfd450caf75
Author: Peter Zijlstra <peterz@infradead.org>
Date:   Tue Jun 5 15:30:31 2012 +0200

    perf/x86: Fix Intel shared extra MSR allocation
    
    Zheng Yan reported that event group validation can wreck event state
    when Intel extra_reg allocation changes event state.
    
    Validation shouldn't change any persistent state. Cloning events in
    validate_{event,group}() isn't really pretty either, so add a few
    special cases to avoid modifying the event state.
    
    The code is restructured to minimize the special case impact.
    
    Reported-by: Zheng Yan <zheng.z.yan@linux.intel.com>
    Acked-by: Stephane Eranian <eranian@google.com>
    Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Link: http://lkml.kernel.org/r/1338903031.28282.175.camel@twins
    Signed-off-by: Ingo Molnar <mingo@kernel.org>

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index e049d6d..cb60838 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1496,6 +1496,7 @@ static struct cpu_hw_events *allocate_fake_cpuc(void)
 		if (!cpuc->shared_regs)
 			goto error;
 	}
+	cpuc->is_fake = 1;
 	return cpuc;
 error:
 	free_fake_cpuc(cpuc);
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 6638aaf..83794d8 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -117,6 +117,7 @@ struct cpu_hw_events {
 	struct perf_event	*event_list[X86_PMC_IDX_MAX]; /* in enabled order */
 
 	unsigned int		group_flag;
+	int			is_fake;
 
 	/*
 	 * Intel DebugStore bits
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 166546e..965baa2 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1119,27 +1119,33 @@ intel_bts_constraints(struct perf_event *event)
 	return NULL;
 }
 
-static bool intel_try_alt_er(struct perf_event *event, int orig_idx)
+static int intel_alt_er(int idx)
 {
 	if (!(x86_pmu.er_flags & ERF_HAS_RSP_1))
-		return false;
+		return idx;
 
-	if (event->hw.extra_reg.idx == EXTRA_REG_RSP_0) {
-		event->hw.config &= ~INTEL_ARCH_EVENT_MASK;
-		event->hw.config |= 0x01bb;
-		event->hw.extra_reg.idx = EXTRA_REG_RSP_1;
-		event->hw.extra_reg.reg = MSR_OFFCORE_RSP_1;
-	} else if (event->hw.extra_reg.idx == EXTRA_REG_RSP_1) {
+	if (idx == EXTRA_REG_RSP_0)
+		return EXTRA_REG_RSP_1;
+
+	if (idx == EXTRA_REG_RSP_1)
+		return EXTRA_REG_RSP_0;
+
+	return idx;
+}
+
+static void intel_fixup_er(struct perf_event *event, int idx)
+{
+	event->hw.extra_reg.idx = idx;
+
+	if (idx == EXTRA_REG_RSP_0) {
 		event->hw.config &= ~INTEL_ARCH_EVENT_MASK;
 		event->hw.config |= 0x01b7;
-		event->hw.extra_reg.idx = EXTRA_REG_RSP_0;
 		event->hw.extra_reg.reg = MSR_OFFCORE_RSP_0;
+	} else if (idx == EXTRA_REG_RSP_1) {
+		event->hw.config &= ~INTEL_ARCH_EVENT_MASK;
+		event->hw.config |= 0x01bb;
+		event->hw.extra_reg.reg = MSR_OFFCORE_RSP_1;
 	}
-
-	if (event->hw.extra_reg.idx == orig_idx)
-		return false;
-
-	return true;
 }
 
 /*
@@ -1157,14 +1163,18 @@ __intel_shared_reg_get_constraints(struct cpu_hw_events *cpuc,
 	struct event_constraint *c = &emptyconstraint;
 	struct er_account *era;
 	unsigned long flags;
-	int orig_idx = reg->idx;
+	int idx = reg->idx;
 
-	/* already allocated shared msr */
-	if (reg->alloc)
+	/*
+	 * reg->alloc can be set due to existing state, so for fake cpuc we
+	 * need to ignore this, otherwise we might fail to allocate proper fake
+	 * state for this extra reg constraint. Also see the comment below.
+	 */
+	if (reg->alloc && !cpuc->is_fake)
 		return NULL; /* call x86_get_event_constraint() */
 
 again:
-	era = &cpuc->shared_regs->regs[reg->idx];
+	era = &cpuc->shared_regs->regs[idx];
 	/*
 	 * we use spin_lock_irqsave() to avoid lockdep issues when
 	 * passing a fake cpuc
@@ -1173,6 +1183,29 @@ __intel_shared_reg_get_constraints(struct cpu_hw_events *cpuc,
 
 	if (!atomic_read(&era->ref) || era->config == reg->config) {
 
+		/*
+		 * If its a fake cpuc -- as per validate_{group,event}() we
+		 * shouldn't touch event state and we can avoid doing so
+		 * since both will only call get_event_constraints() once
+		 * on each event, this avoids the need for reg->alloc.
+		 *
+		 * Not doing the ER fixup will only result in era->reg being
+		 * wrong, but since we won't actually try and program hardware
+		 * this isn't a problem either.
+		 */
+		if (!cpuc->is_fake) {
+			if (idx != reg->idx)
+				intel_fixup_er(event, idx);
+
+			/*
+			 * x86_schedule_events() can call get_event_constraints()
+			 * multiple times on events in the case of incremental
+			 * scheduling(). reg->alloc ensures we only do the ER
+			 * allocation once.
+			 */
+			reg->alloc = 1;
+		}
+
 		/* lock in msr value */
 		era->config = reg->config;
 		era->reg = reg->reg;
@@ -1180,17 +1213,17 @@ __intel_shared_reg_get_constraints(struct cpu_hw_events *cpuc,
 		/* one more user */
 		atomic_inc(&era->ref);
 
-		/* no need to reallocate during incremental event scheduling */
-		reg->alloc = 1;
-
 		/*
 		 * need to call x86_get_event_constraint()
 		 * to check if associated event has constraints
 		 */
 		c = NULL;
-	} else if (intel_try_alt_er(event, orig_idx)) {
-		raw_spin_unlock_irqrestore(&era->lock, flags);
-		goto again;
+	} else {
+		idx = intel_alt_er(idx);
+		if (idx != reg->idx) {
+			raw_spin_unlock_irqrestore(&era->lock, flags);
+			goto again;
+		}
 	}
 	raw_spin_unlock_irqrestore(&era->lock, flags);
 
@@ -1204,11 +1237,14 @@ __intel_shared_reg_put_constraints(struct cpu_hw_events *cpuc,
 	struct er_account *era;
 
 	/*
-	 * only put constraint if extra reg was actually
-	 * allocated. Also takes care of event which do
-	 * not use an extra shared reg
+	 * Only put constraint if extra reg was actually allocated. Also takes
+	 * care of event which do not use an extra shared reg.
+	 *
+	 * Also, if this is a fake cpuc we shouldn't touch any event state
+	 * (reg->alloc) and we don't care about leaving inconsistent cpuc state
+	 * either since it'll be thrown out.
 	 */
-	if (!reg->alloc)
+	if (!reg->alloc || cpuc->is_fake)
 		return;
 
 	era = &cpuc->shared_regs->regs[reg->idx];

