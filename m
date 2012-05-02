Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801Ab2EBKdW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 06:33:22 -0400
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:35087
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752356Ab2EBKdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 06:33:21 -0400
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M3E5BB-02-2PT-02
X-M-MSG: 
Date: Wed, 2 May 2012 12:33:09 +0200
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] perf/x86-ibs: Precise event sampling with IBS for AMD CPUs
Message-ID: <20120502103309.GP18810@erda.amd.com>
References: <1333390758-10893-1-git-send-email-robert.richter@amd.com>
 <1333390758-10893-7-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1333390758-10893-7-git-send-email-robert.richter@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updated version. Level 1 and 2 are handled the same way now. Don't
drop samples in precise level 2 if rip is invalid, instead support the
PERF_EFLAGS_EXACT flag.

No changes in other patches of

 [PATCH 00/12] perf/x86-ibs: Precise event sampling with IBS for AMD CPUs

-Robert



>From 6d646cefdea9958c3401110caecc958b41f6e84d Mon Sep 17 00:00:00 2001
From: Robert Richter <robert.richter@amd.com>
Date: Mon, 12 Mar 2012 12:54:32 +0100
Subject: [PATCH] perf/x86-ibs: Precise event sampling with IBS for AMD CPUs

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
---
 arch/x86/kernel/cpu/perf_event_amd.c     |    7 +++-
 arch/x86/kernel/cpu/perf_event_amd_ibs.c |   73 ++++++++++++++++++++++++++++-
 2 files changed, 76 insertions(+), 4 deletions(-)

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
index 0321b64..117b0aa 100644
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
-- 
1.7.8.4



-- 
Advanced Micro Devices, Inc.
Operating System Research Center

