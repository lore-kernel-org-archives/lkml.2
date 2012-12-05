Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569Ab2LEXGn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 18:06:43 -0500
Received: from [213.199.154.144] ([213.199.154.144]:15842 "EHLO
	db3outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751766Ab2LEXF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 18:05:56 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1de0h1202h1d1ah1d2ahzz8275bhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h14ddh1504h1537h162dh1631h1155h)
X-WSS-ID: 0MEKYRB-01-5K1-02
X-M-MSG: 
From: Jacob Shin <jacob.shin@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Stephane Eranian <eranian@google.com>,
        Robert Richter <rric@kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, Jacob Shin <jacob.shin@amd.com>
Subject: [PATCH 5/6] perf, x86: Allow for architecture specific RDPMC indexes
Date: Wed, 5 Dec 2012 17:04:17 -0600
Message-ID: <1354748658-30567-6-git-send-email-jacob.shin@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1354748658-30567-1-git-send-email-jacob.shin@amd.com>
References: <1354748658-30567-1-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Similar to config_base and event_base, allow architecture specific
RDPMC ECX values.

Signed-off-by: Jacob Shin <jacob.shin@amd.com>
---
 arch/x86/kernel/cpu/perf_event.c     |    2 +-
 arch/x86/kernel/cpu/perf_event.h     |    6 ++++++
 arch/x86/kernel/cpu/perf_event_amd.c |    6 ++++++
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 4428fd1..b63982b 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -835,7 +835,7 @@ static inline void x86_assign_hw_event(struct perf_event *event,
 	} else {
 		hwc->config_base = x86_pmu_config_addr(hwc->idx);
 		hwc->event_base  = x86_pmu_event_addr(hwc->idx);
-		hwc->event_base_rdpmc = hwc->idx;
+		hwc->event_base_rdpmc = x86_pmu_rdpmc_index(hwc->idx);
 	}
 }
 
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 015826e..4a26fb1 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -326,6 +326,7 @@ struct x86_pmu {
 	unsigned	eventsel;
 	unsigned	perfctr;
 	int             (*addr_offset)(int index, int eventsel);
+	int             (*rdpmc_index)(int index);
 	u64		(*event_map)(int);
 	int		max_events;
 	int		num_counters;
@@ -459,6 +460,11 @@ static inline unsigned int x86_pmu_event_addr(int index)
 		(x86_pmu.addr_offset ? x86_pmu.addr_offset(index, 0) : index);
 }
 
+static inline int x86_pmu_rdpmc_index(int index)
+{
+	return x86_pmu.rdpmc_index ? x86_pmu.rdpmc_index(index) : index;
+}
+
 int x86_setup_perfctr(struct perf_event *event);
 
 int x86_pmu_hw_config(struct perf_event *event);
diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index ef1df38..faf9072 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -173,6 +173,11 @@ static inline int amd_pmu_addr_offset(int index, int eventsel)
 	return offset;
 }
 
+static inline int amd_pmu_rdpmc_index(int index)
+{
+	return index;
+}
+
 static int amd_pmu_hw_config(struct perf_event *event)
 {
 	int ret;
@@ -620,6 +625,7 @@ static __initconst const struct x86_pmu amd_pmu = {
 	.eventsel		= MSR_K7_EVNTSEL0,
 	.perfctr		= MSR_K7_PERFCTR0,
 	.addr_offset            = amd_pmu_addr_offset,
+	.rdpmc_index		= amd_pmu_rdpmc_index,
 	.event_map		= amd_pmu_event_map,
 	.max_events		= ARRAY_SIZE(amd_perfmon_event_map),
 	.num_counters		= AMD64_NUM_COUNTERS,
-- 
1.7.9.5


