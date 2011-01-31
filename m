Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292Ab1AaU0U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 15:26:20 -0500
Received: from mail4.comsite.net ([205.238.176.238]:4912 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754270Ab1AaU0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 15:26:18 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=71.22.127.106;
Subject: [PATCH] smp_call_function_many: handle concurrent clearing of mask
To: Mike Galbraith <efault@gmx.de>
From: Milton Miller <miltonm@bga.com>
Cc: Peter Zijlstra <peterz@infradead.org>, akpm@linux-foundation.org,
        Anton Blanchard <anton@samba.org>, xiaoguangrong@cn.fujitsu.com,
        mingo@elte.hu, jaxboe@fusionio.com, npiggin@gmail.com,
        rusty@rustcorp.com.au, torvalds@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, benh@kernel.crashing.org,
        linux-kernel@vger.kernel.org
Message-ID: <smp-ipi-mike@mdm.bga.com>
In-Reply-To: <1296458482.7889.175.camel@marge.simson.net>
References: <20110112150740.77dde58c@kryten>
	 <1295288253.30950.280.camel@laptop>
	 <smp-call-function-peter-reply@mdm.bga.com>
	 <smp-call-function-move-writes@mdm.bga.com>
	 <1296145360.15234.234.camel@laptop>
	 <smp-call-function-list-race@mdm.bga.com>
	 <smp-call-function-list-race-fix@mdm.bga.com>
	 <1296458482.7889.175.camel@marge.simson.net>
Date: Mon, 31 Jan 2011 14:26:17 -0600
X-Originating-IP: 71.22.127.106
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Jan 2011 about 08:21:22 +0100,  Mike Galbraith wrote:
> Wondering if a final sanity check makes sense.  I've got a perma-spin
> bug where comment apparently happened.  Another CPU's diddle the mask
> IPI may make this CPU do horrible things to itself as it's setting up to
> IPI others with that mask.
> 
> ---
>  kernel/smp.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> Index: linux-2.6.38.git/kernel/smp.c
> ===================================================================
> --- linux-2.6.38.git.orig/kernel/smp.c
> +++ linux-2.6.38.git/kernel/smp.c
> @@ -490,6 +490,9 @@ void smp_call_function_many(const struct
>  	cpumask_and(data->cpumask, mask, cpu_online_mask);
>  	cpumask_clear_cpu(this_cpu, data->cpumask);
>  
> +	/* Did you pass me a mask that can be changed/emptied under me? */
> +	BUG_ON(cpumask_empty(data->cpumask));
> +

I was thinking of this as "the ipi cpumask was cleared", but I realize now
you are saying the caller passed in a cpumask, but between the cpu_first/
cpu_next calls above and the cpumask_and another cpu cleared all the cpus?

I could see how that could happen on say a mask of cpus that might have a
translation context, or cpus that need a push to complete an rcu window.
Instead of the BUG_ON, we can handle the mask being cleared.

The arch code to send the IPI must handle an empty mask, as the other
cpus are racing to clear their bit while its trying to send the IPI.
In fact that expected race is the cause of the x86 warning in bz 23042
https://bugzilla.kernel.org/show_bug.cgi?id=23042  that Andrew pointed
out.


How about this [untested] patch?

Mike Galbraith reported finding a lockup where aparently the passed in
cpumask was cleared on other cpu(s) while this cpu was preparing its
smp_call_function_many block.   Detect this race and unlock the call
data block.  Note: arch_send_call_function_ipi_mask must still handle an
empty mask because the element is globally visable before it is called.
And obviously there are no guarantees to which cpus are notified if the
mask is changed during the call.

Reported-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Milton Miller <miltonm@bga.com>
---
On top of "call_function_many: fix list delete vs add race"

Index: linux-2.6/kernel/smp.c
===================================================================
--- linux-2.6.orig/kernel/smp.c	2011-01-31 13:51:56.294049313 -0600
+++ linux-2.6/kernel/smp.c	2011-01-31 13:49:12.737064069 -0600
@@ -450,7 +450,7 @@
 {
 	struct call_function_data *data;
 	unsigned long flags;
-	int cpu, next_cpu, this_cpu = smp_processor_id();
+	int refs, cpu, next_cpu, this_cpu = smp_processor_id();
 
 	/*
 	 * Can deadlock when called with interrupts disabled.
@@ -489,6 +489,13 @@
 	data->csd.info = info;
 	cpumask_and(data->cpumask, mask, cpu_online_mask);
 	cpumask_clear_cpu(this_cpu, data->cpumask);
+	refs = cpumask_weight(data->cpumask);
+
+	/* Some uses might have cleared all cpus in the mask before the copy. */
+	if (unlikely(!refs)) {
+		csd_unlock(&data->csd);
+		return;
+	}
 
 	/*
 	 * We reuse the call function data without waiting for any grace
@@ -511,7 +518,7 @@
 	list_add_rcu(&data->csd.list, &call_function.queue);
 	raw_spin_unlock_irqrestore(&call_function.lock, flags);
 
-	atomic_set(&data->refs, cpumask_weight(data->cpumask));
+	atomic_set(&data->refs, refs);
 
 	/*
 	 * Make the list addition visible before sending the ipi.
