Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932087Ab2JQBZ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 21:25:59 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43397 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755856Ab2JQBZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 21:25:57 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <507E090C.2070607@jp.fujitsu.com>
Date: Wed, 17 Oct 2012 10:25:32 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Toshi Kani <toshi.kani@hp.com>
CC: <linux-acpi@vger.kernel.org>, <lenb@kernel.org>,
        <linux-kernel@vger.kernel.org>, <rjw@sisk.pl>, <liuj97@gmail.com>
Subject: Re: [PATCH 1/2] ACPI: Fix stale pointer access to flags.lockable
References: <1350318870-5700-1-git-send-email-toshi.kani@hp.com>
In-Reply-To: <1350318870-5700-1-git-send-email-toshi.kani@hp.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/10/16 1:34, Toshi Kani wrote:
> During hot-remove, acpi_bus_hot_remove_device() calls ACPI _LCK
> method when device->flags.lockable is set. However, this device
> pointer is stale since the target acpi_device object has been
> already kfree'd by acpi_bus_trim().
> 
> The flags.lockable indicates whether or not this ACPI object
> implements _LCK method. Fix the stable pointer access by replacing
> it with acpi_get_handle() to check if _LCK is implemented.
> 
> Signed-off-by: Toshi Kani <toshi.kani@hp.com>

Looks good to me.
Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

> ---
>   drivers/acpi/scan.c | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> index 1fcb867..ed87f43 100644
> --- a/drivers/acpi/scan.c
> +++ b/drivers/acpi/scan.c
> @@ -97,6 +97,7 @@ void acpi_bus_hot_remove_device(void *context)
>   	struct acpi_eject_event *ej_event = (struct acpi_eject_event *) context;
>   	struct acpi_device *device;
>   	acpi_handle handle = ej_event->handle;
> +	acpi_handle temp;
>   	struct acpi_object_list arg_list;
>   	union acpi_object arg;
>   	acpi_status status = AE_OK;
> @@ -117,13 +118,16 @@ void acpi_bus_hot_remove_device(void *context)
>   		goto err_out;
>   	}
>   
> +	/* device has been freed */
> +	device = NULL;
> +
>   	/* power off device */
>   	status = acpi_evaluate_object(handle, "_PS3", NULL, NULL);
>   	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND)
>   		printk(KERN_WARNING PREFIX
>   				"Power-off device failed\n");
>   
> -	if (device->flags.lockable) {
> +	if (ACPI_SUCCESS(acpi_get_handle(handle, "_LCK", &temp))) {
>   		arg_list.count = 1;
>   		arg_list.pointer = &arg;
>   		arg.type = ACPI_TYPE_INTEGER;
> 


