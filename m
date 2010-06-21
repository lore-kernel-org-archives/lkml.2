Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932460Ab0FUN1O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 09:27:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:37026 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932424Ab0FUN1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 09:27:10 -0400
Message-ID: <4C1F687A.5030907@kernel.org>
Date: Mon, 21 Jun 2010 15:26:18 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
CC: mingo@elte.hu, tglx@linutronix.de, bphilips@suse.de, yinghai@kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, jeff@garzik.org
Subject: Re: [PATCH 06/12 UPDATED] irq: implement irq_schedule_poll()
References: <1276443098-20653-1-git-send-email-tj@kernel.org>	<1276443098-20653-7-git-send-email-tj@kernel.org> <20100615114058.32e58afd@bike.lwn.net>
In-Reply-To: <20100615114058.32e58afd@bike.lwn.net>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 21 Jun 2010 13:26:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement and use irq_schedule_poll() to schedule desc->poll_timer
instead of calling mod_timer directly.  irq_schedule_poll() is called
with desc->lock held and schedules the timer iff necessary - ie. if
the timer is offline or scheduled to expire later than requested.
This will be used to share desc->poll_timer.

* Jiri and Jonathan pointed out that IRQ_POLL_SLACK of HZ / 1000 would
  yield 0 slack on the popular 250HZ config.  Adjusted to HZ / 250.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
---
Minor update.  IRQ_POLL_SLACK bumped up to HZ / 250.

Thanks.

 kernel/irq/spurious.c |   47 +++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 41 insertions(+), 6 deletions(-)

Index: work/kernel/irq/spurious.c
===================================================================
--- work.orig/kernel/irq/spurious.c
+++ work/kernel/irq/spurious.c
@@ -23,6 +23,8 @@ enum {

 	/* IRQ polling common parameters */
 	IRQ_POLL_INTV			= HZ / 100,	/* from the good ol' 100HZ tick */
+
+	IRQ_POLL_SLACK			= HZ / 250,	/* 1 tick slack w/ the popular 250HZ config */
 };

 int noirqdebug __read_mostly;
@@ -43,6 +45,38 @@ static void print_irq_handlers(struct ir
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
@@ -207,7 +241,9 @@ void __note_interrupt(unsigned int irq,
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
@@ -238,10 +273,10 @@ void irq_poll_action_added(struct irq_de
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
