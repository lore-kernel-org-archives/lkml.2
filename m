Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979Ab0DSNKA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 09:10:00 -0400
Received: from mx1.corp.avencall.com ([91.194.178.12]:32972 "EHLO
	mx1.corp.avencall.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754858Ab0DSNJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 09:09:59 -0400
Date: Mon, 19 Apr 2010 15:09:47 +0200
From: Guillaume Knispel <gknispel@proformatique.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Linuxppc-dev@lists.ozlabs.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>, Lars-Peter Clausen <lars@metafoo.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Michael Buesch <mb@bu3sch.de>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: Pending interrupts not always replayed
Message-ID: <20100419150947.4c2832c3@xilun.lan.proformatique.com>
In-Reply-To: <alpine.LFD.2.00.1004182112280.2972@localhost.localdomain>
References: <20100418053439.4d2ffe11@xilun.lan.proformatique.com>
	<20100418164614.771d4f01@xilun.lan.proformatique.com>
	<alpine.LFD.2.00.1004182112280.2972@localhost.localdomain>
Organization: Proformatique
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Apr 2010 21:14:12 +0200 (CEST)
Thomas Gleixner <tglx@linutronix.de> wrote:

> On Sun, 18 Apr 2010, Guillaume Knispel wrote:
> > Now everything seems to work fine: my device was not previously not
> > interrupting anymore after typically 1 or 2 minutes (because the
> > interrupt signal stays at level low until the device is served, so
> 
> So you are having a level interrupt device and the irq line is handled
> by an edge type handler ? Why not configuring the irq line for level
> and in the first place ?

Not really the problem here, it indeed helped me do discover the real
bug (because I would not have seen that an interrupt went missing if the
device have generated another one all by itself soon after that).

I would of course prefer to have this line in level trigger, but the
pic just can't do it for this signal, so I play with masking and
unmasking interrupts on the device side to regenerate edges when needed.
When interrupts are enabled, I do that in the isr, so if it is not
called after a falling edge it won't be anymore in the future.

What is a real bug IMHO is that when in falling edge trigger mode,
the sequence:
 - disable_irq(),
 - 1 falling edge,
 - enable_irq()
doesn't lead to the isr being called just after enable_irq().

This is because:

* __disable_irq basically do (when really disabling)
	desc->status |= IRQ_DISABLED;
	desc->chip->disable(irq);	<= noop or racy see under

* arch/powerpc/sysdev/cpm2_pic.c does not define a disable() in
  struct irq_chip cpm2_pic. So default_disable is used, and
  it's a noop. For pics where this is not a noop, there can be a race
  if the interrupt triggers before the disable(): the flow handler will
  still be executed just after desc->lock is unlocked in
  disable_irq_nosync(). So it does not really matters whether
  disable() is implemented or is a noop.

* When the flow handler is executed after disable_irq_nosync(),
  handle_edge_irq() does:
	desc->status &= ~(IRQ_REPLAY | IRQ_WAITING);
	desc->status |= (IRQ_PENDING | IRQ_MASKED);
	mask_ack_irq(desc, irq);
  The responsibility of triggering the interrupt has now been
  transferred from the pic to the kernel (the interrupt has been acked
  at pic level), so I would say that if the kernel does not run replay
  it later, it will be a bug.

* When __enable_irq() is called, it does:
	unsigned int status = desc->status & ~IRQ_DISABLED;
	desc->status = status | IRQ_NOPROBE;
	check_irq_resend(desc, irq);

* if it's an edge triggered IRQ (and in my case it is)
  check_irq_resend() sometimes, if the planets are aligned, resend the
  IRQ. Planet alignement is defined by retrigger being provided for the
  irq_chip and retrigger succeed, or CONFIG_HARDIRQS_SW_RESEND is
  defined (in which case and if retrigger is absent or has failed, the
  hardirq is indeed executed in a tasklet -- which might maybe cause
  obscure problems?).

My guess is that CONFIG_HARDIRQS_SW_RESEND was meant to be defined on
any platform where a pic can exist and can do edge trigger but does not
implement retrigger or implements a retrigger that can fail (because
otherwise interrupts can be missed).

This seems to be a quite unknown fact that might have been missed by
multiple irq_chips (and could be missed by more in the future), and I
would propose to just unconditionally build the resend_irqs() tasklet
and its scheduling code, and completely remove
CONFIG_HARDIRQS_SW_RESEND, at least if it is sure that executing a flow
handler in a tasklet can never cause obscure problems.

Cheers!
-- 
Guillaume Knispel
