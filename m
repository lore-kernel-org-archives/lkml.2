Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932607Ab1BWUey (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 15:34:54 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36119 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932214Ab1BWUew convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 15:34:52 -0500
MIME-Version: 1.0
In-Reply-To: <20110219150644.681D59D401D@zog.reactivated.net>
References: <20110219150644.681D59D401D@zog.reactivated.net>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 23 Feb 2011 13:34:30 -0700
X-Google-Sender-Auth: lbR1pNIC4IILdivYqej4u-ZhtcI
Message-ID: <AANLkTi=29myerzgH6WRCSOPKpaDnGgEtQacVHvxRoQT_@mail.gmail.com>
Subject: Re: [PATCH] olpc_battery: bind to device tree
To: Daniel Drake <dsd@laptop.org>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>
Cc: cbou@mail.ru, dwmw2@infradead.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        dilinger@queued.net, dmitry.torokhov@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[cc'ing devicetree-discuss@lists.ozlabs.org.  Please cc this list for
any dt-related patches]

On Sat, Feb 19, 2011 at 8:06 AM, Daniel Drake <dsd@laptop.org> wrote:
> Move from being statically probed by platform presence to binding to
> the battery node of the device tree.
>
> This is cleaner and allows suspend/resume (wakeup) support to be added
> in a later patch.
>
> Signed-off-by: Daniel Drake <dsd@laptop.org>

Hi Daniel, comments below.

> ---
>  arch/x86/platform/olpc/olpc_dt.c |   13 +++++++
>  drivers/power/Kconfig            |    2 +-
>  drivers/power/olpc_battery.c     |   66 +++++++++++++++++++++++++------------
>  3 files changed, 58 insertions(+), 23 deletions(-)
>
> Replaces patch "olpc_battery: convert to platform device"
>
> The problem mentioned in another mail regarding devicetree binding is now
> fixed via separate patches from Andres.
>
> diff --git a/arch/x86/platform/olpc/olpc_dt.c b/arch/x86/platform/olpc/olpc_dt.c
> index dab8746..97211c1 100644
> --- a/arch/x86/platform/olpc/olpc_dt.c
> +++ b/arch/x86/platform/olpc/olpc_dt.c
> @@ -19,6 +19,7 @@
>  #include <linux/kernel.h>
>  #include <linux/bootmem.h>
>  #include <linux/of.h>
> +#include <linux/of_platform.h>
>  #include <linux/of_pdt.h>
>  #include <asm/olpc_ofw.h>
>
> @@ -181,3 +182,15 @@ void __init olpc_dt_build_devicetree(void)
>        pr_info("PROM DT: Built device tree with %u bytes of memory.\n",
>                        prom_early_allocated);
>  }
> +
> +/* A list of DT node/bus matches that we want to expose as platform devices */
> +static struct of_device_id __initdata of_ids[] = {
> +       { .name = "battery" },
> +       {},

As mentioned in the other thread, matching by name is strongly
discouraged.  It isn't very accurate and compatible is the preferred
method for binding devices.  'battery' in particular is highly
non-specific.

I do understand that you don't have a compatible property in the
current firmware, and to a certain extent we have to live with what
we're given by the kernel.  However, I think it would be better in the
OLPC case to find the battery node and add a compatible property
before registering a platform_device for it.  (or use a bus notifier
to tell you when it is registered, and add 'compatible' at that
point.)  That way we the uncertainty is taken care of in the board
support code without polluting the driver matching namespace.

> +};
> +
> +static int __init declare_of_platform_devices(void)
> +{
> +       return of_platform_bus_probe(NULL, of_ids, NULL);
> +}
> +device_initcall(declare_of_platform_devices);
> diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
> index 61bf5d7..3a9151d 100644
> --- a/drivers/power/Kconfig
> +++ b/drivers/power/Kconfig
> @@ -84,7 +84,7 @@ config BATTERY_PMU
>
>  config BATTERY_OLPC
>        tristate "One Laptop Per Child battery"
> -       depends on X86_32 && OLPC
> +       depends on X86_32 && OLPC && OF
>        help
>          Say Y to enable support for the battery on the OLPC laptop.
>
> diff --git a/drivers/power/olpc_battery.c b/drivers/power/olpc_battery.c
> index 0b0ff3a..99fc8e0 100644
> --- a/drivers/power/olpc_battery.c
> +++ b/drivers/power/olpc_battery.c
> @@ -17,6 +17,7 @@
>  #include <linux/power_supply.h>
>  #include <linux/jiffies.h>
>  #include <linux/sched.h>
> +#include <linux/of_platform.h>
>  #include <asm/olpc.h>
>
>
> @@ -519,9 +520,8 @@ static struct device_attribute olpc_bat_error = {
>  *             Initialisation
>  *********************************************************************/
>
> -static struct platform_device *bat_pdev;
> -
>  static struct power_supply olpc_bat = {
> +       .name = "olpc-battery",
>        .get_property = olpc_bat_get_property,
>        .use_for_apm = 1,
>  };
> @@ -534,13 +534,18 @@ void olpc_battery_trigger_uevent(unsigned long cause)
>                kobject_uevent(&olpc_bat.dev->kobj, KOBJ_CHANGE);
>  }
>
> -static int __init olpc_bat_init(void)
> +static int __devinit olpc_battery_probe(struct platform_device *pdev,
> +                                       const struct of_device_id *match)

