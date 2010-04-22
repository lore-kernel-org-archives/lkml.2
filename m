Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229Ab0DVUlu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:41:50 -0400
Received: from kroah.org ([198.145.64.141]:37377 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756159Ab0DVT16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:27:58 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:11 2010
Message-Id: <20100422190910.948478255@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:08:11 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       David Miller <davem@davemloft.net>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [040/197] genirq: Force MSI irq handlers to run with interrupts disabled
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit 753649dbc49345a73a2454c770a3f2d54d11aec6 upstream.

Network folks reported that directing all MSI-X vectors of their multi
queue NICs to a single core can cause interrupt stack overflows when
enough interrupts fire at the same time.

This is caused by the fact that we run interrupt handlers by default
with interrupts enabled unless the driver reuqests the interrupt with
the IRQF_DISABLED set. The NIC handlers do not set this flag, so
simultaneous interrupts can nest unlimited and cause the stack
overflow.

The only safe counter measure is to run the interrupt handlers with
interrupts disabled. We can't switch to this mode in general right
now, but it is safe to do so for MSI interrupts.

Force IRQF_DISABLED for MSI interrupt handlers.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Linus Torvalds <torvalds@osdl.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: David Miller <davem@davemloft.net>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/irq/manage.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -735,6 +735,16 @@ __setup_irq(unsigned int irq, struct irq
 		if (new->flags & IRQF_ONESHOT)
 			desc->status |= IRQ_ONESHOT;
 
+		/*
+		 * Force MSI interrupts to run with interrupts
+		 * disabled. The multi vector cards can cause stack
+		 * overflows due to nested interrupts when enough of
+		 * them are directed to a core and fire at the same
+		 * time.
+		 */
+		if (desc->msi_desc)
+			new->flags |= IRQF_DISABLED;
+
 		if (!(desc->status & IRQ_NOAUTOEN)) {
 			desc->depth = 0;
 			desc->status &= ~IRQ_DISABLED;


