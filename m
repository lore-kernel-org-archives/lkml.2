Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234Ab0FMPcR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 11:32:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:37723 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754073Ab0FMPcK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 11:32:10 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, tglx@linutronix.de, bphilips@suse.de, yinghai@kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, jeff@garzik.org,
       linux-ide@vger.kernel.org, stern@rowland.harvard.edu, gregkh@suse.de,
       khali@linux-fr.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 05/12] irq: misc preparations for further changes
Date: Sun, 13 Jun 2010 17:31:31 +0200
Message-Id: <1276443098-20653-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1276443098-20653-1-git-send-email-tj@kernel.org>
References: <1276443098-20653-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 13 Jun 2010 15:31:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* properly indent irqaction fields.

* factor out print_irq_handler()

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/interrupt.h |   20 ++++++++++----------
 kernel/irq/spurious.c     |   28 ++++++++++++++++------------
 2 files changed, 26 insertions(+), 22 deletions(-)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 61857f1..b20bd65 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -102,16 +102,16 @@ typedef irqreturn_t (*irq_handler_t)(int, void *);
  * @thread_flags:	flags related to @thread
  */
 struct irqaction {
-	irq_handler_t handler;
-	unsigned long flags;
-	const char *name;
-	void *dev_id;
-	struct irqaction *next;
-	int irq;
-	struct proc_dir_entry *dir;
-	irq_handler_t thread_fn;
-	struct task_struct *thread;
-	unsigned long thread_flags;
+	irq_handler_t		handler;
+	unsigned long		flags;
+	const char		*name;
+	void			*dev_id;
+	struct irqaction	*next;
+	int			irq;
+	struct proc_dir_entry	*dir;
+	irq_handler_t		thread_fn;
+	struct task_struct	*thread;
+	unsigned long		thread_flags;
 };
 
 extern irqreturn_t no_action(int cpl, void *dev_id);
diff --git a/kernel/irq/spurious.c b/kernel/irq/spurious.c
index fc18a13..0bce0e3 100644
--- a/kernel/irq/spurious.c
+++ b/kernel/irq/spurious.c
@@ -28,6 +28,21 @@ enum {
 int noirqdebug __read_mostly;
 static int irqfixup __read_mostly = IRQFIXUP_SPURIOUS;
 
+static void print_irq_handlers(struct irq_desc *desc)
+{
+	struct irqaction *action;
+
+	printk(KERN_ERR "handlers:\n");
+
+	action = desc->action;
+	while (action) {
+		printk(KERN_ERR "[<%p>]", action->handler);
+		print_symbol(" (%s)", (unsigned long)action->handler);
+		printk("\n");
+		action = action->next;
+	}
+}
+
 /*
  * Recovery handler for misrouted interrupts.
  */
@@ -126,8 +141,6 @@ static void
 __report_bad_irq(unsigned int irq, struct irq_desc *desc,
 		 irqreturn_t action_ret)
 {
-	struct irqaction *action;
-
 	if (action_ret != IRQ_HANDLED && action_ret != IRQ_NONE) {
 		printk(KERN_ERR "irq event %d: bogus return value %x\n",
 				irq, action_ret);
@@ -136,16 +149,7 @@ __report_bad_irq(unsigned int irq, struct irq_desc *desc,
 				"the \"irqpoll\" option)\n", irq);
 	}
 	dump_stack();
-	printk(KERN_ERR "handlers:\n");
-
-	action = desc->action;
-	while (action) {
-		printk(KERN_ERR "[<%p>]", action->handler);
-		print_symbol(" (%s)",
-			(unsigned long)action->handler);
-		printk("\n");
-		action = action->next;
-	}
+	print_irq_handlers(desc);
 }
 
 static void
-- 
1.6.4.2

