Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837Ab0IRRLR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 13:11:17 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:55333 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753066Ab0IRRLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 13:11:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=k3VVRQpxCePUq7waQ4iDx/KUcKbrjx1qKACbhnlwyMaig+D2aHZWWlyl5hwWYBtRuB
         ns1M+oXdEOmSQAS7FRhWntQqLGFyTE9PSCENAtYK2hDGE+iYOEr+V12rVkyLNT1PvPqd
         VgSgSB5Iw7ugDz6Bk8GIIIMyFnFMkzpdJJsPA=
Date: Sat, 18 Sep 2010 10:11:09 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH 1/2] PNPACPI: cope with invalid device IDs
Message-ID: <20100918171109.GA6563@core.coreip.homeip.net>
References: <20100605022058.25768.77560.stgit@localhost.localdomain>
 <201009171637.32127.bjorn.helgaas@hp.com>
 <201009171549.42276.dmitry.torokhov@gmail.com>
 <201009171656.11239.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201009171656.11239.bjorn.helgaas@hp.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 17, 2010 at 04:56:08PM -0600, Bjorn Helgaas wrote:
> On Friday, September 17, 2010 04:49:39 pm Dmitry Torokhov wrote:
> > On Friday, September 17, 2010 03:37:31 pm Bjorn Helgaas wrote:
> > > On Friday, June 04, 2010 08:24:04 pm Dmitry Torokhov wrote:
> > > > If primary ID (HID) is invalid try locating first valid ID on compatible
> > > > ID list before giving up.
> > > > 
> > > > This helps, for example, to recognize i8042 AUX port on Sony Vaio VPCZ1
> > > > which uses SNYSYN0003 as HID. Without the patch users are forced to
> > > > boot with i8042.nopnp to make use of their touchpads.
> > > 
> > > Sorry, we seem to have dropped the ball on this.  Looking at it again,
> > > 
> > > I have another question below:
> > > >  drivers/pnp/pnpacpi/core.c |   29 ++++++++++++++++++++++++-----
> > > >  1 files changed, 24 insertions(+), 5 deletions(-)
> > > > 
> > > > diff --git a/drivers/pnp/pnpacpi/core.c b/drivers/pnp/pnpacpi/core.c
> > > > index f7ff628..2029cb5 100644
> > > > --- a/drivers/pnp/pnpacpi/core.c
> > > > +++ b/drivers/pnp/pnpacpi/core.c
> > > > @@ -28,7 +28,7 @@
> > > > 
> > > >  #include "../base.h"
> > > >  #include "pnpacpi.h"
> > > > 
> > > > -static int num = 0;
> > > > +static int num;
> > > > 
> > > >  /* We need only to blacklist devices that have already an acpi driver
> > > >  that
> > > >  
> > > >   * can't use pnp layer. We don't need to blacklist device that are
> > > >   directly
> > > > 
> > > > @@ -157,11 +157,24 @@ struct pnp_protocol pnpacpi_protocol = {
> > > > 
> > > >  };
> > > >  EXPORT_SYMBOL(pnpacpi_protocol);
> > > > 
> > > > +static char *pnpacpi_get_id(struct acpi_device *device)
> > > > +{
> > > > +	struct acpi_hardware_id *id;
> > > > +
> > > > +	list_for_each_entry(id, &device->pnp.ids, list) {
> > > > +		if (ispnpidacpi(id->id))
> > > > +			return id->id;
> > > > +	}
> > > > +
> > > > +	return NULL;
> > > > +}
> > > > +
> > > > 
> > > >  static int __init pnpacpi_add_device(struct acpi_device *device)
> > > >  {
> > > >  
> > > >  	acpi_handle temp = NULL;
> > > >  	acpi_status status;
> > > >  	struct pnp_dev *dev;
> > > > 
> > > > +	char *pnpid;
> > > > 
> > > >  	struct acpi_hardware_id *id;
> > > >  	
> > > >  	/*
> > > > 
> > > > @@ -169,11 +182,17 @@ static int __init pnpacpi_add_device(struct
> > > > acpi_device *device)
> > > > 
> > > >  	 * driver should not be loaded.
> > > >  	 */
> > > >  	
> > > >  	status = acpi_get_handle(device->handle, "_CRS", &temp);
> > > > 
> > > > -	if (ACPI_FAILURE(status) || !ispnpidacpi(acpi_device_hid(device)) ||
> > > > -	    is_exclusive_device(device) || (!device->status.present))
> > > > +	if (ACPI_FAILURE(status))
> > > > +		return 0;
> > > > +
> > > > +	pnpid = pnpacpi_get_id(device);
> > > > +	if (!pnpid)
> > > > +		return 0;
> > > > +
> > > > +	if (!is_exclusive_device(device) || !device->status.present)
> > > > 
> > > >  		return 0;
> > > 
> > > Doesn't this change the sense of the is_exclusive_device() test?
> > 
> > Yes, it does, "!" shoudl be dropped.
> > 
> > OTOH maybe we should keep the "primary" ID as is (so SYNSYN0003 would
> > still be _the_ id) but only refuse device if none of it's IDs (neither
> > _HID nor _CID) satisfy ispnpidacpi() requirements.
> 
> I think we *should* keep the entire SYNSYN0003 ID, but I don't think
> we currently can because we use a fixed-length array to store it.
> I haven't had time or motivation to fix that yet.
> 

