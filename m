Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640Ab0LVL5z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 06:57:55 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:39172 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125Ab0LVL5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 06:57:54 -0500
Date: Wed, 22 Dec 2010 11:57:52 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: dd diasemi <dd.diasemi@gmail.com>
Cc: jic23@cam.ac.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4 2/11] GPIO: GPIO module of DA9052 device driver
Message-ID: <20101222115752.GB4520@sirena.org.uk>
References: <AANLkTind64+nqpRtR22Tpdj3xLL4+BYPsNbshUu6YZi9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTind64+nqpRtR22Tpdj3xLL4+BYPsNbshUu6YZi9@mail.gmail.com>
X-Cookie: Yow!  Now we can become alcoholics!
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 21, 2010 at 06:47:19PM +0100, dd diasemi wrote:
> GPIO module for DA9052 PMIC device from Dialog Semiconductor.

> Changes made since last submission:
> . locking for individual GPI pin configuration
> . event registration

> Linux Kernel Version: 2.6.34

As previously mentioned you should be submitting against current kernel
versions.  *Please* read and try to follow Documentation/SubmittingPatches.

Looking through this it seems there's several issues here which have
been pointed out with previous versions of the patch.  Please do address
issues identified in review, either by discussing anything you disagree
with on the list or correcting the code.

> +void da9052_gpio_notifier(struct da9052_eh_nb *eh_data, unsigned int event)
> +{
> +	struct da9052_gpio_chip *gpio =
> +			container_of(eh_data, struct da9052_gpio_chip, eh_data);
> +	kobject_uevent(&gpio->gp.dev->kobj, KOBJ_CHANGE);
> +
> +}

What is this doing?  It looks awfully like this is implementing
interrupt handling - you should be using the genirq framework for this,
it provides standard interrupt handling for the kernel.

> +static s32 write_default_gpio_values(struct da9052 *da9052)
> +{
> +	struct da9052_ssc_msg msg;
> +	u8 created_val = 0;
> +
> +#if (DA9052_GPIO_PIN_0 == DA9052_GPIO_CONFIG)
> +	da9052_lock(da9052);
> +	msg.addr = DA9052_GPIO0001_REG;
> +	msg.data = 0;

This appears to be some sort of system specific configuration - things
like this should be being configured by supplying platform data to the
device.

> +s32 da9052_gpio_multiple_read(struct da9052_gpio_multiple_read *multiple_port,
> +				struct da9052 *da9052)

APIs like this should be added to the gpiolib core rather than done in a
driver custom manner - there were some previous efforts at this which
didn't get merged for whatever reason.  There's nothing particularly
device specific about the idea of setting multiple GPIOs in a single
operation.

> +config DA9052_GPIO_ENABLE
> +	bool "Dialog DA9052 GPIO"
> +	depends on PMIC_DA9052
> +	help
> +	  Say Y  to enable the GPIO driver for the DA9052 chip
> +

The _ENABLE isn't idiomatic here...

> +enum ip_op_type {
> +	ALTERNATE_FUNCTIONALITY = 0,
> +	INPUT,
> +	OUTPUT_OPENDRAIN,
> +	OUTPUT_PUSHPULL
> +};

All these constants and most of the remaining ones in the file need
namespacing.
