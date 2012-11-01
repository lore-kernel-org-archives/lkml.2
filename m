Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798Ab2KAH4v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 03:56:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:31482 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753276Ab2KAH4t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 03:56:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,691,1344236400"; 
   d="scan'208";a="235595091"
From: "R, Durgadoss" <durgadoss.r@intel.com>
To: Jonghwa Lee <jonghwa3.lee@samsung.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Brown, Len" <len.brown@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Amit Dinel Kachhap <amit.kachhap@linaro.org>
Subject: RE: [PATCH v3] Thermal: exynos: Add sysfs node supporting exynos's
 emulation mode.
Thread-Topic: [PATCH v3] Thermal: exynos: Add sysfs node supporting exynos's
 emulation mode.
Thread-Index: AQHNt03VJyKSWV78Bkm87IC1qOUUgZfUnN0A
Date: Thu, 1 Nov 2012 07:56:39 +0000
Message-ID: <4D68720C2E767A4AA6A8796D42C8EB591FF32C@BGSMSX101.gar.corp.intel.com>
References: <1351677237-18240-1-git-send-email-jonghwa3.lee@samsung.com>
In-Reply-To: <1351677237-18240-1-git-send-email-jonghwa3.lee@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> +++ b/Documentation/thermal/exynos_thermal_emulation
> @@ -0,0 +1,49 @@
> +EXYNOS EMULATION MODE
> +========================
> +
> +Copyright (C) 2012 Samsung Electronics
> +
> +Writen by Jonghwa Lee <jonghwa3.lee@samsung.com>

s/Writen/Written

> +
> +Description
> +-----------
> +
> +Exynos 4x12 (4212, 4412) and 5 series provide emulation mode for thermal
> management unit.
> +Thermal emulation mode supports software debug for TMU's operation.
> User can set temperature
> +manually with software code and TMU will read current temperature from
> user value not from
> +sensor's value.
> +
> +Enabling CONFIG_EXYNOS_THERMAL_EMUL option will make this support
> in available.
> +When it's enabled, sysfs node will be created under
> +/sys/bus/platform/devices/'exynos device name'/ with name of
> 'emulation'.
> +
> +The sysfs node, 'emulation', will contain value 0 for the initial state. When
> you input any
> +temperature you want to update to sysfs node, it automatically enable
> emulation mode and
> +current temperature will be changed into it.
> +(Exynos also supports user changable delay time which would be used to
> delay of
> + changing temperature. However, this node only uses same delay of real
> sensing time, 938us.)
> +
> +Disabling emulation mode only requires writing value 0 to sysfs node.

This documentation looks fine. As a reply to one of the comments in the
previous version, you gave me an explanation. Could you please add that
explanation here as well ? I think that would help all of us, after this
patch set gets merged..

