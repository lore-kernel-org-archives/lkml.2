Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509Ab2A3Eoa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 23:44:30 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:53915 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754445Ab2A3Eo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 23:44:27 -0500
X-AuditID: b753bd60-9aa63ba00000359c-1e-4f26202874fd
X-AuditID: b753bd60-9aa63ba00000359c-1e-4f26202874fd
From: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Subject: [PATCH -tip v5 2/5] perf: set correct value to perf_event_header.misc
 for BTS
To: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        yrl.pp-manager.tt@hitachi.com,
        Akihiro Nagai <akihiro.nagai.hw@hitachi.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        David Ahern <dsahern@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Date: Mon, 30 Jan 2012 13:43:03 +0900
Message-ID: <20120130044303.2384.63515.stgit@linux3>
In-Reply-To: <20120130044242.2384.23076.stgit@linux3>
References: <20120130044242.2384.23076.stgit@linux3>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set correct value to perf_event_headder.misc of BTS record
to resolve symbols and DSOs correctly by user-space tools.

Changes in v4:
 - Add check routine to set correct value

Signed-off-by: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---

 arch/x86/kernel/cpu/perf_event_intel_ds.c |   31 +++++++++++++++++++----------
 1 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 73da6b6..2f99597 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -285,6 +285,18 @@ void intel_pmu_disable_bts(void)
 	update_debugctlmsr(debugctlmsr);
 }
 
+
+#include <asm/insn.h>
+
+static inline bool kernel_ip(unsigned long ip)
+{
+#ifdef CONFIG_X86_32
+	return ip > PAGE_OFFSET;
+#else
+	return (long)ip < 0;
+#endif
+}
+
 int intel_pmu_drain_bts_buffer(void)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
@@ -330,6 +342,14 @@ int intel_pmu_drain_bts_buffer(void)
 		return 1;
 
 	for (; at < top; at++) {
+		/*
+		 * To resolve user space symbols and DSOs correctly, set
+		 * PERF_RECORD_MISC_USER if from_addr or to_addr is user space.
+		 */
+		if (!kernel_ip(data.ip) || !kernel_ip(data.addr)) {
+			header.misc &= ~PERF_RECORD_MISC_CPUMODE_MASK;
+			header.misc |= PERF_RECORD_MISC_USER;
+		}
 		data.ip		= at->from;
 		data.addr	= at->to;
 
@@ -476,17 +496,6 @@ void intel_pmu_pebs_disable_all(void)
 		wrmsrl(MSR_IA32_PEBS_ENABLE, 0);
 }
 
-#include <asm/insn.h>
-
-static inline bool kernel_ip(unsigned long ip)
-{
-#ifdef CONFIG_X86_32
-	return ip > PAGE_OFFSET;
-#else
-	return (long)ip < 0;
-#endif
-}
-
 static int intel_pmu_pebs_fixup_ip(struct pt_regs *regs)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);

