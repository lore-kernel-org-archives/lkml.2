Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730Ab0DMU1w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 16:27:52 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:27484 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466Ab0DMU0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 16:26:55 -0400
X-SpamScore: 5
X-BigFish: VPS5(zba6lzab9bhzz1202hzzz32i2a8h87h467h6bh43h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L0U0SC-01-CAT-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 01/12] perf, x86: move perfctr init code to x86_setup_perfctr()
Date: Tue, 13 Apr 2010 22:23:10 +0200
Message-ID: <1271190201-25705-2-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <1271190201-25705-1-git-send-email-robert.richter@amd.com>
References: <1271190201-25705-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 13 Apr 2010 20:26:35.0355 (UTC) FILETIME=[9CD07AB0:01CADB47]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split __hw_perf_event_init() to configure pmu events other than
perfctrs. Perfctr code is moved to a separate function
x86_setup_perfctr(). This and the following patches refactor the code.

Split in multiple patches for better review.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_event.c |   20 ++++++++++++++------
 1 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 626154a..d275277 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -426,6 +426,8 @@ set_ext_hw_attr(struct hw_perf_event *hwc, struct perf_event_attr *attr)
 	return 0;
 }
 
+static int x86_setup_perfctr(struct perf_event *event);
+
 static int x86_pmu_hw_config(struct perf_event *event)
 {
 	/*
@@ -453,9 +455,6 @@ static int x86_pmu_hw_config(struct perf_event *event)
  */
 static int __hw_perf_event_init(struct perf_event *event)
 {
-	struct perf_event_attr *attr = &event->attr;
-	struct hw_perf_event *hwc = &event->hw;
-	u64 config;
 	int err;
 
 	if (!x86_pmu_initialized())
@@ -482,15 +481,24 @@ static int __hw_perf_event_init(struct perf_event *event)
 
 	event->destroy = hw_perf_event_destroy;
 
-	hwc->idx = -1;
-	hwc->last_cpu = -1;
-	hwc->last_tag = ~0ULL;
+	event->hw.idx = -1;
+	event->hw.last_cpu = -1;
+	event->hw.last_tag = ~0ULL;
 
 	/* Processor specifics */
 	err = x86_pmu.hw_config(event);
 	if (err)
 		return err;
 
+	return x86_setup_perfctr(event);
+}
+
+static int x86_setup_perfctr(struct perf_event *event)
+{
+	struct perf_event_attr *attr = &event->attr;
+	struct hw_perf_event *hwc = &event->hw;
+	u64 config;
+
 	if (!hwc->sample_period) {
 		hwc->sample_period = x86_pmu.max_period;
 		hwc->last_period = hwc->sample_period;
-- 
1.7.0.3


