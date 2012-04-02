Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290Ab2DBSWe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 14:22:34 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:16443 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753117Ab2DBST7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 14:19:59 -0400
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M1V6X5-01-AHI-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 04/12] perf/x86-ibs: Fix frequency profiling
Date: Mon, 2 Apr 2012 20:19:10 +0200
Message-ID: <1333390758-10893-5-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <1333390758-10893-1-git-send-email-robert.richter@amd.com>
References: <1333390758-10893-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixing profiling at a fix frequency, in this case the freq value and
sample period was setup incorrectly. Since sampling periods are
adjusted we also allow periods that have lower 4 bits set.

Another fix is the setup of the hw counter: If we modify
hwc->sample_period, we also need to update hwc->last_period and
hwc->period_left.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_event_amd_ibs.c |   18 ++++++++++++++++--
 1 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_amd_ibs.c b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
index 6f00ee3..eec3ea2 100644
--- a/arch/x86/kernel/cpu/perf_event_amd_ibs.c
+++ b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
@@ -162,9 +162,16 @@ static int perf_ibs_init(struct perf_event *event)
 		if (config & perf_ibs->cnt_mask)
 			/* raw max_cnt may not be set */
 			return -EINVAL;
-		if (hwc->sample_period & 0x0f)
-			/* lower 4 bits can not be set in ibs max cnt */
+		if (!event->attr.sample_freq && hwc->sample_period & 0x0f)
+			/*
+			 * lower 4 bits can not be set in ibs max cnt,
+			 * but allowing it in case we adjust the
+			 * sample period to set a frequency.
+			 */
 			return -EINVAL;
+		hwc->sample_period &= ~0x0FULL;
+		if (!hwc->sample_period)
+			hwc->sample_period = 0x10;
 	} else {
 		max_cnt = config & perf_ibs->cnt_mask;
 		config &= ~perf_ibs->cnt_mask;
@@ -175,6 +182,13 @@ static int perf_ibs_init(struct perf_event *event)
 	if (!hwc->sample_period)
 		return -EINVAL;
 
+	/*
+	 * If we modify hwc->sample_period, we also need to update
+	 * hwc->last_period and hwc->period_left.
+	 */
+	hwc->last_period = hwc->sample_period;
+	local64_set(&hwc->period_left, hwc->sample_period);
+
 	hwc->config_base = perf_ibs->msr;
 	hwc->config = config;
 
-- 
1.7.8.4


