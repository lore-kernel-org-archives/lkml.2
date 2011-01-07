Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034Ab1AGI4P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 03:56:15 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58327 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025Ab1AGI4N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 03:56:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BlPQwgWi5VvV16bSLJr3g1UL3FSQCRVpwOpsOGAO21xpzR/Uy+opTGGOSLv9HENOnr
         KKDS5TGmmFsaDJq0bkPSgmHpAH6qS4x4SX5B7p+Uusa0IDcZfOwtdCp6mhXpBndkTeiO
         EolggtbUzJkEdfNtkXBJcKdmqopW5jsqqpLcI=
MIME-Version: 1.0
In-Reply-To: <20110107074115.GH30215@kai-debian>
References: <20110106025949.GJ9496@kai-debian>
	<20110107074115.GH30215@kai-debian>
Date: Fri, 7 Jan 2011 09:56:11 +0100
Message-ID: <AANLkTik=x-OTWGzRB2BgB1u748EDM=B3nsGpWbR8D-C5@mail.gmail.com>
Subject: Re: [PATCH V2] platform-driver-x86: ACPI EC Extra driver for Oaktrail
From: Corentin Chary <corentin.chary@gmail.com>
To: Yin Kangkai <kangkai.yin@linux.intel.com>
Cc: platform-driver-x86 <platform-driver-x86@vger.kernel.org>,
        linux-kernel@vger.kernel.org, "Wang, Yong Y" <yong.y.wang@intel.com>,
        "Liu, Bing Wei" <bing.wei.liu@intel.com>,
        Matthew Garrett <mjg@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 7, 2011 at 8:41 AM, Yin Kangkai <kangkai.yin@linux.intel.com> wrote:
> Patch V2
> Changes from V1:
>  - remove wifi, bt, gps, wwan from /sys/devices/platform.
>  - add some helper function for rfkill alloc and rfkill cleanup.
>  - add MODULE_ALIAS.
>  - add Documentation/ABI/testing/sysfs-platform-intel-oaktrail
>  - various other minor changes.
>  - bump driver version from 0.1 to 0.2
>
> Thanks Corentin Chary and Joey Lee for the review.
>
> From ab28d41e89b40e0ab1d73489b7d1a9f6e745c14a Mon Sep 17 00:00:00 2001
> From: Yin Kangkai <kangkai.yin@intel.com>
> Date: Wed, 22 Dec 2010 10:53:36 +0800
> Subject: [PATCH] platform-driver-x86: ACPI EC Extra driver for Oaktrail
>
> This driver implements an Extra ACPI EC driver for products based on Intel
> Oaktrail platform.  It is programming the EC space, through existing ACPI EC
> driver, to provide user space layer the sysfs and rfkill interfaces to
> enable/disable the Camera, Bluetooth, GPS, WiFi, 3G, and to show the status of
> Touchscreen.
>
> Signed-off-by: Yin Kangkai <kangkai.yin@intel.com>
> ---
>  .../ABI/testing/sysfs-platform-intel-oaktrail      |   13 +
>  drivers/platform/x86/Kconfig                       |    9 +
>  drivers/platform/x86/Makefile                      |    1 +
>  drivers/platform/x86/intel_oaktrail.c              |  347 ++++++++++++++++++++
>  4 files changed, 370 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/ABI/testing/sysfs-platform-intel-oaktrail
>  create mode 100644 drivers/platform/x86/intel_oaktrail.c
>
> diff --git a/Documentation/ABI/testing/sysfs-platform-intel-oaktrail b/Documentation/ABI/testing/sysfs-platform-intel-oaktrail
> new file mode 100644
> index 0000000..0512235
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-platform-intel-oaktrail
> @@ -0,0 +1,13 @@
> +What:          /sys/devices/platform/intel_oaktrail/camera
> +Date:          Jan 2011
> +KernelVersion: 2.6.37
> +Contact:       "Yin Kangkai" <kangkai.yin@intel.com>
> +Description:
> +               Control the camera. 1 means on, 0 means off.
> +
> +What:          /sys/devices/platform/intel_oaktrail/touchscreen
> +Date:          Jan 2011
> +KernelVersion: 2.6.37
> +Contact:       "Yin Kangkai" <kangkai.yin@intel.com>
> +Description:
> +               Show the status of the touch screen. 1 means on, 0 means off.
> diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
> index 2b4038a..d1f6981 100644
> --- a/drivers/platform/x86/Kconfig
> +++ b/drivers/platform/x86/Kconfig
> @@ -655,4 +655,13 @@ config XO1_RFKILL
>          Support for enabling/disabling the WLAN interface on the OLPC XO-1
>          laptop.
>
> +config INTEL_OAKTRAIL
> +       tristate "Intel Oaktrail Platform Extras"
> +       depends on ACPI
> +       depends on RFKILL
> +       ---help---
> +         Intel Oaktrail platform need this driver to provide interfaces to
> +         enable/disable the Camera, WiFi, BT etc. devices. If in doubt, say Y
> +         here; it will only load on supported platforms.
> +
>  endif # X86_PLATFORM_DEVICES
> diff --git a/drivers/platform/x86/Makefile b/drivers/platform/x86/Makefile
> index 7ff60e6..add8ab7 100644
> --- a/drivers/platform/x86/Makefile
> +++ b/drivers/platform/x86/Makefile
> @@ -35,3 +35,4 @@ obj-$(CONFIG_INTEL_IPS)               += intel_ips.o
>  obj-$(CONFIG_GPIO_INTEL_PMIC)  += intel_pmic_gpio.o
>  obj-$(CONFIG_XO1_RFKILL)       += xo1-rfkill.o
>  obj-$(CONFIG_IBM_RTL)          += ibm_rtl.o
> +obj-$(CONFIG_INTEL_OAKTRAIL)   += intel_oaktrail.o
> diff --git a/drivers/platform/x86/intel_oaktrail.c b/drivers/platform/x86/intel_oaktrail.c
> new file mode 100644
> index 0000000..9ec71c5
> --- /dev/null
> +++ b/drivers/platform/x86/intel_oaktrail.c
> @@ -0,0 +1,347 @@
> +/*
> +  Copyright (C) 2010 Intel Corporation
> +  Author: Yin Kangkai (kangkai.yin@intel.com)
> +
> +  based on Compal driver
> +
> +  Copyright (C) 2008 Cezary Jackiewicz <cezary.jackiewicz (at) gmail.com>
> +
> +  based on MSI driver
> +
> +  Copyright (C) 2006 Lennart Poettering <mzxreary (at) 0pointer (dot) de>
> +
> +  This program is free software; you can redistribute it and/or modify
> +  it under the terms of the GNU General Public License as published by
> +  the Free Software Foundation; either version 2 of the License, or
> +  (at your option) any later version.
> +
> +  This program is distributed in the hope that it will be useful, but
> +  WITHOUT ANY WARRANTY; without even the implied warranty of
> +  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
> +  General Public License for more details.
> +
> +  You should have received a copy of the GNU General Public License
> +  along with this program; if not, write to the Free Software
> +  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
> +  02110-1301, USA.
> + */
> +
> +/*
> + * intel_oaktrail.c - Intel OakTrail Platform support.
> + *
> + * This driver exports a few files in /sys/devices/platform/intel_oaktrail/:
> + *
> + * camera - Camera subsystem enabled: contains either 0 or 1. (rw)
> + * touchscreen - Touchscreen subsystem enabled: contains either 0 or 1. (ro)
> + *
> + * In addition to these platform device attributes, the driver registers itself
> + * in the Linux rfkill subsystem for these components:
> + *
> + * wifi
> + * bluetooth
> + * wwan (3g)
> + * gps
> + *
> + * and is available to userspace under /sys/class/rfkill/rfkillX/
> + *
> + * This driver might work on other products based on Oaktrail. If you
> + * want to try it you can pass force=1 as argument to the module which
> + * will force it to load even when the DMI data doesn't identify the
> + * product as compatible.
> + */
> +
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/acpi.h>
> +#include <linux/platform_device.h>
> +#include <linux/dmi.h>
> +#include <linux/rfkill.h>
> +
> +#define DRIVER_NAME    "intel_oaktrail"
> +#define DRIVER_VERSION "0.2"
> +
> +/*
> + * This is the devices status address in EC space, and the control bits
> + * definition:
> + *
> + * (1 << 0):   Camera enable/disable, RW.
> + * (1 << 1):   Bluetooth enable/disable, RW.
> + * (1 << 2):   GPS enable/disable, RW.
> + * (1 << 3):   WiFi enable/disable, RW.
> + * (1 << 4):   WWAN (3G) enable/disalbe, RW.
> + * (1 << 5):   Touchscreen enable/disable, Read Only.
> + */
> +#define OT_EC_DEVICE_STATE_ADDRESS     0xD6
> +
> +#define OT_EC_CAMERA_MASK      (1 << 0)
> +#define OT_EC_BT_MASK          (1 << 1)
> +#define OT_EC_GPS_MASK         (1 << 2)
> +#define OT_EC_WIFI_MASK                (1 << 3)
> +#define OT_EC_WWAN_MASK                (1 << 4)
> +#define OT_EC_TS_MASK          (1 << 5)
> +
> +static int force;
> +module_param(force, bool, 0);
> +MODULE_PARM_DESC(force, "Force driver load, ignore DMI data");
> +
> +static struct platform_device *oaktrail_device;
> +static struct rfkill *bt_rfkill;
> +static struct rfkill *gps_rfkill;
> +static struct rfkill *wifi_rfkill;
> +static struct rfkill *wwan_rfkill;
> +
> +#define SIMPLE_MASKED_STORE_SHOW(NAME, MASK)                           \
> +static ssize_t NAME##_show(struct device *dev,                         \
> +       struct device_attribute *attr, char *buf)                       \
> +{                                                                      \
> +       u8 value;                                                       \
> +       ec_read(OT_EC_DEVICE_STATE_ADDRESS, &value);                    \
> +       return sprintf(buf, "%d\n", ((value & MASK) != 0));             \
> +}                                                                      \
> +static ssize_t NAME##_store(struct device *dev,                                \
> +       struct device_attribute *attr, const char *buf, size_t count)   \
> +{                                                                      \
> +       int state;                                                      \
> +       u8 old_val;                                                     \
> +       ec_read(OT_EC_DEVICE_STATE_ADDRESS, &old_val);                  \
> +       if (sscanf(buf, "%d", &state) != 1 || (state < 0 || state > 1)) \
> +               return -EINVAL;                                         \
> +       ec_write(OT_EC_DEVICE_STATE_ADDRESS, state ?                    \
> +                (old_val | MASK) : (old_val & ~MASK));                 \
> +       return count;                                                   \
> +}
> +
> +SIMPLE_MASKED_STORE_SHOW(camera, OT_EC_CAMERA_MASK)
> +SIMPLE_MASKED_STORE_SHOW(touchscreen, OT_EC_TS_MASK)
> +
> +static DEVICE_ATTR(camera, 0644, camera_show, camera_store);
> +static DEVICE_ATTR(touchscreen, 0444, touchscreen_show, NULL);
> +
> +static struct attribute *oaktrail_attributes[] = {
> +       &dev_attr_camera.attr,
> +       &dev_attr_touchscreen.attr,
> +       NULL
> +};
> +
> +static struct attribute_group oaktrail_attribute_group = {
> +       .attrs = oaktrail_attributes
> +};
> +
> +static int oaktrail_rfkill_set(void *data, bool blocked)
> +{
> +       u8 value;
> +       u8 result;
> +       unsigned long radio = (unsigned long) data;
> +
> +       ec_read(OT_EC_DEVICE_STATE_ADDRESS, &result);
> +
> +       if (!blocked)
> +               value = (u8) (result | radio);
> +       else
> +               value = (u8) (result & ~radio);
> +
> +       ec_write(OT_EC_DEVICE_STATE_ADDRESS, value);
> +
> +       return 0;
> +}
> +
> +static const struct rfkill_ops oaktrail_rfkill_ops = {
> +       .set_block = oaktrail_rfkill_set,
> +};
> +
> +static struct rfkill *oaktrail_rfkill_new(char *name, enum rfkill_type type,
> +                                         unsigned long mask)
> +{
> +       int err;
> +       struct rfkill *rfkill_dev;
> +
> +       rfkill_dev = rfkill_alloc(name, &oaktrail_device->dev, type,
> +                                 &oaktrail_rfkill_ops, (void *)mask);
> +       if (!rfkill_dev)
> +               return ERR_PTR(-ENOMEM);
> +
> +       err = rfkill_register(rfkill_dev);

Maybe you should add a rfkill_init_sw_state() call here, to be sure
that the rfkill initial state is right.

> +       if (err) {
> +               rfkill_destroy(rfkill_dev);
> +               return ERR_PTR(err);
> +       }
> +       return rfkill_dev;
> +}
> +
> +static inline void _oaktrail_rfkill_cleanup(struct rfkill *rf)