static int __devinit olpc_battery_probe(struct platform_device *pdev)

match is no longer needed (see below)

>  {
> -       int ret = 0;
> +       int ret;
>        uint8_t status;
> +       struct device_node *root;
> +       const char *arch;
> +       int propsize;
>
> -       if (!olpc_platform_info.ecver)
> -               return -ENXIO;
> +       /* Check that we're running on an XO laptop */
> +       if (!machine_is_olpc())
> +               return -ENODEV;
>
>        /*
>         * We've seen a number of EC protocol changes; this driver requires
> @@ -552,21 +557,15 @@ static int __init olpc_bat_init(void)
>                return -ENXIO;
>        }
>
> +       /* Ignore the status. It doesn't actually matter */
>        ret = olpc_ec_cmd(EC_BAT_STATUS, NULL, 0, &status, 1);
>        if (ret)
>                return ret;
>
> -       /* Ignore the status. It doesn't actually matter */
> -
> -       bat_pdev = platform_device_register_simple("olpc-battery", 0, NULL, 0);
> -       if (IS_ERR(bat_pdev))
> -               return PTR_ERR(bat_pdev);
> -
> -       ret = power_supply_register(&bat_pdev->dev, &olpc_ac);
> +       ret = power_supply_register(&pdev->dev, &olpc_ac);
>        if (ret)
> -               goto ac_failed;
> +               return ret;
>
> -       olpc_bat.name = bat_pdev->name;
>        if (olpc_board_at_least(olpc_board_pre(0xd0))) { /* XO-1.5 */
>                olpc_bat.properties = olpc_xo15_bat_props;
>                olpc_bat.num_properties = ARRAY_SIZE(olpc_xo15_bat_props);
> @@ -575,7 +574,7 @@ static int __init olpc_bat_init(void)
>                olpc_bat.num_properties = ARRAY_SIZE(olpc_xo1_bat_props);
>        }
>
> -       ret = power_supply_register(&bat_pdev->dev, &olpc_bat);
> +       ret = power_supply_register(&pdev->dev, &olpc_bat);
>        if (ret)
>                goto battery_failed;
>
> @@ -587,7 +586,7 @@ static int __init olpc_bat_init(void)
>        if (ret)
>                goto error_failed;
>
> -       goto success;
> +       return 0;
>
>  error_failed:
>        device_remove_bin_file(olpc_bat.dev, &olpc_bat_eeprom);
> @@ -595,19 +594,42 @@ eeprom_failed:
>        power_supply_unregister(&olpc_bat);
>  battery_failed:
>        power_supply_unregister(&olpc_ac);
> -ac_failed:
> -       platform_device_unregister(bat_pdev);
> -success:
>        return ret;
>  }
>
> -static void __exit olpc_bat_exit(void)
> +static int __devexit olpc_battery_remove(struct platform_device *pdev)
>  {
>        device_remove_file(olpc_bat.dev, &olpc_bat_error);
>        device_remove_bin_file(olpc_bat.dev, &olpc_bat_eeprom);
>        power_supply_unregister(&olpc_bat);
>        power_supply_unregister(&olpc_ac);
> -       platform_device_unregister(bat_pdev);
> +       return 0;
> +}
> +
> +static const struct of_device_id olpc_battery_ids[] __devinitconst = {
> +       { .name = "battery" },
> +       {}
> +};
> +MODULE_DEVICE_TABLE(of, olpc_battery_ids);
> +
> +static struct of_platform_driver olpc_battery_drv = {

This should be:

static struct platform_driver olpc_battery_drv = {

of_platform_driver is deprecated and in the process of being removed.
platform_driver is pretty much a drop in replacement as long as the
.of_match_table is populated.

> +       .driver = {
> +               .name = "olpc-battery",
> +               .owner = THIS_MODULE,
> +               .of_match_table = olpc_battery_ids,
> +       },
> +       .probe = olpc_battery_probe,
> +       .remove = __devexit_p(olpc_battery_remove),
> +};
> +
> +static int __init olpc_bat_init(void)
> +{
> +       return of_register_platform_driver(&olpc_battery_drv);

return platform_driver_register(&olpc_battery_drv)

> +}
> +
> +static void __exit olpc_bat_exit(void)
> +{
> +       of_unregister_platform_driver(&olpc_battery_drv);

platform_driver_unregister()

>  }
>
>  module_init(olpc_bat_init);
> --
> 1.7.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
