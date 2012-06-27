Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918Ab2F0Nf4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 09:35:56 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:53321 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab2F0Nfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 09:35:54 -0400
MIME-Version: 1.0
In-Reply-To: <1340772715-22117-2-git-send-email-rob.lee@linaro.org>
References: <1340772715-22117-1-git-send-email-rob.lee@linaro.org> <1340772715-22117-2-git-send-email-rob.lee@linaro.org>
From: Rob Lee <rob.lee@linaro.org>
Date: Wed, 27 Jun 2012 08:35:13 -0500
Message-ID: <CAMXH7KGZ_GBT=EAddos+ynbEhE0Dv_3Gxf3O11shM0HTMKeHaw@mail.gmail.com>
Subject: Re: [PATCH v6] ARM: imx: Add basic imx6q thermal driver
To: kernel@pengutronix.de, shawn.guo@linaro.org
Cc: linux@arm.linux.org.uk, richard.zhao@freescale.com,
        dirk.behme@de.bosch.com, amit.kachhap@linaro.org,
        amit.kucheria@linaro.org, lenb@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2012 at 11:51 PM, Robert Lee <rob.lee@linaro.org> wrote:
> Add imx anatop peripheral thermal driver and use it for imx6q builds.
> This driver hooks into the linux thermal framework which provides a
> sysfs interface for temperature readings and other information and
> a mechanism to shutdown the system upon crossing a critical
> temperature trip point.
>
> Only the sysfs interface and a critcial trip are supported by this
> patch and not any active trip points or cooling devices.
>
> The thermal driver is defaulted to be enabled which required the
> anatopmfd driver to be defaulted to enabled.
>
> Signed-off-by: Robert Lee <rob.lee@linaro.org>
> ---
>  arch/arm/boot/dts/imx6q.dtsi         |    5 +
>  drivers/mfd/Kconfig                  |    1 +
>  drivers/thermal/Kconfig              |    9 +
>  drivers/thermal/Makefile             |    1 +
>  drivers/thermal/imx_anatop_thermal.c |  465 ++++++++++++++++++++++++++++++++++
>  5 files changed, 481 insertions(+)
>  create mode 100644 drivers/thermal/imx_anatop_thermal.c
>
> diff --git a/arch/arm/boot/dts/imx6q.dtsi b/arch/arm/boot/dts/imx6q.dtsi
> index d026f30..b53a16a 100644
> --- a/arch/arm/boot/dts/imx6q.dtsi
> +++ b/arch/arm/boot/dts/imx6q.dtsi
> @@ -449,6 +449,10 @@
>                                         anatop-min-voltage = <725000>;
>                                         anatop-max-voltage = <1450000>;
>                                 };
> +
> +                               thermal {
> +                                       compatible ="fsl,anatop-thermal";
> +                               };
>                         };
>
>                         usbphy@020c9000 { /* USBPHY1 */
> @@ -666,6 +670,7 @@
>                         };
>
>                         ocotp@021bc000 {
> +                               compatible = "fsl,imx6q-ocotp";
>                                 reg = <0x021bc000 0x4000>;
>                         };
>
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index e129c82..552fae3 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -915,6 +915,7 @@ config MFD_STA2X11
>  config MFD_ANATOP
>         bool "Support for Freescale i.MX on-chip ANATOP controller"
>         depends on SOC_IMX6Q
> +       default y
>         help
>           Select this option to enable Freescale i.MX on-chip ANATOP
>           MFD controller. This controller embeds regulator and
> diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
> index 04c6796..a35a35e 100644
> --- a/drivers/thermal/Kconfig
> +++ b/drivers/thermal/Kconfig
> @@ -30,6 +30,15 @@ config CPU_THERMAL
>           and not the ACPI interface.
>           If you want this support, you should say Y or M here.
>
> +config IMX_ANATOP_THERMAL
> +       bool "imx anatop soc thermal driver"
> +       depends on MFD_ANATOP && CPU_THERMAL

I forgot to replace "CPU_THERMAL" with "THERMAL"

