Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758281Ab2JAXQ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:16:28 -0400
Received: from 1wt.eu ([62.212.114.60]:35480 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933057Ab2JAXCA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:02:00 -0400
Message-Id: <20121001225200.404694594@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:53:03 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Salman Qazi <sqazi@google.com>, John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 066/180] sched/x86: Fix overflow in cyc2ns_offset
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Salman Qazi <sqazi@google.com>

commit 9993bc635d01a6ee7f6b833b4ee65ce7c06350b1 upstream.

When a machine boots up, the TSC generally gets reset.  However,
when kexec is used to boot into a kernel, the TSC value would be
carried over from the previous kernel.  The computation of
cycns_offset in set_cyc2ns_scale is prone to an overflow, if the
machine has been up more than 208 days prior to the kexec.  The
overflow happens when we multiply *scale, even though there is
enough room to store the final answer.

We fix this issue by decomposing tsc_now into the quotient and
remainder of division by CYC2NS_SCALE_FACTOR and then performing
the multiplication separately on the two components.

Refactor code to share the calculation with the previous
fix in __cycles_2_ns().

Signed-off-by: Salman Qazi <sqazi@google.com>
Acked-by: John Stultz <john.stultz@linaro.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Turner <pjt@google.com>
Cc: john stultz <johnstul@us.ibm.com>
Link: http://lkml.kernel.org/r/20120310004027.19291.88460.stgit@dungbeetle.mtv.corp.google.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 arch/x86/include/asm/timer.h |    8 ++------
 arch/x86/kernel/tsc.c        |    3 ++-
 include/linux/kernel.h       |   13 +++++++++++++
 3 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/timer.h b/arch/x86/include/asm/timer.h
index b93a9aa..18e1ca7 100644
--- a/arch/x86/include/asm/timer.h
+++ b/arch/x86/include/asm/timer.h
@@ -63,14 +63,10 @@ DECLARE_PER_CPU(unsigned long long, cyc2ns_offset);
 
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
index bc07543..9972276 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -623,7 +623,8 @@ static void set_cyc2ns_scale(unsigned long cpu_khz, int cpu)
 
 	if (cpu_khz) {
 		*scale = (NSEC_PER_MSEC << CYC2NS_SCALE_FACTOR)/cpu_khz;
-		*offset = ns_now - (tsc_now * *scale >> CYC2NS_SCALE_FACTOR);
+		*offset = ns_now - mult_frac(tsc_now, *scale,
+					     (1UL << CYC2NS_SCALE_FACTOR));
 	}
 
 	sched_clock_idle_wakeup_event(0);
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 9acb92d..3526cd4 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -55,6 +55,19 @@ extern const char linux_proc_banner[];
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
 
-- 
1.7.2.1.45.g54fbc



