Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791Ab0LLLXB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 06:23:01 -0500
Received: from fmmailgate02.web.de ([217.72.192.227]:56519 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590Ab0LLLWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 06:22:50 -0500
From: Jan Kiszka <jan.kiszka@web.de>
To: Thomas Gleixner <tglx@linutronix.de>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        Tom Lyon <pugs@cisco.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
Subject: [PATCH v2 3/4] genirq: Add support for IRQF_COND_ONESHOT
Date: Sun, 12 Dec 2010 12:22:43 +0100
Message-Id: <fc410612323e7dcefd3095a580adfbd1ced9b6f5.1292152963.git.jan.kiszka@web.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <cover.1292152963.git.jan.kiszka@web.de>
References: <cover.1292152963.git.jan.kiszka@web.de>
In-Reply-To: <cover.1292152963.git.jan.kiszka@web.de>
References: <cover.1292152963.git.jan.kiszka@web.de>
X-Provags-ID: V01U2FsdGVkX19XloU1n/VfyhY+jDwLud9TbM/L/5FZqTzIg5vV
	UcjJ3sseNY258lC7LjLRrLuxtV1vuag6fY0zBbxKrX4SkHq+Q8
	cfOMC3Chg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

Provide an adaptive version of IRQF_ONESHOT: If the line is exclusively used,
IRQF_COND_ONESHOT provides the same semantics as IRQF_ONESHOT. If it is
shared, the line will be unmasked directly after the hardirq handler, just as
if IRQF_COND_ONESHOT was not provided.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 include/linux/interrupt.h |    3 +++
 kernel/irq/manage.c       |   19 ++++++++++++++++---
 2 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index c6323a2..f462807 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -56,6 +56,8 @@
  *                irq line disabled until the threaded handler has been run.
  * IRQF_NO_SUSPEND - Do not disable this IRQ during suspend
  * IRQF_ADAPTIVE - Request notification about upcoming interrupt line sharing
+ * IRQF_COND_ONESHOT - If line is not shared, keep interrupt disabled after
+ *                     hardirq handler finshed.
  *
  */
 #define IRQF_DISABLED		0x00000020
@@ -69,6 +71,7 @@
 #define IRQF_ONESHOT		0x00002000
 #define IRQF_NO_SUSPEND		0x00004000
 #define IRQF_ADAPTIVE		0x00008000
+#define IRQF_COND_ONESHOT	0x00010000
 
 #define IRQF_TIMER		(__IRQF_TIMER | IRQF_NO_SUSPEND)
 
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index a4557eb..948b7c9 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -580,7 +580,7 @@ static int irq_thread(void *data)
 	struct sched_param param = { .sched_priority = MAX_USER_RT_PRIO/2, };
 	struct irqaction *action = data;
 	struct irq_desc *desc = irq_to_desc(action->irq);
-	int wake, oneshot = desc->status & IRQ_ONESHOT;
+	int wake, oneshot;
 
 	sched_setscheduler(current, SCHED_FIFO, &param);
 	current->irqaction = action;
@@ -603,6 +603,7 @@ static int irq_thread(void *data)
 			desc->status |= IRQ_PENDING;
 			raw_spin_unlock_irq(&desc->lock);
 		} else {
+			oneshot = desc->status & IRQ_ONESHOT;
 			raw_spin_unlock_irq(&desc->lock);
 
 			action->thread_fn(action->irq, action->dev_id);
@@ -756,6 +757,15 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 		shared = 1;
 
 		desc->irq_data.status |= IRQS_SHARED;
+		desc->status &= ~IRQ_ONESHOT;
+
+		/* Unmask if the interrupt was masked due to oneshot mode. */
+		if ((desc->status &
+		     (IRQ_INPROGRESS | IRQ_DISABLED | IRQ_MASKED)) ==
+		    IRQ_MASKED) {
+			desc->irq_data.chip->irq_unmask(&desc->irq_data);
+			desc->status &= ~IRQ_MASKED;
+		}
 	}
 
 	if (!shared) {
@@ -780,7 +790,7 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 		desc->status &= ~(IRQ_AUTODETECT | IRQ_WAITING | IRQ_ONESHOT |
 				  IRQ_INPROGRESS | IRQ_SPURIOUS_DISABLED);
 
-		if (new->flags & IRQF_ONESHOT)
+		if (new->flags & (IRQF_ONESHOT | IRQF_COND_ONESHOT))
 			desc->status |= IRQ_ONESHOT;
 
 		if (!(desc->status & IRQ_NOAUTOEN)) {
@@ -931,8 +941,11 @@ static struct irqaction *__free_irq(unsigned int irq, void *dev_id)
 			desc->irq_data.chip->irq_shutdown(&desc->irq_data);
 		else
 			desc->irq_data.chip->irq_disable(&desc->irq_data);
-	} else if (!desc->action->next)
+	} else if (!desc->action->next) {
 		single_handler = true;
+		if (desc->action->flags & IRQF_COND_ONESHOT)
+			desc->status |= IRQ_ONESHOT;
+	}
 
 #ifdef CONFIG_SMP
 	/* make sure affinity_hint is cleaned up */
-- 
1.7.1

