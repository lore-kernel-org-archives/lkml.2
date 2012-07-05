Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756768Ab2GEWBF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 18:01:05 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:37137 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755616Ab2GEWBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 18:01:03 -0400
Date: Thu, 5 Jul 2012 18:00:40 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matt Mackall <mpm@selenic.com>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>, w@1wt.eu,
        ewust@umich.edu, zakir@umich.edu, greg@kroah.com, nadiah@cs.ucsd.edu,
        jhalderm@umich.edu, tglx@linutronix.de, davem@davemloft.net,
        stable@kernel.org
Subject: Re: [PATCH 01/10] random: make 'add_interrupt_randomness()' do
 something sane
Message-ID: <20120705220040.GA15685@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Matt Mackall <mpm@selenic.com>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	w@1wt.eu, ewust@umich.edu, zakir@umich.edu, greg@kroah.com,
	nadiah@cs.ucsd.edu, jhalderm@umich.edu, tglx@linutronix.de,
	davem@davemloft.net, stable@kernel.org
References: <1341511933-11169-1-git-send-email-tytso@mit.edu>
 <1341511933-11169-2-git-send-email-tytso@mit.edu>
 <1341514078.4020.1213.camel@calx>
 <CA+55aFyMYVLCW0OYTVttkjjOwyu9VgDM9haNC=BeoRCEiWWNPQ@mail.gmail.com>
 <1341524367.4020.1324.camel@calx>
 <CA+55aFxAe1pRN+jvdLveHQ+nNRNC6HDZ+S4Y9P202rxgNLN8pg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxAe1pRN+jvdLveHQ+nNRNC6HDZ+S4Y9P202rxgNLN8pg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 05, 2012 at 02:47:52PM -0700, Linus Torvalds wrote:
> On Thu, Jul 5, 2012 at 2:39 PM, Matt Mackall <mpm@selenic.com> wrote:
> >
> > From my read, this code path gets called on timer interrupts too.
> 
> That's hopefully never true for any normal cases (timers are *very*
> special - they tend to go through their own architecture-specific
> stuff). On modern PC's, for example, the timers happen through the
> local apic timers directly.
> 
> In fact, with SMP, it's a really bad idea to use a normal irq for
> timer interrupts, since you really really want per-CPU-core timers.
> 
> But yes, we should probably make sure that *if* the architecture uses
> regular interrupts for timers we don't count them. The problematic
> embedded platforms are often pretty crap hardware: even when they are
> SMP, they might use an external timer irq (and then we broadcast the
> thing). I think we have the IRQF_TIMER flag for that, so we could add
> a check for that.

Like this?

						- Ted

diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 8270db0..0ce4863 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -133,7 +133,7 @@ irqreturn_t
 handle_irq_event_percpu(struct irq_desc *desc, struct irqaction *action)
 {
 	irqreturn_t retval = IRQ_NONE;
-	unsigned int random = 0, irq = desc->irq_data.irq;
+	unsigned int random = 1, irq = desc->irq_data.irq;
 
 	do {
 		irqreturn_t res;
@@ -161,7 +161,8 @@ handle_irq_event_percpu(struct irq_desc *desc, struct irqaction *action)
 
 			/* Fall through to add to randomness */
 		case IRQ_HANDLED:
-			random |= action->flags;
+			if (action->flags & __IRQF_TIMER)
+				random = 0;
 			break;
 
 		default:
@@ -172,7 +173,8 @@ handle_irq_event_percpu(struct irq_desc *desc, struct irqaction *action)
 		action = action->next;
 	} while (action);
 
-	add_interrupt_randomness(irq);
+	if (random)
+		add_interrupt_randomness(irq);
 
 	if (!noirqdebug)
 		note_interrupt(irq, desc, retval);
