Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030508Ab2CITqq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 14:46:46 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51812 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030490Ab2CITqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:46:42 -0500
Message-Id: <20120309190204.196160159@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 09 Mar 2012 11:02:25 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Thomas Gleixner <tglx@linutronix.de>
Subject: [ 23/95] genirq: Clear action->thread_mask if IRQ_ONESHOT is not set
In-Reply-To: <20120309194424.GA2134@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit 52abb700e16a9aa4cbc03f3d7f80206cbbc80680 upstream.

Xommit ac5637611(genirq: Unmask oneshot irqs when thread was not woken)
fails to unmask when a !IRQ_ONESHOT threaded handler is handled by
handle_level_irq.

This happens because thread_mask is or'ed unconditionally in
irq_wake_thread(), but for !IRQ_ONESHOT interrupts never cleared.  So
the check for !desc->thread_active fails and keeps the interrupt
disabled.

Keep the thread_mask zero for !IRQ_ONESHOT interrupts.

Document the thread_mask magic while at it.

Reported-and-tested-by: Sven Joachim <svenjoac@gmx.de>
Reported-and-tested-by: Stefan Lippers-Hollmann <s.l-h@gmx.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/irq/manage.c |   44 ++++++++++++++++++++++++++++++++++++++------
 1 file changed, 38 insertions(+), 6 deletions(-)

--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -985,6 +985,11 @@ __setup_irq(unsigned int irq, struct irq
 
 		/* add new interrupt at end of irq queue */
 		do {
+			/*
+			 * Or all existing action->thread_mask bits,
+			 * so we can find the next zero bit for this
+			 * new action.
+			 */
 			thread_mask |= old->thread_mask;
 			old_ptr = &old->next;
 			old = *old_ptr;
@@ -993,14 +998,41 @@ __setup_irq(unsigned int irq, struct irq
 	}
 
 	/*
-	 * Setup the thread mask for this irqaction. Unlikely to have
-	 * 32 resp 64 irqs sharing one line, but who knows.
+	 * Setup the thread mask for this irqaction for ONESHOT. For
+	 * !ONESHOT irqs the thread mask is 0 so we can avoid a
+	 * conditional in irq_wake_thread().
 	 */
-	if (new->flags & IRQF_ONESHOT && thread_mask == ~0UL) {
-		ret = -EBUSY;
-		goto out_mask;
+	if (new->flags & IRQF_ONESHOT) {
+		/*
+		 * Unlikely to have 32 resp 64 irqs sharing one line,
+		 * but who knows.
+		 */
+		if (thread_mask == ~0UL) {
+			ret = -EBUSY;
+			goto out_mask;
+		}
+		/*
+		 * The thread_mask for the action is or'ed to
+		 * desc->thread_active to indicate that the
+		 * IRQF_ONESHOT thread handler has been woken, but not
+		 * yet finished. The bit is cleared when a thread
+		 * completes. When all threads of a shared interrupt
+		 * line have completed desc->threads_active becomes
+		 * zero and the interrupt line is unmasked. See
+		 * handle.c:irq_wake_thread() for further information.
+		 *
+		 * If no thread is woken by primary (hard irq context)
+		 * interrupt handlers, then desc->threads_active is
+		 * also checked for zero to unmask the irq line in the
+		 * affected hard irq flow handlers
+		 * (handle_[fasteoi|level]_irq).
+		 *
+		 * The new action gets the first zero bit of
+		 * thread_mask assigned. See the loop above which or's
+		 * all existing action->thread_mask bits.
+		 */
+		new->thread_mask = 1 << ffz(thread_mask);
 	}
-	new->thread_mask = 1 << ffz(thread_mask);
 
 	if (!shared) {
 		init_waitqueue_head(&desc->wait_for_threads);


