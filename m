Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841Ab0ICNsb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 09:48:31 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57463 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755403Ab0ICNsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 09:48:30 -0400
Date: Fri, 3 Sep 2010 14:48:27 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Masayuki Ohtak <masa-korg@dsn.okisemi.com>
Cc: meego-dev@meego.com, Andrew Morton <akpm@linux-foundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Randy Dunlap <randy.dunlap@oracle.com>, Alek Du <alek.du@intel.com>,
        Richard =?iso-8859-1?Q?R=F6jfors?= 
	<richard.rojfors@mocean-labs.com>,
        Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, andrew.chih.howe.khor@intel.com,
        arjan@linux.intel.com, gregkh@suse.de, yong.y.wang@intel.com,
        Tomoya MORINAGA <morinaga526@dsn.okisemi.com>
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_GPIO driver to 2.6.35
Message-ID: <20100903134827.GA7614@rakim.wolfsonmicro.main>
References: <4C80D3C8.9020204@dsn.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C80D3C8.9020204@dsn.okisemi.com>
X-Cookie: Life is not for everyone.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 03, 2010 at 07:54:00PM +0900, Masayuki Ohtak wrote:

> Topcliff PCH is the platform controller hub that is going to be used in
> Intel's upcoming general embedded platform. All IO peripherals in
> Topcliff PCH are actually devices sitting on AMBA bus.
> Topcliff PCH has GPIO I/F. Using this I/F, it is able to access system
> devices connected to GPIO.

This has a similar issue to the CAN driver - it isn't a standard kernel
GPIO driver, it implements a custom ioctl based userspace ABI.  This
means it's not usable from within the kernel and isn't suitable for
mainline.  You should be implementing support for the device using the
standard interfaces used by the other GPIO drivers in kernel.

> +/**
> + * pch_gpio_handler - Implements the interrupt handler functionality of
> + *		      the gpio module.
> + * @irq:	Contains the irq value
> + * @pData:	Contains the reference to the base gpio address.

Please use the standard kernel coding style conventions for naming
variables.

> +static irqreturn_t pch_gpio_handler(s32 irq, void *pData)
> +{
> +	irqreturn_t ret = IRQ_NONE;
> +	u32 pch_idisp_regval;
> +	struct pch_gpio_chip *chip =  (struct pch_gpio_chip *)pData;

No need to cast away from void.

> +
> +	pch_idisp_regval =
> +			chip->pch_gpio_bit_mask & ioread32(&chip->reg->idisp);
> +	if (pch_idisp_regval != 0) {
> +		/*invoke the callback */
> +		(*pch_gpio_cbr) (pch_idisp_regval, chip);

The interrupts from the controller should be hooked up to genirq, not
using this custom callback mechanism.
