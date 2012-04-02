Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412Ab2DBSVd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 14:21:33 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:46812
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754265Ab2DBSUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 14:20:06 -0400
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M1V6X7-02-33S-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 06/12] perf/x86-ibs: Precise event sampling with IBS for AMD CPUs
Date: Mon, 2 Apr 2012 20:19:12 +0200
Message-ID: <1333390758-10893-7-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <1333390758-10893-1-git-send-email-robert.richter@amd.com>
References: <1333390758-10893-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for precise event sampling with IBS. There are
two counting modes to count either cycles or micro-ops. If the
corresponding performance counter events (hw events) are setup with
the precise flag set, the request is redirected to the ibs pmu:

 perf record -a -e cpu-cycles:p ...    # use ibs op counting cycle count
 perf record -a -e r076:p ...          # same as -e cpu-cycles:p
 perf record -a -e r0C1:p ...          # use ibs op counting micro-ops

Each IBS sample contains a linear address that points to the
instruction that was causing the sample to trigger. With ibs we have
skid 0.

Though the skid is 0, we map IBS sampling to following precise levels:

 1: RIP taken from IBS sample or (if invalid) from stack
 2: RIP always taken from IBS sample, samples with an invalid rip
    are dropped. Thus samples of an event containing two precise
    modifiers (e.g. r076:pp) only contain (precise) addresses
    detected with IBS.

Precise level 3 is reserved for other purposes in the future.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_event_amd.c     |    7 +++-
 arch/x86/kernel/cpu/perf_event_amd_ibs.c |   71 +++++++++++++++++++++++++++++-
 2 files changed, 75 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index 95e7fe1..4be3463 100644
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
index 0321b64..05a359f 100644
--- a/arch/x86/kernel/cpu/perf_event_amd_ibs.c
+++ b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
@@ -145,17 +145,82 @@ static struct perf_ibs *get_ibs_pmu(int type)
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
+ * We map IBS sampling to following precise levels:
+ *
+ *  1: RIP taken from IBS sample or (if invalid) from stack
+ *  2: RIP always taken from IBS sample, samples with an invalid rip
+ *     are dropped. Thus samples of an event containing two precise
+ *     modifiers (e.g. r076:pp) only contain (precise) addresses
+ *     detected with IBS.
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
 
@@ -439,6 +504,8 @@ static int perf_ibs_handle_irq(struct perf_ibs *perf_ibs, struct pt_regs *iregs)
 	regs = *iregs;
 	if (!check_rip || !(ibs_data.regs[2] & IBS_RIP_INVALID))
 		instruction_pointer_set(&regs, ibs_data.regs[1]);
+	else if (event->attr.precise_ip > 1)
+		goto out;	/* drop non-precise samples */
 
 	if (event->attr.sample_type & PERF_SAMPLE_RAW) {
 		raw.size = sizeof(u32) + ibs_data.size;
-- 
1.7.8.4


