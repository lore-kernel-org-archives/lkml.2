Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933236Ab2GEOrO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 10:47:14 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:44821 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932779Ab2GEOrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 10:47:11 -0400
Message-ID: <1341499417.16730.595.camel@misato.fc.hp.com>
Subject: Re: [PATCH v6 2/6] ACPI: Add _OST support for sysfs eject
From: Toshi Kani <toshi.kani@hp.com>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, bhelgaas@google.com,
        shuahkhan@gmail.com, liuj97@gmail.com, andi@firstfloor.org,
        linux-kernel@vger.kernel.org
Date: Thu, 05 Jul 2012 08:43:37 -0600
In-Reply-To: <4FF57787.1010308@jp.fujitsu.com>
References: <1340743374-18535-1-git-send-email-toshi.kani@hp.com>
	 <1340743374-18535-3-git-send-email-toshi.kani@hp.com>
	 <4FF57787.1010308@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-05 at 20:16 +0900, Yasuaki Ishimatsu wrote:
> Hi Toshi,
> 
> 2012/06/27 5:42, Toshi Kani wrote:
> > Changed acpi_bus_hot_remove_device() to support _OST. This function is
> > also changed to global so that it can be called from hotplug notify
> > handlers to perform hot-remove operation.
> > 
> > Changed acpi_eject_store(), which is the sysfs eject handler. It checks
> > eject_pending to see if the request was originated from ACPI eject
> > notification. If not, it calls _OST(0x103,84,) per Figure 6-37 in ACPI
> > 5.0 spec.
> > 
> > Added eject_pending bit to acpi_device_flags. This bit is set when the
> > kernel has received an ACPI eject notification, but does not initiate
> > its hot-remove operation by itself.
> > 
> > Added struct acpi_eject_event. This structure is used to pass extended
> > information to acpi_bus_hot_remove_device(), which has a single argument
> > to support asynchronous call
> > 
> > Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> > ---
> >   drivers/acpi/scan.c     |   57 +++++++++++++++++++++++++++++++++++++++-------
> >   include/acpi/acpi_bus.h |    9 ++++++-
> >   2 files changed, 56 insertions(+), 10 deletions(-)
> > 
> > diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> > index c8a1f3b..dbdb9fc 100644
> > --- a/drivers/acpi/scan.c
> > +++ b/drivers/acpi/scan.c
> > @@ -83,19 +83,29 @@ acpi_device_modalias_show(struct device *dev, struct device_attribute *attr, cha
> >   }
> >   static DEVICE_ATTR(modalias, 0444, acpi_device_modalias_show, NULL);
> >   
> > -static void acpi_bus_hot_remove_device(void *context)
> > +/**
> > + * acpi_bus_hot_remove_device: hot-remove a device and its children
> > + * @context: struct acpi_eject_event pointer (freed in this func)
> > + *
> > + * Hot-remove a device and its children. This function frees up the
> > + * memory space passed by arg context, so that the caller may call
> > + * this function asynchronously through acpi_os_hotplug_execute().
> > + */
> > +void acpi_bus_hot_remove_device(void *context)
> >   {
> > +	struct acpi_eject_event *ej_event = (struct acpi_eject_event *) context;
> >   	struct acpi_device *device;
> > -	acpi_handle handle = context;
> > +	acpi_handle handle = ej_event->handle;
> >   	struct acpi_object_list arg_list;
> >   	union acpi_object arg;
> >   	acpi_status status = AE_OK;
> > +	u32 ost_code = ACPI_OST_SC_NON_SPECIFIC_FAILURE; /* default */
> >   
> >   	if (acpi_bus_get_device(handle, &device))
> > -		return;
> > +		goto err_out;
> >   
> >   	if (!device)
> > -		return;
> > +		goto err_out;
> >   
> >   	ACPI_DEBUG_PRINT((ACPI_DB_INFO,
> >   		"Hot-removing device %s...\n", dev_name(&device->dev)));
> > @@ -103,7 +113,7 @@ static void acpi_bus_hot_remove_device(void *context)
> >   	if (acpi_bus_trim(device, 1)) {
> >   		printk(KERN_ERR PREFIX
> >   				"Removing device failed\n");
> > -		return;
> > +		goto err_out;
> >   	}
> >   
> >   	/* power off device */
> > @@ -129,10 +139,20 @@ static void acpi_bus_hot_remove_device(void *context)
> >   	 * TBD: _EJD support.
> >   	 */
> >   	status = acpi_evaluate_object(handle, "_EJ0", &arg_list, NULL);
> > -	if (ACPI_FAILURE(status))
> > -		printk(KERN_WARNING PREFIX
> > -				"Eject device failed\n");
> > +	if (ACPI_FAILURE(status)) {
> > +		if (status != AE_NOT_FOUND)
> > +			pr_warn(PREFIX "Eject device failed\n");
> > +		goto err_out;
> > +	}
> > +
> > +	kfree(context);
> > +	return;
> >   
> > +err_out:
> > +	/* Inform firmware the hot-remove operation has completed w/ error */
> > +	(void) acpi_evaluate_hotplug_ost(handle,
> > +				ej_event->event, ost_code, NULL);
> > +	kfree(context);
> >   	return;
> >   }
> 
> When I read your patch named [PATCH] ACPI: Add ACPI CPU hot-remove support,
> a question about this patch appeared.
> 
> The question is :
> Why does not acpi_bus_hot_remove_device() inform firmware of
> ACPI_OST_SC_SUCCESS, when it succeeded? Are thre any reasons?
> 
> If you have already discussed my question, please let me know the log.

