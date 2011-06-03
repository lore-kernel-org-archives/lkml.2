Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873Ab1FCM6d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 08:58:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:60543 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754720Ab1FCM6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 08:58:31 -0400
Date: Fri, 3 Jun 2011 12:58:16 GMT
From: tip-bot for Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Message-ID: <tip-3a43e05f4d0600e906fa09f4a65d749288c44592@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        sebastian@breakpoint.cc, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, sebastian@breakpoint.cc
In-Reply-To: <1306824972-27067-2-git-send-email-sebastian@breakpoint.cc>
References: <1306824972-27067-2-git-send-email-sebastian@breakpoint.cc>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/urgent] irq: Handle spurios irq detection for threaded irqs
Git-Commit-ID: 3a43e05f4d0600e906fa09f4a65d749288c44592
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 03 Jun 2011 12:58:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3a43e05f4d0600e906fa09f4a65d749288c44592
Gitweb:     http://git.kernel.org/tip/3a43e05f4d0600e906fa09f4a65d749288c44592
Author:     Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
AuthorDate: Tue, 31 May 2011 08:56:11 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 3 Jun 2011 14:53:15 +0200

irq: Handle spurios irq detection for threaded irqs

The detection of spurios interrupts is currently limited to first level
handler. In force-threaded mode we never notice if the threaded irq does
not feel responsible.
This patch catches the return value of the threaded handler and forwards
it to the spurious detector. If the primary handler returns only
IRQ_WAKE_THREAD then the spourious detector ignores it because it gets
called again from the threaded handler.

[ tglx: Report the erroneous return value early and bail out ]

Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Link: http://lkml.kernel.org/r/1306824972-27067-2-git-send-email-sebastian@breakpoint.cc
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/irqreturn.h |    6 +++---
 kernel/irq/handle.c       |    6 ------
 kernel/irq/manage.c       |   24 ++++++++++++++++++------
 kernel/irq/spurious.c     |   22 ++++++++++++++++++----
 4 files changed, 39 insertions(+), 19 deletions(-)

