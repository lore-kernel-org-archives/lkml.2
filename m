Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932307Ab0FDRXw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 13:23:52 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:16543 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756553Ab0FDRXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 13:23:50 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH] PNPACPI: cope with invalid device IDs
Date: Fri, 4 Jun 2010 11:23:22 -0600
User-Agent: KMail/1.13.2 (Linux/2.6.32-22-generic; KDE/4.4.2; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, Len Brown <lenb@kernel.org>
References: <20100604080432.16068.31159.stgit@localhost.localdomain>
In-Reply-To: <20100604080432.16068.31159.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201006041123.25141.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 04, 2010 02:04:32 am Dmitry Torokhov wrote:
> If primary ID (HID) is invalid try locating first valid ID on compatible
> ID list before giving up. This helps, for example, to recognize i8042 AUX
> port on Sony Vaio VPCZ1 which uses SNYSYN0003 as HID.

Is there a bugzilla report or mailing list discussion you could point
to here (in the changelog)?

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

Unrelated change, but OK by me :-)

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

This part (run ispnpidacpi() on all _HIDs & _CIDs, not just on _HID,
so we'll now build a PNPACPI device for things with an invalid _HID
but a valid _CID) makes sense to me and is probably required for the
i8042 PNP driver to claim the device.

> +
> +	if (!is_exclusive_device(device) || !device->status.present)
>  		return 0;
>  
> -	dev = pnp_alloc_dev(&pnpacpi_protocol, num, acpi_device_hid(device));
> +	dev = pnp_alloc_dev(&pnpacpi_protocol, num, pnpid);

I'm curious about this part.  Does it fix something?

Let's say this device has _HID=SNYSYN0003, _CID=PNP0F13.

Previously, we didn't make a PNP device at all because SNYSYN0003 is
invalid.  Now, we'll make a device, exclude SNYSYN0003 from the PNP ID
list, and it looks like the loop farther down will add PNP0f13 again,
so we'll end up with "PNP0f13 PNP0f13" (I think I mentioned this when
reviewing an earlier version of the patch :-)).

With the original pnp_alloc_dev(acpi_device_hid()) call, we'll probably
end up with "SNYsyn0 PNP0f13".  That's clearly wrong, too.

For now, I think the best fix is to keep this pnp_alloc_dev() call change
and adjust the loop so it doesn't add "pnpid" again, so we end up with
just "PNP0f13".

In the long term, I wonder if it'd be better to quit checking the ID for
validity and make pnp_id.id a pointer rather than an array, so we could
have "SNYSYN0003 PNP0f13" as PNP IDs for this device.  I bet that's what
Windows does. 

Bjorn
