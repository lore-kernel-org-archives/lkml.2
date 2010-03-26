Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126Ab0CZM7A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 08:59:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:57708 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752418Ab0CZM65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 08:58:57 -0400
Date: Fri, 26 Mar 2010 12:58:17 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100325135413.861425293@chello.nl>
References: <20100325135413.861425293@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf, x86: Clean up debugctlmsr bit definitions
Message-ID: <tip-7c5ecaf7666617889f337296c610815b519abfa9@git.kernel.org>
Git-Commit-ID: 7c5ecaf7666617889f337296c610815b519abfa9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Mar 2010 12:58:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7c5ecaf7666617889f337296c610815b519abfa9
Gitweb:     http://git.kernel.org/tip/7c5ecaf7666617889f337296c610815b519abfa9
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 25 Mar 2010 14:51:49 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 26 Mar 2010 09:41:03 +0100

perf, x86: Clean up debugctlmsr bit definitions

Move all debugctlmsr thingies into msr-index.h

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20100325135413.861425293@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/msr-index.h           |   13 ++++++++-----
 arch/x86/kernel/cpu/perf_event_intel_ds.c  |   23 +++++++----------------
 arch/x86/kernel/cpu/perf_event_intel_lbr.c |    7 ++-----
 3 files changed, 17 insertions(+), 26 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index aef562c..06e4cf0 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -71,11 +71,14 @@
 #define MSR_IA32_LASTINTTOIP		0x000001de
 
 /* DEBUGCTLMSR bits (others vary by model): */
-#define _DEBUGCTLMSR_LBR	0 /* last branch recording */
-#define _DEBUGCTLMSR_BTF	1 /* single-step on branches */
-
-#define DEBUGCTLMSR_LBR		(1UL << _DEBUGCTLMSR_LBR)
-#define DEBUGCTLMSR_BTF		(1UL << _DEBUGCTLMSR_BTF)
+#define DEBUGCTLMSR_LBR			(1UL <<  0) /* last branch recording */
+#define DEBUGCTLMSR_BTF			(1UL <<  1) /* single-step on branches */
+#define DEBUGCTLMSR_TR			(1UL <<  6)
+#define DEBUGCTLMSR_BTS			(1UL <<  7)
+#define DEBUGCTLMSR_BTINT		(1UL <<  8)
+#define DEBUGCTLMSR_BTS_OFF_OS		(1UL <<  9)
+#define DEBUGCTLMSR_BTS_OFF_USR		(1UL << 10)
+#define DEBUGCTLMSR_FREEZE_LBRS_ON_PMI	(1UL << 11)
 
 #define MSR_IA32_MC0_CTL		0x00000400
 #define MSR_IA32_MC0_STATUS		0x00000401
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index c59678a..2fea362 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -38,15 +38,6 @@ struct pebs_record_nhm {
 };
 
 /*
- * Bits in the debugctlmsr controlling branch tracing.
- */
-#define X86_DEBUGCTL_TR			(1 << 6)
-#define X86_DEBUGCTL_BTS		(1 << 7)
-#define X86_DEBUGCTL_BTINT		(1 << 8)
-#define X86_DEBUGCTL_BTS_OFF_OS		(1 << 9)
-#define X86_DEBUGCTL_BTS_OFF_USR	(1 << 10)
-
-/*
  * A debug store configuration.
  *
  * We only support architectures that use 64bit fields.
@@ -193,15 +184,15 @@ static void intel_pmu_enable_bts(u64 config)
 
 	debugctlmsr = get_debugctlmsr();
 
-	debugctlmsr |= X86_DEBUGCTL_TR;
-	debugctlmsr |= X86_DEBUGCTL_BTS;
-	debugctlmsr |= X86_DEBUGCTL_BTINT;
+	debugctlmsr |= DEBUGCTLMSR_TR;
+	debugctlmsr |= DEBUGCTLMSR_BTS;
+	debugctlmsr |= DEBUGCTLMSR_BTINT;
 
 	if (!(config & ARCH_PERFMON_EVENTSEL_OS))
-		debugctlmsr |= X86_DEBUGCTL_BTS_OFF_OS;
+		debugctlmsr |= DEBUGCTLMSR_BTS_OFF_OS;
 
 	if (!(config & ARCH_PERFMON_EVENTSEL_USR))
-		debugctlmsr |= X86_DEBUGCTL_BTS_OFF_USR;
+		debugctlmsr |= DEBUGCTLMSR_BTS_OFF_USR;
 
 	update_debugctlmsr(debugctlmsr);
 }
@@ -217,8 +208,8 @@ static void intel_pmu_disable_bts(void)
 	debugctlmsr = get_debugctlmsr();
 
 	debugctlmsr &=
-		~(X86_DEBUGCTL_TR | X86_DEBUGCTL_BTS | X86_DEBUGCTL_BTINT |
-		  X86_DEBUGCTL_BTS_OFF_OS | X86_DEBUGCTL_BTS_OFF_USR);
+		~(DEBUGCTLMSR_TR | DEBUGCTLMSR_BTS | DEBUGCTLMSR_BTINT |
+		  DEBUGCTLMSR_BTS_OFF_OS | DEBUGCTLMSR_BTS_OFF_USR);
 
 	update_debugctlmsr(debugctlmsr);
 }
diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index df4c98e..d202c1b 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -12,15 +12,12 @@ enum {
  * otherwise it becomes near impossible to get a reliable stack.
  */
 
-#define X86_DEBUGCTL_LBR               		(1 << 0)
-#define X86_DEBUGCTL_FREEZE_LBRS_ON_PMI		(1 << 11)
-
 static void __intel_pmu_lbr_enable(void)
 {
 	u64 debugctl;
 
 	rdmsrl(MSR_IA32_DEBUGCTLMSR, debugctl);
-	debugctl |= (X86_DEBUGCTL_LBR | X86_DEBUGCTL_FREEZE_LBRS_ON_PMI);
+	debugctl |= (DEBUGCTLMSR_LBR | DEBUGCTLMSR_FREEZE_LBRS_ON_PMI);
 	wrmsrl(MSR_IA32_DEBUGCTLMSR, debugctl);
 }
 
@@ -29,7 +26,7 @@ static void __intel_pmu_lbr_disable(void)
 	u64 debugctl;
 
 	rdmsrl(MSR_IA32_DEBUGCTLMSR, debugctl);
-	debugctl &= ~(X86_DEBUGCTL_LBR | X86_DEBUGCTL_FREEZE_LBRS_ON_PMI);
+	debugctl &= ~(DEBUGCTLMSR_LBR | DEBUGCTLMSR_FREEZE_LBRS_ON_PMI);
 	wrmsrl(MSR_IA32_DEBUGCTLMSR, debugctl);
 }
 
