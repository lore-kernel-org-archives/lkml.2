Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757504Ab1BJXhJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:37:09 -0500
Received: from www.tglx.de ([62.245.132.106]:44129 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757357Ab1BJXhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:37:04 -0500
Message-Id: <20110210223256.156113172@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 10 Feb 2011 23:36:33 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Greg Ungerer <gerg@uclinux.org>
Subject: [patch 19/75] m68knommu: 5772: Replace private irq flow handler
References: <20110210222908.661199947@linutronix.de>
Content-Disposition: inline;
	filename=m68knommu-5772-replace-private-irq-flow-handler.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That handler lacks the minimal checks for action being zero etc. Keep
the weird flow - ack before handling - intact and call into
handle_simple_irq which does the right thing.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Acked-by: Greg Ungerer <gerg@uclinux.org>
LKML-Reference: <20110202212552.413849952@linutronix.de>
---
 arch/m68knommu/platform/5272/intc.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

Index: linux-2.6-tip/arch/m68knommu/platform/5272/intc.c
===================================================================
--- linux-2.6-tip.orig/arch/m68knommu/platform/5272/intc.c
+++ linux-2.6-tip/arch/m68knommu/platform/5272/intc.c
@@ -137,11 +137,8 @@ static int intc_irq_set_type(unsigned in
  */
 static void intc_external_irq(unsigned int irq, struct irq_desc *desc)
 {
-	kstat_incr_irqs_this_cpu(irq, desc);
-	desc->status |= IRQ_INPROGRESS;
-	desc->chip->ack(irq);
-	handle_IRQ_event(irq, desc->action);
-	desc->status &= ~IRQ_INPROGRESS;
+	get_irq_desc_chip(desc)->irq_ack(irq);
+	handle_simple_irq(irq, desc);
 }
 
 static struct irq_chip intc_irq_chip = {


