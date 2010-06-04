Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121Ab0FDR6f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 13:58:35 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:55650 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265Ab0FDR6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 13:58:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TxAxaDRL9RZ7b1VDHUtxE0yg7JMn8jAQ9uqhth0cMyPm6Jp1gWPJy9ShGBllalcg2C
         x2KyBhs3LgdddRtDq4jsnaImuaUNLWtK0c8uNKjwSfDc5pWCaj7A/2QOaLmllWI1kV6R
         2QTiMEqDccbwhOpJ7I97ch0GSOh7s3VSL8qM4=
Date: Fri, 4 Jun 2010 10:58:28 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] PNPACPI: cope with invalid device IDs
Message-ID: <20100604175828.GA17135@core.coreip.homeip.net>
References: <20100604080432.16068.31159.stgit@localhost.localdomain>
 <201006041123.25141.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201006041123.25141.bjorn.helgaas@hp.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 04, 2010 at 11:23:22AM -0600, Bjorn Helgaas wrote:
> On Friday, June 04, 2010 02:04:32 am Dmitry Torokhov wrote:
> > If primary ID (HID) is invalid try locating first valid ID on compatible
> > ID list before giving up. This helps, for example, to recognize i8042 AUX
> > port on Sony Vaio VPCZ1 which uses SNYSYN0003 as HID.
> 
> Is there a bugzilla report or mailing list discussion you could point
> to here (in the changelog)?
> 
> > Tested-by: Jan-Hendrik Zab <jan@jhz.name>
> > Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
> > ---
> > 
> >  drivers/pnp/pnpacpi/core.c |   27 +++++++++++++++++++++++----
> >  1 files changed, 23 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/pnp/pnpacpi/core.c b/drivers/pnp/pnpacpi/core.c
> > index f7ff628..1bf1677 100644
> > --- a/drivers/pnp/pnpacpi/core.c
> > +++ b/drivers/pnp/pnpacpi/core.c
> > @@ -28,7 +28,7 @@
> >  #include "../base.h"
> >  #include "pnpacpi.h"
> >  
> > -static int num = 0;
> > +static int num;
> 
> Unrelated change, but OK by me :-)
> 
> >  /* We need only to blacklist devices that have already an acpi driver that
> >   * can't use pnp layer. We don't need to blacklist device that are directly
> > @@ -157,11 +157,24 @@ struct pnp_protocol pnpacpi_protocol = {
> >  };
> >  EXPORT_SYMBOL(pnpacpi_protocol);
> >  
> > +static char *pnpacpi_get_id(struct acpi_device *device)
> > +{
> > +	struct acpi_hardware_id *id;
> > +
> > +	list_for_each_entry(id, &device->pnp.ids, list) {
> > +		if (ispnpidacpi(id->id))
> > +			return id->id;
> > +	}
> > +
> > +	return NULL;
> > +}
> > +
> >  static int __init pnpacpi_add_device(struct acpi_device *device)
> >  {
> >  	acpi_handle temp = NULL;
> >  	acpi_status status;
> >  	struct pnp_dev *dev;
> > +	char *pnpid;
> >  	struct acpi_hardware_id *id;
> >  
> >  	/*
> > @@ -169,11 +182,17 @@ static int __init pnpacpi_add_device(struct acpi_device *device)
> >  	 * driver should not be loaded.
> >  	 */
> >  	status = acpi_get_handle(device->handle, "_CRS", &temp);
> > -	if (ACPI_FAILURE(status) || !ispnpidacpi(acpi_device_hid(device)) ||
> > -	    is_exclusive_device(device) || (!device->status.present))
> > +	if (ACPI_FAILURE(status))
> > +		return 0;
> > +
> > +	pnpid = pnpacpi_get_id(device);
> > +	if (!pnpid)
> > +		return 0;
> 
> This part (run ispnpidacpi() on all _HIDs & _CIDs, not just on _HID,
> so we'll now build a PNPACPI device for things with an invalid _HID
> but a valid _CID) makes sense to me and is probably required for the
> i8042 PNP driver to claim the device.
> 
> > +
> > +	if (!is_exclusive_device(device) || !device->status.present)
> >  		return 0;
> >  
> > -	dev = pnp_alloc_dev(&pnpacpi_protocol, num, acpi_device_hid(device));
> > +	dev = pnp_alloc_dev(&pnpacpi_protocol, num, pnpid);
> 
> I'm curious about this part.  Does it fix something?
> 
> Let's say this device has _HID=SNYSYN0003, _CID=PNP0F13.
> 
> Previously, we didn't make a PNP device at all because SNYSYN0003 is
> invalid.  Now, we'll make a device, exclude SNYSYN0003 from the PNP ID
> list, and it looks like the loop farther down will add PNP0f13 again,
> so we'll end up with "PNP0f13 PNP0f13" (I think I mentioned this when
> reviewing an earlier version of the patch :-)).
> 
> With the original pnp_alloc_dev(acpi_device_hid()) call, we'll probably
> end up with "SNYsyn0 PNP0f13".  That's clearly wrong, too.
> 
> For now, I think the best fix is to keep this pnp_alloc_dev() call change
> and adjust the loop so it doesn't add "pnpid" again, so we end up with
> just "PNP0f13".
>

Riiight... I remember I promised you to fix it and that is what I had in
some other patch:

@@ -223,7 +224,7 @@ static int __init pnpacpi_add_device(struct
acpi_device *device)
                pnpacpi_parse_resource_option_data(dev);
 
        list_for_each_entry(id, &device->pnp.ids, list) {
-               if (!strcmp(id->id, acpi_device_hid(device)))
+               if (!strcmp(id->id, pnpid))
                        continue;
                if (!ispnpidacpi(id->id))
                        continue;

The problem is that I forgot to fold it into the original one... I'll
fix it later tonight and resend.

> In the long term, I wonder if it'd be better to quit checking the ID for
> validity and make pnp_id.id a pointer rather than an array, so we could
> have "SNYSYN0003 PNP0f13" as PNP IDs for this device.  I bet that's what
> Windows does. 
> 

-- 
Dmitry
