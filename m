Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758073Ab2CNLiL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 07:38:11 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:55607 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755834Ab2CNLiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 07:38:08 -0400
Message-ID: <4F608251.9030307@linux.vnet.ibm.com>
Date: Wed, 14 Mar 2012 17:04:41 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Julia Lawall <Julia.Lawall@lip6.fr>
CC: Len Brown <lenb@kernel.org>, kernel-janitors@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Julia Lawall <julia@diku.dk>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        Venkatesh Pallipadi <venki@google.com>, trenn@suse.de,
        bhelgaas@google.com
Subject: Re: [PATCH] drivers/acpi/processor_driver.c: add missing kfree
References: <1331399145-6508-1-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1331399145-6508-1-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12031411-5816-0000-0000-000001BB5007
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/2012 10:35 PM, Julia Lawall wrote:

> From: Julia Lawall <julia@diku.dk>
> 
> The function acpi_processor_add is stored in the ops.add field of a
> acpi_driver structure.  This function is then called in
> acpi_bus_driver_init.  On failure, this function clears the field
> device->driver_data, but does not free its contents.  Thus the free has to
> be done by the add function.  In acpi_processor_add, the corresponding
> value is pr.  This value is currently freed on failure before storing it in
> device->driver_data, but not after.  This free is added in the error
> handling code at the end of the function.  The static global variable


"static global variable"?? never heard that one before ;-)
Maybe you meant "per_cpu variable processors"..

> processors is also cleared so that it does not refer to a dangling pointer.
> processor_device_array is cleared as well.
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
> This is only compile tested.  In particular, I don't know if it is correct
> to add per_cpu(processor_device_array, pr->id) = NULL;.


No, you shouldn't set it to NULL. processor_device_array was added to check
for buggy BIOSes and return gracefully. Check commit cd8e2b48d (and also the
bugzilla link in that commit).

To have a robust check for buggy BIOSes, we must let it be as it is, even if
it is a stale pointer. That way we can still catch subsequent calls to this
function with the same acpi id (because of a buggy BIOS) and take appropriate
actions.

Other than that, the patch looks good to me.

Regards,
Srivatsa S. Bhat
IBM Linux Technology Center

>  It has nothing to
> do with pr, but it looks like stale information in the case of a failure.
> 
>  drivers/acpi/processor_driver.c |   12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
> index 2801b41..9bb0017 100644
> --- a/drivers/acpi/processor_driver.c
> +++ b/drivers/acpi/processor_driver.c
> @@ -536,8 +536,8 @@ static int __cpuinit acpi_processor_add(struct acpi_device *device)
>  		return -ENOMEM;
> 
>  	if (!zalloc_cpumask_var(&pr->throttling.shared_cpu_map, GFP_KERNEL)) {
> -		kfree(pr);
> -		return -ENOMEM;
> +		result = -ENOMEM;
> +		goto err_free_pr;
>  	}
> 
>  	pr->handle = device->handle;
> @@ -577,7 +577,7 @@ static int __cpuinit acpi_processor_add(struct acpi_device *device)
>  	dev = get_cpu_device(pr->id);
>  	if (sysfs_create_link(&device->dev.kobj, &dev->kobj, "sysdev")) {
>  		result = -EFAULT;
> -		goto err_free_cpumask;
> +		goto err_clear_processors;
>  	}
> 
>  	/*
> @@ -595,9 +595,13 @@ static int __cpuinit acpi_processor_add(struct acpi_device *device)
> 
>  err_remove_sysfs:
>  	sysfs_remove_link(&device->dev.kobj, "sysdev");
> +err_clear_processors:
> +	per_cpu(processors, pr->id) = NULL;
> +	per_cpu(processor_device_array, pr->id) = NULL;
>  err_free_cpumask:
>  	free_cpumask_var(pr->throttling.shared_cpu_map);
> -
> +err_free_pr:
> +	kfree(pr);
>  	return result;
>  }
> 
> 

