Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005Ab2FNGzN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 02:55:13 -0400
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:48644 "HELO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751191Ab2FNGzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 02:55:11 -0400
From: Ning Jiang <ning.n.jiang@gmail.com>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, Ning Jiang <ning.n.jiang@gmail.com>
Subject: [PATCH] genirq: Increment irq count for second edge irq when the first is in progress
Date: Thu, 14 Jun 2012 14:52:04 +0800
Message-Id: <1339656724-28222-1-git-send-email-ning.n.jiang@gmail.com>
X-Mailer: git-send-email 1.7.1
X-OriginalArrivalTime: 14 Jun 2012 06:47:30.0956 (UTC) FILETIME=[920C0CC0:01CD49F9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kstat_incr_irqs_this_cpu() records the real number of interruptions
to a certain CPU, regardless of the current irq state. That includes
interrupts which are delivered in a state where the device handler
cannot be called.

For level irq, if its disabled or no action available, we'll skip
irq handling. When it is enabled later, the irq will be retriggered
and kstat_incr_irqs_this_cpu() will be incremented again. This counts
the number of interrupts arrived at the CPU and therefor it counts
TWO in this situation. The CPU is interrupted twice, not once. The
accounting works correctly as expected.

But for edge irq, we have a subtle problem. Suppose a second irq
happens when the first is still in progress, it will mark itself
pending and quit, then it will be handled in the same loop after
the first one has been handled. Thus kstat_incr_irqs_this_cpu()
will only be counted once for two irqs.

Add a check in edge handler if there is a irq already in progress,
we'll first kstat_incr_irqs_this_cpu() before we mask and quit, so
that we can get correct irq count in this case.

[ Thanks Thomas for his excellent comments ]

Signed-off-by: Ning Jiang <ning.n.jiang@gmail.com>
---
 kernel/irq/chip.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index eebd6d5..254b8aa 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -489,6 +489,8 @@ handle_edge_irq(unsigned int irq, struct irq_desc *desc)
 	if (unlikely(irqd_irq_disabled(&desc->irq_data) ||
 		     irqd_irq_inprogress(&desc->irq_data) || !desc->action)) {
 		if (!irq_check_poll(desc)) {
+			if (irqd_irq_inprogress(&desc->irq_data))
+				kstat_incr_irqs_this_cpu(irq, desc);
 			desc->istate |= IRQS_PENDING;
 			mask_ack_irq(desc);
 			goto out_unlock;
@@ -550,6 +552,8 @@ void handle_edge_eoi_irq(unsigned int irq, struct irq_desc *desc)
 	if (unlikely(irqd_irq_disabled(&desc->irq_data) ||
 		     irqd_irq_inprogress(&desc->irq_data) || !desc->action)) {
 		if (!irq_check_poll(desc)) {
+			if (irqd_irq_inprogress(&desc->irq_data))
+				kstat_incr_irqs_this_cpu(irq, desc);
 			desc->istate |= IRQS_PENDING;
 			goto out_eoi;
 		}
-- 
1.7.1

