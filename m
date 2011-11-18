Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087Ab1KRXpc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 18:45:32 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53544 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab1KRXpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 18:45:31 -0500
Date: Fri, 18 Nov 2011 15:45:12 -0800
From: tip-bot for Salman Qazi <sqazi@google.com>
Message-ID: <tip-4cecf6d401a01d054afc1e5f605bcbfe553cb9b9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, johnstul@us.ibm.com, pjt@google.com,
        sqazi@google.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        johnstul@us.ibm.com, a.p.zijlstra@chello.nl, sqazi@google.com,
        pjt@google.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20111115221121.7262.88871.stgit@dungbeetle.mtv.corp.google.com>
References: <20111115221121.7262.88871.stgit@dungbeetle.mtv.corp.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched, x86: Avoid unnecessary overflow in sched_clock
Git-Commit-ID: 4cecf6d401a01d054afc1e5f605bcbfe553cb9b9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 18 Nov 2011 15:45:18 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4cecf6d401a01d054afc1e5f605bcbfe553cb9b9
Gitweb:     http://git.kernel.org/tip/4cecf6d401a01d054afc1e5f605bcbfe553cb9b9
Author:     Salman Qazi <sqazi@google.com>
AuthorDate: Tue, 15 Nov 2011 14:12:06 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 16 Nov 2011 19:51:25 +0100

sched, x86: Avoid unnecessary overflow in sched_clock

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
Cc: stable@kernel.org
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20111115221121.7262.88871.stgit@dungbeetle.mtv.corp.google.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
 
