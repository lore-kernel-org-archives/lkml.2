Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756444Ab1KVO3h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 09:29:37 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42525 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756343Ab1KVO3e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 09:29:34 -0500
Subject: [patch 7/7] sched: only use TTWU_QUEUE when waker/wakee CPUs do
 not share top level cache
From: Mike Galbraith <mgalbraith@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Paul Turner <pjt@google.com>
In-Reply-To: <1321971445.6855.14.camel@marge.simson.net>
References: <1321350377.1421.55.camel@twins>
	 <1321406062.16760.60.camel@sbsiddha-desk.sc.intel.com>
	 <1321435455.5072.64.camel@marge.simson.net>
	 <1321468646.11680.2.camel@sbsiddha-desk.sc.intel.com>
	 <1321495153.5100.7.camel@marge.simson.net>
	 <1321544313.6308.25.camel@marge.simson.net>
	 <1321545376.2495.1.camel@laptop>
	 <1321547917.6308.48.camel@marge.simson.net>
	 <1321551381.15339.21.camel@sbsiddha-desk.sc.intel.com>
	 <1321629267.7080.13.camel@marge.simson.net>
	 <1321629441.7080.15.camel@marge.simson.net>
	 <1321630552.2197.15.camel@twins>
	 <1321971445.6855.14.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Nov 2011 15:26:25 +0100
Message-ID: <1321971985.6855.26.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


TTWU_QUEUE IPI overhead was measured to be as much as 13% of netperf TCP_RR
overhead when waking to a shared cache.  Don't IPI unless we're waking cross
cache, where it can be a winner.

Suggested by Peterz, tested by /me.

Signed-off-by: Mike Galbraith <efault@gmx.de>

---
 kernel/sched/core.c |   24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

Index: linux-3.0-tip/kernel/sched/core.c
===================================================================
--- linux-3.0-tip.orig/kernel/sched/core.c
+++ linux-3.0-tip/kernel/sched/core.c
@@ -1479,12 +1479,34 @@ static int ttwu_activate_remote(struct t
 #endif /* __ARCH_WANT_INTERRUPTS_ON_CTXSW */
 #endif /* CONFIG_SMP */
 
+static int ttwu_share_cache(int this_cpu, int cpu)
+{
+#ifndef CONFIG_X86
+	struct sched_domain *sd;
+	int ret = 0;
+
+	rcu_read_lock();
+	for_each_domain(this_cpu, sd) {
+		if (!cpumask_test_cpu(cpu, sched_domain_span(sd)))
+			continue;
+
+		ret = (sd->flags & SD_SHARE_PKG_RESOURCES);
+		break;
+	}
+	rcu_read_unlock();
+
+	return ret;
+#else
+	return per_cpu(cpu_llc_id, this_cpu) == per_cpu(cpu_llc_id, cpu);
+#endif
+}
+
 static void ttwu_queue(struct task_struct *p, int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
 
 #if defined(CONFIG_SMP)
-	if (sched_feat(TTWU_QUEUE) && cpu != smp_processor_id()) {
+	if (sched_feat(TTWU_QUEUE) && !ttwu_share_cache(smp_processor_id(), cpu)) {
 		sched_clock_cpu(cpu); /* sync clocks x-cpu */
 		ttwu_queue_remote(p, cpu);
 		return;


