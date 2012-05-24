Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965081Ab2EXSV4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 14:21:56 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:1071 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964942Ab2EXSVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 14:21:53 -0400
Message-ID: <1337883710.2718.85.camel@lorien2>
Subject: Re: [PATCH v4 4/6] ACPI: Add _OST support for ACPI memory hotplug
From: Shuah Khan <shuahkhan@gmail.com>
Reply-To: shuahkhan@gmail.com
To: Toshi Kani <toshi.kani@hp.com>
Cc: shuahkhan@gmail.com, lenb@kernel.org, linux-acpi@vger.kernel.org,
        bhelgaas@google.com, liuj97@gmail.com, andi@firstfloor.org,
        linux-kernel@vger.kernel.org
Date: Thu, 24 May 2012 12:21:50 -0600
In-Reply-To: <1337826324-16802-5-git-send-email-toshi.kani@hp.com>
References: <1337826324-16802-1-git-send-email-toshi.kani@hp.com>
	 <1337826324-16802-5-git-send-email-toshi.kani@hp.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-23 at 20:25 -0600, Toshi Kani wrote:
> Changed acpi_memory_device_notify() to call ACPI _OST method
> when ACPI memory hotplug operation has completed.
> 
> Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> ---
>  drivers/acpi/acpi_memhotplug.c |   43 +++++++++++++++++++++++++++++----------
>  1 files changed, 32 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
> index d985713..24c807f 100644
> --- a/drivers/acpi/acpi_memhotplug.c
> +++ b/drivers/acpi/acpi_memhotplug.c
> @@ -341,7 +341,7 @@ static void acpi_memory_device_notify(acpi_handle handle, u32 event, void *data)
>  {
>  	struct acpi_memory_device *mem_device;
>  	struct acpi_device *device;
> -
> +	u32 ost_code = ACPI_OST_SC_NON_SPECIFIC_FAILURE; /* default */
>  
>  	switch (event) {
>  	case ACPI_NOTIFY_BUS_CHECK:
> @@ -354,15 +354,20 @@ static void acpi_memory_device_notify(acpi_handle handle, u32 event, void *data)
>  					  "\nReceived DEVICE CHECK notification for device\n"));
>  		if (acpi_memory_get_device(handle, &mem_device)) {
>  			printk(KERN_ERR PREFIX "Cannot find driver data\n");
> -			return;
> +			break;
>  		}
>  
> -		if (!acpi_memory_check_device(mem_device)) {
> -			if (acpi_memory_enable_device(mem_device))
> -				printk(KERN_ERR PREFIX
> -					    "Cannot enable memory device\n");
> +		if (acpi_memory_check_device(mem_device))
> +			break;
> +
> +		if (acpi_memory_enable_device(mem_device)) {
> +			printk(KERN_ERR PREFIX "Cannot enable memory device\n");
> +			break;
>  		}
> +
> +		ost_code = ACPI_OST_SC_SUCCESS;
>  		break;
> +
>  	case ACPI_NOTIFY_EJECT_REQUEST:
>  		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
>  				  "\nReceived EJECT REQUEST notification for device\n"));
> @@ -383,19 +388,35 @@ static void acpi_memory_device_notify(acpi_handle handle, u32 event, void *data)
>  		 * TBD: Can also be disabled by Callback registration
>  		 *      with generic sysfs driver
>  		 */
> -		if (acpi_memory_disable_device(mem_device))
> -			printk(KERN_ERR PREFIX
> -				    "Disable memory device\n");
> +		if (acpi_memory_disable_device(mem_device)) {
> +			printk(KERN_ERR PREFIX "Disable memory device\n");
> +			/*
> +			 * If _EJ0 was called but failed, _OST is not
> +			 * necessary.
> +			 */
> +			if (mem_device->state == MEMORY_INVALID_STATE)
> +				return;
> +
> +			break;
> +		}

Why isn't _OST called in this case to report failure? Isn't this one of
the cases Spec talks about. Reference: 6.3.5 _OST (OSPM Status
Indication) page 302.

-- Shuah

> +
>  		/*
>  		 * TBD: Invoke acpi_bus_remove to cleanup data structures
>  		 */
> -		break;
> +
> +		/* _EJ0 succeeded; _OST is not necessary */
> +		return;
> +
>  	default:
>  		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
>  				  "Unsupported event [0x%x]\n", event));
> -		break;
> +
> +		/* non-hotplug event; possibly handled by other handler */
> +		return;
>  	}
>  
> +	/* Inform firmware that the hotplug operation has completed */
> +	(void) acpi_evaluate_hotplug_ost(handle, event, ost_code, NULL);
>  	return;
>  }
>  


