Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053Ab2KHJY0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 04:24:26 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:35784 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188Ab2KHJYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 04:24:23 -0500
MIME-Version: 1.0
In-Reply-To: <1351823091-2540-1-git-send-email-jonghwa3.lee@samsung.com>
References: <1351823091-2540-1-git-send-email-jonghwa3.lee@samsung.com>
Date: Thu, 8 Nov 2012 14:54:22 +0530
Message-ID: <CAK44p22c_KjyGdKqrXmXNgzTPws_rR8mr-SWqJVzVgEaTbZwYg@mail.gmail.com>
Subject: Re: [PATCH v4] Thermal: exynos: Add sysfs node supporting exynos's
 emulation mode.
From: Amit Kachhap <amit.kachhap@linaro.org>
To: Jonghwa Lee <jonghwa3.lee@samsung.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Len Brown <len.brown@intel.com>, Durgadoss R <durgadoss.r@intel.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Zhang Rui <rui.zhang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jonghwa Lee,

I tested this patch and it looks good. I have some minor comments below,

Reviewed-by: Amit Daniel Kachhap <amit.kachhap@linaro.org>

Thanks,
Amit Daniel
On 2 November 2012 07:54, Jonghwa Lee <jonghwa3.lee@samsung.com> wrote:
> This patch supports exynos's emulation mode with newly created sysfs node.
> Exynos 4x12 (4212, 4412) and 5 series provide emulation mode for thermal
> management unit. Thermal emulation mode supports software debug for TMU's
> operation. User can set temperature manually with software code and TMU
> will read current temperature from user value not from sensor's value.
> This patch includes also documentary placed under Documentation/thermal/.
>
> Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
> ---
> v4
>  - Fix Typo.
>  - Remove unnecessary codes.
>  - Add comments about feature of exynos emulation operation to the document.
>
> v3
>  - Remove unnecessay variables.
>  - Do some code clean in exynos_tmu_emulation_store().
>  - Make wrapping function of sysfs node creation function to use
>    #ifdefs in minimum.
>
> v2
>  exynos_thermal.c
>  - Fix build error occured by wrong emulation control register name.
>  - Remove exynos5410 dependent codes.
>  exynos_thermal_emulation
>  - Align indentation.
>
>  Documentation/thermal/exynos_thermal_emulation |   56 +++++++++++++++
>  drivers/thermal/Kconfig                        |    9 +++
>  drivers/thermal/exynos_thermal.c               |   91 ++++++++++++++++++++++++
>  3 files changed, 156 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/thermal/exynos_thermal_emulation
>
> diff --git a/Documentation/thermal/exynos_thermal_emulation b/Documentation/thermal/exynos_thermal_emulation
> new file mode 100644
> index 0000000..a6ea06f
> --- /dev/null
> +++ b/Documentation/thermal/exynos_thermal_emulation
> @@ -0,0 +1,56 @@
> +EXYNOS EMULATION MODE
> +========================
> +
> +Copyright (C) 2012 Samsung Electronics
> +
> +Written by Jonghwa Lee <jonghwa3.lee@samsung.com>
> +
> +Description
> +-----------
> +
> +Exynos 4x12 (4212, 4412) and 5 series provide emulation mode for thermal management unit.
> +Thermal emulation mode supports software debug for TMU's operation. User can set temperature
> +manually with software code and TMU will read current temperature from user value not from
> +sensor's value.
> +
> +Enabling CONFIG_EXYNOS_THERMAL_EMUL option will make this support in available.
> +When it's enabled, sysfs node will be created under
> +/sys/bus/platform/devices/'exynos device name'/ with name of 'emulation'.
> +
> +The sysfs node, 'emulation', will contain value 0 for the initial state. When you input any
> +temperature you want to update to sysfs node, it automatically enable emulation mode and
> +current temperature will be changed into it.
> +(Exynos also supports user changable delay time which would be used to delay of
> + changing temperature. However, this node only uses same delay of real sensing time, 938us.)
> +
> +Exynos emulation mode requires synchronous of value changing and enabling. It means when you
> +want to update the any value of delay or next temperature, then you have to enable emulation
> +mode at the same time. (Or you have to keep the mode enabling.) If you don't, it fails to
> +change the value to updated one and just use last succeessful value repeatedly. That's why
> +this node gives users the right to change termerpature only. Just one interface makes it more
> +simply to use.
> +
> +Disabling emulation mode only requires writing value 0 to sysfs node.
> +
> +
> +TEMP   120 |
> +           |
> +       100 |
> +           |
> +        80 |
> +           |                            +-----------
> +        60 |                            |          |
> +           |              +-------------|          |
> +        40 |              |             |          |
> +           |              |             |          |
> +        20 |              |             |          +----------
> +           |              |             |          |          |
> +         0 |______________|_____________|__________|__________|_________
> +                  A             A          A                  A     TIME
> +                  |<----->|     |<----->|  |<----->|          |
> +                  | 938us |     |       |  |       |          |
> +emulation    :  0  50     |     70      |  20      |          0
> +current temp :   sensor   50            70         20        sensor
> +
> +
> +
> diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
> index e1cb6bd..c02a66c 100644
> --- a/drivers/thermal/Kconfig
> +++ b/drivers/thermal/Kconfig
> @@ -55,3 +55,12 @@ config EXYNOS_THERMAL
>         help
>           If you say yes here you get support for TMU (Thermal Managment
>           Unit) on SAMSUNG EXYNOS series of SoC.
> +
> +config EXYNOS_THERMAL_EMUL
> +       bool "EXYNOS TMU emulation mode support"
> +       depends on !CPU_EXYNOS4210 && EXYNOS_THERMAL
Instead of using CPU_EXYNOS4210 here it is better to use data->soc ==
SOC_ARCH_EXYNOS4210 inside the emulation show/store functions.
> +       help
> +         Exynos 4412 and 4414 and 5 series has emulation mode on TMU.
> +         Enable this option will be make sysfs node in exynos thermal platform
> +         device directory to support emulation mode. With emulation mode sysfs
> +         node, you can manually input temperature to TMU for simulation purpose.
> diff --git a/drivers/thermal/exynos_thermal.c b/drivers/thermal/exynos_thermal.c
> index fd03e85..eebd4e5 100644
> --- a/drivers/thermal/exynos_thermal.c
> +++ b/drivers/thermal/exynos_thermal.c
> @@ -99,6 +99,14 @@
>  #define IDLE_INTERVAL 10000
>  #define MCELSIUS       1000
>
> +#ifdef CONFIG_EXYNOS_THERMAL_EMUL
> +#define EXYNOS_EMUL_TIME       0x57F0
> +#define EXYNOS_EMUL_TIME_SHIFT 16
> +#define EXYNOS_EMUL_DATA_SHIFT 8
> +#define EXYNOS_EMUL_DATA_MASK  0xFF
> +#define EXYNOS_EMUL_ENABLE     0x1
> +#endif /* CONFIG_EXYNOS_THERMAL_EMUL */
> +
>  /* CPU Zone information */
>  #define PANIC_ZONE      4
>  #define WARN_ZONE       3
> @@ -832,6 +840,82 @@ static inline struct  exynos_tmu_platform_data *exynos_get_driver_data(
>         return (struct exynos_tmu_platform_data *)
>                         platform_get_device_id(pdev)->driver_data;
>  }
> +
> +#ifdef CONFIG_EXYNOS_THERMAL_EMUL
> +static ssize_t exynos_tmu_emulation_show(struct device *dev,
> +                                        struct device_attribute *attr,
> +                                        char *buf)
> +{
> +       struct platform_device *pdev = container_of(dev,
> +                                       struct platform_device, dev);
> +       struct exynos_tmu_data *data = platform_get_drvdata(pdev);
> +       unsigned int reg;
> +       u8 temp_code;
> +       int temp = 0;
> +
> +       mutex_lock(&data->lock);
> +       clk_enable(data->clk);
> +       reg = readl(data->base + EXYNOS_EMUL_CON);
> +       clk_disable(data->clk);
> +       mutex_unlock(&data->lock);
> +
> +       if (reg & EXYNOS_EMUL_ENABLE) {
> +               reg >>= EXYNOS_EMUL_DATA_SHIFT;
> +               temp_code = reg & EXYNOS_EMUL_DATA_MASK;
> +               temp = code_to_temp(data, temp_code);
> +       }
> +
> +       return sprintf(buf, "%d\n", temp);
Currently in  /sys/devices/virtual/thermal/thermal_zone0/ all
temperatures are shown in millicelsius so it is better show this in
millicelsius also.
> +}
> +
> +static ssize_t exynos_tmu_emulation_store(struct device *dev,
> +                                       struct device_attribute *attr,
> +                                       const char *buf, size_t count)
> +{
> +       struct platform_device *pdev = container_of(dev,
> +                                       struct platform_device, dev);
> +       struct exynos_tmu_data *data = platform_get_drvdata(pdev);
> +       unsigned int reg;
> +       int temp;
> +
> +       if (!sscanf(buf, "%d\n", &temp) || temp < 0)
> +               return -EINVAL;
> +
> +       mutex_lock(&data->lock);
> +       clk_enable(data->clk);
> +
> +       reg = readl(data->base + EXYNOS_EMUL_CON);
> +
> +       if (temp)
> +               reg = (EXYNOS_EMUL_TIME << EXYNOS_EMUL_TIME_SHIFT) |
> +                       (temp_to_code(data, temp) << EXYNOS_EMUL_DATA_SHIFT) |
Same as above.
> +                       EXYNOS_EMUL_ENABLE;
> +       else
> +               reg &= ~EXYNOS_EMUL_ENABLE;
> +
> +       writel(reg, data->base + EXYNOS_EMUL_CON);
> +
> +       clk_disable(data->clk);
> +       mutex_unlock(&data->lock);
> +
> +       return count;
> +}
> +
> +static DEVICE_ATTR(emulation, 0644, exynos_tmu_emulation_show,
> +                                       exynos_tmu_emulation_store);
> +static int create_emulation_sysfs(struct device *dev)
> +{
> +       return device_create_file(dev, &dev_attr_emulation);
> +}
> +static void remove_emulation_sysfs(struct device *dev)
> +{
> +       device_remove_file(dev, &dev_attr_emulation);
> +}
> +#else
> +static inline int create_emulation_sysfs(struct device *dev) {return 0;}
> +static inline void remove_emulation_sysfs(struct device *dev){}
> +#endif
> +
>  static int __devinit exynos_tmu_probe(struct platform_device *pdev)
>  {
>         struct exynos_tmu_data *data;
> @@ -930,6 +1014,11 @@ static int __devinit exynos_tmu_probe(struct platform_device *pdev)
>                 dev_err(&pdev->dev, "Failed to register thermal interface\n");
>                 goto err_clk;
>         }
> +
> +       ret = create_emulation_sysfs(&pdev->dev);
> +       if (ret)
> +               dev_err(&pdev->dev, "Failed to create emulation mode sysfs node\n");
> +
>         return 0;
>  err_clk:
>         platform_set_drvdata(pdev, NULL);
> @@ -941,6 +1030,8 @@ static int __devexit exynos_tmu_remove(struct platform_device *pdev)
>  {
>         struct exynos_tmu_data *data = platform_get_drvdata(pdev);
>
> +       remove_emulation_sysfs(&pdev->dev);
> +
>         exynos_tmu_control(pdev, false);
>
>         exynos_unregister_thermal();
> --
> 1.7.4.1
>
