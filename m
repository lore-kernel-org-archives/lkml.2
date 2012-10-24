Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030211Ab2JXRWL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 13:22:11 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:31179 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758654Ab2JXRWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 13:22:08 -0400
Message-ID: <1351098875.19172.21.camel@misato.fc.hp.com>
Subject: Re: [PATCH v2 2/2] Improve container_notify_cb() to support
 container hot-remove.
From: Toshi Kani <toshi.kani@hp.com>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: yinghai@kernel.org, bhelgaas@google.com, lenb@kernel.org,
        jiang.liu@huawei.com, izumi.taku@jp.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, mihailm@parallels.com,
        linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 24 Oct 2012 11:14:35 -0600
In-Reply-To: <1351058750-4275-3-git-send-email-tangchen@cn.fujitsu.com>
References: <1351058750-4275-1-git-send-email-tangchen@cn.fujitsu.com>
	 <1351058750-4275-3-git-send-email-tangchen@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-24 at 14:05 +0800, Tang Chen wrote:
> This patch introduces a new function container_device_remove() to do
> the container hot-remove job. It works like the following:
> 
> 1. call acpi_bus_trim(device, 0) to stop the container device.
> 2. generate the KOBJ_OFFLINE uevent. (Did I do this correct ?)
> 3. call acpi_bus_hot_remove_device(), which will call acpi_bus_trim(device, 1)
>    to remove the container.
> 
> This patch is based on Lu Yinghai's work.
> git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-pci-split-pci-root-hp-2
> 
> Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
> ---
>  drivers/acpi/container.c |   58 ++++++++++++++++++++++++++++++++++++++-------
>  1 files changed, 49 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/acpi/container.c b/drivers/acpi/container.c
> index d300e03..9676578 100644
> --- a/drivers/acpi/container.c
> +++ b/drivers/acpi/container.c
> @@ -166,6 +166,35 @@ static int container_device_add(struct acpi_device **device, acpi_handle handle)
>  	return result;
>  }
>  
> +static int container_device_remove(struct acpi_device *device)
> +{
> +	int ret;
> +	struct acpi_eject_event *ej_event;
> +
> +	/* stop container device at first */
> +	ret = acpi_bus_trim(device, 0);

Hi Tang,

Why do you need to call acpi_bus_trim(device,0) to stop the container
device first?

> +	printk(KERN_WARNING "acpi_bus_trim stop return %x\n", ret);

Do you need this message in the normal case?  If so, I'd suggest to use
pr_debug().

> +	if (ret)
> +		return ret;
> +
> +	/* event originated from ACPI eject notification */
> +	device->flags.eject_pending = 1;

You do not need to set the eject_pending flag when the handler calls
acpi_bus_hot_remove_device().  It was set before because the handler did
not initiate the hot-remove operation.

> +
> +	/* send the uevent before remove the device */
> +	kobject_uevent(&device->dev.kobj, KOBJ_OFFLINE);
> +
> +	ej_event = kmalloc(sizeof(*ej_event), GFP_KERNEL);
> +	if (!ej_event)
> +		return -ENOMEM;
> +
> +	ej_event->device = device;
> +	ej_event->event = ACPI_NOTIFY_EJECT_REQUEST;
> +
> +	acpi_bus_hot_remove_device(ej_event);
> +
> +	return 0;
> +}
> +
>  static void __container_notify_cb(struct work_struct *work)
>  {
>  	struct acpi_device *device = NULL;
> @@ -181,6 +210,9 @@ static void __container_notify_cb(struct work_struct *work)
>  	handle = hp_work->handle;
>  	type = hp_work->type;
>  
> +	present = is_device_present(handle);
> +	status = acpi_bus_get_device(handle, &device);
> +
>  	switch (type) {
>  	case ACPI_NOTIFY_BUS_CHECK:
>  		/* Fall through */
> @@ -189,13 +221,14 @@ static void __container_notify_cb(struct work_struct *work)
>  		       (type == ACPI_NOTIFY_BUS_CHECK) ?
>  		       "ACPI_NOTIFY_BUS_CHECK" : "ACPI_NOTIFY_DEVICE_CHECK");
>  
> -		present = is_device_present(handle);
> -		status = acpi_bus_get_device(handle, &device);
>  		if (!present) {
>  			if (ACPI_SUCCESS(status)) {
>  				/* device exist and this is a remove request */
> -				device->flags.eject_pending = 1;
> -				kobject_uevent(&device->dev.kobj, KOBJ_OFFLINE);
> +				result = container_device_remove(device);
> +				if (result) {
> +					printk(KERN_WARNING "Failed to remove container\n");
> +					break;
> +				}
>  				return;
>  			}
>  			break;
> @@ -215,12 +248,19 @@ static void __container_notify_cb(struct work_struct *work)
>  		break;
>  
>  	case ACPI_NOTIFY_EJECT_REQUEST:
> -		if (!acpi_bus_get_device(handle, &device) && device) {
> -			device->flags.eject_pending = 1;
> -			kobject_uevent(&device->dev.kobj, KOBJ_OFFLINE);
> -			return;
> +		printk(KERN_WARNING "Container driver received %s event\n",
> +			"ACPI_NOTIFY_EJECT_REQUEST");

Same as other comment.  Suggest to use pr_debug().

> +
> +		if (!present || ACPI_FAILURE(status) || !device)
> +			break;
> +
> +		result = container_device_remove(device);
> +		if (result) {
> +			printk(KERN_WARNING "Failed to remove container\n");

Please use pr_warn().

Thanks,
-Toshi

> +			break;
>  		}
> -		break;
> +
> +		return;
>  
>  	default:
>  		/* non-hotplug event; possibly handled by other handler */


