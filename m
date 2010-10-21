Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151Ab0JUTqN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 15:46:13 -0400
Received: from www.tglx.de ([62.245.132.106]:50860 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750875Ab0JUTqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 15:46:12 -0400
Date: Thu, 21 Oct 2010 21:45:35 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Richard Weinberger <richard@nod.at>
cc: peterz@infradead.org, hpa@zytor.com, mingo@elte.hu,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-next@vger.kernel.org
Subject: Re: linux-next: User Mode Linux broken
In-Reply-To: <201010212122.38437.richard@nod.at>
Message-ID: <alpine.LFD.2.00.1010212143300.3467@localhost6.localdomain6>
References: <201010211315.26679.richard@nod.at> <alpine.LFD.2.00.1010211805040.2418@localhost6.localdomain6> <201010212122.38437.richard@nod.at>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Oct 2010, Richard Weinberger wrote:
> Am Donnerstag 21 Oktober 2010, 18:09:22 schrieb Thomas Gleixner:
> > On Thu, 21 Oct 2010, Richard Weinberger wrote:
> > > Thomas,
> > > 
> > > Your commit c5f7563 ("genirq: Provide compat handling for
> > > chip->enable()") breaks UML.
> > > It does not start anymore.
> > > 
> > > When I apply this patch it works fine again.
> > > http://userweb.kernel.org/~akpm/mmotm/broken-out/um-migrate-from-__do_irq
> > > -to- generic_handle_irq.patch
> > > 
> > > Maybe your patch breaks all users of __do_IRQ()?
> > 
> > Not intentionally :)
> > 
> > The irq_chip of um has it's own dummy enable function, so the compat
> > code uses it.
> > 
> > +static void compat_irq_enable(struct irq_data *data)
> > +{
> > +	data->chip->enable(data->irq);
> > +}
> > +
> > 
> > ...
> > 
> > +	if (chip->enable)
> > +		chip->irq_enable = compat_irq_enable;
> > +
> > +	/*
> > +	 * The real defaults
> > +	 */
> > +	if (!chip->irq_enable)
> > +		chip->irq_enable = default_enable;
> > 
> > So I really can't see how's that supposed to break UM
> > 
> 
> This patch solves the issue for me.
> What do you think?
> 
> Thanks,
> //richard
> 
> diff --git a/kernel/irq/resend.c b/kernel/irq/resend.c
> index 891115a..1fb4012 100644
> --- a/kernel/irq/resend.c
> +++ b/kernel/irq/resend.c
> @@ -60,8 +60,11 @@ void check_irq_resend(struct irq_desc *desc, unsigned int 
> irq)
>         /*
>          * Make sure the interrupt is enabled, before resending it:
>          */
> +#ifndef CONFIG_GENERIC_HARDIRQS_NO_DEPRECATED
> +       desc->irq_data.chip->enable(irq);
> +#elif
>         desc->irq_data.chip->irq_enable(&desc->irq_data);
> -
> +#endif
>         /*
>          * We do not resend level type interrupts. Level type
>          * interrupts are resent by hardware when they are still

Why shold it solve it ? irq_enable is set to compat_irq_enable which
in turn calls chip->enable.

So how's that different ?

Thanks,

	tglx
