Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258Ab0CZNHq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 09:07:46 -0400
Received: from www.tglx.de ([62.245.132.106]:56934 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753089Ab0CZNHo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 09:07:44 -0400
Date: Fri, 26 Mar 2010 14:05:28 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: Linus Torvalds <torvalds@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, David Miller <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [patch 1/2] genirq: Run irq handlers with interrupts disabled
In-Reply-To: <20100326061310.GV20695@one.firstfloor.org>
Message-ID: <alpine.LFD.2.00.1003261224070.3147@localhost.localdomain>
References: <20100326000325.917127328@linutronix.de> <20100326000405.758579387@linutronix.de> <20100326061310.GV20695@one.firstfloor.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Mar 2010, Andi Kleen wrote:

> > Drivers for whacky hardware still can reenable them in the handler
> > itself, if the need arises. (They do already due to lockdep)
> 
> Can you please explain that lockdep reference?
> I don't think lockdep really forces on interrupts, does it?

Lockdep forces interrupts off. It yells at anyone enabling irqs in the
handler. The ones which do that have been annotated with
local_irq_enable_in_hardirq(), which is a nop for lockdep.

> BTW the one problem I have with this patchkit is that it's clearly
> no stable candidate and I was hoping for a stable fix too.
> Any chance to at least approve my original patch for .32/.33 only?

Why not simply force IRQF_DISABLED for all MSI interrupts. That still
allows nesting for non MSI ones, but it limits the chance of throwing
up reasonably well. That's a two liner.

Can you please test whether it resolves the issue at hand ?

Thanks,

	tglx
---
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index eb6078c..1d55e92 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -735,6 +735,9 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 		if (new->flags & IRQF_ONESHOT)
 			desc->status |= IRQ_ONESHOT;
 
+		if (desc->msi_desc)
+			new->flags |= IRQF_DISABLED;
+
 		if (!(desc->status & IRQ_NOAUTOEN)) {
 			desc->depth = 0;
 			desc->status &= ~IRQ_DISABLED;






