Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104Ab2HMNqn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 09:46:43 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59953 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750963Ab2HMNqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 09:46:42 -0400
Date: Mon, 13 Aug 2012 14:46:39 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Anthony Olech <anthony.olech.opensource@diasemi.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        LKML <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Subject: Re: [NEW DRIVER V2 5/7] DA9058 GPIO driver
Message-ID: <20120813134638.GF13446@opensource.wolfsonmicro.com>
References: <201208060738.q767ci5c005713@ubuntu>
 <CACRpkdYLMRCuZoKPhEwyyoPonUY-mgLOxDvmnoCmCbCxiGHwcA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdYLMRCuZoKPhEwyyoPonUY-mgLOxDvmnoCmCbCxiGHwcA@mail.gmail.com>
X-Cookie: Blow it out your ear.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2012 at 03:09:31PM +0200, Linus Walleij wrote:
> On Sun, Aug 5, 2012 at 10:43 PM, Anthony Olech

> > +#include <linux/regmap.h>

> If you're using regmap you better select it in Kconfig
> too, but it appears you don't. You should be using regmap in the
> main MFD driver in this case (I haven't looked at it though.)

For MFDs the MFD core should already be ensuring that regmap is
selected.

> > +               gpio_cntrl |= 0x0F & gpio->out_config;

> > +               ret = da9058_reg_write(da9058, DA9058_GPIO0001_REG, gpio_cntrl);

> Further, if you're checking that flag just in order to avoid doing this
> write if it's not necessary, it's the wrong solution. The right solution
> is to implement regmap in the MFD driver so it quickly sees that
> the right value is already in the register and bounces off.

Just using regmap_update_bits() will do the right thing.

> > +       if (offset)
> > +               return da9058_to_virt_irq_num(da9058, DA9058_IRQ_EGPI1);
> > +       else
> > +               return da9058_to_virt_irq_num(da9058, DA9058_IRQ_EGPI0);
> > +}

> Lee Jones and Mark Brown discussed these virtual IRQ mapping functions
> recently, and I think the outcome was to patch irqdomain to do the work
> and not sprinkle these custom interfaces to fetch virtual IRQs all over the
> place.

The easiest thing to do would be to pick the VIRQ numbers so that you
can just do

	da9058_to_virt_irq_num(da9058, DA9058_IRQ_EGPI0 + offset);
