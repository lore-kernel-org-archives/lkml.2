Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760964Ab2COJdB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 05:33:01 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:58997 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760636Ab2COJc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 05:32:58 -0400
Message-ID: <4F61B741.1040102@linux.vnet.ibm.com>
Date: Thu, 15 Mar 2012 15:02:49 +0530
From: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Thunderbird/3.1.16
MIME-Version: 1.0
To: Julia Lawall <Julia.Lawall@lip6.fr>
CC: Len Brown <lenb@kernel.org>, srivatsa.bhat@linux.vnet.ibm.com,
        venki@google.com, trenn@suse.de, bhelgaas@google.com,
        kernel-janitors@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/acpi/processor_driver.c: add missing kfree
References: <1331800325-14251-1-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1331800325-14251-1-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12031423-6102-0000-0000-0000010B6442
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 03/15/2012 02:02 PM, Julia Lawall wrote:

> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> The function acpi_processor_add is stored in the ops.add field of a
> acpi_driver structure.  This function is then called in
> acpi_bus_driver_init.  On failure, this function clears the field
> device->driver_data, but does not free its contents.  Thus the free has to
> be done by the add function.  In acpi_processor_add, the corresponding
> value is pr.  This value is currently freed on failure before storing it in
> device->driver_data, but not after.  This free is added in the error
> handling code at the end of the function.  The per_cpu variable
> processors is also cleared so that it does not refer to a dangling pointer.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>


Acked-by: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>

 
> ---
>  drivers/acpi/processor_driver.c |   13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
> index 2801b41..98c3648 100644
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
> +		goto err_clear_processor;
>  	}
> 
>  	/*
> @@ -595,9 +595,14 @@ static int __cpuinit acpi_processor_add(struct acpi_device *device)
> 
>  err_remove_sysfs:
>  	sysfs_remove_link(&device->dev.kobj, "sysdev");
> +err_clear_processor:
> +	/* processor_device_array is not cleared to allow checks for buggy
> +	   BIOSes */
> +	per_cpu(processors, pr->id) = NULL;
>  err_free_cpumask:
>  	free_cpumask_var(pr->throttling.shared_cpu_map);
> -
> +err_free_pr:
> +	kfree(pr);
>  	return result;
>  }
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


