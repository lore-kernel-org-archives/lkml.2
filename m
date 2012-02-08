Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751783Ab2BHGFM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 01:05:12 -0500
Received: from mail.karo-electronics.de ([81.173.242.67]:53473 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107Ab2BHGFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 01:05:11 -0500
Message-ID: <20274.4237.63380.338503@ipc1.ka-ro>
Date: Wed, 8 Feb 2012 07:05:01 +0100
From: =?utf-8?Q?Lothar_Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Yong Zhang <yong.zhang0@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] genirq: Fix race condition in ONESHOT irq handler
In-Reply-To: <alpine.LFD.2.02.1202071719340.2794@ionos>
References: <4F31220A.2050708@metafoo.de>
	<1328621921-17404-1-git-send-email-LW@KARO-electronics.de>
	<alpine.LFD.2.02.1202071719340.2794@ionos>
X-Mailer: VM 8.1.0 under 23.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thomas Gleixner writes:
> On Tue, 7 Feb 2012, Lothar Waßmann wrote:
> 
> > There is a race condition in the threaded IRQ handler code for oneshot
> > interrupts that may lead to disabling an IRQ indefinitely. IRQs are
> > masked before calling the hard-irq handler and are unmasked only after
> > the soft-irq handler has been run. Thus if the hard-irq handler
> > returns IRQ_HANDLED instead of IRQ_WAKE_THREAD, meaning the soft-irq
> 
> Well, oneshot mode interrupts always had the semantics that the
> threaded handler needs to run unconditionally. In fact the oneshot
> mode was implemented to handle hardware which cannot do anything in
> hard interrupt context to avoid the ugliness of a primary handler
> calling disable_irq_nosync().
> 
> So it looks like driver developers decided that the oneshot mode might
> be interesting with a primary handler as well. I can see the reason
> why the tsc2007 driver uses it, but that does not make it a bug in the
> core code in the first place.
> 
Then maybe the core code should not check the return value
of the primary handler for IRQ_WAKE_THREAD but call the secondary
handler unconditionally for ONESHOT interrupts.
Or it should be at least documented somewhere that primary handlers
have to return IRQ_WAKE_THREAD in any case for oneshot interrupts.

> > The problem arises also with interrupt controllers that latch a level
> > triggered IRQ until it is acknowledged (like the i.MX28 does).
> > In this case the IRQ status bit will remain asserted after the
> > soft-irq finishes and retrigger the interrupt while the interrupt line
> > is already deasserted.
> 
> This does not make sense. We acknowledge interrupts via mask_ack_irq()
> right on entry of handle_level_irq(). So either the interrupt
> 
That's right. But at that point the IRQ line is still asserted and
since it is a level IRQ this will not actually clear the interrupt
status bit. Normally the IRQ status bit would self-clear when the IRQ
line is being deasserted (in this case by removing the finger from the
touch panel). But the i.MX28 leaves the IRQ status bit set and it
takes another write to the IRQ status register to remove the bogus IRQ
status.

> controller is completely hosed or this explanation is bogus.
>
The first is the case.


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
