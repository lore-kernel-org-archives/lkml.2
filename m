Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932533Ab2DSUfU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 16:35:20 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:53580 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932183Ab2DSUfS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 16:35:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Lin Ming <ming.m.lin@intel.com>
Subject: Re: [PATCH 1/6] ACPI: D3cold state is always valid
Date: Thu, 19 Apr 2012 22:39:54 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: huang ying <huang.ying.caritas@gmail.com>, Len Brown <lenb@kernel.og>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Zhang Rui <rui.zhang@intel.com>, Aaron Lu <aaron.lu@amd.com>
References: <1334641676-14566-1-git-send-email-ming.m.lin@intel.com> <201204191351.41875.rjw@sisk.pl> <1334849015.4067.1.camel@hp6530s>
In-Reply-To: <1334849015.4067.1.camel@hp6530s>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201204192239.55048.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, April 19, 2012, Lin Ming wrote:
> On Thu, 2012-04-19 at 13:51 +0200, Rafael J. Wysocki wrote:
> > On Thursday, April 19, 2012, huang ying wrote:
> > > On Thu, Apr 19, 2012 at 5:13 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > > On Tuesday, April 17, 2012, huang ying wrote:
> > > >> On Tue, Apr 17, 2012 at 1:47 PM, Lin Ming <ming.m.lin@intel.com> wrote:
> > > >> > ACPI_STATE_D3 actually means ACPI D3hot which is not always valid.
> > > >> > Instead, ACPI D3cold is always valid.
> > > >> >
> > > >> > Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> > > >> > ---
> > > >> >  drivers/acpi/scan.c |   11 ++---------
> > > >> >  1 files changed, 2 insertions(+), 9 deletions(-)
> > > >> >
> > > >> > diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> > > >> > index 767e2dc..fb56388 100644
> > > >> > --- a/drivers/acpi/scan.c
> > > >> > +++ b/drivers/acpi/scan.c
> > > >> > @@ -884,13 +884,6 @@ static int acpi_bus_get_power_flags(struct acpi_device *device)
> > > >> >                                acpi_bus_add_power_resource(ps->resources.handles[j]);
> > > >> >                }
> > > >> >
> > > >> > -               /* The exist of _PR3 indicates D3Cold support */
> > > >> > -               if (i == ACPI_STATE_D3) {
> > > >> > -                       status = acpi_get_handle(device->handle, object_name, &handle);
> > > >> > -                       if (ACPI_SUCCESS(status))
> > > >> > -                               device->power.states[ACPI_STATE_D3_COLD].flags.valid = 1;
> > > >> > -               }
> > > >> > -
> > > >> >                /* Evaluate "_PSx" to see if we can do explicit sets */
> > > >> >                object_name[2] = 'S';
> > > >> >                status = acpi_get_handle(device->handle, object_name, &handle);
> > > >> > @@ -908,8 +901,8 @@ static int acpi_bus_get_power_flags(struct acpi_device *device)
> > > >> >        /* Set defaults for D0 and D3 states (always valid) */
> > > >> >        device->power.states[ACPI_STATE_D0].flags.valid = 1;
> > > >> >        device->power.states[ACPI_STATE_D0].power = 100;
> > > >> > -       device->power.states[ACPI_STATE_D3].flags.valid = 1;
> > > >> > -       device->power.states[ACPI_STATE_D3].power = 0;
> > > >> > +       device->power.states[ACPI_STATE_D3_COLD].flags.valid = 1;
> > > >> > +       device->power.states[ACPI_STATE_D3_COLD].power = 0;
> > > >> >
> > > >> >        acpi_bus_init_power(device);
> > > >>
> > > >> I think D3_HOT should be always valid, while D3_COLD should be valid
> > > >> for some situation.
> > > >
> > > > This need not be PCI, mind you.
> > > >
> > > >>  - has _PS3, no _PR3
> > > >>    - support D3_HOT, D3_COLD
> > > >
> > > > Nope.  D3_HOT cannot be supported in that case at the ACPI level.
> > > >
> > > >>    - set state
> > > >>      - D3_HOT: do nothing in ACPI
> > > >
> > > > That is not D3_HOT, then, from the ACPI point of view.  It is a different
> > > > power state.
> > > >
> > > > Suppose you have a non-PCI device that can be only power-manageable via ACPI
> > > > and that device has only _PS0 and _PS3.  How would you put it into D3_HOT,
> > > > in particular?
> > > 
> > > Normally, we will put it into D3_COLD (via _PS3).
> > > 
> > > If it is prevented to be put in D3_COLD,
> > >   - If D3_HOT is not marked as supported, we will keep it in D0
> > >   - otherwise, we advocate we put it into D3_HOT, but in fact, it is in D0.
> > > 
> > > The result is same, but with wrong name.
> > > 
> > > But there will be some real problem if we have something like CPU
> > > governor.  Because governor may choose D3_HOT for device.
> > 
> > In that case the ACPI layer should simply return an error code indicating
> > that the requested state is not available _from_ _it_.  If there are
> > more layers, however, they may be able to change the power state of
> > the device.
> > 
> > > But for PCI device, D3_HOT is supported for the device.
> > 
> > Yes, if the device supports native PM.  However, PCI D-states and ACPI D-states
> > are different things.  We kind of combine them in our PCI bus type.
> > 
> > > So the bus layer should combine the information from native power
> > > state supported and ACPI power state supported to determine which
> > > power states are supported?
> > 
> > Yes, we do that all the time, with the exception of D3 cold/hot.
> > 
> > > For example, for a PCI device, ACPI advocates D0 and D3_COLD are supported,
> > > and PCI layer may advocate D0, D3_HOT and D3_COLD are supported.
> > 
> > Exactly.  All of the available power states of the device depend on both
> > the device's own capabilities (ie. what PCI D-states the device may be
> > programmed into by register writes) and whatever is available from ACPI.
> > 
> > On embedded systems there are other factors as well.
> 
> So seems the patch is much simpler.

