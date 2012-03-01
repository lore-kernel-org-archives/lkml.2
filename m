Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757495Ab2CAWl7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 17:41:59 -0500
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:35003
	"EHLO AM1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754828Ab2CAWl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 17:41:58 -0500
X-SpamScore: 2
X-BigFish: VS2(zzbb2dIzz1202hzzz2dh87h2a8h668h839h8e2h8e3h944hbe9k)
X-Forefront-Antispam-Report: CIP:160.36.179.132;KIP:(null);UIP:(null);IPV:NLI;H:kedge1.utk.tennessee.edu;RD:kedge1.utk.tennessee.edu;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
Date: Thu, 1 Mar 2012 17:28:14 -0500
From: Vince Weaver <vweaver1@eecs.utk.edu>
To: <linux-kernel@vger.kernel.org>
CC: <mingo@elte.hu>, <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Stephane Eranian <eranian@gmail.com>
Subject: [PATCH] perf_event use rdpmc rather than rdmsr when possible in
 kernel
Message-ID: <alpine.DEB.2.00.1203011724030.26934@cl320.eecs.utk.edu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-ID: <alpine.DEB.2.00.1203011724032.26934@cl320.eecs.utk.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

The rdpmc instruction is faster than the equivelant rdmsr call,
so use it when possible in the kernel.

The perfctr kernel patches did this, after extensive testing showed
rdpmc to always be faster (One can look in etc/costs in the perfctr-2.6 
package to see a historical list of the overhead).

I have done some tests on a 3.2 kernel, the kernel module I used
was included in the first posting of this patch:

                    rdmsr            rdpmc
Core2 T9900:      203.9 cycles     30.9 cycles
AMD fam0fh:        56.2 cycles      9.8 cycles
Atom 6/28/2:      129.7 cycles     50.6 cycles

The speedup of using rdpmc is large, although granted
it really is a drop in the bucket compared to the other overheads 
involved.

It's probably possible (and desirable) to do this without 
requiring a new field in the hw_perf_event structure, but the fixed events 
make this tricky.

Changes since the last version: properly use the "rdpmc" macro,
      make event_base_rdpmc an int rather than unsigned long

Signed-off-by: Vince Weaver <vweaver1@eecs.utk.edu>

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 5adce10..e1ddfc7 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -70,6 +70,7 @@ u64 x86_perf_event_update(struct perf_event *event)
 	struct hw_perf_event *hwc = &event->hw;
 	int shift = 64 - x86_pmu.cntval_bits;
 	u64 prev_raw_count, new_raw_count;
+	u32 high, low;
 	int idx = hwc->idx;
 	s64 delta;
 
@@ -85,7 +86,8 @@ u64 x86_perf_event_update(struct perf_event *event)
 	 */
 again:
 	prev_raw_count = local64_read(&hwc->prev_count);
-	rdmsrl(hwc->event_base, new_raw_count);
+	rdpmc(hwc->event_base_rdpmc, low, high);
+	new_raw_count=((u64)high<<32 | (u64)low);
 
 	if (local64_cmpxchg(&hwc->prev_count, prev_raw_count,
 					new_raw_count) != prev_raw_count)
@@ -768,9 +770,11 @@ static inline void x86_assign_hw_event(struct perf_event *event,
 	} else if (hwc->idx >= X86_PMC_IDX_FIXED) {
 		hwc->config_base = MSR_ARCH_PERFMON_FIXED_CTR_CTRL;
 		hwc->event_base = MSR_ARCH_PERFMON_FIXED_CTR0 + (hwc->idx - X86_PMC_IDX_FIXED);
+		hwc->event_base_rdpmc = (hwc->idx - X86_PMC_IDX_FIXED) | 1<<30;
 	} else {
 		hwc->config_base = x86_pmu_config_addr(hwc->idx);
 		hwc->event_base  = x86_pmu_event_addr(hwc->idx);
+		hwc->event_base_rdpmc = x86_pmu_addr_offset(hwc->idx);
 	}
 }
 
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index abb2776..8caf91a 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -562,6 +562,7 @@ struct hw_perf_event {
 			u64		last_tag;
 			unsigned long	config_base;
 			unsigned long	event_base;
+			int		event_base_rdpmc;
 			int		idx;
 			int		last_cpu;
 			struct hw_perf_event_extra extra_reg;

