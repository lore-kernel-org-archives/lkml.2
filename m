Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756607Ab2BHKiV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 05:38:21 -0500
Received: from www.linutronix.de ([62.245.132.108]:58709 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755241Ab2BHKiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 05:38:20 -0500
Date: Wed, 8 Feb 2012 11:38:18 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: =?ISO-8859-15?Q?Lothar_Wa=DFmann?= <LW@KARO-electronics.de>
cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Yong Zhang <yong.zhang0@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] genirq: Fix race condition in ONESHOT irq handler
In-Reply-To: <20274.4237.63380.338503@ipc1.ka-ro>
Message-ID: <alpine.LFD.2.02.1202081123390.2794@ionos>
References: <4F31220A.2050708@metafoo.de> <1328621921-17404-1-git-send-email-LW@KARO-electronics.de> <alpine.LFD.2.02.1202071719340.2794@ionos> <20274.4237.63380.338503@ipc1.ka-ro>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-727454016-1328697499=:2794"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-727454016-1328697499=:2794
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Wed, 8 Feb 2012, Lothar Waßmann wrote:
> > So it looks like driver developers decided that the oneshot mode might
> > be interesting with a primary handler as well. I can see the reason
> > why the tsc2007 driver uses it, but that does not make it a bug in the
> > core code in the first place.
> > 
> Then maybe the core code should not check the return value
> of the primary handler for IRQ_WAKE_THREAD but call the secondary
> handler unconditionally for ONESHOT interrupts.
> Or it should be at least documented somewhere that primary handlers
> have to return IRQ_WAKE_THREAD in any case for oneshot interrupts.

Well, you know how good we are with documentation :)
 
> > > The problem arises also with interrupt controllers that latch a level
> > > triggered IRQ until it is acknowledged (like the i.MX28 does).
> > > In this case the IRQ status bit will remain asserted after the
> > > soft-irq finishes and retrigger the interrupt while the interrupt line
> > > is already deasserted.
> > 
> > This does not make sense. We acknowledge interrupts via mask_ack_irq()
> > right on entry of handle_level_irq(). So either the interrupt
> > 
> That's right. But at that point the IRQ line is still asserted and
> since it is a level IRQ this will not actually clear the interrupt
> status bit. Normally the IRQ status bit would self-clear when the IRQ
> line is being deasserted (in this case by removing the finger from the
> touch panel). But the i.MX28 leaves the IRQ status bit set and it
> takes another write to the IRQ status register to remove the bogus IRQ
> status.

So the question is whether the imx irq chip implementation should
write to the status register on unmask for level type irqs to avoid
spurious interrupts being generated in the first place. This is not
only an optimization for threaded interrupts, afaict this spurious
effect should happen with non threaded interrupts as well.

Did my patch work for you ?

Thanks,

	tglx
--8323328-727454016-1328697499=:2794--
