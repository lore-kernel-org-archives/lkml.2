Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751408Ab2KPKC1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 05:02:27 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:48267 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750892Ab2KPKC0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 05:02:26 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mika Westerberg <mika.westerberg@linux.intel.com>,
        grant.likely@secretlab.ca, linus.walleij@linaro.org,
        bhelgaas@google.com
Cc: linux-kernel@vger.kernel.org, lenb@kernel.org, rafael.j.wysocki@intel.com,
        broonie@opensource.wolfsonmicro.com, khali@linux-fr.org,
        ben-linux@fluff.org, w.sang@pengutronix.de,
        mathias.nyman@linux.intel.com, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v2 2/3] spi / ACPI: add ACPI enumeration support
Date: Fri, 16 Nov 2012 11:06:47 +0100
Message-ID: <1461172.NdNxeoXuXo@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc5; KDE/4.8.5; x86_64; ; )
In-Reply-To: <1352977397-2280-3-git-send-email-mika.westerberg@linux.intel.com>
References: <1352977397-2280-1-git-send-email-mika.westerberg@linux.intel.com> <1352977397-2280-3-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 15, 2012 01:03:16 PM Mika Westerberg wrote:
> ACPI 5 introduced SPISerialBus resource that allows us to enumerate and
> configure the SPI slave devices behind the SPI controller. This patch adds
> support for this to the SPI core.
> 
> In addition we bind ACPI nodes to SPI devices. This makes it possible for
> the slave drivers to get the ACPI handle for further configuration.
> 
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Does anyone has objections or comments?  Do we need to change anything
in this patch?

Grant? Linus? Bjorn?

Rafael


