Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932155Ab0F3QIN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 12:08:13 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:36240 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756153Ab0F3QIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 12:08:12 -0400
Date: Wed, 30 Jun 2010 17:08:09 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: David Dajun Chen <Dajun.Chen@diasemi.com>
Cc: sameo@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 1/11] MFD: Reformatting of files and removal of
	testing framework
Message-ID: <20100630160807.GC5832@sirena.org.uk>
References: <3495EC08FA53E94AAA00CC4743D5BA7E013FA7EA@pandora.diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3495EC08FA53E94AAA00CC4743D5BA7E013FA7EA@pandora.diasemi.com>
X-Cookie: Slow day.  Practice crawling.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 29, 2010 at 02:12:54PM +0100, David Dajun Chen wrote:

> MFD module of the device driver for DA9052 PMIC device from Dialog
> Semiconductor.

It looks like only a small subset of these patches have managed to get
posted to the mailing list...

> +#if defined(CONFIG_MFD_DA9052_SPI)
> +#include <linux/spi/spi.h>
> +#endif

As I said in reply to the regulator patch it would be much better to
structure the driver such that the I2C and SPI interfaces can be
supported by a single kernel image.  This helps support kernels that can
boot on multiple systems and provides better coverage of the driver in
automated testing.

This will also make the code more legible by removing ifdefery.

> +struct ssc_cache_entry	ssc_cache[DA9052_REG_CNT];
> +struct da9052_eh_nb eve_nb_array[EVE_CNT];

These should both be part of the driver private data rather than
statically allocated in case there are multiple devices in the system.
It'll also save a bit of RAM if the driver is compiled but not used.

> +void da9052_lock(struct da9052 *da9052)
> +{
> +	if (!mutex_trylock(&da9052->ssc_lock))
> +		mutex_lock(&da9052->ssc_lock);
> +}

The use of mutex_trylock() looks deeply suspicious - why might one not
wish to take the lock?

> +static int da9052_add_subdevice_pdata(struct da9052 *da9052,
> +		const char *name, void *pdata, size_t pdata_size)
> +{
> +	struct mfd_cell cell = {
> +		.name = name,
> +		.platform_data = pdata,
> +		.data_size = pdata_size,
> +	};

It'd probably be a bit simpler to have the subdevice read the data from
the platform data of the parent device so that you can just use the MFD
API directly here - it's just an additional indirection in the
subdrivers.

> +static irqreturn_t da9052_eh_isr(int irq, void *dev_id)
> +{
> +	unsigned int handled = 0;
> +
> +	struct da9052 *da9052 = dev_id;
> +
> +	/* Schedule work to be done */
> +	schedule_work(&da9052->eh_isr_work);
> +
> +	/* Disable IRQ */
> +	disable_irq_nosync(DA9052_IRQ);
> +
> +	return IRQ_RETVAL(handled);
> +}

You're looking for request_threaded_irq() here - this provides a
standard implementation of this idiom with less open coding.

> +int eh_register_nb(struct da9052 *da9052, struct da9052_eh_nb *nb)
> +{
> +

The event handling mechanism you've got here looks like it should be
implemented in terms of the kernel IRQ subsystem rather than open coding
a custom API which does the same thing.  This will give you access to
the infrastructre that genirq provides and will allow you to implement
interrupts from any GPIOs the chip has.

Look for other MFDs using handle_nested_irq() for examples of how to
implement this.

> +static int process_events(struct da9052 *da9052, int events_sts)
> +{
> +
> +	int cnt = 0;
> +	int tmp_events_sts = 0;
> +	unsigned char event = 0;
> +
> +	struct list_head *ptr;
> +	struct da9052_eh_nb *nb_ptr;
> +
> +	/* Now we have retrieved all events, process them one by one */
> +	for (cnt = 0; cnt < PRIO_CNT; cnt++) {

Is this prioritisation really required?  It adds quite a bit of code
complexity and it would seem unusual for a device such as a PMIC with a
relatively slow control interface to be generating interrupts in
sufficient volume for it to be worth the effort.  I'd not be surprised
to learn that in actual systems the overhead of implementing the
priority queue outweights the benefit.
