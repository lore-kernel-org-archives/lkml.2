Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813Ab0LVMlG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 07:41:06 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60411 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417Ab0LVMlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 07:41:05 -0500
Date: Wed, 22 Dec 2010 12:41:03 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: dd diasemi <dd.diasemi@gmail.com>
Cc: sameo@openedhand.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4 1/11] MFD: MFD module of DA9052 device driver
Message-ID: <20101222124102.GC4520@sirena.org.uk>
References: <AANLkTinkj4uYG1sFCGRypa4z=Neyj6jOsy+OL91eunpz@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinkj4uYG1sFCGRypa4z=Neyj6jOsy+OL91eunpz@mail.gmail.com>
X-Cookie: Yow!  Now we can become alcoholics!
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 21, 2010 at 07:00:56PM +0100, dd diasemi wrote:

> Changes made since last submission:
> . single kernel image for SPI and I2C connectivities.
> . equal priorites for all DA9052 PMIC device events.
> . semaphore protection for event notification. note usage of mutex
> yields undesirable effects at run time.
> . masked events are not processed.

> Linux Kernel Version: 2.6.34

Standard comments for your patch series: *always* submit against current
kernel versions and always try to address review comments.  Many of the
things I'm identifying below are very familiar.  The below comments are
pretty terse due to the repitition - please refer to previous reviews
for more detail.

> +struct da9052_eh_nb eve_nb_array[EVE_CNT];
> +static struct da9052_ssc_ops ssc_ops;
> +struct mutex manconv_lock;
> +static struct semaphore eve_nb_array_lock;

These globals look suspicious...

> +int da9052_ssc_write(struct da9052 *da9052, struct da9052_ssc_msg *sscmsg)
> +{
> +	int ret = 0;
> +
> +	if ((sscmsg->addr < DA9052_PAGE0_REG_START) ||
> +	(sscmsg->addr > DA9052_PAGE1_REG_END) ||
> +	((sscmsg->addr > DA9052_PAGE0_REG_END) &&
> +	(sscmsg->addr < DA9052_PAGE1_REG_START)))
> +		return INVALID_REGISTER;

Use standard error codes and check your indentation.

> +static irqreturn_t da9052_eh_isr(int irq, void *dev_id)
> +{
> +	struct da9052 *da9052 = dev_id;
> +	schedule_work(&da9052->eh_isr_work);
> +	disable_irq_nosync(DA9052_IRQ);
> +	return IRQ_HANDLED;
> +}

Use a threaded IRQ rather than open coding one with a workqueue.

> +int eh_register_nb(struct da9052 *da9052, struct da9052_eh_nb *nb)
> +{
> +

Rather than implementing a custom IRQ infrastructure you should use the
genirq core to handle interrupts.

> +	udelay(50);
> +	enable_irq(DA9052_IRQ);

The IRQ number used is another thing that should be hanled in a board
specific fashion.  The I2C and SPI frameworks both provide standard
features to pass IRQs to drivers.

> +MODULE_AUTHOR("Dialog Semiconductor Ltd <dchen@diasemi.com>");
> +MODULE_DESCRIPTION("I2C driver for Dialog DA9052 PMIC");
> +MODULE_LICENSE("GPL v2");
> +MODULE_ALIAS("platform:" DA9052_SSC_I2C_DEVICE_NAME);

Your I2C driver isn't a platform device...

> +MODULE_AUTHOR("Dialog Semiconductor Ltd <dchen@diasemi.com>");
> +MODULE_DESCRIPTION("SPI driver for Dialog DA9052 PMIC");
> +MODULE_LICENSE("GPL v2");
> +MODULE_ALIAS("platform:" DA9052_SSC_SPI_DEVICE_NAME);

...nor is your SPI driver.

> +config PMIC_DA9052
> +	tristate "Dialog DA9052 with SPI/I2C"
> +	depends on SPI_MASTER=y
> +	depends on I2C=y
> +	select MFD_CORE

This is going to force both I2C and SPI to be built in if the driver is
enabled, even though only one is likely to be used in a given system and
the driver itself supports modular operation.

> +#ifeq ($(CONFIG_PMIC_DA9052),y)
> +da9052-objs			:= da9052-spi.o da9052-i2c.o da9052-core.o
> +obj-$(CONFIG_PMIC_DA9052)	+= da9052.o
> +#endif

This ifeq doesn't seem consistent with the above Kconfig...

> +
> +#define SPI 1
> +#define I2C 2

Namespacing...

> +/* Configure the DA9052 IRQ as per the BSP */
> +#define DA9052_IRQ	9

Should be supplied via the bus.

> +/* Module specific error codes */
> +#define INVALID_REGISTER		2
> +#define INVALID_READ			3
> +#define INVALID_PAGE			4

Don't define your own error codes, use standard ones.

> +/* Defines for Volatile and Non Volatile register types */
> +#define VOLATILE			0
> +#define NON_VOLATILE			1
> +
> +/* Defines for cache state */
> +#define VALID				0
> +#define INVALID				1

Namespacing.  There's lots of other things with this issue in the rest
of the code.
