Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755734Ab1CUXW5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:22:57 -0400
Received: from kroah.org ([198.145.64.141]:52796 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932422Ab1CUXSb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:18:31 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:03:28 2011
Message-Id: <20110321230328.604758248@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:02:23 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jan Beulich <jbeulich@novell.com>, Milton Miller <miltonm@bga.com>
Subject: [67/78] smp_call_function_many: handle concurrent clearing of mask
In-Reply-To: <20110321230346.GA14681@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

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

---
 kernel/smp.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -450,7 +450,7 @@ void smp_call_function_many(const struct
 {
 	struct call_function_data *data;
 	unsigned long flags;
-	int cpu, next_cpu, this_cpu = smp_processor_id();
+	int refs, cpu, next_cpu, this_cpu = smp_processor_id();
 
 	/*
 	 * Can deadlock when called with interrupts disabled.
@@ -461,7 +461,7 @@ void smp_call_function_many(const struct
 	WARN_ON_ONCE(cpu_online(this_cpu) && irqs_disabled()
 		     && !oops_in_progress && !early_boot_irqs_disabled);
 
-	/* So, what's a CPU they want? Ignoring this one. */
+	/* Try to fastpath.  So, what's a CPU they want? Ignoring this one. */
 	cpu = cpumask_first_and(mask, cpu_online_mask);
 	if (cpu == this_cpu)
 		cpu = cpumask_next_and(cpu, mask, cpu_online_mask);
@@ -519,6 +519,13 @@ void smp_call_function_many(const struct
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
@@ -532,7 +539,7 @@ void smp_call_function_many(const struct
 	 * to the cpumask before this write to refs, which indicates
 	 * data is on the list and is ready to be processed.
 	 */
-	atomic_set(&data->refs, cpumask_weight(data->cpumask));
+	atomic_set(&data->refs, refs);
 	raw_spin_unlock_irqrestore(&call_function.lock, flags);
 
 	/*


