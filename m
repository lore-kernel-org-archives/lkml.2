Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476Ab1LLW2Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 17:28:24 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:49958 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471Ab1LLW2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 17:28:21 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6558"; a="146051941"
Message-ID: <4EE68003.1090802@codeaurora.org>
Date: Mon, 12 Dec 2011 15:28:19 -0700
From: Harini Jayaraman <harinij@codeaurora.org>
Reply-To: harinij@codeaurora.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Wolfram Sang <w.sang@pengutronix.de>
CC: grant.likely@secretlab.ca, bryanh@codeaurora.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kheitke@codeaurora.org, spi-devel-general@lists.sourceforge.net,
        davidb@codeaurora.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] spi: QUP based bus driver for Qualcomm MSM chipsets
References: <y> <1321307907-31508-1-git-send-email-harinij@codeaurora.org> <20111207223757.GE3744@pengutronix.de>
In-Reply-To: <20111207223757.GE3744@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/2011 03:37 PM, Wolfram Sang wrote:
> On Mon, Nov 14, 2011 at 02:58:27PM -0700, Harini Jayaraman wrote:
>> This bus driver supports the QUP SPI hardware controller in the Qualcomm
>> MSM SOCs. The Qualcomm Universal Peripheral Engine (QUP) is a general
>> purpose data path engine with input/output FIFOs and an embedded SPI
>> mini-core. The driver currently supports only FIFO mode.
>>
>> Signed-off-by: Harini Jayaraman<harinij@codeaurora.org>
> Wow, this driver is huge. This is a rough review only, mainly to see
> what can go away. This will make further reviews easier.
>
Thanks Wolfram for taking time to review this patch. I appreciate your 
comments and will incorporate them in to the next version of the patch.
>> ---
>> v2: Updated copyright information (addresses comments from Bryan Huntsman).
>>      Files renamed.
>> ---
>>   drivers/spi/Kconfig                   |   10 +
>>   drivers/spi/Makefile                  |    1 +
>>   drivers/spi/spi-qup.c                 | 1144 +++++++++++++++++++++++++++++++++
>>   drivers/spi/spi-qup.h                 |  436 +++++++++++++
>>   include/linux/platform_data/msm_spi.h |   19 +
>>   5 files changed, 1610 insertions(+), 0 deletions(-)
>>   create mode 100644 drivers/spi/spi-qup.c
>>   create mode 100644 drivers/spi/spi-qup.h
>>   create mode 100644 include/linux/platform_data/msm_spi.h
>>
>> diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
>> index 52e2900..88ea7c5 100644
>> --- a/drivers/spi/Kconfig
>> +++ b/drivers/spi/Kconfig
>> @@ -280,6 +280,16 @@ config SPI_PXA2XX
>>   config SPI_PXA2XX_PCI
>>   	def_bool SPI_PXA2XX&&  X86_32&&  PCI
>>
>> +config SPI_QUP
>> +	tristate "Qualcomm MSM SPI QUPe Support"
>> +	depends on ARCH_MSM
>> +	help
>> +	  Support for Serial Peripheral Interface for Qualcomm Universal
>> +	  Peripheral.
>> +
>> +	  This driver can also be built as a module. If so, the module
>> +	  will be called spi-qup.
>> +
>>   config SPI_S3C24XX
>>   	tristate "Samsung S3C24XX series SPI"
>>   	depends on ARCH_S3C2410&&  EXPERIMENTAL
>> diff --git a/drivers/spi/Makefile b/drivers/spi/Makefile
>> index 61c3261..4d840ff 100644
>> --- a/drivers/spi/Makefile
>> +++ b/drivers/spi/Makefile
>> @@ -44,6 +44,7 @@ obj-$(CONFIG_SPI_PL022)			+= spi-pl022.o
>>   obj-$(CONFIG_SPI_PPC4xx)		+= spi-ppc4xx.o
>>   obj-$(CONFIG_SPI_PXA2XX)		+= spi-pxa2xx.o
>>   obj-$(CONFIG_SPI_PXA2XX_PCI)		+= spi-pxa2xx-pci.o
>> +obj-$(CONFIG_SPI_QUP)			+= spi-qup.o
>>   obj-$(CONFIG_SPI_S3C24XX)		+= spi-s3c24xx-hw.o
>>   spi-s3c24xx-hw-y			:= spi-s3c24xx.o
>>   spi-s3c24xx-hw-$(CONFIG_SPI_S3C24XX_FIQ) += spi-s3c24xx-fiq.o
>> diff --git a/drivers/spi/spi-qup.c b/drivers/spi/spi-qup.c
>> new file mode 100644
>> index 0000000..4b411d8
>> --- /dev/null
>> +++ b/drivers/spi/spi-qup.c
>> @@ -0,0 +1,1144 @@
>> +/* Copyright (c) 2008-2011, Code Aurora Forum. All rights reserved.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 and
>> + * only version 2 as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +
>> +#include<linux/version.h>
>> +#include<linux/kernel.h>
>> +#include<linux/init.h>
>> +#include<linux/spinlock.h>
>> +#include<linux/list.h>
>> +#include<linux/irq.h>
>> +#include<linux/platform_device.h>
>> +#include<linux/spi/spi.h>
>> +#include<linux/interrupt.h>
>> +#include<linux/err.h>
>> +#include<linux/clk.h>
>> +#include<linux/delay.h>
>> +#include<linux/workqueue.h>
>> +#include<linux/io.h>
>> +#include<linux/debugfs.h>
>> +#include<linux/sched.h>
>> +#include<linux/mutex.h>
>> +#include<linux/platform_data/msm_spi.h>
>> +#include "spi-qup.h"
>> +
>> +static void msm_spi_clock_set(struct msm_spi *dd, int speed)
>> +{
>> +	int rc;
>> +
>> +	rc = clk_set_rate(dd->clk, speed);
>> +	if (!rc)
>> +		dd->clock_speed = speed;
>> +}
>> +
>> +static int msm_spi_calculate_size(int *fifo_size,
>> +				  int *block_size,
>> +				  int block,
>> +				  int mult)
>> +{
>> +	int words;
>> +
>> +	switch (block) {
>> +	case 0:
>> +		words = 1; /* 4 bytes */
>> +		break;
>> +	case 1:
>> +		words = 4; /* 16 bytes */
>> +		break;
>> +	case 2:
>> +		words = 8; /* 32 bytes */
>> +		break;
>> +	default:
>> +		return -EINVAL;
>> +	}
>> +
>> +	switch (mult) {
>> +	case 0:
>> +		*fifo_size = words * 2;
>> +		break;
>> +	case 1:
>> +		*fifo_size = words * 4;
>> +		break;
>> +	case 2:
>> +		*fifo_size = words * 8;
>> +		break;
>> +	case 3:
>> +		*fifo_size = words * 16;
>> +		break;
>> +	default:
>> +		return -EINVAL;
>> +	}
> I think this can be simplified. Example for this switch:
>
> 	if (mult>  3)
> 		return -EINVAL;
>
> 	*fifo_size = (words * 2)<<  mult;
>
> Probably the whole function can be optimized away somehow?
>
>> +
>> +	*block_size = words * sizeof(u32); /* in bytes */
>> +	return 0;
>> +}
> ...
>
>
>> +#ifdef CONFIG_DEBUG_FS
>> +static int debugfs_iomem_x32_set(void *data, u64 val)
>> +{
>> +	iowrite32(val, data);
>> +	/* Ensure the previous write completed. */
>> +	wmb();
>> +	return 0;
>> +}
>> +
>> +static int debugfs_iomem_x32_get(void *data, u64 *val)
>> +{
>> +	*val = ioread32(data);
>> +	return 0;
>> +}
>> +
>> +DEFINE_SIMPLE_ATTRIBUTE(fops_iomem_x32, debugfs_iomem_x32_get,
>> +			debugfs_iomem_x32_set, "0x%08llx\n");
>> +
>> +static void spi_debugfs_init(struct msm_spi *dd)
>> +{
>> +	dd->dent_spi = debugfs_create_dir(dev_name(dd->dev), NULL);
>> +	if (dd->dent_spi) {
>> +		int i;
>> +
>> +		for (i = 0; i<  ARRAY_SIZE(debugfs_spi_regs); i++) {
>> +			dd->debugfs_spi_regs[i] =
>> +				debugfs_create_file(
>> +					debugfs_spi_regs[i].name,
>> +					debugfs_spi_regs[i].mode,
>> +					dd->dent_spi,
>> +					dd->base + debugfs_spi_regs[i].offset,
>> +					&fops_iomem_x32);
>> +		}
>> +	}
>> +}
>> +
>> +static void spi_debugfs_exit(struct msm_spi *dd)
>> +{
>> +	if (dd->dent_spi) {
>> +		int i;
>> +
>> +		debugfs_remove_recursive(dd->dent_spi);
>> +		dd->dent_spi = NULL;
>> +		for (i = 0; i<  ARRAY_SIZE(debugfs_spi_regs); i++)
>> +			dd->debugfs_spi_regs[i] = NULL;
>> +	}
>> +}
>> +#else
>> +static void spi_debugfs_init(struct msm_spi *dd) {}
>> +static void spi_debugfs_exit(struct msm_spi *dd) {}
>> +#endif
> That interface should go away. It might have been nice when developing
> the driver, but we other mechanisms to read out register values.
>
>> +
>> +/* ===Device attributes begin=== */
>> +static ssize_t show_stats(struct device *dev, struct device_attribute *attr,
>> +				char *buf)
>> +{
>> +	struct spi_master *master = dev_get_drvdata(dev);
>> +	struct msm_spi *dd =  spi_master_get_devdata(master);
>> +
>> +	return snprintf(buf, PAGE_SIZE,
>> +			"Device       %s\n"
>> +			"rx fifo_size = %d spi words\n"
>> +			"tx fifo_size = %d spi words\n"
>> +			"rx block size = %d bytes\n"
>> +			"tx block size = %d bytes\n"
>> +			"--statistics--\n"
>> +			"Rx isrs  = %d\n"
>> +			"Tx isrs  = %d\n"
>> +			"--debug--\n"
>> +			"NA yet\n",
>> +			dev_name(dev),
>> +			dd->input_fifo_size,
>> +			dd->output_fifo_size,
>> +			dd->input_block_size,
>> +			dd->output_block_size,
>> +			dd->stat_rx,
>> +			dd->stat_tx
>> +			);
>> +}
>> +
>> +/* Reset statistics on write */
>> +static ssize_t set_stats(struct device *dev, struct device_attribute *attr,
>> +				const char *buf, size_t count)
>> +{
>> +	struct msm_spi *dd = dev_get_drvdata(dev);
>> +
>> +	dd->stat_rx = 0;
>> +	dd->stat_tx = 0;
>> +	return count;
>> +}
>> +
>> +static DEVICE_ATTR(stats, S_IRUGO | S_IWUSR, show_stats, set_stats);
>> +
>> +static struct attribute *dev_attrs[] = {
>> +	&dev_attr_stats.attr,
>> +	NULL,
>> +};
>> +
>> +static struct attribute_group dev_attr_grp = {
>> +	.attrs = dev_attrs,
>> +};
>> +/* ===Device attributes end=== */
> This should go as well. Not really needed.
>
>> +
>> +static int __init msm_spi_probe(struct platform_device *pdev)
>> +{
>> +	struct spi_master      *master;
>> +	struct msm_spi	       *dd;
>> +	struct resource	       *resource;
>> +	int                     rc = -ENXIO;
>> +	int                     locked = 0;
>> +	int                     clk_enabled = 0;
>> +	int                     pclk_enabled = 0;
>> +	struct msm_spi_platform_data *pdata = pdev->dev.platform_data;
>> +
>> +	master = spi_alloc_master(&pdev->dev, sizeof(struct msm_spi));
>> +	if (!master) {
>> +		rc = -ENOMEM;
>> +		dev_err(&pdev->dev, "master allocation failed\n");
>> +		goto err_probe_exit;
>> +	}
>> +
>> +	master->bus_num        = pdev->id;
>> +	master->mode_bits      = SPI_SUPPORTED_MODES;
>> +	master->num_chipselect = SPI_NUM_CHIPSELECTS;
>> +	master->setup          = msm_spi_setup;
>> +	master->transfer       = msm_spi_transfer;
>> +	platform_set_drvdata(pdev, master);
>> +	dd = spi_master_get_devdata(master);
>> +
>> +	dd->pdata = pdata;
>> +	rc = msm_spi_get_irq_data(dd, pdev);
>> +	if (rc)
>> +		goto err_probe_res;
>> +
>> +	resource = platform_get_resource_byname(pdev,
>> +						IORESOURCE_MEM, "spi_base");
>> +	if (!resource) {
>> +		rc = -ENXIO;
>> +		goto err_probe_res;
>> +	}
>> +
>> +	dd->mem_phys_addr = resource->start;
>> +	dd->mem_size = resource_size(resource);
>> +
>> +	spin_lock_init(&dd->queue_lock);
>> +	mutex_init(&dd->core_lock);
>> +	INIT_LIST_HEAD(&dd->queue);
>> +	INIT_WORK(&dd->work_data, msm_spi_workq);
>> +	init_waitqueue_head(&dd->continue_suspend);
>> +	dd->workqueue = create_singlethread_workqueue(
>> +						dev_name(master->dev.parent));
>> +	if (!dd->workqueue)
>> +		goto err_probe_res;
>> +
>> +	if (!devm_request_mem_region(&pdev->dev, dd->mem_phys_addr,
>> +					dd->mem_size, SPI_DRV_NAME)) {
>> +		rc = -ENXIO;
>> +		goto err_probe_reqmem;
>> +	}
>> +
>> +	dd->base = devm_ioremap(&pdev->dev, dd->mem_phys_addr, dd->mem_size);
>> +	if (!dd->base) {
>> +		rc = -ENOMEM;
>> +		goto err_probe_reqmem;
>> +	}
>> +
>> +
>> +	mutex_lock(&dd->core_lock);
>> +	locked = 1;
>> +	dd->dev =&pdev->dev;
>> +	dd->clk = clk_get(&pdev->dev, "spi_clk");
>> +	if (IS_ERR(dd->clk)) {
>> +		dev_err(&pdev->dev, "%s: unable to get spi_clk\n", __func__);
>> +		rc = PTR_ERR(dd->clk);
>> +		goto err_probe_clk_get;
>> +	}
>> +
>> +	dd->pclk = clk_get(&pdev->dev, "spi_pclk");
>> +	if (IS_ERR(dd->pclk)) {
>> +		dev_err(&pdev->dev, "%s: unable to get spi_pclk\n", __func__);
>> +		rc = PTR_ERR(dd->pclk);
>> +		goto err_probe_pclk_get;
>> +	}
>> +
>> +	if (pdata&&  pdata->max_clock_speed)
>> +		msm_spi_clock_set(dd, dd->pdata->max_clock_speed);
>> +
>> +	rc = clk_enable(dd->clk);
>> +	if (rc) {
>> +		dev_err(&pdev->dev, "%s: unable to enable spi_clk\n",
>> +			__func__);
>> +		goto err_probe_clk_enable;
>> +	}
>> +
>> +	clk_enabled = 1;
>> +	rc = clk_enable(dd->pclk);
>> +	if (rc) {
>> +		dev_err(&pdev->dev, "%s: unable to enable spi_pclk\n",
>> +		__func__);
>> +		goto err_probe_pclk_enable;
>> +	}
>> +
>> +	pclk_enabled = 1;
>> +	rc = msm_spi_configure_gsbi(dd, pdev);
>> +	if (rc)
>> +		goto err_probe_gsbi;
>> +
>> +	msm_spi_calculate_fifo_size(dd);
>> +
>> +	/* Initialize registers */
>> +	writel(0x00000001, dd->base + SPI_SW_RESET);
>> +	msm_spi_set_state(dd, SPI_OP_STATE_RESET);
>> +	writel(0x00000000, dd->base + SPI_OPERATIONAL);
>> +	writel(0x00000000, dd->base + SPI_CONFIG);
>> +	writel(0x00000000, dd->base + SPI_IO_MODES);
> 0x0, or 0x1 will do. Save the leading 0s.
>
>> +	/*
>> +	 * The SPI core generates a bogus input overrun error on some targets,
>> +	 * when a transition from run to reset state occurs and if the FIFO has
>> +	 * an odd number of entries. Hence we disable the INPUT_OVER_RUN_ERR_EN
>> +	 * bit.
>> +	 */
>> +	msm_spi_enable_error_flags(dd);
>> +
>> +	writel(SPI_IO_C_NO_TRI_STATE, dd->base + SPI_IO_CONTROL);
>> +	rc = msm_spi_set_state(dd, SPI_OP_STATE_RESET);
>> +	if (rc)
>> +		goto err_probe_state;
>> +
>> +	clk_disable(dd->clk);
>> +	clk_disable(dd->pclk);
>> +	clk_enabled = 0;
>> +	pclk_enabled = 0;
>> +
>> +	dd->suspended = 0;
>> +	dd->transfer_pending = 0;
>> +	dd->multi_xfr = 0;
>> +	dd->mode = SPI_MODE_NONE;
>> +
>> +	rc = msm_spi_request_irq(dd, pdev->name, master);
> There is also devm_request_irq
>
>> +	if (rc)
>> +		goto err_probe_irq;
>> +
>> +	msm_spi_disable_irqs(dd);
>> +	mutex_unlock(&dd->core_lock);
>> +	locked = 0;
>> +
>> +	rc = spi_register_master(master);
>> +	if (rc)
>> +		goto err_probe_reg_master;
>> +
>> +	rc = sysfs_create_group(&(dd->dev->kobj),&dev_attr_grp);
>> +	if (rc) {
>> +		dev_err(&pdev->dev, "failed to create dev. attrs : %d\n", rc);
>> +		goto err_attrs;
>> +	}
>> +
>> +	spi_debugfs_init(dd);
>> +
>> +	return 0;
>> +
>> +err_attrs:
>> +	spi_unregister_master(master);
>> +err_probe_reg_master:
>> +	msm_spi_free_irq(dd, master);
>> +err_probe_irq:
>> +err_probe_state:
>> +err_probe_gsbi:
>> +	if (pclk_enabled)
>> +		clk_disable(dd->pclk);
>> +err_probe_pclk_enable:
>> +	if (clk_enabled)
>> +		clk_disable(dd->clk);
>> +err_probe_clk_enable:
>> +	clk_put(dd->pclk);
>> +err_probe_pclk_get:
>> +	clk_put(dd->clk);
>> +err_probe_clk_get:
>> +	if (locked)
>> +		mutex_unlock(&dd->core_lock);
>> +err_probe_reqmem:
>> +	destroy_workqueue(dd->workqueue);
>> +err_probe_res:
>> +	spi_master_put(master);
>> +err_probe_exit:
>> +	return rc;
>> +}
>> +
> ...
>
>> +static struct platform_driver msm_spi_driver = {
>> +	.driver		= {
>> +		.name	= SPI_DRV_NAME,
>> +		.owner	= THIS_MODULE,
>> +	},
>> +	.suspend        = msm_spi_suspend,
>> +	.resume         = msm_spi_resume,
>> +	.remove         = __exit_p(msm_spi_remove),
>> +};
> What about using module_platform_driver?
>
>> +
>> +static int __init msm_spi_init(void)
>> +{
>> +	return platform_driver_probe(&msm_spi_driver, msm_spi_probe);
>> +}
>> +module_init(msm_spi_init);
>> +
>> +static void __exit msm_spi_exit(void)
>> +{
>> +	platform_driver_unregister(&msm_spi_driver);
>> +}
>> +module_exit(msm_spi_exit);
>> +
>> +MODULE_LICENSE("GPL v2");
>> +MODULE_VERSION("0.3");
> MODULE_VERSION is not really needed these days.
>
>> +MODULE_ALIAS("platform:"SPI_DRV_NAME);
>> diff --git a/drivers/spi/spi-qup.h b/drivers/spi/spi-qup.h
>> new file mode 100644
>> index 0000000..be0dc66
>> --- /dev/null
>> +++ b/drivers/spi/spi-qup.h
>> @@ -0,0 +1,436 @@
>> +/* Copyright (c) 2008-2011, Code Aurora Forum. All rights reserved.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 and
>> + * only version 2 as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +
> ...
>
>> +#ifdef CONFIG_DEBUG_FS
>> +static const struct {
>> +	const char *name;
>> +	mode_t mode;
>> +	int offset;
>> +} debugfs_spi_regs[] = {
>> +	{"config",                S_IRUGO | S_IWUSR, SPI_CONFIG},
>> +	{"io_control",            S_IRUGO | S_IWUSR, SPI_IO_CONTROL},
>> +	{"io_modes",              S_IRUGO | S_IWUSR, SPI_IO_MODES},
>> +	{"sw_reset",                        S_IWUSR, SPI_SW_RESET},
>> +	{"time_out",              S_IRUGO | S_IWUSR, SPI_TIME_OUT},
>> +	{"time_out_current",      S_IRUGO,           SPI_TIME_OUT_CURRENT},
>> +	{"mx_output_count",       S_IRUGO | S_IWUSR, SPI_MX_OUTPUT_COUNT},
>> +	{"mx_output_cnt_current", S_IRUGO,           SPI_MX_OUTPUT_CNT_CURRENT},
>> +	{"mx_input_count",        S_IRUGO | S_IWUSR, SPI_MX_INPUT_COUNT},
>> +	{"mx_input_cnt_current",  S_IRUGO,           SPI_MX_INPUT_CNT_CURRENT},
>> +	{"mx_read_count",         S_IRUGO | S_IWUSR, SPI_MX_READ_COUNT},
>> +	{"mx_read_cnt_current",   S_IRUGO,           SPI_MX_READ_CNT_CURRENT},
>> +	{"operational",           S_IRUGO | S_IWUSR, SPI_OPERATIONAL},
>> +	{"error_flags",           S_IRUGO | S_IWUSR, SPI_ERROR_FLAGS},
>> +	{"error_flags_en",        S_IRUGO | S_IWUSR, SPI_ERROR_FLAGS_EN},
>> +	{"deassert_wait",         S_IRUGO | S_IWUSR, SPI_DEASSERT_WAIT},
>> +	{"output_debug",          S_IRUGO,           SPI_OUTPUT_DEBUG},
>> +	{"input_debug",           S_IRUGO,           SPI_INPUT_DEBUG},
>> +	{"test_ctrl",             S_IRUGO | S_IWUSR, SPI_TEST_CTRL},
>> +	{"output_fifo",                     S_IWUSR, SPI_OUTPUT_FIFO},
>> +	{"input_fifo" ,           S_IRUSR,           SPI_INPUT_FIFO},
>> +	{"spi_state",             S_IRUGO | S_IWUSR, SPI_STATE},
>> +	{"qup_config",            S_IRUGO | S_IWUSR, QUP_CONFIG},
>> +	{"qup_error_flags",       S_IRUGO | S_IWUSR, QUP_ERROR_FLAGS},
>> +	{"qup_error_flags_en",    S_IRUGO | S_IWUSR, QUP_ERROR_FLAGS_EN},
>> +	{"mx_write_cnt",          S_IRUGO | S_IWUSR, QUP_MX_WRITE_COUNT},
>> +	{"mx_write_cnt_current",  S_IRUGO,           QUP_MX_WRITE_CNT_CURRENT},
>> +	{"output_fifo_word_cnt",  S_IRUGO,           SPI_OUTPUT_FIFO_WORD_CNT},
>> +	{"input_fifo_word_cnt",   S_IRUGO,           SPI_INPUT_FIFO_WORD_CNT},
>> +};
>> +#endif
> Again, drop it.
>
>> +
>> +/**
>> + * struct msm_spi
>> + * @read_buf: rx_buf from the spi_transfer.
>> + * @write_buf: tx_buf from the spi_transfer.
>> + * @base: location of QUP controller I/O area in memory.
>> + * @dev: parent platform device.
>> + * @queue_lock: lock to protect queue.
>> + * @core_lock: mutex used to protect this struct.
>> + * @queue: to log SPI transfer requests.
>> + * @workqueue: workqueue for the SPI transfer requests.
>> + * @work_data: work.
>> + * @cur_msg: the current spi_message being processed.
>> + * @cur_transfer: the current spi_transfer being processed.
>> + * @transfer_complete: completion function to signal the end of a spi_transfer.
>> + * @clk: the SPI core clock
>> + * @pclk: hardware core clock. Needs to be enabled to access the QUP register
>> + * @mem_phys_addr: physical address of the QUP controller.
>> + * @mem_size: size of the QUP controller block.
>> + * @input_fifo_size: the input FIFO size (in bytes).
>> + * @output_fifo_size: the output FIFO size (in bytes).
>> + * @rx_bytes_remaining: the number of rx bytes remaining to be transferred.
>> + * @tx_bytes_remaining: the number of tx bytes remaining to be transferred.
>> + * @clock_speed: SPI clock speed.
>> + * @irq_in: assigned interrupt line for QUP interrupts.
>> + * @read_xfr_cnt: number of words read from the FIFO (per transfer).
>> + * @write_xfr_cnt: number of words written to the FIFO (per transfer).
>> + * @write_len: the total number of tx bytes to be transferred, per
>> + *	spi_message. This is valid only for WR-WR and WR-RD transfers
>> + *	in a single spi_message.
>> + * @read_len: the total number of rx bytes to be transferred, per
>> + *	spi_message. This is valid only for WR-WR and WR-RD transfers
>> + *	in a single spi_message.
>> + * @bytes_per_word: bytes per word
>> + * @suspended: the suspend state.
>> + * @transfer_pending: when set indicates a pending transfer.
>> + * @continue_suspend: head of wait queue.
>> + * @mode: mode for SPI operation.
>> + * @input_block_size: the input block size (in bytes).
>> + * @output_block_size: the output block size (in bytes).
>> + * @stat_rx: count of input interrupts handled.
>> + * @stat_tx: count of output interrupts handled.
>> + * @dent_spi: used for debug purposes.
>> + * @debugfs_spi_regs: used for debug purposes.
>> + * @pdata: platform data
>> + * @multi_xfr: when set indicates multiple spi_transfers in a single
>> + *	spi_message.
>> + * @done: flag used to signal completion.
>> + * @cur_msg_len: combined length of all the transfers in a single
>> + *	spi_message (in bytes).
>> + * @cur_tx_transfer: the current tx transfer being processed. Used in
>> + *	FIFO mode only.
>> + * @cur_rx_transfer: the current rx transfer being processed. Used in
>> + *	FIFO mode only.
>> + *
>> + * Early QUP controller used three separate interrupt lines for input, output,
>> + * and error interrupts.  Later versions share a single interrupt line.
>> + */
>> +struct msm_spi {
>> +	u8                      *read_buf;
>> +	const u8                *write_buf;
>> +	void __iomem            *base;
>> +	struct device           *dev;
>> +	spinlock_t               queue_lock;
>> +	struct mutex             core_lock;
>> +	struct list_head         queue;
>> +	struct workqueue_struct *workqueue;
>> +	struct work_struct       work_data;
>> +	struct spi_message      *cur_msg;
>> +	struct spi_transfer     *cur_transfer;
>> +	struct completion        transfer_complete;
>> +	struct clk              *clk;
>> +	struct clk              *pclk;
>> +	unsigned long            mem_phys_addr;
>> +	size_t                   mem_size;
>> +	int                      input_fifo_size;
>> +	int                      output_fifo_size;
>> +	u32                      rx_bytes_remaining;
>> +	u32                      tx_bytes_remaining;
>> +	u32                      clock_speed;
>> +	int                      irq_in;
>> +	int                      read_xfr_cnt;
>> +	int                      write_xfr_cnt;
>> +	int                      write_len;
>> +	int                      read_len;
>> +	int                      bytes_per_word;
>> +	bool                     suspended;
>> +	bool                     transfer_pending;
>> +	wait_queue_head_t        continue_suspend;
>> +	enum msm_spi_mode        mode;
>> +	int                      input_block_size;
>> +	int                      output_block_size;
>> +	int                      stat_rx;
>> +	int                      stat_tx;
>> +#ifdef CONFIG_DEBUG_FS
>> +	struct dentry *dent_spi;
>> +	struct dentry *debugfs_spi_regs[ARRAY_SIZE(debugfs_spi_regs)];
>> +#endif
>> +	struct msm_spi_platform_data *pdata;
>> +	bool                     multi_xfr;
>> +	bool                     done;
>> +	u32                      cur_msg_len;
>> +	struct spi_transfer     *cur_tx_transfer;
>> +	struct spi_transfer     *cur_rx_transfer;
>> +};
> This looks excessive. Please check if all of this is really needed?
>
>> +
>> +/* Forward declaration */
>> +static irqreturn_t msm_spi_input_irq(int irq, void *dev_id);
>> +static irqreturn_t msm_spi_output_irq(int irq, void *dev_id);
>> +static irqreturn_t msm_spi_error_irq(int irq, void *dev_id);
>> +static inline int msm_spi_set_state(struct msm_spi *dd,
>> +				enum msm_spi_state state);
>> +static void msm_spi_write_word_to_fifo(struct msm_spi *dd);
>> +static inline void msm_spi_write_rmn_to_fifo(struct msm_spi *dd);
>> +
>> +/* In QUP the same interrupt line is used for input, output and error */
>> +static inline int msm_spi_get_irq_data(struct msm_spi *dd,
>> +					struct platform_device *pdev)
>> +{
>> +	dd->irq_in  = platform_get_irq_byname(pdev, "spi_irq_in");
>> +	if (dd->irq_in<  0)
>> +		return -EINVAL;
>> +
>> +	return 0;
>> +}
>> +
>> +static inline int msm_spi_configure_gsbi(struct msm_spi *dd,
>> +					struct platform_device *pdev)
>> +{
>> +	struct resource *resource;
>> +	unsigned long   gsbi_mem_phys_addr;
>> +	size_t          gsbi_mem_size;
>> +	void __iomem    *gsbi_base;
>> +
>> +	resource  = platform_get_resource_byname(pdev,
>> +						 IORESOURCE_MEM, "gsbi_base");
>> +	if (!resource)
>> +		return -ENXIO;
>> +
>> +	gsbi_mem_phys_addr = resource->start;
>> +	gsbi_mem_size = resource_size(resource);
>> +	if (!devm_request_mem_region(&pdev->dev, gsbi_mem_phys_addr,
>> +					gsbi_mem_size, SPI_DRV_NAME))
>> +		return -ENXIO;
>> +
>> +	gsbi_base = devm_ioremap(&pdev->dev, gsbi_mem_phys_addr,
>> +					gsbi_mem_size);
>> +	if (!gsbi_base)
>> +		return -ENXIO;
>> +
>> +	/* Set GSBI to SPI mode */
>> +	writel(GSBI_SPI_CONFIG, gsbi_base + GSBI_CTRL_REG);
>> +
>> +	return 0;
>> +}
>> +
>> +/* Figure which irq occured and call the relevant functions */
>> +static irqreturn_t msm_spi_qup_irq(int irq, void *dev_id)
>> +{
>> +	u32 op, ret = IRQ_NONE;
>> +	struct msm_spi *dd = dev_id;
>> +
>> +	if (readl(dd->base + SPI_ERROR_FLAGS) ||
>> +		readl(dd->base + QUP_ERROR_FLAGS)) {
>> +		struct spi_master *master = dev_get_drvdata(dd->dev);
>> +		ret |= msm_spi_error_irq(irq, master);
>> +	}
>> +
>> +	op = readl(dd->base + SPI_OPERATIONAL);
>> +	if (op&  SPI_OP_INPUT_SERVICE_FLAG) {
>> +		writel(SPI_OP_INPUT_SERVICE_FLAG, dd->base + SPI_OPERATIONAL);
>> +		ret |= msm_spi_input_irq(irq, dev_id);
>> +	}
>> +
>> +	if (op&  SPI_OP_OUTPUT_SERVICE_FLAG) {
>> +		writel(SPI_OP_OUTPUT_SERVICE_FLAG, dd->base + SPI_OPERATIONAL);
>> +		ret |= msm_spi_output_irq(irq, dev_id);
>> +	}
>> +
>> +	if (dd->done) {
>> +		complete(&dd->transfer_complete);
>> +		dd->done = 0;
>> +	}
>> +	return ret;
>> +}
> Too much code for a header file IMO.
>
>> +
>> +static inline int msm_spi_request_irq(struct msm_spi *dd,
>> +					const char *name,
>> +					struct spi_master *master)
>> +{
>> +	return request_irq(dd->irq_in, msm_spi_qup_irq, IRQF_TRIGGER_HIGH,
>> +			   name, dd);
>> +}
>> +
>> +static inline void msm_spi_free_irq(struct msm_spi *dd,
>> +					struct spi_master *master)
>> +{
>> +	free_irq(dd->irq_in, dd);
>> +}
>> +
>> +static inline void msm_spi_disable_irqs(struct msm_spi *dd)
>> +{
>> +	disable_irq(dd->irq_in);
>> +}
>> +
>> +static inline void msm_spi_enable_irqs(struct msm_spi *dd)
>> +{
>> +	enable_irq(dd->irq_in);
>> +}
>> +
>> +static inline void msm_spi_get_clk_err(struct msm_spi *dd, u32 *spi_err)
>> +{
>> +	*spi_err = readl(dd->base + QUP_ERROR_FLAGS);
>> +}
>> +
>> +static inline void msm_spi_ack_clk_err(struct msm_spi *dd)
>> +{
>> +	writel(QUP_ERR_MASK, dd->base + QUP_ERROR_FLAGS);
>> +}
>> +
>> +static inline void msm_spi_add_configs(struct msm_spi *dd, u32 *config, int n);
>> +
>> +/* QUP has no_input, no_output, and N bits at QUP_CONFIG */
>> +static inline void msm_spi_set_qup_config(struct msm_spi *dd, int bpw)
>> +{
>> +	u32 qup_config = readl(dd->base + QUP_CONFIG);
>> +
>> +	msm_spi_add_configs(dd,&qup_config, bpw-1);
>> +	writel(qup_config | QUP_CONFIG_SPI_MODE, dd->base + QUP_CONFIG);
>> +}
>> +
>> +static inline int msm_spi_prepare_for_write(struct msm_spi *dd)
>> +{
>> +	if (msm_spi_set_state(dd, SPI_OP_STATE_RUN))
>> +		return -EINVAL;
>> +
>> +	if (msm_spi_set_state(dd, SPI_OP_STATE_PAUSE))
>> +		return -EINVAL;
>> +
>> +	return 0;
>> +}
>> +
>> +static inline void msm_spi_start_write(struct msm_spi *dd, u32 read_count)
>> +{
>> +	if (read_count<= dd->input_fifo_size)
>> +		msm_spi_write_rmn_to_fifo(dd);
>> +	else
>> +		msm_spi_write_word_to_fifo(dd);
>> +}
>> +
>> +static inline void msm_spi_set_write_count(struct msm_spi *dd, int val)
>> +{
>> +	writel(val, dd->base + QUP_MX_WRITE_COUNT);
>> +}
>> +
>> +static inline void msm_spi_complete(struct msm_spi *dd)
>> +{
>> +	dd->done = 1;
>> +}
>> +
>> +static inline void msm_spi_enable_error_flags(struct msm_spi *dd)
>> +{
>> +	writel_relaxed(0x00000078, dd->base + SPI_ERROR_FLAGS_EN);
>> +}
>> +
>> +static inline void msm_spi_clear_error_flags(struct msm_spi *dd)
>> +{
>> +	writel_relaxed(0x0000007C, dd->base + SPI_ERROR_FLAGS);
>> +}
> While most of these one liners are too few code for a header file IMO.
> No need to encapsulate most of it, e.g use the *_irq-calls directly.
> Also, please don't use magic values (0x7c) but combine the proper
> defines, please.
We have different versions of the QUP controller and hence would like to 
abstract it out, so that subsequent versions of the QUP can be 
accommodated in future. I will surely combine the proper defines in my 
next patch.
> Thanks,
>
>     Wolfram
>

Thanks,
Harini Jayaraman

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

