Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965202Ab1C3VJo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:09:44 -0400
Received: from mga01.intel.com ([192.55.52.88]:24598 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965000Ab1C3VJl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:09:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="673448517"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: miltonm@bga.com, jbeulich@novell.com, torvalds@linux-foundation.org,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [215/275] smp_call_function_many: handle concurrent clearing of mask
Message-Id: <20110330210740.146AA3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:07:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Milton Miller <miltonm@bga.com>

commit 723aae25d5cdb09962901d36d526b44d4be1051c upstream.

Mike Galbraith reported finding a lockup ("perma-spin bug") where the
cpumask passed to smp_call_function_many was cleared by other cpu(s)
while a cpu was preparing its call_data block, resulting in no cpu to
clear the last ref and unlock the block.

Having cpus clear their bit asynchronously could be useful on a mask of
cpus that might have a translation context, or cpus that need a push to
complete an rcu window.

Instead of adding a BUG_ON and requiring yet another cpumask copy, just
detect the race and handle it.

Note: arch_send_call_function_ipi_mask must still handle an empty
cpumask because the data block is globally visible before the that arch
callback is made.  And (obviously) there are no guarantees to which cpus
are notified if the mask is changed during the call; only cpus that were
online and had their mask bit set during the whole call are guaranteed
to be called.

Reported-by: Mike Galbraith <efault@gmx.de>
Reported-by: Jan Beulich <JBeulich@novell.com>
Acked-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Milton Miller <miltonm@bga.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 kernel/smp.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

Index: linux-2.6.35.y/kernel/smp.c
===================================================================
--- linux-2.6.35.y.orig/kernel/smp.c	2011-03-29 23:03:02.689231360 -0700
+++ linux-2.6.35.y/kernel/smp.c	2011-03-29 23:03:02.732230259 -0700
@@ -427,7 +427,7 @@
 {
 	struct call_function_data *data;
 	unsigned long flags;
-	int cpu, next_cpu, this_cpu = smp_processor_id();
+	int refs, cpu, next_cpu, this_cpu = smp_processor_id();
 
 	/*
 	 * Can deadlock when called with interrupts disabled.
@@ -438,7 +438,7 @@
 	WARN_ON_ONCE(cpu_online(this_cpu) && irqs_disabled()
 		     && !oops_in_progress);
 
-	/* So, what's a CPU they want? Ignoring this one. */
+	/* Try to fastpath.  So, what's a CPU they want? Ignoring this one. */
 	cpu = cpumask_first_and(mask, cpu_online_mask);
 	if (cpu == this_cpu)
 		cpu = cpumask_next_and(cpu, mask, cpu_online_mask);
@@ -496,6 +496,13 @@
 	/* We rely on the "and" being processed before the store */
 	cpumask_and(data->cpumask, mask, cpu_online_mask);
 	cpumask_clear_cpu(this_cpu, data->cpumask);
+	refs = cpumask_weight(data->cpumask);
+
+	/* Some callers race with other cpus changing the passed mask */
+	if (unlikely(!refs)) {
+		csd_unlock(&data->csd);
+		return;
+	}
 
 	raw_spin_lock_irqsave(&call_function.lock, flags);
 	/*
@@ -509,7 +516,7 @@
 	 * to the cpumask before this write to refs, which indicates
 	 * data is on the list and is ready to be processed.
 	 */
-	atomic_set(&data->refs, cpumask_weight(data->cpumask));
+	atomic_set(&data->refs, refs);
 	raw_spin_unlock_irqrestore(&call_function.lock, flags);
 
 	/*
