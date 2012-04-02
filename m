Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115Ab2DBST7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 14:19:59 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:41390
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753117Ab2DBST5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 14:19:57 -0400
X-SpamScore: 3
X-BigFish: VPS3(zz853kzz1202hzz8275bhz2dh668h839hd24h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M1V6X1-02-33E-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 01/12] perf/x86-ibs: Fix update of period
Date: Mon, 2 Apr 2012 20:19:07 +0200
Message-ID: <1333390758-10893-2-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <1333390758-10893-1-git-send-email-robert.richter@amd.com>
References: <1333390758-10893-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The last sw period was not correctly updated on overflow and thus led
to wrong distribution of events. We always need to properly initialize
data.period in struct perf_sample_data.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_event_amd_ibs.c |   27 ++++++++++++++-------------
 1 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_amd_ibs.c b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
index 573d248..6eb6451 100644
--- a/arch/x86/kernel/cpu/perf_event_amd_ibs.c
+++ b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
@@ -386,7 +386,21 @@ static int perf_ibs_handle_irq(struct perf_ibs *perf_ibs, struct pt_regs *iregs)
 	if (!(*buf++ & perf_ibs->valid_mask))
 		return 0;
 
+	/*
+	 * Emulate IbsOpCurCnt in MSRC001_1033 (IbsOpCtl), not
+	 * supported in all cpus. As this triggered an interrupt, we
+	 * set the current count to the max count.
+	 */
+	config = ibs_data.regs[0];
+	if (perf_ibs == &perf_ibs_op && !(ibs_caps & IBS_CAPS_RDWROPCNT)) {
+		config &= ~IBS_OP_CUR_CNT;
+		config |= (config & IBS_OP_MAX_CNT) << 36;
+	}
+
+	perf_ibs_event_update(perf_ibs, event, config);
 	perf_sample_data_init(&data, 0);
+	data.period = event->hw.last_period;
+
 	if (event->attr.sample_type & PERF_SAMPLE_RAW) {
 		ibs_data.caps = ibs_caps;
 		size = 1;
@@ -405,19 +419,6 @@ static int perf_ibs_handle_irq(struct perf_ibs *perf_ibs, struct pt_regs *iregs)
 
 	regs = *iregs; /* XXX: update ip from ibs sample */
 
-	/*
-	 * Emulate IbsOpCurCnt in MSRC001_1033 (IbsOpCtl), not
-	 * supported in all cpus. As this triggered an interrupt, we
-	 * set the current count to the max count.
-	 */
-	config = ibs_data.regs[0];
-	if (perf_ibs == &perf_ibs_op && !(ibs_caps & IBS_CAPS_RDWROPCNT)) {
-		config &= ~IBS_OP_CUR_CNT;
-		config |= (config & IBS_OP_MAX_CNT) << 36;
-	}
-
-	perf_ibs_event_update(perf_ibs, event, config);
-
 	overflow = perf_ibs_set_period(perf_ibs, hwc, &config);
 	reenable = !(overflow && perf_event_overflow(event, &data, &regs));
 	config = (config >> 4) | (reenable ? perf_ibs->enable_mask : 0);
-- 
1.7.8.4


