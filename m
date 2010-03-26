Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753014Ab0CZAHs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 20:07:48 -0400
Received: from www.tglx.de ([62.245.132.106]:58661 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752635Ab0CZAHo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 20:07:44 -0400
Message-Id: <20100326000405.758579387@linutronix.de>
User-Agent: quilt/0.47-1
Date: Fri, 26 Mar 2010 00:06:51 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Andi Kleen <andi@firstfloor.org>,
       David Miller <davem@davemloft.net>, Greg Kroah-Hartman <gregkh@suse.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [patch 1/2] genirq: Run irq handlers with interrupts disabled
References: <20100326000325.917127328@linutronix.de>
Content-Disposition: inline;
	filename=genirq-run-handlers-with-irqs-disabled.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Running interrupt handlers with interrupts enabled can cause stack
overflows. That has been observed with multiqueue NICs delivering all
their interrupts to a single core. We might band aid that somehow by
checking the interrupt stacks, but the real safe fix is to run the irq
handlers with interrupts disabled.

Drivers for whacky hardware still can reenable them in the handler
itself, if the need arises. (They do already due to lockdep)

The risk of doing this is rather low:

 - lockdep already enforces this
 - CONFIG_NOHZ has shaken out the drivers which relied on jiffies updates
 - time keeping is not longer sensitive to the timer interrupt being delayed

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/handle.c |    3 ---
 1 file changed, 3 deletions(-)

Index: linux-2.6/kernel/irq/handle.c
===================================================================
--- linux-2.6.orig/kernel/irq/handle.c
+++ linux-2.6/kernel/irq/handle.c
@@ -370,9 +370,6 @@ irqreturn_t handle_IRQ_event(unsigned in
 	irqreturn_t ret, retval = IRQ_NONE;
 	unsigned int status = 0;
 
-	if (!(action->flags & IRQF_DISABLED))
-		local_irq_enable_in_hardirq();
-
 	do {
 		trace_irq_handler_entry(irq, action);
 		ret = action->handler(irq, action->dev_id);


