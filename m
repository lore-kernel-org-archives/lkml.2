Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932152Ab2EIOeU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 10:34:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41086 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758033Ab2EIOeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 10:34:18 -0400
Date: Wed, 9 May 2012 07:34:03 -0700
From: tip-bot for Robert Richter <robert.richter@amd.com>
Message-ID: <tip-450bbd493d436f9eadd1b7828158f37559f26674@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        robert.richter@amd.com, a.p.zijlstra@chello.nl, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        robert.richter@amd.com, a.p.zijlstra@chello.nl, tglx@linutronix.de
In-Reply-To: <20120502103309.GP18810@erda.amd.com>
References: <20120502103309.GP18810@erda.amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86-ibs:
  Precise event sampling with IBS for AMD CPUs
Git-Commit-ID: 450bbd493d436f9eadd1b7828158f37559f26674
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 09 May 2012 07:34:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  450bbd493d436f9eadd1b7828158f37559f26674
Gitweb:     http://git.kernel.org/tip/450bbd493d436f9eadd1b7828158f37559f26674
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Mon, 12 Mar 2012 12:54:32 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 May 2012 15:23:14 +0200

perf/x86-ibs: Precise event sampling with IBS for AMD CPUs

This patch adds support for precise event sampling with IBS. There are
two counting modes to count either cycles or micro-ops. If the
corresponding performance counter events (hw events) are setup with
the precise flag set, the request is redirected to the ibs pmu:

 perf record -a -e cpu-cycles:p ...    # use ibs op counting cycle count
 perf record -a -e r076:p ...          # same as -e cpu-cycles:p
 perf record -a -e r0C1:p ...          # use ibs op counting micro-ops

Each ibs sample contains a linear address that points to the
instruction that was causing the sample to trigger. With ibs we have
skid 0. Thus, ibs supports precise levels 1 and 2. Samples are marked
with the PERF_EFLAGS_EXACT flag set. In rare cases the rip is invalid
when IBS was not able to record the rip correctly. Then the
PERF_EFLAGS_EXACT flag is cleared and the rip is taken from pt_regs.

V2:
* don't drop samples in precise level 2 if rip is invalid, instead
  support the PERF_EFLAGS_EXACT flag

Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20120502103309.GP18810@erda.amd.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_amd.c     |    7 +++-
 arch/x86/kernel/cpu/perf_event_amd_ibs.c |   73 ++++++++++++++++++++++++++++-
 2 files changed, 76 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index 589286f..6565226 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -134,8 +134,13 @@ static u64 amd_pmu_event_map(int hw_event)
 
 static int amd_pmu_hw_config(struct perf_event *event)
 {
-	int ret = x86_pmu_hw_config(event);
+	int ret;
 
+	/* pass precise event sampling to ibs: */
+	if (event->attr.precise_ip && get_ibs_caps())
+		return -ENOENT;
+
+	ret = x86_pmu_hw_config(event);
 	if (ret)
 		return ret;
 
diff --git a/arch/x86/kernel/cpu/perf_event_amd_ibs.c b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
index cc1f329..34dfa85 100644
--- a/arch/x86/kernel/cpu/perf_event_amd_ibs.c
+++ b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
@@ -145,17 +145,80 @@ static struct perf_ibs *get_ibs_pmu(int type)
 	return NULL;
 }
 
+/*
+ * Use IBS for precise event sampling:
+ *
+ *  perf record -a -e cpu-cycles:p ...    # use ibs op counting cycle count
+ *  perf record -a -e r076:p ...          # same as -e cpu-cycles:p
+ *  perf record -a -e r0C1:p ...          # use ibs op counting micro-ops
+ *
+ * IbsOpCntCtl (bit 19) of IBS Execution Control Register (IbsOpCtl,
+ * MSRC001_1033) is used to select either cycle or micro-ops counting
+ * mode.
+ *
+ * The rip of IBS samples has skid 0. Thus, IBS supports precise
+ * levels 1 and 2 and the PERF_EFLAGS_EXACT is set. In rare cases the
+ * rip is invalid when IBS was not able to record the rip correctly.
+ * We clear PERF_EFLAGS_EXACT and take the rip from pt_regs then.
+ *
+ */
+static int perf_ibs_precise_event(struct perf_event *event, u64 *config)
+{
+	switch (event->attr.precise_ip) {
+	case 0:
+		return -ENOENT;
+	case 1:
+	case 2:
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	switch (event->attr.type) {
+	case PERF_TYPE_HARDWARE:
+		switch (event->attr.config) {
+		case PERF_COUNT_HW_CPU_CYCLES:
+			*config = 0;
+			return 0;
+		}
+		break;
+	case PERF_TYPE_RAW:
+		switch (event->attr.config) {
+		case 0x0076:
+			*config = 0;
+			return 0;
+		case 0x00C1:
+			*config = IBS_OP_CNT_CTL;
+			return 0;
+		}
+		break;
+	default:
+		return -ENOENT;
+	}
+
+	return -EOPNOTSUPP;
+}
+
 static int perf_ibs_init(struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
 	struct perf_ibs *perf_ibs;
 	u64 max_cnt, config;
+	int ret;
 
 	perf_ibs = get_ibs_pmu(event->attr.type);
-	if (!perf_ibs)
+	if (perf_ibs) {
+		config = event->attr.config;
+	} else {
+		perf_ibs = &perf_ibs_op;
+		ret = perf_ibs_precise_event(event, &config);
+		if (ret)
+			return ret;
+	}
+
+	if (event->pmu != &perf_ibs->pmu)
 		return -ENOENT;
 
-	config = event->attr.config;
 	if (config & ~perf_ibs->config_mask)
 		return -EINVAL;
 
@@ -437,8 +500,12 @@ static int perf_ibs_handle_irq(struct perf_ibs *perf_ibs, struct pt_regs *iregs)
 	ibs_data.size = sizeof(u64) * size;
 
 	regs = *iregs;
-	if (!check_rip || !(ibs_data.regs[2] & IBS_RIP_INVALID))
+	if (check_rip && (ibs_data.regs[2] & IBS_RIP_INVALID)) {
+		regs.flags &= ~PERF_EFLAGS_EXACT;
+	} else {
 		instruction_pointer_set(&regs, ibs_data.regs[1]);
+		regs.flags |= PERF_EFLAGS_EXACT;
+	}
 
 	if (event->attr.sample_type & PERF_SAMPLE_RAW) {
 		raw.size = sizeof(u32) + ibs_data.size;
