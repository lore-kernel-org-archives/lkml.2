Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760938Ab2CNMcL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 08:32:11 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:62744 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759147Ab2CNMcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 08:32:08 -0400
X-IronPort-AV: E=Sophos;i="4.73,583,1325458800"; 
   d="scan'208";a="149314178"
Date: Wed, 14 Mar 2012 13:32:06 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
cc: Julia Lawall <Julia.Lawall@lip6.fr>, Len Brown <lenb@kernel.org>,
        kernel-janitors@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Julia Lawall <julia@diku.dk>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        Venkatesh Pallipadi <venki@google.com>, trenn@suse.de,
        bhelgaas@google.com
Subject: Re: [PATCH] drivers/acpi/processor_driver.c: add missing kfree
In-Reply-To: <4F608251.9030307@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.02.1203141328530.1987@localhost6.localdomain6>
References: <1331399145-6508-1-git-send-email-Julia.Lawall@lip6.fr> <4F608251.9030307@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 14 Mar 2012, Srivatsa S. Bhat wrote:

> On 03/10/2012 10:35 PM, Julia Lawall wrote:
>
>> From: Julia Lawall <julia@diku.dk>
>>
>> The function acpi_processor_add is stored in the ops.add field of a
>> acpi_driver structure.  This function is then called in
>> acpi_bus_driver_init.  On failure, this function clears the field
>> device->driver_data, but does not free its contents.  Thus the free has to
>> be done by the add function.  In acpi_processor_add, the corresponding
>> value is pr.  This value is currently freed on failure before storing it in
>> device->driver_data, but not after.  This free is added in the error
>> handling code at the end of the function.  The static global variable
>
>
> "static global variable"?? never heard that one before ;-)
> Maybe you meant "per_cpu variable processors"..
>
>> processors is also cleared so that it does not refer to a dangling pointer.
>> processor_device_array is cleared as well.
>>
>> Signed-off-by: Julia Lawall <julia@diku.dk>
>>
>> ---
>> This is only compile tested.  In particular, I don't know if it is correct
>> to add per_cpu(processor_device_array, pr->id) = NULL;.
>
>
> No, you shouldn't set it to NULL. processor_device_array was added to check
> for buggy BIOSes and return gracefully. Check commit cd8e2b48d (and also the
> bugzilla link in that commit).
>
> To have a robust check for buggy BIOSes, we must let it be as it is, even if
> it is a stale pointer. That way we can still catch subsequent calls to this
> function with the same acpi id (because of a buggy BIOS) and take appropriate
> actions.
>
> Other than that, the patch looks good to me.

Thanks for the feedback.  Just to be clear, I should keep

+err_clear_processors:
+       per_cpu(processors, pr->id) = NULL;

and just drop:

+       per_cpu(processor_device_array, pr->id) = NULL;

julia

>
> Regards,
> Srivatsa S. Bhat
> IBM Linux Technology Center
>
>>  It has nothing to
>> do with pr, but it looks like stale information in the case of a failure.
>>
>>  drivers/acpi/processor_driver.c |   12 ++++++++----
>>  1 file changed, 8 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
>> index 2801b41..9bb0017 100644
>> --- a/drivers/acpi/processor_driver.c
>> +++ b/drivers/acpi/processor_driver.c
>> @@ -536,8 +536,8 @@ static int __cpuinit acpi_processor_add(struct acpi_device *device)
>>  		return -ENOMEM;
>>
>>  	if (!zalloc_cpumask_var(&pr->throttling.shared_cpu_map, GFP_KERNEL)) {
>> -		kfree(pr);
>> -		return -ENOMEM;
>> +		result = -ENOMEM;
>> +		goto err_free_pr;
>>  	}
>>
>>  	pr->handle = device->handle;
>> @@ -577,7 +577,7 @@ static int __cpuinit acpi_processor_add(struct acpi_device *device)
>>  	dev = get_cpu_device(pr->id);
>>  	if (sysfs_create_link(&device->dev.kobj, &dev->kobj, "sysdev")) {
>>  		result = -EFAULT;
>> -		goto err_free_cpumask;
>> +		goto err_clear_processors;
>>  	}
>>
>>  	/*
>> @@ -595,9 +595,13 @@ static int __cpuinit acpi_processor_add(struct acpi_device *device)
>>
>>  err_remove_sysfs:
>>  	sysfs_remove_link(&device->dev.kobj, "sysdev");
>> +err_clear_processors:
>> +	per_cpu(processors, pr->id) = NULL;
>> +	per_cpu(processor_device_array, pr->id) = NULL;
>>  err_free_cpumask:
>>  	free_cpumask_var(pr->throttling.shared_cpu_map);
>> -
>> +err_free_pr:
>> +	kfree(pr);
>>  	return result;
>>  }
>>
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
