Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760848Ab0J1R7V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 13:59:21 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50152 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755325Ab0J1R7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 13:59:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=QolMg36yZRt31smHA+6EfWImcu/mQq8Yv3V4dsbu0PUubba68pHBPiZxGsXft9hei1
         gRk2+cJN9TL00U4LiusFuAHnHJXnrrLhOwC6/UmPBVjMhnxCNjCSyax7VZCh0Kf4ljXo
         2LACOS98//ckCMjik2211KaK3t/vB1FHLhwUc=
From: Rabin Vincent <rabin@rab.in>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, Rabin Vincent <rabin@rab.in>
Subject: [PATCH] genirq: handle shared irqs in handle_nested_irq()
Date: Thu, 28 Oct 2010 23:28:38 +0530
Message-Id: <1288288718-1188-1-git-send-email-rabin@rab.in>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow shared irqs to work when nested threads are used for handling
threaded interrupts.

Signed-off-by: Rabin Vincent <rabin@rab.in>
---
 kernel/irq/chip.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index baa5c4a..94a45a9 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -418,8 +418,8 @@ static inline void unmask_irq(struct irq_desc *desc)
 void handle_nested_irq(unsigned int irq)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
+	irqreturn_t action_ret = IRQ_NONE;
 	struct irqaction *action;
-	irqreturn_t action_ret;
 
 	might_sleep();
 
@@ -434,7 +434,10 @@ void handle_nested_irq(unsigned int irq)
 	desc->status |= IRQ_INPROGRESS;
 	raw_spin_unlock_irq(&desc->lock);
 
-	action_ret = action->thread_fn(action->irq, action->dev_id);
+	do {
+		action_ret |= action->thread_fn(action->irq, action->dev_id);
+		action = action->next;
+	} while (action);
 	if (!noirqdebug)
 		note_interrupt(irq, desc, action_ret);
 
-- 
1.7.2.3

