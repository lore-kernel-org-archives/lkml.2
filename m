Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354Ab2KTNBA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 08:01:00 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:55409 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752710Ab2KTNA7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 08:00:59 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: grant.likely@secretlab.ca, linus.walleij@linaro.org, w.sang@pengutronix.de,
        rafael.j.wysocki@intel.com, linux-kernel@vger.kernel.org,
        lenb@kernel.org, broonie@opensource.wolfsonmicro.com,
        khali@linux-fr.org, ben-linux@fluff.org, bhelgaas@google.com,
        mathias.nyman@linux.intel.com, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v3 2/3] spi / ACPI: add ACPI enumeration support
Date: Tue, 20 Nov 2012 14:05:26 +0100
Message-ID: <12657869.yQS4p6Y8j3@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0-rc6; KDE/4.9.3; x86_64; ; )
In-Reply-To: <1353407384-26880-3-git-send-email-mika.westerberg@linux.intel.com>
References: <1352977397-2280-1-git-send-email-mika.westerberg@linux.intel.com> <1353407384-26880-1-git-send-email-mika.westerberg@linux.intel.com> <1353407384-26880-3-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 20, 2012 12:29:43 PM Mika Westerberg wrote:
> ACPI 5 introduced SPISerialBus resource that allows us to enumerate and
> configure the SPI slave devices behind the SPI controller. This patch adds
> support for this to the SPI core.
> 
> In addition we bind ACPI nodes to SPI devices. This makes it possible for
> the slave drivers to get the ACPI handle for further configuration.
> 
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> ---
>  drivers/spi/spi.c |  115 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 114 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
> index 84c2861..3ae5351 100644
> --- a/drivers/spi/spi.c
> +++ b/drivers/spi/spi.c
> @@ -35,6 +35,8 @@
>  #include <linux/sched.h>
>  #include <linux/delay.h>
>  #include <linux/kthread.h>
> +#include <linux/ioport.h>
> +#include <linux/acpi.h>
>  
>  static void spidev_release(struct device *dev)
>  {
> @@ -93,6 +95,10 @@ static int spi_match_device(struct device *dev, struct device_driver *drv)
>  	if (of_driver_match_device(dev, drv))
>  		return 1;
>  
> +	/* Then try ACPI */
> +	if (acpi_driver_match_device(dev, drv))
> +		return 1;
> +
>  	if (sdrv->id_table)
>  		return !!spi_match_id(sdrv->id_table, spi);
>  
> @@ -888,6 +894,112 @@ static void of_register_spi_devices(struct spi_master *master)
>  static void of_register_spi_devices(struct spi_master *master) { }
>  #endif
>  
> +#ifdef CONFIG_ACPI
> +static int acpi_spi_add_resource(struct acpi_resource *ares, void *data)
> +{
> +	struct acpi_resource_spi_serialbus *sb;
> +	struct spi_device *spi = data;
> +	struct resource r;
> +
> +	switch (ares->type) {
> +	case ACPI_RESOURCE_TYPE_IRQ:
> +	case ACPI_RESOURCE_TYPE_EXTENDED_IRQ:

It is not necessary to check the resource type for IRQ resources here,
because acpi_dev_resource_interrupt() will do it for you anyway. :-)

So, I would first check if the resource type is ACPI_RESOURCE_TYPE_SERIAL_BUS
(and populate the spi_device fields if so) and then do something like this:

if (acpi_dev_resource_interrupt(ares, 0, &r)) {
	if (spi->irq < 0)
		spi->irq = r.start;

	return 1;
}

We don't even need to memset(), because we're not going to use that resource
object going forward.


> +		/* Only use the first interrupt resource and skip the rest */
> +		memset(&r, 0, sizeof(r));
> +		if (spi->irq < 0 && acpi_dev_resource_interrupt(ares, 0, &r))
> +			spi->irq = r.start;
> +		return 1;
> +
> +	case ACPI_RESOURCE_TYPE_SERIAL_BUS:
> +		sb = &ares->data.spi_serial_bus;
> +		if (sb->type == ACPI_RESOURCE_SERIAL_TYPE_SPI) {
> +			spi->chip_select = sb->device_selection;
> +			spi->max_speed_hz = sb->connection_speed;
> +
> +			if (sb->clock_phase == ACPI_SPI_SECOND_PHASE)
> +				spi->mode |= SPI_CPHA;
> +			if (sb->clock_polarity == ACPI_SPI_START_HIGH)
> +				spi->mode |= SPI_CPOL;
> +			if (sb->device_polarity == ACPI_SPI_ACTIVE_HIGH)
> +				spi->mode |= SPI_CS_HIGH;
> +
> +			return 1;
> +		}
> +		return 0;
> +	}
> +
> +	return 0;

We're not interested in any resources except for the above, so I think we
can just always return 1 from this function, or am I missing anything?

> +}
> +
> +static acpi_status acpi_spi_add_device(acpi_handle handle, u32 level,
> +				       void *data, void **return_value)
> +{
> +	struct spi_master *master = data;
> +	struct list_head resource_list;
> +	struct acpi_device *adev;
> +	struct spi_device *spi;
> +	int ret;
> +
> +	if (acpi_bus_get_device(handle, &adev))
> +		return AE_OK;
> +	if (acpi_bus_get_status(adev) || !adev->status.present)
> +		return AE_OK;
> +
> +	spi = spi_alloc_device(master);
> +	if (!spi) {
> +		dev_err(&master->dev, "failed to allocate SPI device for %s\n",
> +			dev_name(&adev->dev));
> +		return AE_NO_MEMORY;
> +	}
> +
> +	ACPI_HANDLE_SET(&spi->dev, handle);
> +	spi->irq = -1;
> +
> +	INIT_LIST_HEAD(&resource_list);
> +	ret = acpi_dev_get_resources(adev, &resource_list,
> +				     acpi_spi_add_resource, spi);

acpi_dev_free_resource_list(&resource_list); can be done here (the list
is going to be empty anyway if acpi_spi_add_resource() always returns 1)
and then you won't need the fail_put_dev label.

> +	if (ret < 0)
> +		goto fail_put_dev;
> +
> +	acpi_dev_free_resource_list(&resource_list);
> +
> +	if (!spi->max_speed_hz)
> +		goto fail_put_dev;
> +
> +	strlcpy(spi->modalias, dev_name(&adev->dev), sizeof(spi->modalias));
> +	if (spi_add_device(spi)) {
> +		dev_err(&master->dev, "failed to add SPI device %s from ACPI\n",
> +			dev_name(&adev->dev));
> +		goto fail_put_dev;
> +	}
> +
> +	return AE_OK;
> +
> +fail_put_dev:
> +	spi_dev_put(spi);
> +
> +	return AE_OK;
> +}
> +
> +static void acpi_register_spi_devices(struct spi_master *master)
> +{
> +	acpi_status status;
> +	acpi_handle handle;
> +
> +	handle = ACPI_HANDLE(&master->dev);
> +	if (!handle)
> +		return;
> +
> +	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, handle, 1,
> +				     acpi_spi_add_device, NULL,
> +				     master, NULL);
> +	if (ACPI_FAILURE(status))
> +		dev_warn(&master->dev, "failed to enumerate SPI slaves\n");
> +}
> +#else
> +static inline void acpi_register_spi_devices(struct spi_master *master) {}
> +#endif /* CONFIG_ACPI */
> +
>  static void spi_master_release(struct device *dev)
>  {
>  	struct spi_master *master;
> @@ -1023,8 +1135,9 @@ int spi_register_master(struct spi_master *master)
>  		spi_match_master_to_boardinfo(master, &bi->board_info);
>  	mutex_unlock(&board_lock);
>  
> -	/* Register devices from the device tree */
> +	/* Register devices from the device tree and ACPI */
>  	of_register_spi_devices(master);
> +	acpi_register_spi_devices(master);
>  done:
>  	return status;
>  }

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
