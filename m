Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067Ab1BAHMf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 02:12:35 -0500
Received: from mail4.comsite.net ([205.238.176.238]:42392 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab1BAHMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 02:12:34 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=71.22.127.106;
Subject: [PATCH 2/3 v2] smp_call_function_many: handle concurrent clearing of mask
To: akpm@linux-foundation.org, Mike Galbraith <efault@gmx.de>
From: Milton Miller <miltonm@bga.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Anton Blanchard <anton@samba.org>,
        xiaoguangrong@cn.fujitsu.com, mingo@elte.hu, jaxboe@fusionio.com,
        npiggin@gmail.com, rusty@rustcorp.com.au,
        torvalds@linux-foundation.org, paulmck@linux.vnet.ibm.com,
        benh@kernel.crashing.org, linux-kernel@vger.kernel.org
Message-ID: <smp-ipi-mask-clear-race@mdm.bga.com>
In-Reply-To: <ipi-list-reply@mdm.bga.com>
References: <20110112150740.77dde58c@kryten>
	 <1295288253.30950.280.camel@laptop>
	 <smp-call-function-peter-reply@mdm.bga.com>
	 <smp-call-function-move-writes@mdm.bga.com>
	 <1296145360.15234.234.camel@laptop>
	 <smp-call-function-list-race@mdm.bga.com>
	 <smp-call-function-list-race-fix@mdm.bga.com>
	 <1296458482.7889.175.camel@marge.simson.net>
	 <ipi-list-reply@mdm.bga.com>
Date: Tue, 01 Feb 2011 01:12:33 -0600
X-Originating-IP: 71.22.127.106
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Galbraith reported finding a lockup ("perma-spin bug") where the
cpumask passed to smp_call_function_many was cleared by other cpu(s)
while a cpu was preparing its call_data block, resulting in no cpu to
clear the last ref and unlock the block.

Having cpus clear their bit asynchronously could be useful on a mask of
cpus that might have a translation context, or cpus that need a push to
complete an rcu window.

Instead of adding a BUG_ON and requiring yet another cpumask copy, just
detect the race and handle it.

Note: arch_send_call_function_ipi_mask must still handle an empty cpumask
because the data block is globally visible before the that arch callback
is made.  And (obviously) there are no guarantees to which cpus are
notified if the mask is changed during the call; only cpus that were online
and had their mask bit set during the whole call are guaranteed to be called.

Reported-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Milton Miller <miltonm@bga.com>
---
v2: rediff for v2 of call_function_many: fix list delete vs add race

The arch code not expecting the race to empty the mask is the cause
of https://bugzilla.kernel.org/show_bug.cgi?id=23042 that Andrew pointed
out.


Index: linux-2.6/kernel/smp.c
===================================================================
--- linux-2.6.orig/kernel/smp.c	2011-01-31 18:25:47.266755387 -0600
+++ linux-2.6/kernel/smp.c	2011-01-31 18:46:37.848099236 -0600
@@ -450,7 +450,7 @@ void smp_call_function_many(const struct
 {
 	struct call_function_data *data;
 	unsigned long flags;
-	int cpu, next_cpu, this_cpu = smp_processor_id();
+	int refs, cpu, next_cpu, this_cpu = smp_processor_id();
 
 	/*
 	 * Can deadlock when called with interrupts disabled.
@@ -489,6 +489,13 @@ void smp_call_function_many(const struct
 	data->csd.info = info;
 	cpumask_and(data->cpumask, mask, cpu_online_mask);
 	cpumask_clear_cpu(this_cpu, data->cpumask);
+	refs = cpumask_weight(data->cpumask);
+
+	/* some callers might race with other cpus changing the mask */
+	if (unlikely(!refs)) {
+		csd_unlock(&data->csd);
+		return;
+	}
 
 	/*
 	 * We reuse the call function data without waiting for any grace
@@ -512,7 +519,7 @@ void smp_call_function_many(const struct
 	 * We rely on the wmb() in list_add_rcu to order the writes
 	 * to func, data, and cpumask before this write to refs.
 	 */
-	atomic_set(&data->refs, cpumask_weight(data->cpumask));
+	atomic_set(&data->refs, refs);
 	raw_spin_unlock_irqrestore(&call_function.lock, flags);
 
 	/*