I don't know if the coding style allow _ function prefix, I used to
believe it did
not, but I checked Documentation/CodingStyle, and I found nothing about that,
so it's probably ok.

> +{
> +       if (rf) {
> +               rfkill_unregister(rf);
> +               rfkill_destroy(rf);
> +       }
> +
> +       return;

We don't need that return

> +}
> +
> +static void oaktrail_rfkill_cleanup(void)
> +{
> +       _oaktrail_rfkill_cleanup(wifi_rfkill);
> +       _oaktrail_rfkill_cleanup(bt_rfkill);
> +       _oaktrail_rfkill_cleanup(gps_rfkill);
> +       _oaktrail_rfkill_cleanup(wwan_rfkill);
> +
> +       return;

And that one

> +}
> +
> +static int oaktrail_rfkill_init(void)
> +{
> +       int ret;
> +
> +       wifi_rfkill = oaktrail_rfkill_new("oaktrail-wifi",
> +                                         RFKILL_TYPE_WLAN,
> +                                         OT_EC_WIFI_MASK);
> +       if (IS_ERR(wifi_rfkill)) {
> +               ret = PTR_ERR(wifi_rfkill);
> +               wifi_rfkill = NULL;
> +               goto cleanup;
> +       }
> +
> +       bt_rfkill = oaktrail_rfkill_new("oaktrail-bluetooth",
> +                                       RFKILL_TYPE_BLUETOOTH,
> +                                       OT_EC_BT_MASK);
> +       if (IS_ERR(bt_rfkill)) {
> +               ret = PTR_ERR(bt_rfkill);
> +               bt_rfkill = NULL;
> +               goto cleanup;
> +       }
> +
> +       gps_rfkill = oaktrail_rfkill_new("oaktrail-gps",
> +                                        RFKILL_TYPE_GPS,
> +                                        OT_EC_GPS_MASK);
> +       if (IS_ERR(gps_rfkill)) {
> +               ret = PTR_ERR(gps_rfkill);
> +               gps_rfkill = NULL;
> +               goto cleanup;
> +       }
> +
> +       wwan_rfkill = oaktrail_rfkill_new("oaktrail-wwan",
> +                                         RFKILL_TYPE_WWAN,
> +                                         OT_EC_WWAN_MASK);
> +       if (IS_ERR(wwan_rfkill)) {
> +               ret = PTR_ERR(wwan_rfkill);
> +               wwan_rfkill = NULL;
> +               goto cleanup;
> +       }
> +
> +       return 0;
> +
> +cleanup:
> +       oaktrail_rfkill_cleanup();
> +       return ret;
> +}
> +
> +static int __devinit oaktrail_probe(struct platform_device *pdev)
> +{
> +       return sysfs_create_group(&pdev->dev.kobj, &oaktrail_attribute_group);
> +}
> +
> +static int __devexit oaktrail_remove(struct platform_device *pdev)
> +{
> +       sysfs_remove_group(&pdev->dev.kobj, &oaktrail_attribute_group);
> +
> +       return 0;
> +}
> +
> +static struct platform_driver oaktrail_driver = {
> +       .driver = {
> +               .name = DRIVER_NAME,
> +               .owner = THIS_MODULE,
> +       },
> +       .probe  = oaktrail_probe,
> +       .remove = __devexit_p(oaktrail_remove)
> +};
> +
> +static int dmi_check_cb(const struct dmi_system_id *id)
> +{
> +       pr_info("Identified model '%s'\n", id->ident);
> +       return 0;
> +}
> +
> +static struct dmi_system_id __initdata oaktrail_dmi_table[] = {
> +       {
> +               .ident = "OakTrail platform",
> +               .matches = {
> +                       DMI_MATCH(DMI_PRODUCT_NAME, "OakTrail platform"),
> +               },
> +               .callback = dmi_check_cb
> +       },
> +       { }
> +};
> +
> +static int __init oaktrail_init(void)
> +{
> +       int ret;
> +
> +       if (acpi_disabled) {
> +               pr_err("ACPI needs to be enabled for this driver to work!\n");
> +               return -ENODEV;
> +       }
> +
> +       if (!force && !dmi_check_system(oaktrail_dmi_table)) {
> +               pr_err("Platform not recognized (You could try the module's force-parameter)");
> +               return -ENODEV;
> +       }
> +
> +       ret = platform_driver_register(&oaktrail_driver);
> +       if (ret) {
> +               pr_warning("Unable to register platform driver\n");
> +               goto err_driver_reg;
> +       }
> +
> +       oaktrail_device = platform_device_alloc(DRIVER_NAME, -1);
> +       if (!oaktrail_device) {
> +               pr_warning("Unable to allocate platform device\n");
> +               ret = -ENOMEM;
> +               goto err_device_alloc;
> +       }
> +
> +       ret = platform_device_add(oaktrail_device);
> +       if (ret) {
> +               pr_warning("Unable to add platform device\n");
> +               goto err_device_add;
> +       }
> +
> +       ret = oaktrail_rfkill_init();
> +       if (ret) {
> +               pr_warning("Setup rfkill failed\n");
> +               goto err_rfkill;
> +       }
> +
> +       pr_info("Driver "DRIVER_VERSION" successfully loaded\n");
> +       return 0;
> +
> +err_rfkill:
> +       platform_device_del(oaktrail_device);
> +err_device_add:
> +       platform_device_put(oaktrail_device);
> +err_device_alloc:
> +       platform_driver_unregister(&oaktrail_driver);
> +err_driver_reg:
> +       return ret;
> +}
> +
> +static void __exit oaktrail_cleanup(void)
> +{
> +       platform_device_unregister(oaktrail_device);
> +       platform_driver_unregister(&oaktrail_driver);
> +       oaktrail_rfkill_cleanup();
> +
> +       pr_info("Driver unloaded\n");
> +}
> +
> +module_init(oaktrail_init);
> +module_exit(oaktrail_cleanup);
> +
> +MODULE_AUTHOR("Yin Kangkai (kangkai.yin@intel.com)");
> +MODULE_DESCRIPTION("Intel Oaktrail Platform ACPI Extras");
> +MODULE_VERSION(DRIVER_VERSION);
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS("dmi:*:svnIntelCorporation:pnOakTrailplatform:*");
> --
> 1.6.5
>
>

-- 
Corentin Chary
http://xf.iksaif.net
