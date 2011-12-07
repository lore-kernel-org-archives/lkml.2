Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757640Ab1LGQUT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:20:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33596 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757230Ab1LGQUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:20:13 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:08:27 2011
Message-Id: <20111207160827.358847595@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:07:18 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>, Salman Qazi <sqazi@google.com>,
        John Stultz <johnstul@us.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: [58/80] sched, x86: Avoid unnecessary overflow in sched_clock
In-Reply-To: <20111207161256.GA7736@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Salman Qazi <sqazi@google.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/include/asm/timer.h |   23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

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
@@ -41,9 +57,14 @@ DECLARE_PER_CPU(unsigned long long, cyc2
 
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
 


