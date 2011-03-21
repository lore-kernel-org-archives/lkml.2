Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090Ab1CUL77 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 07:59:59 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:44302 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752932Ab1CUL7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 07:59:54 -0400
X-Authenticated: #911537
X-Provags-ID: V01U2FsdGVkX1/Waa1JI/jW6YWK01VgbppdVBJZj8RRzi/eAtgrjc
	qGQDg4MvSdN3v3
From: Torben Hohn <torbenh@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, linuxpps@ml.enneenne.com,
        Torben Hohn <torbenh@gmx.de>
Subject: [PATCH 3/5] RFC genirq: save irq timestamps in void *dev_id
Date: Mon, 21 Mar 2011 12:59:18 +0100
Message-Id: <1300708760-27910-3-git-send-email-torbenh@gmx.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1300708760-27910-1-git-send-email-torbenh@gmx.de>
References: <1300708760-27910-1-git-send-email-torbenh@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To make the timestamps accessible to the irq handler,
we mandate that IRQF_TIMESTAMP irqs have their dev_id
point to a struct timespec, where the timestamp is stored.

Genirq will fill in the timestamp before calling the irq handler.

Signed-off-by: Torben Hohn <torbenh@gmx.de>
---
 kernel/irq/handle.c |    6 ++++++
 kernel/irq/manage.c |    9 +++++++++
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 3540a71..4edcd03 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -64,6 +64,12 @@ irqreturn_t handle_IRQ_event(unsigned int irq, struct irqaction *action)
 	unsigned int status = 0;
 
 	do {
+		if (action->flags & IRQF_TIMESTAMP) {
+			struct timespec *ts = action->dev_id;
+			struct irq_desc *desc = irq_to_desc(irq);
+			*ts = desc->last_timestamp;
+		}
+
 		trace_irq_handler_entry(irq, action);
 		ret = action->handler(irq, action->dev_id);
 		trace_irq_handler_exit(irq, action, ret);
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index adbf6c9..b60350f 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -972,6 +972,8 @@ static struct irqaction *__free_irq(unsigned int irq, void *dev_id)
 	 *   'real' IRQ doesn't run in * parallel with our fake. )
 	 */
 	if (action->flags & IRQF_SHARED) {
+		if (action->flags & IRQF_TIMESTAMP)
+			getrawmonotonic((struct timespec *)dev_id);
 		local_irq_save(flags);
 		action->handler(irq, dev_id);
 		local_irq_restore(flags);
@@ -1068,6 +1070,10 @@ EXPORT_SYMBOL(free_irq);
  *	IRQF_SHARED		Interrupt is shared
  *	IRQF_SAMPLE_RANDOM	The interrupt can be used for entropy
  *	IRQF_TRIGGER_*		Specify active edge(s) or level
+ *	IRQF_TIMESTAMP		Interrupt gets timestamped. (in this
+ *				case dev_id MUST point to a 
+ *				struct timespec which will be filled
+ *				with the timestamp)
  *
  */
 int request_threaded_irq(unsigned int irq, irq_handler_t handler,
@@ -1127,6 +1133,9 @@ int request_threaded_irq(unsigned int irq, irq_handler_t handler,
 		 */
 		unsigned long flags;
 
+		if (irqflags & IRQF_TIMESTAMP)
+			getrawmonotonic((struct timespec *)dev_id);
+
 		disable_irq(irq);
 		local_irq_save(flags);
 
-- 
1.7.2.3

