Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758572Ab2GLCgW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 22:36:22 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:51512 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756504Ab2GLCgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 22:36:18 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+ZknRRf1aZTgMCfX18+meUEP5cKfEdKfKNxu662X
	lUX8M4cLPTWu/I
Message-ID: <1342060574.7338.20.camel@marge.simpson.net>
Subject: Re: [patch RT 3/7] Disable RT_GROUP_SCHED in PREEMPT_RT_FULL
From: Mike Galbraith <efault@gmx.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        RT-users <linux-rt-users@vger.kernel.org>,
        Carsten Emde <C.Emde@osadl.org>
Date: Thu, 12 Jul 2012 04:36:14 +0200
In-Reply-To: <20120711215611.837510935@linutronix.de>
References: <20120711214552.036760674@linutronix.de>
	 <20120711215611.837510935@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-11 at 22:05 +0000, Thomas Gleixner wrote:
> plain text document attachment
> (disable-rt_group_sched-in-preempt_rt_full.patch)
> Strange CPU stalls have been observed in RT when RT_GROUP_SCHED
> was configured.
> 
> Disable it for now.
> 
> Signed-off-by: Carsten Emde <C.Emde@osadl.org>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> 
> ---
>  init/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> Index: linux-3.4.4-rt13-64+/init/Kconfig
> ===================================================================
> --- linux-3.4.4-rt13-64+.orig/init/Kconfig
> +++ linux-3.4.4-rt13-64+/init/Kconfig
> @@ -746,6 +746,7 @@ config RT_GROUP_SCHED
>  	bool "Group scheduling for SCHED_RR/FIFO"
>  	depends on EXPERIMENTAL
>  	depends on CGROUP_SCHED
> +	depends on !PREEMPT_RT_FULL
>  	default n
>  	help
>  	  This feature lets you explicitly allocate real CPU bandwidth
> 
> 
> 
> 
> 

I turn the thing off because it doesn't make any sense to me for -rt,
and because it's busted.  The below works around isolation bustage I
encountered.  Peter didn't like it (what's to like?) but it saves the
day, so shall live on in non-rt kernels until I hopefully someday see
RT_GROUP_SCHED being fed into a Bitwolf-9000 ;-)

sched,rt: fix isolated CPUs leaving root_task_group indefinitely throttled

Root task group bandwidth replentishment must service all CPUs regardless of
where it was last started.

Signed-off-by: Mike Galbraith <efault@gmx.de>
---
 kernel/sched/rt.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -782,6 +782,19 @@ static int do_sched_rt_period_timer(stru
 	const struct cpumask *span;
 
 	span = sched_rt_period_mask();
+#ifdef CONFIG_RT_GROUP_SCHED
+	/*
+	 * FIXME: isolated CPUs should really leave the root task group,
+	 * whether they are isolcpus or were isolated via cpusets, lest
+	 * the timer run on a CPU which does not service all runqueues,
+	 * potentially leaving other CPUs indefinitely throttled.  If
+	 * isolation is really required, the user will turn the throttle
+	 * off to kill the perturbations it causes anyway.  Meanwhile,
+	 * this maintains functionallity for boot and/or troubleshooting.
+	 */
+	if (rt_b == &root_task_group.rt_bandwidth)
+		span = cpu_online_mask;
+#endif
 	for_each_cpu(i, span) {
 		int enqueue = 0;
 		struct rt_rq *rt_rq = sched_rt_period_rt_rq(rt_b, i);


