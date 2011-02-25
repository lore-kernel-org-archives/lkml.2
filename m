Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638Ab1BYRhP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 12:37:15 -0500
Received: from xenotime.net ([184.105.210.51]:37993 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752429Ab1BYRhO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 12:37:14 -0500
Date: Fri, 25 Feb 2011 09:37:04 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Jon Brenner <jbrenner@taosinc.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH: 2.6.37 1/1] TAOS 258x: Device Driver
Message-Id: <20110225093704.0571c20e.rdunlap@xenotime.net>
In-Reply-To: <1298600118.3238.10.camel@jonz-ubuntu>
References: <1298600118.3238.10.camel@jonz-ubuntu>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Feb 2011 20:15:18 -0600 Jon Brenner wrote:

> From: J. August Brenner <jbrenner@taosinc.com>
> 
> This driver supports the TAOS tsl258x family of ALS sensors.
> This driver provides ALS data (lux), and device configuration via ioctl,
> input_event, sysfs/iio methods.  These methods are provided to support
> varied access requirements and integrated into a single driver.
> Thus, adverting the need for multiple releases of similar code.
> More significantly, this driver provides the capability to be fed 'glass
> coefficients' to accommodate varying system designs (bezels, faceplates,
> etc.).  
> 
> Signed-off-by: Jon August Brenner <jbrenner@taosinc.com>
> 
> ---
> diff -Naurp drivers-orig/Kconfig drivers/Kconfig
> --- drivers-orig/Kconfig	2011-01-04 18:50:19.000000000 -0600
> +++ drivers/Kconfig	2011-02-24 16:03:53.536188000 -0600

Wrong source tree level:  diffs should begin with the top-level linux directory.

> @@ -13,6 +13,13 @@ config SENSORS_TSL2563
>  	 This driver can also be built as a module.  If so, the module
>  	 will be called tsl2563.
>  
> +config TAOS_258x
> +	tristate "TAOS TSL258x device driver"
> +	default m

Don't enable unnecessary drivers.

> +	help
> +	  Provides support for the TAOS tsl258x family of devices.
> +	  Access ALS data via iio, sysfs, input_event, and ioctl methods.
> +
>  config SENSORS_ISL29018
>          tristate "ISL 29018 light and proximity sensor"
>          depends on I2C
> diff -Naurp drivers-orig/Makefile drivers/Makefile
> --- drivers-orig/Makefile	2011-01-04 18:50:19.000000000 -0600
> +++ drivers/Makefile	2011-02-24 16:04:31.701642000 -0600

This isn't drivers/Makefile, is it?
This is drivers/hwmon/Makefile or drivers/als/Makefile ?

> @@ -3,4 +3,5 @@
>  #
>  
>  obj-$(CONFIG_SENSORS_TSL2563)	+= tsl2563.o
> +obj-$(CONFIG_TAOS_258x)	+= tsl258x.o
>  obj-$(CONFIG_SENSORS_ISL29018)	+= isl29018.o
> diff -Naurp drivers-orig/tsl258x.c drivers/tsl258x.c
> --- drivers-orig/tsl258x.c	1969-12-31 18:00:00.000000000 -0600
> +++ drivers/tsl258x.c	2011-02-24 14:07:43.416960000 -0600

What is the real path here?

and please include a full diffstat so that we can see what files are being
added/changed.  Hint:  read Documentation/SubmittingPatches.

> @@ -0,0 +1,2055 @@

[snippage]

I didn't read all of Jonathan's comments, but they are not
addressed in this patch.

> +/*........................................................................*/
> +/* Various /misc. emun*/

                     ^^^^ enum */

> +enum {
> +	TAOS_CHIP_UNKNOWN = 0, TAOS_CHIP_WORKING = 1, TAOS_CHIP_SLEEP = 2
> +} TAOS_CHIP_WORKING_STATUS;

> +/* ------ Mutex ------*/
> +DEFINE_MUTEX(als_mutex);

Drop obvious comments. (multiple)

> +struct delayed_work *luxUd;

Strange variable name (no camelcase, please).

> +/*........................................................................*/
> +/*
> + Initial values for device - this values can/will be changed by driver.
> + and applications as needed.
> + These values are dynamic.
> + */

above & below:  Please use the usual kernel multi-line comment style:

/*
 * comment text line 1
 * comment text line 2
 */

> +/*
> + This structure is intentionally large to accommodate updates via
> + ioctl and proc input methods.
> + */


> +struct taos_lux *taos_device_luxP;

ugh

> +/*===========================================================================*/
> +/**@defgroup Initialization Driver Initialization
> + * The sections applies to functions for driver initialization, instantiation,
> + * _exit, \n
> + * and user-land application invoking (ie. open).\n
> + * Also included in this section is the initial interrupt handler (handler
> + * bottom halves are in the respective
> + * sections).
> + * @{
> + */

What kind of doc formatting is that?
Please use kernel-doc for kernel tree doc comments, or just use C-style
comments or plain text, but not that stuff.
For kernel-doc info, see Documentation/kernel-doc-nano-HOWTO.txt.


> +exit_1: device_destroy(taos_class, MKDEV(MAJOR(taos_dev_number), 0));
> +exit_2: cdev_del(&chip->cdev);
> +	kfree(chip);
> +exit_3: class_destroy(taos_class);
> +	unregister_chrdev_region(taos_dev_number, MAX_NUM_DEVICES);
> +

Put labels on a line by themselves (above), like the one below.

> +exit_4:
> +
> +	printk(KERN_INFO "\n\nallocating iio device\n");
> +/**
> + * Driver exit
> + */
> +static void __exit taos_exit(void)
> +{
> +	printk(KERN_INFO "TAOS driver __exit\n");

Drop that printk.

> +}
> +
> +/**
> + * Client probe function - When a valid device is found, the driver's device
> + * data structure is updated, and initialization completes successfully.
> + */

"/**" in the kernel source tree means "the beginning of a kernel-doc comment,"
so please use it for that and only that. (MANY places)


> +static ssize_t taos_interrupt_store(struct device *dev,
> +    struct device_attribute *attr, const char *buf, size_t len)
> +{
> +	unsigned long value;

Please leave an empty line between function local data and code. (multiple)

> +	if (strict_strtoul(buf, 0, &value))
> +		return -EINVAL;


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
