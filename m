Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758884Ab1LONz2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 08:55:28 -0500
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:39075
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751305Ab1LONz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 08:55:27 -0500
X-SpamScore: -4
X-BigFish: VS-4(z1039ozbb2dI9371I1432N98dKzz1202hzz8275bh8275dhz2dh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 13,
Date: Thu, 15 Dec 2011 22:08:28 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Rob Herring <robherring2@gmail.com>
CC: Kevin Hilman <khilman@ti.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Tony Lindgren <tony@atomide.com>,
        Linus Walleij <linus.ml.walleij@gmail.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Barry Song <baohua.song@csr.com>, Thomas Gleixner <tglx@linutronix.de>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 3/9] irq: convert generic-chip to use irq_domain
Message-ID: <20111215140827.GB2963@S2100-06.ap.freescale.net>
References: <1323876538-20406-1-git-send-email-robherring2@gmail.com>
 <1323876538-20406-4-git-send-email-robherring2@gmail.com>
 <20111215052512.GB21815@S2101-09.ap.freescale.net>
 <20111215055501.GC21815@S2101-09.ap.freescale.net>
 <4EE9F899.7010402@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4EE9F899.7010402@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 15, 2011 at 07:39:37AM -0600, Rob Herring wrote:
> On 12/14/2011 11:55 PM, Shawn Guo wrote:
> > On Thu, Dec 15, 2011 at 01:25:20PM +0800, Shawn Guo wrote:
> >> On Wed, Dec 14, 2011 at 09:28:52AM -0600, Rob Herring wrote:
> >>> From: Rob Herring <rob.herring@calxeda.com>
> >>>
> >>> Add irq domain support to irq generic-chip. This enables users of
> >>> generic-chip to support dynamic irq assignment needed for DT interrupt
> >>> binding. Users must be converted to use irq_data.hwirq for determining
> >>> local interrupt numbers rather than using the Linux irq number.
> >>>
> >>> irq_base is kept for now as there are a few users of it. Once they
> >>> are converted to use the irq domain, it can be removed.
> >>>
> >>> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> >>> Cc: Thomas Gleixner <tglx@linutronix.de>
> >>> ---
> >>
> >> Tested-by: Shawn Guo <shawn.guo@linaro.org>
> >>
> > Sorry, I have to take that tag back after I correct my test setup.
> > It does not work for imx5 TZIC case, because the following change
> > I suggested before is missed.
> > 
> > diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
> > index eb763f7..2a2aac1 100644
> > --- a/kernel/irq/irqdomain.c
> > +++ b/kernel/irq/irqdomain.c
> > @@ -39,7 +39,7 @@ void irq_domain_add(struct irq_domain *domain)
> >                         return;
> >                 }
> >                 d->domain = domain;
> > -               d->hwirq = hwirq;
> > +               d->hwirq = hwirq - domain->hwirq_base;
> 
> This is a problem. It entirely defeats the point of hwirq_base and it
> would break the GIC. We need to fix this in the generic irq chip.
> 
Actually I do not quite understand why we need to make the following
change all over generic-chip.c.

-       u32 mask = 1 << (d->irq - gc->irq_base);
+       u32 mask = 1 << d->hwirq;

Though d->irq is the Linux irq number, "d->irq - gc->irq_base" is
really just what we need here.

-- 
Regards,
Shawn

