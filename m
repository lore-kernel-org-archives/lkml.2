Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752006Ab1HEEF4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 00:05:56 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16506 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751Ab1HEEFZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 00:05:25 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 04 Aug 2011 21:05:04 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Rob Herring <robherring2@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Chris Ball <cjb@laptop.org>,
        "ccross@android.com" <ccross@android.com>,
        "olof@lixom.net" <olof@lixom.net>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Thu, 4 Aug 2011 21:05:01 -0700
Subject: RE: [PATCH 1/3] irq: If an IRQ is a GPIO, request and configure it
Thread-Topic: [PATCH 1/3] irq: If an IRQ is a GPIO, request and configure it
Thread-Index: AcxTErH7HPFMaqSZQT+jIGPrwaKXJAAEVLnA
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF049F171EC4@HQMAIL01.nvidia.com>
References: <1312498820-2275-1-git-send-email-swarren@nvidia.com>
 <1312498820-2275-2-git-send-email-swarren@nvidia.com>
 <4E3B4D73.9030505@gmail.com>
In-Reply-To: <4E3B4D73.9030505@gmail.com>
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

Rob Herring wrote at Thursday, August 04, 2011 7:55 PM:
> On 08/04/2011 06:00 PM, Stephen Warren wrote:
> > Many IRQs are associated with GPIO pins. When the pin is used as an IRQ,
> > it can't be used as anything else; it should be requested. Enhance the
> > core interrupt code to call gpio_request() and gpio_direction_input() for
> > any IRQ that is also a GPIO. This prevents duplication of these calls in
> > each driver that uses an IRQ.
...
> > diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
...
> > @@ -978,6 +979,16 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
> >  			old = *old_ptr;
> >  		} while (old);
> >  		shared = 1;
> > +	} else {
> > +		gpio = irq_to_gpio(irq);
> 
> If you read the documentation for gpio, it is not recommended to use
> irq_to_gpio. There's only a handful of users. Part of the problem is it
> is platform specific and the gpio core cannot convert irq to gpio
> number

It seems like that's a soluble problem though?

I was thinking about adding a to_gpio function to struct irq_chip, as
the inverse of struct gpio_chip's to_irq. Then, presumably any platform
would be able to convert back from IRQ to GPIO, provided the platform
called a new __irq_to_gpio from the platform-specific gpio_to_irq, just
like most gpio_to_irq implementations defer to __gpio_to_irq.

I ended up not doing that in this patchset, since Tegra's gpio_to_irq
function already works for the IRQs/GPIOs that were relevant for my
testing, and I wanted to post a simple patch first to driver discussion.

> Here is the relevant section:
> 
> Non-error values returned from irq_to_gpio() would most commonly be used
> with gpio_get_value(), for example to initialize or update driver state
> when the IRQ is edge-triggered.  Note that some platforms don't support
> this reverse mapping, so you should avoid using it.

-- 
nvpublic

