Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019Ab0LPRBO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 12:01:14 -0500
Received: from imr4.ericy.com ([198.24.6.8]:40405 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754887Ab0LPRBL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 12:01:11 -0500
Date: Thu, 16 Dec 2010 09:00:18 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Matthew Garrett <mjg@redhat.com>
CC: "rydberg@euromail.se" <rydberg@euromail.se>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: [lm-sensors] [PATCH 1/2] applesmc: Use PnP rather than
 hardcoding resources and devices
Message-ID: <20101216170018.GA8140@ericsson.com>
References: <1292513589-14651-1-git-send-email-mjg@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1292513589-14651-1-git-send-email-mjg@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 16, 2010 at 10:33:08AM -0500, Matthew Garrett wrote:
> The AppleSMC device is described in ACPI, including a list of its resources.
> We should use those rather than hardcoding the ports. A side-effect is that
> we can then remove the DMI matching, since there's a unique identifier to
> indicate that the machine has one of these devices.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>

Matthew,

I am having trouble applying this patch to my -next tree. The driver there
(and in the official -next tree) has subtle differences to your version.
What tree is your patch based on ? Can you rebase it to the -next tree and resubmit ?

Couple of comments below; not necessarily complete, since I can not apply the patch.
I hope Henrik can comment on the merits of the patch itself, ie if it is known to work
with all systems.

Thanks,
Guenter

> ---
>  drivers/hwmon/applesmc.c |  185 +++++++++++++++++++++++-----------------------
>  1 files changed, 91 insertions(+), 94 deletions(-)
> 
> diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
> index ee91d69..dbe3fa6 100644
> --- a/drivers/hwmon/applesmc.c
> +++ b/drivers/hwmon/applesmc.c
> @@ -30,7 +30,6 @@
>  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> 
>  #include <linux/delay.h>
> -#include <linux/platform_device.h>
>  #include <linux/input-polldev.h>
>  #include <linux/kernel.h>
>  #include <linux/slab.h>
> @@ -43,11 +42,13 @@
>  #include <linux/leds.h>
>  #include <linux/hwmon.h>
>  #include <linux/workqueue.h>
> +#include <linux/slab.h>
> +#include <linux/pnp.h>
> 
>  /* data port used by Apple SMC */
> -#define APPLESMC_DATA_PORT     0x300
> +#define APPLESMC_DATA_PORT     0x0
>  /* command/status port used by Apple SMC */
> -#define APPLESMC_CMD_PORT      0x304
> +#define APPLESMC_CMD_PORT      0x4
> 
>  #define APPLESMC_NR_PORTS      32 /* 0x300-0x31f */
> 
> @@ -76,6 +77,8 @@
>  #define MOTION_SENSOR_Z_KEY    "MO_Z" /* r-o sp78 (2 bytes) */
>  #define MOTION_SENSOR_KEY      "MOCN" /* r/w ui16 */
> 
> +#define NOTIFICATION_KEY       "NTOK"
> +
>  #define FANS_COUNT             "FNum" /* r-o ui8 */
>  #define FANS_MANUAL            "FS! " /* r-w ui16 */
>  #define FAN_ID_FMT             "F%dID" /* r-o char[16] */
> @@ -103,6 +106,14 @@ static const char *const fan_speed_fmt[] = {
>  #define to_index(attr) (to_sensor_dev_attr(attr)->index & 0xffff)
>  #define to_option(attr) (to_sensor_dev_attr(attr)->index >> 16)
> 
> +struct applesmc_pnp_device {
> +       int iobase;
> +       int iolen;
> +};
> +
> +struct pnp_dev *pdev;
> +struct applesmc_pnp_device *pnp_device;
> +
Please make those variables static.

>  /* Dynamic device node attributes */
>  struct applesmc_dev_attr {
>         struct sensor_device_attribute sda;     /* hwmon attributes */
> @@ -143,7 +154,6 @@ static struct applesmc_registers {
>  } smcreg;
> 
>  static const int debug;
> -static struct platform_device *pdev;
>  static s16 rest_x;
>  static s16 rest_y;
>  static u8 backlight_state[2];
> @@ -159,6 +169,16 @@ static unsigned int key_at_index;
> 
>  static struct workqueue_struct *applesmc_led_wq;
> 
> +static u8 applesmc_read_reg(u8 reg)
> +{
> +       return inb(pnp_device->iobase + reg);
> +}
> +
> +static void applesmc_write_reg(u8 val, u8 reg)
> +{
> +       outb(val, pnp_device->iobase + reg);
> +}
> +
>  /*
>   * __wait_status - Wait up to 32ms for the status port to get a certain value
>   * (masked with 0x0f), returning zero if the value is obtained.  Callers must
> @@ -172,7 +192,8 @@ static int __wait_status(u8 val)
> 
>         for (us = APPLESMC_MIN_WAIT; us < APPLESMC_MAX_WAIT; us <<= 1) {
>                 udelay(us);
> -               if ((inb(APPLESMC_CMD_PORT) & APPLESMC_STATUS_MASK) == val) {
> +               if ((applesmc_read_reg(APPLESMC_CMD_PORT)
> +                    & APPLESMC_STATUS_MASK) == val) {
>                         return 0;
>                 }
>         }
> @@ -189,9 +210,10 @@ static int send_command(u8 cmd)
>  {
>         int us;
>         for (us = APPLESMC_MIN_WAIT; us < APPLESMC_MAX_WAIT; us <<= 1) {
> -               outb(cmd, APPLESMC_CMD_PORT);
> +               applesmc_write_reg(cmd, APPLESMC_CMD_PORT);
>                 udelay(us);
> -               if ((inb(APPLESMC_CMD_PORT) & APPLESMC_STATUS_MASK) == 0x0c)
> +               if ((applesmc_read_reg(APPLESMC_CMD_PORT)
> +                    & APPLESMC_STATUS_MASK) == 0x0c)
>                         return 0;
>         }
>         return -EIO;
> @@ -202,7 +224,7 @@ static int send_argument(const char *key)
>         int i;
> 
>         for (i = 0; i < 4; i++) {
> -               outb(key[i], APPLESMC_DATA_PORT);
> +               applesmc_write_reg(key[i], APPLESMC_DATA_PORT);
>                 if (__wait_status(0x04))
>                         return -EIO;
>         }
> @@ -218,14 +240,14 @@ static int read_smc(u8 cmd, const char *key, u8 *buffer, u8 len)
>                 return -EIO;
>         }
> 
> -       outb(len, APPLESMC_DATA_PORT);
> +       applesmc_write_reg(len, APPLESMC_DATA_PORT);
> 
>         for (i = 0; i < len; i++) {
>                 if (__wait_status(0x05)) {
>                         pr_warn("%s: read data fail\n", key);
>                         return -EIO;
>                 }
> -               buffer[i] = inb(APPLESMC_DATA_PORT);
> +               buffer[i] = applesmc_read_reg(APPLESMC_DATA_PORT);
>         }
> 
>         return 0;
> @@ -240,14 +262,14 @@ static int write_smc(u8 cmd, const char *key, const u8 *buffer, u8 len)
>                 return -EIO;
>         }
> 
> -       outb(len, APPLESMC_DATA_PORT);
> +       applesmc_write_reg(len, APPLESMC_DATA_PORT);
> 
>         for (i = 0; i < len; i++) {
>                 if (__wait_status(0x04)) {
>                         pr_warn("%s: write data fail\n", key);
>                         return -EIO;
>                 }
> -               outb(buffer[i], APPLESMC_DATA_PORT);
> +               applesmc_write_reg(buffer[i], APPLESMC_DATA_PORT);
>         }
> 
>         return 0;
> @@ -566,20 +588,6 @@ static void applesmc_destroy_smcreg(void)
>         memset(&smcreg, 0, sizeof(smcreg));
>  }
> 
> -/* Device model stuff */
> -static int applesmc_probe(struct platform_device *dev)
> -{
> -       int ret;
> -
> -       ret = applesmc_init_smcreg();
> -       if (ret)
> -               return ret;
> -
> -       applesmc_device_init();
> -
> -       return 0;
> -}
> -
>  /* Synchronize device with memorized backlight state */
>  static int applesmc_pm_resume(struct device *dev)
>  {
> @@ -600,15 +608,6 @@ static const struct dev_pm_ops applesmc_pm_ops = {
>         .restore = applesmc_pm_restore,
>  };
> 
> -static struct platform_driver applesmc_driver = {
> -       .probe = applesmc_probe,
> -       .driver = {
> -               .name = "applesmc",
> -               .owner = THIS_MODULE,
> -               .pm = &applesmc_pm_ops,
> -       },
> -};
> -
>  /*
>   * applesmc_calibrate - Set our "resting" values.  Callers must
>   * hold applesmc_lock.
> @@ -1174,72 +1173,48 @@ static void applesmc_release_key_backlight(void)
>         destroy_workqueue(applesmc_led_wq);
>  }
> 
> -static int applesmc_dmi_match(const struct dmi_system_id *id)
> +static int __devinit applesmc_pnp_probe(struct pnp_dev *dev,
> +                                       const struct pnp_device_id *dev_id)
>  {
> -       return 1;
> -}
> +       int ret;
> +       struct resource *res;
> +       struct applesmc_pnp_device *applesmc_pnp_device;
> 
> -/* Note that DMI_MATCH(...,"MacBook") will match "MacBookPro1,1".
> - * So we need to put "Apple MacBook Pro" before "Apple MacBook". */
> -static __initdata struct dmi_system_id applesmc_whitelist[] = {
> -       { applesmc_dmi_match, "Apple MacBook Air", {
> -         DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
> -         DMI_MATCH(DMI_PRODUCT_NAME, "MacBookAir") },
> -       },
> -       { applesmc_dmi_match, "Apple MacBook Pro", {
> -         DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
> -         DMI_MATCH(DMI_PRODUCT_NAME,"MacBookPro") },
> -       },
> -       { applesmc_dmi_match, "Apple MacBook", {
> -         DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
> -         DMI_MATCH(DMI_PRODUCT_NAME,"MacBook") },
> -       },
> -       { applesmc_dmi_match, "Apple Macmini", {
> -         DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
> -         DMI_MATCH(DMI_PRODUCT_NAME,"Macmini") },
> -       },
> -       { applesmc_dmi_match, "Apple MacPro", {
> -         DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
> -         DMI_MATCH(DMI_PRODUCT_NAME, "MacPro") },
> -       },
> -       { applesmc_dmi_match, "Apple iMac", {
> -         DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
> -         DMI_MATCH(DMI_PRODUCT_NAME,"iMac") },
> -       },
> -       { .ident = NULL }
> -};
> +       pdev = dev;
> 
> -static int __init applesmc_init(void)
> -{
> -       int ret;
> +       applesmc_pnp_device = kzalloc(sizeof(struct applesmc_pnp_device),
> +                                     GFP_KERNEL);
> 
> -       if (!dmi_check_system(applesmc_whitelist)) {
> -               pr_warn("supported laptop not found!\n");
> -               ret = -ENODEV;
> +       if (!applesmc_pnp_device) {
> +               ret = -ENOMEM;
>                 goto out;
>         }
> 
> -       if (!request_region(APPLESMC_DATA_PORT, APPLESMC_NR_PORTS,
> -                                                               "applesmc")) {
> +       pnp_device = applesmc_pnp_device;
> +
Just wondering ...  applesmc_pnp_device doesn't seem to be necessary. 
Why not just use the global variable directly if you have it anyway ?

> +       pnp_set_drvdata(dev, applesmc_pnp_device);
> +

... but then since you assign it to drvdata, can you get rid of the global variable 
and use pnp_get_drvdata() whereever it is needed instead ?

> +       res = pnp_get_resource(dev, IORESOURCE_IO, 0);
> +
> +       if (!res) {
>                 ret = -ENXIO;
>                 goto out;
>         }
> 
> -       ret = platform_driver_register(&applesmc_driver);
> -       if (ret)
> -               goto out_region;
> +       applesmc_pnp_device->iobase = res->start;
> +       applesmc_pnp_device->iolen = res->end - res->start + 1;
> 
> -       pdev = platform_device_register_simple("applesmc", APPLESMC_DATA_PORT,
> -                                              NULL, 0);
> -       if (IS_ERR(pdev)) {
> -               ret = PTR_ERR(pdev);
> -               goto out_driver;
> +       if (!request_region(pnp_device->iobase, pnp_device->iolen, "applesmc")) {

This line has more than 80 columns.

> +               ret = -ENXIO;
> +               goto out;
>         }
> 
>         /* create register cache */
>         ret = applesmc_init_smcreg();
>         if (ret)
> -               goto out_device;
> +               goto out_region;
> +
> +       applesmc_device_init();
> 
>         ret = applesmc_create_nodes(info_group, 1);
>         if (ret)
> @@ -1287,19 +1262,17 @@ out_info:
>         applesmc_destroy_nodes(info_group);
>  out_smcreg:
>         applesmc_destroy_smcreg();
> -out_device:
> -       platform_device_unregister(pdev);
> -out_driver:
> -       platform_driver_unregister(&applesmc_driver);
>  out_region:
> -       release_region(APPLESMC_DATA_PORT, APPLESMC_NR_PORTS);
> +       release_region(pnp_device->iobase, pnp_device->iolen);

No kfree() of applesmc_pnp_device, so you are leaking memory here.

>  out:
>         pr_warn("driver init failed (ret=%d)!\n", ret);
>         return ret;
>  }
> 
> -static void __exit applesmc_exit(void)
> +static void __devexit applesmc_pnp_remove(struct pnp_dev *dev)
>  {
> +       struct applesmc_pnp_device *applesmc_pnp_device = pnp_get_drvdata(dev);
> +

Why bother with this, as it is assigned to pnp_device ?

>         hwmon_device_unregister(hwmon_dev);
>         applesmc_release_key_backlight();
>         applesmc_release_light_sensor();
> @@ -1308,9 +1281,33 @@ static void __exit applesmc_exit(void)
>         applesmc_destroy_nodes(fan_group);
>         applesmc_destroy_nodes(info_group);
>         applesmc_destroy_smcreg();
> -       platform_device_unregister(pdev);
> -       platform_driver_unregister(&applesmc_driver);
> -       release_region(APPLESMC_DATA_PORT, APPLESMC_NR_PORTS);
> +       release_region(pnp_device->iobase, pnp_device->iolen);
> +       kfree(applesmc_pnp_device);
> +}
> +
> +static const struct pnp_device_id applesmc_dev_table[] = {
> +       {"APP0001", 0},
> +       {"", 0},
> +};
> +
> +static struct pnp_driver applesmc_pnp_driver = {
> +       .name           = "Apple SMC",
> +       .probe          = applesmc_pnp_probe,
> +       .remove         = applesmc_pnp_remove,
> +       .id_table       = applesmc_dev_table,
> +       .driver = {
> +               .pm     = &applesmc_pm_ops,
> +       },
> +};
> +
> +static int __init applesmc_init(void)
> +{
> +       return pnp_register_driver(&applesmc_pnp_driver);
> +}
> +
> +static void __exit applesmc_exit(void)
> +{
> +       pnp_unregister_driver(&applesmc_pnp_driver);
>  }
> 
>  module_init(applesmc_init);
> @@ -1319,4 +1316,4 @@ module_exit(applesmc_exit);
>  MODULE_AUTHOR("Nicolas Boichat");
>  MODULE_DESCRIPTION("Apple SMC");
>  MODULE_LICENSE("GPL v2");
> -MODULE_DEVICE_TABLE(dmi, applesmc_whitelist);
> +MODULE_DEVICE_TABLE(pnp, applesmc_dev_table);
> --
> 1.7.3.3
> 
> 
> _______________________________________________
> lm-sensors mailing list
> lm-sensors@lm-sensors.org
> http://lists.lm-sensors.org/mailman/listinfo/lm-sensors
