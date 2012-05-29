Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949Ab2E2XP6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 19:15:58 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53299 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668Ab2E2XP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 19:15:57 -0400
Date: Wed, 30 May 2012 07:15:49 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: stefani@seibold.net
Cc: linux-kernel@vger.kernel.org, thomas.braunstorfinger@rohde-schwarz.com
Subject: Re: [PATCH] add new NRP power meter USB device driver
Message-ID: <20120529231549.GB28736@kroah.com>
References: <1338318858-24144-1-git-send-email-stefani@seibold.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1338318858-24144-1-git-send-email-stefani@seibold.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2012 at 09:14:18PM +0200, stefani@seibold.net wrote:
> From: Stefani Seibold <stefani@seibold.net>
> 
> This driver supports all of the Rohde&Schwarz RF Power Meter NRP Sensors. These
> sensors are intelligent standalone instruments that communicate via USB.
> 
> A power meter is a device for analyzing the RF power output level of an
> electrical device, similar to an oscilloscope.

Nice, but why is this a kernel driver?  Can't you control this device
from userspace using libusb/usbfs?

> The Power Meter Sensors will be used in a wide range of environements, like
> 
> - Manufacturing (e.g. air planes and smart phones)
> - Radio and TV broadcasting
> - Mobile communications
> - Engeeniering
> - Science Labs
> - Education
> 
> The NRP Power Meters support the following measurements:
> 
>  - Dynamic range: up to 90 dB (sensor dependent)
>  - Level range: -67 dBm to +45 dBm (sensor dependent)
>  - Frequency range: DC to 67 GHz (sensor dependent)
>  - Measurement speed: 1500 measurements per second in the buffered mode
>  - Linearity uncertainty: 0.007 dB
>  - Precise average power measurements irrespective of modulation and bandwidth
>  - Flexible measurements on up to 128 time slots per power sensor
>  - S parameter correction of components between sensor and test object

These measurements are good, but if you want to be a kernel driver, you
should tie into the IIO framework which should support a common
userspace API for these sensor readings, and not create driver-custom
ioctls for just this one device.

> The device will be controlled by a SCPI like interface.

What is scpi?

