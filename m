Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135Ab1DFN7x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 09:59:53 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36996 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755915Ab1DFN7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 09:59:52 -0400
Date: Wed, 6 Apr 2011 22:59:56 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Jangam <Ashish.Jangam@kpitcummins.com>
Cc: "sameo@openedhand.com" <sameo@openedhand.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dajun Chen <Dajun.Chen@diasemi.com>
Subject: Re: [PATCHv1 1/11] MFD: MFD module of DA9052 PMIC driver
Message-ID: <20110406135954.GA2810@opensource.wolfsonmicro.com>
References: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151B4AC245@KCINPUNHJCMS01.kpit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151B4AC245@KCINPUNHJCMS01.kpit.com>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 06, 2011 at 07:01:34PM +0530, Ashish Jangam wrote:

> +int da9052_adc_manual_read(struct da9052 *da9052,
> +                       unsigned char channel)
> +{
> +       unsigned char timeout_cnt = 8;
> +       unsigned short calc_data;
> +       int ret;
> +       u16 data = 0;
> +       u8 mux_sel = 0;

There's no concurrency protection in this code so if two users try to do
ADC reads simultaneously they'll interfere with each other.

> +int da9052_reg_read(struct da9052 *da9052, unsigned char reg)
> +{
> +       unsigned char val;
> +
> +       if( reg > DA9052_MAX_REG_CNT ) {

This isn't the standard kernel coding style - checkpatch.pl can help
spot issues like this (there's many other examples throughout the code).

> +       if ( da9052->read_dev(da9052, reg, 1, &val) ) {
> +               mutex_unlock(&da9052->io_lock);
> +               return -EIO;
> +       }

It'd seem helpful to return any error code that read_dev() returns to
the caller.

> +int da9052_read_events(struct da9052 *da9052, unsigned char reg ,
> +                             unsigned int *events)
> +{
> +       uint8_t v[4] = {0, 0, 0, 0};
> +       int ret;
> +
> +       ret = da9052_group_read(da9052, reg, 4, v);
> +       if (ret < 0)
> +               return ret;
> +
> +       *events = (v[3] << 24) | (v[2] << 16) | (v[1] << 8) | v[0];
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL_GPL(da9052_read_events);

This looks like part of the old non-standard IRQ code previous versions
of these patches had?  Looks like this should be merged into the IRQ
code if it's needed at all.

> +MODULE_AUTHOR("Dialog Semiconductor Ltd <dchen@diasemi.com>");
> +MODULE_DESCRIPTION("DA9052 MFD Core");
> +MODULE_LICENSE("GPL v2");
> +MODULE_ALIAS("platform:" DA9052_SSC_DEVICE_NAME);

Is this really a platform device?

> +static struct i2c_device_id da9052_i2c_id[] = {
> +       { "da9052_i2c", 0},
> +       {}
> +};

The usual style would just be "da9052_i2c" - the fact that this is an
I2C device ID makes it obvious that the device is an I2C one.

> +/*
> + * da9052-irq.c  --  Interrupt controller support for Dilaog DA9052 PMICs
> + *
> +#include <linux/i2c.h>
> +#include <linux/spi/spi.h>

The IRQ controller code probably shouldn't know anything about I2C or
SPI given that you've got a separate layer doing register I/O.

> +static void da9052_irq_sync_unlock(unsigned int irq)
> +{
> +       struct da9052 *da9052 = get_irq_chip_data(irq);
> +
> +       mutex_unlock(&da9052->irq_lock);
> +}

You should be applying the changes made while locked here - the locked
region should be atomic.

> +struct irq_chip da9052_irq_chip = {
> +       .name = "da9052",
> +       .bus_lock = da9052_irq_lock,
> +       .bus_sync_unlock = da9052_irq_sync_unlock,
> +       .mask = da9052_irq_mask,
> +       .unmask = da9052_irq_unmask,
> +};

This is out of date with current mainline, you should be using the irq_
variants of the operations which take an irq_desc rather than IRQ
number.

> +       for (cur_irq = da9052->irq_base;
> +            cur_irq < ARRAY_SIZE(da9052_irqs) + da9052->irq_base;
> +            cur_irq++) {
> +               set_irq_chip_data(cur_irq, da9052);
> +               set_irq_chip_and_handler(cur_irq, &da9052_irq_chip,
> +                                        handle_simple_irq);
> +               set_irq_nested_thread(cur_irq, 1);
> +
> +               /* ARM needs us to explicitly flag the IRQ as valid
> +                * and will set them noprobe when we do so. */
> +#ifdef CONFIG_ARM
> +               set_irq_flags(cur_irq, IRQF_VALID);
> +#else
> +               set_irq_noprobe(cur_irq);
> +#endif
> +       }

It'd be nice to credit the code you're drawing inspiration from :)

> +config PMIC_DA9052
> +       tristate "Dialog DA9052 with SPI/I2C"
> +       depends on SPI_MASTER=y
> +       depends on I2C=y

These dependencies look wrong - they'll force both I2C and SPI to be
built in even though only one of them will be required by the driver in
a given system.

> + /* Helper to save on boilerplate */
> +static inline int da9052_request_irq(struct da9052 *da9052, int irq,
> +                                      irq_handler_t handler, const char *name,
> +                                      void *data)
> + {
> +       int ret;
> +
> +       if (!da9052->irq_base)
> +               return -EINVAL;
> +
> +       ret = request_threaded_irq(da9052->irq_base + irq, NULL, handler,
> +                                     IRQF_TRIGGER_LOW | IRQF_ONESHOT, name,
> +                                     data);

Since you're implementing directly with genirq you don't need this
stuff, some drivers have it as they were written before genirq could
support devices on sleepy buses.
