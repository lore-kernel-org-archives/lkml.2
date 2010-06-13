Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315Ab0FMPee (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 11:34:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:37718 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753992Ab0FMPcK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 11:32:10 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, tglx@linutronix.de, bphilips@suse.de, yinghai@kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, jeff@garzik.org,
       linux-ide@vger.kernel.org, stern@rowland.harvard.edu, gregkh@suse.de,
       khali@linux-fr.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 06/12] irq: implement irq_schedule_poll()
Date: Sun, 13 Jun 2010 17:31:32 +0200
Message-Id: <1276443098-20653-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1276443098-20653-1-git-send-email-tj@kernel.org>
References: <1276443098-20653-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 13 Jun 2010 15:31:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement and use irq_schedule_poll() to schedule desc->poll_timer
instead of calling mod_timer directly.  irq_schedule_poll() is called
with desc->lock held and schedules the timer iff necessary - ie. if
the timer is offline or scheduled to expire later than requested.
This will be used to share desc->poll_timer.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/irq/spurious.c |   47 +++++++++++++++++++++++++++++++++++++++++------
 1 files changed, 41 insertions(+), 6 deletions(-)

diff --git a/kernel/irq/spurious.c b/kernel/irq/spurious.c
index 0bce0e3..0b8fd0a 100644
--- a/kernel/irq/spurious.c
+++ b/kernel/irq/spurious.c
@@ -23,6 +23,8 @@ enum {
 
 	/* IRQ polling common parameters */
 	IRQ_POLL_INTV			= HZ / 100,	/* from the good ol' 100HZ tick */
+
+	IRQ_POLL_SLACK			= HZ / 1000,	/* 10% slack */
 };
 
 int noirqdebug __read_mostly;
@@ -43,6 +45,38 @@ static void print_irq_handlers(struct irq_desc *desc)
 	}
 }
 
+static unsigned long irq_poll_slack(unsigned long intv)
+{
+	return IRQ_POLL_SLACK;
+}
+
+/**
+ * irq_schedule_poll - schedule IRQ poll
+ * @desc: IRQ desc to schedule poll for
+ * @intv: poll interval
+ *
+ * Schedules @desc->poll_timer.  If the timer is already scheduled,
+ * it's modified iff jiffies + @intv + slack is before the timer's
+ * expires.  poll_timers aren't taken offline behind this function's
+ * back and the users of this function are guaranteed that poll_irq()
+ * will be called at or before jiffies + @intv + slack.
+ *
+ * CONTEXT:
+ * desc->lock
+ */
+static void irq_schedule_poll(struct irq_desc *desc, unsigned long intv)
+{
+	unsigned long expires = jiffies + intv;
+	int slack = irq_poll_slack(intv);
+
+	if (timer_pending(&desc->poll_timer) &&
+	    time_before_eq(desc->poll_timer.expires, expires + slack))
+		return;
+
+	set_timer_slack(&desc->poll_timer, slack);
+	mod_timer(&desc->poll_timer, expires);
+}
+
 /*
  * Recovery handler for misrouted interrupts.
  */
@@ -207,7 +241,9 @@ void __note_interrupt(unsigned int irq, struct irq_desc *desc,
 		desc->depth++;
 		desc->chip->disable(irq);
 
-		mod_timer(&desc->poll_timer, jiffies + IRQ_POLL_INTV);
+		raw_spin_lock(&desc->lock);
+		irq_schedule_poll(desc, IRQ_POLL_INTV);
+		raw_spin_unlock(&desc->lock);
 	}
 	desc->irqs_unhandled = 0;
 }
@@ -221,9 +257,8 @@ void poll_irq(unsigned long arg)
 
 	raw_spin_lock_irq(&desc->lock);
 	try_one_irq(desc->irq, desc);
+	irq_schedule_poll(desc, IRQ_POLL_INTV);
 	raw_spin_unlock_irq(&desc->lock);
-
-	mod_timer(&desc->poll_timer, jiffies + IRQ_POLL_INTV);
 }
 
 void irq_poll_action_added(struct irq_desc *desc, struct irqaction *action)
@@ -238,10 +273,10 @@ void irq_poll_action_added(struct irq_desc *desc, struct irqaction *action)
 		__enable_irq(desc, desc->irq, false);
 	}
 
-	raw_spin_unlock_irqrestore(&desc->lock, flags);
-
 	if ((action->flags & IRQF_SHARED) && irqfixup >= IRQFIXUP_POLL)
-		mod_timer(&desc->poll_timer, jiffies + IRQ_POLL_INTV);
+		irq_schedule_poll(desc, IRQ_POLL_INTV);
+
+	raw_spin_unlock_irqrestore(&desc->lock, flags);
 }
 
 void irq_poll_action_removed(struct irq_desc *desc, struct irqaction *action)
-- 
1.6.4.2

