Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758758Ab2CJAlJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 19:41:09 -0500
Received: from mail-yw0-f74.google.com ([209.85.213.74]:60348 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756028Ab2CJAlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 19:41:07 -0500
Subject: [PATCH] sched, x86: fix overflow in cyc2ns_offset
To: john stultz <johnstul@us.ibm.com>
From: Salman Qazi <sqazi@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Turner <pjt@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 09 Mar 2012 16:41:01 -0800
Message-ID: <20120310004027.19291.88460.stgit@dungbeetle.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a machine boots up, the TSC generally gets reset.  However, when
kexec is used to boot into a kernel, the TSC value would be carried
over from the previous kernel.  The computation of cycns_offset in
set_cyc2ns_scale is prone to an overflow, if the machine has been up
more than 208 days prior to the kexec.  The overflow happens when
we multiply *scale, even though there is enough room to store the
final answer.  We fix this issue by decomposing tsc_now into the
quotient and remainder of division by CYC2NS_SCALE_FACTOR and then
performing the multiplication separately on the two components.

Refactor code to share the calculation with the previous
fix in __cycles_2_ns.

Acked-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Salman Qazi <sqazi@google.com>
---
 arch/x86/include/asm/timer.h |    8 ++------
 arch/x86/kernel/tsc.c        |    3 ++-
 include/linux/kernel.h       |   13 +++++++++++++
 3 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/timer.h b/arch/x86/include/asm/timer.h
index 431793e..34baa0e 100644
--- a/arch/x86/include/asm/timer.h
+++ b/arch/x86/include/asm/timer.h
@@ -57,14 +57,10 @@ DECLARE_PER_CPU(unsigned long long, cyc2ns_offset);
 
 static inline unsigned long long __cycles_2_ns(unsigned long long cyc)
 {
-	unsigned long long quot;
-	unsigned long long rem;
 	int cpu = smp_processor_id();
 	unsigned long long ns = per_cpu(cyc2ns_offset, cpu);
-	quot = (cyc >> CYC2NS_SCALE_FACTOR);
-	rem = cyc & ((1ULL << CYC2NS_SCALE_FACTOR) - 1);
-	ns += quot * per_cpu(cyc2ns, cpu) +
-		((rem * per_cpu(cyc2ns, cpu)) >> CYC2NS_SCALE_FACTOR);
+	ns += mult_frac(cyc, per_cpu(cyc2ns, cpu),
+			(1UL << CYC2NS_SCALE_FACTOR));
 	return ns;
 }
 
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index a62c201..183c592 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -620,7 +620,8 @@ static void set_cyc2ns_scale(unsigned long cpu_khz, int cpu)
 
 	if (cpu_khz) {
 		*scale = (NSEC_PER_MSEC << CYC2NS_SCALE_FACTOR)/cpu_khz;
-		*offset = ns_now - (tsc_now * *scale >> CYC2NS_SCALE_FACTOR);
+		*offset = ns_now - mult_frac(tsc_now, *scale,
+					     (1UL << CYC2NS_SCALE_FACTOR));
 	}
 
 	sched_clock_idle_wakeup_event(0);
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index e834342..d801acb 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -85,6 +85,19 @@
 }							\
 )
 
+/*
+ * Multiplies an integer by a fraction, while avoiding unnecessary
+ * overflow or loss of precision.
+ */
+#define mult_frac(x, numer, denom)(			\
+{							\
+	typeof(x) quot = (x) / (denom);			\
+	typeof(x) rem  = (x) % (denom);			\
+	(quot * (numer)) + ((rem * (numer)) / (denom));	\
+}							\
+)
+
+
 #define _RET_IP_		(unsigned long)__builtin_return_address(0)
 #define _THIS_IP_  ({ __label__ __here; __here: (unsigned long)&&__here; })
 