> The patch is against linux 3.5.0
> (commit 1e2aec873ad6d16538512dbb96853caa1fa076af)
> 
> The source is checked with checkpatch.pl and has no errors. Only 11
> "line over 80 characters" warnings are left. I see no reason to satisfy this
> boring punch card limit for this lines, since it will make the source noisier.
> 
> make C=1 is quiet.
> 
> Please apply it to the kernel tree.
> Thanks.
> 
> Signed-off-by: Stefani Seibold <stefani@seibold.net>
> ---
>  drivers/usb/misc/Kconfig       |   12 +
>  drivers/usb/misc/Makefile      |    1 +
>  drivers/usb/misc/nrpz.c        | 1069 ++++++++++++++++++++++++++++++++++++++++
>  include/linux/usb/nrpzmodule.h |   47 ++
>  4 files changed, 1129 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/usb/misc/nrpz.c
>  create mode 100644 include/linux/usb/nrpzmodule.h
> 
> diff --git a/drivers/usb/misc/Kconfig b/drivers/usb/misc/Kconfig
> index 1bfcd02..2c55d5f 100644
> --- a/drivers/usb/misc/Kconfig
> +++ b/drivers/usb/misc/Kconfig
> @@ -244,3 +244,15 @@ config USB_YUREX
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called yurex.
>  
> +config USB_NRPZ
> +	tristate "USB NRPZ power sensor driver support"
> +	depends on USB
> +	help
> +	  This driver supports the Rohde&Schwarz NRP RF Power Meter Sensors.
> +
> +	  These sensors are intelligent standalone instruments that
> +	  communicate via USB and provide a wide range of measurements.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called nrpz.
> +
> diff --git a/drivers/usb/misc/Makefile b/drivers/usb/misc/Makefile
> index 796ce7e..9a0364c 100644
> --- a/drivers/usb/misc/Makefile
> +++ b/drivers/usb/misc/Makefile
> @@ -25,5 +25,6 @@ obj-$(CONFIG_USB_TRANCEVIBRATOR)	+= trancevibrator.o
>  obj-$(CONFIG_USB_USS720)		+= uss720.o
>  obj-$(CONFIG_USB_SEVSEG)		+= usbsevseg.o
>  obj-$(CONFIG_USB_YUREX)			+= yurex.o
> +obj-$(CONFIG_USB_NRPZ)			+= nrpz.o
>  
>  obj-$(CONFIG_USB_SISUSBVGA)		+= sisusbvga/
> diff --git a/drivers/usb/misc/nrpz.c b/drivers/usb/misc/nrpz.c
> new file mode 100644
> index 0000000..e341703
> --- /dev/null
> +++ b/drivers/usb/misc/nrpz.c
> @@ -0,0 +1,1069 @@
> +/*
> + * Rohde & Schwarz USB NRP Zxx power meter kernel module driver
> + *
> + * Version: 4.0
> + *
> + * Copyright (c) 2012 by Rohde & Scharz GmbH & Co. KG
> + *  written by Stefani Seibold <stefani@seibold.net>
> + *
> + * Based on USB Skeleton driver written by Greg Kroah-Hartman <greg@kroah.com>
> + *
> + * This driver supports the RF Power Meter R&S ® NRP Sensors. These
> + * sensors are intelligent standalone instruments that communicate via USB
> + * and support the following measurements:
> + *
> + * - Dynamic range: up to 90 dB (sensor dependent)
> + * - Level range: -67 dBm to +45 dBm (sensor dependent)
> + * - Frequency range: DC to 67 GHz (sensor dependent)
> + * - Measurement speed: 1500 measurements per second in the buffered mode
> + * - Linearity uncertainty: 0.007 dB
> + * - Precise average power measurements irrespective of modulation and bandwidth
> + * - Flexible measurements on up to 128 time slots per power sensor
> + * - S parameter correction of components between sensor and test object
> + *
> + * History:
> + *
> + * 2012_05_18 - 4.0 - revamp for kernel inclusion
> + * 2007_05_15 - 2.0 - Ported the driver to kernel 2.6, mostly rewritten
> + * 2001_05_01 - 0.1 - first version
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.

Are you sure "any later version"?

> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

This paragraph is never needed, unless you want to track the movements
of the FSF's office for the next 40 years.

> + */
> +
> +/*
> + * Internal format of the NRPZ USB messages:
> + *
> + *  Byte 0:	Signature
> + *  Byte 1:	Error Code
> + *  Byte 2/3:	Array Index
> + *		or State (Byte 2)
> + *		or Group Number (Byte 2) / Param Number (Byte 3)
> + *  Byte 4-15:	Data depening on signature type (Byte 0):
> + *		floats, bit fields and integer are 32 bit
> + *
> + * Signature types:
> + *  'E':	single float value
> + *  'e':	single value
> + *  'A':	float array
> + *  'P':	auxiliary or peak float array
> + *  'a':	interim float array
> + *  'p':	interim auxiliary or peak float array
> + *  'F':	feature bit field
> + *  'U':	float parameter (32 bit)
> + *  'V':	bit field parameter (32 bit)
> + *  'W':	integer parameter (32 bit)
> + *  'T':	string data
> + *  'R':	receipt data (string or binary data)
> + *  'X':	internal error
> + *  'Z':	current state (Byte 2)
> + *  'z':	life sign package
> + *  'L':	float value (32 bit)
> + *  'M':	bit field value (32 bit)
> + *  'N':	long value (32 bit)
> + *  'B':	binary data
> + *
> + * State values:
> + *   0:		trigger idle
> + *   1:		trigger reserved
> + *   2:		wait for trigger
> + *   3:		trigger measuring
> + *
> + * Communication in direction from host to the device are mostly like SCPI.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/sched.h>
> +#include <linux/signal.h>
> +#include <linux/errno.h>
> +#include <linux/poll.h>
> +#include <linux/init.h>
> +#include <linux/slab.h>
> +#include <linux/fcntl.h>
> +#include <linux/module.h>
> +#include <linux/spinlock.h>
> +#include <linux/list.h>
> +#include <linux/usb.h>
> +#include <linux/version.h>
> +#include <linux/kref.h>
> +#include <linux/bitops.h>
> +#include <linux/mutex.h>
> +
> +#include <linux/usb/nrpzmodule.h>
> +
> +#if 0
> +#define CONFIG_NRP_DEBUG
> +#endif
> +#ifdef CONFIG_NRP_DEBUG
> +static int debug = 1;
> +#else
> +static int debug;
> +#endif
> +
> +module_param(debug, int, 0);
> +MODULE_PARM_DESC(debug, "Debug enabled or not");
> +
> +#define nrpz_dbg(format, arg...) \
> +	do { if (debug) printk(KERN_DEBUG "nrpz: " format "\n", ##arg); } while (0)
> +#define nrpz_err(format, arg...) \
> +	do { printk(KERN_ERR "nrpz: " format "\n", ##arg); } while (0)
> +#define nrpz_info(format, arg...) \
> +	do { printk(KERN_INFO "nrpz: " format "\n", ##arg); } while (0)

Ick, no, please use dev_dbg(), dev_err(), and dev_info() instead, don't
create your own macros.

> +/* Version Information */
> +#define DRIVER_VERSION	"v4.00"

