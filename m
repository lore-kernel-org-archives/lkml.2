Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751120Ab1LHGGh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 01:06:37 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:41410 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751036Ab1LHGGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 01:06:36 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+BthkBUVSBIpfVpUcoW1uA6ak0EeNLDy/b279tfe
	kU9N2BSYCRX5Bo
Subject: Re: [patch v3 5/6] sched, ttwu_queue: queue remote wakeups only
 when crossing cache domains
From: Mike Galbraith <efault@gmx.de>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Venki Pallipadi <venki@google.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Tim Chen <tim.c.chen@linux.jf.intel.com>,
        "Shi, Alex" <alex.shi@intel.com>
In-Reply-To: <1323285644.1984.55.camel@sbsiddha-desk.sc.intel.com>
References: <20111202010731.344451602@sbsiddha-desk.sc.intel.com>
	 <20111202010832.714874234@sbsiddha-desk.sc.intel.com>
	 <1322796864.4755.5.camel@marge.simson.net>
	 <1323275027.32012.114.camel@twins>
	 <1323285644.1984.55.camel@sbsiddha-desk.sc.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Dec 2011 07:06:28 +0100
Message-ID: <1323324388.5118.16.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-07 at 11:20 -0800, Suresh Siddha wrote:
> On Wed, 2011-12-07 at 08:23 -0800, Peter Zijlstra wrote:
> > In fact, Ingo (rightfully) refused to take this due to the x86 specific
> > code in scheduler guts..
> 
> I noticed this while reviewing/testing the patch and left it because on
> the microbenchmark, it had measurable impact of using the direct check
> as compared to going through the scheduler domains every time to figure
> out if we shared the LLC or not.
> 
> > Initially the idea was to provide a new arch interface and a fallback
> > and do the Kconfig thing etc. After a bit of thought I decided against
> > that for we already have that information in the sched_domain tree
> > anyway and it should be a simple matter of representing things
> > differently.
> 
> This def looks better.

Yup.

> > +DEFINE_PER_CPU(int, sd_top_spr_id);
> 
> pkg_srid (shared resource id)?
> 
> > +
> > +static void update_top_cache_domain(int cpu)
> > +{
> > +	struct sched_domain *sd;
> > +	int id = -1;
> > +
> > +	sd = highest_flag_domain(cpu, SD_SHARE_PKG_RESOURCES);
> > +	if (sd)
> > +		id = cpumask_first(sched_domain_span(sd));
> 
> if there is no sd with shared pkg resources, then id has to be set to
> 'cpu'.
> 
> > +	rcu_assign_pointer(per_cpu(sd_top_spr, cpu), sd);
> > +	per_cpu(sd_top_spr_id, cpu) = id;
> 
> Otherwise it looks good.
> 
> Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>

Acked-by: Mike Galbraith <efault@gmx.de>

The stable regression fix should look about like so then, yes?

From: Peter Zijlstra <peterz@infradead.org>

sched, ttwu_queue: queue remote wakeups only when crossing cache domains

<Insert Peter's final changelog>

Acked-by: Mike Galbraith <efault@gmx.de>
Cc: stable@kernel.org # v3.0+

---
 kernel/sched.c |   51 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 50 insertions(+), 1 deletion(-)
Index: linux-3.0/kernel/sched.c
===================================================================
--- linux-3.0.orig/kernel/sched.c
+++ linux-3.0/kernel/sched.c
@@ -2636,6 +2636,19 @@ static int ttwu_activate_remote(struct t
 
 }
 #endif /* __ARCH_WANT_INTERRUPTS_ON_CTXSW */
+
+/*
+ * Keep a unique ID per domain (we use the first cpu number in
+ * the cpumask of the domain), this allows us to quickly tell if
+ * two cpus are in the same cache domain, see ttwu_share_cache().
+ */
+DEFINE_PER_CPU(int, sd_top_spr_id);
+
+static inline int ttwu_share_cache(int this_cpu, int that_cpu)
+{
+	return per_cpu(sd_top_spr_id, this_cpu) ==
+		per_cpu(sd_top_spr_id, that_cpu);
+}
 #endif /* CONFIG_SMP */
 
 static void ttwu_queue(struct task_struct *p, int cpu)
@@ -2643,7 +2656,7 @@ static void ttwu_queue(struct task_struc
 	struct rq *rq = cpu_rq(cpu);
 
 #if defined(CONFIG_SMP)
-	if (sched_feat(TTWU_QUEUE) && cpu != smp_processor_id()) {
+	if (sched_feat(TTWU_QUEUE) && !ttwu_share_cache(smp_processor_id(), cpu)) {
 		sched_clock_cpu(cpu); /* sync clocks x-cpu */
 		ttwu_queue_remote(p, cpu);
 		return;
@@ -6858,6 +6871,40 @@ static void destroy_sched_domains(struct
 		destroy_sched_domain(sd, cpu);
 }
 
+/**
+ * highest_flag_domain - Return highest sched_domain containing flag.
+ * @cpu:	The cpu whose highest level of sched domain is to
+ *		be returned.
+ * @flag:	The flag to check for the highest sched_domain
+ *		for the given cpu.
+ *
+ * Returns the highest sched_domain of a cpu which contains the given flag.
+ */
+static inline struct sched_domain *highest_flag_domain(int cpu, int flag)
+{
+	struct sched_domain *sd, *hsd = NULL;
+
+	for_each_domain(cpu, sd) {
+		if (!(sd->flags & flag))
+			break;
+		hsd = sd;
+	}
+
+	return hsd;
+}
+
+static void update_top_cache_domain(int cpu)
+{
+	struct sched_domain *sd;
+	int id = cpu;
+
+	sd = highest_flag_domain(cpu, SD_SHARE_PKG_RESOURCES);
+	if (sd)
+		id = cpumask_first(sched_domain_span(sd));
+
+	per_cpu(sd_top_spr_id, cpu) = id;
+}
+
 /*
  * Attach the domain 'sd' to 'cpu' as its base domain. Callers must
  * hold the hotplug lock.
@@ -6897,6 +6944,8 @@ cpu_attach_domain(struct sched_domain *s
 	tmp = rq->sd;
 	rcu_assign_pointer(rq->sd, sd);
 	destroy_sched_domains(tmp, cpu);
+
+	update_top_cache_domain(cpu);
 }
 
 /* cpus with isolated domains */



