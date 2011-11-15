Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544Ab1KOWkd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 17:40:33 -0500
Received: from mail-ey0-f202.google.com ([209.85.215.202]:47503 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755001Ab1KOWkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 17:40:32 -0500
Subject: [PATCH] sched: avoid unnecessary overflow in sched_clock
In-Reply-To: <20111115215920.6239.23656.stgit@dungbeetle.mtv.corp.google.com>
To: John Stultz <johnstul@us.ibm.com>, Salman Qazi <sqazi@google.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
From: Salman Qazi <sqazi@google.com>
Date: Tue, 15 Nov 2011 14:12:06 -0800
Message-ID: <20111115221121.7262.88871.stgit@dungbeetle.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Added the missing signed-off-by line)

In hundreds of days, the __cycles_2_ns calculation in sched_clock
has an overflow.  cyc * per_cpu(cyc2ns, cpu) exceeds 64 bits, causing
the final value to become zero.  We can solve this without losing
any precision.

We can decompose TSC into quotient and remainder of division by the
scale factor, and then use this to convert TSC into nanoseconds.

Signed-off-by: Salman Qazi <sqazi@google.com>
---
 arch/x86/include/asm/timer.h |   23 ++++++++++++++++++++++-
 1 files changed, 22 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/timer.h b/arch/x86/include/asm/timer.h
index fa7b917..431793e 100644
--- a/arch/x86/include/asm/timer.h
+++ b/arch/x86/include/asm/timer.h
@@ -32,6 +32,22 @@ extern int no_timer_check;
  *  (mathieu.desnoyers@polymtl.ca)
  *
  *			-johnstul@us.ibm.com "math is hard, lets go shopping!"
+ *
+ * In:
+ *
+ * ns = cycles * cyc2ns_scale / SC
+ *
+ * Although we may still have enough bits to store the value of ns,
+ * in some cases, we may not have enough bits to store cycles * cyc2ns_scale,
+ * leading to an incorrect result.
+ *
+ * To avoid this, we can decompose 'cycles' into quotient and remainder
+ * of division by SC.  Then,
+ *
+ * ns = (quot * SC + rem) * cyc2ns_scale / SC
+ *    = quot * cyc2ns_scale + (rem * cyc2ns_scale) / SC
+ *
+ *			- sqazi@google.com
  */
 
 DECLARE_PER_CPU(unsigned long, cyc2ns);
@@ -41,9 +57,14 @@ DECLARE_PER_CPU(unsigned long long, cyc2ns_offset);
 
 static inline unsigned long long __cycles_2_ns(unsigned long long cyc)
 {
+	unsigned long long quot;
+	unsigned long long rem;
 	int cpu = smp_processor_id();
 	unsigned long long ns = per_cpu(cyc2ns_offset, cpu);
-	ns += cyc * per_cpu(cyc2ns, cpu) >> CYC2NS_SCALE_FACTOR;
+	quot = (cyc >> CYC2NS_SCALE_FACTOR);
+	rem = cyc & ((1ULL << CYC2NS_SCALE_FACTOR) - 1);
+	ns += quot * per_cpu(cyc2ns, cpu) +
+		((rem * per_cpu(cyc2ns, cpu)) >> CYC2NS_SCALE_FACTOR);
 	return ns;
 }
 

