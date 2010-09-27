Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932922Ab0I0Mqc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 08:46:32 -0400
Received: from www.tglx.de ([62.245.132.106]:48903 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759249Ab0I0Mqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 08:46:30 -0400
Message-Id: <20100927121843.119867950@linutronix.de>
User-Agent: quilt/0.48-1
Date: Mon, 27 Sep 2010 12:45:56 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 17/19] genirq: Switch dummy_chip and no_irq_chip to new
	functions
References: <20100927121651.904100669@linutronix.de>
Content-Disposition: inline; filename=genirq-fixup-dummy-chip.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/handle.c |   44 ++++++++++++++++++++++++--------------------
 1 file changed, 24 insertions(+), 20 deletions(-)

Index: linux-2.6-tip/kernel/irq/handle.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/handle.c
+++ linux-2.6-tip/kernel/irq/handle.c
@@ -303,37 +303,41 @@ void clear_kstat_irqs(struct irq_desc *d
  * What should we do if we get a hw irq event on an illegal vector?
  * Each architecture has to answer this themself.
  */
-static void ack_bad(unsigned int irq)
+static void ack_bad(struct irq_data *data)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
+	struct irq_desc *desc = irq_data_to_desc(data);
 
-	print_irq_desc(irq, desc);
-	ack_bad_irq(irq);
+	print_irq_desc(data->irq, desc);
+	ack_bad_irq(data->irq);
 }
 
 /*
  * NOP functions
  */
-static void noop(unsigned int irq)
+static void noop(struct irq_data *data)
 {
 }
 
-static unsigned int noop_ret(unsigned int irq)
+static unsigned int noop_ret(struct irq_data *data)
 {
 	return 0;
 }
 
+static void compat_noop(unsigned int irq)
+{
+}
+
 /*
  * Generic no controller implementation
  */
 struct irq_chip no_irq_chip = {
 	.name		= "none",
-	.startup	= noop_ret,
-	.shutdown	= noop,
-	.enable		= noop,
-	.disable	= noop,
-	.ack		= ack_bad,
-	.end		= noop,
+	.irq_startup	= noop_ret,
+	.irq_shutdown	= noop,
+	.irq_enable	= noop,
+	.irq_disable	= noop,
+	.irq_ack	= ack_bad,
+	.end		= compat_noop,
 };
 
 /*
@@ -342,14 +346,14 @@ struct irq_chip no_irq_chip = {
  */
 struct irq_chip dummy_irq_chip = {
 	.name		= "dummy",
-	.startup	= noop_ret,
-	.shutdown	= noop,
-	.enable		= noop,
-	.disable	= noop,
-	.ack		= noop,
-	.mask		= noop,
-	.unmask		= noop,
-	.end		= noop,
+	.irq_startup	= noop_ret,
+	.irq_shutdown	= noop,
+	.irq_enable	= noop,
+	.irq_disable	= noop,
+	.irq_ack	= noop,
+	.irq_mask	= noop,
+	.irq_unmask	= noop,
+	.end		= compat_noop,
 };
 
 /*


