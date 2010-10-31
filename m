Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830Ab0JaN2O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 09:28:14 -0400
Received: from www.tglx.de ([62.245.132.106]:48279 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755639Ab0JaN2L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 09:28:11 -0400
Date: Sun, 31 Oct 2010 14:22:11 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: [GIT pull] genirq updates for 2.6.37
Message-ID: <alpine.LFD.2.00.1010311421200.2955@localhost6.localdomain6>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest irq-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git irq-core-for-linus

Thanks,

	tglx

------------------>
Paul Mundt (2):
      genirq: Add single IRQ reservation helper
      genirq: Fix up irq_node() for irq_data changes.

Thomas Gleixner (1):
      genirq: Warn if enable_irq is called before irq is set up


 include/linux/irq.h   |    5 +++++
 include/linux/irqnr.h |    2 +-
 kernel/irq/manage.c   |    4 ++++
 3 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index e963911..abde252 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -412,6 +412,11 @@ static inline void irq_free_desc(unsigned int irq)
 	irq_free_descs(irq, 1);
 }
 
+static inline int irq_reserve_irq(unsigned int irq)
+{
+	return irq_reserve_irqs(irq, 1);
+}
+
 #endif /* CONFIG_GENERIC_HARDIRQS */
 
 #endif /* !CONFIG_S390 */
diff --git a/include/linux/irqnr.h b/include/linux/irqnr.h
index 05aa8c23..3bc4dca 100644
--- a/include/linux/irqnr.h
+++ b/include/linux/irqnr.h
@@ -43,7 +43,7 @@ unsigned int irq_get_next_irq(unsigned int offset);
 		else
 
 #ifdef CONFIG_SMP
-#define irq_node(irq)	(irq_to_desc(irq)->node)
+#define irq_node(irq)	(irq_get_irq_data(irq)->node)
 #else
 #define irq_node(irq)	0
 #endif
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 644e8d5..5f92acc 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -324,6 +324,10 @@ void enable_irq(unsigned int irq)
 	if (!desc)
 		return;
 
+	if (WARN(!desc->irq_data.chip || !desc->irq_data.chip->irq_enable,
+	    KERN_ERR "enable_irq before setup/request_irq: irq %u\n", irq))
+		return;
+
 	chip_bus_lock(desc);
 	raw_spin_lock_irqsave(&desc->lock, flags);
 	__enable_irq(desc, irq, false);
