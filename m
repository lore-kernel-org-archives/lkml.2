Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225Ab2BGNiq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 08:38:46 -0500
Received: from mail.karo-electronics.de ([81.173.242.67]:56739 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755655Ab2BGNip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 08:38:45 -0500
From: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Yong Zhang <yong.zhang0@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] genirq: Fix race condition in ONESHOT irq handler
Date: Tue,  7 Feb 2012 14:38:41 +0100
Message-Id: <1328621921-17404-1-git-send-email-LW@KARO-electronics.de>
X-Mailer: git-send-email 1.7.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
References: <4F31220A.2050708@metafoo.de>
To: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a race condition in the threaded IRQ handler code for oneshot
interrupts that may lead to disabling an IRQ indefinitely. IRQs are
masked before calling the hard-irq handler and are unmasked only after
the soft-irq handler has been run. Thus if the hard-irq handler
returns IRQ_HANDLED instead of IRQ_WAKE_THREAD, meaning the soft-irq
will not be called, the interrupt will remain masked forever.

This can happen due to a short pulse on the interrupt line, that
triggers the interrupt logic, but goes undetected by the hard-irq
handler. The problem can be reproduced with the TSC2007 touch
controller driver that uses ONESHOT interrupts.

The problem arises also with interrupt controllers that latch a level
triggered IRQ until it is acknowledged (like the i.MX28 does).
In this case the IRQ status bit will remain asserted after the
soft-irq finishes and retrigger the interrupt while the interrupt line
is already deasserted.

Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
---
 kernel/irq/chip.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index f7c543a..74fdef9 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -343,6 +343,8 @@ EXPORT_SYMBOL_GPL(handle_simple_irq);
 void
 handle_level_irq(unsigned int irq, struct irq_desc *desc)
 {
+	irqreturn_t ret;
+
 	raw_spin_lock(&desc->lock);
 	mask_ack_irq(desc);
 
@@ -360,10 +362,13 @@ handle_level_irq(unsigned int irq, struct irq_desc *desc)
 	if (unlikely(!desc->action || irqd_irq_disabled(&desc->irq_data)))
 		goto out_unlock;
 
-	handle_irq_event(desc);
+	ret = handle_irq_event(desc);
 
-	if (!irqd_irq_disabled(&desc->irq_data) && !(desc->istate & IRQS_ONESHOT))
+	if (!irqd_irq_disabled(&desc->irq_data) &&
+			(!(desc->istate & IRQS_ONESHOT) ||
+				!(ret & IRQ_WAKE_THREAD)))
 		unmask_irq(desc);
+
 out_unlock:
 	raw_spin_unlock(&desc->lock);
 }
-- 
1.7.2.5

