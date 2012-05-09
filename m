Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759707Ab2EIOhh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 10:37:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41152 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757290Ab2EIOhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 10:37:36 -0400
Date: Wed, 9 May 2012 07:37:22 -0700
From: tip-bot for Robert Richter <robert.richter@amd.com>
Message-ID: <tip-c9574fe0bdb9ac9a2698e02a712088ce8431e9f8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        robert.richter@amd.com, a.p.zijlstra@chello.nl, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        robert.richter@amd.com, a.p.zijlstra@chello.nl, tglx@linutronix.de
In-Reply-To: <1333390758-10893-11-git-send-email-robert.richter@amd.com>
References: <1333390758-10893-11-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86-ibs:
  Implement workaround for IBS erratum #420
Git-Commit-ID: c9574fe0bdb9ac9a2698e02a712088ce8431e9f8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 09 May 2012 07:37:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c9574fe0bdb9ac9a2698e02a712088ce8431e9f8
Gitweb:     http://git.kernel.org/tip/c9574fe0bdb9ac9a2698e02a712088ce8431e9f8
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Mon, 2 Apr 2012 20:19:16 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 May 2012 15:23:16 +0200

perf/x86-ibs: Implement workaround for IBS erratum #420

When disabling ibs there might be the case where hardware continuously
generates interrupts. This is described in erratum #420 (Instruction-
Based Sampling Engine May Generate Interrupt that Cannot Be Cleared).
To avoid this we must clear the counter mask first and then clear the
enable bit. This patch implements this.

See Revision Guide for AMD Family 10h Processors, Publication #41322.

Note: We now keep track of the last read ibs config value which is
then used to disable ibs. To update the config value we pass now a
pointer to the functions reading it.

Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1333390758-10893-11-git-send-email-robert.richter@amd.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_amd_ibs.c |   62 +++++++++++++++++++-----------
 1 files changed, 39 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_amd_ibs.c b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
index cb51a3e..b14e711 100644
--- a/arch/x86/kernel/cpu/perf_event_amd_ibs.c
+++ b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
@@ -291,20 +291,36 @@ static u64 get_ibs_op_count(u64 config)
 
 static void
 perf_ibs_event_update(struct perf_ibs *perf_ibs, struct perf_event *event,
-		      u64 config)
+		      u64 *config)
 {
-	u64 count = perf_ibs->get_count(config);
+	u64 count = perf_ibs->get_count(*config);
 
 	while (!perf_event_try_update(event, count, 20)) {
-		rdmsrl(event->hw.config_base, config);
-		count = perf_ibs->get_count(config);
+		rdmsrl(event->hw.config_base, *config);
+		count = perf_ibs->get_count(*config);
 	}
 }
 
