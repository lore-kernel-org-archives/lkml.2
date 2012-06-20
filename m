Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756376Ab2FTONg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 10:13:36 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:49115 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426Ab2FTONe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 10:13:34 -0400
MIME-Version: 1.0
In-Reply-To: <20120620101127.GS28394@pengutronix.de>
References: <1340175964-4043-1-git-send-email-rob.lee@linaro.org>
 <1340175964-4043-2-git-send-email-rob.lee@linaro.org> <20120620101127.GS28394@pengutronix.de>
From: Rob Lee <rob.lee@linaro.org>
Date: Wed, 20 Jun 2012 09:12:51 -0500
Message-ID: <CAMXH7KE0Ei5cZLCOuO-hxBXW8WX48VhxNs2FxPV8biDNqzRY5A@mail.gmail.com>
Subject: Re: [PATCH v5] ARM: imx: Add basic imx6q cpu thermal management
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: kernel@pengutronix.de, shawn.guo@linaro.org, linux@arm.linux.org.uk,
        richard.zhao@freescale.com, dirk.behme@de.bosch.com,
        amit.kachhap@linaro.org, amit.kucheria@linaro.org, lenb@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sascha, thanks for the review.

On Wed, Jun 20, 2012 at 5:11 AM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> On Wed, Jun 20, 2012 at 02:06:04AM -0500, Robert Lee wrote:
>> Add imx6q cpu thermal management driver using the new cpu cooling
>> interface which limits system performance via cpufreq to reduce
>> the cpu temperature.  Temperature readings are taken using
>> the imx6q temperature sensor and this functionality was added
>> as part of this cpu thermal management driver.
>>
>> Signed-off-by: Robert Lee <rob.lee@linaro.org>
>> ---
>>  arch/arm/boot/dts/imx6q.dtsi    |    5 +
>>  drivers/thermal/Kconfig         |   28 ++
>>  drivers/thermal/Makefile        |    1 +
>>  drivers/thermal/imx6q_thermal.c |  593 +++++++++++++++++++++++++++++++++++++++
>>  4 files changed, 627 insertions(+)
>>  create mode 100644 drivers/thermal/imx6q_thermal.c
>>
>> diff --git a/arch/arm/boot/dts/imx6q.dtsi b/arch/arm/boot/dts/imx6q.dtsi
>> index 8c90cba..2650f65 100644
>> --- a/arch/arm/boot/dts/imx6q.dtsi
>> +++ b/arch/arm/boot/dts/imx6q.dtsi
>> @@ -442,6 +442,10 @@
>>                                       anatop-min-voltage = <725000>;
>>                                       anatop-max-voltage = <1450000>;
>>                               };
>> +
>> +                             thermal {
>> +                                     compatible ="fsl,anatop-thermal";
>> +                             };
>>                       };
>>
>>                       usbphy@020c9000 { /* USBPHY1 */
>> @@ -659,6 +663,7 @@
>>                       };
>>
>>                       ocotp@021bc000 {
>> +                             compatible = "fsl,imx6q-ocotp";
>>                               reg = <0x021bc000 0x4000>;
>>                       };
>>
>> diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
>> index 04c6796..b80c408 100644
>> --- a/drivers/thermal/Kconfig
>> +++ b/drivers/thermal/Kconfig
>> @@ -30,6 +30,34 @@ config CPU_THERMAL
>>         and not the ACPI interface.
>>         If you want this support, you should say Y or M here.
>>
>> +config IMX6Q_THERMAL
>> +     bool "IMX6Q Thermal interface support"
>> +     depends on MFD_ANATOP && CPU_THERMAL
>> +     help
>> +       Adds thermal management for IMX6Q.
>> +
>> +config IMX6Q_THERMAL_FAKE_CALIBRATION
>> +     bool "IMX6Q fake temperature sensor calibration (FOR TESTING ONLY)"
>> +     depends on IMX6Q_THERMAL
>> +     help
>> +       This enables a fake temp sensor calibration value for parts without
>> +       the correction calibration values burned into OCOTP. If the part
>> +       already has the calibrated values burned into OCOTP, enabling this
>> +       does nothing.
>> +       WARNING: Use of this feature is for testing only as it will cause
>> +       incorrect temperature readings which will result in incorrect system
>> +       thermal limiting behavior such as premature system performance
>> +       limiting or lack of proper performance reduction to reduce cpu
>> +       temperature
>> +
>> +config IMX6Q_THERMAL_FAKE_CAL_VAL
>> +     hex "IMX6Q fake temperature sensor calibration value"
>> +     depends on IMX6Q_THERMAL_FAKE_CALIBRATION
>> +     default 0x5704c67d
>> +     help
>> +       Refer to the temperature sensor section of the imx6q reference manual
>> +       for more inforation on how this value is used.
>
> Don't add such stuff to Kconfig. If during runtime you detect that there
> is no calibration data, then issue a warning and fall back to a safe
> value. If you really think this should be configurable, add a sysfs
> entry for it. "FOR TESTING ONLY" seems to imply though that it shouldn't
> be configurable.
>

