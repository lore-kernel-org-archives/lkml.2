Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758837Ab2FZROh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 13:14:37 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:23035 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758499Ab2FZROg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 13:14:36 -0400
Date: Tue, 26 Jun 2012 13:06:35 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Wen Congyang <wency@cn.fujitsu.com>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yasuaki ISIMATU <isimatu.yasuaki@jp.fujitsu.com>
Subject: Re: [PATCH 7/8] auto bind the memory device which is hotpluged
 before the driver is loaded
Message-ID: <20120626170635.GC21579@phenom.dumpdata.com>
References: <4FE97DD5.6030205@cn.fujitsu.com>
 <4FE97F60.90101@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FE97F60.90101@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2012 at 05:22:40PM +0800, Wen Congyang wrote:
> If the memory device is hotpluged before the driver is loaded, the
> user cannot see this device under the directory /sys/bus/acpi/devices/,
> and the user cannot bind it by hand after the driver is loaded.

Why not? Can the user rmmod acpi_memhotplug and modprobe it?

> This patch introduces a new feature to bind such device when is driver

s/when is/when the/
> is being loaded.
> 
> Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
> ---
>  drivers/acpi/acpi_memhotplug.c |   37 ++++++++++++++++++++++++++++++++++++-
>  1 files changed, 36 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
> index 148c88a..a682657 100644
> --- a/drivers/acpi/acpi_memhotplug.c
> +++ b/drivers/acpi/acpi_memhotplug.c
> @@ -52,6 +52,9 @@ MODULE_LICENSE("GPL");
>  #define MEMORY_POWER_ON_STATE	1
>  #define MEMORY_POWER_OFF_STATE	2
>  
> +static bool auto_probe;
> +module_param(auto_probe, bool, S_IRUGO | S_IWUSR);
> +
>  static int acpi_memory_device_add(struct acpi_device *device);
>  static int acpi_memory_device_remove(struct acpi_device *device, int type);
>  
> @@ -515,12 +518,44 @@ acpi_memory_register_notify_handler(acpi_handle handle,
>  				    u32 level, void *ctxt, void **retv)
>  {
>  	acpi_status status;
> -
> +	struct acpi_memory_device *mem_device = NULL;
> +	unsigned long long current_status;

Can it just be unsigned long?

>  
>  	status = is_memory_device(handle);
>  	if (ACPI_FAILURE(status))
>  		return AE_OK;	/* continue */
>  
> +	if (auto_probe) {
> +		if (acpi_memory_get_device(handle, &mem_device))
> +			goto install;
> +
> +		/* Get device present/absent information from the _STA */
> +		status = acpi_evaluate_integer(mem_device->device->handle,
> +					       "_STA", NULL, &current_status);
> +		if (ACPI_FAILURE(status))
> +			goto install;
> +
> +		/*
> +		 * Check for device status. Device should be
> +		 * present/enabled/functioning.
> +		 */
> +		if (!((current_status & ACPI_STA_DEVICE_PRESENT)
> +		      && (current_status & ACPI_STA_DEVICE_ENABLED)
> +		      && (current_status & ACPI_STA_DEVICE_FUNCTIONING)))

Can you make this:
	!(current_status & (ACPI_STA_DEVICE_PRESENT | ACPI_STA_DEVICE_ENABLED | ACPI_STA_DEVICE_FUNCTIONING))

instead?
> +			goto install;
> +
> +		/* We have bound this device while we register the dirver */

driver.
> +		if (mem_device->state == MEMORY_POWER_ON_STATE)
> +			goto install;
> +
> +		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
> +				  "\nauto probe memory device\n"));
> +
> +		if (acpi_memory_enable_device(mem_device))
> +			pr_err(PREFIX "Cannot enable memory device\n");

Would it be prudent to provide more information? Like which device could
not be enabled? And perhaps the reason why it could not be enabled?

> +	}
> +
> +install:
>  	status = acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
>  					     acpi_memory_device_notify, NULL);
>  	/* continue */
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
