Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592Ab0GITFO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 15:05:14 -0400
Received: from kroah.org ([198.145.64.141]:60756 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754230Ab0GITFK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 15:05:10 -0400
Date: Fri, 9 Jul 2010 12:04:30 -0700
From: Greg KH <greg@kroah.com>
To: David Brownell <dbrownell@users.sourceforge.net>,
       Michal Nazarewicz <m.nazarewicz@samsung.com>
Cc: mina86@mina86.com, Alan Stern <stern@rowland.harvard.edu>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org,
       Dries Van Puymbroeck <Dries.VanPuymbroeck@dekimo.com>,
       stable <stable@kernel.org>
Subject: Re: [PATCHv3 1/3] USB: gadget: mass/file storage: set serial number
Message-ID: <20100709190430.GB29601@kroah.com>
References: <20100708183425.GB31823@kroah.com>
 <e2d14d0a730dde4b716c0e086761ef65ba9afda8.1278619472.git.m.nazarewicz@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e2d14d0a730dde4b716c0e086761ef65ba9afda8.1278619472.git.m.nazarewicz@samsung.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David, any thoughts on these versions of the patch?

thanks,

greg k-h

On Thu, Jul 08, 2010 at 10:52:26PM +0200, Michal Nazarewicz wrote:
> This commit adds iSerialNumber to all gadgets that use the Mass
> Storage Function.  It appears that Windows has problems when
> it is not set.
> 
> Not to copy the same code all over again, a fsg_string_serial_fill()
> macro has been added to the storage_common.c file which is now also
> used in the File Storage Gadget.
> 
> Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> Reported-by: Dries Van Puymbroeck <Dries.VanPuymbroeck@dekimo.com>
> Tested-by: Dries Van Puymbroeck <Dries.VanPuymbroeck@dekimo.com>
> Cc: stable <stable@kernel.org>
> ---
> > On Thu, Jul 01, 2010 at 03:42:19PM +0200, Michal Nazarewicz wrote:
> > This patch conflicts with the patch in my tree:
> > 	Subject: USB: Add a serial number parameter to g_file_storage module
> >
> > So, could you fix the above patch up to play nice with your change so
> > that I can accept it?
> 
> Sending all 3 patches.  The first and last are identical to v2 (only
> updated offsets and some such).
> 
> The second has been modified as it stopped applying after applying the
> first plus there was a bug: the fsg_string_serial was never filled if
> CONFIG_USB_FILE_STORAGE_TEST was not defined.
> 
> 
> Please also note that David has some concerns about this patch (if I
> understood everything correctly).  However, I wasn't sure what was the
> issue here...
> 
> 
> The delta for the second patch is:
> 
> > --- drivers/usb/gadget/file_storage.c	2010-07-08 22:19:21.428413976 +0200
> > +++ /home/mina86/file_storage.c	2010-07-08 22:17:23.792913751 +0200
> > @@ -3315,20 +3315,13 @@
> >  		fsg_strings[FSG_STRING_SERIAL - 1].s = mod_data.serial_parm;
> >  	} else {
> >  fill_serial:
> > -		/* Serial number not specified or invalid, make our own.
> > -		 * We just encode it from the driver version string,
> > -		 * 12 characters to comply with both CB[I] and BBB spec.
> > -		 * Warning : Two devices running the same kernel will have
> > -		 * the same fallback serial number. */
> > -		for (i = 0; i < 12; i += 2) {
> > -			unsigned char	c = DRIVER_VERSION[i / 2];
> > -
> > -			if (!c)
> > -				break;
> > -			sprintf(&fsg_string_serial[i], "%02X", c);
> > -		}
> > +		fsg_string_serial_fill(fsg_string_serial, DRIVER_VERSION);
> >  	}
> >  
> > +#else /* !CONFIG_USB_FILE_STORAGE_TEST */
> > +
> > +	fsg_string_serial_fill(fsg_string_serial, DRIVER_VERSION);
> > +
> >  #endif /* CONFIG_USB_FILE_STORAGE_TEST */
> >  
> >  	return 0;
> 
> 
> On Thu, 08 Jul 2010 21:03:28 +0200, Greg KH <greg@kroah.com> wrote:
> > Note, Monday I'll be somewhere in Europe so my email access might be a
> > bit limited for that week.
> 
> We do have pretty good Internet here you know... ;)  Any way, come visit
> Warsaw then! :P
> 
> At any rate, I think there is no rush, no rush at all.
> 
>  drivers/usb/gadget/file_storage.c   |   10 +---------
>  drivers/usb/gadget/mass_storage.c   |   31 +++++++++++++++++++------------
>  drivers/usb/gadget/multi.c          |   12 ++++++++++++
>  drivers/usb/gadget/storage_common.c |   12 ++++++++++++
>  4 files changed, 44 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/usb/gadget/file_storage.c b/drivers/usb/gadget/file_storage.c
> index b49d86e..f1e6956 100644
> --- a/drivers/usb/gadget/file_storage.c
> +++ b/drivers/usb/gadget/file_storage.c
> @@ -3447,15 +3447,7 @@ static int __init fsg_bind(struct usb_gadget *gadget)
>  			init_utsname()->sysname, init_utsname()->release,
>  			gadget->name);
>  
> -	/* On a real device, serial[] would be loaded from permanent
> -	 * storage.  We just encode it from the driver version string. */
> -	for (i = 0; i < sizeof fsg_string_serial - 2; i += 2) {
> -		unsigned char		c = DRIVER_VERSION[i / 2];
> -
> -		if (!c)
> -			break;
> -		sprintf(&fsg_string_serial[i], "%02X", c);
> -	}
> +	fsg_string_serial_fill(fsg_string_serial, DRIVER_VERSION);
>  
>  	fsg->thread_task = kthread_create(fsg_main_thread, fsg,
>  			"file-storage-gadget");
> diff --git a/drivers/usb/gadget/mass_storage.c b/drivers/usb/gadget/mass_storage.c
> index 705cc1f..16e0d4b 100644
> --- a/drivers/usb/gadget/mass_storage.c
> +++ b/drivers/usb/gadget/mass_storage.c
> @@ -72,21 +72,16 @@ static struct usb_device_descriptor msg_device_desc = {
>  	.bcdUSB =		cpu_to_le16(0x0200),
>  	.bDeviceClass =		USB_CLASS_PER_INTERFACE,
>  
> -	/* Vendor and product id can be overridden by module parameters.  */
>  	.idVendor =		cpu_to_le16(FSG_VENDOR_ID),
>  	.idProduct =		cpu_to_le16(FSG_PRODUCT_ID),
> -	/* .bcdDevice = f(hardware) */
> -	/* .iManufacturer = DYNAMIC */
> -	/* .iProduct = DYNAMIC */
> -	/* NO SERIAL NUMBER */
> -	.bNumConfigurations =	1,
>  };
>  
>  static struct usb_otg_descriptor otg_descriptor = {
>  	.bLength =		sizeof otg_descriptor,
>  	.bDescriptorType =	USB_DT_OTG,
>  
> -	/* REVISIT SRP-only hardware is possible, although
> +	/*
> +	 * REVISIT SRP-only hardware is possible, although
>  	 * it would not be called "OTG" ...
>  	 */
>  	.bmAttributes =		USB_OTG_SRP | USB_OTG_HNP,
> @@ -100,16 +95,21 @@ static const struct usb_descriptor_header *otg_desc[] = {
>  
>  /* string IDs are assigned dynamically */
>  
> -#define STRING_MANUFACTURER_IDX		0
> -#define STRING_PRODUCT_IDX		1
> -#define STRING_CONFIGURATION_IDX	2
> +enum {
> +	STRING_MANUFACTURER_IDX,
> +	STRING_PRODUCT_IDX,
> +	STRING_CONFIGURATION_IDX,
> +	STRING_SERIAL_IDX
> +};
>  
>  static char manufacturer[50];
> +static char serial[13];
>  
>  static struct usb_string strings_dev[] = {
>  	[STRING_MANUFACTURER_IDX].s = manufacturer,
>  	[STRING_PRODUCT_IDX].s = DRIVER_DESC,
>  	[STRING_CONFIGURATION_IDX].s = "Self Powered",
> +	[STRING_SERIAL_IDX].s = serial,
>  	{  } /* end of list */
>  };
>  
> @@ -167,7 +167,6 @@ static struct usb_configuration msg_config_driver = {
>  	.label			= "Linux File-Backed Storage",
>  	.bind			= msg_do_config,
>  	.bConfigurationValue	= 1,
> -	/* .iConfiguration = DYNAMIC */
>  	.bmAttributes		= USB_CONFIG_ATT_SELFPOWER,
>  };
>  
> @@ -181,7 +180,8 @@ static int __init msg_bind(struct usb_composite_dev *cdev)
>  	struct usb_gadget *gadget = cdev->gadget;
>  	int status;
>  
> -	/* Allocate string descriptor numbers ... note that string
> +	/*
> +	 * Allocate string descriptor numbers ... note that string
>  	 * contents can be overridden by the composite_dev glue.
>  	 */
>  
> @@ -201,6 +201,13 @@ static int __init msg_bind(struct usb_composite_dev *cdev)
>  	strings_dev[STRING_PRODUCT_IDX].id = status;
>  	msg_device_desc.iProduct = status;
>  
> +	fsg_string_serial_fill(serial, DRIVER_VERSION);
> +	status = usb_string_id(cdev);
> +	if (status < 0)
> +		return status;
> +	strings_dev[STRING_SERIAL_IDX].id = status;
> +	msg_device_desc.iSerialNumber = status;
> +
>  	status = usb_string_id(cdev);
>  	if (status < 0)
>  		return status;
> diff --git a/drivers/usb/gadget/multi.c b/drivers/usb/gadget/multi.c
> index a930d7f..6f7447b 100644
> --- a/drivers/usb/gadget/multi.c
> +++ b/drivers/usb/gadget/multi.c
> @@ -120,12 +120,15 @@ static const struct usb_descriptor_header *otg_desc[] = {
>  
>  #define STRING_MANUFACTURER_IDX		0
>  #define STRING_PRODUCT_IDX		1
> +#define STRING_SERIAL_IDX		2
>  
>  static char manufacturer[50];
> +static char serial[13];
>  
>  static struct usb_string strings_dev[] = {
>  	[STRING_MANUFACTURER_IDX].s = manufacturer,
>  	[STRING_PRODUCT_IDX].s = DRIVER_DESC,
> +	[STRING_SERIAL_IDX].s = serial,
>  	{  } /* end of list */
>  };
>  
> @@ -281,6 +284,9 @@ static int __init multi_bind(struct usb_composite_dev *cdev)
>  	snprintf(manufacturer, sizeof manufacturer, "%s %s with %s",
>  	         init_utsname()->sysname, init_utsname()->release,
>  	         gadget->name);
> +
> +	fsg_string_serial_fill(serial, DRIVER_VERSION);
> +
>  	status = usb_string_id(cdev);
>  	if (status < 0)
>  		goto fail2;
> @@ -293,6 +299,12 @@ static int __init multi_bind(struct usb_composite_dev *cdev)
>  	strings_dev[STRING_PRODUCT_IDX].id = status;
>  	device_desc.iProduct = status;
>  
> +	status = usb_string_id(cdev);
> +	if (status < 0)
> +		goto fail2;
> +	strings_dev[STRING_SERIAL_IDX].id = status;
> +	device_desc.iSerialNumber = status;
> +
>  #ifdef USB_ETH_RNDIS
>  	/* register our first configuration */
>  	status = usb_add_config(cdev, &rndis_config_driver);
> diff --git a/drivers/usb/gadget/storage_common.c b/drivers/usb/gadget/storage_common.c
> index 04c462f..00acae1 100644
> --- a/drivers/usb/gadget/storage_common.c
> +++ b/drivers/usb/gadget/storage_common.c
> @@ -545,6 +545,18 @@ static struct usb_gadget_strings	fsg_stringtab = {
>  };
>  
>  
> +#define fsg_string_serial_fill_n(serial, n, version) do {	\
> +		unsigned char *c = version;			\
> +		unsigned i = ((n) + 1) / 2;			\
> +		char *s = serial;				\
> +		for (; *c && --i; s += 2, ++c)			\
> +			sprintf(s, "%02X", *c);			\
> +	} while (0)
> +
> +#define fsg_string_serial_fill(serial, version)				\
> +	fsg_string_serial_fill_n(serial, ARRAY_SIZE(serial), version)
> +
> +
>   /*-------------------------------------------------------------------------*/
>  
>  /* If the next two routines are called while the gadget is registered,
> -- 
> 1.7.1
