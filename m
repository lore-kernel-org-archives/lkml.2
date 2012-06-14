Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831Ab2FNIcN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 04:32:13 -0400
Received: from na3sys009aog134.obsmtp.com ([74.125.149.83]:55861 "HELO
	na3sys009aog134.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754239Ab2FNIcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 04:32:11 -0400
From: Ning Jiang <ning.n.jiang@gmail.com>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, Ning Jiang <ning.n.jiang@gmail.com>
Subject: [PATCH 2/2] genirq: Resend nested irq's ancestor irq
Date: Thu, 14 Jun 2012 16:31:37 +0800
Message-Id: <1339662697-4600-2-git-send-email-ning.n.jiang@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1339662697-4600-1-git-send-email-ning.n.jiang@gmail.com>
References: <1339662697-4600-1-git-send-email-ning.n.jiang@gmail.com>
X-OriginalArrivalTime: 14 Jun 2012 08:27:34.0535 (UTC) FILETIME=[8C758170:01CD4A07]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We'll set IRQS_PENDING for handle_nested_irq if it's disabled. When
it's re-enabled later on, check_irq_resend() will detect this flag
and trigger the software resend mechanism. resend_irqs() will call
desc->handle_irq() directly to process this interrupt, hence the
irq_nested_primary_handler() will be called for the nested irq which
gives us a warning.

If we need to resend a nested interrupt, we have to trace all the
way back to its ancestor and trigger ancestor's irq flow handler.

Signed-off-by: Ning Jiang <ning.n.jiang@gmail.com>
---
 kernel/irq/resend.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/kernel/irq/resend.c b/kernel/irq/resend.c
index 6454db7..dcfc1b5 100644
--- a/kernel/irq/resend.c
+++ b/kernel/irq/resend.c
@@ -74,6 +74,11 @@ void check_irq_resend(struct irq_desc *desc, unsigned int irq)
 		if (!desc->irq_data.chip->irq_retrigger ||
 		    !desc->irq_data.chip->irq_retrigger(&desc->irq_data)) {
 #ifdef CONFIG_HARDIRQS_SW_RESEND
+			while (irq_settings_is_nested_thread(desc) &&
+				(desc->irq_data.parent_irq != NO_IRQ)) {
+				irq = desc->irq_data.parent_irq;
+				desc = irq_to_desc(irq);
+			}
 			/* Set it pending and activate the softirq: */
 			set_bit(irq, irqs_resend);
 			tasklet_schedule(&resend_tasklet);
-- 
1.7.1

