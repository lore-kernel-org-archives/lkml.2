Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758003Ab2GFTRO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 15:17:14 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:48588 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755814Ab2GFTRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 15:17:12 -0400
Message-ID: <1341602020.16730.695.camel@misato.fc.hp.com>
Subject: Re: [PATCH] ACPI: Add ACPI CPU hot-remove support
From: Toshi Kani <toshi.kani@hp.com>
To: Jiang Liu <liuj97@gmail.com>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 06 Jul 2012 13:13:40 -0600
In-Reply-To: <4FF711DE.1030108@gmail.com>
References: <1340981479-6521-1-git-send-email-toshi.kani@hp.com>
	 <4FF711DE.1030108@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-07-07 at 00:27 +0800, Jiang Liu wrote:
> Hi Toshi,
> 	I think a better solution here is to send a notification to acpid
> daemon instead of directly ejecting the physical processor in kernel by
> apci hotplug work thread. The daemon should do:
> 	1) check whether user policy allows to remove the physical processor
> 	2) resolve any dependency issues, such as some memory/IOHs may have
> 	dependency on the processor.
> 	3) Remove all devices on the physical processor through sysfs.
> 	4) Power off the physical processor through sysfs.
> 
> 	If we rely on the acpi hotplug work thread to do the hard work, it
> may block the work thread for a very long time and it won't respond to other
> hotplug events.
> 	Thanks!
> 	Gerry

Hi Gerry,

Good points.  I agree with your concerns in general.

For step 2) and 4), I am wondering if they are relevant to CPU hotplug
these days.  In ACPI namespace, a processor object represents a logical
processor (or a core when hyper-threading is disabled).  A physical
processor (i.e. a socket) usually has multiple cores, and memory
controller and bus interface are part of the socket functionality.
Hence, I think step 2) and 4) belong to socket-level hot-removal
operation, which can be implemented as container hot-remove when a
socket is represented with a container object.  

I agree that step 1) needs to be concerned for CPU hotplug.  Other
approach (which has been implemented in other OS) is that such user
policy can be managed by management console or hypervisor, which becomes
a single place to manage the policy for multiple OS instances, i.e. if
hot-remove is disallowed on a target, it fails a request and does not
send a GPE.  Asking customers to setup the policy to each OS instance
can be problematic, esp. when there are many OS instances on virtualized
environment.  Other issue is that when a hot-remove request is failed or
ignored in user space, we do not have a way to fail the request with
_OST at this point.  Therefore, from the management console /
hypervisor, where a hot-remove request was made from, this case can be
seen as a hang in the hot-remove request.

Thanks,
-Toshi


> On 06/29/2012 10:51 PM, Toshi Kani wrote:
> > Added CPU hot-remove support through an ACPI eject notification.
> > It calls acpi_bus_hot_remove_device(), which shares the same code
> > path with the sysfs eject operation.  acpi_os_hotplug_execute()
> > serializes hot-remove operations between ACPI hot-remove and sysfs
> > eject requests.
> > 
> > Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> > 
> > ---
> > This patch applies on top of the patchset below.
> > 
> > [PATCH v6 0/6] ACPI: Add _OST support for ACPI hotplug
> > http://marc.info/?l=linux-acpi&m=134074381322973&w=2
> > 
> > ---
> >  drivers/acpi/processor_driver.c |   27 +++++++++++++++++----------
> >  1 files changed, 17 insertions(+), 10 deletions(-)
> > 
> > diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
> > index f9fa1b2..a6f6bde 100644
> > --- a/drivers/acpi/processor_driver.c
> > +++ b/drivers/acpi/processor_driver.c
> > @@ -699,8 +699,8 @@ int acpi_processor_device_add(acpi_handle handle, struct acpi_device **device)
> >  static void acpi_processor_hotplug_notify(acpi_handle handle,
> >  					  u32 event, void *data)
> >  {
> > -	struct acpi_processor *pr;
> >  	struct acpi_device *device = NULL;
> > +	struct acpi_eject_event *ej_event = NULL;
> >  	u32 ost_code = ACPI_OST_SC_NON_SPECIFIC_FAILURE; /* default */
> >  	int result;
> >  
> > @@ -732,20 +732,27 @@ static void acpi_processor_hotplug_notify(acpi_handle handle,
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
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


