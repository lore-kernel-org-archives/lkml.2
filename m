Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235Ab1IBPuf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 11:50:35 -0400
Received: from www.linutronix.de ([62.245.132.108]:35554 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179Ab1IBPud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 11:50:33 -0400
Date: Fri, 2 Sep 2011 17:50:21 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Stephen Warren <swarren@nvidia.com>
cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Chris Ball <cjb@laptop.org>,
        "ccross@android.com" <ccross@android.com>,
        "olof@lixom.net" <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: RE: [PATCH 1/3] irq: If an IRQ is a GPIO, request and configure it
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF04B327A55C@HQMAIL01.nvidia.com>
Message-ID: <alpine.LFD.2.02.1109021731141.2723@ionos>
References: <1312498820-2275-1-git-send-email-swarren@nvidia.com> <1312498820-2275-2-git-send-email-swarren@nvidia.com> <alpine.LFD.2.02.1109021027360.2723@ionos> <74CDBE0F657A3D45AFBB94109FB122FF04B327A55C@HQMAIL01.nvidia.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Sep 2011, Stephen Warren wrote:

> Thomas Gleixner wrote at Friday, September 02, 2011 2:37 AM:
> > On Thu, 4 Aug 2011, Stephen Warren wrote:
> > 
> > > Many IRQs are associated with GPIO pins. When the pin is used as an IRQ,
> > > it can't be used as anything else; it should be requested. Enhance the
> > > core interrupt code to call gpio_request() and gpio_direction_input() for
> > > any IRQ that is also a GPIO. This prevents duplication of these calls in
> > > each driver that uses an IRQ.
> > 
> > This is very much the wrong approach. If you think it through then the
> > irq setup code might end up with tons of other subsystem specific
> > setup thingies, e.g. PCI .....
> > 
> > The right thing to do is to add a irq_configure() function pointer to
> > the irq chip and provide a common function for gpios in gpiolib, which
> > is then used by the particular GPIO irq chip implementation.
> 
> Sorry, could you expand on this some more.
> 
> The whole point of these patches is that it's impossible to convert from
> IRQ number to GPIO number.
> 
> Some drivers use just an IRQ, and don't care if it's a GPIO. They work
> fine currently.
> 
> Some drivers use just a GPIO; that's not relevant to these patches.
> 
> Some drivers use something that's both an IRQ and a GPIO. Historically,
> this has worked by passing the IRQ to the driver, and then the driver
> calling irq_to_gpio() to get the GPIO ID. Since irq_to_gpio() is being
> removed, this is no longer possible. The whole point of the removal was
> that it's not possible in general to convert from IRQ to GPIO, so I'm not
> sure exactly what you're proposing irq_configure() or gpiolib do to
> centralize this?

chip->irq_configure() calls a irqchip function if set. So now the code
which implements the irq functionality for GPIO definitely knows how
to map the irq number to the GPIO pin, otherwise it would not be able
to handle the mask/ack/unmask function either.

The drivers which just request an irq are oblivious about that:

request_irq(irq)

	if (chip->irq_configure)
	   chip->irq_configure()
		configure_gpio_pin()

Whether configure_gpio_pin() is a function which is implemented per
GPIO driver or a common function in gpiolib is not relevant for the
irq core code.

Thanks,

	tglx
