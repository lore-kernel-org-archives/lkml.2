Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758938Ab2EXU20 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 16:28:26 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:38726 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756374Ab2EXU2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 16:28:24 -0400
Message-ID: <1337891135.16730.404.camel@misato.fc.hp.com>
Subject: Re: [PATCH v4 4/6] ACPI: Add _OST support for ACPI memory hotplug
From: Toshi Kani <toshi.kani@hp.com>
To: shuahkhan@gmail.com
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, bhelgaas@google.com,
        liuj97@gmail.com, andi@firstfloor.org, linux-kernel@vger.kernel.org
Date: Thu, 24 May 2012 14:25:35 -0600
In-Reply-To: <1337883710.2718.85.camel@lorien2>
References: <1337826324-16802-1-git-send-email-toshi.kani@hp.com>
	 <1337826324-16802-5-git-send-email-toshi.kani@hp.com>
	 <1337883710.2718.85.camel@lorien2>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-24 at 12:21 -0600, Shuah Khan wrote:
> On Wed, 2012-05-23 at 20:25 -0600, Toshi Kani wrote:
> > Changed acpi_memory_device_notify() to call ACPI _OST method
> > when ACPI memory hotplug operation has completed.
> > 
> > Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> > ---
> >  drivers/acpi/acpi_memhotplug.c |   43 +++++++++++++++++++++++++++++----------
> >  1 files changed, 32 insertions(+), 11 deletions(-)
> > 
> > diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
> > index d985713..24c807f 100644
> > --- a/drivers/acpi/acpi_memhotplug.c
> > +++ b/drivers/acpi/acpi_memhotplug.c
> > @@ -341,7 +341,7 @@ static void acpi_memory_device_notify(acpi_handle handle, u32 event, void *data)
> >  {
> >  	struct acpi_memory_device *mem_device;
> >  	struct acpi_device *device;
> > -
> > +	u32 ost_code = ACPI_OST_SC_NON_SPECIFIC_FAILURE; /* default */
> >  
> >  	switch (event) {
> >  	case ACPI_NOTIFY_BUS_CHECK:
> > @@ -354,15 +354,20 @@ static void acpi_memory_device_notify(acpi_handle handle, u32 event, void *data)
> >  					  "\nReceived DEVICE CHECK notification for device\n"));
> >  		if (acpi_memory_get_device(handle, &mem_device)) {
> >  			printk(KERN_ERR PREFIX "Cannot find driver data\n");
> > -			return;
> > +			break;
> >  		}
> >  
> > -		if (!acpi_memory_check_device(mem_device)) {
> > -			if (acpi_memory_enable_device(mem_device))
> > -				printk(KERN_ERR PREFIX
> > -					    "Cannot enable memory device\n");
> > +		if (acpi_memory_check_device(mem_device))
> > +			break;
> > +
> > +		if (acpi_memory_enable_device(mem_device)) {
> > +			printk(KERN_ERR PREFIX "Cannot enable memory device\n");
> > +			break;
> >  		}
> > +
> > +		ost_code = ACPI_OST_SC_SUCCESS;
> >  		break;
> > +
> >  	case ACPI_NOTIFY_EJECT_REQUEST:
> >  		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
> >  				  "\nReceived EJECT REQUEST notification for device\n"));
> > @@ -383,19 +388,35 @@ static void acpi_memory_device_notify(acpi_handle handle, u32 event, void *data)
> >  		 * TBD: Can also be disabled by Callback registration
> >  		 *      with generic sysfs driver
> >  		 */
> > -		if (acpi_memory_disable_device(mem_device))
> > -			printk(KERN_ERR PREFIX
> > -				    "Disable memory device\n");
> > +		if (acpi_memory_disable_device(mem_device)) {
> > +			printk(KERN_ERR PREFIX "Disable memory device\n");
> > +			/*
> > +			 * If _EJ0 was called but failed, _OST is not
> > +			 * necessary.
> > +			 */
> > +			if (mem_device->state == MEMORY_INVALID_STATE)
> > +				return;
> > +
> > +			break;
> > +		}
> 
> Why isn't _OST called in this case to report failure? Isn't this one of
> the cases Spec talks about. Reference: 6.3.5 _OST (OSPM Status
> Indication) page 302.

If an ejection operation failed before calling _EJ0, the OS needs to
call _OST.  Once the OS called _EJ0, the OS need not to call _OST again
since FW has been informed with _EJ0 already.  If _EJ0 failed, FW knows
it failed as well.  Please see page 14, Figure 2, of DIG64 HPPF doc.
The pointer to the doc is described in patch [0/6].

Thanks,
-Toshi


> 
> -- Shuah
> 
> > +
> >  		/*
> >  		 * TBD: Invoke acpi_bus_remove to cleanup data structures
> >  		 */
> > -		break;
> > +
> > +		/* _EJ0 succeeded; _OST is not necessary */
> > +		return;
> > +
> >  	default:
> >  		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
> >  				  "Unsupported event [0x%x]\n", event));
> > -		break;
> > +
> > +		/* non-hotplug event; possibly handled by other handler */
> > +		return;
> >  	}
> >  
> > +	/* Inform firmware that the hotplug operation has completed */
> > +	(void) acpi_evaluate_hotplug_ost(handle, event, ost_code, NULL);
> >  	return;
> >  }
> >  
> 
> 


