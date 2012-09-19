Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756Ab2ISRHM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 13:07:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53980 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756429Ab2ISRHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 13:07:08 -0400
Date: Wed, 19 Sep 2012 10:06:55 -0700
From: tip-bot for Stephane Eranian <eranian@google.com>
Message-ID: <tip-20a36e39d59757252edbbdcf9574ae2998733ce9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <20120910230701.GA5898@quad>
References: <20120910230701.GA5898@quad>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf/x86: Fix Intel Ivy Bridge support
Git-Commit-ID: 20a36e39d59757252edbbdcf9574ae2998733ce9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 19 Sep 2012 10:07:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  20a36e39d59757252edbbdcf9574ae2998733ce9
Gitweb:     http://git.kernel.org/tip/20a36e39d59757252edbbdcf9574ae2998733ce9
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Tue, 11 Sep 2012 01:07:01 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 19 Sep 2012 17:28:47 +0200

perf/x86: Fix Intel Ivy Bridge support

This patch updates the existing Intel IvyBridge (model 58)
support with proper PEBS event constraints. It cannot reuse
the same as SandyBridge because some events (0xd3) are
specific to IvyBridge.

Also there is no UOPS_DISPATCHED.THREAD on IVB, so do not
populate the PERF_COUNT_HW_STALLED_CYCLES_BACKEND mapping.

Signed-off-by: Stephane Eranian <eranian@google.com>
Cc: peterz@infradead.org
Cc: ak@linux.intel.com
Link: http://lkml.kernel.org/r/20120910230701.GA5898@quad
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event.h          |    2 ++
 arch/x86/kernel/cpu/perf_event_intel.c    |   24 +++++++++++++++++++++++-
 arch/x86/kernel/cpu/perf_event_intel_ds.c |   14 ++++++++++++++
 3 files changed, 39 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 6605a81..8b6defe 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -586,6 +586,8 @@ extern struct event_constraint intel_westmere_pebs_event_constraints[];
 
 extern struct event_constraint intel_snb_pebs_event_constraints[];
 
+extern struct event_constraint intel_ivb_pebs_event_constraints[];
+
 struct event_constraint *intel_pebs_constraints(struct perf_event *event);
 
 void intel_pmu_pebs_enable(struct perf_event *event);
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 0d3d63a..6bca492 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -2048,7 +2048,6 @@ __init int intel_pmu_init(void)
 	case 42: /* SandyBridge */
 	case 45: /* SandyBridge, "Romely-EP" */
 		x86_add_quirk(intel_sandybridge_quirk);
-	case 58: /* IvyBridge */
 		memcpy(hw_cache_event_ids, snb_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
 		memcpy(hw_cache_extra_regs, snb_hw_cache_extra_regs,
@@ -2073,6 +2072,29 @@ __init int intel_pmu_init(void)
 
 		pr_cont("SandyBridge events, ");
 		break;
+	case 58: /* IvyBridge */
+		memcpy(hw_cache_event_ids, snb_hw_cache_event_ids,
+		       sizeof(hw_cache_event_ids));
+		memcpy(hw_cache_extra_regs, snb_hw_cache_extra_regs,
+		       sizeof(hw_cache_extra_regs));
+
+		intel_pmu_lbr_init_snb();
+
+		x86_pmu.event_constraints = intel_snb_event_constraints;
+		x86_pmu.pebs_constraints = intel_ivb_pebs_event_constraints;
+		x86_pmu.pebs_aliases = intel_pebs_aliases_snb;
+		x86_pmu.extra_regs = intel_snb_extra_regs;
+		/* all extra regs are per-cpu when HT is on */
+		x86_pmu.er_flags |= ERF_HAS_RSP_1;
+		x86_pmu.er_flags |= ERF_NO_HT_SHARING;
+
+		/* UOPS_ISSUED.ANY,c=1,i=1 to count stall cycles */
+		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND] =
+			X86_CONFIG(.event=0x0e, .umask=0x01, .inv=1, .cmask=1);
+
+		pr_cont("IvyBridge events, ");
+		break;
+
 
 	default:
 		switch (x86_pmu.version) {
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index e38d97b..826054a 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -407,6 +407,20 @@ struct event_constraint intel_snb_pebs_event_constraints[] = {
 	EVENT_CONSTRAINT_END
 };
 
+struct event_constraint intel_ivb_pebs_event_constraints[] = {
+        INTEL_UEVENT_CONSTRAINT(0x01c0, 0x2), /* INST_RETIRED.PRECDIST */
+        INTEL_UEVENT_CONSTRAINT(0x01c2, 0xf), /* UOPS_RETIRED.ALL */
+        INTEL_UEVENT_CONSTRAINT(0x02c2, 0xf), /* UOPS_RETIRED.RETIRE_SLOTS */
+        INTEL_EVENT_CONSTRAINT(0xc4, 0xf),    /* BR_INST_RETIRED.* */
+        INTEL_EVENT_CONSTRAINT(0xc5, 0xf),    /* BR_MISP_RETIRED.* */
+        INTEL_EVENT_CONSTRAINT(0xcd, 0x8),    /* MEM_TRANS_RETIRED.* */
+        INTEL_EVENT_CONSTRAINT(0xd0, 0xf),    /* MEM_UOP_RETIRED.* */
+        INTEL_EVENT_CONSTRAINT(0xd1, 0xf),    /* MEM_LOAD_UOPS_RETIRED.* */
+        INTEL_EVENT_CONSTRAINT(0xd2, 0xf),    /* MEM_LOAD_UOPS_LLC_HIT_RETIRED.* */
+        INTEL_EVENT_CONSTRAINT(0xd3, 0xf),    /* MEM_LOAD_UOPS_LLC_MISS_RETIRED.* */
+        EVENT_CONSTRAINT_END
+};
+
 struct event_constraint *intel_pebs_constraints(struct perf_event *event)
 {
 	struct event_constraint *c;
