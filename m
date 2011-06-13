Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783Ab1FMAre (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 20:47:34 -0400
Received: from smtp-out.google.com ([216.239.44.51]:27604 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754262Ab1FMArd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 20:47:33 -0400
From: Colin Cross <ccross@android.com>
To: linux-kernel@vger.kernel.org
Cc: Colin Cross <ccross@android.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] irq: Always clear pending flag in check_irq_resend
Date: Sun, 12 Jun 2011 17:47:20 -0700
Message-Id: <1307926040-29020-1-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.4.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If an interrupt occurs while the irq is masked, the irq is marked
as pending.  For a level triggered interrupt, the pending flag
is only cleared when the interrupt is handled.  If the interrupt
is never handled because the irq is deasserted before being
enabled it will stay pending, and suspend may be blocked by
check_wakeup_irqs.

Change check_irq_resend to always clear the pending flag,
including for level interrupts.

Signed-off-by: Colin Cross <ccross@android.com>
---
 kernel/irq/resend.c |   19 ++++++++++---------
 1 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/kernel/irq/resend.c b/kernel/irq/resend.c
index 14dd576..ef60772 100644
--- a/kernel/irq/resend.c
+++ b/kernel/irq/resend.c
@@ -55,17 +55,18 @@ static DECLARE_TASKLET(resend_tasklet, resend_irqs, 0);
  */
 void check_irq_resend(struct irq_desc *desc, unsigned int irq)
 {
-	/*
-	 * We do not resend level type interrupts. Level type
-	 * interrupts are resent by hardware when they are still
-	 * active.
-	 */
-	if (irq_settings_is_level(desc))
-		return;
-	if (desc->istate & IRQS_REPLAY)
-		return;
 	if (desc->istate & IRQS_PENDING) {
 		desc->istate &= ~IRQS_PENDING;
+		/*
+		 * We do not resend level type interrupts. Level type
+		 * interrupts are resent by hardware when they are still
+		 * active.
+		 */
+		if (irq_settings_is_level(desc))
+			return;
+		if (desc->istate & IRQS_REPLAY)
+			return;
+
 		desc->istate |= IRQS_REPLAY;
 
 		if (!desc->irq_data.chip->irq_retrigger ||
-- 
1.7.4.1

