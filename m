Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566Ab0FDRIY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 13:08:24 -0400
Received: from vms173019pub.verizon.net ([206.46.173.19]:54249 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756486Ab0FDRIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 13:08:21 -0400
Date: Fri, 04 Jun 2010 13:07:15 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH] PNPACPI: cope with invalid device IDs
In-reply-to: <20100604080432.16068.31159.stgit@localhost.localdomain>
Message-id: <alpine.LFD.2.00.1006041306230.4073@localhost.localdomain>
References: <20100604080432.16068.31159.stgit@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

applied to acpi-test

thanks,
Len Brown, Intel Open Source Technology Center

On Fri, 4 Jun 2010, Dmitry Torokhov wrote:

> If primary ID (HID) is invalid try locating first valid ID on compatible
> ID list before giving up. This helps, for example, to recognize i8042 AUX
> port on Sony Vaio VPCZ1 which uses SNYSYN0003 as HID.
> 
> Tested-by: Jan-Hendrik Zab <jan@jhz.name>
> Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
> ---
> 
>  drivers/pnp/pnpacpi/core.c |   27 +++++++++++++++++++++++----
>  1 files changed, 23 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/pnp/pnpacpi/core.c b/drivers/pnp/pnpacpi/core.c
> index f7ff628..1bf1677 100644
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
>  
> -	dev = pnp_alloc_dev(&pnpacpi_protocol, num, acpi_device_hid(device));
> +	dev = pnp_alloc_dev(&pnpacpi_protocol, num, pnpid);
>  	if (!dev)
>  		return -ENOMEM;
>  
> 
