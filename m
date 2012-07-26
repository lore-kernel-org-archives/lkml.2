Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271Ab2GZTXw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 15:23:52 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:49816 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670Ab2GZTXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 15:23:51 -0400
MIME-Version: 1.0
In-Reply-To: <1343257978-7085-3-git-send-email-toshi.kani@hp.com>
References: <1343257978-7085-1-git-send-email-toshi.kani@hp.com> <1343257978-7085-3-git-send-email-toshi.kani@hp.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 26 Jul 2012 13:23:29 -0600
Message-ID: <CAErSpo64rOMfLB0abck20OEyeD1V96R-yzPUDt2gHa0zo26EYw@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] ACPI: Update CPU hotplug messages
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
> Updated CPU hotplug log messages with acpi_pr_<level>(),
> dev_<level>() and pr_<level>().  Some messages are also
> changed for clarity.
>
> Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> Tested-by: Vijay Mohan Pandarathil <vijaymohan.pandarathil@hp.com>
> ---
>  drivers/acpi/processor_driver.c |   36 +++++++++++++++++++++---------------
>  1 files changed, 21 insertions(+), 15 deletions(-)
>
> diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
> index a6bdeaa..225f252 100644
> --- a/drivers/acpi/processor_driver.c
> +++ b/drivers/acpi/processor_driver.c
> @@ -282,7 +282,9 @@ static int acpi_processor_get_info(struct acpi_device *device)
>                 /* Declared with "Processor" statement; match ProcessorID */
>                 status = acpi_evaluate_object(pr->handle, NULL, NULL, &buffer);
>                 if (ACPI_FAILURE(status)) {
> -                       printk(KERN_ERR PREFIX "Evaluating processor object\n");
> +                       acpi_pr_err(pr->handle,
> +                               "Failed to evaluate processor object (0x%x)\n",
> +                               status);

This looks like it could be a dev_err().

>                         return -ENODEV;
>                 }
>
> @@ -301,8 +303,9 @@ static int acpi_processor_get_info(struct acpi_device *device)
>                 status = acpi_evaluate_integer(pr->handle, METHOD_NAME__UID,
>                                                 NULL, &value);
>                 if (ACPI_FAILURE(status)) {
> -                       printk(KERN_ERR PREFIX
> -                           "Evaluating processor _UID [%#x]\n", status);
> +                       acpi_pr_err(pr->handle,
> +                               "Failed to evaluate processor _UID (0x%x)\n",
> +                               status);

And this.

>                         return -ENODEV;
>                 }
>                 device_declaration = 1;
> @@ -345,7 +348,7 @@ static int acpi_processor_get_info(struct acpi_device *device)
>         if (!object.processor.pblk_address)
>                 ACPI_DEBUG_PRINT((ACPI_DB_INFO, "No PBLK (NULL address)\n"));
>         else if (object.processor.pblk_length != 6)
> -               printk(KERN_ERR PREFIX "Invalid PBLK length [%d]\n",
> +               acpi_pr_err(pr->handle, "Invalid PBLK length [%d]\n",

And this.

>                             object.processor.pblk_length);
>         else {
>                 pr->throttling.address = object.processor.pblk_address;
> @@ -429,8 +432,8 @@ static int acpi_cpu_soft_notify(struct notifier_block *nfb,
>                  * Initialize missing things
>                  */
>                 if (pr->flags.need_hotplug_init) {
> -                       printk(KERN_INFO "Will online and init hotplugged "
> -                              "CPU: %d\n", pr->id);
> +                       pr_info("Will online and init hotplugged CPU: %d\n",
> +                               pr->id);
>                         WARN(acpi_processor_start(pr), "Failed to start CPU:"
>                                 " %d\n", pr->id);
>                         pr->flags.need_hotplug_init = 0;
> @@ -491,14 +494,16 @@ static __ref int acpi_processor_start(struct acpi_processor *pr)
>                                    &pr->cdev->device.kobj,
>                                    "thermal_cooling");
>         if (result) {
> -               printk(KERN_ERR PREFIX "Create sysfs link\n");
> +               dev_err(&device->dev,
> +                       "Failed to create sysfs link 'thermal_cooling'\n");
>                 goto err_thermal_unregister;
>         }
>         result = sysfs_create_link(&pr->cdev->device.kobj,
>                                    &device->dev.kobj,
>                                    "device");
>         if (result) {
> -               printk(KERN_ERR PREFIX "Create sysfs link\n");
> +               dev_err(&pr->cdev->device,
> +                       "Failed to create sysfs link 'device'\n");
>                 goto err_remove_sysfs_thermal;
>         }
>
> @@ -560,8 +565,7 @@ static int __cpuinit acpi_processor_add(struct acpi_device *device)
>          */
>         if (per_cpu(processor_device_array, pr->id) != NULL &&
>             per_cpu(processor_device_array, pr->id) != device) {
> -               printk(KERN_WARNING "BIOS reported wrong ACPI id "
> -                       "for the processor\n");
> +               pr_warn("BIOS reported wrong ACPI id for the processor\n");

And this.

>                 result = -ENODEV;
>                 goto err_free_cpumask;
>         }
> @@ -715,7 +719,7 @@ static void acpi_processor_hotplug_notify(acpi_handle handle,
>
>                 result = acpi_processor_device_add(handle, &device);
>                 if (result) {
> -                       pr_err(PREFIX "Unable to add the device\n");
> +                       acpi_pr_err(handle, "Unable to add the device\n");
>                         break;
>                 }
>
> @@ -727,17 +731,19 @@ static void acpi_processor_hotplug_notify(acpi_handle handle,
>                                   "received ACPI_NOTIFY_EJECT_REQUEST\n"));
>
>                 if (acpi_bus_get_device(handle, &device)) {
> -                       pr_err(PREFIX "Device don't exist, dropping EJECT\n");
> +                       acpi_pr_err(handle,
> +                               "Device don't exist, dropping EJECT\n");
>                         break;
>                 }
>                 if (!acpi_driver_data(device)) {
> -                       pr_err(PREFIX "Driver data is NULL, dropping EJECT\n");
> +                       acpi_pr_err(handle,
> +                               "Driver data is NULL, dropping EJECT\n");

And this.

>                         break;
>                 }
>
>                 ej_event = kmalloc(sizeof(*ej_event), GFP_KERNEL);
>                 if (!ej_event) {
> -                       pr_err(PREFIX "No memory, dropping EJECT\n");
> +                       acpi_pr_err(handle, "No memory, dropping EJECT\n");

And this.

>                         break;
>                 }
>
> @@ -847,7 +853,7 @@ static acpi_status acpi_processor_hotadd_init(struct acpi_processor *pr)
>          * and do it when the CPU gets online the first time
>          * TBD: Cleanup above functions and try to do this more elegant.
>          */
> -       printk(KERN_INFO "CPU %d got hotplugged\n", pr->id);
> +       pr_info("CPU %d got hotplugged\n", pr->id);

And this.  The caller (acpi_processor_get_info()) has an acpi_device
*, so we should be able to use it here.

>         pr->flags.need_hotplug_init = 1;
>
>         return AE_OK;
> --
> 1.7.7.6
>