Ah, right...

> Do you want to post an update fixing the is_exclusive_device() thing?
> 

Here it is.

-- 
Dmitry


PNPACPI: cope with invalid device IDs

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

If primary ID (HID) is invalid try locating first valid ID on compatible
ID list before giving up.

This helps, for example, to recognize i8042 AUX port on Sony Vaio VPCZ1
which uses SNYSYN0003 as HID. Without the patch users are forced to
boot with i8042.nopnp to make use of their touchpads.

Tested-by: Jan-Hendrik Zab <jan@jhz.name>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/pnp/pnpacpi/core.c |   29 ++++++++++++++++++++++++-----
 1 files changed, 24 insertions(+), 5 deletions(-)


diff --git a/drivers/pnp/pnpacpi/core.c b/drivers/pnp/pnpacpi/core.c
index dc4e32e..0d943ee 100644
--- a/drivers/pnp/pnpacpi/core.c
+++ b/drivers/pnp/pnpacpi/core.c
@@ -28,7 +28,7 @@
 #include "../base.h"
 #include "pnpacpi.h"
 
-static int num = 0;
+static int num;
 
 /* We need only to blacklist devices that have already an acpi driver that
  * can't use pnp layer. We don't need to blacklist device that are directly
@@ -180,11 +180,24 @@ struct pnp_protocol pnpacpi_protocol = {
 };
 EXPORT_SYMBOL(pnpacpi_protocol);
 
+static char *pnpacpi_get_id(struct acpi_device *device)
+{
+	struct acpi_hardware_id *id;
+
+	list_for_each_entry(id, &device->pnp.ids, list) {
+		if (ispnpidacpi(id->id))
+			return id->id;
+	}
+
+	return NULL;
+}
+
 static int __init pnpacpi_add_device(struct acpi_device *device)
 {
 	acpi_handle temp = NULL;
 	acpi_status status;
 	struct pnp_dev *dev;
+	char *pnpid;
 	struct acpi_hardware_id *id;
 
 	/*
@@ -192,11 +205,17 @@ static int __init pnpacpi_add_device(struct acpi_device *device)
 	 * driver should not be loaded.
 	 */
 	status = acpi_get_handle(device->handle, "_CRS", &temp);
-	if (ACPI_FAILURE(status) || !ispnpidacpi(acpi_device_hid(device)) ||
-	    is_exclusive_device(device) || (!device->status.present))
+	if (ACPI_FAILURE(status))
+		return 0;
+
+	pnpid = pnpacpi_get_id(device);
+	if (!pnpid)
+		return 0;
+
+	if (is_exclusive_device(device) || !device->status.present)
 		return 0;
 
-	dev = pnp_alloc_dev(&pnpacpi_protocol, num, acpi_device_hid(device));
+	dev = pnp_alloc_dev(&pnpacpi_protocol, num, pnpid);
 	if (!dev)
 		return -ENOMEM;
 
@@ -227,7 +246,7 @@ static int __init pnpacpi_add_device(struct acpi_device *device)
 		pnpacpi_parse_resource_option_data(dev);
 
 	list_for_each_entry(id, &device->pnp.ids, list) {
-		if (!strcmp(id->id, acpi_device_hid(device)))
+		if (!strcmp(id->id, pnpid))
 			continue;
 		if (!ispnpidacpi(id->id))
 			continue;
