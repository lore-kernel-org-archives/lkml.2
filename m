Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183Ab2DWTqY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 15:46:24 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:60480 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752397Ab2DWTqT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 15:46:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Aaron Lu <aaron.lu@amd.com>
Subject: Re: [PATCH] ACPI: evaluate _PS3 when entering D3 Cold
Date: Mon, 23 Apr 2012 21:50:57 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: Len Brown <lenb@kernel.org>, Lin Ming <ming.m.lin@intel.com>,
        linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        Andiry Xu <andiry.xu@amd.com>, Alex He <alex.he@amd.com>
References: <1333217910-29579-1-git-send-email-aaron.lu@amd.com> <201204231343.03382.rjw@sisk.pl> <20120423151327.GA4019@fedora>
In-Reply-To: <20120423151327.GA4019@fedora>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201204232150.57812.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 23, 2012, Aaron Lu wrote:
> On Mon, Apr 23, 2012 at 01:43:03PM +0200, Rafael J. Wysocki wrote:
> > On Monday, April 23, 2012, Aaron Lu wrote:
> > > Hi Rafael and Ming,
> > > 
> > > Do you have any more comments on this patch?
> > > If not, can I have your ack? Thanks.
> > > 
> > > -Aaron
> > > 
> > > On Sun, Apr 01, 2012 at 02:18:30AM +0800, Aaron Lu wrote:
> > > > When entering D3 Cold from a higher device state, evaluate _PS3 first
> > > > and then make the proper power transition.
> > > > This is used to solve the ZPODD problem on AMD's platform, _PS3 on such
> > > > platforms will power off the ODD device and thus make the device enter
> > > > D3 cold state.
> > > > 
> > > > Signed-off-by: Aaron Lu <aaron.lu@amd.com>
> > > > Cc: Andiry Xu <andiry.xu@amd.com>
> > > > Cc: Alex He <alex.he@amd.com>
> > > > ---
> > > >  drivers/acpi/bus.c |   17 ++++++++++++++---
> > > >  1 file changed, 14 insertions(+), 3 deletions(-)
> > > > 
> > > > diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
> > > > index 3263b68..68e593f 100644
> > > > --- a/drivers/acpi/bus.c
> > > > +++ b/drivers/acpi/bus.c
> > > > @@ -227,6 +227,8 @@ static int __acpi_bus_set_power(struct acpi_device *device, int state)
> > > >  	int result = 0;
> > > >  	acpi_status status = AE_OK;
> > > >  	char object_name[5] = { '_', 'P', 'S', '0' + state, '\0' };
> > > > +	struct acpi_device_power_state *ps;
> > > > +	u8 explicit_set;
> > > >  
> > > >  	if (!device || (state < ACPI_STATE_D0) || (state > ACPI_STATE_D3_COLD))
> > > >  		return -EINVAL;
> > > > @@ -239,7 +241,8 @@ static int __acpi_bus_set_power(struct acpi_device *device, int state)
> > > >  		return 0;
> > > >  	}
> > > >  
> > > > -	if (!device->power.states[state].flags.valid) {
> > > > +	ps = &device->power.states[state];
> > > > +	if (!ps->flags.valid) {
> > > >  		printk(KERN_WARNING PREFIX "Device does not support D%d\n", state);
> > > >  		return -ENODEV;
> > > >  	}
> > > > @@ -263,7 +266,7 @@ static int __acpi_bus_set_power(struct acpi_device *device, int state)
> > > >  			if (result)
> > > >  				goto end;
> > > >  		}
> > > > -		if (device->power.states[state].flags.explicit_set) {
> > > > +		if (ps->flags.explicit_set) {
> > > >  			status = acpi_evaluate_object(device->handle,
> > > >  						      object_name, NULL, NULL);
> > > >  			if (ACPI_FAILURE(status)) {
> > > > @@ -272,7 +275,15 @@ static int __acpi_bus_set_power(struct acpi_device *device, int state)
> > > >  			}
> > > >  		}
> > > >  	} else {
> > > > -		if (device->power.states[state].flags.explicit_set) {
> > > > +		/* If state is D3 Cold, try to evaluate _PS3 first */
> > > > +		if (state == ACPI_STATE_D3_COLD) {
> > > > +			explicit_set = (ps - 1)->flags.explicit_set;
> > > > +			object_name[3] -= 1;
> > > > +		}
> > > > +		else {
> > > > +			explicit_set = ps->flags.explicit_set;
> > > > +		}
> > 
> > I really don't like this.  I think you should modify acpi_bus_get_power_flags(),
> > on top of the recent Lin Ming's patch, so that it sets flags.explicit_set for
> > D3_COLD if _PS3 is present and _PR3 is not.
> > 
> 
> Thanks for your comments.
> 
> > I'm not sure you'll need the $subject patch any more then.
> > 
> 
> A little change is still required. I attached the code below.
> BTW, I think _PS3 will also need be executed if both _PS3 and _PR3
> available when putting a device into D3cold.

Yes, ACPI 5.0 seems to indicate so at least.

> diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
> index 3263b68..187433f 100644
> --- a/drivers/acpi/bus.c
> +++ b/drivers/acpi/bus.c
> @@ -273,6 +273,9 @@ static int __acpi_bus_set_power(struct acpi_device *device, int state)
>  		}
>  	} else {
>  		if (device->power.states[state].flags.explicit_set) {
> +			/* evaluate _PS3 instead of _PS4 when entering D3Cold */
> +			if (state == ACPI_STATE_D3)
> +				object_name[3] -= 1;

Can you just put '3' here directly?  That'll be much cleaner than the
subtraction (that could have been -- as well).

>  			status = acpi_evaluate_object(device->handle,
>  						      object_name, NULL, NULL);
>  			if (ACPI_FAILURE(status)) {
> diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> index 7417267..de2ae10 100644
> --- a/drivers/acpi/scan.c
> +++ b/drivers/acpi/scan.c
> @@ -887,8 +887,12 @@ static int acpi_bus_get_power_flags(struct acpi_device *device)
>  		/* Evaluate "_PSx" to see if we can do explicit sets */
>  		object_name[2] = 'S';
>  		status = acpi_get_handle(device->handle, object_name, &handle);
> -		if (ACPI_SUCCESS(status))
> +		if (ACPI_SUCCESS(status)) {
>  			ps->flags.explicit_set = 1;
> +			/* Also set D3Cold's explicit flag when _PS3 exists */
> +			if (i == ACPI_STATE_D3_HOT)
> +				(ps+1)->flags.explicit_set = 1;

Please don't use pointer arithmetics here.  I know it _happens_ to work,
but I don't think it's appropriate in this situation at all.

> +		}
>  
>  		/*
>  		 * State is valid if there are means to put the device into it.

Thanks,
Rafael
