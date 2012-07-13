Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030846Ab2GMS2N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 14:28:13 -0400
Received: from www.linutronix.de ([62.245.132.108]:46149 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933472Ab2GMS2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 14:28:10 -0400
Date: Fri, 13 Jul 2012 20:28:07 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Avi Kivity <avi@redhat.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>
Subject: Re: [GIT PULL] KVM fixes for 3.5-rc6
In-Reply-To: <CA+55aFy=ogfJu3WuoCCDseysxOOn_UEAnv_7Ldsa45VV7fMVPg@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1207131928000.32033@ionos>
References: <4FFEBB39.8090308@redhat.com> <CA+55aFwAXbrQRKg_cJT04H_XnoEPjJ0O711C5uA6fRY35DVhKQ@mail.gmail.com> <CA+55aFy=ogfJu3WuoCCDseysxOOn_UEAnv_7Ldsa45VV7fMVPg@mail.gmail.com>
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

> On Fri, Jul 13, 2012 at 8:45 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> At the same time, I do wonder if maybe MSI + IRQF_ONESHOT couldn't be
> improved. The fact that the KVM people think that the extra overhead
> of IRQF_ONESHOT is a bad thing for MSI interrupts makes me wonder if
> maybe this wouldn't be an area the irq layer couldn't be improved on.
> Maybe the MSI+IRQF_ONESHOT case could be improved. Because MSI is kind
> of fundamentally one-shot, since it's a message-based irq scheme.  So
> maybe the extra overhead is unnecessary in general, not just in this
> particular KVM case. Hmm?
> 
> Thomas, see the commentary of a76beb14123a ("KVM: Fix device
> assignment threaded irq handler").

Groan.

We already discussed to let the irq chip (in this case MSI) tell the
core that it does not need the extra oneshot handling. That way the
code which requests an threaded irq with the NULL primary handler
works on both MSI and normal interrupts.

Untested patch below.

Thanks,

	tglx

-----
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
@@ -1004,35 +1004,48 @@ __setup_irq(unsigned int irq, struct irq
 	 */
 	if (new->flags & IRQF_ONESHOT) {
 		/*
-		 * Unlikely to have 32 resp 64 irqs sharing one line,
-		 * but who knows.
+		 * Drivers are often written to work w/o knowledge
+		 * about the underlying irq chip implementation, so a
+		 * request for a threaded irq without a primary hard
+		 * irq context handler requires the ONESHOT flag to be
+		 * set. Some irq chips like MSI based interrupts are
+		 * per se one shot safe. Check the chip flags, so we
+		 * can avoid the unmask dance at the end of the
+		 * threaded handler for those.
 		 */
-		if (thread_mask == ~0UL) {
-			ret = -EBUSY;
-			goto out_mask;
+		if (desc->irq_data.chip->flags & IRQCHIP_ONESHOT_SAFE) {
+			new->flags &= ~IRQF_ONESHOT;
+		} else {
+			/*
+			 * Unlikely to have 32 resp 64 irqs sharing one line,
+			 * but who knows.
+			 */
+			if (thread_mask == ~0UL) {
+				ret = -EBUSY;
+				goto out_mask;
+			}
+			/*
+			 * The thread_mask for the action is or'ed to
+			 * desc->thread_active to indicate that the
+			 * IRQF_ONESHOT thread handler has been woken, but not
+			 * yet finished. The bit is cleared when a thread
+			 * completes. When all threads of a shared interrupt
+			 * line have completed desc->threads_active becomes
+			 * zero and the interrupt line is unmasked. See
+			 * handle.c:irq_wake_thread() for further information.
+			 *
+			 * If no thread is woken by primary (hard irq context)
+			 * interrupt handlers, then desc->threads_active is
+			 * also checked for zero to unmask the irq line in the
+			 * affected hard irq flow handlers
+			 * (handle_[fasteoi|level]_irq).
+			 *
+			 * The new action gets the first zero bit of
+			 * thread_mask assigned. See the loop above which or's
+			 * all existing action->thread_mask bits.
+			 */
+			new->thread_mask = 1 << ffz(thread_mask);
 		}
-		/*
-		 * The thread_mask for the action is or'ed to
-		 * desc->thread_active to indicate that the
-		 * IRQF_ONESHOT thread handler has been woken, but not
-		 * yet finished. The bit is cleared when a thread
-		 * completes. When all threads of a shared interrupt
-		 * line have completed desc->threads_active becomes
-		 * zero and the interrupt line is unmasked. See
-		 * handle.c:irq_wake_thread() for further information.
-		 *
-		 * If no thread is woken by primary (hard irq context)
-		 * interrupt handlers, then desc->threads_active is
-		 * also checked for zero to unmask the irq line in the
-		 * affected hard irq flow handlers
-		 * (handle_[fasteoi|level]_irq).
-		 *
-		 * The new action gets the first zero bit of
-		 * thread_mask assigned. See the loop above which or's
-		 * all existing action->thread_mask bits.
-		 */
-		new->thread_mask = 1 << ffz(thread_mask);
-
 	} else if (new->handler == irq_default_primary_handler) {
 		/*
 		 * The interrupt was requested with handler = NULL, so
