Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933555Ab2GMTCY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 15:02:24 -0400
Received: from www.linutronix.de ([62.245.132.108]:46223 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932263Ab2GMTCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 15:02:23 -0400
Date: Fri, 13 Jul 2012 21:02:20 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Avi Kivity <avi@redhat.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>
Subject: Re: [GIT PULL] KVM fixes for 3.5-rc6
In-Reply-To: <CA+55aFwxXPEw-fupEdbCo5eTSC5NPKwvDNkLC9V4NWQ+i3gLxg@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1207132056540.32033@ionos>
References: <4FFEBB39.8090308@redhat.com> <CA+55aFwAXbrQRKg_cJT04H_XnoEPjJ0O711C5uA6fRY35DVhKQ@mail.gmail.com> <CA+55aFy=ogfJu3WuoCCDseysxOOn_UEAnv_7Ldsa45VV7fMVPg@mail.gmail.com> <alpine.LFD.2.02.1207131928000.32033@ionos>
 <CA+55aFwxXPEw-fupEdbCo5eTSC5NPKwvDNkLC9V4NWQ+i3gLxg@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jul 2012, Linus Torvalds wrote:

> On Fri, Jul 13, 2012 at 11:28 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> >
> > We already discussed to let the irq chip (in this case MSI) tell the
> > core that it does not need the extra oneshot handling. That way the
> > code which requests an threaded irq with the NULL primary handler
> > works on both MSI and normal interrupts.
> 
> So I  don't think your patch is quite right.
> 
> If you want to clear the IRQF_ONESHOT for MSI irq's (and other ones
> where the interrupt controller is fundamentally ONESHOT), I think you
> should do it a few lines higher up - *before* you check the "does the
> IRQF_ONESHOT mask match other shared interrupts"?
> 
> Now, irq sharing presumably doesn't happen with MSI, but there's
> nothing fundamentally wrong with message-based irq schemes that have
> shared interrupt handlers.
> 
> I think. Hmm?

Shared irqs are not supported by MSI, but yes, the check should be
done way up. Makes it less ugly as well :)

Thanks,

	tglx

Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6/arch/x86/kernel/apic/io_apic.c
@@ -3109,6 +3109,7 @@ static struct irq_chip msi_chip = {
 	.irq_set_affinity	= msi_set_affinity,
 #endif
 	.irq_retrigger		= ioapic_retrigger_irq,
+	.flags			= IRQCHIP_ONESHOT_SAFE,
 };
 
 static int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc, int irq)
Index: linux-2.6/include/linux/irq.h
===================================================================
--- linux-2.6.orig/include/linux/irq.h
+++ linux-2.6/include/linux/irq.h
@@ -351,6 +351,7 @@ enum {
 	IRQCHIP_MASK_ON_SUSPEND		= (1 <<  2),
 	IRQCHIP_ONOFFLINE_ENABLED	= (1 <<  3),
 	IRQCHIP_SKIP_SET_WAKE		= (1 <<  4),
+	IRQCHIP_ONESHOT_SAFE		= (1 <<  5),
 };
 
 /* This include will go away once we isolated irq_desc usage to core code */
Index: linux-2.6/kernel/irq/manage.c
===================================================================
--- linux-2.6.orig/kernel/irq/manage.c
+++ linux-2.6/kernel/irq/manage.c
@@ -960,6 +960,18 @@ __setup_irq(unsigned int irq, struct irq
 	}
 
 	/*
+	 * Drivers are often written to work w/o knowledge about the
+	 * underlying irq chip implementation, so a request for a
+	 * threaded irq without a primary hard irq context handler
+	 * requires the ONESHOT flag to be set. Some irq chips like
+	 * MSI based interrupts are per se one shot safe. Check the
+	 * chip flags, so we can avoid the unmask dance at the end of
+	 * the threaded handler for those.
+	 */
+	if (desc->irq_data.chip->flags & IRQCHIP_ONESHOT_SAFE)
+		new->flags &= ~IRQF_ONESHOT;
+
+	/*
 	 * The following block of code has to be executed atomically
 	 */
 	raw_spin_lock_irqsave(&desc->lock, flags);
@@ -1033,7 +1045,8 @@ __setup_irq(unsigned int irq, struct irq
 		 */
 		new->thread_mask = 1 << ffz(thread_mask);
 
-	} else if (new->handler == irq_default_primary_handler) {
+	} else if (new->handler == irq_default_primary_handler &&
+		   !(desc->irq_data.chip->flags & IRQCHIP_ONESHOT_SAFE)) {
 		/*
 		 * The interrupt was requested with handler = NULL, so
 		 * we use the default primary handler for it. But it


