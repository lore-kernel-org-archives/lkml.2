Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757386Ab1BJXgX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:36:23 -0500
Received: from www.tglx.de ([62.245.132.106]:43917 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757360Ab1BJXgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:36:16 -0500
Message-Id: <20110210223254.999164371@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 10 Feb 2011 23:36:06 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 07/75] genirq: Warn when handler enables interrupts
References: <20110210222908.661199947@linutronix.de>
Content-Disposition: inline;
	filename=genirq-warn-when-handler-enables-irqs.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We run all handlers with interrupts disabled and expect them not to
enable them. Warn when we catch one who does.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/handle.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6-tip/kernel/irq/handle.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/handle.c
+++ linux-2.6-tip/kernel/irq/handle.c
@@ -68,6 +68,9 @@ irqreturn_t handle_IRQ_event(unsigned in
 		ret = action->handler(irq, action->dev_id);
 		trace_irq_handler_exit(irq, action, ret);
 
+		if (WARN_ON_ONCE(!irqs_disabled()))
+			local_irq_disable();
+
 		switch (ret) {
 		case IRQ_WAKE_THREAD:
 			/*
@@ -114,7 +117,6 @@ irqreturn_t handle_IRQ_event(unsigned in
 
 	if (status & IRQF_SAMPLE_RANDOM)
 		add_interrupt_randomness(irq);
-	local_irq_disable();
 
 	return retval;
 }


