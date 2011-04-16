Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756305Ab1DPAfp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 20:35:45 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:7679 "EHLO
	VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754262Ab1DPAfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 20:35:43 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LJPYZ8-02-AE0-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@googlemail.com>
Subject: [PATCH 2/4] perf, x86: Fix AMD family 15h FPU event constraints
Date: Sat, 16 Apr 2011 02:27:54 +0200
Message-ID: <1302913676-14352-3-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1302913676-14352-1-git-send-email-robert.richter@amd.com>
References: <1302913676-14352-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Depending on the unit mask settings some FPU events may be scheduled
only on cpu counter #3. This patch fixes this.

Cc: Stephane Eranian <eranian@googlemail.com>
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_event_amd.c |   21 ++++++++++++++++++---
 1 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index 4e16138..758cccc 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -427,7 +427,9 @@ static __initconst const struct x86_pmu amd_pmu = {
  *
  * Exceptions:
  *
+ * 0x000	FP	PERF_CTL[3], PERF_CTL[5:3] (*)
  * 0x003	FP	PERF_CTL[3]
+ * 0x004	FP	PERF_CTL[3], PERF_CTL[5:3] (*)
  * 0x00B	FP	PERF_CTL[3]
  * 0x00D	FP	PERF_CTL[3]
  * 0x023	DE	PERF_CTL[2:0]
@@ -448,6 +450,8 @@ static __initconst const struct x86_pmu amd_pmu = {
  * 0x0DF	LS	PERF_CTL[5:0]
  * 0x1D6	EX	PERF_CTL[5:0]
  * 0x1D8	EX	PERF_CTL[5:0]
+ *
+ * (*) depending on the umask all FPU counters may be used
  */
 
 static struct event_constraint amd_f15_PMC0  = EVENT_CONSTRAINT(0, 0x01, 0);
@@ -460,18 +464,29 @@ static struct event_constraint amd_f15_PMC53 = EVENT_CONSTRAINT(0, 0x38, 0);
 static struct event_constraint *
 amd_get_event_constraints_f15h(struct cpu_hw_events *cpuc, struct perf_event *event)
 {
-	unsigned int event_code = amd_get_event_code(&event->hw);
+	struct hw_perf_event *hwc = &event->hw;
+	unsigned int event_code = amd_get_event_code(hwc);
 
 	switch (event_code & AMD_EVENT_TYPE_MASK) {
 	case AMD_EVENT_FP:
 		switch (event_code) {
+		case 0x000:
+			if (!(hwc->config & 0x0000F000ULL))
+				break;
+			if (!(hwc->config & 0x00000F00ULL))
+				break;
+			return &amd_f15_PMC3;
+		case 0x004:
+			if (hweight_long(hwc->config &
+					 ARCH_PERFMON_EVENTSEL_UMASK) <= 1)
+				break;
+			return &amd_f15_PMC3;
 		case 0x003:
 		case 0x00B:
 		case 0x00D:
 			return &amd_f15_PMC3;
-		default:
-			return &amd_f15_PMC53;
 		}
+		return &amd_f15_PMC53;
 	case AMD_EVENT_LS:
 	case AMD_EVENT_DC:
 	case AMD_EVENT_EX_LS:
-- 
1.7.3.4