Ok, I'll remove this in v6.

>
>> +
>>  config SPEAR_THERMAL
>>       bool "SPEAr thermal sensor driver"
>>       depends on THERMAL
>> diff --git a/drivers/thermal/Makefile b/drivers/thermal/Makefile
>> index 4636e35..fc4004e 100644
>> --- a/drivers/thermal/Makefile
>> +++ b/drivers/thermal/Makefile
>> @@ -6,3 +6,4 @@ obj-$(CONFIG_THERMAL)         += thermal_sys.o
>>  obj-$(CONFIG_CPU_THERMAL)       += cpu_cooling.o
>>  obj-$(CONFIG_SPEAR_THERMAL)          += spear_thermal.o
>>  obj-$(CONFIG_EXYNOS_THERMAL)         += exynos_thermal.o
>> +obj-$(CONFIG_IMX6Q_THERMAL)  += imx6q_thermal.o
>> diff --git a/drivers/thermal/imx6q_thermal.c b/drivers/thermal/imx6q_thermal.c
>> new file mode 100644
>> index 0000000..255d646
>> --- /dev/null
>> +++ b/drivers/thermal/imx6q_thermal.c
>> @@ -0,0 +1,593 @@
>> +/*
>> + * Copyright 2012 Freescale Semiconductor, Inc.
>> + * Copyright 2012 Linaro Ltd.
>> + *
>> + * The code contained herein is licensed under the GNU General Public
>> + * License. You may obtain a copy of the GNU General Public License
>> + * Version 2 or later at the following locations:
>> + *
>> + * http://www.opensource.org/licenses/gpl-license.html
>> + * http://www.gnu.org/copyleft/gpl.html
>> + */
>> +
>> +/* i.MX6Q Thermal Implementation */
>> +
>> +#include <linux/kernel.h>
>> +#include <linux/device.h>
>> +#include <linux/module.h>
>> +#include <linux/dmi.h>
>> +#include <linux/init.h>
>> +#include <linux/slab.h>
>> +#include <linux/delay.h>
>> +#include <linux/types.h>
>> +#include <linux/thermal.h>
>> +#include <linux/io.h>
>> +#include <linux/syscalls.h>
>> +#include <linux/cpufreq.h>
>> +#include <linux/of.h>
>> +#include <linux/of_address.h>
>> +#include <linux/smp.h>
>> +#include <linux/cpu_cooling.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/mfd/anatop.h>
>> +
>> +/* register define of anatop */
>> +#define HW_ANADIG_ANA_MISC0                  0x00000150
>> +#define HW_ANADIG_ANA_MISC0_SET                      0x00000154
>> +#define HW_ANADIG_ANA_MISC0_CLR                      0x00000158
>> +#define HW_ANADIG_ANA_MISC0_TOG                      0x0000015c
>> +#define BM_ANADIG_ANA_MISC0_REFTOP_SELBIASOFF        0x00000008
>> +
>> +#define HW_ANADIG_TEMPSENSE0                 0x00000180
>> +#define HW_ANADIG_TEMPSENSE0_SET             0x00000184
>> +#define HW_ANADIG_TEMPSENSE0_CLR             0x00000188
>> +#define HW_ANADIG_TEMPSENSE0_TOG             0x0000018c
>> +
>> +#define BP_ANADIG_TEMPSENSE0_TEMP_VALUE              8
>> +#define BM_ANADIG_TEMPSENSE0_TEMP_VALUE              0x000FFF00
>> +#define BM_ANADIG_TEMPSENSE0_FINISHED                0x00000004
>> +#define BM_ANADIG_TEMPSENSE0_MEASURE_TEMP    0x00000002
>> +#define BM_ANADIG_TEMPSENSE0_POWER_DOWN              0x00000001
>> +
>> +#define HW_ANADIG_TEMPSENSE1                 0x00000190
>> +#define HW_ANADIG_TEMPSENSE1_SET             0x00000194
>> +#define HW_ANADIG_TEMPSENSE1_CLR             0x00000198
>> +#define BP_ANADIG_TEMPSENSE1_MEASURE_FREQ    0
>> +#define BM_ANADIG_TEMPSENSE1_MEASURE_FREQ    0x0000FFFF
>> +
>> +#define HW_OCOTP_ANA1                                0x000004E0
>> +
>> +#define IMX6Q_THERMAL_POLLING_FREQUENCY_MS 1000
>> +
>> +#define IMX6Q_THERMAL_ACTIVE_TRP_PTS 3
>> +/* assumption: always one critical trip point */
>> +#define IMX6Q_THERMAL_TOTAL_TRP_PTS (IMX6Q_THERMAL_ACTIVE_TRP_PTS + 1)
>> +
>> +struct imx6q_sensor_data {
>> +     int     c1, c2;
>> +     char    name[16];
>> +     u8      meas_delay;     /* in milliseconds */
>> +     u32     noise_margin;   /* in millicelcius */
>> +     int     last_temp;      /* in millicelcius */
>
> s/celcius/celsius/
>

Oops, will fix this in v6.

>> +     /*
>> +      * When noise filtering, if consecutive measurements are each higher
>> +      * up to consec_high_limit times, assume changing temperature readings
>> +      * to be valid and not noise.
>> +      */
>> +     u32     consec_high_limit;
>> +     struct anatop *anatopmfd;
>> +};
>> +
>> +struct imx6q_thermal_data {
>> +     enum thermal_trip_type type[IMX6Q_THERMAL_TOTAL_TRP_PTS];
>> +     struct freq_clip_table freq_tab[IMX6Q_THERMAL_ACTIVE_TRP_PTS];
>> +     unsigned int crit_temp_level;
>> +};
>> +
>> +struct imx6q_thermal_zone {
>> +     struct thermal_zone_device      *therm_dev;
>> +     struct thermal_cooling_device   *cool_dev;
>> +     struct imx6q_sensor_data        *sensor_data;
>> +     struct imx6q_thermal_data       *thermal_data;
>> +     struct thermal_zone_device_ops  dev_ops;
>> +};
>> +
>> +static struct imx6q_sensor_data g_sensor_data __devinitdata = {
>> +     .name                   = "imx6q-temp_sens",
>> +     .meas_delay             = 1,    /* in milliseconds */
>
> This is initialized here, once again in probe and never changed to any
> other value.
>
>> +     .noise_margin           = 3000,
>> +     .consec_high_limit      = 3,
>> +};
>
> Also constant values. What's the purpose of collecting these in this
> struct?
>

