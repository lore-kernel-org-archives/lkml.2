Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867Ab2GPBJg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 21:09:36 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:39234 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752355Ab2GPBJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 21:09:34 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH] random: remove rand_initialize_irq()
Date: Sun, 15 Jul 2012 21:09:31 -0400
Message-Id: <1342400971-15245-1-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.7.11.1.108.gb129051
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the new interrupt sampling system, we are no longer using the
timer_rand_state structure in the irq descriptor, so we can stop
initializing it now.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 drivers/char/random.c   | 55 -------------------------------------------------
 include/linux/irqdesc.h |  1 -
 kernel/irq/manage.c     | 17 ---------------
 3 files changed, 73 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index e318085..9793b40 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -634,43 +634,6 @@ struct timer_rand_state {
 	unsigned dont_count_entropy:1;
 };
 
-#ifndef CONFIG_GENERIC_HARDIRQS
-
-static struct timer_rand_state *irq_timer_state[NR_IRQS];
-
-static struct timer_rand_state *get_timer_rand_state(unsigned int irq)
-{
-	return irq_timer_state[irq];
-}
-
-static void set_timer_rand_state(unsigned int irq,
-				 struct timer_rand_state *state)
-{
-	irq_timer_state[irq] = state;
-}
-
-#else
-
-static struct timer_rand_state *get_timer_rand_state(unsigned int irq)
-{
-	struct irq_desc *desc;
-
-	desc = irq_to_desc(irq);
-
-	return desc->timer_rand_state;
-}
-
-static void set_timer_rand_state(unsigned int irq,
-				 struct timer_rand_state *state)
-{
-	struct irq_desc *desc;
-
-	desc = irq_to_desc(irq);
-
-	desc->timer_rand_state = state;
-}
-#endif
-
 /*
  * Add device- or boot-specific data to the input and nonblocking
  * pools to help initialize them to unique values.
@@ -1133,24 +1096,6 @@ static int rand_initialize(void)
 }
 module_init(rand_initialize);
 
-void rand_initialize_irq(int irq)
-{
-	struct timer_rand_state *state;
-
-	state = get_timer_rand_state(irq);
-
-	if (state)
-		return;
-
-	/*
-	 * If kzalloc returns null, we just won't use that entropy
-	 * source.
-	 */
-	state = kzalloc(sizeof(struct timer_rand_state), GFP_KERNEL);
-	if (state)
-		set_timer_rand_state(irq, state);
-}
-
 #ifdef CONFIG_BLOCK
 void rand_initialize_disk(struct gendisk *disk)
 {
diff --git a/include/linux/irqdesc.h b/include/linux/irqdesc.h
index f1e2527..9a323d1 100644
--- a/include/linux/irqdesc.h
+++ b/include/linux/irqdesc.h
@@ -39,7 +39,6 @@ struct module;
  */
 struct irq_desc {
 	struct irq_data		irq_data;
-	struct timer_rand_state *timer_rand_state;
 	unsigned int __percpu	*kstat_irqs;
 	irq_flow_handler_t	handle_irq;
 #ifdef CONFIG_IRQ_PREFLOW_FASTEOI
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 8c54823..5e42eb1 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -893,22 +893,6 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 		return -ENOSYS;
 	if (!try_module_get(desc->owner))
 		return -ENODEV;
-	/*
-	 * Some drivers like serial.c use request_irq() heavily,
-	 * so we have to be careful not to interfere with a
-	 * running system.
-	 */
-	if (new->flags & IRQF_SAMPLE_RANDOM) {
-		/*
-		 * This function might sleep, we want to call it first,
-		 * outside of the atomic block.
-		 * Yes, this might clear the entropy pool if the wrong
-		 * driver is attempted to be loaded, without actually
-		 * installing a new handler, but is this really a problem,
-		 * only the sysadmin is able to do this.
-		 */
-		rand_initialize_irq(irq);
-	}
 
 	/*
 	 * Check whether the interrupt nests into another interrupt
@@ -1354,7 +1338,6 @@ EXPORT_SYMBOL(free_irq);
  *	Flags:
  *
  *	IRQF_SHARED		Interrupt is shared
- *	IRQF_SAMPLE_RANDOM	The interrupt can be used for entropy
  *	IRQF_TRIGGER_*		Specify active edge(s) or level
  *
  */
-- 
1.7.11.1.108.gb129051

