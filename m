Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749Ab0JVNEt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 09:04:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:40443 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756352Ab0JVNEs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 09:04:48 -0400
Date: Fri, 22 Oct 2010 13:04:06 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20101019134808.354429461@chello.nl>
References: <20101019134808.354429461@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf, x86: Less disastrous PEBS/BTS buffer allocation failure
Message-ID: <tip-6809b6ea73f7291f2e495d40397f1172c9caa77e@git.kernel.org>
Git-Commit-ID: 6809b6ea73f7291f2e495d40397f1172c9caa77e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 22 Oct 2010 13:04:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6809b6ea73f7291f2e495d40397f1172c9caa77e
Gitweb:     http://git.kernel.org/tip/6809b6ea73f7291f2e495d40397f1172c9caa77e
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 19 Oct 2010 14:22:50 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 22 Oct 2010 14:18:26 +0200

perf, x86: Less disastrous PEBS/BTS buffer allocation failure

Currently PEBS/BTS buffers are allocated when we instantiate the first
event, when this fails everything fails.

This is a problem because esp. BTS tries to allocate a rather large
buffer (64K), which can easily fail.

This patch changes the logic such that when either buffer allocation
fails, we simply don't allow events that would use these facilities,
but continue functioning for all other events.

This logic comes from a much larger patch proposed by Stephane.

Suggested-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Stephane Eranian <eranian@google.com>
LKML-Reference: <20101019134808.354429461@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c          |    5 +-
 arch/x86/kernel/cpu/perf_event_intel_ds.c |   58 ++++++++++++++++++++++-------
 2 files changed, 47 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index f369c53..61e78f6 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -238,6 +238,7 @@ struct x86_pmu {
 	 * Intel DebugStore bits
 	 */
 	int		bts, pebs;
+	int		bts_active, pebs_active;
 	int		pebs_record_size;
 	void		(*drain_pebs)(struct pt_regs *regs);
 	struct event_constraint *pebs_constraints;
@@ -478,7 +479,7 @@ static int x86_setup_perfctr(struct perf_event *event)
 	if ((attr->config == PERF_COUNT_HW_BRANCH_INSTRUCTIONS) &&
 	    (hwc->sample_period == 1)) {
 		/* BTS is not supported by this architecture. */
-		if (!x86_pmu.bts)
+		if (!x86_pmu.bts_active)
 			return -EOPNOTSUPP;
 
 		/* BTS is currently only allowed for user-mode. */
@@ -497,7 +498,7 @@ static int x86_pmu_hw_config(struct perf_event *event)
 		int precise = 0;
 
 		/* Support for constant skid */
-		if (x86_pmu.pebs) {
+		if (x86_pmu.pebs_active) {
 			precise++;
 
 			/* Support for IP fixup */
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 3c86f4d..05c7db6 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -193,36 +193,66 @@ static void release_ds_buffers(void)
 
 static int reserve_ds_buffers(void)
 {
-	int cpu, err = 0;
+	int bts_err = 0, pebs_err = 0;
+	int cpu;
+
+	x86_pmu.bts_active = 0;
+	x86_pmu.pebs_active = 0;
 
 	if (!x86_pmu.bts && !x86_pmu.pebs)
 		return 0;
 
+	if (!x86_pmu.bts)
+		bts_err = 1;
+
+	if (!x86_pmu.pebs)
+		pebs_err = 1;
+
 	get_online_cpus();
 
 	for_each_possible_cpu(cpu) {
-		if (alloc_ds_buffer(cpu))
-			break;
+		if (alloc_ds_buffer(cpu)) {
+			bts_err = 1;
+			pebs_err = 1;
+		}
 
-		if (alloc_bts_buffer(cpu))
-			break;
+		if (!bts_err && alloc_bts_buffer(cpu))
+			bts_err = 1;
+
+		if (!pebs_err && alloc_pebs_buffer(cpu))
+			pebs_err = 1;
 
-		if (alloc_pebs_buffer(cpu))
+		if (bts_err && pebs_err)
 			break;
+	}
+
+	if (bts_err) {
+		for_each_possible_cpu(cpu)
+			release_bts_buffer(cpu);
+	}
 
-		err = 0;
+	if (pebs_err) {
+		for_each_possible_cpu(cpu)
+			release_pebs_buffer(cpu);
 	}
 
-	if (err)
-		release_ds_buffers();
-	else {
+	if (bts_err && pebs_err) {
+		for_each_possible_cpu(cpu)
+			release_ds_buffer(cpu);
+	} else {
+		if (x86_pmu.bts && !bts_err)
+			x86_pmu.bts_active = 1;
+
+		if (x86_pmu.pebs && !pebs_err)
+			x86_pmu.pebs_active = 1;
+
 		for_each_online_cpu(cpu)
 			init_debug_store_on_cpu(cpu);
 	}
 
 	put_online_cpus();
 
-	return err;
+	return 0;
 }
 
 /*
@@ -287,7 +317,7 @@ static int intel_pmu_drain_bts_buffer(void)
 	if (!event)
 		return 0;
 
-	if (!ds)
+	if (!x86_pmu.bts_active)
 		return 0;
 
 	at  = (struct bts_record *)(unsigned long)ds->bts_buffer_base;
@@ -557,7 +587,7 @@ static void intel_pmu_drain_pebs_core(struct pt_regs *iregs)
 	struct pebs_record_core *at, *top;
 	int n;
 
-	if (!ds || !x86_pmu.pebs)
+	if (!x86_pmu.pebs_active)
 		return;
 
 	at  = (struct pebs_record_core *)(unsigned long)ds->pebs_buffer_base;
@@ -599,7 +629,7 @@ static void intel_pmu_drain_pebs_nhm(struct pt_regs *iregs)
 	u64 status = 0;
 	int bit, n;
 
-	if (!ds || !x86_pmu.pebs)
+	if (!x86_pmu.pebs_active)
 		return;
 
 	at  = (struct pebs_record_nhm *)(unsigned long)ds->pebs_buffer_base;
