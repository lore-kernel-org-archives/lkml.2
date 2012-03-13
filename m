Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964773Ab2CMEuM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 00:50:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35326 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753939Ab2CMEuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 00:50:10 -0400
Date: Mon, 12 Mar 2012 21:49:53 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-0vsy1sgywc4uar3mu1szm0rg@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@redhat.com, robert.richter@amd.com, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, robert.richter@amd.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86: Prettify pmu config literals
Git-Commit-ID: f9b4eeb809c6d031cc9561cc34dd691701cb2c2a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 12 Mar 2012 21:49:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f9b4eeb809c6d031cc9561cc34dd691701cb2c2a
Gitweb:     http://git.kernel.org/tip/f9b4eeb809c6d031cc9561cc34dd691701cb2c2a
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 12 Mar 2012 12:44:35 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 12 Mar 2012 20:44:54 +0100

perf/x86: Prettify pmu config literals

I got somewhat tired of having to decode hex numbers..

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Stephane Eranian <eranian@google.com>
Cc: Robert Richter <robert.richter@amd.com>
Link: http://lkml.kernel.org/n/tip-0vsy1sgywc4uar3mu1szm0rg@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.h       |   23 +++++++++++++++++++++++
 arch/x86/kernel/cpu/perf_event_intel.c |   21 ++++++++++++++-------
 2 files changed, 37 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 82db83b..66fda0c 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -268,6 +268,29 @@ struct x86_pmu_quirk {
 	void (*func)(void);
 };
 
+union x86_pmu_config {
+	struct {
+		u64 event:8,
+		    umask:8,
+		    usr:1,
+		    os:1,
+		    edge:1,
+		    pc:1,
+		    interrupt:1,
+		    __reserved1:1,
+		    en:1,
+		    inv:1,
+		    cmask:8,
+		    event2:4,
+		    __reserved2:4,
+		    go:1,
+		    ho:1;
+	} bits;
+	u64 value;
+};
+
+#define X86_CONFIG(args...) ((union x86_pmu_config){.bits = {args}}).value
+
 /*
  * struct x86_pmu - generic x86 pmu
  */
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 61d4f79..4bd9c9e 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1288,7 +1288,8 @@ static int intel_pmu_hw_config(struct perf_event *event)
 		 *
 		 * Thereby we gain a PEBS capable cycle counter.
 		 */
-		u64 alt_config = 0x108000c0; /* INST_RETIRED.TOTAL_CYCLES */
+		u64 alt_config = X86_CONFIG(.event=0xc0, .inv=1, .cmask=16);
+
 
 		alt_config |= (event->hw.config & ~X86_RAW_EVENT_MASK);
 		event->hw.config = alt_config;
@@ -1690,9 +1691,11 @@ __init int intel_pmu_init(void)
 		x86_pmu.extra_regs = intel_nehalem_extra_regs;
 
 		/* UOPS_ISSUED.STALLED_CYCLES */
-		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND] = 0x180010e;
+		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND] =
+			X86_CONFIG(.event=0x0e, .umask=0x01, .inv=1, .cmask=1);
 		/* UOPS_EXECUTED.CORE_ACTIVE_CYCLES,c=1,i=1 */
-		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_BACKEND] = 0x1803fb1;
+		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_BACKEND] =
+			X86_CONFIG(.event=0xb1, .umask=0x3f, .inv=1, .cmask=1);
 
 		x86_add_quirk(intel_nehalem_quirk);
 
@@ -1727,9 +1730,11 @@ __init int intel_pmu_init(void)
 		x86_pmu.er_flags |= ERF_HAS_RSP_1;
 
 		/* UOPS_ISSUED.STALLED_CYCLES */
-		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND] = 0x180010e;
+		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND] =
+			X86_CONFIG(.event=0x0e, .umask=0x01, .inv=1, .cmask=1);
 		/* UOPS_EXECUTED.CORE_ACTIVE_CYCLES,c=1,i=1 */
-		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_BACKEND] = 0x1803fb1;
+		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_BACKEND] =
+			X86_CONFIG(.event=0xb1, .umask=0x3f, .inv=1, .cmask=1);
 
 		pr_cont("Westmere events, ");
 		break;
@@ -1750,9 +1755,11 @@ __init int intel_pmu_init(void)
 		x86_pmu.er_flags |= ERF_NO_HT_SHARING;
 
 		/* UOPS_ISSUED.ANY,c=1,i=1 to count stall cycles */
-		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND] = 0x180010e;
+		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND] =
+			X86_CONFIG(.event=0x0e, .umask=0x01, .inv=1, .cmask=1);
 		/* UOPS_DISPATCHED.THREAD,c=1,i=1 to count stall cycles*/
-		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_BACKEND] = 0x18001b1;
+		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_BACKEND] =
+			X86_CONFIG(.event=0xb1, .umask=0x01, .inv=1, .cmask=1);
 
 		pr_cont("SandyBridge events, ");
 		break;
