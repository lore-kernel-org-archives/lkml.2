Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949Ab2FLO5H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 10:57:07 -0400
Received: from www.linutronix.de ([62.245.132.108]:44316 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496Ab2FLO5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 10:57:05 -0400
Date: Tue, 12 Jun 2012 16:56:57 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
cc: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] irq/core changes for v3.5
In-Reply-To: <Pine.LNX.4.64.1206121201130.6800@axis700.grange>
Message-ID: <alpine.LFD.2.02.1206121639420.3086@ionos>
References: <20120522032554.GA11358@gmail.com> <Pine.LNX.4.64.1206121201130.6800@axis700.grange>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Jun 2012, Guennadi Liakhovetski wrote:
> Correct me if I'm wrong, but the above patch, however good and correct in 
> principle, breaks all existing drivers, that currently use 
> request_threaded_irq() in this "bogus" way, namely, with NULL handler and 
> without the IRQF_ONESHOT flag? Of those drivers I counted 73 in today's 
> Linus' tree with a total of 92 call occurrences. Isn't this a bit too 
> brutal? How about either doing it more gently (first just issue a warning) 
> or first fixing them all? The current approach seems to just cause a bunch 
> of regressions to me? I can provide a list of affected files, if someone 
> volunteers to fix them all;-)

Yeah, I guess I was a bit too fast with that after Linus ranting about
the missing check. :)

Thinking more about it, it's probably the best thing to simply force
the IRQF_ONESHOT flag if it's missing. I'd love to omit it for non
level type interrupts to avoid the overhead in the irq thread, but
there is no way to figure that out at this point.

Does that fix it for you ?

Thanks,

	tglx
---
 kernel/irq/manage.c |   39 ++++++++++++++++++---------------------
 1 file changed, 18 insertions(+), 21 deletions(-)

Index: tip/kernel/irq/manage.c
===================================================================
--- tip.orig/kernel/irq/manage.c
+++ tip/kernel/irq/manage.c
@@ -959,6 +959,24 @@ __setup_irq(unsigned int irq, struct irq
 		goto out_thread;
 	}
 
+	if (new->handler == irq_default_primary_handler ) {
+		/*
+		 * The interrupt was requested with handler = NULL, so
+		 * we use the default primary handler for it.
+		 *
+		 * This requires the IRQF_ONESHOT flag set especially
+		 * for level type interrupts, because the default
+		 * primary handler just wakes the thread, then the irq
+		 * lines is reenabled, but the device still has the
+		 * level irq asserted. Rinse and repeat....
+		 *
+		 * Omitting the flag works for edge type interrupts,
+		 * but we can't say for sure which type this interrupt
+		 * really has at this point. So we simply enforce it.
+		 */
+		new->flags |= IRQF_ONESHOT;
+	}
+
 	/*
 	 * The following block of code has to be executed atomically
 	 */
@@ -1032,27 +1050,6 @@ __setup_irq(unsigned int irq, struct irq
 		 * all existing action->thread_mask bits.
 		 */
 		new->thread_mask = 1 << ffz(thread_mask);
-
-	} else if (new->handler == irq_default_primary_handler) {
-		/*
-		 * The interrupt was requested with handler = NULL, so
-		 * we use the default primary handler for it. But it
-		 * does not have the oneshot flag set. In combination
-		 * with level interrupts this is deadly, because the
-		 * default primary handler just wakes the thread, then
-		 * the irq lines is reenabled, but the device still
-		 * has the level irq asserted. Rinse and repeat....
-		 *
-		 * While this works for edge type interrupts, we play
-		 * it safe and reject unconditionally because we can't
-		 * say for sure which type this interrupt really
-		 * has. The type flags are unreliable as the
-		 * underlying chip implementation can override them.
-		 */
-		pr_err("Threaded irq requested with handler=NULL and !ONESHOT for irq %d\n",
-		       irq);
-		ret = -EINVAL;
-		goto out_mask;
 	}
 
 	if (!shared) {


