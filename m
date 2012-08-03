Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949Ab2HCQhl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 12:37:41 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:38568 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863Ab2HCQhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 12:37:20 -0400
Date: Fri, 3 Aug 2012 18:37:15 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] irq fix
Message-ID: <20120803163715.GA1721@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest irq-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq-urgent-for-linus

   HEAD: dc9b229a58dc0dfed34272ff26c6d5fd17c674e0 genirq: Allow irq chips to mark themself oneshot safe

 Thanks,

	Ingo

------------------>
Thomas Gleixner (1):
      genirq: Allow irq chips to mark themself oneshot safe


 include/linux/irq.h |    1 +
 kernel/irq/manage.c |   15 ++++++++++++++-
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index 553fb66..216b0ba 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -349,6 +349,7 @@ enum {
 	IRQCHIP_MASK_ON_SUSPEND		= (1 <<  2),
 	IRQCHIP_ONOFFLINE_ENABLED	= (1 <<  3),
 	IRQCHIP_SKIP_SET_WAKE		= (1 <<  4),
+	IRQCHIP_ONESHOT_SAFE		= (1 <<  5),
 };
 
 /* This include will go away once we isolated irq_desc usage to core code */
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 8c54823..2e326d1 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -960,6 +960,18 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 	}
 
 	/*
+	 * Drivers are often written to work w/o knowledge about the
+	 * underlying irq chip implementation, so a request for a
+	 * threaded irq without a primary hard irq context handler
+	 * requires the ONESHOT flag to be set. Some irq chips like
+	 * MSI based interrupts are per se one shot safe. Check the
+	 * chip flags, so we can avoid the unmask dance at the end of
+	 * the threaded handler for those.
+	 */
+	if (desc->irq_data.chip->flags & IRQCHIP_ONESHOT_SAFE)
+		new->flags &= ~IRQF_ONESHOT;
+
+	/*
 	 * The following block of code has to be executed atomically
 	 */
 	raw_spin_lock_irqsave(&desc->lock, flags);
@@ -1033,7 +1045,8 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 		 */
 		new->thread_mask = 1 << ffz(thread_mask);
 
-	} else if (new->handler == irq_default_primary_handler) {
+	} else if (new->handler == irq_default_primary_handler &&
+		   !(desc->irq_data.chip->flags & IRQCHIP_ONESHOT_SAFE)) {
 		/*
 		 * The interrupt was requested with handler = NULL, so
 		 * we use the default primary handler for it. But it