> +
> +
> +TEMP	120 |
> +	    |
> +	100 |
> +	    |
> +	 80 |
> +	    |		     	 	 +-----------
> +	 60 |      		     	 |	    |
> +	    |	           +-------------|          |
> +	 40 |              |         	 |          |
> +   	    |		   |	     	 |          |
> +	 20 |		   |	     	 |          +----------
> +	    |	 	   |	     	 |          |          |
> +  	  0
> |______________|_____________|__________|__________|_______
> __
> +		   A	    	 A	    A	   	       A     TIME
> +		   |<----->|	 |<----->|  |<----->|	       |
> +		   | 938us |  	 |	 |  |       |          |
> +emulation    :  0 50	   |  	 70      |  20      |          0
> +current temp :   sensor   50		 70         20	      sensor
> +
> +
> +
> diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
> index e1cb6bd..c02a66c 100644
> --- a/drivers/thermal/Kconfig
> +++ b/drivers/thermal/Kconfig
> @@ -55,3 +55,12 @@ config EXYNOS_THERMAL
>  	help
>  	  If you say yes here you get support for TMU (Thermal Managment
>  	  Unit) on SAMSUNG EXYNOS series of SoC.
> +
> +config EXYNOS_THERMAL_EMUL
> +	bool "EXYNOS TMU emulation mode support"
> +	depends on !CPU_EXYNOS4210 && EXYNOS_THERMAL
> +	help
> +	  Exynos 4412 and 4414 and 5 series has emulation mode on TMU.
> +	  Enable this option will be make sysfs node in exynos thermal
> platform
> +	  device directory to support emulation mode. With emulation mode
> sysfs
> +	  node, you can manually input temperature to TMU for simulation
> purpose.
> diff --git a/drivers/thermal/exynos_thermal.c
> b/drivers/thermal/exynos_thermal.c
> index fd03e85..4bdd1eb 100644
> --- a/drivers/thermal/exynos_thermal.c
> +++ b/drivers/thermal/exynos_thermal.c
> @@ -99,6 +99,14 @@
>  #define IDLE_INTERVAL 10000
>  #define MCELSIUS	1000
> 
> +#ifdef CONFIG_EXYNOS_THERMAL_EMUL
> +#define EXYNOS_EMUL_TIME	0x57F0
> +#define EXYNOS_EMUL_TIME_SHIFT	16
> +#define EXYNOS_EMUL_DATA_SHIFT	8
> +#define EXYNOS_EMUL_DATA_MASK	0xFF
> +#define EXYNOS_EMUL_ENABLE	0x1
> +#endif /* CONFIG_EXYNOS_THERMAL_EMUL */
> +
>  /* CPU Zone information */
>  #define PANIC_ZONE      4
>  #define WARN_ZONE       3
> @@ -832,6 +840,84 @@ static inline struct  exynos_tmu_platform_data
> *exynos_get_driver_data(
>  	return (struct exynos_tmu_platform_data *)
>  			platform_get_device_id(pdev)->driver_data;
>  }
> +
> +#ifdef CONFIG_EXYNOS_THERMAL_EMUL
> +static ssize_t exynos_tmu_emulation_show(struct device *dev,
> +					 struct device_attribute *attr,
> +					 char *buf)
> +{
> +	struct platform_device *pdev = container_of(dev,
> +					struct platform_device, dev);
> +	struct exynos_tmu_data *data = platform_get_drvdata(pdev);
> +	unsigned int reg;
> +	u8 temp_code;
> +	int temp = 0;
> +
> +	mutex_lock(&data->lock);
> +	clk_enable(data->clk);
> +	reg = readl(data->base + EXYNOS_EMUL_CON);
> +	clk_disable(data->clk);
> +	mutex_unlock(&data->lock);
> +
> +	if (reg & EXYNOS_EMUL_ENABLE) {
> +		reg >>= EXYNOS_EMUL_DATA_SHIFT;
> +		temp_code = reg & EXYNOS_EMUL_DATA_MASK;
> +		temp = code_to_temp(data, temp_code);
> +	} else {
> +		temp = 0;
> +	}

Do we still need the else part ?

> +
> +	return sprintf(buf, "%d\n", temp);
> +}
> +
> +static ssize_t exynos_tmu_emulation_store(struct device *dev,
> +					struct device_attribute *attr,
> +					const char *buf, size_t count)
> +{
> +	struct platform_device *pdev = container_of(dev,
> +					struct platform_device, dev);
> +	struct exynos_tmu_data *data = platform_get_drvdata(pdev);
> +	unsigned int reg;
> +	int temp = 0;

Looks like we don't need to assign 0 to temp here..

> +
> +	if (!sscanf(buf, "%d\n", &temp) || temp < 0)
> +		return -EINVAL;
> +
> +	mutex_lock(&data->lock);
> +	clk_enable(data->clk);
> +
> +	reg = readl(data->base + EXYNOS_EMUL_CON);
> +
> +	if (temp)
> +		reg = (EXYNOS_EMUL_TIME << EXYNOS_EMUL_TIME_SHIFT)
> |
> +			(temp_to_code(data, temp) <<
> EXYNOS_EMUL_DATA_SHIFT) |
> +			EXYNOS_EMUL_ENABLE;
> +	else
> +		reg &= ~EXYNOS_EMUL_ENABLE;
> +
> +	writel(reg, data->base + EXYNOS_EMUL_CON);
> +
> +	clk_disable(data->clk);
> +	mutex_unlock(&data->lock);
> +
> +	return count;
> +}
> +
> +static DEVICE_ATTR(emulation, 0644, exynos_tmu_emulation_show,
> +					exynos_tmu_emulation_store);
> +static int create_emulation_sysfs(struct device *dev)
> +{
> +	return device_create_file(dev, &dev_attr_emulation);
> +}
> +static void remove_emulation_sysfs(struct device *dev)
> +{
> +	device_remove_file(dev, &dev_attr_emulation);
> +}
> +#else
> +static inline int create_emulation_sysfs(struct device *dev) {return 0;}
> +static inline void remove_emulation_sysfs(struct device *dev){}
> +#endif
> +
>  static int __devinit exynos_tmu_probe(struct platform_device *pdev)
>  {
>  	struct exynos_tmu_data *data;
> @@ -930,6 +1016,11 @@ static int __devinit exynos_tmu_probe(struct
> platform_device *pdev)
>  		dev_err(&pdev->dev, "Failed to register thermal
> interface\n");
>  		goto err_clk;
>  	}
> +
> +	ret = create_emulation_sysfs(&pdev->dev);
> +	if (ret)
> +		dev_err(&pdev->dev, "Faield to create emulation mode

s/Faield/Failed

> sysfs node\n");
> +
>  	return 0;
>  err_clk:
>  	platform_set_drvdata(pdev, NULL);
> @@ -941,6 +1032,8 @@ static int __devexit exynos_tmu_remove(struct
> platform_device *pdev)
>  {
>  	struct exynos_tmu_data *data = platform_get_drvdata(pdev);
> 
> +	remove_emulation_sysfs(&pdev->dev);
> +

Yes, this makes it cleaner.

>  	exynos_tmu_control(pdev, false);
> 
>  	exynos_unregister_thermal();
> --
> 1.7.4.1

