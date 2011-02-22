Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665Ab1BVQTf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 11:19:35 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41747 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754079Ab1BVQTe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 11:19:34 -0500
Date: Tue, 22 Feb 2011 17:19:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] irq fixes
Message-ID: <20110222161927.GA19980@elte.hu>
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

Please pull the latest irq-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git irq-fixes-for-linus

 Thanks,

	Ingo

------------------>
Thomas Gleixner (2):
      genirq: Prevent access beyond allocated_irqs bitmap
      genirq: Disable the SHIRQ_DEBUG call in request_threaded_irq for now


 kernel/irq/internals.h |    6 ++++++
 kernel/irq/irqdesc.c   |   11 ++++++++++-
 kernel/irq/manage.c    |    2 +-
 kernel/irq/resend.c    |    2 +-
 4 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/kernel/irq/internals.h b/kernel/irq/internals.h
index 4571ae7..99c3bc8 100644
--- a/kernel/irq/internals.h
+++ b/kernel/irq/internals.h
@@ -3,6 +3,12 @@
  */
 #include <linux/irqdesc.h>
 
+#ifdef CONFIG_SPARSE_IRQ
+# define IRQ_BITMAP_BITS	(NR_IRQS + 8196)
+#else
+# define IRQ_BITMAP_BITS	NR_IRQS
+#endif
+
 extern int noirqdebug;
 
 #define irq_data_to_desc(data)	container_of(data, struct irq_desc, irq_data)
diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index 282f202..2039bea 100644
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -94,7 +94,7 @@ int nr_irqs = NR_IRQS;
 EXPORT_SYMBOL_GPL(nr_irqs);
 
 static DEFINE_MUTEX(sparse_irq_lock);
-static DECLARE_BITMAP(allocated_irqs, NR_IRQS);
+static DECLARE_BITMAP(allocated_irqs, IRQ_BITMAP_BITS);
 
 #ifdef CONFIG_SPARSE_IRQ
 
@@ -217,6 +217,15 @@ int __init early_irq_init(void)
 	initcnt = arch_probe_nr_irqs();
 	printk(KERN_INFO "NR_IRQS:%d nr_irqs:%d %d\n", NR_IRQS, nr_irqs, initcnt);
 
+	if (WARN_ON(nr_irqs > IRQ_BITMAP_BITS))
+		nr_irqs = IRQ_BITMAP_BITS;
+
+	if (WARN_ON(initcnt > IRQ_BITMAP_BITS))
+		initcnt = IRQ_BITMAP_BITS;
+
+	if (initcnt > nr_irqs)
+		nr_irqs = initcnt;
+
 	for (i = 0; i < initcnt; i++) {
 		desc = alloc_desc(i, node);
 		set_bit(i, allocated_irqs);
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 0caa59f..9033c1c 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -1100,7 +1100,7 @@ int request_threaded_irq(unsigned int irq, irq_handler_t handler,
 	if (retval)
 		kfree(action);
 
-#ifdef CONFIG_DEBUG_SHIRQ
+#ifdef CONFIG_DEBUG_SHIRQ_FIXME
 	if (!retval && (irqflags & IRQF_SHARED)) {
 		/*
 		 * It's a shared IRQ -- the driver ought to be prepared for it
diff --git a/kernel/irq/resend.c b/kernel/irq/resend.c
index 891115a..dc49358 100644
--- a/kernel/irq/resend.c
+++ b/kernel/irq/resend.c
@@ -23,7 +23,7 @@
 #ifdef CONFIG_HARDIRQS_SW_RESEND
 
 /* Bitmap to handle software resend of interrupts: */
-static DECLARE_BITMAP(irqs_resend, NR_IRQS);
+static DECLARE_BITMAP(irqs_resend, IRQ_BITMAP_BITS);
 
 /*
  * Run software resends of IRQ's