There's not a good purpose for doing it this way now.  It came from a
very early implementation that ended up changing before submitting.
I'll fix this in v6.

>> +
>> +/*
>> + * This data defines the various temperature trip points that will trigger
>> + * cooling action when crossed.
>> + */
>> +static struct imx6q_thermal_data g_thermal_data __devinitdata = {
>> +     .type[0] = THERMAL_TRIP_ACTIVE,
>> +     .freq_tab[0] = {
>> +             .freq_clip_max = 800 * 1000,
>> +             .temp_level = 85000,
>> +     },
>> +     .type[1] = THERMAL_TRIP_ACTIVE,
>> +     .freq_tab[1] = {
>> +             .freq_clip_max = 400 * 1000,
>> +             .temp_level = 90000,
>> +     },
>> +     .type[2] = THERMAL_TRIP_ACTIVE,
>> +     .freq_tab[2] = {
>> +             .freq_clip_max = 200 * 1000,
>> +             .temp_level = 95000,
>> +     },
>> +     .type[3] = THERMAL_TRIP_CRITICAL,
>> +     .crit_temp_level = 100000,
>> +};
>> +
>> +static int th_sys_get_temp(struct thermal_zone_device *thermal,
>> +                               unsigned long *temp);
>> +
>> +static struct imx6q_thermal_zone     *th_zone;
>> +static void __iomem                  *ocotp_base;
>
> This is a driver and drivers should generally be multi instance safe.
>

I don't understand what this comment is referring to.  Could you elaborate?

