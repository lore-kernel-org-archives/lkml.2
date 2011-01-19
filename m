Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097Ab1ASVtP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 16:49:15 -0500
Received: from www.tglx.de ([62.245.132.106]:33331 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753989Ab1ASVtN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 16:49:13 -0500
Message-Id: <20110119210838.904608692@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 19 Jan 2011 21:48:09 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Paul Mundt <lethal@linux-sh.org>
Subject: [patch 02/37] h8300: Convert interrupt handling to flow handler
References: <20110119205258.462759212@linutronix.de>
Content-Disposition: inline; filename=h8300-convert-to-flow-handler.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__do_IRQ is deprecated so h8300 needs to be converted to proper flow
handling. The irq chip is simple and does not required any
mask/ack/eoi functions, so we can use handle_simple_irq.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Paul Mundt <lethal@linux-sh.org>
---
 arch/h8300/kernel/irq.c |   15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

Index: linux-2.6/arch/h8300/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/h8300/kernel/irq.c
+++ linux-2.6/arch/h8300/kernel/irq.c
@@ -50,10 +50,6 @@ static void h8300_disable_irq(struct irq
 		IER_REGS &= ~(1 << (data->irq - EXT_IRQ0));
 }
 
-static void h8300_end_irq(unsigned int irq)
-{
-}
-
 static unsigned int h8300_startup_irq(struct irq_data *data)
 {
 	if (is_ext_irq(data->irq))
@@ -77,7 +73,6 @@ struct irq_chip h8300irq_chip = {
 	.irq_shutdown	= h8300_shutdown_irq,
 	.irq_enable	= h8300_enable_irq,
 	.irq_disable	= h8300_disable_irq,
-	.end		= h8300_end_irq,
 };
 
 #if defined(CONFIG_RAMKERNEL)
@@ -159,18 +154,14 @@ void __init init_IRQ(void)
 
 	setup_vector();
 
-	for (c = 0; c < NR_IRQS; c++) {
-		irq_desc[c].status = IRQ_DISABLED;
-		irq_desc[c].action = NULL;
-		irq_desc[c].depth = 1;
-		irq_desc[c].chip = &h8300irq_chip;
-	}
+	for (c = 0; c < NR_IRQS; c++)
+		set_irq_chip_and_handler(c, &h8300irq_chip, handle_simple_irq);
 }
 
 asmlinkage void do_IRQ(int irq)
 {
 	irq_enter();
-	__do_IRQ(irq);
+	generic_handle_irq(irq);
 	irq_exit();
 }
 


