Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333Ab1HVX0h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 19:26:37 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:42336 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753744Ab1HVX0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 19:26:34 -0400
Date: Mon, 22 Aug 2011 17:26:33 -0600 (MDT)
From: Paul Walmsley <paul@pwsan.com>
To: Pantelis Antoniou <pantelis.antoniou@gmail.com>
cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        torvalds@linux-foundation.org, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        tony@atomide.com, linux-arm-kernel@lists.infradead.org, mporter@ti.com
Subject: Re: [PATCH] irq: always set IRQF_ONESHOT if no primary handler is
 specified
In-Reply-To: <C5991460-2092-4E65-99EE-091F8DAA0AC3@gmail.com>
Message-ID: <alpine.DEB.2.00.1108221723010.10315@utopia.booyaka.com>
References: <1310070737-18514-1-git-send-email-bigeasy@linutronix.de> <C5991460-2092-4E65-99EE-091F8DAA0AC3@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Aug 2011, Pantelis Antoniou wrote:

> Let me report that with this change Beagle board fails to boot,
> hangs right on rootfs mount.

Confirmed here.

Commit f3637a5f2e2eb391ff5757bc83fb5de8f9726464 ("irq: Always set 
IRQF_ONESHOT if no primary handler is specified"), merged as part of 
v3.1-rc3, won't boot into userspace via MMC on either OMAP4 Panda or 
OMAP3530 BeagleBoard.  v3.1-rc2 works.


- Paul

> Users of BB should revert this until the offending driver(s) are fixed.
> 
> Regards
> 
> -- Pantelis
> 
> On Jul 7, 2011, at 11:32 PM, Sebastian Andrzej Siewior wrote:
> 
> > If no primary handler is specified then a default one is assigned which
> > always returns IRQ_WAKE_THREAD. This handler requires the IRQF_ONESHOT
> > flag on LEVEL / EIO typed irqs because the source of interrupt is not
> > disabled.
> > Since it is required for those users and there is no difference for others
> > it makes sense to add this flag unconditionally.
> > 
> > Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> > ---
> > A quick grep shows that drivers/staging/iio/adc/ad7816.c is the only
> > driver in tree doing it wrong i.e. request_threaded_irq with
> > IRQF_TRIGGER_{LOW|HIGH} but without ONEHOST.
> > 
> > There are 59 users in tree which request an edge typed interrupt. 24 of
> > them specify the ONEHOST flag the others don't. Both variants are valid
> > and identical but a consistent behavior would be nice.
> > 
> > There is a total of 134 users and 87 specify the irq type directly. For
> > the remaining 47 the type depends on initial configuration of the irq chip
> > or it might be specified via the device tree, dunno. 
> > Should that patch be accepted I suggest to remove the ONESHOT flag from
> > every request_th.* which uses NULL as the primary handler so we have a
> > consistent behavior here.
> > 
> > kernel/irq/manage.c |    1 +
> > 1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
> > index 0a7840ae..3f9cd47 100644
> > --- a/kernel/irq/manage.c
> > +++ b/kernel/irq/manage.c
> > @@ -1322,6 +1322,7 @@ int request_threaded_irq(unsigned int irq, irq_handler_t handler,
> > 		if (!thread_fn)
> > 			return -EINVAL;
> > 		handler = irq_default_primary_handler;
> > +		irqflags |= IRQF_ONESHOT;
> > 	}
> > 
> > 	action = kzalloc(sizeof(struct irqaction), GFP_KERNEL);
> > -- 
> > 1.7.4.4
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
