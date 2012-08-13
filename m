Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186Ab2HMWLH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 18:11:07 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:35533 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754840Ab2HMWFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 18:05:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Theodore Tso" <tytso@mit.edu>, Sedat Dilek <sedat.dilek@gmail.com>
Subject: [ 31/44] random: remove rand_initialize_irq()
Date: Mon, 13 Aug 2012 15:02:38 -0700
Message-Id: <20120813220144.896927076@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120813220142.113186818@linuxfoundation.org>
References: <20120813220142.113186818@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/mfd/ab3550-core.c   |    2 -
 include/linux/irqdesc.h     |    1 
 include/linux/random.h      |    2 -
 kernel/irq/manage.c         |   17 -------------
 7 files changed, 81 deletions(-)

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
@@ -936,9 +936,6 @@ static int __devinit ab3100_probe(struct
 
 	err = request_threaded_irq(client->irq, NULL, ab3100_irq_handler,
 				IRQF_ONESHOT, "ab3100-core", ab3100);
-	/* This real unpredictable IRQ is of course sampled for entropy */
-	rand_initialize_irq(client->irq);
-
 	if (err)
 		goto exit_no_irq;
 
--- a/drivers/mfd/ab3550-core.c
+++ b/drivers/mfd/ab3550-core.c
@@ -1309,8 +1309,6 @@ static int __init ab3550_probe(struct i2
 
 	err = request_threaded_irq(client->irq, NULL, ab3550_irq_handler,
 		IRQF_ONESHOT, "ab3550-core", ab);
-	/* This real unpredictable IRQ is of course sampled for entropy */
-	rand_initialize_irq(client->irq);
 
 	if (err)
 		goto exit_no_irq;
--- a/include/linux/irqdesc.h
+++ b/include/linux/irqdesc.h
@@ -38,7 +38,6 @@ struct timer_rand_state;
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
@@ -886,22 +886,6 @@ __setup_irq(unsigned int irq, struct irq
 
 	if (desc->irq_data.chip == &no_irq_chip)
 		return -ENOSYS;
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
@@ -1325,7 +1309,6 @@ EXPORT_SYMBOL(free_irq);
  *	Flags:
  *
  *	IRQF_SHARED		Interrupt is shared
- *	IRQF_SAMPLE_RANDOM	The interrupt can be used for entropy
  *	IRQF_TRIGGER_*		Specify active edge(s) or level
  *
  */


