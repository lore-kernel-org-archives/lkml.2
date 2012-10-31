Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760966Ab2JaWnc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 18:43:32 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:8717 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760858Ab2JaWna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 18:43:30 -0400
Message-ID: <1351722950.19172.86.camel@misato.fc.hp.com>
Subject: Re: [PATCH v2 RESEND] ACPI: Add ACPI CPU hot-remove support
From: Toshi Kani <toshi.kani@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org, lenb@kernel.org, linux-kernel@vger.kernel.org,
        isimatu.yasuaki@jp.fujitsu.com, imammedo@redhat.com,
        vijaymohan.pandarathil@hp.com, prarit@redhat.com, bhelgaas@google.com
Date: Wed, 31 Oct 2012 16:35:50 -0600
In-Reply-To: <6242557.1QFHiVDrMN@vostro.rjw.lan>
References: <1350673793-19248-1-git-send-email-toshi.kani@hp.com>
	 <6242557.1QFHiVDrMN@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-31 at 23:27 +0100, Rafael J. Wysocki wrote:
> On Friday, October 19, 2012 01:09:53 PM Toshi Kani wrote:
> > Added CPU hot-remove support through an ACPI eject notification.
> > It calls acpi_bus_hot_remove_device(), which shares the same code
> > path with the sysfs eject operation.  acpi_os_hotplug_execute()
> > serializes hot-remove operations between ACPI hot-remove and sysfs
> > eject requests.
> > 
> > Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> > Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> > Tested-by: IgorMammedov <imammedo@redhat.com>
> > Tested-by: Vijay Mohan Pandarathil <vijaymohan.pandarathil@hp.com>
> > Tested-by: Prarit Bhargava <prarit@redhat.com>
> 
> This doesn't build with modular processor driver.

Hi Rafael,

Thanks for pointing this out!  I will fix the issue and send an updated
version.

-Toshi


> 
> Thanks,
> Rafael
> 
> 
> > ---
> > v2: Rebased to the current Linus's tree.
> > ---
> >  drivers/acpi/processor_driver.c | 27 +++++++++++++++++----------
> >  1 file changed, 17 insertions(+), 10 deletions(-)
> > 
> > diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
> > index e78c2a5..1cc9652 100644
> > --- a/drivers/acpi/processor_driver.c
> > +++ b/drivers/acpi/processor_driver.c
> > @@ -694,8 +694,8 @@ int acpi_processor_device_add(acpi_handle handle, struct acpi_device **device)
> >  static void acpi_processor_hotplug_notify(acpi_handle handle,
> >  					  u32 event, void *data)
> >  {
> > -	struct acpi_processor *pr;
> >  	struct acpi_device *device = NULL;
> > +	struct acpi_eject_event *ej_event = NULL;
> >  	u32 ost_code = ACPI_OST_SC_NON_SPECIFIC_FAILURE; /* default */
> >  	int result;
> >  
> > @@ -727,20 +727,27 @@ static void acpi_processor_hotplug_notify(acpi_handle handle,
> >  				  "received ACPI_NOTIFY_EJECT_REQUEST\n"));
> >  
> >  		if (acpi_bus_get_device(handle, &device)) {
> > -			printk(KERN_ERR PREFIX
> > -				    "Device don't exist, dropping EJECT\n");
> > +			pr_err(PREFIX "Device don't exist, dropping EJECT\n");
> >  			break;
> >  		}
> > -		pr = acpi_driver_data(device);
> > -		if (!pr) {
> > -			printk(KERN_ERR PREFIX
> > -				    "Driver data is NULL, dropping EJECT\n");
> > +		if (!acpi_driver_data(device)) {
> > +			pr_err(PREFIX "Driver data is NULL, dropping EJECT\n");
> >  			break;
> >  		}
> >  
> > -		/* REVISIT: update when eject is supported */
> > -		ost_code = ACPI_OST_SC_EJECT_NOT_SUPPORTED;
> > -		break;
> > +		ej_event = kmalloc(sizeof(*ej_event), GFP_KERNEL);
> > +		if (!ej_event) {
> > +			pr_err(PREFIX "No memory, dropping EJECT\n");
> > +			break;
> > +		}
> > +
> > +		ej_event->handle = handle;
> > +		ej_event->event = ACPI_NOTIFY_EJECT_REQUEST;
> > +		acpi_os_hotplug_execute(acpi_bus_hot_remove_device,
> > +					(void *)ej_event);
> > +
> > +		/* eject is performed asynchronously */
> > +		return;
> >  
> >  	default:
> >  		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
> > 


