Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757258Ab0J0Bud (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 21:50:33 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:58224 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812Ab0J0Buc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 21:50:32 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6148"; a="59448544"
From: adharmap@codeaurora.org
To: tglx@linutronix.de
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, linux-arm-msm-owner@vger.kernel.org,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>
Subject: [RFC IRQ] genirq: fix handle_nested_irq for lazy disable
Date: Tue, 26 Oct 2010 18:50:09 -0700
Message-Id: <1288144209-28086-1-git-send-email-adharmap@codeaurora.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Abhijeet Dharmapurikar <adharmap@codeaurora.org>

When lazy disabling is implemented and an interrupt is disabled the
genirq code ends up marking it as IRQ_DISABLED in the descriptor.
The interrupt stays enabled in the controller.  If the interrupt
fires after disabling, the flow handlers namely handle_level_irq and
handle_edge_irq mask the interrupt in the controller.

This is not the case with handle_nested_irq. The interrupt stays enabled in
the controller and if it were a level interrupt it keeps firing only to be
ignored by handle_nested_irq.

Update handle_nested_irq to mask such an interrupt.

Change-Id: Id0fa3280c49a36aa8b8db1d5cc20472bf5e53c5f
Signed-off-by: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
---
 This problem shows up on my hardware because the interrupt controller is
 over a slow bus and it doesnt deactivate the interrupt line to the processor
 until an ack or mask operation is carried out for each of its active
 interrupts.

 I could have updated the interrupt controller thread itself to check if the
 interrupt is marked IRQ_DISABLED but didn't seem right to take the
 desc->lock in there. Instead updating handle_nested_irq to handle this
 seemed like the right thing to do.

 kernel/irq/chip.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index baa5c4a..35ccc41 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -419,6 +419,7 @@ void handle_nested_irq(unsigned int irq)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 	struct irqaction *action;
+	int mask_this_irq = 0;
 	irqreturn_t action_ret;
 
 	might_sleep();
@@ -428,8 +429,10 @@ void handle_nested_irq(unsigned int irq)
 	kstat_incr_irqs_this_cpu(irq, desc);
 
 	action = desc->action;
-	if (unlikely(!action || (desc->status & IRQ_DISABLED)))
+	if (unlikely(!action || (desc->status & IRQ_DISABLED))) {
+		mask_this_irq = 1;
 		goto out_unlock;
+	}
 
 	desc->status |= IRQ_INPROGRESS;
 	raw_spin_unlock_irq(&desc->lock);
@@ -443,6 +446,11 @@ void handle_nested_irq(unsigned int irq)
 
 out_unlock:
 	raw_spin_unlock_irq(&desc->lock);
+	if (unlikely(mask_this_irq)) {
+		chip_bus_lock(irq, desc);
+		desc->chip->mask(irq);
+		chip_bus_sync_unlock(irq, desc);
+	}
 }
 EXPORT_SYMBOL_GPL(handle_nested_irq);
 
-- 
1.7.1
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