> +       default y
> +       help
> +         Enable the on-chip temperature sensor and register the linux thermal
> +         framework to provide SoC temperature data to sysfs and a basic
> +         shutdown mechanism to prevent the SoC from overheating.
> +
>  config SPEAR_THERMAL
>         bool "SPEAr thermal sensor driver"
>         depends on THERMAL
> diff --git a/drivers/thermal/Makefile b/drivers/thermal/Makefile
> index 4636e35..4dd4570 100644
> --- a/drivers/thermal/Makefile
> +++ b/drivers/thermal/Makefile
> @@ -6,3 +6,4 @@ obj-$(CONFIG_THERMAL)           += thermal_sys.o
>  obj-$(CONFIG_CPU_THERMAL)       += cpu_cooling.o
>  obj-$(CONFIG_SPEAR_THERMAL)            += spear_thermal.o
>  obj-$(CONFIG_EXYNOS_THERMAL)           += exynos_thermal.o
> +obj-$(CONFIG_IMX_ANATOP_THERMAL)       += imx_anatop_thermal.o
> diff --git a/drivers/thermal/imx_anatop_thermal.c b/drivers/thermal/imx_anatop_thermal.c
> new file mode 100644
> index 0000000..a932fe8
> --- /dev/null
> +++ b/drivers/thermal/imx_anatop_thermal.c
> @@ -0,0 +1,465 @@
> +/*
> + * Copyright 2012 Freescale Semiconductor, Inc.
> + * Copyright 2012 Linaro Ltd.
> + *
> + * The code contained herein is licensed under the GNU General Public
> + * License. You may obtain a copy of the GNU General Public License
> + * Version 2 or later at the following locations:
> + *
> + * http://www.opensource.org/licenses/gpl-license.html
> + * http://www.gnu.org/copyleft/gpl.html
> + */
> +
> +/*
> + * Thermal driver for i.MX anatop systems.  Implented by hooking in to the
> + * linux thermal framework.
> + */
> +
> +#include <linux/delay.h>
> +#include <linux/device.h>
> +#include <linux/dmi.h>
> +#include <linux/init.h>
> +#include <linux/io.h>
> +#include <linux/kernel.h>
> +#include <linux/mfd/anatop.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_address.h>
> +#include <linux/platform_device.h>
> +#include <linux/smp.h>
> +#include <linux/slab.h>
> +#include <linux/syscalls.h>
> +#include <linux/thermal.h>
> +#include <linux/types.h>
> +
> +/* register define of anatop */
> +#define HW_ANADIG_ANA_MISC0                    0x00000150
> +#define HW_ANADIG_ANA_MISC0_SET                        0x00000154
> +#define HW_ANADIG_ANA_MISC0_CLR                        0x00000158
> +#define HW_ANADIG_ANA_MISC0_TOG                        0x0000015c
> +#define BM_ANADIG_ANA_MISC0_REFTOP_SELBIASOFF  0x00000008
> +
> +#define HW_ANADIG_TEMPSENSE0                   0x00000180
> +#define HW_ANADIG_TEMPSENSE0_SET               0x00000184
> +#define HW_ANADIG_TEMPSENSE0_CLR               0x00000188
> +#define HW_ANADIG_TEMPSENSE0_TOG               0x0000018c
> +
> +#define BP_ANADIG_TEMPSENSE0_TEMP_VALUE                8
> +#define BM_ANADIG_TEMPSENSE0_TEMP_VALUE                0x000FFF00
> +#define BM_ANADIG_TEMPSENSE0_FINISHED          0x00000004
> +#define BM_ANADIG_TEMPSENSE0_MEASURE_TEMP      0x00000002
> +#define BM_ANADIG_TEMPSENSE0_POWER_DOWN                0x00000001
> +
> +#define HW_ANADIG_TEMPSENSE1                   0x00000190
> +#define HW_ANADIG_TEMPSENSE1_SET               0x00000194
> +#define HW_ANADIG_TEMPSENSE1_CLR               0x00000198
> +#define BP_ANADIG_TEMPSENSE1_MEASURE_FREQ      0
> +#define BM_ANADIG_TEMPSENSE1_MEASURE_FREQ      0x0000FFFF
> +
> +#define HW_OCOTP_ANA1                          0x000004E0
> +
> +#define IMX_THERMAL_POLLING_FREQUENCY_MS 1000
> +
> +#define IMX_ANATOP_TS_NOISE_MARGIN 3000 /* in millicelsius */
> +#define IMX_ANATOP_TS_NOISE_COUNT      3
> +
> +/* anatop temperature sensor data */
> +struct imx_anatop_tsdata {
> +       int     c1, c2;
> +       u32     noise_margin;   /* in millicelsius */
> +       int     last_temp;      /* in millicelsius */
> +       /*
> +        * When filtering noise, if consecutive measurements are each higher
> +        * up to consec_high_limit times, assume changing temperature readings
> +        * to be valid and not noise.
> +        */
> +       u32     consec_high_limit;
> +       bool    handle_suspend;
> +       struct anatop *anatopmfd;
> +
> +};
> +
> +struct imx_anatop_thdata {
> +       struct thermal_zone_device      *tzdev;
> +       struct imx_anatop_tsdata        sensor_data;
> +       struct thermal_zone_device_ops  dev_ops;
> +       unsigned int                    crit_temp_level;
> +       void __iomem                    *ocotp_base;
> +};
> +
> +static inline int anatop_get_temp(int *temp, struct thermal_zone_device *tzdev)
> +{
> +       unsigned int n_meas;
> +       unsigned int reg;
> +       struct imx_anatop_tsdata *sd;
> +
> +       sd = &((struct imx_anatop_thdata *)tzdev->devdata)->sensor_data;
> +
> +
> +       do {
> +               /*
> +                * Every time we measure the temperature, we will power on the
> +                * temperature sensor, enable measurements, take a reading,
> +                * disable measurements, power off the temperature sensor.
> +                */
> +               sd->handle_suspend = false;
> +
> +               anatop_write_reg(sd->anatopmfd, HW_ANADIG_TEMPSENSE0, 0,
> +                       BM_ANADIG_TEMPSENSE0_POWER_DOWN);
> +               anatop_write_reg(sd->anatopmfd, HW_ANADIG_TEMPSENSE0,
> +                       BM_ANADIG_TEMPSENSE0_MEASURE_TEMP,
> +                       BM_ANADIG_TEMPSENSE0_MEASURE_TEMP);
> +               /*
> +                * According to the anatop temp sensor designers, it may require
> +                * up to ~17us to complete a measurement (imx6q).
> +                * But this timing isn't checked on every part nor is it
> +                * specified in the datasheet,  so sleeping at least 1ms should
> +                * provide plenty of time.  Sleeping longer than 1ms is ok so no
> +                * need for usleep_range */
> +               msleep(1);
> +
> +               reg = anatop_read_reg(sd->anatopmfd, HW_ANADIG_TEMPSENSE0);
> +
> +               anatop_write_reg(sd->anatopmfd, HW_ANADIG_TEMPSENSE0, 0,
> +                       BM_ANADIG_TEMPSENSE0_MEASURE_TEMP);
> +               anatop_write_reg(sd->anatopmfd, HW_ANADIG_TEMPSENSE0,
> +                       BM_ANADIG_TEMPSENSE0_POWER_DOWN,
> +                       BM_ANADIG_TEMPSENSE0_POWER_DOWN);
> +
> +       /* if we had a suspend and resume event, we will re-take the reading */
> +       } while (sd->handle_suspend);
> +
> +       if (!(reg & BM_ANADIG_TEMPSENSE0_FINISHED) &&
> +               (reg & BM_ANADIG_TEMPSENSE0_TEMP_VALUE)) {
> +               dev_dbg(&tzdev->device,
> +                       "Temp sensor error: reading never finished");
> +               return -EAGAIN;
> +       }
> +
> +       n_meas = (reg & BM_ANADIG_TEMPSENSE0_TEMP_VALUE)
> +                       >> BP_ANADIG_TEMPSENSE0_TEMP_VALUE;
> +
> +       /* See anatop_process_ts_fuse_data() for forumla derivation. */
> +       *temp = sd->c2 + (sd->c1 * n_meas);
> +
> +       dev_dbg(&tzdev->device, "Temperature: %d\n", *temp / 1000);
> +       return 0;
> +}
> +
> +static int th_sys_get_temp(struct thermal_zone_device *tzdev,
> +                                 unsigned long *temp)
> +{
> +       int i, total = 0, tmp = 0;
> +       const u8 loop = 5;
> +       u32 consec_high = 0;
> +
> +       struct imx_anatop_tsdata *sd;
> +
> +       sd = &((struct imx_anatop_thdata *)tzdev->devdata)->sensor_data;
> +
> +       /*
> +        * Measure temperature and handle noise
> +        *
> +        * While the anatop temperature sensor is designed to minimize being
> +        * affected by system noise, it's safest to run sanity checks and
> +        * perform any necessary filtering, if a noise_margin has been defined.
> +        */
> +       for (i = 0; (sd->noise_margin) && (i < loop); i++) {
> +               /*
> +                * We expect the sensor reading to be successful, but if for
> +                * unknow reason it is not, use the data from the last
> +                * successful reading
> +                */
> +               if (anatop_get_temp(&tmp, tzdev)) {
> +                       tmp = sd->last_temp;
> +                       continue;
> +               }
> +
> +               if ((abs(tmp - sd->last_temp) <= sd->noise_margin) ||
> +                       (consec_high >= sd->consec_high_limit)) {
> +                       sd->last_temp = tmp;
> +                       i = 0;
> +                       break;
> +               }
> +               if (tmp > sd->last_temp)
> +                       consec_high++;
> +
> +               /*
> +                * ignore first measurement as the previous measurement was
> +                * a long time ago.
> +                */
> +               if (i)
> +                       total += tmp;
> +
> +               sd->last_temp = tmp;
> +       }
> +
> +       if (sd->noise_margin && i)
> +               tmp = total / (loop - 1);
> +
> +       /*
> +        * The thermal framework code stores temperature in unsigned long. Also,
> +        * it has references to "millicelsius" which limits the lowest
> +        * temperature possible (compared to Kelvin).
> +        */
> +       if (tmp > 0)
> +               *temp = tmp;
> +       else
> +               *temp = 0;
> +       return 0;
> +}
> +
> +static int th_sys_get_mode(struct thermal_zone_device *tzdev,
> +                           enum thermal_device_mode *mode)
> +{
> +       *mode = THERMAL_DEVICE_ENABLED;
> +       return 0;
> +}
> +
> +static int th_sys_get_trip_type(struct thermal_zone_device *tzdev, int trip,
> +                                enum thermal_trip_type *type)
> +{
> +       *type = THERMAL_TRIP_CRITICAL;
> +       return 0;
> +}
> +
> +static int th_sys_get_crit_temp(struct thermal_zone_device *tzdev,
> +                                unsigned long *temp)
> +{
> +       struct imx_anatop_thdata *p;
> +
> +       p = (struct imx_anatop_thdata *)tzdev->devdata;
> +       *temp = p->crit_temp_level;
> +       return 0;
> +}
> +
> +static int th_sys_get_trip_temp(struct thermal_zone_device *tzdev, int trip,
> +                                unsigned long *temp)
> +{
> +       /* only a critical trip point is supported, for now. */
> +       return th_sys_get_crit_temp(tzdev, temp);
> +}
> +
> +static int __devinit anatop_process_ts_fuse_data(unsigned int fuse_data,
> +                struct imx_anatop_thdata *thermal_data)
> +{
> +       int t1, t2, n1, n2;
> +       struct imx_anatop_tsdata *sd = &thermal_data->sensor_data;
> +       struct thermal_zone_device *tzdev = thermal_data->tzdev;
> +
> +
> +       if (fuse_data == 0 || fuse_data == 0xffffffff) {
> +               dev_warn(&tzdev->device, "WARNING: Disabling CPU thermal "
> +                       "protection (invalid calibration value of %x detected\n"
> +                       , fuse_data);
> +               return -EINVAL;
> +       }
> +
> +       /*
> +        * Fuse data layout:
> +        * [31:20] sensor value @ 25C
> +        * [19:8] sensor value of hot
> +        * [7:0] hot temperature value
> +        */
> +       n1 = fuse_data >> 20;
> +       n2 = (fuse_data & 0xfff00) >> 8;
> +       t2 = fuse_data & 0xff;
> +       t1 = 25; /* t1 always 25C */
> +
> +       dev_dbg(&tzdev->device, " -- temperature sensor calibration data --\n");
> +       dev_dbg(&tzdev->device, "HW_OCOTP_ANA1: %x\n", fuse_data);
> +       dev_dbg(&tzdev->device, "n1: %d\nn2: %d\nt1: %d\nt2: %d\n", n1, n2, t1,
> +               t2);
> +
> +       /*
> +        * Derived from linear interpolation,
> +        * Tmeas = T2 + (Nmeas - N2) * (T1 - T2) / (N1 - N2)
> +        * We want to reduce this down to the minimum computation necessary
> +        * for each temperature read.  Also, we want Tmeas in millicelsius
> +        * and we don't want to lose precision from integer division. So...
> +        * milli_Tmeas = 1000 * T2 + 1000 * (Nmeas - N2) * (T1 - T2) / (N1 - N2)
> +        * Let constant c1 = 1000 * (T1 - T2) / (N1 - N2)
> +        * milli_Tmeas = (1000 * T2) + c1 * (Nmeas - N2)
> +        * milli_Tmeas = (1000 * T2) + (c1 * Nmeas) - (c1 * N2)
> +        * Let constant c2 = (1000 * T2) - (c1 * N2)
> +        * milli_Tmeas = c2 + (c1 * Nmeas)
> +        */
> +       sd->c1 = (1000 * (t1 - t2)) / (n1 - n2);
> +       sd->c2 = (1000 * t2) - (sd->c1 * n2);
> +
> +       dev_dbg(&tzdev->device, "c1: %i\n", sd->c1);
> +       dev_dbg(&tzdev->device, "c2: %i\n", sd->c2);
> +       return 0;
> +}
> +
> +static int anatop_thermal_suspend(struct platform_device *pdev,
> +                                       pm_message_t state)
> +{
> +       struct imx_anatop_thdata *dd = platform_get_drvdata(pdev);
> +       struct imx_anatop_tsdata *sd = &dd->sensor_data;
> +
> +       /* power off the sensor during suspend */
> +       anatop_write_reg(sd->anatopmfd, HW_ANADIG_TEMPSENSE0, 0,
> +               BM_ANADIG_TEMPSENSE0_MEASURE_TEMP);
> +
> +       anatop_write_reg(sd->anatopmfd, HW_ANADIG_TEMPSENSE0,
> +               BM_ANADIG_TEMPSENSE0_POWER_DOWN,
> +               BM_ANADIG_TEMPSENSE0_POWER_DOWN);
> +       return 0;
> +}
> +
> +static int anatop_thermal_resume(struct platform_device *pdev)
> +{
> +       struct imx_anatop_thdata *dd = platform_get_drvdata(pdev);
> +       struct imx_anatop_tsdata *sd = &dd->sensor_data;
> +
> +       sd->handle_suspend = true;
> +       return 0;
> +}
> +
> +static int __devexit anatop_thermal_remove(struct platform_device *pdev)
> +{
> +       struct imx_anatop_thdata *dd = platform_get_drvdata(pdev);
> +
> +       if (dd && dd->tzdev)
> +               thermal_zone_device_unregister(dd->tzdev);
> +
> +       if (dd->ocotp_base)
> +               iounmap(dd->ocotp_base);
> +
> +       dev_info(&pdev->dev, "imx thermal management unregistered\n");
> +       return 0;
> +}
> +
> +static int __devinit anatop_thermal_probe(struct platform_device *pdev)
> +{
> +       unsigned int fuse_data;
> +       void __iomem *ocotp_base;
> +       struct device_node *np_ocotp, *np_thermal;
> +       static struct imx_anatop_thdata *therm_data;
> +       struct anatop *anatopmfd = dev_get_drvdata(pdev->dev.parent);
> +
> +       struct imx_anatop_tsdata *sd;
> +       int ret;
> +
> +       np_ocotp = of_find_compatible_node(NULL, NULL, "fsl,imx6q-ocotp");
> +       np_thermal = pdev->dev.of_node;
> +
> +       if (!(np_ocotp && np_thermal && anatopmfd))
> +               return 0;
> +
> +       ocotp_base = of_iomap(np_ocotp, 0);
> +
> +       if (!ocotp_base) {
> +               dev_err(&pdev->dev, "Could not retrieve ocotp-base\n");
> +               ret = -ENXIO;
> +               goto err_unregister;
> +       }
> +
> +       fuse_data = readl_relaxed(ocotp_base + HW_OCOTP_ANA1);
> +
> +       therm_data = devm_kzalloc(&pdev->dev, sizeof(struct imx_anatop_thdata),
> +               GFP_KERNEL);
> +
> +
> +       if (!therm_data) {
> +               ret = -ENOMEM;
> +               goto err_unregister;
> +       }
> +
> +       therm_data->dev_ops.get_temp = th_sys_get_temp;
> +       therm_data->dev_ops.get_mode = th_sys_get_mode;
> +       therm_data->dev_ops.get_trip_type = th_sys_get_trip_type;
> +       therm_data->dev_ops.get_trip_temp = th_sys_get_trip_temp;
> +       therm_data->dev_ops.get_crit_temp = th_sys_get_crit_temp;
> +
> +       /*
> +        * max die temp on imx parts using anatop is 105C, let's give some
> +        * cushion for noise and possible temperature rise between measurements.
> +        */
> +       therm_data->crit_temp_level = 100000; /* in millicelsius */
> +
> +       sd = &therm_data->sensor_data;
> +       sd->noise_margin = IMX_ANATOP_TS_NOISE_MARGIN;
> +       sd->consec_high_limit = IMX_ANATOP_TS_NOISE_COUNT;
> +       sd->anatopmfd = anatopmfd;
> +
> +       platform_set_drvdata(pdev, therm_data);
> +
> +       ret = anatop_process_ts_fuse_data(fuse_data, therm_data);
> +
> +       if (ret) {
> +               dev_err(&pdev->dev, "Invalid temperature calibration data.\n");
> +               goto err_unregister;
> +       }
> +
> +       /* Make sure sensor is in known good state for measurements */
> +       anatop_write_reg(anatopmfd, HW_ANADIG_TEMPSENSE0, 0,
> +               BM_ANADIG_TEMPSENSE0_POWER_DOWN);
> +
> +       anatop_write_reg(anatopmfd, HW_ANADIG_TEMPSENSE0, 0,
> +               BM_ANADIG_TEMPSENSE0_MEASURE_TEMP);
> +
> +       anatop_write_reg(anatopmfd, HW_ANADIG_TEMPSENSE1, 0,
> +               BM_ANADIG_TEMPSENSE1_MEASURE_FREQ);
> +
> +       anatop_write_reg(anatopmfd, HW_ANADIG_ANA_MISC0_SET,
> +               BM_ANADIG_ANA_MISC0_REFTOP_SELBIASOFF,
> +               BM_ANADIG_ANA_MISC0_REFTOP_SELBIASOFF);
> +
> +       anatop_write_reg(anatopmfd, HW_ANADIG_TEMPSENSE0,
> +               BM_ANADIG_TEMPSENSE0_POWER_DOWN,
> +               BM_ANADIG_TEMPSENSE0_POWER_DOWN);
> +
> +       therm_data->tzdev = thermal_zone_device_register(
> +               "Processor", 1, therm_data, &therm_data->dev_ops, 0, 0, 0,
> +               IMX_THERMAL_POLLING_FREQUENCY_MS);
> +
> +       if (IS_ERR(therm_data->tzdev)) {
> +               dev_err(&pdev->dev,
> +                       "Failed to register thermal zone device\n");
> +               ret = -EINVAL;
> +               goto err_unregister;
> +       }
> +
> +       dev_info(&pdev->dev, "imx thermal management registered\n");
> +       return 0;
> +
> +err_unregister:
> +       anatop_thermal_remove(pdev);
> +       return ret;
> +}
> +
> +static struct of_device_id __devinitdata of_anatop_thermal_match_tbl[] = {
> +       { .compatible = "fsl,anatop-thermal", },
> +       { /* end */ }
> +};
> +
> +static struct platform_driver anatop_thermal = {
> +       .driver = {
> +               .name   = "anatop_thermal",
> +               .owner  = THIS_MODULE,
> +               .of_match_table = of_anatop_thermal_match_tbl,
> +       },
> +       .probe          = anatop_thermal_probe,
> +       .remove         = anatop_thermal_remove,
> +       .suspend        = anatop_thermal_suspend,
> +       .resume         = anatop_thermal_resume,
> +};
> +
> +static int __devinit anatop_thermal_init(void)
> +{
> +       return platform_driver_register(&anatop_thermal);
> +}
> +device_initcall(anatop_thermal_init);
> +
> +static void __exit anatop_thermal_exit(void)
> +{
> +       platform_driver_unregister(&anatop_thermal);
> +}
> +module_exit(anatop_thermal_exit);
> +
> +MODULE_AUTHOR("Freescale Semiconductor");
> +MODULE_DESCRIPTION("i.MX anatop thermal driver");
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS("platform:imx-anatop-thermal");
> --
> 1.7.10
>
