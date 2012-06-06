Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757232Ab2FFQRd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 12:17:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40698 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756776Ab2FFQRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 12:17:21 -0400
Date: Wed, 6 Jun 2012 09:17:02 -0700
From: tip-bot for Vince Weaver <vweaver1@eecs.utk.edu>
Message-ID: <tip-c48b60538c3ba05a7a2713c4791b25405525431b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, vweaver1@eecs.utk.edu
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, vweaver1@eecs.utk.edu
In-Reply-To: <alpine.DEB.2.00.1203011724030.26934@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1203011724030.26934@cl320.eecs.utk.edu>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86: Use rdpmc() rather than rdmsr()
  when possible in the kernel
Git-Commit-ID: c48b60538c3ba05a7a2713c4791b25405525431b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 06 Jun 2012 09:17:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c48b60538c3ba05a7a2713c4791b25405525431b
Gitweb:     http://git.kernel.org/tip/c48b60538c3ba05a7a2713c4791b25405525431b
Author:     Vince Weaver <vweaver1@eecs.utk.edu>
AuthorDate: Thu, 1 Mar 2012 17:28:14 -0500
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Jun 2012 17:23:35 +0200

perf/x86: Use rdpmc() rather than rdmsr() when possible in the kernel

The rdpmc instruction is faster than the equivelant rdmsr call,
so use it when possible in the kernel.

The perfctr kernel patches did this, after extensive testing showed
rdpmc to always be faster (One can look in etc/costs in the perfctr-2.6
package to see a historical list of the overhead).

I have done some tests on a 3.2 kernel, the kernel module I used
was included in the first posting of this patch:

                   rdmsr           rdpmc
 Core2 T9900:      203.9 cycles     30.9 cycles
 AMD fam0fh:        56.2 cycles      9.8 cycles
 Atom 6/28/2:      129.7 cycles     50.6 cycles

The speedup of using rdpmc is large.

[ It's probably possible (and desirable) to do this without
  requiring a new field in the hw_perf_event structure, but
  the fixed events make this tricky. ]

Signed-off-by: Vince Weaver <vweaver1@eecs.utk.edu>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/alpine.DEB.2.00.1203011724030.26934@cl320.eecs.utk.edu
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event.c |    4 +++-
 include/linux/perf_event.h       |    1 +
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 43c2017..000a474 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -75,7 +75,7 @@ u64 x86_perf_event_update(struct perf_event *event)
 	 */
 again:
 	prev_raw_count = local64_read(&hwc->prev_count);
-	rdmsrl(hwc->event_base, new_raw_count);
+	rdpmcl(hwc->event_base_rdpmc, new_raw_count);
 
 	if (local64_cmpxchg(&hwc->prev_count, prev_raw_count,
 					new_raw_count) != prev_raw_count)
@@ -819,9 +819,11 @@ static inline void x86_assign_hw_event(struct perf_event *event,
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
index 45db49f..1ce887a 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -677,6 +677,7 @@ struct hw_perf_event {
 			u64		last_tag;
 			unsigned long	config_base;
 			unsigned long	event_base;
+			int		event_base_rdpmc;
 			int		idx;
 			int		last_cpu;
 
