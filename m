Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186Ab0IQWiQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 18:38:16 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:4225 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754380Ab0IQWiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 18:38:15 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 1/2] PNPACPI: cope with invalid device IDs
Date: Fri, 17 Sep 2010 16:37:31 -0600
User-Agent: KMail/1.13.2 (Linux/2.6.32-24-generic; KDE/4.4.2; x86_64; ; )
Cc: Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>
References: <20100605022058.25768.77560.stgit@localhost.localdomain> <20100605022404.25768.77841.stgit@localhost.localdomain>
In-Reply-To: <20100605022404.25768.77841.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201009171637.32127.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 04, 2010 08:24:04 pm Dmitry Torokhov wrote:
> If primary ID (HID) is invalid try locating first valid ID on compatible
> ID list before giving up.
> 
> This helps, for example, to recognize i8042 AUX port on Sony Vaio VPCZ1
> which uses SNYSYN0003 as HID. Without the patch users are forced to
> boot with i8042.nopnp to make use of their touchpads.

Sorry, we seem to have dropped the ball on this.  Looking at it again,
I have another question below:

>  drivers/pnp/pnpacpi/core.c |   29 ++++++++++++++++++++++++-----
>  1 files changed, 24 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/pnp/pnpacpi/core.c b/drivers/pnp/pnpacpi/core.c
> index f7ff628..2029cb5 100644
> --- a/drivers/pnp/pnpacpi/core.c
> +++ b/drivers/pnp/pnpacpi/core.c
> @@ -28,7 +28,7 @@
>  #include "../base.h"
>  #include "pnpacpi.h"
>  
> -static int num = 0;
> +static int num;
>  
>  /* We need only to blacklist devices that have already an acpi driver that
>   * can't use pnp layer. We don't need to blacklist device that are directly
> @@ -157,11 +157,24 @@ struct pnp_protocol pnpacpi_protocol = {
>  };
>  EXPORT_SYMBOL(pnpacpi_protocol);
>  
> +static char *pnpacpi_get_id(struct acpi_device *device)
> +{
> +	struct acpi_hardware_id *id;
> +
> +	list_for_each_entry(id, &device->pnp.ids, list) {
> +		if (ispnpidacpi(id->id))
> +			return id->id;
> +	}
> +
> +	return NULL;
> +}
> +
>  static int __init pnpacpi_add_device(struct acpi_device *device)
>  {
>  	acpi_handle temp = NULL;
>  	acpi_status status;
>  	struct pnp_dev *dev;
> +	char *pnpid;
>  	struct acpi_hardware_id *id;
>  
>  	/*
> @@ -169,11 +182,17 @@ static int __init pnpacpi_add_device(struct acpi_device *device)
>  	 * driver should not be loaded.
>  	 */
>  	status = acpi_get_handle(device->handle, "_CRS", &temp);
> -	if (ACPI_FAILURE(status) || !ispnpidacpi(acpi_device_hid(device)) ||
> -	    is_exclusive_device(device) || (!device->status.present))
> +	if (ACPI_FAILURE(status))
> +		return 0;
> +
> +	pnpid = pnpacpi_get_id(device);
> +	if (!pnpid)
> +		return 0;
> +
> +	if (!is_exclusive_device(device) || !device->status.present)
>  		return 0;

Doesn't this change the sense of the is_exclusive_device() test?

Looks good to me otherwise.

Bjorn

> -	dev = pnp_alloc_dev(&pnpacpi_protocol, num, acpi_device_hid(device));
> +	dev = pnp_alloc_dev(&pnpacpi_protocol, num, pnpid);
>  	if (!dev)
>  		return -ENOMEM;
>  
> @@ -204,7 +223,7 @@ static int __init pnpacpi_add_device(struct acpi_device *device)
>  		pnpacpi_parse_resource_option_data(dev);
>  
>  	list_for_each_entry(id, &device->pnp.ids, list) {
> -		if (!strcmp(id->id, acpi_device_hid(device)))
> +		if (!strcmp(id->id, pnpid))
>  			continue;
>  		if (!ispnpidacpi(id->id))
>  			continue;
> 
> 
