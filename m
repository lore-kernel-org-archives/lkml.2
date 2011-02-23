Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644Ab1BWXw7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 18:52:59 -0500
Received: from www.tglx.de ([62.245.132.106]:56020 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754437Ab1BWXw5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 18:52:57 -0500
Message-Id: <20110223234956.483640430@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 23 Feb 2011 23:52:16 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [patch 2/5] genirq: Allow shared oneshot interrupts
References: <20110223231601.613115832@linutronix.de>
Content-Disposition: inline;
	filename=genirq-allow-shared-oneshot-interrupts.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support ONESHOT on shared interrupts, if all drivers agree on it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/manage.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

Index: linux-2.6-tip/kernel/irq/manage.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/manage.c
+++ linux-2.6-tip/kernel/irq/manage.c
@@ -823,10 +823,6 @@ __setup_irq(unsigned int irq, struct irq
 		rand_initialize_irq(irq);
 	}
 
-	/* Oneshot interrupts are not allowed with shared */
-	if ((new->flags & IRQF_ONESHOT) && (new->flags & IRQF_SHARED))
-		return -EINVAL;
-
 	/*
 	 * Check whether the interrupt nests into another interrupt
 	 * thread.
@@ -880,10 +876,12 @@ __setup_irq(unsigned int irq, struct irq
 		 * Can't share interrupts unless both agree to and are
 		 * the same type (level, edge, polarity). So both flag
 		 * fields must have IRQF_SHARED set and the bits which
-		 * set the trigger type must match.
+		 * set the trigger type must match. Also all must
+		 * agree on ONESHOT.
 		 */
 		if (!((old->flags & new->flags) & IRQF_SHARED) ||
-		    ((old->flags ^ new->flags) & IRQF_TRIGGER_MASK)) {
+		    ((old->flags ^ new->flags) & IRQF_TRIGGER_MASK) ||
+		    ((old->flags ^ new->flags) & IRQF_ONESHOT)) {
 			old_name = old->name;
 			goto mismatch;
 		}


