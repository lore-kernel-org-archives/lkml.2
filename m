Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809Ab0JMK4L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 06:56:11 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:42432 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937Ab0JMK4J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 06:56:09 -0400
From: "Varadarajan, Charulatha" <charu@ti.com>
To: Evgeny Kuznetsov <EXT-Eugeny.Kuznetsov@nokia.com>,
        "tony@atomide.com" <tony@atomide.com>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Balbi, Felipe" <balbi@ti.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "khilman@deeprootsystems.com" <khilman@deeprootsystems.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "tero.kristo@nokia.com" <tero.kristo@nokia.com>
Date: Wed, 13 Oct 2010 16:25:08 +0530
Subject: RE: [PATCHv2 1/1] omap: Ptr "isr_reg" tracked as NULL was
 dereferenced
Thread-Topic: [PATCHv2 1/1] omap: Ptr "isr_reg" tracked as NULL was
 dereferenced
Thread-Index: Actqvq9qrgwB1wrKSFO45k3ZlFCZPgAAdlRw
Message-ID: <EAF47CD23C76F840A9E7FCE10091EFAB030D099AFD@dbde02.ent.ti.com>
References: <cover.1286961160.git.EXT-Eugeny.Kuznetsov@nokia.com>
 <7bb69801f49283c3bde78aa008c15308ac8a5fbf.1286961160.git.EXT-Eugeny.Kuznetsov@nokia.com>
In-Reply-To: <7bb69801f49283c3bde78aa008c15308ac8a5fbf.1286961160.git.EXT-Eugeny.Kuznetsov@nokia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Evgeny Kuznetsov [mailto:EXT-Eugeny.Kuznetsov@nokia.com]
> Sent: Wednesday, October 13, 2010 3:35 PM
> To: tony@atomide.com
> Cc: linux-omap@vger.kernel.org; linux-kernel@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; Balbi, Felipe; linux@arm.linux.org.uk;
> khilman@deeprootsystems.com; akpm@linux-foundation.org; Varadarajan,
> Charulatha; tero.kristo@nokia.com; ext-eugeny.kuznetsov@nokia.com
> Subject: [PATCHv2 1/1] omap: Ptr "isr_reg" tracked as NULL was
> dereferenced
> 
> From: Evgeny Kuznetsov <ext-eugeny.kuznetsov@nokia.com>
> 
> Value of "isr_reg" pointer is depend on configuration and GPIO method.
> Potentially it may have NULL value and it is dereferenced later
> in code. If pointer is NULL there is some kernel issue.

Can you elaborate?

> Warning and exit from function are added in this case.
> Also compilation check is added for correct architecture
> configuration.
> 
> Signed-off-by: Evgeny Kuznetsov <EXT-Eugeny.Kuznetsov@nokia.com>
> ---
>  arch/arm/plat-omap/gpio.c |   18 ++++++++++++++++++
>  1 files changed, 18 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/plat-omap/gpio.c b/arch/arm/plat-omap/gpio.c
> index c05c653..d04913c 100644
> --- a/arch/arm/plat-omap/gpio.c
> +++ b/arch/arm/plat-omap/gpio.c
> @@ -1318,6 +1318,23 @@ static void gpio_irq_handler(unsigned int irq,
> struct irq_desc *desc)
>  	if (bank->method == METHOD_GPIO_44XX)
>  		isr_reg = bank->base + OMAP4_GPIO_IRQSTATUS0;
>  #endif
> +
> +#if !defined(CONFIG_ARCH_OMAP1) &&		\
> +		!defined(CONFIG_ARCH_OMAP15XX) &&	\
> +		!defined(CONFIG_ARCH_OMAP16XX) &&	\
> +		!defined(CONFIG_ARCH_OMAP730) &&	\
> +		!defined(CONFIG_ARCH_OMAP850) &&	\
> +		!defined(CONFIG_ARCH_OMAP2) &&	\
> +		!defined(CONFIG_ARCH_OMAP3) &&	\
> +		!defined(CONFIG_ARCH_OMAP4)
> +
> +#error "Incorrect arch configuration"

This is not required. If the architecture is not one of the above
mentioned, gpio_irq_handler() will not be used/called at all.

Also all the possible gpio methods for a given OMAP architecture are
already considered with "#ifdef"s and (bank->method) checks in
gpio_irq_handler().

> +
> +#endif
> +
> +	if (WARN_ON(!isr_reg))
> +		goto exit;

For the above mentioned reason, this isr_reg would be non-NULL. Have
you observed this error anytime?

Also, the omap-gpio code has similar code spread all over and has to be
anyway cleaned-up. Is there any reason why gpio_irq_handler() alone is
addressed in this patch?

> +
>  	while(1) {
>  		u32 isr_saved, level_mask = 0;
>  		u32 enabled;
> @@ -1377,6 +1394,7 @@ static void gpio_irq_handler(unsigned int irq,
> struct irq_desc *desc)
>  	configured, we must unmask the bank interrupt only after
>  	handler(s) are executed in order to avoid spurious bank
>  	interrupt */
> +exit:
>  	if (!unmasked)
>  		desc->chip->unmask(irq);
> 
> --
> 1.6.3.3

