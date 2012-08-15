Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932273Ab2HOT5P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:57:15 -0400
Received: from mail1.windriver.com ([147.11.146.13]:63176 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932222Ab2HOTw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:52:59 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: "Theodore Ts'o" <tytso@mit.edu>, Sedat Dilek <sedat.dilek@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 161/165] random: remove rand_initialize_irq()
Date: Wed, 15 Aug 2012 15:48:25 -0400
Message-ID: <1345060109-9187-162-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Theodore Ts'o <tytso@mit.edu>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit c5857ccf293968348e5eb4ebedc68074de3dcda6 upstream.

With the new interrupt sampling system, we are no longer using the
timer_rand_state structure in the irq descriptor, so we can stop
initializing it now.

[ Merged in fixes from Sedat to find some last missing references to
  rand_initialize_irq() ]

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
[PG: in .34 the irqdesc.h content is in irq.h instead.]
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/ia64/kernel/irq_ia64.c |  1 -
 drivers/char/random.c       | 55 ---------------------------------------------
 drivers/mfd/ab3100-core.c   |  3 ---
 include/linux/irq.h         |  1 -
 include/linux/random.h      |  2 --
 kernel/irq/manage.c         | 17 --------------
 6 files changed, 79 deletions(-)

diff --git a/arch/ia64/kernel/irq_ia64.c b/arch/ia64/kernel/irq_ia64.c
index 6404793..73a3f5b 100644
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
diff --git a/drivers/char/random.c b/drivers/char/random.c
index 14f1f23..1644b8e 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -629,43 +629,6 @@ struct timer_rand_state {
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
@@ -1134,24 +1097,6 @@ static int rand_initialize(void)
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
diff --git a/drivers/mfd/ab3100-core.c b/drivers/mfd/ab3100-core.c
index 2a193dc..5b7f5a90 100644
--- a/drivers/mfd/ab3100-core.c
+++ b/drivers/mfd/ab3100-core.c
@@ -890,9 +890,6 @@ static int __init ab3100_probe(struct i2c_client *client,
 
 	err = request_threaded_irq(client->irq, NULL, ab3100_irq_handler,
 				IRQF_ONESHOT, "ab3100-core", ab3100);
-	/* This real unpredictable IRQ is of course sampled for entropy */
-	rand_initialize_irq(client->irq);
-
 	if (err)
 		goto exit_no_irq;
 
diff --git a/include/linux/irq.h b/include/linux/irq.h
index 707ab12..7c2e4bf 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -174,7 +174,6 @@ struct irq_2_iommu;
  */
 struct irq_desc {
 	unsigned int		irq;
-	struct timer_rand_state *timer_rand_state;
 	unsigned int            *kstat_irqs;
 #ifdef CONFIG_INTR_REMAP
 	struct irq_2_iommu      *irq_2_iommu;
diff --git a/include/linux/random.h b/include/linux/random.h
index 5a376bc..1864957 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -44,8 +44,6 @@ struct rand_pool_info {
 
 #ifdef __KERNEL__
 
-extern void rand_initialize_irq(int irq);
-
 extern void add_device_randomness(const void *, unsigned int);
 extern void add_input_randomness(unsigned int type, unsigned int code,
 				 unsigned int value);
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 46f10b1..9080985 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -652,22 +652,6 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 
 	if (desc->chip == &no_irq_chip)
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
 
 	/* Oneshot interrupts are not allowed with shared */
 	if ((new->flags & IRQF_ONESHOT) && (new->flags & IRQF_SHARED))
@@ -1040,7 +1024,6 @@ EXPORT_SYMBOL(free_irq);
  *
  *	IRQF_SHARED		Interrupt is shared
  *	IRQF_DISABLED	Disable local interrupts while processing
- *	IRQF_SAMPLE_RANDOM	The interrupt can be used for entropy
  *	IRQF_TRIGGER_*		Specify active edge(s) or level
  *
  */
-- 
1.7.12.rc2

