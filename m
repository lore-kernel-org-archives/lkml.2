Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218Ab0JOGUr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 02:20:47 -0400
Received: from smtp.nokia.com ([192.100.122.230]:38843 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232Ab0JOGUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 02:20:45 -0400
Subject: RE: [PATCHv2 1/1] omap: Ptr "isr_reg" tracked as NULL was
 dereferenced
From: Evgeny Kuznetsov <EXT-Eugeny.Kuznetsov@nokia.com>
To: "tony@atomide.com" <tony@atomide.com>,
        "ext Varadarajan, Charulatha" <charu@ti.com>
Cc: linux-omap@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Balbi, Felipe" <balbi@ti.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "khilman@deeprootsystems.com" <khilman@deeprootsystems.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "tero.kristo@nokia.com" <tero.kristo@nokia.com>
In-Reply-To: <1286971758.12782.35.camel@ekuznets-lx-nokia>
References: <cover.1286961160.git.EXT-Eugeny.Kuznetsov@nokia.com>
	 <7bb69801f49283c3bde78aa008c15308ac8a5fbf.1286961160.git.EXT-Eugeny.Kuznetsov@nokia.com>
	 <EAF47CD23C76F840A9E7FCE10091EFAB030D099AFD@dbde02.ent.ti.com>
	 <1286970199.12782.28.camel@ekuznets-lx-nokia>
	 <EAF47CD23C76F840A9E7FCE10091EFAB030D099B87@dbde02.ent.ti.com>
	 <1286971758.12782.35.camel@ekuznets-lx-nokia>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Oct 2010 10:16:18 +0400
Message-ID: <1287123378.12782.49.camel@ekuznets-lx-nokia>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Oct 2010 06:20:03.0672 (UTC) FILETIME=[01087580:01CB6C31]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-13 at 16:09 +0400, Evgeny Kuznetsov wrote:
> On Wed, 2010-10-13 at 17:20 +0530, ext Varadarajan, Charulatha wrote:
> > 
> > <<snip>>
> > 
> > > > >
> > > > > From: Evgeny Kuznetsov <ext-eugeny.kuznetsov@nokia.com>
> > > > >
> > > > > Value of "isr_reg" pointer is depend on configuration and GPIO method.
> > > > > Potentially it may have NULL value and it is dereferenced later
> > > > > in code. If pointer is NULL there is some kernel issue.
> > > >
> > > > Can you elaborate?
> > > "isr_reg" should not be NULL. But if it is NULL then there is kernel
> > > bug. And WARN_ON() used to show it.
> > > I did not see this bug, this is potentially may happen.
> > > >
> > > > > Warning and exit from function are added in this case.
> > > > > Also compilation check is added for correct architecture
> > > > > configuration.
> > > > >
> > > > > Signed-off-by: Evgeny Kuznetsov <EXT-Eugeny.Kuznetsov@nokia.com>
> > > > > ---
> > > > >  arch/arm/plat-omap/gpio.c |   18 ++++++++++++++++++
> > > > >  1 files changed, 18 insertions(+), 0 deletions(-)
> > > > >
> > > > > diff --git a/arch/arm/plat-omap/gpio.c b/arch/arm/plat-omap/gpio.c
> > > > > index c05c653..d04913c 100644
> > > > > --- a/arch/arm/plat-omap/gpio.c
> > > > > +++ b/arch/arm/plat-omap/gpio.c
> > > > > @@ -1318,6 +1318,23 @@ static void gpio_irq_handler(unsigned int irq,
> > > > > struct irq_desc *desc)
> > > > >  	if (bank->method == METHOD_GPIO_44XX)
> > > > >  		isr_reg = bank->base + OMAP4_GPIO_IRQSTATUS0;
> > > > >  #endif
> > > > > +
> > > > > +#if !defined(CONFIG_ARCH_OMAP1) &&		\
> > > > > +		!defined(CONFIG_ARCH_OMAP15XX) &&	\
> > > > > +		!defined(CONFIG_ARCH_OMAP16XX) &&	\
> > > > > +		!defined(CONFIG_ARCH_OMAP730) &&	\
> > > > > +		!defined(CONFIG_ARCH_OMAP850) &&	\
> > > > > +		!defined(CONFIG_ARCH_OMAP2) &&	\
> > > > > +		!defined(CONFIG_ARCH_OMAP3) &&	\
> > > > > +		!defined(CONFIG_ARCH_OMAP4)
> > > > > +
> > > > > +#error "Incorrect arch configuration"
> > > >
> > > > This is not required. If the architecture is not one of the above
> > > > mentioned, gpio_irq_handler() will not be used/called at all.
> > > This could be removed.
> > > 
> > > > Also all the possible gpio methods for a given OMAP architecture are
> > > > already considered with "#ifdef"s and (bank->method) checks in
> > > > gpio_irq_handler().
> > > It is not cover all cased, e.g. for OMAP4 arch:
> > > ....
> > > 	#if defined(CONFIG_ARCH_OMAP4)
> > > 		if (bank->method == METHOD_GPIO_44XX)
> > > 			isr_reg = bank->base + OMAP4_GPIO_IRQSTATUS0;
> > > 	#endif
> > > .....
> > > 
> > > If (bank->method != METHOD_GPIO_44XX) then isr_reg will be NULL.
> > > This should not happen, but potentially may have place.
> > 
> > When would it fail? If it is CONFIG_ARCH_OMAP4, the gpio method can
> > only be METHOD_GPIO_44XX. Else if it is for some other OMAP architecture,
> > the gpio_method is similarly taken care. So this cannot happen.
> This is similar check as e.g. in _enable_gpio_irqbank() there default
> case for bank->methos switch is WARN_ON(1).
> Just to warn in case.
Hi Tony,

It is not a bug fix, it is just check to prevent potential issues. Used
to warn in case of bug and prevent kernel oops. Check added only here
(not all gpio code cleanup) since here it could cause kernel opps.

Would you apply patch if I will leave only if condition section in
patch?

	if (WARN_ON(!isr_reg))
		goto exit;

If yes, I'll resend v3 patch.

Thanks,
Regards,
Evgeny

> > 
> > > 
> > > >
> > > > > +
> > > > > +#endif
> > > > > +
> > > > > +	if (WARN_ON(!isr_reg))
> > > > > +		goto exit;
> > > >
> > > > For the above mentioned reason, this isr_reg would be non-NULL. Have
> > > > you observed this error anytime?
> > > I did not see this bug, this is potentially may happen.
> > > >
> > > > Also, the omap-gpio code has similar code spread all over and has to be
> > > > anyway cleaned-up. Is there any reason why gpio_irq_handler() alone is
> > > > addressed in this patch?
> > > Here "isr_reg" is used later in code and may cause oops if it is NULL.
> > > >
> > > > > +
> > > > >  	while(1) {
> > > > >  		u32 isr_saved, level_mask = 0;
> > > > >  		u32 enabled;
> > > > > @@ -1377,6 +1394,7 @@ static void gpio_irq_handler(unsigned int irq,
> > > > > struct irq_desc *desc)
> > > > >  	configured, we must unmask the bank interrupt only after
> > > > >  	handler(s) are executed in order to avoid spurious bank
> > > > >  	interrupt */
> > > > > +exit:
> > > > >  	if (!unmasked)
> > > > >  		desc->chip->unmask(irq);
> > > > >
> > > > > --
> > > > > 1.6.3.3
> > > >
> > > 
> > 
> 