diff --git a/include/linux/irqreturn.h b/include/linux/irqreturn.h
index 819acaa..714ba08 100644
--- a/include/linux/irqreturn.h
+++ b/include/linux/irqreturn.h
@@ -8,9 +8,9 @@
  * @IRQ_WAKE_THREAD	handler requests to wake the handler thread
  */
 enum irqreturn {
-	IRQ_NONE,
-	IRQ_HANDLED,
-	IRQ_WAKE_THREAD,
+	IRQ_NONE		= (0 << 0),
+	IRQ_HANDLED		= (1 << 0),
+	IRQ_WAKE_THREAD		= (1 << 1),
 };
 
 typedef enum irqreturn irqreturn_t;
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 90cb55f..470d08c 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -133,12 +133,6 @@ handle_irq_event_percpu(struct irq_desc *desc, struct irqaction *action)
 		switch (res) {
 		case IRQ_WAKE_THREAD:
 			/*
-			 * Set result to handled so the spurious check
-			 * does not trigger.
-			 */
-			res = IRQ_HANDLED;
-
-			/*
 			 * Catch drivers which return WAKE_THREAD but
 			 * did not set up a thread function
 			 */
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index f7ce002..d64bafb 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -723,13 +723,16 @@ irq_thread_check_affinity(struct irq_desc *desc, struct irqaction *action) { }
  * context. So we need to disable bh here to avoid deadlocks and other
  * side effects.
  */
-static void
+static irqreturn_t
 irq_forced_thread_fn(struct irq_desc *desc, struct irqaction *action)
 {
+	irqreturn_t ret;
+
 	local_bh_disable();
-	action->thread_fn(action->irq, action->dev_id);
+	ret = action->thread_fn(action->irq, action->dev_id);
 	irq_finalize_oneshot(desc, action, false);
 	local_bh_enable();
+	return ret;
 }
 
 /*
@@ -737,10 +740,14 @@ irq_forced_thread_fn(struct irq_desc *desc, struct irqaction *action)
  * preemtible - many of them need to sleep and wait for slow busses to
  * complete.
  */
-static void irq_thread_fn(struct irq_desc *desc, struct irqaction *action)
+static irqreturn_t irq_thread_fn(struct irq_desc *desc,
+		struct irqaction *action)
 {
-	action->thread_fn(action->irq, action->dev_id);
+	irqreturn_t ret;
+
+	ret = action->thread_fn(action->irq, action->dev_id);
 	irq_finalize_oneshot(desc, action, false);
+	return ret;
 }
 
 /*
@@ -753,7 +760,8 @@ static int irq_thread(void *data)
 	};
 	struct irqaction *action = data;
 	struct irq_desc *desc = irq_to_desc(action->irq);
-	void (*handler_fn)(struct irq_desc *desc, struct irqaction *action);
+	irqreturn_t (*handler_fn)(struct irq_desc *desc,
+			struct irqaction *action);
 	int wake;
 
 	if (force_irqthreads & test_bit(IRQTF_FORCED_THREAD,
@@ -783,8 +791,12 @@ static int irq_thread(void *data)
 			desc->istate |= IRQS_PENDING;
 			raw_spin_unlock_irq(&desc->lock);
 		} else {
+			irqreturn_t action_ret;
+
 			raw_spin_unlock_irq(&desc->lock);
-			handler_fn(desc, action);
+			action_ret = handler_fn(desc, action);
+			if (!noirqdebug)
+				note_interrupt(action->irq, desc, action_ret);
 		}
 
 		wake = atomic_dec_and_test(&desc->threads_active);
diff --git a/kernel/irq/spurious.c b/kernel/irq/spurious.c
index c9a78ba..aa57d5d 100644
--- a/kernel/irq/spurious.c
+++ b/kernel/irq/spurious.c
@@ -167,6 +167,13 @@ out:
 		  jiffies + POLL_SPURIOUS_IRQ_INTERVAL);
 }
 
+static inline int bad_action_ret(irqreturn_t action_ret)
+{
+	if (likely(action_ret <= (IRQ_HANDLED | IRQ_WAKE_THREAD)))
+		return 0;
+	return 1;
+}
+
 /*
  * If 99,900 of the previous 100,000 interrupts have not been handled
  * then assume that the IRQ is stuck in some manner. Drop a diagnostic
@@ -182,7 +189,7 @@ __report_bad_irq(unsigned int irq, struct irq_desc *desc,
 	struct irqaction *action;
 	unsigned long flags;
 
-	if (action_ret != IRQ_HANDLED && action_ret != IRQ_NONE) {
+	if (bad_action_ret(action_ret)) {
 		printk(KERN_ERR "irq event %d: bogus return value %x\n",
 				irq, action_ret);
 	} else {
@@ -263,7 +270,16 @@ void note_interrupt(unsigned int irq, struct irq_desc *desc,
 	if (desc->istate & IRQS_POLL_INPROGRESS)
 		return;
 
-	if (unlikely(action_ret != IRQ_HANDLED)) {
+	/* we get here again via the threaded handler */
+	if (action_ret == IRQ_WAKE_THREAD)
+		return;
+
+	if (bad_action_ret(action_ret)) {
+		report_bad_irq(irq, desc, action_ret);
+		return;
+	}
+
+	if (unlikely(action_ret == IRQ_NONE)) {
 		/*
 		 * If we are seeing only the odd spurious IRQ caused by
 		 * bus asynchronicity then don't eventually trigger an error,
@@ -275,8 +291,6 @@ void note_interrupt(unsigned int irq, struct irq_desc *desc,
 		else
 			desc->irqs_unhandled++;
 		desc->last_unhandled = jiffies;
-		if (unlikely(action_ret != IRQ_NONE))
-			report_bad_irq(irq, desc, action_ret);
 	}
 
 	if (unlikely(try_misrouted_irq(irq, desc, action_ret))) {
