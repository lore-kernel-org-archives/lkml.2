Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756568Ab3AHXh2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 18:37:28 -0500
Received: from mail.windriver.com ([147.11.1.11]:63491 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756171Ab3AHXhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 18:37:24 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Salman Qazi <sqazi@google.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 38/77] sched, x86: Avoid unnecessary overflow in sched_clock
Date: Tue, 8 Jan 2013 18:35:17 -0500
Message-ID: <1357688156-25387-39-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
References: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Salman Qazi <sqazi@google.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 4cecf6d401a01d054afc1e5f605bcbfe553cb9b9 upstream.

(Added the missing signed-off-by line)

In hundreds of days, the __cycles_2_ns calculation in sched_clock
has an overflow.  cyc * per_cpu(cyc2ns, cpu) exceeds 64 bits, causing
the final value to become zero.  We can solve this without losing
any precision.

We can decompose TSC into quotient and remainder of division by the
scale factor, and then use this to convert TSC into nanoseconds.

Signed-off-by: Salman Qazi <sqazi@google.com>
Acked-by: John Stultz <johnstul@us.ibm.com>
Reviewed-by: Paul Turner <pjt@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20111115221121.7262.88871.stgit@dungbeetle.mtv.corp.google.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/x86/include/asm/timer.h | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/timer.h b/arch/x86/include/asm/timer.h
index 5469630..b93a9aa 100644
--- a/arch/x86/include/asm/timer.h
+++ b/arch/x86/include/asm/timer.h
@@ -38,6 +38,22 @@ extern int no_timer_check;
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
@@ -47,9 +63,14 @@ DECLARE_PER_CPU(unsigned long long, cyc2ns_offset);
 
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
 
-- 
1.7.12.1