Yes, it should be simpler.

> How about below?

It looks good to me.  Feel free to add my ACK to the final version.

Thanks,
Rafael


>  drivers/acpi/power.c   |    2 +-
>  drivers/acpi/scan.c    |    9 +--------
>  drivers/pci/pci-acpi.c |    4 ++--
>  include/acpi/actypes.h |    7 ++++---
>  4 files changed, 8 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/acpi/power.c b/drivers/acpi/power.c
> index 7049a7d..330bb4d 100644
> --- a/drivers/acpi/power.c
> +++ b/drivers/acpi/power.c
> @@ -631,7 +631,7 @@ int acpi_power_get_inferred_state(struct acpi_device *device, int *state)
>  	 * We know a device's inferred power state when all the resources
>  	 * required for a given D-state are 'on'.
>  	 */
> -	for (i = ACPI_STATE_D0; i < ACPI_STATE_D3; i++) {
> +	for (i = ACPI_STATE_D0; i < ACPI_STATE_D3_HOT; i++) {
>  		list = &device->power.states[i].resources;
>  		if (list->count < 1)
>  			continue;
> diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> index 767e2dc..fbf38ad 100644
> --- a/drivers/acpi/scan.c
> +++ b/drivers/acpi/scan.c
> @@ -869,7 +869,7 @@ static int acpi_bus_get_power_flags(struct acpi_device *device)
>  	/*
>  	 * Enumerate supported power management states
>  	 */
> -	for (i = ACPI_STATE_D0; i <= ACPI_STATE_D3; i++) {
> +	for (i = ACPI_STATE_D0; i <= ACPI_STATE_D3_HOT; i++) {
>  		struct acpi_device_power_state *ps = &device->power.states[i];
>  		char object_name[5] = { '_', 'P', 'R', '0' + i, '\0' };
>  
> @@ -884,13 +884,6 @@ static int acpi_bus_get_power_flags(struct acpi_device *device)
>  				acpi_bus_add_power_resource(ps->resources.handles[j]);
>  		}
>  
> -		/* The exist of _PR3 indicates D3Cold support */
> -		if (i == ACPI_STATE_D3) {
> -			status = acpi_get_handle(device->handle, object_name, &handle);
> -			if (ACPI_SUCCESS(status))
> -				device->power.states[ACPI_STATE_D3_COLD].flags.valid = 1;
> -		}
> -
>  		/* Evaluate "_PSx" to see if we can do explicit sets */
>  		object_name[2] = 'S';
>  		status = acpi_get_handle(device->handle, object_name, &handle);
> diff --git a/drivers/pci/pci-acpi.c b/drivers/pci/pci-acpi.c
> index 0f150f2..1929c0c 100644
> --- a/drivers/pci/pci-acpi.c
> +++ b/drivers/pci/pci-acpi.c
> @@ -200,7 +200,7 @@ static pci_power_t acpi_pci_choose_state(struct pci_dev *pdev)
>  		return PCI_D1;
>  	case ACPI_STATE_D2:
>  		return PCI_D2;
> -	case ACPI_STATE_D3:
> +	case ACPI_STATE_D3_HOT:
>  		return PCI_D3hot;
>  	case ACPI_STATE_D3_COLD:
>  		return PCI_D3cold;
> @@ -223,7 +223,7 @@ static int acpi_pci_set_power_state(struct pci_dev *dev, pci_power_t state)
>  		[PCI_D0] = ACPI_STATE_D0,
>  		[PCI_D1] = ACPI_STATE_D1,
>  		[PCI_D2] = ACPI_STATE_D2,
> -		[PCI_D3hot] = ACPI_STATE_D3,
> +		[PCI_D3hot] = ACPI_STATE_D3_HOT,
>  		[PCI_D3cold] = ACPI_STATE_D3
>  	};
>  	int error = -EINVAL;
> diff --git a/include/acpi/actypes.h b/include/acpi/actypes.h
> index eba6604..e8bcc47 100644
> --- a/include/acpi/actypes.h
> +++ b/include/acpi/actypes.h
> @@ -499,9 +499,10 @@ typedef u64 acpi_integer;
>  #define ACPI_STATE_D0                   (u8) 0
>  #define ACPI_STATE_D1                   (u8) 1
>  #define ACPI_STATE_D2                   (u8) 2
> -#define ACPI_STATE_D3                   (u8) 3
> -#define ACPI_STATE_D3_COLD              (u8) 4
> -#define ACPI_D_STATES_MAX               ACPI_STATE_D3_COLD
> +#define ACPI_STATE_D3_HOT               (u8) 3
> +#define ACPI_STATE_D3                   (u8) 4
> +#define ACPI_STATE_D3_COLD              ACPI_STATE_D3
> +#define ACPI_D_STATES_MAX               ACPI_STATE_D3
>  #define ACPI_D_STATE_COUNT              5
>  
>  #define ACPI_STATE_C0                   (u8) 0
> 
> 
> 
> 

