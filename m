Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751219Ab2KOXcn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 18:32:43 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60934 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800Ab2KOXck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 18:32:40 -0500
Date: Thu, 15 Nov 2012 15:32:37 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Wen Congyang <wency@cn.fujitsu.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-acpi@vger.kernel.org, Len Brown <len.brown@intel.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jiang Liu <jiang.liu@huawei.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mgorman@suse.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Toshi Kani <toshi.kani@hp.com>, Jiang Liu <liuj97@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Christoph Lameter <cl@linux.com>
Subject: Re: [Patch v5 2/7] acpi,memory-hotplug: deal with eject request in
 hotplug queue
In-Reply-To: <1352962777-24407-3-git-send-email-wency@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1211151531310.27188@chino.kir.corp.google.com>
References: <1352962777-24407-1-git-send-email-wency@cn.fujitsu.com> <1352962777-24407-3-git-send-email-wency@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Nov 2012, Wen Congyang wrote:

> The memory device can be removed by 2 ways:
> 1. send eject request by SCI
> 2. echo 1 >/sys/bus/pci/devices/PNP0C80:XX/eject
> 
> We handle the 1st case in the module acpi_memhotplug, and handle
> the 2nd case in ACPI eject notification. This 2 events may happen
> at the same time, so we may touch acpi_memory_device.res_list at
> the same time. This patch reimplements memory-hotremove support
> through an ACPI eject notification. Now the memory device is
> offlined and hotremoved only in the function acpi_memory_device_remove()
> which is protected by device_lock().
> 

You mean it's protected by device_lock() before calling the remove() 
function for eject?

> CC: David Rientjes <rientjes@google.com>
> CC: Jiang Liu <liuj97@gmail.com>
> CC: Len Brown <len.brown@intel.com>
> CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> CC: Paul Mackerras <paulus@samba.org>
> CC: Christoph Lameter <cl@linux.com>
> Cc: Minchan Kim <minchan.kim@gmail.com>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> CC: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> CC: Rafael J. Wysocki <rjw@sisk.pl>
> CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
> ---
>  drivers/acpi/acpi_memhotplug.c | 87 +++++-------------------------------------
>  1 file changed, 9 insertions(+), 78 deletions(-)
> 
> diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
> index 2918be1..6e12042 100644
> --- a/drivers/acpi/acpi_memhotplug.c
> +++ b/drivers/acpi/acpi_memhotplug.c
> @@ -272,40 +272,6 @@ static int acpi_memory_enable_device(struct acpi_memory_device *mem_device)
>  	return 0;
>  }
>  
> -static int acpi_memory_powerdown_device(struct acpi_memory_device *mem_device)
> -{
> -	acpi_status status;
> -	struct acpi_object_list arg_list;
> -	union acpi_object arg;
> -	unsigned long long current_status;
> -
> -
> -	/* Issue the _EJ0 command */
> -	arg_list.count = 1;
> -	arg_list.pointer = &arg;
> -	arg.type = ACPI_TYPE_INTEGER;
> -	arg.integer.value = 1;
> -	status = acpi_evaluate_object(mem_device->device->handle,
> -				      "_EJ0", &arg_list, NULL);
> -	/* Return on _EJ0 failure */
> -	if (ACPI_FAILURE(status)) {
> -		ACPI_EXCEPTION((AE_INFO, status, "_EJ0 failed"));
> -		return -ENODEV;
> -	}
> -
> -	/* Evalute _STA to check if the device is disabled */
> -	status = acpi_evaluate_integer(mem_device->device->handle, "_STA",
> -				       NULL, &current_status);
> -	if (ACPI_FAILURE(status))
> -		return -ENODEV;
> -
> -	/* Check for device status.  Device should be disabled */
> -	if (current_status & ACPI_STA_DEVICE_ENABLED)
> -		return -EINVAL;
> -
> -	return 0;
> -}
> -
>  static int acpi_memory_remove_memory(struct acpi_memory_device *mem_device)
>  {
>  	int result;
> @@ -325,34 +291,11 @@ static int acpi_memory_remove_memory(struct acpi_memory_device *mem_device)
>  	return 0;
>  }
>  
> -static int acpi_memory_disable_device(struct acpi_memory_device *mem_device)
> -{
> -	int result;
> -
> -	/*
> -	 * Ask the VM to offline this memory range.
> -	 * Note: Assume that this function returns zero on success
> -	 */
> -	result = acpi_memory_remove_memory(mem_device);
> -	if (result)
> -		return result;
> -
> -	/* Power-off and eject the device */
> -	result = acpi_memory_powerdown_device(mem_device);
> -	if (result) {
> -		/* Set the status of the device to invalid */
> -		mem_device->state = MEMORY_INVALID_STATE;
> -		return result;
> -	}
> -
> -	mem_device->state = MEMORY_POWER_OFF_STATE;
> -	return result;
> -}
> -
>  static void acpi_memory_device_notify(acpi_handle handle, u32 event, void *data)
>  {
>  	struct acpi_memory_device *mem_device;
>  	struct acpi_device *device;
> +	struct acpi_eject_event *ej_event = NULL;
>  	u32 ost_code = ACPI_OST_SC_NON_SPECIFIC_FAILURE; /* default */
>  
>  	switch (event) {
> @@ -394,31 +337,19 @@ static void acpi_memory_device_notify(acpi_handle handle, u32 event, void *data)
>  			break;
>  		}
>  
> -		/*
> -		 * Currently disabling memory device from kernel mode
> -		 * TBD: Can also be disabled from user mode scripts
> -		 * TBD: Can also be disabled by Callback registration
> -		 *      with generic sysfs driver
> -		 */
> -		if (acpi_memory_disable_device(mem_device)) {
> -			printk(KERN_ERR PREFIX "Disable memory device\n");
> -			/*
> -			 * If _EJ0 was called but failed, _OST is not
> -			 * necessary.
> -			 */
> -			if (mem_device->state == MEMORY_INVALID_STATE)
> -				return;
> -
> +		ej_event = kmalloc(sizeof(*ej_event), GFP_KERNEL);
> +		if (!ej_event) {
> +			pr_err(PREFIX "No memory, dropping EJECT\n");
>  			break;
>  		}
>  
> -		/*
> -		 * TBD: Invoke acpi_bus_remove to cleanup data structures
> -		 */
> +		ej_event->handle = handle;
> +		ej_event->event = ACPI_NOTIFY_EJECT_REQUEST;
> +		acpi_os_hotplug_execute(acpi_bus_hot_remove_device,
> +					(void *)ej_event);
>  
> -		/* _EJ0 succeeded; _OST is not necessary */
> +		/* eject is performed asynchronously */
>  		return;
> -
>  	default:
>  		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
>  				  "Unsupported event [0x%x]\n", event));
