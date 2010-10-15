Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751263Ab0JOEFS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 00:05:18 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53036 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841Ab0JOEFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 00:05:16 -0400
Date: Fri, 15 Oct 2010 00:05:15 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: linux-kernel@vger.kernel.org
Cc: Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>, linux-cris-kernel@axis.com,
        kyle@mcmartin.ca
Subject: [PATCH 1/4] cris: use set_irq_chip helpers
Message-ID: <20101015040515.GB6333@bombadil.infradead.org>
References: <20101015040127.GA6333@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101015040127.GA6333@bombadil.infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

But just call __do_IRQ for ->handle_irq for now.

Signed-off-by: Kyle McMartin <kyle@redhat.com>
---
 arch/cris/arch-v10/kernel/irq.c |    2 +-
 arch/cris/arch-v32/kernel/irq.c |    2 +-
 arch/cris/include/asm/irq.h     |    3 +++
 arch/cris/kernel/irq.c          |    6 +++++-
 4 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/cris/arch-v10/kernel/irq.c b/arch/cris/arch-v10/kernel/irq.c
index a0c0df8..25d6252 100644
--- a/arch/cris/arch-v10/kernel/irq.c
+++ b/arch/cris/arch-v10/kernel/irq.c
@@ -221,7 +221,7 @@ init_IRQ(void)
 
 	/* Initialize IRQ handler descriptors. */
 	for(i = 2; i < NR_IRQS; i++) {
-		irq_desc[i].chip = &crisv10_irq_type;
+		set_irq_chip_and_handler(i, &crisv10_irq_type, cris_do_IRQ);
 		set_int_vector(i, interrupt[i]);
 	}
 
diff --git a/arch/cris/arch-v32/kernel/irq.c b/arch/cris/arch-v32/kernel/irq.c
index 2ed48ae..4c78afd 100644
--- a/arch/cris/arch-v32/kernel/irq.c
+++ b/arch/cris/arch-v32/kernel/irq.c
@@ -472,7 +472,7 @@ init_IRQ(void)
 
 	/* Point all IRQ's to bad handlers. */
 	for (i = FIRST_IRQ, j = 0; j < NR_IRQS; i++, j++) {
-		irq_desc[j].chip = &crisv32_irq_type;
+		set_irq_chip_and_handler(j, &crisv32_irq_type, cris_do_IRQ);
 		set_exception_vector(i, interrupt[j]);
 	}
 
diff --git a/arch/cris/include/asm/irq.h b/arch/cris/include/asm/irq.h
index ce0fcf5..3406c68 100644
--- a/arch/cris/include/asm/irq.h
+++ b/arch/cris/include/asm/irq.h
@@ -8,6 +8,9 @@ static inline int irq_canonicalize(int irq)
   return irq; 
 }
 
+struct irq_desc;
+extern void cris_do_IRQ(unsigned int irq, struct irq_desc *desc);
+
 #endif  /* _ASM_IRQ_H */
 
 
diff --git a/arch/cris/kernel/irq.c b/arch/cris/kernel/irq.c
index 469f7f9..b6d54eb 100644
--- a/arch/cris/kernel/irq.c
+++ b/arch/cris/kernel/irq.c
@@ -93,7 +93,7 @@ asmlinkage void do_IRQ(int irq, struct pt_regs * regs)
 		printk("do_IRQ: stack overflow: %lX\n", sp);
 		show_stack(NULL, (unsigned long *)sp);
 	}
-	__do_IRQ(irq);
+	generic_handle_irq(irq);
         irq_exit();
 	set_irq_regs(old_regs);
 }
@@ -105,3 +105,7 @@ void weird_irq(void)
 	while(1);
 }
 
+void cris_do_IRQ(unsigned int irq, struct irq_desc *desc)
+{
+	__do_IRQ(irq);
+}
-- 
1.7.3.1


