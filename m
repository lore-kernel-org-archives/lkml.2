Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932981Ab0EDAVt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 20:21:49 -0400
Received: from mx1.corp.avencall.com ([91.194.178.12]:51205 "EHLO
	mx1.corp.avencall.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755584Ab0EDAVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 20:21:48 -0400
Date: Tue, 4 May 2010 02:21:42 +0200
From: Guillaume Knispel <gknispel@proformatique.com>
To: linux-kernel@vger.kernel.org, Linuxppc-dev@lists.ozlabs.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Guillaume Knispel <gknispel@proformatique.com>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>, Ingo Molnar <mingo@elte.hu>,
       Lars-Peter Clausen <lars@metafoo.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Russell King <linux@arm.linux.org.uk>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCHv2 1/2] genirq: reliably replay pending edge-triggered irq
Message-Id: <20100504022142.1eb653da.gknispel@proformatique.com>
In-Reply-To: <20100504021941.ff7579c1.gknispel@proformatique.com>
References: <20100504021941.ff7579c1.gknispel@proformatique.com>
X-Mailer: Sylpheed version 2.3.0beta5 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following can happen:

CPU 1                           CPU 2
disable_irq():                  handle_edge_irq():
LOCK desc->lock (irqsave)
desc->status |= IRQ_DISABLED;
desc->chip->disable(irq);/*1*/
UNLOCK desc->lock (irqrestore)
                                LOCK desc->lock
                                desc->status |= (IRQ_PENDING
                                                 | IRQ_MASKED);
                                mask_ack_irq(desc, irq);
                                UNLOCK desc->lock

NOTE /*1*/: ->disable can point to default_disable().
Since commit:
 76d2160147f43f982dfe881404cfde9fd0a9da21
 genirq: do not mask interrupts by default
the delayed interrupt disable mechanism has been activated for every
user of default_disable() -- which used to mask the interrupt at
controller level before and is now a noop.  The sequence describing a
race above will now indeed happen if an interrupt event occurs at any
time between the effective disable_irq() and the next effective
enable_irq().

Also note that even if ->disable does a masking, a similar race
can indeed happen even on a monoprocessor system if an interrupt event
occurs before just before the masking.

In order to avoid interrupt loss, an IRQ_PENDING interrupt must be
replayed when enable_irq() is called (or immediately after).

This replay (implemented in kernel/irq/resend.c) used to be reliable
only if:

  * the interrupt controller driver implements a reliable retrigger()
    callback

       or

  * CONFIG_HARDIRQS_SW_RESEND is defined (in this case the flow handler
    can be executed in a tasklet running resend_irqs() )

So CONFIG_HARDIRQS_SW_RESEND was meant to be set on plateforms where it
exists a risk that edge interrupts are used on an interrupt controller
that does not support hard retrigger (or at least not reliably).

But CONFIG_HARDIRQS_SW_RESEND was only defined on arm and avr32
architectures, and other architectures exist which can have controllers
without a reliable retrigger(). Some examples:
 * arch/powerpc/sysdev/cpm2.c arch/powerpc/sysdev/ipic.c
 * arch/blackfin/mach-common/ints-priority.c
 * arch/mips/alchemy/common/irq.c
 * ...

With the present change, resend_irqs() is unconditionally built, so
that edge-triggered interrupts can not be lost.
The CONFIG_HARDIRQS_SW_RESEND option is not used anymore.

See http://lkml.org/lkml/2010/4/19/129 for the first discussion about
this problem.

Signed-off-by: Guillaume Knispel <gknispel@proformatique.com>
CC: linux-kernel@vger.kernel.org
CC: Linuxppc-dev@lists.ozlabs.org
CC: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Haavard Skinnemoen <hskinnemoen@atmel.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Lars-Peter Clausen <lars@metafoo.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Randy Dunlap <randy.dunlap@oracle.com>
CC: Russell King <linux@arm.linux.org.uk>
CC: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/resend.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/kernel/irq/resend.c b/kernel/irq/resend.c
index 090c376..3b20ce1 100644
--- a/kernel/irq/resend.c
+++ b/kernel/irq/resend.c
@@ -20,8 +20,6 @@
 
 #include "internals.h"
 
-#ifdef CONFIG_HARDIRQS_SW_RESEND
-
 /* Bitmap to handle software resend of interrupts: */
 static DECLARE_BITMAP(irqs_resend, NR_IRQS);
 
@@ -46,8 +44,6 @@ static void resend_irqs(unsigned long arg)
 /* Tasklet to handle resend: */
 static DECLARE_TASKLET(resend_tasklet, resend_irqs, 0);
 
-#endif
-
 /*
  * IRQ resend
  *
@@ -71,11 +67,9 @@ void check_irq_resend(struct irq_desc *desc, unsigned int irq)
 		desc->status = (status & ~IRQ_PENDING) | IRQ_REPLAY;
 
 		if (!desc->chip->retrigger || !desc->chip->retrigger(irq)) {
-#ifdef CONFIG_HARDIRQS_SW_RESEND
 			/* Set it pending and activate the softirq: */
 			set_bit(irq, irqs_resend);
 			tasklet_schedule(&resend_tasklet);
-#endif
 		}
 	}
 }
-- 
1.6.2
