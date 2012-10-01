Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964811Ab2JAXSi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:18:38 -0400
Received: from 1wt.eu ([62.212.114.60]:35432 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757637Ab2JAXBu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:01:50 -0400
Message-Id: <20121001225205.075216172@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:54:53 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: "Theodore Tso" <tytso@mit.edu>, Sedat Dilek <sedat.dilek@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 176/180] random: remove rand_initialize_irq()
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

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
[PG: in .34 the irqdesc.h content is in irq.h instead.]
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 arch/ia64/kernel/irq_ia64.c |    1 -
 drivers/char/random.c       |   55 -------------------------------------------
 include/linux/irq.h         |    1 -
 include/linux/random.h      |    2 -
 kernel/irq/manage.c         |   17 -------------
 5 files changed, 0 insertions(+), 76 deletions(-)

diff --git a/arch/ia64/kernel/irq_ia64.c b/arch/ia64/kernel/irq_ia64.c
index dd9d7b5..463b8a7 100644
--- a/arch/ia64/kernel/irq_ia64.c
+++ b/arch/ia64/kernel/irq_ia64.c
@@ -24,7 +24,6 @@
 #include <linux/kernel_stat.h>
 #include <linux/slab.h>
 #include <linux/ptrace.h>
-#include <linux/random.h>	/* for rand_initialize_irq() */
 #include <linux/signal.h>
 #include <linux/smp.h>
 #include <linux/threads.h>
diff --git a/drivers/char/random.c b/drivers/char/random.c
index 3ea1ddb..cbb63b0 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -621,43 +621,6 @@ struct timer_rand_state {
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
@@ -1123,24 +1086,6 @@ static int rand_initialize(void)
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
diff --git a/include/linux/irq.h b/include/linux/irq.h
index 9e5f45a..2333710 100644
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
index 315705c..5dd29f3 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -633,22 +633,6 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 
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
@@ -1021,7 +1005,6 @@ EXPORT_SYMBOL(free_irq);
  *
  *	IRQF_SHARED		Interrupt is shared
  *	IRQF_DISABLED	Disable local interrupts while processing
- *	IRQF_SAMPLE_RANDOM	The interrupt can be used for entropy
  *	IRQF_TRIGGER_*		Specify active edge(s) or level
  *
  */
-- 
1.7.2.1.45.g54fbc



