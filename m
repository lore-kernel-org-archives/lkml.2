Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031399Ab2CFWTD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 17:19:03 -0500
Received: from www.linutronix.de ([62.245.132.108]:60109 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030811Ab2CFWTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 17:19:00 -0500
Date: Tue, 6 Mar 2012 23:18:54 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Sven Joachim <svenjoac@gmx.de>, Stefan Lippers-Hollmann <s.L-H@gmx.de>,
        Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Jonathan Nieder <jrnieder@gmail.com>, linux-wireless@vger.kernel.org,
        Stefano Brivio <stefano.brivio@polimi.it>
Subject: Re: [ 57/72] genirq: Unmask oneshot irqs when thread was not woken
In-Reply-To: <CA+55aFxdnfGREML3u+eoGf89Jci8qBuW7WBmPk3w=wRWMvRvfg@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1203062243130.2742@ionos>
References: <20120228010511.GA8453@kroah.com> <20120228010434.412979550@linuxfoundation.org> <87hay4dqjr.fsf@turtle.gmx.de> <201203050143.24541.s.L-H@gmx.de> <CA+55aFxZsVxkxifR+EUZi=RsUGKfs5vYXX3nN_M_Az1BY5yyaw@mail.gmail.com> <alpine.LFD.2.02.1203060927190.2742@ionos>
 <alpine.LFD.2.02.1203060957140.2742@ionos> <alpine.LFD.2.02.1203062019340.2742@ionos> <8762eh1p7d.fsf@turtle.gmx.de> <alpine.LFD.2.02.1203062101040.2742@ionos> <CA+55aFxdnfGREML3u+eoGf89Jci8qBuW7WBmPk3w=wRWMvRvfg@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII
Content-ID: <alpine.LFD.2.02.1203062256001.2742@ionos>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Mar 2012, Linus Torvalds wrote:
> On Tue, Mar 6, 2012 at 12:26 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> without ever doing any insane bit scanning.

Duh, yes. That's really insane. I first did

- new->thread_mask = 1 << ffz(thread_mask);
+ new->thread_mask = (new->flags & IRQF_ONESHOT) ? 1 << ffz(thread_mask) : 0;

and then decided to move it into the already existing new->flags &
IRQF_ONESHOT check section and deleted the wrong part ....

/me looks for a huge brown paperbag.

Thanks for catching it !

       tglx

-------------->
Subject: genirq: Clear action->thread_mask if IRQ_ONESHOT is not set

commit ac5637611(genirq: Unmask oneshot irqs when thread was not
woken) fails to unmask when a !IRQ_ONESHOT threaded handler is handled
by handle_level_irq. This happens because thread_mask is or'ed
unconditionally in irq_wake_thread(), but for !IRQ_ONESHOT interrupts
never cleared. So the check for !desc->thread_active fails and keeps
the interrupt disabled.

Keep the thread_mask zero for !IRQ_ONESHOT interrupts.

Document the thread_mask magic while at it.

Reported-by: Sven Joachim <svenjoac@gmx.de>
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---

Index: tip/kernel/irq/manage.c
===================================================================
--- tip.orig/kernel/irq/manage.c
+++ tip/kernel/irq/manage.c
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
