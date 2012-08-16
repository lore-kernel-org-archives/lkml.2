Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563Ab2HPGgT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 02:36:19 -0400
Received: from mga14.intel.com ([143.182.124.37]:62766 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751325Ab2HPGgR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 02:36:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,778,1336374000"; 
   d="scan'208";a="134861027"
Message-ID: <1345099040.1682.868.camel@rui.sh.intel.com>
Subject: Re: [PATCH 2/2] Thermal: Add ST-Ericsson db8500 thermal dirver.
From: Zhang Rui <rui.zhang@intel.com>
To: Hongbo Zhang <hongbo.zhang@linaro.org>
Cc: linaro-dev@lists.linaro.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, STEricsson_nomadik_linux@list.st.com,
        kernel@igloocommunity.org,
        "hongbo.zhang" <hongbo.zhang@stericsson.com>,
        "hongbo.zhang" <hongbo.zhang@linaro.com>, linux-kernel@vger.kernel.org,
        len.brown@intel.com, durgadoss.r@intel.com,
        Amit Kachhap <amit.kachhap@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>
Date: Thu, 16 Aug 2012 14:37:20 +0800
In-Reply-To: <CAJLyvQx9JJqyDQhRNgQq9RD_gNM__qDrBi6Mbghp=LnLq8NuGA@mail.gmail.com>
References: <1344597614-13998-1-git-send-email-hongbo.zhang@linaro.com>
	 <1344597614-13998-3-git-send-email-hongbo.zhang@linaro.com>
	 <CAJLyvQx9JJqyDQhRNgQq9RD_gNM__qDrBi6Mbghp=LnLq8NuGA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 四, 2012-08-16 at 14:23 +0800, Hongbo Zhang wrote:
> Add more people into list.
> 
> 
> On 10 August 2012 19:20, hongbo.zhang <hongbo.zhang@linaro.org> wrote:
>         From: "hongbo.zhang" <hongbo.zhang@stericsson.com>
>         
>         This diver is based on the thermal management framework in
>         thermal_sys.c.
>         A thermal zone device is created with the trip points to which
>         cooling
>         devices can be binded, the current cooling device is cpufreq,
>         e.g. CPU
>         frequency is clipped down to cool the CPU, and other cooling
>         devices can
>         be added and binded to the trip points dynamically.
>         The platform specific PRCMU interrupts are used to active
>         thermal update
>         when trip points are reached.
>         
>         Signed-off-by: hongbo.zhang <hongbo.zhang@linaro.com>
>         ---
>          arch/arm/boot/dts/db8500.dtsi                |   11 +
>          arch/arm/configs/u8500_defconfig             |    4 +
>          arch/arm/mach-ux500/board-mop500.c           |   73 ++++
>          drivers/thermal/Kconfig                      |   20 +
>          drivers/thermal/Makefile                     |    4 +-
>          drivers/thermal/db8500_cpufreq_cooling.c     |  175 +++++++++
>          drivers/thermal/db8500_thermal.c             |  511
>         ++++++++++++++++++++++++++
>          include/linux/platform_data/db8500_thermal.h |   39 ++
>          8 files changed, 836 insertions(+), 1 deletion(-)
>          create mode 100644 drivers/thermal/db8500_cpufreq_cooling.c
>          create mode 100644 drivers/thermal/db8500_thermal.c
>          create mode 100644
>         include/linux/platform_data/db8500_thermal.h
>         
>         diff --git a/arch/arm/boot/dts/db8500.dtsi
>         b/arch/arm/boot/dts/db8500.dtsi
>         index daedefe..a667399 100644
>         --- a/arch/arm/boot/dts/db8500.dtsi
>         +++ b/arch/arm/boot/dts/db8500.dtsi
>         @@ -174,6 +174,10 @@
>                                 compatible = "stericsson,nmk_pinctrl";
>                         };
>         
>         +               cpufreq-cooling {
>         +                        compatible =
>         "stericsson,db8500-cpufreq-cooling";
>         +                };
>         +
>                         usb@a03e0000 {
>                                 compatible = "stericsson,db8500-musb",
>                                         "mentor,musb";
>         @@ -203,6 +207,13 @@
>                                         reg = <0x80157450 0xC>;
>                                 };
>         
>         +                       thermal@801573c0 {
>         +                                compatible =
>         "stericsson,db8500-thermal";
>         +                                reg = <0x801573c0 0x40>;
>         +                                interrupts = <21 0x4>, <22
>         0x4>;
>         +                                interrupt-names =
>         "IRQ_HOTMON_LOW", "IRQ_HOTMON_HIGH";
>         +                        };
>         +
>                                 db8500-prcmu-regulators {
>                                         compatible =
>         "stericsson,db8500-prcmu-regulator";
>         
>         diff --git a/arch/arm/configs/u8500_defconfig
>         b/arch/arm/configs/u8500_defconfig
>         index 036419f..15a455e 100644
>         --- a/arch/arm/configs/u8500_defconfig
>         +++ b/arch/arm/configs/u8500_defconfig
>         @@ -117,3 +117,7 @@ CONFIG_DEBUG_KERNEL=y
>          CONFIG_DEBUG_INFO=y
>          # CONFIG_FTRACE is not set
>          CONFIG_DEBUG_USER=y
>         +CONFIG_THERMAL=y
>         +CONFIG_CPU_THERMAL=y
>         +CONFIG_DB8500_THERMAL=y
>         +CONFIG_DB8500_CPUFREQ_COOLING=y
>         diff --git a/arch/arm/mach-ux500/board-mop500.c
>         b/arch/arm/mach-ux500/board-mop500.c
>         index 8674a89..5f59566 100644
>         --- a/arch/arm/mach-ux500/board-mop500.c
>         +++ b/arch/arm/mach-ux500/board-mop500.c
>         @@ -32,6 +32,8 @@
>          #include <linux/smsc911x.h>
>          #include <linux/gpio_keys.h>
>          #include <linux/delay.h>
>         +#include <linux/platform_data/db8500_thermal.h>
>         +
>          #include <linux/of.h>
>          #include <linux/of_platform.h>
>          #include <linux/leds.h>
>         @@ -212,6 +214,71 @@ static struct ab8500_platform_data
>         ab8500_platdata = {
>          };
>         
>          /*
>         + * Thermal Sensor
>         + */
>         +
>         +static struct resource db8500_thsens_resources[] = {
>         +       {
>         +               .name = "IRQ_HOTMON_LOW",
>         +               .start  = IRQ_PRCMU_HOTMON_LOW,
>         +               .end    = IRQ_PRCMU_HOTMON_LOW,
>         +               .flags  = IORESOURCE_IRQ,
>         +       },
>         +       {
>         +               .name = "IRQ_HOTMON_HIGH",
>         +               .start  = IRQ_PRCMU_HOTMON_HIGH,
>         +               .end    = IRQ_PRCMU_HOTMON_HIGH,
>         +               .flags  = IORESOURCE_IRQ,
>         +       },
>         +};
>         +
>         +static struct db8500_trip_point db8500_trips_table[] = {
>         +       [0] = {
>         +               .temp = 70000,
>         +               .type = THERMAL_TRIP_ACTIVE,
>         +               .cooling_dev_name = {
>         +                       [0] = "thermal-cpufreq-0",
>         +               },
>         +       },
>         +       [1] = {
>         +               .temp = 75000,
>         +               .type = THERMAL_TRIP_ACTIVE,
>         +               .cooling_dev_name = {
>         +                       [0] = "thermal-cpufreq-1",
>         +               },
>         +       },
>         +       [2] = {
>         +               .temp = 80000,
>         +               .type = THERMAL_TRIP_ACTIVE,
>         +               .cooling_dev_name = {
>         +                       [0] = "thermal-cpufreq-2",
>         +               },
>         +       },
>         +       [3] = {
>         +               .temp = 85000,
>         +               .type = THERMAL_TRIP_CRITICAL,
>         +       },
>         +};
>         +
>         +static struct db8500_thsens_platform_data db8500_thsens_data
>         = {
>         +       .trip_points    = db8500_trips_table,
>         +       .num_trips      = ARRAY_SIZE(db8500_trips_table),
>         +};
>         +
>         +static struct platform_device u8500_thsens_device = {
>         +       .name           = "db8500-thermal",
>         +       .resource       = db8500_thsens_resources,
>         +       .num_resources  = ARRAY_SIZE(db8500_thsens_resources),
>         +       .dev    = {
>         +               .platform_data  = &db8500_thsens_data,
>         +       },
>         +};
>         +
>         +static struct platform_device u8500_cpufreq_cooling_device =
>         {
>         +       .name           = "db8500-cpufreq-cooling",
>         +};
>         +
>         +/*
>           * TPS61052
>           */
>         
>         @@ -586,6 +653,8 @@ static struct platform_device
>         *snowball_platform_devs[] __initdata = {
>                 &snowball_led_dev,
>                 &snowball_key_dev,
>                 &snowball_sbnet_dev,
>         +       &u8500_thsens_device,
>         +       &u8500_cpufreq_cooling_device,
>          };
>         
>          static void __init mop500_init_machine(void)
>         @@ -757,6 +826,10 @@ struct of_dev_auxdata
>         u8500_auxdata_lookup[] __initdata = {
>                 OF_DEV_AUXDATA("st,nomadik-i2c", 0x8012a000,
>         "nmk-i2c.4", NULL),
>                 /* Requires device name bindings. */
>                 OF_DEV_AUXDATA("stericsson,nmk_pinctrl", 0,
>         "pinctrl-db8500", NULL),
>         +       OF_DEV_AUXDATA("stericsson,db8500-thermal",
>         0x801573c0,
>         +                       "db8500-thermal",
>         &db8500_thsens_data),
>         +       OF_DEV_AUXDATA("stericsson,db8500-cpufreq-cooling", 0,
>         +                       "db8500-cpufreq-cooling", NULL),
>                 {},
>          };
>         
>         diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
>         index ace6078..37bd484 100644
>         --- a/drivers/thermal/Kconfig
>         +++ b/drivers/thermal/Kconfig
>         @@ -30,6 +30,26 @@ config CPU_THERMAL
>                   and not the ACPI interface.
>                   If you want this support, you should say Y or M
>         here.
>         
>         +config DB8500_THERMAL
>         +       bool "db8500 thermal management"
>         +       depends on THERMAL
>         +       default y
>         +       help
>         +         Adds DB8500 thermal management implementation
>         according to the thermal
>         +         management framework. A thermal zone with several
>         trip points will be
>         +         created. Cooling devices can be binded to the trip
>         points to cool this
>         +         thermal zone if trip points reached.
>         +
>         +config DB8500_CPUFREQ_COOLING
>         +       tristate "db8500 cpufreq cooling"
>         +       depends on CPU_THERMAL
>         +       default y
>         +       help
>         +         Adds DB8500 cpufreq cooling devices, and these
>         cooling devices can be
>         +         binded to thermal zone trip points. When a trip
>         point reached, the
>         +         binded cpufreq cooling device turns active to set
>         CPU frequency low to
>         +         cool down the CPU.
>         +
>          config SPEAR_THERMAL
>                 bool "SPEAr thermal sensor driver"
>                 depends on THERMAL
>         diff --git a/drivers/thermal/Makefile
>         b/drivers/thermal/Makefile
>         index 30c456c..d146456 100644
>         --- a/drivers/thermal/Makefile
>         +++ b/drivers/thermal/Makefile
>         @@ -3,5 +3,7 @@
>          #
>         
>          obj-$(CONFIG_THERMAL)          += thermal_sys.o
>         -obj-$(CONFIG_CPU_THERMAL)       += cpu_cooling.o
>         +obj-$(CONFIG_CPU_THERMAL)      += cpu_cooling.o
>         +obj-$(CONFIG_DB8500_THERMAL)   += db8500_thermal.o
>         +obj-$(CONFIG_DB8500_CPUFREQ_COOLING)
>         +=db8500_cpufreq_cooling.o
>          obj-$(CONFIG_SPEAR_THERMAL)            += spear_thermal.o
>         diff --git a/drivers/thermal/db8500_cpufreq_cooling.c
>         b/drivers/thermal/db8500_cpufreq_cooling.c
>         new file mode 100644
>         index 0000000..973d1ad
>         --- /dev/null
>         +++ b/drivers/thermal/db8500_cpufreq_cooling.c
>         @@ -0,0 +1,175 @@
>         +/*
>         + * db8500_cpufreq_cooling.c - db8500 cpufreq works as cooling
>         device.
>         + *
>         + * Copyright (C) 2012 ST-Ericsson
>         + * Copyright (C) 2012 Linaro Ltd.
>         + *
>         + * Author: Hongbo Zhang <hognbo.zhang@stericsson.com>
>         + *
>         + * This program is free software; you can redistribute it
>         and/or modify
>         + * it under the terms of the GNU General Public License as
>         published by
>         + * the Free Software Foundation; either version 2 of the
>         License, or
>         + * (at your option) any later version.
>         + *
>         + * This program is distributed in the hope that it will be
>         useful,
>         + * but WITHOUT ANY WARRANTY; without even the implied
>         warranty of
>         + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
>         the
>         + * GNU General Public License for more details.
>         + *
>         + */
>         +
>         +#include <linux/slab.h>
>         +#include <linux/module.h>
>         +#include <linux/platform_device.h>
>         +#include <linux/cpufreq.h>
>         +#include <linux/cpu_cooling.h>
>         +#include <linux/err.h>
>         +
>         +static LIST_HEAD(db8500_cpufreq_cdev_list);
>         +
>         +struct db8500_cpufreq_cdev {
>         +       struct thermal_cooling_device *cdev;
>         +       struct list_head node;
>         +};
>         +
>         +/* Local function to create cpufreq clip table */
>         +static int cpufreq_table_create(struct platform_device *pdev,
>         +               struct freq_clip_table **freq_tab, int
>         *num_freq)
>         +{
>         +       struct cpufreq_frequency_table *table;
>         +       struct freq_clip_table *clip;
>         +       unsigned int temp;
>         +       int i, j, count = 0;
>         +
>         +       table = cpufreq_frequency_get_table(0);
>         +       if (!table)
>         +               return -ENODATA;
>         +
>         +       /* Check number of frequencies */
>         +       for (i = 0; (table[i].frequency != CPUFREQ_TABLE_END);
>         i++) {
>         +               if (table[i].frequency ==
>         CPUFREQ_ENTRY_INVALID)
>         +                       continue;
>         +               count++;
>         +       }
>         +
>         +       clip = devm_kzalloc(&pdev->dev,
>         +                       sizeof(struct freq_clip_table) *
>         count, GFP_KERNEL);
>         +
>         +       /* Save frequencies */
>         +       count = 0;
>         +       for (i = 0; (table[i].frequency != CPUFREQ_TABLE_END);
>         i++) {
>         +               if (table[i].frequency ==
>         CPUFREQ_ENTRY_INVALID)
>         +                       continue;
>         +               clip[count].freq_clip_max =
>         table[i].frequency;
>         +               count++;
>         +       }
>         +
>         +       /* Descending order frequencies */
>         +       for (i = 0; i <= count - 2; i++)
>         +               for (j = i + 1; j <= count - 1; j++)
>         +                       if (clip[i].freq_clip_max <
>         clip[j].freq_clip_max) {
>         +                               temp = clip[i].freq_clip_max;
>         +                               clip[i].freq_clip_max =
>         clip[j].freq_clip_max;
>         +                               clip[j].freq_clip_max = temp;
>         +                       }
>         +
>         +       for (i = 0; i < count; i++) {
>         +               clip[i].mask_val = cpu_present_mask;
>         +               pr_info("db8500_clip_tab.%d: %d\n", i,
>         clip[i].freq_clip_max);
>         +       }
>         +
>         +       *freq_tab = clip;
>         +       *num_freq = count;
>         +
>         +       return 0;
>         +}
>         +
>         +static int __devinit db8500_cpufreq_cooling_probe(struct
>         platform_device *pdev)
>         +{
>         +       struct freq_clip_table *freq_tab = NULL;
>         +       struct db8500_cpufreq_cdev *cooling_devs;
>         +       int i, ret, num_freq = 0;
>         +
>         +       if (cpufreq_table_create(pdev, &freq_tab, &num_freq))
>         +               return -ENODATA;
>         +
>         +       if (unlikely(!freq_tab || !num_freq))
>         +               return -ENODATA;
>         +
>         +       /* Create one cooling device for each clip frequency
>         */
>         +       for (i = 0; i < num_freq; i++) {
>         +               cooling_devs = devm_kzalloc(&pdev->dev,
>         +                               sizeof(struct
>         db8500_cpufreq_cdev), GFP_KERNEL);
>         +               if (!cooling_devs) {
>         +                       ret = -ENOMEM;
>         +                       goto exit;
>         +               }
>         +
>         +               cooling_devs->cdev =
>         cpufreq_cooling_register(&freq_tab[i], 1);
>         +
>         +               if (IS_ERR(cooling_devs->cdev)) {
>         +                       pr_err("Failed to register cpufreq
>         cooling device\n");
>         +                       ret = PTR_ERR(cooling_devs->cdev);
>         +                       goto exit;
>         +               }
>         +
>         +               list_add_tail(&cooling_devs->node,
>         &db8500_cpufreq_cdev_list);
>         +               pr_info("Cooling device regestered: %s\n",
>         +                       cooling_devs->cdev->type);
>         +       }
>         +
>         +       return 0;
>         +
>         +exit:
>         +       list_for_each_entry(cooling_devs,
>         &db8500_cpufreq_cdev_list, node)
>         +
>         cpufreq_cooling_unregister(cooling_devs->cdev);
>         +
>         +       return ret;
>         +}
>         +
>         +static int __devexit db8500_cpufreq_cooling_remove(struct
>         platform_device *pdev)
>         +{
>         +       struct db8500_cpufreq_cdev *cooling_devs;
>         +
>         +       list_for_each_entry(cooling_devs,
>         &db8500_cpufreq_cdev_list, node)
>         +
>         cpufreq_cooling_unregister(cooling_devs->cdev);
>         +
>         +       return 0;
>         +}
>         +
>         +#ifdef CONFIG_OF
>         +static const struct of_device_id
>         db8500_cpufreq_cooling_match[] = {
>         +       { .compatible = "stericsson,db8500-cpufreq-cooling" },
>         +       {},
>         +};
>         +#else
>         +#define db8500_cpufreq_cooling_match NULL
>         +#endif
>         +
>         +static struct platform_driver db8500_cpufreq_cooling_driver =
>         {
>         +       .driver = {
>         +               .owner = THIS_MODULE,
>         +               .name = "db8500-cpufreq-cooling",
>         +               .of_match_table =
>         db8500_cpufreq_cooling_match,
>         +       },
>         +       .probe = db8500_cpufreq_cooling_probe,
>         +       .remove = __devexit_p(db8500_cpufreq_cooling_remove),
>         +};
>         +
>         +static int __init db8500_cpufreq_cooling_init(void)
>         +{
>         +       return
>         platform_driver_register(&db8500_cpufreq_cooling_driver);
>         +}
>         +
>         +static void __exit db8500_cpufreq_cooling_exit(void)
>         +{
>         +
>         platform_driver_unregister(&db8500_cpufreq_cooling_driver);
>         +}
>         +
>         +/* Should be later than db8500_cpufreq_register */
>         +late_initcall(db8500_cpufreq_cooling_init);
>         +module_exit(db8500_cpufreq_cooling_exit);
>         +
>         +MODULE_AUTHOR("Hongbo Zhang <hongbo.zhang@stericsson.com>");
>         +MODULE_DESCRIPTION("db8500 cpufreq cooling driver");
>         +MODULE_LICENSE("GPL");
>         diff --git a/drivers/thermal/db8500_thermal.c
>         b/drivers/thermal/db8500_thermal.c
>         new file mode 100644
>         index 0000000..920df6a
>         --- /dev/null
>         +++ b/drivers/thermal/db8500_thermal.c
>         @@ -0,0 +1,511 @@
>         +/*
>         + * db8500_thermal.c - db8500 Thermal Management
>         Implementation
>         + *
>         + * Copyright (C) 2012 ST-Ericsson
>         + * Copyright (C) 2012 Linaro Ltd.
>         + *
>         + * Author: Hongbo Zhang <hognbo.zhang@stericsson.com>
>         + *
>         + * This program is free software; you can redistribute it
>         and/or modify
>         + * it under the terms of the GNU General Public License as
>         published by
>         + * the Free Software Foundation; either version 2 of the
>         License, or
>         + * (at your option) any later version.
>         + *
>         + * This program is distributed in the hope that it will be
>         useful,
>         + * but WITHOUT ANY WARRANTY; without even the implied
>         warranty of
>         + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
>         the
>         + * GNU General Public License for more details.
>         + *
>         + */
>         +
>         +#include <linux/module.h>
>         +#include <linux/slab.h>
>         +#include <linux/interrupt.h>
>         +#include <linux/platform_device.h>
>         +#include <linux/thermal.h>
>         +#include <linux/cpu_cooling.h>
>         +#include <linux/mfd/dbx500-prcmu.h>
>         +#include <linux/platform_data/db8500_thermal.h>
>         +
>         +#define PRCMU_DEFAULT_MEASURE_TIME 0xFFF
>         +#define PRCMU_DEFAULT_LOW_TEMP 0
>         +
>         +struct db8500_thermal_zone {
>         +       struct thermal_zone_device *therm_dev;
>         +       struct mutex th_lock;
>         +       struct platform_device *thsens_pdev;
>         +       struct work_struct therm_work;
>         +       struct db8500_thsens_platform_data *trip_tab;
>         +       enum thermal_device_mode mode;
>         +       unsigned long cur_temp_pseudo;
>         +       unsigned int cur_index;
>         +       int low_irq;
>         +       int high_irq;
>         +};
>         +
>         +/* Bind callback functions for thermal zone */
>         +static int db8500_cdev_bind(struct thermal_zone_device
>         *thermal,
>         +                       struct thermal_cooling_device *cdev)
>         +{
>         +       struct db8500_thermal_zone *pzone;
>         +       struct db8500_thsens_platform_data *ptrips;
>         +       char *cdev_name;
>         +       int i, j, ret;
>         +
>         +       pzone = (struct db8500_thermal_zone
>         *)thermal->devdata;
>         +       ptrips = pzone->trip_tab;
>         +
>         +       if (!cdev->type)
>         +               return -EINVAL;
>         +
>         +       ret = -ENODEV;
>         +       for (i = 0; i < ptrips->num_trips; i++)
>         +               for (j = 0; j < COOLING_DEV_MAX; j++) {
>         +                       cdev_name =
>         ptrips->trip_points[i].cooling_dev_name[j];
>         +                       if (!cdev_name)
>         +                               continue;
>         +
>         +                       if (strcmp(cdev_name, cdev->type))
>         +                               continue;
>         +
>         +                       ret =
>         thermal_zone_bind_cooling_device(
>         +                               thermal, i, cdev);
>         +                       if (ret)
>         +                               pr_err("Error binding cooling
>         device.\n");
>         +                       else
>         +                               pr_info("Cdev %s binded.\n",
>         cdev->type);
>         +               }
>         +
>         +       /* Force an update since polling mode is not used */
>         +       schedule_work(&pzone->therm_work);
>         +
>         +       return ret;
>         +}
>         +
>         +/* Unbind callback functions for thermal zone */
>         +static int db8500_cdev_unbind(struct thermal_zone_device
>         *thermal,
>         +                         struct thermal_cooling_device *cdev)
>         +{
>         +       struct db8500_thermal_zone *pzone;
>         +       struct db8500_thsens_platform_data *ptrips;
>         +       char *cdev_name;
>         +       int i, j, ret;
>         +
>         +       pzone = (struct db8500_thermal_zone
>         *)thermal->devdata;
>         +       ptrips = pzone->trip_tab;
>         +
>         +       if (!cdev->type)
>         +               return -EINVAL;
>         +
>         +       ret = -ENODEV;
>         +       for (i = 0; i < ptrips->num_trips; i++)
>         +               for (j = 0; j < COOLING_DEV_MAX; j++) {
>         +                       cdev_name =
>         ptrips->trip_points[i].cooling_dev_name[j];
>         +                       if (!cdev_name)
>         +                               continue;
>         +
>         +                       if (strcmp(cdev_name, cdev->type))
>         +                               continue;
>         +
>         +                       /* Invalidate the cooling device
>         before unbinding it */
>         +                       if (cdev->ops->set_cur_state)
>         +                               cdev->ops->set_cur_state(cdev,
>         0);
>         +
>         +                       ret =
>         thermal_zone_unbind_cooling_device(
>         +                               thermal, i, cdev);
>         +                       if (ret)
>         +                               pr_err("Error unbinding
>         cooling device.\n");
>         +                       else
>         +                               pr_info("Cdev %s unbinded.\n",
>         cdev->type);
>         +               }
>         +
>         +       return ret;
>         +}
>         +
>         +/* Get temperature callback functions for thermal zone */
>         +static int db8500_sys_get_temp(struct thermal_zone_device
>         *thermal,
>         +                                 unsigned long *temp)
>         +{
>         +       struct db8500_thermal_zone *pzone;
>         +
>         +       pzone = (struct db8500_thermal_zone
>         *)thermal->devdata;
>         +
>         +       /* TODO: There is no PRCMU interface to get
>         temperature data currently,
>         +       so a pseudo temperature is returned , it works for the
>         thermal framework
>         +       and this will be fixed when the PRCMU interface is
>         available */
>         +       *temp = pzone->cur_temp_pseudo;
>         +
>         +       return 0;
>         +}
>         +
>         +/* Get mode callback functions for thermal zone */
>         +static int db8500_sys_get_mode(struct thermal_zone_device
>         *thermal,
>         +                           enum thermal_device_mode *mode)
>         +{
>         +       struct db8500_thermal_zone *pzone;
>         +       pzone = (struct db8500_thermal_zone
>         *)thermal->devdata;
>         +
>         +       mutex_lock(&pzone->th_lock);
>         +       *mode = pzone->mode;
>         +       mutex_unlock(&pzone->th_lock);
>         +
>         +       return 0;
>         +}
>         +
>         +/* Set mode callback functions for thermal zone */
>         +static int db8500_sys_set_mode(struct thermal_zone_device
>         *thermal,
>         +                       enum thermal_device_mode mode)
>         +{
>         +       struct db8500_thermal_zone *pzone;
>         +       struct thermal_zone_device      *pthdev;
>         +       struct thermal_cooling_device_instance *instance;
>         +       struct thermal_cooling_device *cdev;
>         +
>         +       pzone = (struct db8500_thermal_zone
>         *)thermal->devdata;
>         +       pthdev = pzone->therm_dev;
>         +
>         +       if (!pthdev) {
>         +               pr_err("Thermal zone not registered.\n");
>         +               return 0;
>         +       }
>         +
>         +       mutex_lock(&pzone->th_lock);
>         +
>         +       if (mode == THERMAL_DEVICE_ENABLED && pzone->mode !=
>         mode) {
>         +               pzone->mode = mode;
>         +               schedule_work(&pzone->therm_work);
>         +       }
>         +
>         +       if (mode == THERMAL_DEVICE_DISABLED && pzone->mode !=
>         mode) {
>         +               pzone->mode = mode;
>         +
>         +               mutex_lock(&thermal->lock);
>         +               list_for_each_entry(instance,
>         +                       &thermal->cooling_devices, node) {
>         +                       cdev = instance->cdev;
>         +                       if (cdev->ops->set_cur_state)
>         +                               cdev->ops->set_cur_state(cdev,
>         0);
>         +               }
I guess this is the reason why you need patch 1/2, right?

If this is true, IMO, a proper way to do this is to introduce a new API
in the generic thermal layer, say thermal_zone_deactive(), which will
put all referenced cooling device to cooling state 0 instead. what do
you think?

thanks,
rui
>         +               mutex_unlock(&thermal->lock);
>         +       }
>         +
>         +       mutex_unlock(&pzone->th_lock);
>         +
>         +       return 0;
>         +}
>         +
>         +/* Get trip type callback function for thermal zone */
>         +static int db8500_sys_get_trip_type(struct
>         thermal_zone_device *thermal,
>         +                                int trip, enum
>         thermal_trip_type *type)
>         +{
>         +       struct db8500_thermal_zone *pzone;
>         +       struct db8500_thsens_platform_data *ptrips;
>         +
>         +       pzone = (struct db8500_thermal_zone
>         *)thermal->devdata;
>         +       ptrips = pzone->trip_tab;
>         +
>         +       if (trip >= ptrips->num_trips)
>         +               return -EINVAL;
>         +
>         +       *type = ptrips->trip_points[trip].type;
>         +
>         +       return 0;
>         +}
>         +
>         +/* Get trip temperature callback function for thermal zone */
>         +static int db8500_sys_get_trip_temp(struct
>         thermal_zone_device *thermal,
>         +                                int trip, unsigned long
>         *temp)
>         +{
>         +       struct db8500_thermal_zone *pzone;
>         +       struct db8500_thsens_platform_data *ptrips;
>         +
>         +       pzone = (struct db8500_thermal_zone
>         *)thermal->devdata;
>         +       ptrips = pzone->trip_tab;
>         +
>         +       if (trip >= ptrips->num_trips)
>         +               return -EINVAL;
>         +
>         +       *temp = ptrips->trip_points[trip].temp;
>         +
>         +       return 0;
>         +}
>         +
>         +/* Get critical temperature callback function for thermal
>         zone */
>         +static int db8500_sys_get_crit_temp(struct
>         thermal_zone_device *thermal,
>         +                                unsigned long *temp)
>         +{
>         +       struct db8500_thermal_zone *pzone;
>         +       struct db8500_thsens_platform_data *ptrips;
>         +       int i;
>         +
>         +       pzone = (struct db8500_thermal_zone
>         *)thermal->devdata;
>         +       ptrips = pzone->trip_tab;
>         +
>         +       for (i = (ptrips->num_trips - 1) ; i > 0 ; i--) {
>         +               if (ptrips->trip_points[i].type ==
>         THERMAL_TRIP_CRITICAL) {
>         +                       *temp = ptrips->trip_points[i].temp;
>         +                       return 0;
>         +               }
>         +       }
>         +
>         +       return -EINVAL;
>         +}
>         +
>         +static struct thermal_zone_device_ops thdev_ops = {
>         +       .bind = db8500_cdev_bind,
>         +       .unbind = db8500_cdev_unbind,
>         +       .get_temp = db8500_sys_get_temp,
>         +       .get_mode = db8500_sys_get_mode,
>         +       .set_mode = db8500_sys_set_mode,
>         +       .get_trip_type = db8500_sys_get_trip_type,
>         +       .get_trip_temp = db8500_sys_get_trip_temp,
>         +       .get_crit_temp = db8500_sys_get_crit_temp,
>         +};
>         +
>         +static irqreturn_t prcmu_low_irq_handler(int irq, void
>         *irq_data)
>         +{
>         +       struct db8500_thermal_zone *pzone = irq_data;
>         +       struct db8500_thsens_platform_data *ptrips;
>         +       unsigned long next_low, next_high;
>         +       unsigned int idx;
>         +
>         +       ptrips = pzone->trip_tab;
>         +       idx = pzone->cur_index;
>         +       if (unlikely(idx == 0))
>         +               /* Meaningless for thermal management,
>         ignoring it */
>         +               return IRQ_HANDLED;
>         +
>         +       if (idx == 1) {
>         +               next_high = ptrips->trip_points[0].temp;
>         +               next_low = PRCMU_DEFAULT_LOW_TEMP;
>         +       } else {
>         +               next_high = ptrips->trip_points[idx-1].temp;
>         +               next_low = ptrips->trip_points[idx-2].temp;
>         +       }
>         +
>         +       pzone->cur_index -= 1;
>         +       pzone->cur_temp_pseudo = (next_high + next_low)/2;
>         +
>         +       prcmu_stop_temp_sense();
>         +       prcmu_config_hotmon((u8)(next_low/1000),
>         (u8)(next_high/1000));
>         +       prcmu_start_temp_sense(PRCMU_DEFAULT_MEASURE_TIME);
>         +
>         +       pr_debug("PRCMU set max %ld, set min %ld\n",
>         next_high, next_low);
>         +
>         +       schedule_work(&pzone->therm_work);
>         +
>         +       return IRQ_HANDLED;
>         +}
>         +
>         +static irqreturn_t prcmu_high_irq_handler(int irq, void
>         *irq_data)
>         +{
>         +       struct db8500_thermal_zone *pzone = irq_data;
>         +       struct db8500_thsens_platform_data *ptrips;
>         +       unsigned long next_low, next_high;
>         +       unsigned int idx;
>         +
>         +       ptrips = pzone->trip_tab;
>         +       idx = pzone->cur_index;
>         +
>         +       if (idx < ptrips->num_trips - 1) {
>         +               next_high = ptrips->trip_points[idx+1].temp;
>         +               next_low = ptrips->trip_points[idx].temp;
>         +
>         +               pzone->cur_index += 1;
>         +               pzone->cur_temp_pseudo = (next_high +
>         next_low)/2;
>         +
>         +               prcmu_stop_temp_sense();
>         +               prcmu_config_hotmon((u8)(next_low/1000),
>         (u8)(next_high/1000));
>         +
>         prcmu_start_temp_sense(PRCMU_DEFAULT_MEASURE_TIME);
>         +
>         +               pr_debug("PRCMU set max %ld, min %ld\n",
>         next_high, next_low);
>         +       }
>         +
>         +       if (idx == ptrips->num_trips - 1)
>         +               pzone->cur_temp_pseudo =
>         ptrips->trip_points[idx].temp + 1;
>         +
>         +       schedule_work(&pzone->therm_work);
>         +
>         +       return IRQ_HANDLED;
>         +}
>         +
>         +static void db8500_thermal_work(struct work_struct *work)
>         +{
>         +       enum thermal_device_mode cur_mode;
>         +       struct db8500_thermal_zone *pzone;
>         +
>         +       pzone = container_of(work, struct db8500_thermal_zone,
>         therm_work);
>         +
>         +       mutex_lock(&pzone->th_lock);
>         +       cur_mode = pzone->mode;
>         +       mutex_unlock(&pzone->th_lock);
>         +
>         +       if (cur_mode == THERMAL_DEVICE_DISABLED) {
>         +               pr_warn("Warning: thermal function
>         disabled.\n");
>         +               return;
>         +       }
>         +
>         +       thermal_zone_device_update(pzone->therm_dev);
>         +       pr_debug("db8500_thermal_work finished.\n");
>         +}
>         +
>         +static int __devinit db8500_thermal_probe(struct
>         platform_device *pdev)
>         +{
>         +       struct db8500_thermal_zone *pzone = NULL;
>         +       struct db8500_thsens_platform_data *ptrips;
>         +       int low_irq, high_irq, ret = 0;
>         +       unsigned long dft_low, dft_high;
>         +
>         +       pr_info("Function db8500_thermal_probe.\n");
>         +
>         +       pzone = devm_kzalloc(&pdev->dev,
>         +                       sizeof(struct db8500_thermal_zone),
>         GFP_KERNEL);
>         +       if (!pzone)
>         +               return -ENOMEM;
>         +
>         +       pzone->thsens_pdev = pdev;
>         +
>         +       low_irq = platform_get_irq_byname(pdev,
>         "IRQ_HOTMON_LOW");
>         +       if (low_irq < 0) {
>         +               pr_err("Get IRQ_HOTMON_LOW failed.\n");
>         +               return low_irq;
>         +       }
>         +
>         +       ret = devm_request_threaded_irq(&pdev->dev, low_irq,
>         NULL,
>         +               prcmu_low_irq_handler,
>         +               IRQF_NO_SUSPEND | IRQF_ONESHOT,
>         "dbx500_temp_low", pzone);
>         +       if (ret < 0) {
>         +               pr_err("Failed to allocate temp low irq.\n");
>         +               return ret;
>         +       }
>         +
>         +       high_irq = platform_get_irq_byname(pdev,
>         "IRQ_HOTMON_HIGH");
>         +       if (high_irq < 0) {
>         +               pr_err("Get IRQ_HOTMON_HIGH failed.\n");
>         +               return high_irq;
>         +       }
>         +
>         +       ret = devm_request_threaded_irq(&pdev->dev, high_irq,
>         NULL,
>         +               prcmu_high_irq_handler,
>         +               IRQF_NO_SUSPEND | IRQF_ONESHOT,
>         "dbx500_temp_high", pzone);
>         +       if (ret < 0) {
>         +               pr_err("Failed to allocate temp high irq.\n");
>         +               return ret;
>         +       }
>         +
>         +       pzone->low_irq = low_irq;
>         +       pzone->high_irq = high_irq;
>         +
>         +       pzone->mode = THERMAL_DEVICE_DISABLED;
>         +
>         +       mutex_init(&pzone->th_lock);
>         +
>         +       INIT_WORK(&pzone->therm_work, db8500_thermal_work);
>         +
>         +       ptrips = pdev->dev.platform_data;
>         +       pzone->trip_tab = ptrips;
>         +
>         +       pzone->therm_dev =
>         thermal_zone_device_register("db8500_thermal_zone",
>         +               ptrips->num_trips, 0, pzone, &thdev_ops, 0, 0,
>         0, 0);
>         +
>         +       if (IS_ERR(pzone->therm_dev)) {
>         +               pr_err("Failed to register thermal zone device
>         \n");
>         +               return PTR_ERR(pzone->therm_dev);
>         +       }
>         +
>         +       dft_low = PRCMU_DEFAULT_LOW_TEMP;
>         +       dft_high = ptrips->trip_points[0].temp;
>         +
>         +       prcmu_stop_temp_sense();
>         +       prcmu_config_hotmon((u8)(dft_low/1000),
>         (u8)(dft_high/1000));
>         +       prcmu_start_temp_sense(PRCMU_DEFAULT_MEASURE_TIME);
>         +
>         +       pzone->cur_index = 0;
>         +       pzone->cur_temp_pseudo = (dft_low + dft_high)/2;
>         +
>         +       pzone->mode = THERMAL_DEVICE_ENABLED;
>         +
>         +       platform_set_drvdata(pdev, pzone);
>         +
>         +       return 0;
>         +}
>         +
>         +static int __devexit db8500_thermal_remove(struct
>         platform_device *pdev)
>         +{
>         +       struct db8500_thermal_zone *pzone;
>         +       pzone = platform_get_drvdata(pdev);
>         +
>         +       cancel_work_sync(&pzone->therm_work);
>         +
>         +       if (pzone->therm_dev)
>         +
>         thermal_zone_device_unregister(pzone->therm_dev);
>         +
>         +       return 0;
>         +}
>         +
>         +static int db8500_thermal_suspend(struct platform_device
>         *pdev,
>         +               pm_message_t state)
>         +{
>         +       struct db8500_thermal_zone *pzone;
>         +       pzone = platform_get_drvdata(pdev);
>         +
>         +       flush_work_sync(&pzone->therm_work);
>         +       prcmu_stop_temp_sense();
>         +
>         +       return 0;
>         +}
>         +
>         +static int db8500_thermal_resume(struct platform_device
>         *pdev)
>         +{
>         +       struct db8500_thermal_zone *pzone;
>         +       struct db8500_thsens_platform_data *ptrips;
>         +       unsigned long dft_low, dft_high;
>         +
>         +       pzone = platform_get_drvdata(pdev);
>         +       ptrips = pzone->trip_tab;
>         +       dft_low = PRCMU_DEFAULT_LOW_TEMP;
>         +       dft_high = ptrips->trip_points[0].temp;
>         +
>         +       prcmu_config_hotmon((u8)(dft_low/1000),
>         (u8)(dft_high/1000));
>         +       prcmu_start_temp_sense(PRCMU_DEFAULT_MEASURE_TIME);
>         +
>         +       return 0;
>         +}
>         +
>         +#ifdef CONFIG_OF
>         +static const struct of_device_id db8500_thermal_match[] = {
>         +       { .compatible = "stericsson,db8500-thermal" },
>         +       {},
>         +};
>         +#else
>         +#define db8500_thermal_match NULL
>         +#endif
>         +
>         +static struct platform_driver db8500_thermal_driver = {
>         +       .driver = {
>         +               .owner = THIS_MODULE,
>         +               .name = "db8500-thermal",
>         +               .of_match_table = db8500_thermal_match,
>         +       },
>         +       .probe = db8500_thermal_probe,
>         +       .suspend = db8500_thermal_suspend,
>         +       .resume = db8500_thermal_resume,
>         +       .remove = __devexit_p(db8500_thermal_remove),
>         +};
>         +
>         +static int __init db8500_thermal_init(void)
>         +{
>         +       return
>         platform_driver_register(&db8500_thermal_driver);
>         +}
>         +
>         +static void __exit db8500_thermal_exit(void)
>         +{
>         +       platform_driver_unregister(&db8500_thermal_driver);
>         +}
>         +
>         +module_init(db8500_thermal_init);
>         +module_exit(db8500_thermal_exit);
>         +
>         +MODULE_AUTHOR("Hongbo Zhang <hongbo.zhang@stericsson.com>");
>         +MODULE_DESCRIPTION("db8500 thermal driver");
>         +MODULE_LICENSE("GPL");
>         diff --git a/include/linux/platform_data/db8500_thermal.h
>         b/include/linux/platform_data/db8500_thermal.h
>         new file mode 100644
>         index 0000000..0b6d164
>         --- /dev/null
>         +++ b/include/linux/platform_data/db8500_thermal.h
>         @@ -0,0 +1,39 @@
>         +/*
>         + * db8500_thermal.h - db8500 Thermal Management
>         Implementation
>         + *
>         + * Copyright (C) 2012 ST-Ericsson
>         + * Copyright (C) 2012 Linaro Ltd.
>         + *
>         + * Author: Hongbo Zhang <hognbo.zhang@stericsson.com>
>         + *
>         + * This program is free software; you can redistribute it
>         and/or modify
>         + * it under the terms of the GNU General Public License as
>         published by
>         + * the Free Software Foundation; either version 2 of the
>         License, or
>         + * (at your option) any later version.
>         + *
>         + * This program is distributed in the hope that it will be
>         useful,
>         + * but WITHOUT ANY WARRANTY; without even the implied
>         warranty of
>         + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
>         the
>         + * GNU General Public License for more details.
>         + *
>         + */
>         +
>         +#ifndef _DB8500_THERMAL_H_
>         +#define _DB8500_THERMAL_H_
>         +
>         +#include <linux/thermal.h>
>         +
>         +#define COOLING_DEV_MAX 8
>         +
>         +struct db8500_trip_point {
>         +       unsigned long temp;
>         +       enum thermal_trip_type type;
>         +       char *cooling_dev_name[COOLING_DEV_MAX];
>         +};
>         +
>         +struct db8500_thsens_platform_data {
>         +       struct db8500_trip_point *trip_points;
>         +       int num_trips;
>         +};
>         +
>         +#endif /* _DB8500_THERMAL_H_ */
>         --
>         1.7.10
>         
> 


