Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760639Ab2D0S4w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 14:56:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36002 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754820Ab2D0S4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 14:56:50 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] irqdomain: print a warning if domains contain IRQ 0
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <CACRpkdYpPLNnuivcN9CsG6ZHsZ7=AOkYv9OSGjfiLFi1ouh03g@mail.gmail.com>
References: <1334756420-12019-1-git-send-email-linus.walleij@stericsson.com> <1334787792.3143.19.camel@pasglop> <20120419182917.2F64E3E0700@localhost> <CACRpkdYpPLNnuivcN9CsG6ZHsZ7=AOkYv9OSGjfiLFi1ouh03g@mail.gmail.com>
Date: Fri, 27 Apr 2012 12:56:48 -0600
Message-Id: <20120427185648.47F393E0B4D@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Apr 2012 08:38:05 +0200, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Thu, Apr 19, 2012 at 8:29 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> 
> > This is indeed specific to the legacy domain.  I think the patch is
> > good and it will help weed out unintended irq0 users.  However, it
> > requires the following additional fix I think.  It will need to be
> > tested to make sure it doesn't break PowerPC ISA users.
> >
> > g.
> >
> > diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
> > index d0995bd..31f1f88 100644
> > --- a/include/linux/irqdomain.h
> > +++ b/include/linux/irqdomain.h
> > @@ -138,7 +138,7 @@ static inline struct irq_domain *irq_domain_add_legacy_isa(
> >                                const struct irq_domain_ops *ops,
> >                                void *host_data)
> >  {
> > -       return irq_domain_add_legacy(of_node, NUM_ISA_INTERRUPTS, 0, 0, ops,
> > +       return irq_domain_add_legacy(of_node, NUM_ISA_INTERRUPTS-1, 1, 1, ops,
> >                                     host_data);
> 
> Hm, so what does this do? If I fold it into my patch I need some
> kind of blurb...
> 
> I'm guessing it bumps the ISA IRQs with one to avoid using IRQ0 which
> seems like a valid patch on its own, and that the old code was
> used for actively ignoring IRQ 0 on ISA (not used or whatever)?

Yes, that is exactly what it does.  The fact that 0 is allowed but
never used is an artifact of how this code used to be only for ISA and
both irq and hwirq base numbers were hard coded to 0 for that.

The reworked legacy domain allowed both irq base and hwirq base to be
non-zero, but the check for 0 code remained.

g.

