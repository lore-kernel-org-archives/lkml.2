Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087Ab2LKQwW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 11:52:22 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:62275 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753647Ab2LKQwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 11:52:21 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 1/1] gpio: add Lynxpoint chipset gpio driver.
To: Mathias Nyman <mathias.nyman@linux.intel.com>
Cc: linus.walleij@linaro.org, mika.westerberg@linux.intel.com,
        rafael.j.wysocki@intel.com, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
In-Reply-To: <50C71BC3.2090006@linux.intel.com>
References: <1354888899-21907-1-git-send-email-mathias.nyman@linux.intel.com> <1354888899-21907-2-git-send-email-mathias.nyman@linux.intel.com> <20121210230749.7820F3E081F@localhost> <50C71BC3.2090006@linux.intel.com>
Date: Tue, 11 Dec 2012 16:52:07 +0000
Message-Id: <20121211165207.C30423E0C3E@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Dec 2012 13:40:51 +0200, Mathias Nyman <mathias.nyman@linux.intel.com> wrote:
> On 12/11/2012 01:07 AM, Grant Likely wrote:
> > On Fri,  7 Dec 2012 16:01:39 +0200, Mathias Nyman<mathias.nyman@linux.intel.com>  wrote:
> >> Add gpio support for Intel Lynxpoint chipset.
> >> Lynxpoint supports 94 gpio pins which can generate interrupts.
> >> Driver will fail requests for pins that are marked as owned by ACPI, or
> >> set in an alternate mode (non-gpio).
> >>
> >> Signed-off-by: Mathias Nyman<mathias.nyman@linux.intel.com>
> >> ---
> >> +static void lp_gpio_set(struct gpio_chip *chip, unsigned gpio, int value)
> >> +{
> >> +	struct lp_gpio *lg = container_of(chip, struct lp_gpio, chip);
> >> +	unsigned long reg = gpio_reg(chip, gpio, LP_CONFIG1);
> >> +	unsigned long flags;
> >> +
> >> +	spin_lock_irqsave(&lg->lock, flags);
> >> +
> >> +	if (value)
> >> +		outl(inl(reg) | OUT_LVL_BIT, reg);
> >> +	else
> >> +		outl(inl(reg)&  ~OUT_LVL_BIT, reg);
> >> +
> >> +	spin_unlock_irqrestore(&lg->lock, flags);
> >> +}
> >
> > A *lot* of drivers implement their own GPIO ops like this, and they all
> > end up looking the same. Please take a look at
> > drivers/gpio/gpio-generic.c and see if you can use the stock operations
> > provided there.
> >
> > g.
> >
> 
> Look quite similar but turns out the only potential generic ones which 
> could be used are the bgpio_set() and bgpio_get() funtions. Using them 
> would require custom pin2mask, write_reg, read_reg, etc functions.
> bgpio_set_direction

You would need new write_reg and read_reg, but they'd just become part
of the library. Ah, but I see now that each GPIO has a separate
register, and not a bitmask for multiple gpio lines. Fair enough.

g.

