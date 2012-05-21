Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756784Ab2EUQsP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 12:48:15 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:33253 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751499Ab2EUQsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 12:48:13 -0400
MIME-Version: 1.0
Date: Tue, 22 May 2012 00:48:12 +0800
Message-ID: <CAH3Oq6T-OVj_=kVBdDXxize5v5hovp8FQSDhxCHvF_kcX4QPuA@mail.gmail.com>
Subject: Add IRQS_PENDING for nested and simple irq handler as well
From: Ning Jiang <ning.n.jiang@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From eb72d4c573b482f85b227558deca297d8a8de1df Mon Sep 17 00:00:00 2001
From: Ning Jiang <ning.n.jiang@gmail.com>
Date: Tue, 22 May 2012 00:19:20 +0800
Subject: [PATCH] genirq: Add IRQS_PENDING for nested and simple irq
handler as well

Usually nested and simple irq act as second level in interrupt
distribution tree, in suspend, we need to keep first level irq
functional by irq flag IRQF_NO_SUSPEND and check the 'pending'
state in the second level.

More information can be found in the log of commit:

commit d4dc0f90d243fb54cfbca6601c9a7c5a758e437f
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Wed Apr 25 12:54:54 2012 +0200

    genirq: Allow check_wakeup_irqs to notice level-triggered interrupts

Signed-off-by: Ning Jiang <ning.n.jiang@gmail.com>
---
 kernel/irq/chip.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 741f836..5bec667 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -275,8 +275,10 @@ void handle_nested_irq(unsigned int irq)
 	kstat_incr_irqs_this_cpu(irq, desc);

 	action = desc->action;
-	if (unlikely(!action || irqd_irq_disabled(&desc->irq_data)))
+	if (unlikely(!action || irqd_irq_disabled(&desc->irq_data))) {
+		desc->istate |= IRQS_PENDING;
 		goto out_unlock;
+	}

 	irqd_set(&desc->irq_data, IRQD_IRQ_INPROGRESS);
 	raw_spin_unlock_irq(&desc->lock);
@@ -324,8 +326,10 @@ handle_simple_irq(unsigned int irq, struct irq_desc *desc)
 	desc->istate &= ~(IRQS_REPLAY | IRQS_WAITING);
 	kstat_incr_irqs_this_cpu(irq, desc);

-	if (unlikely(!desc->action || irqd_irq_disabled(&desc->irq_data)))
+	if (unlikely(!desc->action || irqd_irq_disabled(&desc->irq_data))) {
+		desc->istate |= IRQS_PENDING;
 		goto out_unlock;
+	}

 	handle_irq_event(desc);

-- 
1.7.1

Thanks,
Ning
