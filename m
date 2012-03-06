Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031048Ab2CFU0N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 15:26:13 -0500
Received: from www.linutronix.de ([62.245.132.108]:59491 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932377Ab2CFU0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 15:26:11 -0500
Date: Tue, 6 Mar 2012 21:26:07 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sven Joachim <svenjoac@gmx.de>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Stefan Lippers-Hollmann <s.L-H@gmx.de>,
        Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Jonathan Nieder <jrnieder@gmail.com>, linux-wireless@vger.kernel.org,
        Stefano Brivio <stefano.brivio@polimi.it>
Subject: Re: [ 57/72] genirq: Unmask oneshot irqs when thread was not woken
In-Reply-To: <8762eh1p7d.fsf@turtle.gmx.de>
Message-ID: <alpine.LFD.2.02.1203062101040.2742@ionos>
References: <20120228010511.GA8453@kroah.com> <20120228010434.412979550@linuxfoundation.org> <87hay4dqjr.fsf@turtle.gmx.de> <201203050143.24541.s.L-H@gmx.de> <CA+55aFxZsVxkxifR+EUZi=RsUGKfs5vYXX3nN_M_Az1BY5yyaw@mail.gmail.com> <alpine.LFD.2.02.1203060927190.2742@ionos>
 <alpine.LFD.2.02.1203060957140.2742@ionos> <alpine.LFD.2.02.1203062019340.2742@ionos> <8762eh1p7d.fsf@turtle.gmx.de>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Mar 2012, Sven Joachim wrote:
> Am 06.03.2012 um 20:31 schrieb Thomas Gleixner:
> 
> > Stephan, Sven: Can you please provide the output of /proc/interrupts ?
> 
> Here is mine, from a freshly booted 3.3-rc6 kernel.
> 
> Cheers,
>        Sven
> 
>            CPU0       
>   0:      25050    XT-PIC-XT-PIC    timer
>   1:        101    XT-PIC-XT-PIC    i8042
>   2:          0    XT-PIC-XT-PIC    cascade
>   3:          1    XT-PIC-XT-PIC  
>   4:          1    XT-PIC-XT-PIC  
>   5:          0    XT-PIC-XT-PIC    ehci_hcd:usb1, uhci_hcd:usb2
>   6:          1    XT-PIC-XT-PIC    i915, uhci_hcd:usb5, yenta
>   7:          1    XT-PIC-XT-PIC  
>   8:          0    XT-PIC-XT-PIC    rtc0
>   9:        634    XT-PIC-XT-PIC    acpi
>  10:        341    XT-PIC-XT-PIC    uhci_hcd:usb4, snd_hda_intel, b43

Ah, XT-PIC uses handle_level_irq(). /me bangs head against desk.

Does the patch below fix the problem for you ?

Thanks,

	tglx

----------------->
Subject: genirq: Clear action->thread_mask if IRQ_ONESHOT is not set

commit ac5637611(genirq: Unmask oneshot irqs when thread was not
woken) fails to unmask when a !IRQ_ONESHOT threaded handler is handled
by handle_level_irq. This happens because thread_mask is or'ed
unconditionally in irq_wake_thread(), but for !IRQ_ONESHOT interrupts
never cleared. So the check for !desc->thread_active fails and keeps
the interrupt disabled.

Keep the thread_mask zero for !IRQ_ONESHOT interrupts.

Reported-by: Sven Joachim <svenjoac@gmx.de>
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---

Index: linux-2.6/kernel/irq/manage.c
===================================================================
--- linux-2.6.orig/kernel/irq/manage.c
+++ linux-2.6/kernel/irq/manage.c
@@ -996,11 +996,13 @@ __setup_irq(unsigned int irq, struct irq
 	 * Setup the thread mask for this irqaction. Unlikely to have
 	 * 32 resp 64 irqs sharing one line, but who knows.
 	 */
-	if (new->flags & IRQF_ONESHOT && thread_mask == ~0UL) {
-		ret = -EBUSY;
-		goto out_mask;
+	if (new->flags & IRQF_ONESHOT) {
+		if (thread_mask == ~0UL) {
+			ret = -EBUSY;
+			goto out_mask;
+		}
+		new->thread_mask = new->flags & IRQF_ONESHOT;
 	}
-	new->thread_mask = 1 << ffz(thread_mask);
 
 	if (!shared) {
 		init_waitqueue_head(&desc->wait_for_threads);
