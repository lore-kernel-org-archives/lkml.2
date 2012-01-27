Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204Ab2A0Q25 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 11:28:57 -0500
Received: from mga09.intel.com ([134.134.136.24]:44682 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751534Ab2A0Q2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 11:28:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="103409420"
From: "R, Durgadoss" <durgadoss.r@intel.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, "mjg@redhat.com" <mjg@redhat.com>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 4/5] platform-x86: intel_mid_thermal: convert to use
 Intel MSIC API
Thread-Topic: [PATCH 4/5] platform-x86: intel_mid_thermal: convert to use
 Intel MSIC API
Thread-Index: AQHM3FC0RIVXuNz8okWjqr7E+oL63pYgaLwg
Date: Fri, 27 Jan 2012 16:28:50 +0000
Message-ID: <4D68720C2E767A4AA6A8796D42C8EB5902FDCA@BGSMSX101.gar.corp.intel.com>
References: <20120126173729.16719.15431.stgit@bob.linux.org.uk>
 <20120126173927.16719.25711.stgit@bob.linux.org.uk>
In-Reply-To: <20120126173927.16719.25711.stgit@bob.linux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q0RGT1ZQ020486



> -----Original Message-----
> From: platform-driver-x86-owner@vger.kernel.org [mailto:platform-driver-x86-
> owner@vger.kernel.org] On Behalf Of Alan Cox
> Sent: Thursday, January 26, 2012 11:10 PM
> To: mjg@redhat.com; platform-driver-x86@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: [PATCH 4/5] platform-x86: intel_mid_thermal: convert to use Intel MSIC
> API
> 
> From: Mika Westerberg <mika.westerberg@linux.intel.com>
> 
> Intel MSIC MFD driver provides common register access interface to the
> devices in the MSIC die so we use that instead of SCU IPC.
> 

Acked-by: Durgadoss R <durgadoss.r@intel.com>

Thanks,
Durga

> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> ---
> 
>  drivers/platform/x86/Kconfig             |    2 +-
>  drivers/platform/x86/intel_mid_thermal.c |   39 ++++++++++++++----------------
>  2 files changed, 19 insertions(+), 22 deletions(-)
> 
> 
> diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
> index 5715e4d..86720bc 100644
> --- a/drivers/platform/x86/Kconfig
> +++ b/drivers/platform/x86/Kconfig
> @@ -672,7 +672,7 @@ config INTEL_MID_POWER_BUTTON
> 
>  config INTEL_MFLD_THERMAL
>         tristate "Thermal driver for Intel Medfield platform"
> -       depends on INTEL_SCU_IPC && THERMAL
> +       depends on MFD_INTEL_MSIC && THERMAL
>         help
>           Say Y here to enable thermal driver support for the  Intel Medfield
>           platform.
> diff --git a/drivers/platform/x86/intel_mid_thermal.c
> b/drivers/platform/x86/intel_mid_thermal.c
> index de2e62e..aef4979 100644
> --- a/drivers/platform/x86/intel_mid_thermal.c
> +++ b/drivers/platform/x86/intel_mid_thermal.c
> @@ -33,18 +33,15 @@
>  #include <linux/slab.h>
>  #include <linux/pm.h>
>  #include <linux/thermal.h>
> -
> -#include <asm/intel_scu_ipc.h>
> +#include <linux/mfd/intel_msic.h>
> 
>  /* Number of thermal sensors */
>  #define MSIC_THERMAL_SENSORS	4
> 
>  /* ADC1 - thermal registers */
> -#define MSIC_THERM_ADC1CNTL1	0x1C0
>  #define MSIC_ADC_ENBL		0x10
>  #define MSIC_ADC_START		0x08
> 
> -#define MSIC_THERM_ADC1CNTL3	0x1C2
>  #define MSIC_ADCTHERM_ENBL	0x04
>  #define MSIC_ADCRRDATA_ENBL	0x05
>  #define MSIC_CHANL_MASK_VAL	0x0F
> @@ -75,8 +72,8 @@
>  #define ADC_VAL60C		315
> 
>  /* ADC base addresses */
> -#define ADC_CHNL_START_ADDR	0x1C5	/* increments by 1 */
> -#define ADC_DATA_START_ADDR	0x1D4	/* increments by 2 */
> +#define ADC_CHNL_START_ADDR	INTEL_MSIC_ADC1ADDR0	/* increments by 1 */
> +#define ADC_DATA_START_ADDR	INTEL_MSIC_ADC1SNS0H	/* increments by 2 */
> 
>  /* MSIC die attributes */
>  #define MSIC_DIE_ADC_MIN	488
> @@ -189,17 +186,17 @@ static int mid_read_temp(struct thermal_zone_device *tzd,
> unsigned long *temp)
>  	addr = td_info->chnl_addr;
> 
>  	/* Enable the msic for conversion before reading */
> -	ret = intel_scu_ipc_iowrite8(MSIC_THERM_ADC1CNTL3, MSIC_ADCRRDATA_ENBL);
> +	ret = intel_msic_reg_write(INTEL_MSIC_ADC1CNTL3, MSIC_ADCRRDATA_ENBL);
>  	if (ret)
>  		return ret;
> 
>  	/* Re-toggle the RRDATARD bit (temporary workaround) */
> -	ret = intel_scu_ipc_iowrite8(MSIC_THERM_ADC1CNTL3, MSIC_ADCTHERM_ENBL);
> +	ret = intel_msic_reg_write(INTEL_MSIC_ADC1CNTL3, MSIC_ADCTHERM_ENBL);
>  	if (ret)
>  		return ret;
> 
>  	/* Read the higher bits of data */
> -	ret = intel_scu_ipc_ioread8(addr, &data);
> +	ret = intel_msic_reg_read(addr, &data);
>  	if (ret)
>  		return ret;
> 
> @@ -207,7 +204,7 @@ static int mid_read_temp(struct thermal_zone_device *tzd,
> unsigned long *temp)
>  	adc_val = (data << 2);
>  	addr++;
> 
> -	ret = intel_scu_ipc_ioread8(addr, &data);/* Read lower bits */
> +	ret = intel_msic_reg_read(addr, &data);/* Read lower bits */
>  	if (ret)
>  		return ret;
> 
> @@ -235,7 +232,7 @@ static int configure_adc(int val)
>  	int ret;
>  	uint8_t data;
> 
> -	ret = intel_scu_ipc_ioread8(MSIC_THERM_ADC1CNTL1, &data);
> +	ret = intel_msic_reg_read(INTEL_MSIC_ADC1CNTL1, &data);
>  	if (ret)
>  		return ret;
> 
> @@ -246,7 +243,7 @@ static int configure_adc(int val)
>  		/* Just stop the ADC */
>  		data &= (~MSIC_ADC_START);
>  	}
> -	return intel_scu_ipc_iowrite8(MSIC_THERM_ADC1CNTL1, data);
> +	return intel_msic_reg_write(INTEL_MSIC_ADC1CNTL1, data);
>  }
> 
>  /**
> @@ -262,21 +259,21 @@ static int set_up_therm_channel(u16 base_addr)
>  	int ret;
> 
>  	/* Enable all the sensor channels */
> -	ret = intel_scu_ipc_iowrite8(base_addr, SKIN_SENSOR0_CODE);
> +	ret = intel_msic_reg_write(base_addr, SKIN_SENSOR0_CODE);
>  	if (ret)
>  		return ret;
> 
> -	ret = intel_scu_ipc_iowrite8(base_addr + 1, SKIN_SENSOR1_CODE);
> +	ret = intel_msic_reg_write(base_addr + 1, SKIN_SENSOR1_CODE);
>  	if (ret)
>  		return ret;
> 
> -	ret = intel_scu_ipc_iowrite8(base_addr + 2, SYS_SENSOR_CODE);
> +	ret = intel_msic_reg_write(base_addr + 2, SYS_SENSOR_CODE);
>  	if (ret)
>  		return ret;
> 
>  	/* Since this is the last channel, set the stop bit
>  	 * to 1 by ORing the DIE_SENSOR_CODE with 0x10 */
> -	ret = intel_scu_ipc_iowrite8(base_addr + 3,
> +	ret = intel_msic_reg_write(base_addr + 3,
>  			(MSIC_DIE_SENSOR_CODE | 0x10));
>  	if (ret)
>  		return ret;
> @@ -295,11 +292,11 @@ static int reset_stopbit(uint16_t addr)
>  {
>  	int ret;
>  	uint8_t data;
> -	ret = intel_scu_ipc_ioread8(addr, &data);
> +	ret = intel_msic_reg_read(addr, &data);
>  	if (ret)
>  		return ret;
>  	/* Set the stop bit to zero */
> -	return intel_scu_ipc_iowrite8(addr, (data & 0xEF));
> +	return intel_msic_reg_write(addr, (data & 0xEF));
>  }
> 
>  /**
> @@ -322,7 +319,7 @@ static int find_free_channel(void)
>  	uint8_t data;
> 
>  	/* check whether ADC is enabled */
> -	ret = intel_scu_ipc_ioread8(MSIC_THERM_ADC1CNTL1, &data);
> +	ret = intel_msic_reg_read(INTEL_MSIC_ADC1CNTL1, &data);
>  	if (ret)
>  		return ret;
> 
> @@ -331,7 +328,7 @@ static int find_free_channel(void)
> 
>  	/* ADC is already enabled; Looking for an empty channel */
>  	for (i = 0; i < ADC_CHANLS_MAX; i++) {
> -		ret = intel_scu_ipc_ioread8(ADC_CHNL_START_ADDR + i, &data);
> +		ret = intel_msic_reg_read(ADC_CHNL_START_ADDR + i, &data);
>  		if (ret)
>  			return ret;
> 
> @@ -359,7 +356,7 @@ static int mid_initialize_adc(struct device *dev)
>  	 * Ensure that adctherm is disabled before we
>  	 * initialize the ADC
>  	 */
> -	ret = intel_scu_ipc_ioread8(MSIC_THERM_ADC1CNTL3, &data);
> +	ret = intel_msic_reg_read(INTEL_MSIC_ADC1CNTL3, &data);
>  	if (ret)
>  		return ret;
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe platform-driver-x86"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
