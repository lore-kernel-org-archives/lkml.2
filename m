Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758030Ab1EaG4Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 02:56:25 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:47681 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751856Ab1EaG4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 02:56:23 -0400
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: [PATCH 3/3] irq: catch more wrong return values from interrupt handlers
Date: Tue, 31 May 2011 08:56:12 +0200
Message-Id: <1306824972-27067-3-git-send-email-sebastian@breakpoint.cc>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1306824972-27067-1-git-send-email-sebastian@breakpoint.cc>
References: <1306824972-27067-1-git-send-email-sebastian@breakpoint.cc>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We now also accept return value IRQ_WAKE_THREAD from a threaded
interrupt or IRQ_HANDLED | IRQ_WAKE_THREAD from primary and theaded
handler which is wrong. We need to accept the later on shared handlers
where one handler is primary only and the second is a threaded handler.
This patch attempts to catch them. Unfortunately this patch introduces
two new types so I'm not sure if it is worth it.

Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
---
 include/linux/irqreturn.h |    4 ++++
 kernel/irq/chip.c         |    5 ++++-
 kernel/irq/handle.c       |    4 ++++
 kernel/irq/manage.c       |    2 ++
 kernel/irq/spurious.c     |    2 +-
 5 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/include/linux/irqreturn.h b/include/linux/irqreturn.h
index 714ba08..2374005 100644
--- a/include/linux/irqreturn.h
+++ b/include/linux/irqreturn.h
@@ -6,11 +6,15 @@
  * @IRQ_NONE		interrupt was not from this device
  * @IRQ_HANDLED		interrupt was handled by this device
  * @IRQ_WAKE_THREAD	handler requests to wake the handler thread
+ * @IRQ_HANDLED_WAKE	interal type, don't use it
+ * @IRQ_WRONG_TYPE	interal type, don't use it
  */
 enum irqreturn {
 	IRQ_NONE		= (0 << 0),
 	IRQ_HANDLED		= (1 << 0),
 	IRQ_WAKE_THREAD		= (1 << 1),
+	IRQ_HANDLED_WAKE	= (IRQ_HANDLED | IRQ_WAKE_THREAD),
+	IRQ_WRONG_RET		= (1 << 2),
 };
 
 typedef enum irqreturn irqreturn_t;
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index d5a3009..c4494b3 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -260,8 +260,11 @@ void handle_nested_irq(unsigned int irq)
 	raw_spin_unlock_irq(&desc->lock);
 
 	action_ret = action->thread_fn(action->irq, action->dev_id);
-	if (!noirqdebug)
+	if (!noirqdebug) {
+		if (action_ret > IRQ_HANDLED)
+			action_ret |= IRQ_WRONG_RET;
 		note_interrupt(irq, desc, action_ret);
+	}
 
 	raw_spin_lock_irq(&desc->lock);
 	irqd_clear(&desc->irq_data, IRQD_IRQ_INPROGRESS);
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 470d08c..15b070b 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -148,6 +148,10 @@ handle_irq_event_percpu(struct irq_desc *desc, struct irqaction *action)
 			random |= action->flags;
 			break;
 
+		case IRQ_HANDLED_WAKE:
+			res = IRQ_WRONG_RET;
+			break;
+
 		default:
 			break;
 		}
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index f4d5329..0a50547 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -796,6 +796,8 @@ static int irq_thread(void *data)
 			raw_spin_unlock_irq(&desc->lock);
 			action_ret = handler_fn(desc, action);
 			if (!noirqdebug) {
+				if (action_ret > IRQ_HANDLED)
+					action_ret |= IRQ_WRONG_RET;
 				raw_spin_lock_irq(&desc->lock);
 				note_interrupt(action->irq, desc, action_ret);
 				raw_spin_unlock_irq(&desc->lock);
diff --git a/kernel/irq/spurious.c b/kernel/irq/spurious.c
index 0992587..2da50e6 100644
--- a/kernel/irq/spurious.c
+++ b/kernel/irq/spurious.c
@@ -169,7 +169,7 @@ out:
 
 static int bad_action_ret(irqreturn_t action_ret)
 {
-	if (likely(action_ret <= (IRQ_HANDLED | IRQ_WAKE_THREAD)))
+	if (likely(action_ret <= IRQ_HANDLED_WAKE))
 		return 0;
 	return 1;
 }
-- 
1.7.4.4

