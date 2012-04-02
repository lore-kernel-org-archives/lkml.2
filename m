Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344Ab2DBSUK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 14:20:10 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:41543
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754153Ab2DBSUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 14:20:04 -0400
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M1V6X6-02-33P-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 12/12] perf/x86-ibs: Fix usage of IBS op current count
Date: Mon, 2 Apr 2012 20:19:18 +0200
Message-ID: <1333390758-10893-13-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <1333390758-10893-1-git-send-email-robert.richter@amd.com>
References: <1333390758-10893-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The value of IbsOpCurCnt rolls over when it reaches IbsOpMaxCnt. Thus,
it is reset to zero by hardware. To get the correct count we need to
add the max count to it in case we received an ibs sample (valid bit
set).

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_event_amd_ibs.c |   33 +++++++++++++++++++----------
 1 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_amd_ibs.c b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
index b44aa63..0dfe952 100644
--- a/arch/x86/kernel/cpu/perf_event_amd_ibs.c
+++ b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
@@ -288,7 +288,15 @@ static u64 get_ibs_fetch_count(u64 config)
 
 static u64 get_ibs_op_count(u64 config)
 {
-	return (config & IBS_OP_CUR_CNT) >> 32;
+	u64 count = 0;
+
+	if (config & IBS_OP_VAL)
+		count += (config & IBS_OP_MAX_CNT) << 4; /* cnt rolled over */
+
+	if (ibs_caps & IBS_CAPS_RDWROPCNT)
+		count += (config & IBS_OP_CUR_CNT) >> 32;
+
+	return count;
 }
 
 static void
@@ -297,7 +305,12 @@ perf_ibs_event_update(struct perf_ibs *perf_ibs, struct perf_event *event,
 {
 	u64 count = perf_ibs->get_count(*config);
 
-	while (!perf_event_try_update(event, count, 20)) {
+	/*
+	 * Set width to 64 since we do not overflow on max width but
+	 * instead on max count. In perf_ibs_set_period() we clear
+	 * prev count manually on overflow.
+	 */
+	while (!perf_event_try_update(event, count, 64)) {
 		rdmsrl(event->hw.config_base, *config);
 		count = perf_ibs->get_count(*config);
 	}
@@ -376,6 +389,12 @@ static void perf_ibs_stop(struct perf_event *event, int flags)
 	if (hwc->state & PERF_HES_UPTODATE)
 		return;
 
+	/*
+	 * Clear valid bit to not count rollovers on update, rollovers
+	 * are only updated in the irq handler.
+	 */
+	config &= ~perf_ibs->valid_mask;
+
 	perf_ibs_event_update(perf_ibs, event, &config);
 	hwc->state |= PERF_HES_UPTODATE;
 }
@@ -490,17 +509,7 @@ static int perf_ibs_handle_irq(struct perf_ibs *perf_ibs, struct pt_regs *iregs)
 	if (!(*buf++ & perf_ibs->valid_mask))
 		return 0;
 
-	/*
-	 * Emulate IbsOpCurCnt in MSRC001_1033 (IbsOpCtl), not
-	 * supported in all cpus. As this triggered an interrupt, we
-	 * set the current count to the max count.
-	 */
 	config = &ibs_data.regs[0];
-	if (perf_ibs == &perf_ibs_op && !(ibs_caps & IBS_CAPS_RDWROPCNT)) {
-		*config &= ~IBS_OP_CUR_CNT;
-		*config |= (*config & IBS_OP_MAX_CNT) << 36;
-	}
-
 	perf_ibs_event_update(perf_ibs, event, config);
 	perf_sample_data_init(&data, 0, hwc->last_period);
 	if (!perf_ibs_set_period(perf_ibs, hwc, &period))
-- 
1.7.8.4


