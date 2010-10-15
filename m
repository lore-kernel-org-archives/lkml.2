Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549Ab0JOEau (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 00:30:50 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47990 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895Ab0JOEat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 00:30:49 -0400
Date: Fri, 15 Oct 2010 00:30:46 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: linux-kernel@vger.kernel.org
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Subject: [PATCH] h8300: get rid of __do_IRQ use
Message-ID: <20101015043046.GA22409@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace __do_IRQ use with handle_edge_irq handler, and remove some
redundant initialization.

Signed-off-by: Kyle McMartin <kyle@redhat.com>
---

This commit is neither boot tested, nor build tested, since the latest
kernel seems to be broken on the h8300 cross-compiler I was using...

 arch/h8300/Kconfig      |    4 ++++
 arch/h8300/kernel/irq.c |   16 ++++------------
 2 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/arch/h8300/Kconfig b/arch/h8300/Kconfig
index 988b6ff..937f5ae 100644
--- a/arch/h8300/Kconfig
+++ b/arch/h8300/Kconfig
@@ -58,6 +58,10 @@ config GENERIC_HARDIRQS
 	bool
 	default y
 
+config GENERIC_HARDIRQS_NO__DO_IRQ
+	bool
+	default y
+
 config GENERIC_CALIBRATE_DELAY
 	bool
 	default y
diff --git a/arch/h8300/kernel/irq.c b/arch/h8300/kernel/irq.c
index c25dc2c..acdbc07 100644
--- a/arch/h8300/kernel/irq.c
+++ b/arch/h8300/kernel/irq.c
@@ -50,10 +50,6 @@ static void h8300_disable_irq(unsigned int irq)
 		IER_REGS &= ~(1 << (irq - EXT_IRQ0));
 }
 
-static void h8300_end_irq(unsigned int irq)
-{
-}
-
 static unsigned int h8300_startup_irq(unsigned int irq)
 {
 	if (is_ext_irq(irq))
@@ -75,10 +71,9 @@ struct irq_chip h8300irq_chip = {
 	.name		= "H8300-INTC",
 	.startup	= h8300_startup_irq,
 	.shutdown	= h8300_shutdown_irq,
-	.enable		= h8300_enable_irq,
+	.unmask		= h8300_enable_irq,
+	.mask		= h8300_disable_irq,
 	.disable	= h8300_disable_irq,
-	.ack		= NULL,
-	.end		= h8300_end_irq,
 };
 
 #if defined(CONFIG_RAMKERNEL)
@@ -161,17 +156,14 @@ void __init init_IRQ(void)
 	setup_vector();
 
 	for (c = 0; c < NR_IRQS; c++) {
-		irq_desc[c].status = IRQ_DISABLED;
-		irq_desc[c].action = NULL;
-		irq_desc[c].depth = 1;
-		irq_desc[c].chip = &h8300irq_chip;
+		set_irq_chip_and_handler(c, &h8300_irq_chip, handle_edge_irq);
 	}
 }
 
 asmlinkage void do_IRQ(int irq)
 {
 	irq_enter();
-	__do_IRQ(irq);
+	generic_handle_irq(irq);
 	irq_exit();
 }
 
