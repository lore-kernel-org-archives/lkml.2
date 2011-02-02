Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489Ab1BBVmC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 16:42:02 -0500
Received: from www.tglx.de ([62.245.132.106]:38939 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754437Ab1BBVl7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 16:41:59 -0500
Message-Id: <20110202212552.413849952@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 02 Feb 2011 21:41:31 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Greg Ungerer <gerg@uclinux.org>
Subject: [patch 7/8] m68knommu: 5772: Replace private irq flow handler
References: <20110202212258.546660886@linutronix.de>
Content-Disposition: inline; filename=m68knommu-replace-private-handler.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That handler lacks the minimal checks for action being zero etc. Keep
the weird flow - ack before handling - intact and call into
handle_simple_irq which does the right thing.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Greg Ungerer <gerg@uclinux.org>
---
 arch/m68knommu/platform/5272/intc.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

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
 	desc->chip->ack(irq);
-	handle_IRQ_event(irq, desc->action);
-	desc->status &= ~IRQ_INPROGRESS;
+	handle_simple_irq(irq, desc);
 }
 
 static struct irq_chip intc_irq_chip = {


