Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932468Ab2L1TTy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:19:54 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55584 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932394Ab2L1TTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:19:32 -0500
Message-Id: <20121228190340.978015392@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:04:22 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [ 052/173] genirq: Always force thread affinity
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit 04aa530ec04f61875b99c12721162e2964e3318c upstream.

Sankara reported that the genirq core code fails to adjust the
affinity of an interrupt thread in several cases:

 1) On request/setup_irq() the call to setup_affinity() happens before
    the new action is registered, so the new thread is not notified.

 2) For secondary shared interrupts nothing notifies the new thread to
    change its affinity.

 3) Interrupts which have the IRQ_NO_BALANCE flag set are not moving
    the thread either.

Fix this by setting the thread affinity flag right on thread creation
time. This ensures that under all circumstances the thread moves to
the right place. Requires a check in irq_thread_check_affinity for an
existing affinity mask (CONFIG_CPU_MASK_OFFSTACK=y)

Reported-and-tested-by: Sankara Muthukrishnan <sankara.m@gmail.com>
Link: http://lkml.kernel.org/r/alpine.LFD.2.02.1209041738200.2754@ionos
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/irq/manage.c |   23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 1cbd572..35c70c9 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -732,6 +732,7 @@ static void
 irq_thread_check_affinity(struct irq_desc *desc, struct irqaction *action)
 {
 	cpumask_var_t mask;
+	bool valid = true;
 
 	if (!test_and_clear_bit(IRQTF_AFFINITY, &action->thread_flags))
 		return;
@@ -746,10 +747,18 @@ irq_thread_check_affinity(struct irq_desc *desc, struct irqaction *action)
 	}
 
 	raw_spin_lock_irq(&desc->lock);
-	cpumask_copy(mask, desc->irq_data.affinity);
+	/*
+	 * This code is triggered unconditionally. Check the affinity
+	 * mask pointer. For CPU_MASK_OFFSTACK=n this is optimized out.
+	 */
+	if (desc->irq_data.affinity)
+		cpumask_copy(mask, desc->irq_data.affinity);
+	else
+		valid = false;
 	raw_spin_unlock_irq(&desc->lock);
 
-	set_cpus_allowed_ptr(current, mask);
+	if (valid)
+		set_cpus_allowed_ptr(current, mask);
 	free_cpumask_var(mask);
 }
 #else
@@ -954,6 +963,16 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 		 */
 		get_task_struct(t);
 		new->thread = t;
+		/*
+		 * Tell the thread to set its affinity. This is
+		 * important for shared interrupt handlers as we do
+		 * not invoke setup_affinity() for the secondary
+		 * handlers as everything is already set up. Even for
+		 * interrupts marked with IRQF_NO_BALANCE this is
+		 * correct as we want the thread to move to the cpu(s)
+		 * on which the requesting code placed the interrupt.
+		 */
+		set_bit(IRQTF_AFFINITY, &new->thread_flags);
 	}
 
 	if (!alloc_cpumask_var(&mask, GFP_KERNEL)) {


