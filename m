Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751367Ab1BZBBr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 20:01:47 -0500
Received: from mail.perches.com ([173.55.12.10]:3945 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750804Ab1BZBBq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 20:01:46 -0500
Subject: Re: [PATCH v4 4/4] gpio: Add support for Intel
 ICHx/3100/Series[56] GPIO
From: Joe Perches <joe@perches.com>
To: Peter Tyser <ptyser@xes-inc.com>
Cc: linux-kernel@vger.kernel.org, Alek Du <alek.du@intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Eric Miao <eric.y.miao@gmail.com>,
        Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>,
        Vincent Palatin <vpalatin@chromium.org>
In-Reply-To: <1298669181-9589-4-git-send-email-ptyser@xes-inc.com>
References: <1298669181-9589-1-git-send-email-ptyser@xes-inc.com>
	 <1298669181-9589-4-git-send-email-ptyser@xes-inc.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Feb 2011 17:01:43 -0800
Message-ID: <1298682103.4002.24.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-02-25 at 15:26 -0600, Peter Tyser wrote:
> This driver works on many Intel chipsets, including the ICH6, ICH7,
> ICH8, ICH9, ICH10, 3100, Series 5/3400 (Ibex Peak), Series 6/C200
> (Cougar Point).

Hi Peter.

just trivia...

> diff --git a/drivers/gpio/ichx_gpio.c b/drivers/gpio/ichx_gpio.c
[]
> @@ -0,0 +1,551 @@
> +/*
> + * Intel ICH6-10, Series 5 and 6 GPIO driver
[]
> + */
> +

You could use

#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

before any #include

so that the uses of
	printk(KERN_<level> "%s: foo...\n", DRV_NAME, bar...);
can be
	pr_<level>("foo...\n", bar...);

> +#include <linux/module.h>
> +#include <linux/pci.h>
> +#include <linux/gpio.h>
> +#include <linux/platform_device.h>

[]

> +static int modparam_gpiobase = -1 /* dynamic */;

Pretty unusual commenting style and too easy to lose sight
of the terminating semicolon.

It's more usually written as:

static int modparam_gpiobase = -1;	/* dynamic */

> +static int __devinit ichx_gpio_init(struct pci_dev *pdev,
> +				const struct pci_device_id *ent,
> +				struct platform_device *dev)
> +{
[]
> +	if (!ichx_priv.gpio_base) {
> +		printk(KERN_ERR "%s: GPIO BAR not enumerated\n", DRV_NAME);

print->pr_<level> like:
		pr_err("GPIO BAR not enumerated\n");

> +	if (ichx_priv.desc->gpe0_sts_ofs) {
> +		pci_read_config_dword(pdev, PCI_ICHX_ACPI_BAR,
> +				      (u32 *)&ichx_priv.pm_base);
> +		ichx_priv.pm_base &= PCI_BASE_ADDRESS_IO_MASK;
> +		if (!ichx_priv.pm_base)
> +			printk(KERN_WARNING "%s: ACPI BAR not enumerated, "
> +			       "GPI 0 - 15 unusable\n", DRV_NAME);

			pr_warn("ACPI BAR not enumerated, GPI 0 - 15 unusable\n");

and so forth for all the printks.

One other typo:

> +static int ich6_gpio_request(struct gpio_chip *chip, unsigned nr)
> +{
> +	/*
> +	 * Fixups for bits 16 and 17 are necessary on the Intel ICH6/3100
> +	 * brdige as they are controlled by USE register bits 0 and 1.  See
> 

	bridge


