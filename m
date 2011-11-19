Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757360Ab1KSEaR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 23:30:17 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:41054 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751744Ab1KSEaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 23:30:15 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+35e5WeBq3+UPVT8k4ydHqo5yy1DNq7qrG19Tl6A
	NHZOp2i2XMrYHn
Subject: Re: [patch 5/6] sched: disable sched feature TTWU_QUEUE by default
From: Mike Galbraith <efault@gmx.de>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Venki Pallipadi <venki@google.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Tim Chen <tim.c.chen@linux.jf.intel.com>, alex.shi@intel.com
In-Reply-To: <20111118230554.105376150@sbsiddha-desk.sc.intel.com>
References: <20111118230323.592022417@sbsiddha-desk.sc.intel.com>
	 <20111118230554.105376150@sbsiddha-desk.sc.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 19 Nov 2011 05:30:09 +0100
Message-ID: <1321677009.6307.13.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-11-18 at 15:03 -0800, Suresh Siddha wrote:
> plain text document attachment (disable_sched_ttwu_queue.patch)
> Context-switch intensive microbenchmark on a 8-socket system had
> ~600K times more resched IPI's on each logical CPU with this feature enabled
> by default. Disabling this features makes that microbenchmark perform 5 times
> better.
> 
> Also disabling this feature showed 2% performance improvement on a 8-socket
> OLTP workload.
> 
> More heurestics are needed when and how to use this feature by default.
> For now, disable it by default.

Yeah, the overhead for very hefty switchers is high enough to increase
TCP_RR latency up to 13% in my testing.  I used a trylock() to generally
not eat that, but leave the contended case improvement intact.

Peter suggested trying doing the IPI only when crossing cache
boundaries, which worked for me as well.

---
 kernel/sched.c |   24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

Index: linux-3.0-tip/kernel/sched.c
===================================================================
--- linux-3.0-tip.orig/kernel/sched.c
+++ linux-3.0-tip/kernel/sched.c
@@ -2784,12 +2784,34 @@ static int ttwu_activate_remote(struct t
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
  

