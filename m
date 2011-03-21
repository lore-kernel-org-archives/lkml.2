Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794Ab1CUL7w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 07:59:52 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:60262 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751783Ab1CUL7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 07:59:51 -0400
X-Authenticated: #911537
X-Provags-ID: V01U2FsdGVkX1/Waa1JI/jW6YWK01VgbppdVBJZj8RRzi/eAtgrjc
	qGQDg4MvSdN3v3
From: Torben Hohn <torbenh@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, linuxpps@ml.enneenne.com,
        Torben Hohn <torbenh@gmx.de>
Subject: [PATCH 5/5] RFC genirq: enforce dev_id to be struct timespec * with IRQF_TIMESTAMP
Date: Mon, 21 Mar 2011 12:59:20 +0100
Message-Id: <1300708760-27910-5-git-send-email-torbenh@gmx.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1300708760-27910-1-git-send-email-torbenh@gmx.de>
References: <1300708760-27910-1-git-send-email-torbenh@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

we can enforce the dev_id to be a struct timespec * in
irq_turn_on_timestamping() and irq_turn_off_timestamping()

Signed-off-by: Torben Hohn <torbenh@gmx.de>
---
 include/linux/interrupt.h |    4 ++--
 kernel/irq/manage.c       |    8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index cc9ed9c..759fead 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -175,8 +175,8 @@ request_any_context_irq(unsigned int irq, irq_handler_t handler,
 static inline void exit_irq_thread(void) { }
 #endif
 
-extern void irq_turn_on_timestamping(unsigned int irq, void *dev_id);
-extern void irq_turn_off_timestamping(unsigned int irq, void *dev_id);
+extern void irq_turn_on_timestamping(unsigned int irq, struct timespec *dev_id);
+extern void irq_turn_off_timestamping(unsigned int irq, struct timespec *dev_id);
 
 extern void free_irq(unsigned int, void *);
 
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 66e9501..3ac9acc 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -656,7 +656,7 @@ void exit_irq_thread(void)
  *
  *	Turning on timestamping nests.
  */
-void irq_turn_on_timestamping(unsigned int irq, void *dev_id)
+void irq_turn_on_timestamping(unsigned int irq, struct timespec *dev_id)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 	unsigned long flags;
@@ -667,7 +667,7 @@ void irq_turn_on_timestamping(unsigned int irq, void *dev_id)
 
 	act = desc->action;
 	while (act) {
-		if (act->dev_id == dev_id) {
+		if (act->dev_id == (void *)dev_id) {
 			act->flags |= IRQF_TIMESTAMP;
 			break;
 		}
@@ -689,7 +689,7 @@ EXPORT_SYMBOL_GPL(irq_turn_on_timestamping);
  *
  *	Turning on timestamping nests.
  */
-void irq_turn_off_timestamping(unsigned int irq, void *dev_id)
+void irq_turn_off_timestamping(unsigned int irq, struct timespec *dev_id)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 	unsigned long flags;
@@ -700,7 +700,7 @@ void irq_turn_off_timestamping(unsigned int irq, void *dev_id)
 
 	act = desc->action;
 	while (act) {
-		if (act->dev_id == dev_id) {
+		if (act->dev_id == (void *)dev_id) {
 			act->flags &= ~(IRQF_TIMESTAMP);
 		}
 		irqf_accu |= act->flags;
-- 
1.7.2.3