Hi Yasuaki,

Please refer Figure 2, page 14, of the following document.  _EJ0
substitutes _OST as it indicates to the firmware that the OS was
successful in offlining.

  DIG64 Hot-Plug & Partitioning Flow (HPPF) Specification R1.0
  http://www.dig64.org/home/DIG64_HPPF_R1_0.pdf

Figure 6-37 of ACPI 5.0 spec also has a similar example flow.

Thanks,
-Toshi


> Thanks,
> Yasuaki Ishimatsu
> 
> 
> >   
> > @@ -144,6 +164,7 @@ acpi_eject_store(struct device *d, struct device_attribute *attr,
> >   	acpi_status status;
> >   	acpi_object_type type = 0;
> >   	struct acpi_device *acpi_device = to_acpi_device(d);
> > +	struct acpi_eject_event *ej_event;
> >   
> >   	if ((!count) || (buf[0] != '1')) {
> >   		return -EINVAL;
> > @@ -160,7 +181,25 @@ acpi_eject_store(struct device *d, struct device_attribute *attr,
> >   		goto err;
> >   	}
> >   
> > -	acpi_os_hotplug_execute(acpi_bus_hot_remove_device, acpi_device->handle);
> > +	ej_event = kmalloc(sizeof(*ej_event), GFP_KERNEL);
> > +	if (!ej_event) {
> > +		ret = -ENOMEM;
> > +		goto err;
> > +	}
> > +
> > +	ej_event->handle = acpi_device->handle;
> > +	if (acpi_device->flags.eject_pending) {
> > +		/* event originated from ACPI eject notification */
> > +		ej_event->event = ACPI_NOTIFY_EJECT_REQUEST;
> > +		acpi_device->flags.eject_pending = 0;
> > +	} else {
> > +		/* event originated from user */
> > +		ej_event->event = ACPI_OST_EC_OSPM_EJECT;
> > +		(void) acpi_evaluate_hotplug_ost(ej_event->handle,
> > +			ej_event->event, ACPI_OST_SC_EJECT_IN_PROGRESS, NULL);
> > +	}
> > +
> > +	acpi_os_hotplug_execute(acpi_bus_hot_remove_device, (void *)ej_event);
> >   err:
> >   	return ret;
> >   }
> > diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
> > index 1d9e432..b22b774 100644
> > --- a/include/acpi/acpi_bus.h
> > +++ b/include/acpi/acpi_bus.h
> > @@ -182,7 +182,8 @@ struct acpi_device_flags {
> >   	u32 suprise_removal_ok:1;
> >   	u32 power_manageable:1;
> >   	u32 performance_manageable:1;
> > -	u32 reserved:24;
> > +	u32 eject_pending:1;
> > +	u32 reserved:23;
> >   };
> >   
> >   /* File System */
> > @@ -334,6 +335,11 @@ struct acpi_bus_event {
> >   	u32 data;
> >   };
> >   
> > +struct acpi_eject_event {
> > +	acpi_handle	handle;
> > +	u32		event;
> > +};
> > +
> >   extern struct kobject *acpi_kobj;
> >   extern int acpi_bus_generate_netlink_event(const char*, const char*, u8, int);
> >   void acpi_bus_private_data_handler(acpi_handle, void *);
> > @@ -371,6 +377,7 @@ int acpi_bus_register_driver(struct acpi_driver *driver);
> >   void acpi_bus_unregister_driver(struct acpi_driver *driver);
> >   int acpi_bus_add(struct acpi_device **child, struct acpi_device *parent,
> >   		 acpi_handle handle, int type);
> > +void acpi_bus_hot_remove_device(void *context);
> >   int acpi_bus_trim(struct acpi_device *start, int rmdevice);
> >   int acpi_bus_start(struct acpi_device *device);
> >   acpi_status acpi_bus_get_ejd(acpi_handle handle, acpi_handle * ejd);
> > 
> 
> 
> 


