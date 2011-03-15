Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758405Ab1COU4P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 16:56:15 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59523 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757521Ab1COU4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 16:56:14 -0400
Date: Tue, 15 Mar 2011 21:56:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] irq/um changes for v2.6.39
Message-ID: <20110315205609.GA6559@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest um-irq-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git um-irq-for-linus

 Thanks,

	Ingo

------------------>
Thomas Gleixner (4):
      um: Remove stale irq_chip.end
      um: Convert irq_chips to new functions
      um: Use proper accessors in show_interrupts()
      um: Select GENERIC_HARDIRQS_NO_DEPRECATED


 arch/um/Kconfig.common |    1 +
 arch/um/kernel/irq.c   |   31 +++++++++++++++----------------
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/arch/um/Kconfig.common b/arch/um/Kconfig.common
index e351e14..1e78940 100644
--- a/arch/um/Kconfig.common
+++ b/arch/um/Kconfig.common
@@ -7,6 +7,7 @@ config UML
 	bool
 	default y
 	select HAVE_GENERIC_HARDIRQS
+	select GENERIC_HARDIRQS_NO_DEPRECATED
 
 config MMU
 	bool
diff --git a/arch/um/kernel/irq.c b/arch/um/kernel/irq.c
index 3f0ac9e..64cfea8 100644
--- a/arch/um/kernel/irq.c
+++ b/arch/um/kernel/irq.c
@@ -35,8 +35,10 @@ int show_interrupts(struct seq_file *p, void *v)
 	}
 
 	if (i < NR_IRQS) {
-		raw_spin_lock_irqsave(&irq_desc[i].lock, flags);
-		action = irq_desc[i].action;
+		struct irq_desc *desc = irq_to_desc(i);
+
+		raw_spin_lock_irqsave(&desc->lock, flags);
+		action = desc->action;
 		if (!action)
 			goto skip;
 		seq_printf(p, "%3d: ",i);
@@ -46,7 +48,7 @@ int show_interrupts(struct seq_file *p, void *v)
 		for_each_online_cpu(j)
 			seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
 #endif
-		seq_printf(p, " %14s", irq_desc[i].chip->name);
+		seq_printf(p, " %14s", get_irq_desc_chip(desc)->name);
 		seq_printf(p, "  %s", action->name);
 
 		for (action=action->next; action; action = action->next)
@@ -54,7 +56,7 @@ int show_interrupts(struct seq_file *p, void *v)
 
 		seq_putc(p, '\n');
 skip:
-		raw_spin_unlock_irqrestore(&irq_desc[i].lock, flags);
+		raw_spin_unlock_irqrestore(&desc->lock, flags);
 	} else if (i == NR_IRQS)
 		seq_putc(p, '\n');
 
@@ -360,10 +362,10 @@ EXPORT_SYMBOL(um_request_irq);
 EXPORT_SYMBOL(reactivate_fd);
 
 /*
- * irq_chip must define (startup || enable) &&
- * (shutdown || disable) && end
+ * irq_chip must define at least enable/disable and ack when
+ * the edge handler is used.
  */
-static void dummy(unsigned int irq)
+static void dummy(struct irq_data *d)
 {
 }
 
@@ -371,20 +373,17 @@ static void dummy(unsigned int irq)
 static struct irq_chip normal_irq_type = {
 	.name = "SIGIO",
 	.release = free_irq_by_irq_and_dev,
-	.disable = dummy,
-	.enable = dummy,
-	.ack = dummy,
-	.end = dummy
+	.irq_disable = dummy,
+	.irq_enable = dummy,
+	.irq_ack = dummy,
 };
 
 static struct irq_chip SIGVTALRM_irq_type = {
 	.name = "SIGVTALRM",
 	.release = free_irq_by_irq_and_dev,
-	.shutdown = dummy, /* never called */
-	.disable = dummy,
-	.enable = dummy,
-	.ack = dummy,
-	.end = dummy
+	.irq_disable = dummy,
+	.irq_enable = dummy,
+	.irq_ack = dummy,
 };
 
 void __init init_IRQ(void)