> ---
>  drivers/spi/spi.c |  201 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 200 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
> index 84c2861..e39a484 100644
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
> @@ -888,6 +894,196 @@ static void of_register_spi_devices(struct spi_master *master)
>  static void of_register_spi_devices(struct spi_master *master) { }
>  #endif
>  
> +#ifdef CONFIG_ACPI
> +static int acpi_spi_add_resource(struct acpi_resource *ares, void *data)
> +{
> +	struct acpi_resource_spi_serialbus *sb;
> +	struct spi_device *spi = data;
> +
> +	if (ares->type != ACPI_RESOURCE_TYPE_SERIAL_BUS)
> +		return 0;
> +
> +	sb = &ares->data.spi_serial_bus;
> +	if (sb->type != ACPI_RESOURCE_SERIAL_TYPE_SPI)
> +		return 0;
> +
> +	spi->chip_select = sb->device_selection;
> +	spi->max_speed_hz = sb->connection_speed;
> +
> +	if (sb->clock_phase == ACPI_SPI_SECOND_PHASE)
> +		spi->mode |= SPI_CPHA;
> +	if (sb->clock_polarity == ACPI_SPI_START_HIGH)
> +		spi->mode |= SPI_CPOL;
> +	if (sb->device_polarity == ACPI_SPI_ACTIVE_HIGH)
> +		spi->mode |= SPI_CS_HIGH;
> +
> +	return 1;
> +}
> +
> +static acpi_status acpi_spi_add_device(acpi_handle handle, u32 level,
> +				       void *data, void **return_value)
> +{
> +	struct spi_master *master = data;
> +	struct resource_list_entry *rentry;
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
> +	INIT_LIST_HEAD(&resource_list);
> +	ret = acpi_dev_get_resources(adev, &resource_list,
> +				     acpi_spi_add_resource, spi);
> +	if (ret < 0)
> +		goto fail_put_dev;
> +
> +	list_for_each_entry(rentry, &resource_list, node) {
> +		struct resource *r = &rentry->res;
> +
> +		if (resource_type(r) == IORESOURCE_IRQ) {
> +			spi->irq = r->start;
> +			break;
> +		}
> +	}
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
> +	handle = master->dev.acpi_handle;
> +	if (!handle)
> +		return;
> +
> +	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, handle, 1,
> +				     acpi_spi_add_device, NULL,
> +				     master, NULL);
> +	if (ACPI_FAILURE(status))
> +		dev_warn(&master->dev, "failed to enumerate SPI slaves\n");
> +}
> +
> +struct acpi_spi_find {
> +	acpi_handle handle;
> +	u16 chip_select;
> +	bool found;
> +};
> +
> +static int acpi_spi_find_child_address(struct acpi_resource *ares, void *data)
> +{
> +	struct acpi_resource_spi_serialbus *sb;
> +	struct acpi_spi_find *spi_find = data;
> +
> +	if (ares->type != ACPI_RESOURCE_TYPE_SERIAL_BUS)
> +		return 1;
> +
> +	sb = &ares->data.spi_serial_bus;
> +	if (sb->type != ACPI_RESOURCE_SERIAL_TYPE_SPI)
> +		return 1;
> +
> +	if (sb->device_selection == spi_find->chip_select)
> +		spi_find->found = true;
> +
> +	return 1;
> +}
> +
> +static acpi_status acpi_spi_find_child(acpi_handle handle, u32 level,
> +				       void *data, void **return_value)
> +{
> +	struct acpi_spi_find *spi_find = data;
> +	struct list_head resource_list;
> +	struct acpi_device *adev;
> +	int ret;
> +
> +	if (acpi_bus_get_device(handle, &adev))
> +		return AE_OK;
> +	if (acpi_bus_get_status(adev) || !adev->status.present)
> +		return AE_OK;
> +
> +	INIT_LIST_HEAD(&resource_list);
> +	ret = acpi_dev_get_resources(adev, &resource_list,
> +				     acpi_spi_find_child_address, spi_find);
> +	if (ret < 0)
> +		return AE_OK;
> +
> +	acpi_dev_free_resource_list(&resource_list);
> +
> +	if (spi_find->found) {
> +		spi_find->handle = handle;
> +		return AE_CTRL_TERMINATE;
> +	}
> +	return AE_OK;
> +}
> +
> +static int acpi_spi_find_device(struct device *dev, acpi_handle *handle)
> +{
> +	struct spi_device *spi = to_spi_device(dev);
> +	struct spi_master *master = spi->master;
> +	struct acpi_spi_find spi_find;
> +	acpi_handle parent;
> +	acpi_status status;
> +
> +	parent = master->dev.acpi_handle;
> +	if (!parent)
> +		return -ENODEV;
> +
> +	memset(&spi_find, 0, sizeof(spi_find));
> +	spi_find.chip_select = spi->chip_select;
> +
> +	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, parent, 1,
> +				     acpi_spi_find_child, NULL,
> +				     &spi_find, NULL);
> +	if (ACPI_FAILURE(status) || !spi_find.handle)
> +		return -ENODEV;
> +
> +	*handle = spi_find.handle;
> +	return 0;
> +}
> +
> +static struct acpi_bus_type acpi_spi_bus = {
> +	.bus = &spi_bus_type,
> +	.find_device = acpi_spi_find_device,
> +};
> +
> +static void acpi_spi_bus_register(void)
> +{
> +	register_acpi_bus_type(&acpi_spi_bus);
> +}
> +#else
> +static inline void acpi_register_spi_devices(struct spi_master *master) {}
> +static inline void acpi_spi_bus_register(void) {}
> +#endif /* CONFIG_ACPI */
> +
>  static void spi_master_release(struct device *dev)
>  {
>  	struct spi_master *master;
> @@ -1023,8 +1219,9 @@ int spi_register_master(struct spi_master *master)
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
> @@ -1550,6 +1747,8 @@ static int __init spi_init(void)
>  	status = class_register(&spi_master_class);
>  	if (status < 0)
>  		goto err2;
> +
> +	acpi_spi_bus_register();
>  	return 0;
>  
>  err2:
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
