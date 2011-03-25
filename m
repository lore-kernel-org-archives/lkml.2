Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174Ab1CYND2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 09:03:28 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56594 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751224Ab1CYND1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 09:03:27 -0400
Date: Fri, 25 Mar 2011 14:03:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] irq fixes
Message-ID: <20110325130318.GA9827@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest irq-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git irq-fixes-for-linus

 Thanks,

	Ingo

------------------>
Thomas Gleixner (3):
      genirq; Remove the last leftovers of the old sparse irq code
      genirq: Provide a lockdep helper
      genirq: Provide locked setter for chip, handler, name


 include/linux/irqdesc.h |   45 +++++++++++++++++++++++++++++++++------------
 kernel/irq/irqdesc.c    |   14 --------------
 2 files changed, 33 insertions(+), 26 deletions(-)

diff --git a/include/linux/irqdesc.h b/include/linux/irqdesc.h
index 0021837..15e6c39 100644
--- a/include/linux/irqdesc.h
+++ b/include/linux/irqdesc.h
@@ -100,13 +100,6 @@ struct irq_desc {
 extern struct irq_desc irq_desc[NR_IRQS];
 #endif
 
-/* Will be removed once the last users in power and sh are gone */
-extern struct irq_desc *irq_to_desc_alloc_node(unsigned int irq, int node);
-static inline struct irq_desc *move_irq_desc(struct irq_desc *desc, int node)
-{
-	return desc;
-}
-
 #ifdef CONFIG_GENERIC_HARDIRQS
 
 static inline struct irq_data *irq_desc_get_irq_data(struct irq_desc *desc)
@@ -178,24 +171,52 @@ static inline int irq_has_action(unsigned int irq)
 	return desc->action != NULL;
 }
 
-#ifndef CONFIG_GENERIC_HARDIRQS_NO_COMPAT
-static inline int irq_balancing_disabled(unsigned int irq)
+/* caller has locked the irq_desc and both params are valid */
+static inline void __irq_set_handler_locked(unsigned int irq,
+					    irq_flow_handler_t handler)
 {
 	struct irq_desc *desc;
 
 	desc = irq_to_desc(irq);
-	return desc->status & IRQ_NO_BALANCING_MASK;
+	desc->handle_irq = handler;
 }
-#endif
 
 /* caller has locked the irq_desc and both params are valid */
+static inline void
+__irq_set_chip_handler_name_locked(unsigned int irq, struct irq_chip *chip,
+				   irq_flow_handler_t handler, const char *name)
+{
+	struct irq_desc *desc;
+
+	desc = irq_to_desc(irq);
+	irq_desc_get_irq_data(desc)->chip = chip;
+	desc->handle_irq = handler;
+	desc->name = name;
+}
+
+#ifndef CONFIG_GENERIC_HARDIRQS_NO_COMPAT
 static inline void __set_irq_handler_unlocked(int irq,
 					      irq_flow_handler_t handler)
 {
+	__irq_set_handler_locked(irq, handler);
+}
+
+static inline int irq_balancing_disabled(unsigned int irq)
+{
 	struct irq_desc *desc;
 
 	desc = irq_to_desc(irq);
-	desc->handle_irq = handler;
+	return desc->status & IRQ_NO_BALANCING_MASK;
+}
+#endif
+
+static inline void
+irq_set_lockdep_class(unsigned int irq, struct lock_class_key *class)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+
+	if (desc)
+		lockdep_set_class(&desc->lock, class);
 }
 
 #ifdef CONFIG_IRQ_PREFLOW_FASTEOI
diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index dbccc79..6fb014f 100644
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -198,15 +198,6 @@ err:
 	return -ENOMEM;
 }
 
-struct irq_desc * __ref irq_to_desc_alloc_node(unsigned int irq, int node)
-{
-	int res = irq_alloc_descs(irq, irq, 1, node);
-
-	if (res == -EEXIST || res == irq)
-		return irq_to_desc(irq);
-	return NULL;
-}
-
 static int irq_expand_nr_irqs(unsigned int nr)
 {
 	if (nr > IRQ_BITMAP_BITS)
@@ -283,11 +274,6 @@ struct irq_desc *irq_to_desc(unsigned int irq)
 	return (irq < NR_IRQS) ? irq_desc + irq : NULL;
 }
 
-struct irq_desc *irq_to_desc_alloc_node(unsigned int irq, int node)
-{
-	return irq_to_desc(irq);
-}
-
 static void free_desc(unsigned int irq)
 {
 	dynamic_irq_cleanup(irq);
