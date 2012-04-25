Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004Ab2DYMzE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 08:55:04 -0400
Received: from www.linutronix.de ([62.245.132.108]:39407 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754Ab2DYMzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 08:55:01 -0400
Date: Wed, 25 Apr 2012 14:54:54 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: NeilBrown <neilb@suse.de>
cc: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH 2/3] IRQ: allow check_wakeup_irqs to notice level-triggered
 interrupts.
In-Reply-To: <20120425193916.0db1b4b1@notabene.brown>
Message-ID: <alpine.LFD.2.02.1204251402360.2542@ionos>
References: <20120425025637.7832.14013.stgit@notabene.brown> <20120425030524.7832.85239.stgit@notabene.brown> <alpine.LFD.2.02.1204251018530.2542@ionos> <20120425193916.0db1b4b1@notabene.brown>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Apr 2012, NeilBrown wrote:
> On Wed, 25 Apr 2012 10:50:15 +0200 (CEST) Thomas Gleixner
> <tglx@linutronix.de> wrote:
> 
> > On Wed, 25 Apr 2012, NeilBrown wrote:
> > 
> > > Level triggered interrupts do not cause IRQS_PENDING to be set, so
> > > check_wakeup_irqs ignores them.
> > > They don't need to set IRQS_PENDING as the level stays high which
> > > shows that they must be pending.  However if such an interrupt fired
> > > during late suspend, it will have been masked so the fact that it
> > > is still asserted will not cause the suspend to abort.
> > > 
> > > So if any wakeup interrupt is masked, unmask it when checking wakeup
> > > irqs.  If the interrupt is asserted, suspend will abort.
> > > 
> > > Signed-off-by: NeilBrown <neilb@suse.de>
> > > ---
> > > 
> > >  kernel/irq/pm.c |    6 ++++++
> > >  1 file changed, 6 insertions(+)
> > > 
> > > diff --git a/kernel/irq/pm.c b/kernel/irq/pm.c
> > > index 15e53b1..0d26206 100644
> > > --- a/kernel/irq/pm.c
> > > +++ b/kernel/irq/pm.c
> > > @@ -106,6 +106,12 @@ int check_wakeup_irqs(void)
> > >  		if (irqd_is_wakeup_set(&desc->irq_data)) {
> > >  			if (desc->istate & IRQS_PENDING)
> > >  				return -EBUSY;
> > > +			if (irqd_irq_masked(&desc->irq_data))
> > > +				/* Probably a level interrupt
> > > +				 * which fired recently and was
> > > +				 * masked
> > > +				 */
> > > +				unmask_irq(desc);
> > 
> > Oh no. We don't unmask unconditionally. What about an interrupt which
> > is disabled, has no handler ..... ? That needs more thought.
> 
> If there is no handler, then irqd_is_wakeup_set() should fail should it not?

Well, it does not. The wakeup state is a permanent flag on the irq
line. Though we don't have IRQS_SUSPENDED on that descriptor.
 
> For disabled: would it be OK to check desc->depth?
> Something like:
>      if (desc->depth == 1 && (desc->state & IRQS_SUSPENDED) &&
>          irqd_irq_masked(&desc->irq_data))
>               unmask_irq(desc);
> 

Why not simply managing the pending bit for level irqs ?

Index: tip/kernel/irq/chip.c
===================================================================
--- tip.orig/kernel/irq/chip.c
+++ tip/kernel/irq/chip.c
@@ -379,8 +379,10 @@ handle_level_irq(unsigned int irq, struc
 	 * If its disabled or no action available
 	 * keep it masked and get out of here
 	 */
-	if (unlikely(!desc->action || irqd_irq_disabled(&desc->irq_data)))
+	if (unlikely(!desc->action || irqd_irq_disabled(&desc->irq_data))) {
+		desc->istate |= IRQS_PENDING;
 		goto out_unlock;
+	}
 
 	handle_irq_event(desc);
 
Index: tip/kernel/irq/resend.c
===================================================================
--- tip.orig/kernel/irq/resend.c
+++ tip/kernel/irq/resend.c
@@ -58,10 +58,13 @@ void check_irq_resend(struct irq_desc *d
 	/*
 	 * We do not resend level type interrupts. Level type
 	 * interrupts are resent by hardware when they are still
-	 * active.
+	 * active. Clear the pending bit so suspend/resume does not
+	 * get confused.
 	 */
-	if (irq_settings_is_level(desc))
+	if (irq_settings_is_level(desc)) {
+		desc->istate &= ~IRQS_PENDING;
 		return;
+	}
 	if (desc->istate & IRQS_REPLAY)
 		return;
 	if (desc->istate & IRQS_PENDING) {

And to handle interrupts which have been disabled before suspend add:

Index: tip/kernel/irq/pm.c
===================================================================
--- tip.orig/kernel/irq/pm.c
+++ tip/kernel/irq/pm.c
@@ -103,7 +103,8 @@ int check_wakeup_irqs(void)
 	int irq;
 
 	for_each_irq_desc(irq, desc) {
-		if (irqd_is_wakeup_set(&desc->irq_data)) {
+		if (desc->depth == 1 &&
+		    irqd_is_wakeup_set(&desc->irq_data)) {
 			if (desc->istate & IRQS_PENDING)
 				return -EBUSY;
 			continue;