-/* Note: The enable mask must be encoded in the config argument. */
-static inline void perf_ibs_enable_event(struct hw_perf_event *hwc, u64 config)
+static inline void perf_ibs_enable_event(struct perf_ibs *perf_ibs,
+					 struct hw_perf_event *hwc, u64 config)
 {
-	wrmsrl(hwc->config_base, hwc->config | config);
+	wrmsrl(hwc->config_base, hwc->config | config | perf_ibs->enable_mask);
+}
+
+/*
+ * Erratum #420 Instruction-Based Sampling Engine May Generate
+ * Interrupt that Cannot Be Cleared:
+ *
+ * Must clear counter mask first, then clear the enable bit. See
+ * Revision Guide for AMD Family 10h Processors, Publication #41322.
+ */
+static inline void perf_ibs_disable_event(struct perf_ibs *perf_ibs,
+					  struct hw_perf_event *hwc, u64 config)
+{
+	config &= ~perf_ibs->cnt_mask;
+	wrmsrl(hwc->config_base, config);
+	config &= ~perf_ibs->enable_mask;
+	wrmsrl(hwc->config_base, config);
 }
 
 /*
@@ -318,7 +334,7 @@ static void perf_ibs_start(struct perf_event *event, int flags)
 	struct hw_perf_event *hwc = &event->hw;
 	struct perf_ibs *perf_ibs = container_of(event->pmu, struct perf_ibs, pmu);
 	struct cpu_perf_ibs *pcpu = this_cpu_ptr(perf_ibs->pcpu);
-	u64 config;
+	u64 period;
 
 	if (WARN_ON_ONCE(!(hwc->state & PERF_HES_STOPPED)))
 		return;
@@ -326,10 +342,9 @@ static void perf_ibs_start(struct perf_event *event, int flags)
 	WARN_ON_ONCE(!(hwc->state & PERF_HES_UPTODATE));
 	hwc->state = 0;
 
-	perf_ibs_set_period(perf_ibs, hwc, &config);
-	config = (config >> 4) | perf_ibs->enable_mask;
+	perf_ibs_set_period(perf_ibs, hwc, &period);
 	set_bit(IBS_STARTED, pcpu->state);
-	perf_ibs_enable_event(hwc, config);
+	perf_ibs_enable_event(perf_ibs, hwc, period >> 4);
 
 	perf_event_update_userpage(event);
 }
@@ -339,7 +354,7 @@ static void perf_ibs_stop(struct perf_event *event, int flags)
 	struct hw_perf_event *hwc = &event->hw;
 	struct perf_ibs *perf_ibs = container_of(event->pmu, struct perf_ibs, pmu);
 	struct cpu_perf_ibs *pcpu = this_cpu_ptr(perf_ibs->pcpu);
-	u64 val;
+	u64 config;
 	int stopping;
 
 	stopping = test_and_clear_bit(IBS_STARTED, pcpu->state);
@@ -347,12 +362,11 @@ static void perf_ibs_stop(struct perf_event *event, int flags)
 	if (!stopping && (hwc->state & PERF_HES_UPTODATE))
 		return;
 
-	rdmsrl(hwc->config_base, val);
+	rdmsrl(hwc->config_base, config);
 
 	if (stopping) {
 		set_bit(IBS_STOPPING, pcpu->state);
-		val &= ~perf_ibs->enable_mask;
-		wrmsrl(hwc->config_base, val);
+		perf_ibs_disable_event(perf_ibs, hwc, config);
 		WARN_ON_ONCE(hwc->state & PERF_HES_STOPPED);
 		hwc->state |= PERF_HES_STOPPED;
 	}
@@ -360,7 +374,7 @@ static void perf_ibs_stop(struct perf_event *event, int flags)
 	if (hwc->state & PERF_HES_UPTODATE)
 		return;
 
-	perf_ibs_event_update(perf_ibs, event, val);
+	perf_ibs_event_update(perf_ibs, event, &config);
 	hwc->state |= PERF_HES_UPTODATE;
 }
 
@@ -456,7 +470,7 @@ static int perf_ibs_handle_irq(struct perf_ibs *perf_ibs, struct pt_regs *iregs)
 	struct perf_ibs_data ibs_data;
 	int offset, size, check_rip, offset_max, throttle = 0;
 	unsigned int msr;
-	u64 *buf, config;
+	u64 *buf, *config, period;
 
 	if (!test_bit(IBS_STARTED, pcpu->state)) {
 		/* Catch spurious interrupts after stopping IBS: */
@@ -477,15 +491,15 @@ static int perf_ibs_handle_irq(struct perf_ibs *perf_ibs, struct pt_regs *iregs)
 	 * supported in all cpus. As this triggered an interrupt, we
 	 * set the current count to the max count.
 	 */
-	config = ibs_data.regs[0];
+	config = &ibs_data.regs[0];
 	if (perf_ibs == &perf_ibs_op && !(ibs_caps & IBS_CAPS_RDWROPCNT)) {
-		config &= ~IBS_OP_CUR_CNT;
-		config |= (config & IBS_OP_MAX_CNT) << 36;
+		*config &= ~IBS_OP_CUR_CNT;
+		*config |= (*config & IBS_OP_MAX_CNT) << 36;
 	}
 
 	perf_ibs_event_update(perf_ibs, event, config);
 	perf_sample_data_init(&data, 0, hwc->last_period);
-	if (!perf_ibs_set_period(perf_ibs, hwc, &config))
+	if (!perf_ibs_set_period(perf_ibs, hwc, &period))
 		goto out;	/* no sw counter overflow */
 
 	ibs_data.caps = ibs_caps;
@@ -523,8 +537,10 @@ static int perf_ibs_handle_irq(struct perf_ibs *perf_ibs, struct pt_regs *iregs)
 
 	throttle = perf_event_overflow(event, &data, &regs);
 out:
-	config = (config >> 4) | (throttle ? 0 : perf_ibs->enable_mask);
-	perf_ibs_enable_event(hwc, config);
+	if (throttle)
+		perf_ibs_disable_event(perf_ibs, hwc, *config);
+	else
+		perf_ibs_enable_event(perf_ibs, hwc, period >> 4);
 
 	perf_event_update_userpage(event);
 