What happened to the first 3 versions of this code?  :)

> +#define DRIVER_AUTHOR	"Stefani Seibold <stefani@seibold.net>"
> +#define DRIVER_DESC	"Rohde&Schwarz NRP-Zxx USB Powermeter"
> +
> +/* Get a minor range for your devices from the usb maintainer */
> +#define NRPZ_MINOR_BASE		192

You didn't ask me for a minor base, did you?

> +#define to_nrpz_dev(d) container_of(d, struct usb_nrpz, kref)
> +#define list_to_urb(d) container_of(d, struct urb, urb_list)

Make these inline functions instead?

> +
> +/* Define these values to match your device */

This comment can be fixed, right?

> +#define USB_RS_VENDOR_ID	0x0aad
> +#define USB_NRP_PRODUCT_ID	0x0002
> +#define USB_NRPZ21_PRODUCT_ID	0x0003
> +#define USB_NRPFU_PRODUCT_ID	0x0004
> +#define USB_FSHZ1_PRODUCT_ID	0x000b
> +#define USB_NRPZ11_PRODUCT_ID	0x000c
> +#define USB_NRPZ22_PRODUCT_ID	0x0013
> +#define USB_NRPZ23_PRODUCT_ID	0x0014
> +#define USB_NRPZ24_PRODUCT_ID	0x0015
> +#define USB_NRPZ51_PRODUCT_ID	0x0016
> +#define USB_NRPZ52_PRODUCT_ID	0x0017
> +#define USB_NRPZ55_PRODUCT_ID	0x0018
> +#define USB_NRPZ56_PRODUCT_ID	0x0019
> +#define USB_FSHZ18_PRODUCT_ID	0x001a
> +#define USB_NRPZ91_PRODUCT_ID	0x0021
> +#define USB_NRPZ81_PRODUCT_ID	0x0023
> +#define USB_NRPZ31_PRODUCT_ID	0x002c
> +#define USB_NRPZ37_PRODUCT_ID	0x002d
> +#define USB_NRPZ96_PRODUCT_ID	0x002e
> +#define USB_NRPZ27_PRODUCT_ID	0x002f
> +#define USB_NRPZ28_PRODUCT_ID	0x0051
> +#define USB_NRPZ98_PRODUCT_ID	0x0052
> +#define USB_NRPZ92_PRODUCT_ID	0x0062
> +#define USB_NRPZ57_PRODUCT_ID	0x0070
> +#define USB_NRPZ85_PRODUCT_ID	0x0083
> +#define USB_NRPC40_PRODUCT_ID	0x008F
> +#define USB_NRPC50_PRODUCT_ID	0x0090
> +#define USB_NRPZ86_PRODUCT_ID	0x0095
> +#define USB_NRPZ41_PRODUCT_ID	0x0096
> +#define USB_NRPZ61_PRODUCT_ID	0x0097
> +#define USB_NRPZ71_PRODUCT_ID	0x0098
> +#define USB_NRPZ32_PRODUCT_ID	0x009A
> +#define USB_NRPZ211_PRODUCT_ID	0x00A6
> +#define USB_NRPZ221_PRODUCT_ID	0x00A7
> +#define USB_NRPZ58_PRODUCT_ID	0x00A8
> +#define USB_NRPC33_PRODUCT_ID	0x00B6
> +#define USB_NRPC18_PRODUCT_ID	0x00BF
> +
> +/* table of devices that work with this driver */
> +static struct usb_device_id nrpz_table[] = {
> +	{USB_DEVICE(USB_RS_VENDOR_ID, USB_NRP_PRODUCT_ID)},
> +	{USB_DEVICE(USB_RS_VENDOR_ID, USB_NRPZ21_PRODUCT_ID)},
> +	{USB_DEVICE(USB_RS_VENDOR_ID, USB_NRPFU_PRODUCT_ID)},
> +	{USB_DEVICE(USB_RS_VENDOR_ID, USB_FSHZ1_PRODUCT_ID)},
> +	{USB_DEVICE(USB_RS_VENDOR_ID, USB_NRPZ11_PRODUCT_ID)},
> +	{USB_DEVICE(USB_RS_VENDOR_ID, USB_NRPZ22_PRODUCT_ID)},
> +	{USB_DEVICE(USB_RS_VENDOR_ID, USB_NRPZ23_PRODUCT_ID)},
> +	{USB_DEVICE(USB_RS_VENDOR_ID, USB_NRPZ24_PRODUCT_ID)},
> +	{USB_DEVICE(USB_RS_VENDOR_ID, USB_NRPZ51_PRODUCT_ID)},
> +	{USB_DEVICE(USB_RS_VENDOR_ID, USB_NRPZ52_PRODUCT_ID)},
> +	{USB_DEVICE(USB_RS_VENDOR_ID, USB_NRPZ55_PRODUCT_ID)},
> +	{USB_DEVICE(USB_RS_VENDOR_ID, USB_NRPZ56_PRODUCT_ID)},
> +	{USB_DEVICE(USB_RS_VENDOR_ID, USB_NRPZ57_PRODUCT_ID)},
> +	{USB_DEVICE(USB_RS_VENDOR_ID, USB_FSHZ18_PRODUCT_ID)},
> +	{USB_DEVICE(USB_RS_VENDOR_ID, USB_NRPZ91_PRODUCT_ID)},
> +	{USB_DEVICE(USB_RS_VENDOR_ID, USB_NRPZ81_PRODUCT_ID)},
> +	{USB_DEVICE(USB_RS_VENDOR_ID, USB_NRPZ31_PRODUCT_ID)},
> +	{USB_DEVICE(USB_RS_VENDOR_ID, USB_NRPZ37_PRODUCT_ID)},
> +	{USB_DEVICE(USB_RS_VENDOR_ID, USB_NRPZ96_PRODUCT_ID)},
> +	{USB_DEVICE(USB_RS_VENDOR_ID, USB_NRPZ27_PRODUCT_ID)},
> +	{USB_DEVICE(USB_RS_VENDOR_ID, USB_NRPZ28_PRODUCT_ID)},
> +	{USB_DEVICE(USB_RS_VENDOR_ID, USB_NRPZ98_PRODUCT_ID)},
> +	{USB_DEVICE(USB_RS_VENDOR_ID, USB_NRPZ92_PRODUCT_ID)},
> +	{USB_DEVICE(USB_RS_VENDOR_ID, USB_NRPZ85_PRODUCT_ID)},
> +	{USB_DEVICE(USB_RS_VENDOR_ID, USB_NRPC40_PRODUCT_ID)},
> +	{USB_DEVICE(USB_RS_VENDOR_ID, USB_NRPC50_PRODUCT_ID)},
> +	{USB_DEVICE(USB_RS_VENDOR_ID, USB_NRPZ86_PRODUCT_ID)},
> +	{USB_DEVICE(USB_RS_VENDOR_ID, USB_NRPZ41_PRODUCT_ID)},
> +	{USB_DEVICE(USB_RS_VENDOR_ID, USB_NRPZ61_PRODUCT_ID)},
> +	{USB_DEVICE(USB_RS_VENDOR_ID, USB_NRPZ71_PRODUCT_ID)},
> +	{USB_DEVICE(USB_RS_VENDOR_ID, USB_NRPZ32_PRODUCT_ID)},
> +	{USB_DEVICE(USB_RS_VENDOR_ID, USB_NRPZ211_PRODUCT_ID)},
> +	{USB_DEVICE(USB_RS_VENDOR_ID, USB_NRPZ221_PRODUCT_ID)},
> +	{USB_DEVICE(USB_RS_VENDOR_ID, USB_NRPZ58_PRODUCT_ID)},
> +	{USB_DEVICE(USB_RS_VENDOR_ID, USB_NRPC33_PRODUCT_ID)},
> +	{USB_DEVICE(USB_RS_VENDOR_ID, USB_NRPC18_PRODUCT_ID)},
> +	{} /* Terminating entry */
> +};
> +
> +MODULE_DEVICE_TABLE(usb, nrpz_table);
> +
> +/* Structure to hold all of our device specific stuff */
> +struct usb_nrpz {
> +	struct usb_device *udev;
> +	struct usb_interface *intf;

Do you really need both?

> +	unsigned minor;			/* minor number for this device */
> +	unsigned long in_use;		/* in use flag */

Why a long for this?

> +
> +	size_t in_size;			/* size of the receive buffer */
> +	size_t out_size;		/* size of the send buffer */
> +	__u8 in_epAddr;			/* address of the bulk in endpoint */
> +	__u8 out_epAddr;		/* address of the bulk out endpoint */
> +
> +	struct kref kref;
> +	wait_queue_head_t wq;
> +
> +	struct usb_anchor out_running;	/* list of in use output buffers */
> +	struct list_head out_avail;	/* list of available output buffers */
> +	spinlock_t write_lock;		/* spinlock for transmit list */
> +	struct mutex write_mutex;	/* exclusive write data semaphore */
> +
> +	struct usb_anchor in_running;	/* list of in use input buffers */
> +	struct list_head in_avail;	/* list of available input buffers */
> +	spinlock_t read_lock;		/* spinlock for receive list */
> +	struct mutex read_mutex;	/* exclusive read data semaphore */
> +
> +	struct urb out_urbs[64];	/* array of urb's for output */
> +	struct urb in_urbs[64];		/* array of urb's for input */
> +};
> +
> +/* forward declaration */
> +static struct usb_driver nrpz_driver;
> +
> +static inline void urb_list_add(spinlock_t *lock, struct urb *urb,
> +				struct list_head *head)
> +{
> +	spin_lock_irq(lock);
> +	list_add(&urb->urb_list, head);
> +	spin_unlock_irq(lock);
> +}
> +
> +static inline void urb_list_add_tail(spinlock_t *lock, struct urb *urb,
> +				struct list_head *head)
> +{
> +	spin_lock_irq(lock);
> +	list_add_tail(&urb->urb_list, head);
> +	spin_unlock_irq(lock);
> +}

