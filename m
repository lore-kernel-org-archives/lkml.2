Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064Ab2KHSs2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 13:48:28 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:42961 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504Ab2KHSsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 13:48:25 -0500
MIME-Version: 1.0
In-Reply-To: <1351928793-14375-3-git-send-email-mika.westerberg@linux.intel.com>
References: <1351928793-14375-1-git-send-email-mika.westerberg@linux.intel.com>
 <1351928793-14375-3-git-send-email-mika.westerberg@linux.intel.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 8 Nov 2012 18:48:05 +0000
X-Google-Sender-Auth: dL25zuJaqcMKNmeMfI_U5ugQfo0
Message-ID: <CACxGe6urWvrLUy_fkC6hA6go7p2GdoxSOO13c0aYe+0rNWwJ9Q@mail.gmail.com>
Subject: Re: [PATCH 2/3] spi / ACPI: add ACPI enumeration support
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, lenb@kernel.org, rafael.j.wysocki@intel.com,
        broonie@opensource.wolfsonmicro.com, linus.walleij@linaro.org,
        khali@linux-fr.org, ben-linux@fluff.org, w.sang@pengutronix.de,
        mathias.nyman@linux.intel.com, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 3, 2012 at 7:46 AM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:
> ACPI 5 introduced SPISerialBus resource that allows us to enumerate and
> configure the SPI slave devices behind the SPI controller. This patch adds
> support for this to the SPI core.
>
> In addition we bind ACPI nodes to SPI devices. This makes it possible for
> the slave drivers to get the ACPI handle for further configuration.
>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
>  drivers/spi/spi.c |  231 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 230 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
> index 84c2861..de22a6e 100644
> --- a/drivers/spi/spi.c
> +++ b/drivers/spi/spi.c
> @@ -35,6 +35,7 @@
>  #include <linux/sched.h>
>  #include <linux/delay.h>
>  #include <linux/kthread.h>
> +#include <linux/acpi.h>
>
>  static void spidev_release(struct device *dev)
>  {
> @@ -93,6 +94,10 @@ static int spi_match_device(struct device *dev, struct device_driver *drv)
>         if (of_driver_match_device(dev, drv))
>                 return 1;
>
> +       /* Then try ACPI */
> +       if (acpi_driver_match_device(dev, drv))
> +               return 1;
> +
>         if (sdrv->id_table)
>                 return !!spi_match_id(sdrv->id_table, spi);
>
> @@ -888,6 +893,227 @@ static void of_register_spi_devices(struct spi_master *master)
>  static void of_register_spi_devices(struct spi_master *master) { }
>  #endif
>
> +#ifdef CONFIG_ACPI
> +struct acpi_spi {
> +       acpi_status (*callback)(struct acpi_device *, void *);
> +       void *data;
> +};
> +
> +static acpi_status acpi_spi_enumerate_device(acpi_handle handle, u32 level,
> +                                            void *data, void **return_value)
> +{
> +       struct acpi_spi *acpi_spi = data;
> +       struct acpi_device *adev;
> +
> +       if (acpi_bus_get_device(handle, &adev))
> +               return AE_OK;
> +       if (acpi_bus_get_status(adev) || !adev->status.present)
> +               return AE_OK;
> +
> +       return acpi_spi->callback(adev, acpi_spi->data);
> +}
> +
> +static acpi_status acpi_spi_enumerate(acpi_handle handle,
> +       acpi_status (*callback)(struct acpi_device *, void *), void *data)
> +{
> +       struct acpi_spi acpi_spi;
> +
> +       acpi_spi.callback = callback;
> +       acpi_spi.data = data;
> +
> +       return acpi_walk_namespace(ACPI_TYPE_DEVICE, handle, 1,
> +                                  acpi_spi_enumerate_device, NULL,
> +                                  &acpi_spi, NULL);
> +}

>From my reading of this, the block causes 2 levels of callback
indirection. First to either acpi_spi_find_child or
acpi_spi_add_device and second to acpi_spi_enumerate_device. All to
share about 4 lines of code in acpi_spi_enumerate_device. It took me a
while to unravel it. I think acpi_spi_find_child and
acpi_spi_add_device should be passed directly to acpi_walk_namespace.
Is there anything that prevents that?

I also agree with the discussion that the actual parsing code for the
resources should be common,. Retrieving things like IRQs and address
resources should be function calls into ACPI helpers instead of open
coding it in the spi core code.

Otherwise the patch looks sane to me.

g.
