Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031181Ab2ERKlK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 06:41:10 -0400
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:4853
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031141Ab2ERKlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 06:41:03 -0400
X-SpamScore: 6
X-BigFish: VPS6(z426fnzzz1202hzz8275bh8275dhz2dh668h839hd24he5bhf0ah)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M47SC7-01-1PC-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>, <stable@vger.kernel.org>,
        <#@erda.amd.com>, <v2.6.39+@erda.amd.com>
Subject: [PATCH] perf, x86: Update event scheduling constraints for AMD family 15h models
Date: Fri, 18 May 2012 12:40:42 +0200
Message-ID: <1337337642-1621-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.8.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This update is for newer family 15h cpu models from 0x02 to 0x1f.

Cc: stable@vger.kernel.org # v2.6.39+
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_event_amd.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index 6565226..11a4eb9 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -496,6 +496,7 @@ static __initconst const struct x86_pmu amd_pmu = {
  * 0x023	DE	PERF_CTL[2:0]
  * 0x02D	LS	PERF_CTL[3]
  * 0x02E	LS	PERF_CTL[3,0]
+ * 0x031	LS	PERF_CTL[2:0] (**)
  * 0x043	CU	PERF_CTL[2:0]
  * 0x045	CU	PERF_CTL[2:0]
  * 0x046	CU	PERF_CTL[2:0]
@@ -509,10 +510,12 @@ static __initconst const struct x86_pmu amd_pmu = {
  * 0x0DD	LS	PERF_CTL[5:0]
  * 0x0DE	LS	PERF_CTL[5:0]
  * 0x0DF	LS	PERF_CTL[5:0]
+ * 0x1C0	EX	PERF_CTL[5:3]
  * 0x1D6	EX	PERF_CTL[5:0]
  * 0x1D8	EX	PERF_CTL[5:0]
  *
- * (*) depending on the umask all FPU counters may be used
+ * (*)  depending on the umask all FPU counters may be used
+ * (**) only one unitmask enabled at a time
  */
 
 static struct event_constraint amd_f15_PMC0  = EVENT_CONSTRAINT(0, 0x01, 0);
@@ -562,6 +565,12 @@ amd_get_event_constraints_f15h(struct cpu_hw_events *cpuc, struct perf_event *ev
 			return &amd_f15_PMC3;
 		case 0x02E:
 			return &amd_f15_PMC30;
+		case 0x031:
+			if (hweight_long(hwc->config & ARCH_PERFMON_EVENTSEL_UMASK) <= 1)
+				return &amd_f15_PMC20;
+			return &emptyconstraint;
+		case 0x1C0:
+			return &amd_f15_PMC53;
 		default:
 			return &amd_f15_PMC50;
 		}
-- 
1.7.8.4


