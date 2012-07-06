Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757385Ab2GFOUy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 10:20:54 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:34476 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458Ab2GFOUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 10:20:52 -0400
Message-ID: <1341584240.16730.596.camel@misato.fc.hp.com>
Subject: Re: [PATCH] ACPI: Add ACPI CPU hot-remove support
From: Toshi Kani <toshi.kani@hp.com>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 06 Jul 2012 08:17:20 -0600
In-Reply-To: <4FF65535.4060802@jp.fujitsu.com>
References: <1340981479-6521-1-git-send-email-toshi.kani@hp.com>
	 <4FF65535.4060802@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-07-06 at 12:02 +0900, Yasuaki Ishimatsu wrote:
> Hi Toshi,
> 
> 2012/06/29 23:51, Toshi Kani wrote:
> > Added CPU hot-remove support through an ACPI eject notification.
> > It calls acpi_bus_hot_remove_device(), which shares the same code
> > path with the sysfs eject operation.  acpi_os_hotplug_execute()
> > serializes hot-remove operations between ACPI hot-remove and sysfs
> > eject requests.
> > 
> > Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> 
> Looks good to me.
> 
> Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

Great!  Thanks Yasuaki for reviewing!
-Toshi


> > 
> > ---
> > This patch applies on top of the patchset below.
> > 
> > [PATCH v6 0/6] ACPI: Add _OST support for ACPI hotplug
> > http://marc.info/?l=linux-acpi&m=134074381322973&w=2
> > 
> > ---
> >   drivers/acpi/processor_driver.c |   27 +++++++++++++++++----------
> >   1 files changed, 17 insertions(+), 10 deletions(-)
> > 
> > diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
> > index f9fa1b2..a6f6bde 100644
> > --- a/drivers/acpi/processor_driver.c
> > +++ b/drivers/acpi/processor_driver.c
> > @@ -699,8 +699,8 @@ int acpi_processor_device_add(acpi_handle handle, struct acpi_device **device)
> >   static void acpi_processor_hotplug_notify(acpi_handle handle,
> >   					  u32 event, void *data)
> >   {
> > -	struct acpi_processor *pr;
> >   	struct acpi_device *device = NULL;
> > +	struct acpi_eject_event *ej_event = NULL;
> >   	u32 ost_code = ACPI_OST_SC_NON_SPECIFIC_FAILURE; /* default */
> >   	int result;
> >   
> > @@ -732,20 +732,27 @@ static void acpi_processor_hotplug_notify(acpi_handle handle,
> >   				  "received ACPI_NOTIFY_EJECT_REQUEST\n"));
> >   
> >   		if (acpi_bus_get_device(handle, &device)) {
> > -			printk(KERN_ERR PREFIX
> > -				    "Device don't exist, dropping EJECT\n");
> > +			pr_err(PREFIX "Device don't exist, dropping EJECT\n");
> >   			break;
> >   		}
> > -		pr = acpi_driver_data(device);
> > -		if (!pr) {
> > -			printk(KERN_ERR PREFIX
> > -				    "Driver data is NULL, dropping EJECT\n");
> > +		if (!acpi_driver_data(device)) {
> > +			pr_err(PREFIX "Driver data is NULL, dropping EJECT\n");
> >   			break;
> >   		}
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
> >   	default:
> >   		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
> > 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


