Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552Ab0FMPef (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 11:34:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:37722 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754039Ab0FMPcK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 11:32:10 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, tglx@linutronix.de, bphilips@suse.de, yinghai@kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, jeff@garzik.org,
       linux-ide@vger.kernel.org, stern@rowland.harvard.edu, gregkh@suse.de,
       khali@linux-fr.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 03/12] irq: use desc->poll_timer for irqpoll
Date: Sun, 13 Jun 2010 17:31:29 +0200
Message-Id: <1276443098-20653-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1276443098-20653-1-git-send-email-tj@kernel.org>
References: <1276443098-20653-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 13 Jun 2010 15:31:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to tickless and missing IRQF_IRQPOLL flags, irqpoll has been
broken in many configurations for quite some time.  Make irqpoll
global polling use desc->poll_timer instead.  It's simpler and more
reliable.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/irq/spurious.c |   41 +++++------------------------------------
 1 files changed, 5 insertions(+), 36 deletions(-)

diff --git a/kernel/irq/spurious.c b/kernel/irq/spurious.c
index 545f730..fc18a13 100644
--- a/kernel/irq/spurious.c
+++ b/kernel/irq/spurious.c
@@ -159,41 +159,6 @@ report_bad_irq(unsigned int irq, struct irq_desc *desc, irqreturn_t action_ret)
 	}
 }
 
-static inline int
-try_misrouted_irq(unsigned int irq, struct irq_desc *desc,
-		  irqreturn_t action_ret)
-{
-	struct irqaction *action;
-
-	if (irqfixup < IRQFIXUP_MISROUTED)
-		return 0;
-
-	/* We didn't actually handle the IRQ - see if it was misrouted? */
-	if (action_ret == IRQ_NONE)
-		return 1;
-
-	/*
-	 * But for IRQFIXUP_POLL we also do it for handled interrupts
-	 * if they are marked as IRQF_IRQPOLL (or for irq zero, which
-	 * is the traditional PC timer interrupt.. Legacy)
-	 */
-	if (irqfixup < IRQFIXUP_POLL)
-		return 0;
-
-	if (!irq)
-		return 1;
-
-	/*
-	 * Since we don't get the descriptor lock, "action" can
-	 * change under us.  We don't really care, but we don't
-	 * want to follow a NULL pointer. So tell the compiler to
-	 * just load it once by using a barrier.
-	 */
-	action = desc->action;
-	barrier();
-	return action && (action->flags & IRQF_IRQPOLL);
-}
-
 void __note_interrupt(unsigned int irq, struct irq_desc *desc,
 		      irqreturn_t action_ret)
 {
@@ -213,7 +178,8 @@ void __note_interrupt(unsigned int irq, struct irq_desc *desc,
 			report_bad_irq(irq, desc, action_ret);
 	}
 
-	if (unlikely(try_misrouted_irq(irq, desc, action_ret))) {
+	if (unlikely(irqfixup >= IRQFIXUP_MISROUTED &&
+		     action_ret == IRQ_NONE)) {
 		int ok = misrouted_irq(irq);
 		if (action_ret == IRQ_NONE)
 			desc->irqs_unhandled -= ok;
@@ -269,6 +235,9 @@ void irq_poll_action_added(struct irq_desc *desc, struct irqaction *action)
 	}
 
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
+
+	if ((action->flags & IRQF_SHARED) && irqfixup >= IRQFIXUP_POLL)
+		mod_timer(&desc->poll_timer, jiffies + IRQ_POLL_INTV);
 }
 
 void irq_poll_action_removed(struct irq_desc *desc, struct irqaction *action)
-- 
1.6.4.2

