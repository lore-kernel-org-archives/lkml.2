Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750897Ab2F0EKy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 00:10:54 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54626 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714Ab2F0EKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 00:10:50 -0400
Date: Tue, 26 Jun 2012 21:10:48 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Wen Congyang <wency@cn.fujitsu.com>
cc: lenb@kernel.org, linux-acpi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yasuaki ISIMATU <isimatu.yasuaki@jp.fujitsu.com>
Subject: Re: [PATCH 1/8] fix memory leak when memory device is unbound from
 the module acpi_memhotplug
In-Reply-To: <4FE97E86.60603@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1206262108050.24245@chino.kir.corp.google.com>
References: <4FE97DD5.6030205@cn.fujitsu.com> <4FE97E86.60603@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jun 2012, Wen Congyang wrote:

> We allocate memory to store acpi_memory_info, so we should free it before
> freeing mem_device.
> 
> Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
> ---
>  drivers/acpi/acpi_memhotplug.c |   18 +++++++++++++-----
>  1 files changed, 13 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
> index d985713..f6831d1 100644
> --- a/drivers/acpi/acpi_memhotplug.c
> +++ b/drivers/acpi/acpi_memhotplug.c
> @@ -399,6 +399,18 @@ static void acpi_memory_device_notify(acpi_handle handle, u32 event, void *data)
>  	return;
>  }
>  
> +static void acpi_free_memory_device(struct acpi_memory_device *mem_device)
> +{

The function that allocates struct acpi_memory_device is 
acpi_memory_device_add(), shouldn't this be called acpi_memory_device_free()?

> +	struct acpi_memory_info *info, *n;
> +
> +	if (!mem_device)
> +		return;
> +
> +	list_for_each_entry_safe(info, n, &mem_device->res_list, list)
> +		kfree(info);

Duplicates code from acpi_memory_get_device_resources(), should be moved 
into a seperate function.

> +	kfree(mem_device);
> +}
> +
>  static int acpi_memory_device_add(struct acpi_device *device)
>  {
>  	int result;
> @@ -451,14 +463,10 @@ static int acpi_memory_device_add(struct acpi_device *device)
>  
>  static int acpi_memory_device_remove(struct acpi_device *device, int type)
>  {
> -	struct acpi_memory_device *mem_device = NULL;
> -
> -
>  	if (!device || !acpi_driver_data(device))
>  		return -EINVAL;
>  
> -	mem_device = acpi_driver_data(device);
> -	kfree(mem_device);
> +	acpi_free_memory_device(acpi_driver_data(device));
>  
>  	return 0;
>  }