Why the lists of urbs?  Why not either just create them all dynamically
all the time, or use urb anchors?

> +	case NRPZ_GETSENSORINFO:
> +	 {
> +		struct nrpz_sensor_info __user *sensor_info =
> +			(struct nrpz_sensor_info __user *)arg;
> +
> +		if (!access_ok(VERIFY_WRITE, sensor_info, sizeof(*sensor_info)))
> +			return -EFAULT;
> +
> +		__put_user(dev->udev->descriptor.bcdDevice,
> +				&sensor_info->bcdDevice);
> +		__put_user(dev->udev->descriptor.bcdUSB,
> +				&sensor_info->bcdUSB);
> +		__put_user(dev->udev->descriptor.bDescriptorType,
> +				&sensor_info->bDescriptorType);
> +		__put_user(dev->udev->descriptor.bDeviceClass,
> +				&sensor_info->bDeviceClass);
> +		__put_user(dev->udev->descriptor.bDeviceSubClass,
> +				&sensor_info->bDeviceSubClass);
> +		__put_user(dev->udev->descriptor.bDeviceProtocol,
> +				&sensor_info->bDeviceProtocol);
> +		__put_user(dev->udev->descriptor.bMaxPacketSize0,
> +				&sensor_info->bMaxPacketSize0);
> +		__put_user(dev->udev->descriptor.bNumConfigurations,
> +				&sensor_info->bNumConfigurations);
> +		__put_user(dev->udev->descriptor.iManufacturer,
> +				&sensor_info->iManufacturer);
> +		__put_user(dev->udev->descriptor.iProduct,
> +				&sensor_info->iProduct);
> +		__put_user(dev->udev->descriptor.iSerialNumber,
> +				&sensor_info->iSerialNumber);
> +		__put_user(dev->udev->descriptor.idVendor,
> +				&sensor_info->vendorId);
> +		__put_user(dev->udev->descriptor.idProduct,
> +				&sensor_info->productId);
> +		usb_string(dev->udev, dev->udev->descriptor.iManufacturer,
> +				(char __force *)sensor_info->manufacturer,
> +				sizeof(sensor_info->manufacturer));
> +		usb_string(dev->udev, dev->udev->descriptor.iProduct,
> +				(char __force *)sensor_info->productName,
> +				sizeof(sensor_info->productName));
> +		usb_string(dev->udev, dev->udev->descriptor.iSerialNumber,
> +				(char __force *)sensor_info->serialNumber,
> +				sizeof(sensor_info->serialNumber));

Why are you sending this information through an ioctl, when it is
already exported in sysfs?  That seems quite needless.

Anyway, I think the main questions are, "Why is this a kernel driver",
and "If this is a kernel driver, why not use the IIO interface"?

thanks,

greg k-h
