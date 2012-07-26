Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751678Ab2GZTYC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 15:24:02 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:57737 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329Ab2GZTX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 15:23:58 -0400
MIME-Version: 1.0
In-Reply-To: <1343257978-7085-4-git-send-email-toshi.kani@hp.com>
References: <1343257978-7085-1-git-send-email-toshi.kani@hp.com> <1343257978-7085-4-git-send-email-toshi.kani@hp.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 26 Jul 2012 13:23:37 -0600
Message-ID: <CAErSpo6Dn8+pOsSuiMDNzwheH=LELRKhkWeSB__S0WjHBz13nA@mail.gmail.com>
Subject: Re: [PATCH v3 3/4] ACPI: Update Memory hotplug messages
To: Toshi Kani <toshi.kani@hp.com>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        joe@perches.com, isimatu.yasuaki@jp.fujitsu.com, liuj97@gmail.com,
        srivatsa.bhat@linux.vnet.ibm.com, prarit@redhat.com,
        imammedo@redhat.com, vijaymohan.pandarathil@hp.com
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2012 at 5:12 PM, Toshi Kani <toshi.kani@hp.com> wrote:
> Updated Memory hotplug log messages with acpi_pr_<level>()
> and pr_<level>().
>
> Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> ---
>  drivers/acpi/acpi_memhotplug.c |   24 ++++++++++++------------
>  1 files changed, 12 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
> index 06c55cd..dcc8f4d 100644
> --- a/drivers/acpi/acpi_memhotplug.c
> +++ b/drivers/acpi/acpi_memhotplug.c
> @@ -170,7 +170,7 @@ acpi_memory_get_device(acpi_handle handle,
>         /* Get the parent device */
>         result = acpi_bus_get_device(phandle, &pdevice);
>         if (result) {
> -               printk(KERN_WARNING PREFIX "Cannot get acpi bus device");
> +               acpi_pr_warn(phandle, "Cannot get acpi bus device\n");
>                 return -EINVAL;
>         }
>
> @@ -180,14 +180,14 @@ acpi_memory_get_device(acpi_handle handle,
>          */
>         result = acpi_bus_add(&device, pdevice, handle, ACPI_BUS_TYPE_DEVICE);
>         if (result) {
> -               printk(KERN_WARNING PREFIX "Cannot add acpi bus");
> +               acpi_pr_warn(handle, "Cannot add acpi bus\n");
>                 return -EINVAL;
>         }
>
>        end:
>         *mem_device = acpi_driver_data(device);
>         if (!(*mem_device)) {
> -               printk(KERN_ERR "\n driver data not found");
> +               acpi_pr_err(handle, "driver data not found\n");

acpi_driver_data() requires a valid acpi_device *, so dev_err() should
work here.

>                 return -ENODEV;
>         }
>
> @@ -224,7 +224,7 @@ static int acpi_memory_enable_device(struct acpi_memory_device *mem_device)
>         /* Get the range from the _CRS */
>         result = acpi_memory_get_device_resources(mem_device);
>         if (result) {
> -               printk(KERN_ERR PREFIX "get_device_resources failed\n");
> +               pr_err(PREFIX "get_device_resources failed\n");

And here.

>                 mem_device->state = MEMORY_INVALID_STATE;
>                 return result;
>         }
> @@ -257,7 +257,7 @@ static int acpi_memory_enable_device(struct acpi_memory_device *mem_device)
>                 num_enabled++;
>         }
>         if (!num_enabled) {
> -               printk(KERN_ERR PREFIX "add_memory failed\n");
> +               acpi_pr_err(mem_device->device->handle, "add_memory failed\n");

And here.

>                 mem_device->state = MEMORY_INVALID_STATE;
>                 return -EINVAL;
>         }
> @@ -353,7 +353,7 @@ static void acpi_memory_device_notify(acpi_handle handle, u32 event, void *data)
>                         ACPI_DEBUG_PRINT((ACPI_DB_INFO,
>                                           "\nReceived DEVICE CHECK notification for device\n"));
>                 if (acpi_memory_get_device(handle, &mem_device)) {
> -                       printk(KERN_ERR PREFIX "Cannot find driver data\n");
> +                       acpi_pr_err(handle, "Cannot find driver data\n");
>                         break;
>                 }
>
> @@ -361,7 +361,7 @@ static void acpi_memory_device_notify(acpi_handle handle, u32 event, void *data)
>                         break;
>
>                 if (acpi_memory_enable_device(mem_device)) {
> -                       pr_err(PREFIX "Cannot enable memory device\n");
> +                       acpi_pr_err(handle, "Cannot enable memory device\n");

And here.

>                         break;
>                 }
>
> @@ -373,12 +373,12 @@ static void acpi_memory_device_notify(acpi_handle handle, u32 event, void *data)
>                                   "\nReceived EJECT REQUEST notification for device\n"));
>
>                 if (acpi_bus_get_device(handle, &device)) {
> -                       printk(KERN_ERR PREFIX "Device doesn't exist\n");
> +                       acpi_pr_err(handle, "Device doesn't exist\n");
>                         break;
>                 }
>                 mem_device = acpi_driver_data(device);
>                 if (!mem_device) {
> -                       printk(KERN_ERR PREFIX "Driver Data is NULL\n");
> +                       acpi_pr_err(handle, "Driver Data is NULL\n");

And here.

>                         break;
>                 }
>
> @@ -389,7 +389,7 @@ static void acpi_memory_device_notify(acpi_handle handle, u32 event, void *data)
>                  *      with generic sysfs driver
>                  */
>                 if (acpi_memory_disable_device(mem_device)) {
> -                       pr_err(PREFIX "Disable memory device\n");
> +                       acpi_pr_err(handle, "Disable memory device\n");

And here.  (What is this message supposed to mean, anyway?)

>                         /*
>                          * If _EJ0 was called but failed, _OST is not
>                          * necessary.
> @@ -449,7 +449,7 @@ static int acpi_memory_device_add(struct acpi_device *device)
>         /* Set the device state */
>         mem_device->state = MEMORY_POWER_ON_STATE;
>
> -       printk(KERN_DEBUG "%s \n", acpi_device_name(device));
> +       pr_debug("%s\n", acpi_device_name(device));

And here.  This message looks dubious anyway.

>
>         /*
>          * Early boot code has recognized memory area by EFI/E820.
> @@ -464,7 +464,7 @@ static int acpi_memory_device_add(struct acpi_device *device)
>                 /* call add_memory func */
>                 result = acpi_memory_enable_device(mem_device);
>                 if (result)
> -                       printk(KERN_ERR PREFIX
> +                       acpi_pr_err(device->handle,
>                                 "Error in acpi_memory_enable_device\n");

And here.

>         }
>         return result;
> --
> 1.7.7.6
>
