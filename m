Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143Ab2DSS3V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 14:29:21 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40202 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754454Ab2DSS3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 14:29:20 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] irqdomain: print a warning if domains contain IRQ 0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
In-Reply-To: <1334787792.3143.19.camel@pasglop>
References: <1334756420-12019-1-git-send-email-linus.walleij@stericsson.com> <1334787792.3143.19.camel@pasglop>
Date: Thu, 19 Apr 2012 12:29:17 -0600
Message-Id: <20120419182917.2F64E3E0700@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Apr 2012 08:23:12 +1000, Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> On Wed, 2012-04-18 at 15:40 +0200, Linus Walleij wrote:
> > From: Linus Walleij <linus.walleij@linaro.org>
> > 
> > Some of the clients using IRQ domains from the ARM VIC
> > (arch/arm/common/vic.c) don't know that their (hardware) IRQ 0
> > is silently ignored by the IRQ core, they will just notice
> > that they're not getting this IRQ anymore. So print a warning
> > if a domain contains IRQ 0 (NO_IRQ) so we get some noise about
> > it atleast.
> 
> I don't understand. HW IRQ 0 is not ignored and works perfectly
> fine on "normal" remapped domains. Or is this specific to "legacy
> domains" ? In this case pls make it clear in the subject :-)

This is indeed specific to the legacy domain.  I think the patch is
good and it will help weed out unintended irq0 users.  However, it
requires the following additional fix I think.  It will need to be
tested to make sure it doesn't break PowerPC ISA users.

g.

diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
index d0995bd..31f1f88 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -138,7 +138,7 @@ static inline struct irq_domain *irq_domain_add_legacy_isa(
 				const struct irq_domain_ops *ops,
 				void *host_data)
 {
-	return irq_domain_add_legacy(of_node, NUM_ISA_INTERRUPTS, 0, 0, ops,
+	return irq_domain_add_legacy(of_node, NUM_ISA_INTERRUPTS-1, 1, 1, ops,
 				     host_data);
 }
 extern struct irq_domain *irq_find_host(struct device_node *node);


> > ---
> >  kernel/irq/irqdomain.c |    4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
> > index 0e0ba5f..1444454 100644
> > --- a/kernel/irq/irqdomain.c
> > +++ b/kernel/irq/irqdomain.c
> > @@ -136,8 +136,10 @@ struct irq_domain *irq_domain_add_legacy(struct device_node *of_node,
> >  		int hwirq = first_hwirq + i;
> >  
> >  		/* IRQ0 gets ignored */
> > -		if (!irq)
> > +		if (!irq) {
> > +			pr_warn("trying to register IRQ 0 (NO_IRQ) in an irq  domain\n");
> >  			continue;
> > +		}
> >  
> >  		/* Legacy flags are left to default at this point,
> >  		 * one can then use irq_create_mapping() to
> 
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies,Ltd.
