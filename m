Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617Ab2BWFjn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 00:39:43 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:44648 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666Ab2BWFjl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 00:39:41 -0500
From: "Manjunathappa, Prakash" <prakash.pm@ti.com>
To: "Manjunathappa, Prakash" <prakash.pm@ti.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Nori, Sekhar" <nsekhar@ti.com>, Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: RE: [PATCH v4 2/3] arm:davinci: move emif driver to drivers/mfd
 from mach-davinci folder
Thread-Topic: [PATCH v4 2/3] arm:davinci: move emif driver to drivers/mfd
 from mach-davinci folder
Thread-Index: AQHM5wFGKpFBqAjVOUWX8ihjnrE7QJZKDCsA
Date: Thu, 23 Feb 2012 05:39:11 +0000
Message-ID: <A73F36158E33644199EB82C5EC81C7BC3176A846@DBDE01.ent.ti.com>
References: <1328771908-32527-1-git-send-email-prakash.pm@ti.com>
 <1328771908-32527-3-git-send-email-prakash.pm@ti.com>
In-Reply-To: <1328771908-32527-3-git-send-email-prakash.pm@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Feb 09, 2012 at 12:48:27, Manjunathappa, Prakash wrote:
> Move aemif kernel module from arch/arm/mach-davinci/ to multi functional
> devices frame work. "davinci_aemif" MFD driver adds "davinci_nand" and
> "physmap-flash" slave devices.
> 
> Signed-off-by: Manjunathappa, Prakash <prakash.pm@ti.com>
> ---
> Since v3:
> No change. Resending as 3/3 in patch changed.
> Since v2:
> Modified emif MFD driver to load multiple instance of NAND/NOR devices.
> Since v1:
> Patch generated using -M option.
> 
>  arch/arm/Kconfig                                   |    1 +
>  arch/arm/mach-davinci/Makefile                     |    2 +-
>  drivers/mfd/Makefile                               |    1 +
>  .../aemif.c => drivers/mfd/davinci_aemif.c         |   75 +++++++++++++++++++-
>  include/linux/mfd/davinci_aemif.h                  |   14 ++++
>  5 files changed, 91 insertions(+), 2 deletions(-)
>  rename arch/arm/mach-davinci/aemif.c => drivers/mfd/davinci_aemif.c (66%)
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index a48aecc..09dcb94 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -934,6 +934,7 @@ config ARCH_DAVINCI
>  	select GENERIC_ALLOCATOR
>  	select GENERIC_IRQ_CHIP
>  	select ARCH_HAS_HOLES_MEMORYMODEL
> +	select MFD_CORE
>  	help
>  	  Support for TI's DaVinci platform.
>  
> diff --git a/arch/arm/mach-davinci/Makefile b/arch/arm/mach-davinci/Makefile
> index 2db78bd..8bab47c 100644
> --- a/arch/arm/mach-davinci/Makefile
> +++ b/arch/arm/mach-davinci/Makefile
> @@ -5,7 +5,7 @@
>  
>  # Common objects
>  obj-y 			:= time.o clock.o serial.o psc.o \
> -			   dma.o usb.o common.o sram.o aemif.o
> +			   dma.o usb.o common.o sram.o
>  
>  obj-$(CONFIG_DAVINCI_MUX)		+= mux.o
>  
> diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
> index b953bab..54fc267 100644
> --- a/drivers/mfd/Makefile
> +++ b/drivers/mfd/Makefile
> @@ -11,6 +11,7 @@ obj-$(CONFIG_HTC_EGPIO)		+= htc-egpio.o
>  obj-$(CONFIG_HTC_PASIC3)	+= htc-pasic3.o
>  obj-$(CONFIG_HTC_I2CPLD)	+= htc-i2cpld.o
>  
> +obj-${CONFIG_ARCH_DAVINCI}	+= davinci_aemif.o
>  obj-$(CONFIG_MFD_DAVINCI_VOICECODEC)	+= davinci_voicecodec.o
>  obj-$(CONFIG_MFD_DM355EVM_MSP)	+= dm355evm_msp.o
>  obj-$(CONFIG_MFD_TI_SSP)	+= ti-ssp.o
> diff --git a/arch/arm/mach-davinci/aemif.c b/drivers/mfd/davinci_aemif.c
> similarity index 66%
> rename from arch/arm/mach-davinci/aemif.c
> rename to drivers/mfd/davinci_aemif.c
> index b67c115..5fb490d 100644
> --- a/arch/arm/mach-davinci/aemif.c
> +++ b/drivers/mfd/davinci_aemif.c
> @@ -14,8 +14,13 @@
>  #include <linux/clk.h>
>  #include <linux/module.h>
>  #include <linux/time.h>
> -
>  #include <linux/mfd/davinci_aemif.h>
> +#include <linux/mtd/physmap.h>
> +#include <linux/slab.h>
> +#include <mach/nand.h>
> +
> +static char *name[] = {"davinci_nand", "physmap-flash",};
> +#define MAX ARRAY_SIZE(name)
>  
>  /* Timing value configuration */
>  
> @@ -131,3 +136,71 @@ int davinci_aemif_setup_timing(struct davinci_aemif_timing *t,
>  	return 0;
>  }
>  EXPORT_SYMBOL(davinci_aemif_setup_timing);
> +
> +static int __init davinci_aemif_probe(struct platform_device *pdev)
> +{
> +	struct davinci_aemif_devices *davinci_aemif_devices =
> +		pdev->dev.platform_data;
> +	struct platform_device *devices;
> +	struct mfd_cell *cells;
> +	int ret, i, j, count;
> +
> +	devices = davinci_aemif_devices->devices;
> +
> +	cells = kzalloc(sizeof(struct mfd_cell) *
> +			davinci_aemif_devices->num_devices, GFP_KERNEL);
> +
> +	for (j = 0, count = 0; j < MAX; j++) {
> +		for (i = 0; i < davinci_aemif_devices->num_devices; i++) {
> +			if (strcmp(devices[i].name, name[j]))
> +				continue;
> +			cells[count].name = name[j];
> +			cells[count].platform_data =
> +				devices[i].dev.platform_data;
> +			cells[count].pdata_size =
> +				sizeof(struct davinci_nand_pdata);

Doesnot take care of updating nor platform data size, I will fix this send out next version.

Thanks,
Prakash

> +			cells[count].id = devices[i].id;
> +			cells[count].resources = devices[i].resource;
> +			cells[count].num_resources = devices[i].num_resources;
> +			count++;
> +		}
> +	}
> +
> +	ret = mfd_add_devices(&pdev->dev, 0, cells,
> +			      count, NULL, 0);
> +	if (ret != 0)
> +		dev_err(&pdev->dev, "fail to register client devices\n");
> +
> +	return 0;
> +}
> +
> +static int __devexit davinci_aemif_remove(struct platform_device *pdev)
> +{
> +	mfd_remove_devices(&pdev->dev);
> +	return 0;
> +}
> +
> +static struct platform_driver davinci_aemif_driver = {
> +	.driver	= {
> +		.name = "davinci_aemif",
> +		.owner = THIS_MODULE,
> +	},
> +	.remove	= __devexit_p(davinci_aemif_remove),
> +};
> +
> +static int __init davinci_aemif_init(void)
> +{
> +	return platform_driver_probe(&davinci_aemif_driver,
> +			davinci_aemif_probe);
> +}
> +module_init(davinci_aemif_init);
> +
> +static void __exit davinci_aemif_exit(void)
> +{
> +	platform_driver_unregister(&davinci_aemif_driver);
> +}
> +module_exit(davinci_aemif_exit);
> +
> +MODULE_AUTHOR("Prakash Manjunathappa");
> +MODULE_DESCRIPTION("Texas Instruments AEMIF Interface");
> +MODULE_LICENSE("GPL");
> diff --git a/include/linux/mfd/davinci_aemif.h b/include/linux/mfd/davinci_aemif.h
> index 05b2934..18650c3 100644
> --- a/include/linux/mfd/davinci_aemif.h
> +++ b/include/linux/mfd/davinci_aemif.h
> @@ -10,6 +10,10 @@
>  #ifndef _MACH_DAVINCI_AEMIF_H
>  #define _MACH_DAVINCI_AEMIF_H
>  
> +#include <linux/kernel.h>
> +#include <linux/platform_device.h>
> +#include <linux/mfd/core.h>
> +
>  #define NRCSR_OFFSET		0x00
>  #define AWCCR_OFFSET		0x04
>  #define A1CR_OFFSET		0x10
> @@ -18,6 +22,16 @@
>  #define ACR_EW_MASK		BIT(30)
>  #define ACR_SS_MASK		BIT(31)
>  
> +enum davinci_emif_cells {
> +	DAVINCI_NAND_DEVICE_CELL,
> +	DAVINCI_NOR_FLASH_CELL,
> +};
> +
> +struct davinci_aemif_devices {
> +	struct platform_device *devices;
> +	unsigned int num_devices;
> +};
> +
>  /* All timings in nanoseconds */
>  struct davinci_aemif_timing {
>  	u8	wsetup;
> -- 
> 1.7.1
> 
> 

