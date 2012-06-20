Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756401Ab2FTKoI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 06:44:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34385 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932089Ab2FTKoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 06:44:06 -0400
Date: Wed, 20 Jun 2012 03:43:50 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-bcae21d6e793a7047d38abc9ac0946c53733c1dd@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        arjan@linux.intel.com, torvalds@linux-foundation.org,
        a.p.zijlstra@chello.nl, akpm@linux-foundation.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, arjan@linux.intel.com,
        tglx@linutronix.de
In-Reply-To: <1339594110.8980.38.camel@twins>
References: <1339594110.8980.38.camel@twins>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/x86: Remove broken power estimation
Git-Commit-ID: bcae21d6e793a7047d38abc9ac0946c53733c1dd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 20 Jun 2012 03:43:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bcae21d6e793a7047d38abc9ac0946c53733c1dd
Gitweb:     http://git.kernel.org/tip/bcae21d6e793a7047d38abc9ac0946c53733c1dd
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 13 Jun 2012 15:24:45 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 18 Jun 2012 11:39:07 +0200

sched/x86: Remove broken power estimation

The x86 sched power implementation has been broken forever and gets in
the way of other stuff, remove it.

[ For archaeological interest, fixing this code would require dealing
  with the cross-cpu calling of these functions and more importantly, we
  need to filter idle time out of the a/m-perf stuff because the ratio
  will go down to 0 when idle, giving a 0 capacity which is not what
  we'd want. ]

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Link: http://lkml.kernel.org/r/1339594110.8980.38.camel@twins
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/Makefile |    2 +-
 arch/x86/kernel/cpu/sched.c  |   55 ------------------------------------------
 2 files changed, 1 insertions(+), 56 deletions(-)

diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index 6ab6aa2..c598126 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -14,7 +14,7 @@ CFLAGS_common.o		:= $(nostackp)
 
 obj-y			:= intel_cacheinfo.o scattered.o topology.o
 obj-y			+= proc.o capflags.o powerflags.o common.o
-obj-y			+= vmware.o hypervisor.o sched.o mshyperv.o
+obj-y			+= vmware.o hypervisor.o mshyperv.o
 obj-y			+= rdrand.o
 obj-y			+= match.o
 
diff --git a/arch/x86/kernel/cpu/sched.c b/arch/x86/kernel/cpu/sched.c
deleted file mode 100644
index a640ae5..0000000
--- a/arch/x86/kernel/cpu/sched.c
+++ /dev/null
@@ -1,55 +0,0 @@
-#include <linux/sched.h>
-#include <linux/math64.h>
-#include <linux/percpu.h>
-#include <linux/irqflags.h>
-
-#include <asm/cpufeature.h>
-#include <asm/processor.h>
-
-#ifdef CONFIG_SMP
-
-static DEFINE_PER_CPU(struct aperfmperf, old_perf_sched);
-
-static unsigned long scale_aperfmperf(void)
-{
-	struct aperfmperf val, *old = &__get_cpu_var(old_perf_sched);
-	unsigned long ratio, flags;
-
-	local_irq_save(flags);
-	get_aperfmperf(&val);
-	local_irq_restore(flags);
-
-	ratio = calc_aperfmperf_ratio(old, &val);
-	*old = val;
-
-	return ratio;
-}
-
-unsigned long arch_scale_freq_power(struct sched_domain *sd, int cpu)
-{
-	/*
-	 * do aperf/mperf on the cpu level because it includes things
-	 * like turbo mode, which are relevant to full cores.
-	 */
-	if (boot_cpu_has(X86_FEATURE_APERFMPERF))
-		return scale_aperfmperf();
-
-	/*
-	 * maybe have something cpufreq here
-	 */
-
-	return default_scale_freq_power(sd, cpu);
-}
-
-unsigned long arch_scale_smt_power(struct sched_domain *sd, int cpu)
-{
-	/*
-	 * aperf/mperf already includes the smt gain
-	 */
-	if (boot_cpu_has(X86_FEATURE_APERFMPERF))
-		return SCHED_LOAD_SCALE;
-
-	return default_scale_smt_power(sd, cpu);
-}
-
-#endif
