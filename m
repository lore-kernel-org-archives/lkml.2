Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558Ab2BGRDS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 12:03:18 -0500
Received: from www.linutronix.de ([62.245.132.108]:55353 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090Ab2BGRDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 12:03:17 -0500
Date: Tue, 7 Feb 2012 18:03:14 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: =?ISO-8859-15?Q?Lothar_Wa=DFmann?= <LW@KARO-electronics.de>
cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Yong Zhang <yong.zhang0@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] genirq: Fix race condition in ONESHOT irq handler
In-Reply-To: <1328621921-17404-1-git-send-email-LW@KARO-electronics.de>
Message-ID: <alpine.LFD.2.02.1202071719340.2794@ionos>
References: <4F31220A.2050708@metafoo.de> <1328621921-17404-1-git-send-email-LW@KARO-electronics.de>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-126526901-1328632644=:2794"
Content-ID: <alpine.LFD.2.02.1202071738260.2794@ionos>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-126526901-1328632644=:2794
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.LFD.2.02.1202071738261.2794@ionos>

On Tue, 7 Feb 2012, Lothar Waﬂmann wrote:

> There is a race condition in the threaded IRQ handler code for oneshot
> interrupts that may lead to disabling an IRQ indefinitely. IRQs are
> masked before calling the hard-irq handler and are unmasked only after
> the soft-irq handler has been run. Thus if the hard-irq handler
> returns IRQ_HANDLED instead of IRQ_WAKE_THREAD, meaning the soft-irq

Well, oneshot mode interrupts always had the semantics that the
threaded handler needs to run unconditionally. In fact the oneshot
mode was implemented to handle hardware which cannot do anything in
hard interrupt context to avoid the ugliness of a primary handler
calling disable_irq_nosync().

So it looks like driver developers decided that the oneshot mode might
be interesting with a primary handler as well. I can see the reason
why the tsc2007 driver uses it, but that does not make it a bug in the
core code in the first place.

Though we should handle it and the problem not only arises with the
IRQ_HANDLED return code, it also arises with IRQ_NONE.

> will not be called, the interrupt will remain masked forever.
> 
> This can happen due to a short pulse on the interrupt line, that
> triggers the interrupt logic, but goes undetected by the hard-irq
> handler. The problem can be reproduced with the TSC2007 touch
> controller driver that uses ONESHOT interrupts.

It should not return IRQ_HANDLED in that case, as the real thing is a
spurious interrupt.
 
> The problem arises also with interrupt controllers that latch a level
> triggered IRQ until it is acknowledged (like the i.MX28 does).
> In this case the IRQ status bit will remain asserted after the
> soft-irq finishes and retrigger the interrupt while the interrupt line
> is already deasserted.

This does not make sense. We acknowledge interrupts via mask_ack_irq()
right on entry of handle_level_irq(). So either the interrupt
controller is completely hosed or this explanation is bogus.

> Signed-off-by: Lothar Waﬂmann <LW@KARO-electronics.de>
> ---
>  kernel/irq/chip.c |    9 +++++++--
>  1 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
> index f7c543a..74fdef9 100644
> --- a/kernel/irq/chip.c
> +++ b/kernel/irq/chip.c
> @@ -343,6 +343,8 @@ EXPORT_SYMBOL_GPL(handle_simple_irq);
>  void
>  handle_level_irq(unsigned int irq, struct irq_desc *desc)
>  {
> +	irqreturn_t ret;
> +
>  	raw_spin_lock(&desc->lock);
>  	mask_ack_irq(desc);
>  
> @@ -360,10 +362,13 @@ handle_level_irq(unsigned int irq, struct irq_desc *desc)
>  	if (unlikely(!desc->action || irqd_irq_disabled(&desc->irq_data)))
>  		goto out_unlock;
>  
> -	handle_irq_event(desc);
> +	ret = handle_irq_event(desc);
>  
> -	if (!irqd_irq_disabled(&desc->irq_data) && !(desc->istate & IRQS_ONESHOT))
> +	if (!irqd_irq_disabled(&desc->irq_data) &&
> +			(!(desc->istate & IRQS_ONESHOT) ||
> +				!(ret & IRQ_WAKE_THREAD)))

Hmm, that looks ugly and it misses the same fixup for
handle_fasteoi_irq() including proper comments.

The following patch should address both cases.

Thanks,

	tglx

===================================================================
--- linux-3.2.orig/kernel/irq/chip.c +++ linux-3.2/kernel/irq/chip.c
@@ -330,6 +330,24 @@ out_unlock: }
EXPORT_SYMBOL_GPL(handle_simple_irq);
 
+/*
+ * Called unconditionally from handle_level_irq() and only for oneshot
+ * interrupts from handle_fasteoi_irq()
+ */
+static void cond_unmask_irq(struct irq_desc *desc)
+{
+	/*
+	 * We need to unmask in the following cases:
+	 * - Standard level irq (IRQF_ONESHOT is not set)
+	 * - Oneshot irq which did not wake the thread (caused by a
+	 *   spurious interrupt or a primary handler handling it
+	 *   completely).
+	 */
+	if (!irqd_irq_disabled(&desc->irq_data) &&
+	    irqd_irq_masked(&desc->irq_data) && !desc->threads_oneshot)
+		unmask_irq(desc);
+}
+
 /**
  *	handle_level_irq - Level type irq handler
  *	@irq:	the interrupt number
@@ -362,8 +380,8 @@ handle_level_irq(unsigned int irq, struc
 
 	handle_irq_event(desc);
 
-	if (!irqd_irq_disabled(&desc->irq_data) && !(desc->istate & IRQS_ONESHOT))
-		unmask_irq(desc);
+	cond_unmask_irq(desc);
+
 out_unlock:
 	raw_spin_unlock(&desc->lock);
 }
@@ -417,6 +435,9 @@ handle_fasteoi_irq(unsigned int irq, str
 	preflow_handler(desc);
 	handle_irq_event(desc);
 
+	if (desc->istate & IRQS_ONESHOT)
+		cond_unmask_irq(desc);
+
 out_eoi:
 	desc->irq_data.chip->irq_eoi(&desc->irq_data);
 out_unlock:
--8323328-126526901-1328632644=:2794--