>> +
>> +static inline int imx6q_get_temp(int *temp, struct imx6q_sensor_data *sd)
>> +{
>> +     unsigned int n_meas;
>> +     unsigned int reg;
>> +
>> +     do {
>> +             /*
>> +              * Every time we measure the temperature, we will power on the
>> +              * temperature sensor, enable measurements, take a reading,
>> +              * disable measurements, power off the temperature sensor.
>> +              */
>> +             anatop_write_reg(sd->anatopmfd, HW_ANADIG_TEMPSENSE0, 0,
>> +                     BM_ANADIG_TEMPSENSE0_POWER_DOWN);
>> +
>> +             anatop_write_reg(sd->anatopmfd, HW_ANADIG_TEMPSENSE0,
>> +                     BM_ANADIG_TEMPSENSE0_MEASURE_TEMP,
>> +                     BM_ANADIG_TEMPSENSE0_MEASURE_TEMP);
>> +
>> +             /*
>> +              * According to imx6q temp sensor designers,
>> +              * it may require up to ~17us to complete
>> +              * a measurement.  But this timing isn't checked on every part
>> +              * nor is it specified in the datasheet, so we check the
>> +              * 'finished' status bit to be sure of completion of a valid
>> +              * measurement.
>> +              */
>> +             msleep(sd->meas_delay);
>
> The comment seems to have nothing to do with calling msleep, and it's
> not clear to me why you have to put the argument to msleep into a
> struct.
>

Agree, it should move below to where we actually check the status bit.
 There isn't a good reason why the argument must be in the sensor data
struct in the current implementation.  I will fix these issues in v6.

>> +
>> +             reg = anatop_read_reg(sd->anatopmfd, HW_ANADIG_TEMPSENSE0);
>> +
>> +             anatop_write_reg(sd->anatopmfd, HW_ANADIG_TEMPSENSE0, 0,
>> +                     BM_ANADIG_TEMPSENSE0_MEASURE_TEMP);
>> +
>> +             anatop_write_reg(sd->anatopmfd, HW_ANADIG_TEMPSENSE0,
>> +                     BM_ANADIG_TEMPSENSE0_POWER_DOWN,
>> +                     BM_ANADIG_TEMPSENSE0_POWER_DOWN);
>> +
>> +     } while (!(reg & BM_ANADIG_TEMPSENSE0_FINISHED) &&
>> +              (reg & BM_ANADIG_TEMPSENSE0_TEMP_VALUE));
>
> You should never solely depend on hardware to break out of loops.
>

Ok, I will re-work the implementation to not require this.

>> +
>> +     n_meas = (reg & BM_ANADIG_TEMPSENSE0_TEMP_VALUE)
>> +                     >> BP_ANADIG_TEMPSENSE0_TEMP_VALUE;
>> +
>> +     /* See imx6q_thermal_process_fuse_data() for forumla derivation. */
>> +     *temp = sd->c2 + (sd->c1 * n_meas);
>> +
>> +     pr_debug("Temperature: %d\n", *temp / 1000);
>> +
>> +     return 0;
>> +}
>> +
>> +static int th_sys_get_temp(struct thermal_zone_device *thermal,
>> +                               unsigned long *temp)
>> +{
>> +     int i, total = 0, tmp = 0;
>> +     const u8 loop = 5;
>> +     u32 consec_high = 0;
>> +
>> +     struct imx6q_sensor_data *sd;
>> +
>> +     sd = ((struct imx6q_thermal_zone *)thermal->devdata)->sensor_data;
>> +
>> +     /*
>> +      * Measure temperature and handle noise
>> +      *
>> +      * While the imx6q temperature sensor is designed to minimize being
>> +      * affected by system noise, it's safest to run sanity checks and
>> +      * perform any necessary filitering.
>
> s/filitering/filtering/
>

Oops, will fix in v6.

>> +      */
>> +     for (i = 0; (sd->noise_margin) && (i < loop); i++) {
>> +             imx6q_get_temp(&tmp, sd);
>> +
>> +             if ((abs(tmp - sd->last_temp) <= sd->noise_margin) ||
>> +                     (consec_high >= sd->consec_high_limit)) {
>> +                     sd->last_temp = tmp;
>> +                     i = 0;
>> +                     break;
>> +             }
>> +             if (tmp > sd->last_temp)
>> +                     consec_high++;
>> +
>> +             /*
>> +              * ignore first measurement as the previous measurement was
>> +              * a long time ago.
>> +              */
>> +             if (i)
>> +                     total += tmp;
>> +
>> +             sd->last_temp = tmp;
>> +     }
>> +
>> +     if (sd->noise_margin && i)
>> +             tmp = total / (loop - 1);
>> +
>> +     /*
>> +      * The thermal framework code stores temperature in unsigned long. Also,
>> +      * it has references to "millicelcius" which limits the lowest
>
> s/celcius/celsius/
>

Oops, will fix in v6.

>> +      * temperature possible (compared to Kelvin).
>> +      */
>> +     if (tmp > 0)
>> +             *temp = tmp;
>> +     else
>> +             *temp = 0;
>> +
>> +     return 0;
>> +}
>> +
>> +static int th_sys_get_mode(struct thermal_zone_device *thermal,
>> +                         enum thermal_device_mode *mode)
>> +{
>> +     *mode = THERMAL_DEVICE_ENABLED;
>> +     return 0;
>> +}
>> +
>> +static int th_sys_get_trip_type(struct thermal_zone_device *thermal, int trip,
>> +                              enum thermal_trip_type *type)
>> +{
>> +     struct imx6q_thermal_data *p;
>> +
>> +     if (trip >= thermal->trips)
>> +             return -EINVAL;
>> +
>> +     p = ((struct imx6q_thermal_zone *)thermal->devdata)->thermal_data;
>> +
>> +     *type = p->type[trip];
>> +
>> +     return 0;
>> +}
>> +
>> +static int th_sys_get_trip_temp(struct thermal_zone_device *thermal, int trip,
>> +                              unsigned long *temp)
>> +{
>> +     struct imx6q_thermal_data *p;
>> +     enum thermal_trip_type type;
>> +
>> +     if (trip >= thermal->trips)
>> +             return -EINVAL;
>> +
>> +     p = ((struct imx6q_thermal_zone *)thermal->devdata)->thermal_data;
>> +
>> +     thermal->ops->get_trip_type(thermal, trip, &type);
>> +
>> +     if (type == THERMAL_TRIP_CRITICAL)
>> +             *temp = p->crit_temp_level;
>> +     else
>> +             *temp = p->freq_tab[trip].temp_level;
>> +     return 0;
>> +}
>> +
>> +static int th_sys_get_crit_temp(struct thermal_zone_device *thermal,
>> +                              unsigned long *temp)
>> +{
>> +     struct imx6q_thermal_data *p;
>> +
>> +     p = ((struct imx6q_thermal_zone *)thermal->devdata)->thermal_data;
>> +     *temp = p->crit_temp_level;
>> +     return 0;
>> +}
>> +
>> +static int th_sys_bind(struct thermal_zone_device *thermal,
>> +                     struct thermal_cooling_device *cdev)
>> +{
>> +     int i;
>> +     struct thermal_cooling_device *cd;
>> +
>> +     cd = ((struct imx6q_thermal_zone *)thermal->devdata)->cool_dev;
>> +
>> +     /* if the cooling device is the one from imx6 bind it */
>> +     if (cdev != cd)
>> +             return 0;
>> +
>> +     for (i = 0; i < IMX6Q_THERMAL_ACTIVE_TRP_PTS; i++) {
>> +             if (thermal_zone_bind_cooling_device(thermal, i, cdev)) {
>> +                     pr_err("error binding cooling dev\n");
>> +                     return -EINVAL;
>> +             }
>> +     }
>> +
>> +     return 0;
>> +}
>> +
>> +static int th_sys_unbind(struct thermal_zone_device *thermal,
>> +                       struct thermal_cooling_device *cdev)
>> +{
>> +     int i;
>> +
>> +     struct thermal_cooling_device *cd;
>> +
>> +     cd = ((struct imx6q_thermal_zone *)thermal->devdata)->cool_dev;
>> +
>> +     if (cdev != cd)
>> +             return 0;
>> +
>> +     for (i = 0; i < IMX6Q_THERMAL_ACTIVE_TRP_PTS; i++) {
>> +             if (thermal_zone_unbind_cooling_device(thermal, i, cdev)) {
>> +                     pr_err("error unbinding cooling dev\n");
>> +                     return -EINVAL;
>> +             }
>> +     }
>> +
>> +     return 0;
>> +}
>> +
>> +static struct thermal_zone_device_ops g_dev_ops __devinitdata = {
>> +     .bind = th_sys_bind,
>> +     .unbind = th_sys_unbind,
>> +     .get_temp = th_sys_get_temp,
>> +     .get_mode = th_sys_get_mode,
>> +     .get_trip_type = th_sys_get_trip_type,
>> +     .get_trip_temp = th_sys_get_trip_temp,
>> +     .get_crit_temp = th_sys_get_crit_temp,
>> +};
>> +
>> +static int __devinit imx6q_thermal_process_fuse_data(unsigned int fuse_data,
>> +              struct imx6q_sensor_data *sd)
>> +{
>> +     int t1, t2, n1, n2;
>> +
>> +     if (fuse_data == 0 || fuse_data == 0xffffffff) {
>> +             pr_warn("WARNING: Incorrect temperature sensor value of %x "
>> +                     "detected\n", fuse_data);
>> +
>> +#ifdef CONFIG_IMX6Q_THERMAL_FAKE_CALIBRATION
>> +             pr_warn(
>> +                     "WARNING: Using fake calibration value of %x value. "
>> +                     "This will cause your system performance to be limited "
>> +                     "prematurely (compared to a using properly calibrated "
>> +                     "value) OR will cause the system to allow the "
>> +                     "temperature to exceed the maximum specified "
>> +                     "temperature without the proper performance "
>> +                     "limiting.\n", CONFIG_IMX6Q_THERMAL_FAKE_CAL_VAL);
>> +
>> +             fuse_data = CONFIG_IMX6Q_THERMAL_FAKE_CAL_VAL;
>> +#else
>> +             pr_warn("WARNING: Disabling CPU thermal protection\n");
>> +             return -EINVAL;
>> +#endif
>> +     }
>> +
>> +     /*
>> +      * Fuse data layout:
>> +      * [31:20] sensor value @ 25C
>> +      * [19:8] sensor value of hot
>> +      * [7:0] hot temperature value
>> +      */
>> +     n1 = fuse_data >> 20;
>> +     n2 = (fuse_data & 0xfff00) >> 8;
>> +     t2 = fuse_data & 0xff;
>> +     t1 = 25; /* t1 always 25C */
>> +
>> +     pr_debug(" -- temperature sensor calibration data --\n");
>> +     pr_debug("HW_OCOTP_ANA1: %x\n", fuse_data);
>> +     pr_debug("n1: %d\nn2: %d\nt1: %d\nt2: %d\n", n1, n2, t1, t2);
>> +
>> +     /*
>> +      * Derived from linear interpolation,
>> +      * Tmeas = T2 + (Nmeas - N2) * (T1 - T2) / (N1 - N2)
>> +      * We want to reduce this down to the minimum computation necessary
>> +      * for each temperature read.  Also, we want Tmeas in millicelcius
>> +      * and we don't want to lose precision from integer division. So...
>> +      * milli_Tmeas = 1000 * T2 + 1000 * (Nmeas - N2) * (T1 - T2) / (N1 - N2)
>> +      * Let constant c1 = 1000 * (T1 - T2) / (N1 - N2)
>> +      * milli_Tmeas = (1000 * T2) + c1 * (Nmeas - N2)
>> +      * milli_Tmeas = (1000 * T2) + (c1 * Nmeas) - (c1 * N2)
>> +      * Let constant c2 = (1000 * T2) - (c1 * N2)
>> +      * milli_Tmeas = c2 + (c1 * Nmeas)
>> +      */
>> +     sd->c1 = (1000 * (t1 - t2)) / (n1 - n2);
>> +     sd->c2 = (1000 * t2) - (sd->c1 * n2);
>> +
>> +     pr_debug("c1: %i\n", sd->c1);
>> +     pr_debug("c2: %i\n", sd->c2);
>> +
>> +     return 0;
>> +}
>> +
>> +static int anatop_thermal_suspend(struct platform_device *pdev,
>> +                                     pm_message_t state)
>> +{
>> +     struct imx6q_sensor_data *sd = pdev->dev.platform_data;
>> +
>> +     /* power off the sensor during suspend */
>> +     anatop_write_reg(sd->anatopmfd, HW_ANADIG_TEMPSENSE0, 0,
>> +             BM_ANADIG_TEMPSENSE0_MEASURE_TEMP);
>> +
>> +     anatop_write_reg(sd->anatopmfd, HW_ANADIG_TEMPSENSE0,
>> +             BM_ANADIG_TEMPSENSE0_POWER_DOWN,
>> +             BM_ANADIG_TEMPSENSE0_POWER_DOWN);
>> +
>> +     return 0;
>> +}
>> +
>> +static int __devexit anatop_thermal_remove(struct platform_device *pdev)
>> +{
>> +     if (th_zone && th_zone->therm_dev)
>> +             thermal_zone_device_unregister(th_zone->therm_dev);
>> +
>> +     if (th_zone && th_zone->cool_dev)
>> +             cpufreq_cooling_unregister(th_zone->cool_dev);
>> +
>> +     kfree(th_zone->sensor_data);
>> +     kfree(th_zone->thermal_data);
>> +     kfree(th_zone);
>> +
>> +     if (ocotp_base)
>> +             iounmap(ocotp_base);
>> +
>> +     pr_info("i.MX6Q: Kernel Thermal management unregistered\n");
>> +
>> +     return 0;
>> +}
>> +
>> +static int __devinit anatop_thermal_probe(struct platform_device *pdev)
>> +{
>> +     struct device_node *np_ocotp, *np_thermal;
>> +     unsigned int fuse_data;
>> +     struct anatop *anatopmfd = dev_get_drvdata(pdev->dev.parent);
>> +     int ret, i;
>> +
>> +     np_ocotp = of_find_compatible_node(NULL, NULL, "fsl,imx6q-ocotp");
>> +     np_thermal = of_find_compatible_node(NULL, NULL, "fsl,anatop-thermal");
>
> np_thermal = pdev->devI don't quite understand this..of_node;
>

I see, thanks.  In this case I was just using the np_thermal as a
check to be sure we are on the right platform, but it seems that the
platform driver has already done the check for "fsl,anatop-thermal",
so I can remove this line completely and remove the np_thermal check
below.

>> +
>> +     if (!(np_ocotp && np_thermal && anatopmfd))
>> +             return -ENXIO; /* not a compatible platform */
>> +
>> +     ocotp_base = of_iomap(np_ocotp, 0);
>> +
>> +     if (!ocotp_base) {
>> +             pr_err("Could not retrieve ocotp-base\n");
>> +             ret = -ENXIO;
>> +             goto err_unregister;
>> +     }
>> +
>> +     fuse_data = readl_relaxed(ocotp_base + HW_OCOTP_ANA1);
>> +
>> +     th_zone = kzalloc(sizeof(struct imx6q_thermal_zone), GFP_KERNEL);
>
> consider using devm_*
>

Ok, will look at converting to devm_kzalloc and removing the
respective kfree calls in v6.

>> +     if (!th_zone) {
>> +             ret = -ENOMEM;
>> +             goto err_unregister;
>> +     }
>> +
>> +     th_zone->dev_ops = g_dev_ops;
>> +
>> +     th_zone->thermal_data =
>> +             kzalloc(sizeof(struct imx6q_thermal_data), GFP_KERNEL);
>
> Why do you allocate this seperately? You could embed a struct
> imx6q_thermal_data in struct imx6q_thermal_zone.
>

In one implementation I did during development this made more sense,
but now I should embed it as you say.  I'll change this in v6.

>> +
>> +     if (!th_zone->thermal_data) {
>> +             ret = -ENOMEM;
>> +             goto err_unregister;
>> +     }
>> +
>> +     memcpy(th_zone->thermal_data, &g_thermal_data,
>> +                             sizeof(struct imx6q_thermal_data));
>> +
>> +     for (i = 0; i < ARRAY_SIZE(g_thermal_data.freq_tab); i++)
>> +             th_zone->thermal_data->freq_tab[i].mask_val = cpumask_of(0);
>> +
>> +
>> +     th_zone->sensor_data =
>> +             kzalloc(sizeof(struct imx6q_sensor_data), GFP_KERNEL);
>
> This one also could be embedded in struct imx6q_thermal_zone.
>

Same. Will change in v6.

>> +
>> +     if (!th_zone->sensor_data) {
>> +             ret = -ENOMEM;
>> +             goto err_unregister;
>> +     }
>> +
>> +     memcpy(th_zone->sensor_data, &g_sensor_data,
>> +                             sizeof(struct imx6q_sensor_data));
>> +
>> +     th_zone->sensor_data->anatopmfd = anatopmfd;
>> +
>> +     ret = imx6q_thermal_process_fuse_data(fuse_data, th_zone->sensor_data);
>> +
>> +     if (ret) {
>> +             pr_err("Invalid temperature calibration data.\n");
>
> use dev_* functions for logging throughout the driver.
>

Will change in v6.

>> +             goto err_unregister;
>> +     }
>> +
>> +     if (!th_zone->sensor_data->meas_delay)
>> +             th_zone->sensor_data->meas_delay = 1;
>> +
>> +     /* Make sure sensor is in known good state for measurements */
>> +     anatop_write_reg(anatopmfd, HW_ANADIG_TEMPSENSE0, 0,
>> +             BM_ANADIG_TEMPSENSE0_POWER_DOWN);
>> +
>> +     anatop_write_reg(anatopmfd, HW_ANADIG_TEMPSENSE0, 0,
>> +             BM_ANADIG_TEMPSENSE0_MEASURE_TEMP);
>> +
>> +     anatop_write_reg(anatopmfd, HW_ANADIG_TEMPSENSE1, 0,
>> +             BM_ANADIG_TEMPSENSE1_MEASURE_FREQ);
>> +
>> +     anatop_write_reg(anatopmfd, HW_ANADIG_ANA_MISC0_SET,
>> +             BM_ANADIG_ANA_MISC0_REFTOP_SELBIASOFF,
>> +             BM_ANADIG_ANA_MISC0_REFTOP_SELBIASOFF);
>> +
>> +     anatop_write_reg(anatopmfd, HW_ANADIG_TEMPSENSE0,
>> +             BM_ANADIG_TEMPSENSE0_POWER_DOWN,
>> +             BM_ANADIG_TEMPSENSE0_POWER_DOWN);
>> +
>> +     th_zone->cool_dev = cpufreq_cooling_register(
>> +             (struct freq_clip_table *)th_zone->thermal_data->freq_tab,
>> +             IMX6Q_THERMAL_ACTIVE_TRP_PTS);
>> +
>> +     if (IS_ERR(th_zone->cool_dev)) {
>> +             pr_err("Failed to register cpufreq cooling device\n");
>> +             ret = -EINVAL;
>> +             goto err_unregister;
>> +     }
>> +
>> +     th_zone->therm_dev = thermal_zone_device_register(
>> +             th_zone->sensor_data->name, IMX6Q_THERMAL_TOTAL_TRP_PTS,
>> +             th_zone, &th_zone->dev_ops, 0, 0, 0,
>> +             IMX6Q_THERMAL_POLLING_FREQUENCY_MS);
>> +
>> +     if (IS_ERR(th_zone->therm_dev)) {
>> +             pr_err("Failed to register thermal zone device\n");
>> +             ret = -EINVAL;
>> +             goto err_unregister;
>> +     }
>> +
>> +     pdev->dev.platform_data = th_zone->sensor_data;
>
> platform_data is for passing information from the one who registers the
> platform_device to the driver. What you have to use here is
> platform_set_drvdata(). Also you have to initialize this before
> registering the thermal zone, not afterwards.
>

Will fix this in v6.

>> +
>> +     return 0;
>> +
>> +err_unregister:
>> +     anatop_thermal_remove(pdev);
>> +     return ret;
>> +}
>> +
>> +static struct of_device_id __devinitdata of_anatop_thermal_match_tbl[] = {
>> +     { .compatible = "fsl,anatop-thermal", },
>> +     { /* end */ }
>> +};
>> +
>> +static struct platform_driver anatop_thermal = {
>> +     .driver = {
>> +             .name   = "anatop_thermal",
>> +             .owner  = THIS_MODULE,
>> +             .of_match_table = of_anatop_thermal_match_tbl,
>> +     },
>> +     .probe  = anatop_thermal_probe,
>> +     .remove = anatop_thermal_remove,
>> +     .suspend = anatop_thermal_suspend,
>> +     /* due to implentation of imx6q_get_temp , resume is unnecessary */
>> +};
>> +
>> +static int __devinit anatop_thermal_init(void)
>> +{
>> +     return platform_driver_register(&anatop_thermal);
>> +}
>> +device_initcall(anatop_thermal_init);
>> +
>> +static void __exit anatop_thermal_exit(void)
>> +{
>> +     platform_driver_unregister(&anatop_thermal);
>> +}
>> +module_exit(anatop_thermal_exit);
>
> use module_platform_driver
>

Will fix this in v6.

Thanks,
Rob

>> +
>> +MODULE_AUTHOR("Freescale Semiconductor");
>> +MODULE_DESCRIPTION("i.MX6Q SoC thermal driver");
>> +MODULE_LICENSE("GPL");
>> +MODULE_ALIAS("platform:imx6q-thermal");
>> --
>> 1.7.10
>>
>>
>
> --
> Pengutronix e.K.                           |                             |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
