Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646Ab2ISOtM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 10:49:12 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:45780 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753490Ab2ISOtI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 10:49:08 -0400
From: "Ortiz, Lance E" <lance.oritz@hp.com>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
CC: "rob@landley.net" <rob@landley.net>, "lenb@kernel.org" <lenb@kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: RE: [PATCH] ACPI: Add new sysfs interface to export device
 description
Thread-Topic: [PATCH] ACPI: Add new sysfs interface to export device
 description
Thread-Index: AQHNjRYoOZ04aBsO5UmZ6uBY8gFgqJeRObwAgACPnRA=
Date: Wed, 19 Sep 2012 14:27:48 +0000
Message-ID: <A961433CDFF2F640A2866803152E61F950D1B50A@G9W0753.americas.hpqcorp.net>
References: <1347035296-8882-1-git-send-email-lance.ortiz@hp.com>
 <50595BF0.2010002@jp.fujitsu.com>
In-Reply-To: <50595BF0.2010002@jp.fujitsu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.210.48.12]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Comment Below...

> -----Original Message-----
> From: Yasuaki Ishimatsu [mailto:isimatu.yasuaki@jp.fujitsu.com]
> Sent: Tuesday, September 18, 2012 11:45 PM
> To: Ortiz, Lance E
> Cc: rob@landley.net; lenb@kernel.org; linux-doc@vger.kernel.org; linux-
> kernel@vger.kernel.org; linux-acpi@vger.kernel.org
> Subject: Re: [PATCH] ACPI: Add new sysfs interface to export device
> description
> 
> Hi Lance,
> 
> 2012/09/08 1:28, Lance Ortiz wrote:
> > Add support to export the device description obtained from the ACPI
> _STR
> > method, if one exists for a device, to user-space via a sysfs
> interface.
> > This new interface provides a standard and platform neutral way for
> users
> > to obtain the description text stored in the ACPI _STR method.  If no
> > _STR method exists for the device, no sysfs 'description' file will
> be
> > created.  The 'description' file will be located in the /sys/devices/
> > directory using the device's path.
> >
> > /sys/device/<bus>/<bridge path>/<device
> path>.../firmware_node/description
> >
> > Example:
> >
> >
> /sys/devices/pci0000:00/0000:00.07.0/0000:0e:00.0/firmware_node/descrip
> tion
> >
> > It can also be located using the ACPI device path, for example:
> >
> >
> /sys/devices/LNXSYSTM:00/device:00/ACPI0004:00/PNP0A08:00/device:13/dev
> ice:15/description
> >
> /sys/devices/LNXSYSTM:00/device:00/ACPI0004:00/ACPI0004:01/ACPI0007:02/
> description
> >
> > Execute the 'cat' command on the 'description' file to obtain the
> > description string for that device.
> >
> > This patch also includes documentation describing how the new sysfs
> > interface works
> >
> > Signed-off-by: Lance Ortiz <lance.ortiz@hp.com>
> > ---
> 
> Tested-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> 
> There is a comment as follows.
> 
> >   .../ABI/testing/sysfs-devices-firmware_node        |   17 ++++++
> >   drivers/acpi/scan.c                                |   58
> +++++++++++++++++++-
> >   include/acpi/acpi_bus.h                            |    1 +
> >   3 files changed, 74 insertions(+), 2 deletions(-)
> >   create mode 100644 Documentation/ABI/testing/sysfs-devices-
> firmware_node
> >
> > diff --git a/Documentation/ABI/testing/sysfs-devices-firmware_node
> b/Documentation/ABI/testing/sysfs-devices-firmware_node
> > new file mode 100644
> > index 0000000..46badc9
> > --- /dev/null
> > +++ b/Documentation/ABI/testing/sysfs-devices-firmware_node
> > @@ -0,0 +1,17 @@
> > +What:		/sys/devices/.../firmware_node/
> > +Date:		September 2012
> > +Contact:	<>
> > +Description:
> > +		The /sys/devices/.../firmware_node directory contains
> attributes
> > +		allowing the user space to check and modify some firmware
> > +		related properties of given device.
> > +
> > +What:		/sys/devices/.../firmware_node/description
> > +Date:		September 2012
> > +Contact:	Lance Ortiz <lance.ortiz@hp.com>
> > +Description:
> > +		The /sys/devices/.../firmware/description attribute
> contains a string
> > +		that describes the device as provided by the _STR method in
> the ACPI
> > +		namespace.  This attribute is read-only.  If the device
> does not have
> > +		an _STR method associated with it in the ACPI namespace,
> this
> > +		attribute is not present.
> > diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> > index c8a1f3b..c9c91e1 100644
> > --- a/drivers/acpi/scan.c
> > +++ b/drivers/acpi/scan.c
> > @@ -10,6 +10,7 @@
> >   #include <linux/signal.h>
> >   #include <linux/kthread.h>
> >   #include <linux/dmi.h>
> > +#include <linux/nls.h>
> >
> >   #include <acpi/acpi_drivers.h>
> >
> > @@ -192,8 +193,38 @@ end:
> >   }
> >   static DEVICE_ATTR(path, 0444, acpi_device_path_show, NULL);
> >
> > +/* sysfs file that shows description text from the ACPI _STR method
> */
> > +static ssize_t description_show(struct device *dev,
> > +				struct device_attribute *attr,
> > +				char *buf) {
> > +	struct acpi_device *acpi_dev = to_acpi_device(dev);
> > +	int result;
> > +
> > +	if (acpi_dev->pnp.str_obj == NULL) {
> > +		result = sprintf(buf, "No Description\n");
> > +		goto end;
> > +	}
> > +
> > +	/*
> > +	 * The _STR object contains a Unicode identifier for a device.
> > +	 * We need to convert to utf-8 so it can be displayed.
> > +	 */
> > +	result = utf16s_to_utf8s(
> > +		(wchar_t *)acpi_dev->pnp.str_obj->buffer.pointer,
> > +		acpi_dev->pnp.str_obj->buffer.length,
> > +		UTF16_LITTLE_ENDIAN, buf,
> > +		PAGE_SIZE);
> > +
> > +	buf[result++] = '\n';
> > +
> > +end:
> > +	return result;
> > +}
> > +static DEVICE_ATTR(description, 0444, description_show, NULL);
> > +
> >   static int acpi_device_setup_files(struct acpi_device *dev)
> >   {
> > +	struct acpi_buffer buffer = {ACPI_ALLOCATE_BUFFER, NULL};
> >   	acpi_status status;
> >   	acpi_handle temp;
> >   	int result = 0;
> > @@ -217,6 +248,21 @@ static int acpi_device_setup_files(struct
> acpi_device *dev)
> >   			goto end;
> >   	}
> >
> > +	/*
> > +	 * If device has _STR, 'description' file is created
> > +	 */
> > +	status = acpi_get_handle(dev->handle, "_STR", &temp);
> > +	if (ACPI_SUCCESS(status)) {
> > +		status = acpi_evaluate_object(dev->handle, "_STR",
> > +					NULL, &buffer);
> > +		if (ACPI_FAILURE(status))
> > +			buffer.pointer = NULL;
> > +		dev->pnp.str_obj = buffer.pointer;
> > +		result = device_create_file(&dev->dev,
> &dev_attr_description);
> 
> A description sysfs is created even if "acpi_evaluate_object()" fails.
> Why do you create it in this case?
> 
> Thanks,
> Yasuaki Ishimatsu

Yasuaki,

First of all, thank you for reviewing and testing my patch.

To address your comment, I was trying to differentiate between the existence of the _STR method and the failure to evaluate it.  If an STR method exists, we create the sysfs file.  If it fails to evaluate, we will see "No Description" when we read the file.  This would indicate that something is wrong as opposed to the system not having an _STR.  If you feel that this is unnecessary, or should be done differently let me know.

Lance

> 
> > +		if (result)
> > +			goto end;
> > +	}
> > +
> >           /*
> >            * If device has _EJ0, 'eject' file is created that is used
> to trigger
> >            * hot-removal function from userland.
> > @@ -234,8 +280,16 @@ static void acpi_device_remove_files(struct
> acpi_device *dev)
> >   	acpi_handle temp;
> >
> >   	/*
> > -	 * If device has _EJ0, 'eject' file is created that is used to
> trigger
> > -	 * hot-removal function from userland.
> > +	 * If device has _STR, remove 'description' file
> > +	 */
> > +	status = acpi_get_handle(dev->handle, "_STR", &temp);
> > +	if (ACPI_SUCCESS(status)) {
> > +		if (dev->pnp.str_obj != NULL)
> > +			kfree(dev->pnp.str_obj);
> > +		device_remove_file(&dev->dev, &dev_attr_description);
> > +	}
> > +	/*
> > +	 * If device has _EJ0, remove 'eject' file.
> >   	 */
> >   	status = acpi_get_handle(dev->handle, "_EJ0", &temp);
> >   	if (ACPI_SUCCESS(status))
> > diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
> > index 9e6e1c6..12172d5 100644
> > --- a/include/acpi/acpi_bus.h
> > +++ b/include/acpi/acpi_bus.h
> > @@ -209,6 +209,7 @@ struct acpi_device_pnp {
> >   	struct list_head ids;		/* _HID and _CIDs */
> >   	acpi_device_name device_name;	/* Driver-determined */
> >   	acpi_device_class device_class;	/*        "          */
> > +	union acpi_object *str_obj;	/* unicode string for _STR method
> */
> >   };
> >
> >   #define acpi_device_bid(d)	((d)->pnp.bus_id)
> >
> 

