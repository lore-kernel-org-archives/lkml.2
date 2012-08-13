Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639Ab2HMUYN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 16:24:13 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51310 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754613Ab2HMUYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 16:24:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Theodore Tso" <tytso@mit.edu>, Sedat Dilek <sedat.dilek@gmail.com>
Subject: [ 57/82] random: remove rand_initialize_irq()
Date: Mon, 13 Aug 2012 13:19:33 -0700
Message-Id: <20120813201751.462729393@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120813201746.448504360@linuxfoundation.org>
References: <20120813201746.448504360@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit c5857ccf293968348e5eb4ebedc68074de3dcda6 upstream.

With the new interrupt sampling system, we are no longer using the
timer_rand_state structure in the irq descriptor, so we can stop
initializing it now.

[ Merged in fixes from Sedat to find some last missing references to
  rand_initialize_irq() ]

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/ia64/kernel/irq_ia64.c |    1 
 drivers/char/random.c       |   55 --------------------------------------------
 drivers/mfd/ab3100-core.c   |    3 --
 include/linux/irqdesc.h     |    1 
 include/linux/random.h      |    2 -
 kernel/irq/manage.c         |   17 -------------
 6 files changed, 79 deletions(-)

--- a/arch/ia64/kernel/irq_ia64.c
+++ b/arch/ia64/kernel/irq_ia64.c
@@ -23,7 +23,6 @@
 #include <linux/ioport.h>
 #include <linux/kernel_stat.h>
 #include <linux/ptrace.h>
-#include <linux/random.h>	/* for rand_initialize_irq() */
 #include <linux/signal.h>
 #include <linux/smp.h>
 #include <linux/threads.h>
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
--- a/drivers/mfd/ab3100-core.c
+++ b/drivers/mfd/ab3100-core.c
@@ -931,9 +931,6 @@ static int __devinit ab3100_probe(struct
 
 	err = request_threaded_irq(client->irq, NULL, ab3100_irq_handler,
 				IRQF_ONESHOT, "ab3100-core", ab3100);
-	/* This real unpredictable IRQ is of course sampled for entropy */
-	rand_initialize_irq(client->irq);
-
 	if (err)
 		goto exit_no_irq;
 
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
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -48,8 +48,6 @@ struct rnd_state {
 
 #ifdef __KERNEL__
 
-extern void rand_initialize_irq(int irq);
-
 extern void add_device_randomness(const void *, unsigned int);
 extern void add_input_randomness(unsigned int type, unsigned int code,
 				 unsigned int value);
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -893,22 +893,6 @@ __setup_irq(unsigned int irq, struct irq
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


