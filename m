Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758345Ab0IXWsy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 18:48:54 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:38644 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753687Ab0IXWsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 18:48:52 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6116"; a="55523025"
Message-ID: <4C9D2AD2.4030102@codeaurora.org>
Date: Fri, 24 Sep 2010 16:48:50 -0600
From: Kenneth Heitke <kheitke@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.11pre) Gecko/20100922 Shredder/3.1.5pre
MIME-Version: 1.0
To: Ben Dooks <ben-linux@fluff.org>, khali@linux-fr.org,
        linux-i2c@vger.kernel.org
CC: linux-arm-msm@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        srinidhi kasagar <srinidhi.kasagar@stericsson.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: Single-wire Serial Bus Interface for Qualcomm MSM
 chipsets
References: <1279734768-8436-1-git-send-email-kheitke@codeaurora.org>
In-Reply-To: <1279734768-8436-1-git-send-email-kheitke@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben,

Can you comment on whether or not you would be willing to accept this 
driver as part of the I2C subsystem.  I have an updated patch that I'm 
ready to submit if you are willing to consider this driver.

thank you,
Ken

On 07/21/2010 11:52 AM, Kenneth Heitke wrote:
> This bus driver supports the Single-wire Serial Bus Interface (SSBI)
> controller in the Qualcomm MSM SOCs.  SSBI is not an I2C but is
> functionally related enough such that it is able to leverage the I2C
> framework.
>
> Unlike I2C, SSBI is a point-to-point connection, and therefore there is no
> need to specify a slave device address. The SSBI implementation
> overrides the slave device address to be a device register address
> instead.  This restricts the client drivers from using the SMBus
> communication APIs unless they update the address field (addr) of the
> i2c_client structure prior to every SMBus function call.  Instead it is
> recommended to use the i2c_transfer function where the address is
> specified as part of the i2c_msg structure.  The i2c_transfer function
> also provides more flexibility for performing multiple transactions in a
> single function call.
>
> Signed-off-by: Kenneth Heitke<kheitke@codeaurora.org>
> ---
>   drivers/i2c/busses/Kconfig    |   10 +
>   drivers/i2c/busses/Makefile   |    1 +
>   drivers/i2c/busses/i2c-ssbi.c |  472 +++++++++++++++++++++++++++++++++++++++++
>   include/linux/i2c-ssbi.h      |   33 +++
>   4 files changed, 516 insertions(+), 0 deletions(-)
>   create mode 100644 drivers/i2c/busses/i2c-ssbi.c
>   create mode 100755 include/linux/i2c-ssbi.h
>
> diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
> index bceafbf..690d601 100644
> --- a/drivers/i2c/busses/Kconfig
> +++ b/drivers/i2c/busses/Kconfig
> @@ -569,6 +569,16 @@ config I2C_SIMTEC
>   	  This driver can also be built as a module. If so, the module
>   	  will be called i2c-simtec.
>
> +config I2C_SSBI
> +	tristate "Qualcomm Single-wire Serial Bus Interface (SSBI)"
> +	depends on I2C&&  (ARCH_MSM7X30 || ARCH_MSM8X60)
> +	help
> +	  If you say yes to this option, support will be included for the
> +	  built-in SSBI interface on Qualcomm MSM family processors.
> +
> +          Note that SSBI is not an I2C bus, but is functionally related
> +          enough such that it is able to leverages the I2C framework.
> +
>   config I2C_STU300
>   	tristate "ST Microelectronics DDC I2C interface"
>   	depends on MACH_U300
> diff --git a/drivers/i2c/busses/Makefile b/drivers/i2c/busses/Makefile
> index 936880b..79a7ad9 100644
> --- a/drivers/i2c/busses/Makefile
> +++ b/drivers/i2c/busses/Makefile
> @@ -55,6 +55,7 @@ obj-$(CONFIG_I2C_S6000)		+= i2c-s6000.o
>   obj-$(CONFIG_I2C_SH7760)	+= i2c-sh7760.o
>   obj-$(CONFIG_I2C_SH_MOBILE)	+= i2c-sh_mobile.o
>   obj-$(CONFIG_I2C_SIMTEC)	+= i2c-simtec.o
> +obj-$(CONFIG_I2C_SSBI)          += i2c-ssbi.o
>   obj-$(CONFIG_I2C_STU300)	+= i2c-stu300.o
>   obj-$(CONFIG_I2C_VERSATILE)	+= i2c-versatile.o
>   obj-$(CONFIG_I2C_OCTEON)	+= i2c-octeon.o
> diff --git a/drivers/i2c/busses/i2c-ssbi.c b/drivers/i2c/busses/i2c-ssbi.c
> new file mode 100644
> index 0000000..1763ea5
> --- /dev/null
> +++ b/drivers/i2c/busses/i2c-ssbi.c
> @@ -0,0 +1,472 @@
> +/* Copyright (c) 2009-2010, Code Aurora Forum. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 and
> + * only version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
> + * 02110-1301, USA.
> + *
> + */
> +/*
> + * SSBI driver for Qualcomm MSM platforms
> + *
> + */
> +#include<linux/kernel.h>
> +#include<linux/platform_device.h>
> +#include<linux/err.h>
> +#include<linux/slab.h>
> +#include<linux/delay.h>
> +#include<linux/io.h>
> +#include<linux/i2c.h>
> +#include<linux/i2c-ssbi.h>
> +
> +/* SSBI 2.0 controller registers */
> +#define SSBI2_CMD			0x0008
> +#define SSBI2_RD			0x0010
> +#define SSBI2_STATUS			0x0014
> +#define SSBI2_MODE2			0x001C
> +
> +/* SSBI_CMD fields */
> +#define SSBI_CMD_RDWRN			(0x01<<  24)
> +#define SSBI_CMD_REG_ADDR_SHFT		(0x10)
> +#define SSBI_CMD_REG_ADDR_MASK		(0xFF<<  SSBI_CMD_REG_ADDR_SHFT)
> +#define SSBI_CMD_REG_DATA_SHFT		(0x00)
> +#define SSBI_CMD_REG_DATA_MASK		(0xFF<<  SSBI_CMD_REG_DATA_SHFT)
> +
> +/* SSBI_STATUS fields */
> +#define SSBI_STATUS_DATA_IN		0x10
> +#define SSBI_STATUS_RD_CLOBBERED	0x08
> +#define SSBI_STATUS_RD_READY		0x04
> +#define SSBI_STATUS_READY		0x02
> +#define SSBI_STATUS_MCHN_BUSY		0x01
> +
> +/* SSBI_RD fields */
> +#define SSBI_RD_RDWRN			0x01000000
> +#define SSBI_RD_REG_ADDR_SHFT		0x10
> +#define SSBI_RD_REG_ADDR_MASK		(0xFF<<  SSBI_RD_REG_ADDR_SHFT)
> +#define SSBI_RD_REG_DATA_SHFT		(0x00)
> +#define SSBI_RD_REG_DATA_MASK		(0xFF<<  SSBI_RD_REG_DATA_SHFT)
> +
> +/* SSBI_MODE2 fields */
> +#define SSBI_MODE2_REG_ADDR_15_8_SHFT	0x04
> +#define SSBI_MODE2_REG_ADDR_15_8_MASK	(0x7F<<  SSBI_MODE2_REG_ADDR_15_8_SHFT)
> +#define SSBI_MODE2_ADDR_WIDTH_SHFT	0x01
> +#define SSBI_MODE2_ADDR_WIDTH_MASK	(0x07<<  SSBI_MODE2_ADDR_WIDTH_SHFT)
> +#define SSBI_MODE2_SSBI2_MODE		0x00000001
> +
> +#define SSBI_MODE2_REG_ADDR_15_8(MD, AD) \
> +	(((MD)&  0x0F) | ((((AD)>>  8)<<  SSBI_MODE2_REG_ADDR_15_8_SHFT)&  \
> +	SSBI_MODE2_REG_ADDR_15_8_MASK))
> +
> +#define SSBI_MODE2_ADDR_WIDTH(N) \
> +	((((N) - 8)<<  SSBI_MODE2_ADDR_WIDTH_SHFT)&  SSBI_MODE2_ADDR_WIDTH_MASK)
> +
> +#define SSBI_TIMEOUT_US			100
> +
> +#define SSBI_CMD_READ(AD) \
> +	(SSBI_CMD_RDWRN | (((AD)&  0xFF)<<  SSBI_CMD_REG_ADDR_SHFT))
> +
> +#define SSBI_CMD_WRITE(AD, DT) \
> +	((((AD)&  0xFF)<<  SSBI_CMD_REG_ADDR_SHFT) | \
> +	 (((DT)&  0xFF)<<  SSBI_CMD_REG_DATA_SHFT))
> +
> +/* SSBI PMIC Arbiter command registers */
> +#define SSBI_PA_CMD			0x0000
> +#define SSBI_PA_RD_STATUS		0x0004
> +
> +/* SSBI_PA_CMD fields */
> +#define SSBI_PA_CMD_RDWRN		(0x01<<  24)
> +#define SSBI_PA_CMD_REG_ADDR_14_8_SHFT	(0x10)
> +#define SSBI_PA_CMD_REG_ADDR_14_8_MASK	(0x7F<<  SSBI_PA_CMD_REG_ADDR_14_8_SHFT)
> +#define SSBI_PA_CMD_REG_ADDR_7_0_SHFT	(0x08)
> +#define SSBI_PA_CMD_REG_ADDR_7_0_MASK	(0xFF<<  SSBI_PA_CMD_REG_ADDR_7_0_SHFT)
> +#define SSBI_PA_CMD_REG_DATA_SHFT	(0x00)
> +#define SSBI_PA_CMD_REG_DATA_MASK	(0xFF<<  SSBI_PA_CMD_REG_DATA_SHFT)
> +
> +#define SSBI_PA_CMD_REG_DATA(DT) \
> +	(((DT)<<  SSBI_PA_CMD_REG_DATA_SHFT)&  SSBI_PA_CMD_REG_DATA_MASK)
> +
> +#define SSBI_PA_CMD_REG_ADDR(AD) \
> +	(((AD)<<  SSBI_PA_CMD_REG_ADDR_7_0_SHFT)&  \
> +	(SSBI_PA_CMD_REG_ADDR_14_8_MASK|SSBI_PA_CMD_REG_ADDR_7_0_MASK))
> +
> +/* SSBI_PA_RD_STATUS fields */
> +#define SSBI_PA_RD_STATUS_TRANS_DONE	(0x01<<  27)
> +#define SSBI_PA_RD_STATUS_TRANS_DENIED	(0x01<<  26)
> +#define SSBI_PA_RD_STATUS_REG_DATA_SHFT	(0x00)
> +#define SSBI_PA_RD_STATUS_REG_DATA_MASK	(0xFF<<  SSBI_PA_CMD_REG_DATA_SHFT)
> +#define SSBI_PA_RD_STATUS_TRANS_COMPLETE \
> +	(SSBI_PA_RD_STATUS_TRANS_DONE|SSBI_PA_RD_STATUS_TRANS_DENIED)
> +
> +#define SSBI_MSM_NAME			"i2c_ssbi"
> +
> +MODULE_LICENSE("GPL v2");
> +MODULE_VERSION("2.0");
> +MODULE_ALIAS("platform:i2c_ssbi");
> +MODULE_AUTHOR("Kenneth Heitke<kheitke@codeaurora.org>");
> +
> +struct i2c_ssbi_dev {
> +	void __iomem		*base;
> +	struct device           *dev;
> +	struct i2c_adapter	 adapter;
> +	unsigned long		 mem_phys_addr;
> +	size_t			 mem_size;
> +	enum msm_ssbi_controller_type controller_type;
> +	int (*read)(struct i2c_ssbi_dev *, struct i2c_msg *);
> +	int (*write)(struct i2c_ssbi_dev *, struct i2c_msg *);
> +};
> +
> +static inline int
> +i2c_ssbi_poll_for_device_ready(struct i2c_ssbi_dev *ssbi)
> +{
> +	u32 timeout = SSBI_TIMEOUT_US;
> +
> +	while (!(readl(ssbi->base + SSBI2_STATUS)&  SSBI_STATUS_READY)) {
> +		if (--timeout == 0) {
> +			dev_err(ssbi->dev, "%s: timeout, status %x\n", __func__,
> +				readl(ssbi->base + SSBI2_STATUS));
> +			return -ETIMEDOUT;
> +		}
> +		udelay(1);
> +	}
> +
> +	return 0;
> +}
> +
> +static inline int
> +i2c_ssbi_poll_for_read_completed(struct i2c_ssbi_dev *ssbi)
> +{
> +	u32 timeout = SSBI_TIMEOUT_US;
> +
> +	while (!(readl(ssbi->base + SSBI2_STATUS)&  SSBI_STATUS_RD_READY)) {
> +		if (--timeout == 0) {
> +			dev_err(ssbi->dev, "%s: timeout, status %x\n", __func__,
> +				readl(ssbi->base + SSBI2_STATUS));
> +			return -ETIMEDOUT;
> +		}
> +		udelay(1);
> +	}
> +
> +	return 0;
> +}
> +
> +static inline int
> +i2c_ssbi_poll_for_transfer_completed(struct i2c_ssbi_dev *ssbi)
> +{
> +	u32 timeout = SSBI_TIMEOUT_US;
> +
> +	while ((readl(ssbi->base + SSBI2_STATUS)&  SSBI_STATUS_MCHN_BUSY)) {
> +		if (--timeout == 0) {
> +			dev_err(ssbi->dev, "%s: timeout, status %x\n", __func__,
> +				readl(ssbi->base + SSBI2_STATUS));
> +			return -ETIMEDOUT;
> +		}
> +		udelay(1);
> +	}
> +
> +	return 0;
> +}
> +
> +static int
> +i2c_ssbi_read_bytes(struct i2c_ssbi_dev *ssbi, struct i2c_msg *msg)
> +{
> +	int ret = 0;
> +	u8 *buf = msg->buf;
> +	u16 len = msg->len;
> +	u16 addr = msg->addr;
> +	u32 read_cmd = SSBI_CMD_READ(addr);
> +
> +	if (ssbi->controller_type == MSM_SBI_CTRL_SSBI2) {
> +		u32 mode2 = readl(ssbi->base + SSBI2_MODE2);
> +		writel(SSBI_MODE2_REG_ADDR_15_8(mode2, addr),
> +				ssbi->base + SSBI2_MODE2);
> +	}
> +
> +	while (len) {
> +		ret = i2c_ssbi_poll_for_device_ready(ssbi);
> +		if (ret)
> +			goto read_failed;
> +
> +		writel(read_cmd, ssbi->base + SSBI2_CMD);
> +
> +		ret = i2c_ssbi_poll_for_read_completed(ssbi);
> +		if (ret)
> +			goto read_failed;
> +
> +		*buf++ = readl(ssbi->base + SSBI2_RD)&  SSBI_RD_REG_DATA_MASK;
> +		len--;
> +	}
> +
> +read_failed:
> +	return ret;
> +}
> +
> +static int
> +i2c_ssbi_write_bytes(struct i2c_ssbi_dev *ssbi, struct i2c_msg *msg)
> +{
> +	int ret = 0;
> +	u8 *buf = msg->buf;
> +	u16 len = msg->len;
> +	u16 addr = msg->addr;
> +
> +	if (ssbi->controller_type == MSM_SBI_CTRL_SSBI2) {
> +		u32 mode2 = readl(ssbi->base + SSBI2_MODE2);
> +		writel(SSBI_MODE2_REG_ADDR_15_8(mode2, addr),
> +				ssbi->base + SSBI2_MODE2);
> +	}
> +
> +	while (len) {
> +		ret = i2c_ssbi_poll_for_device_ready(ssbi);
> +		if (ret)
> +			goto write_failed;
> +
> +		writel(SSBI_CMD_WRITE(addr, *buf++), ssbi->base + SSBI2_CMD);
> +
> +		ret = i2c_ssbi_poll_for_transfer_completed(ssbi);
> +		if (ret)
> +			goto write_failed;
> +
> +		len--;
> +	}
> +
> +write_failed:
> +	return ret;
> +}
> +
> +static inline int
> +i2c_ssbi_pa_transfer(struct i2c_ssbi_dev *ssbi, u32 cmd, u8 *data)
> +{
> +	u32 rd_status;
> +	u32 timeout = SSBI_TIMEOUT_US;
> +
> +	writel(cmd, ssbi->base + SSBI_PA_CMD);
> +	rd_status = readl(ssbi->base + SSBI_PA_RD_STATUS);
> +
> +	while ((rd_status&  (SSBI_PA_RD_STATUS_TRANS_COMPLETE)) == 0) {
> +
> +		if (--timeout == 0) {
> +			dev_err(ssbi->dev, "%s: timeout, status %x\n",
> +					__func__, rd_status);
> +			return -ETIMEDOUT;
> +		}
> +		udelay(1);
> +		rd_status = readl(ssbi->base + SSBI_PA_RD_STATUS);
> +	}
> +
> +	if (rd_status&  SSBI_PA_RD_STATUS_TRANS_DENIED) {
> +		dev_err(ssbi->dev, "%s: transaction denied, status %x\n",
> +				__func__, rd_status);
> +		return -EPERM;
> +	}
> +
> +	if (data)
> +		*data = (rd_status&  SSBI_PA_RD_STATUS_REG_DATA_MASK)>>
> +					SSBI_PA_CMD_REG_DATA_SHFT;
> +	return 0;
> +}
> +
> +static int
> +i2c_ssbi_pa_read_bytes(struct i2c_ssbi_dev *ssbi, struct i2c_msg *msg)
> +{
> +	int ret = 0;
> +	u8  data;
> +	u8 *buf = msg->buf;
> +	u16 len = msg->len;
> +	u32 read_cmd = (SSBI_PA_CMD_RDWRN | SSBI_PA_CMD_REG_ADDR(msg->addr));
> +
> +	while (len) {
> +
> +		ret = i2c_ssbi_pa_transfer(ssbi, read_cmd,&data);
> +		if (ret)
> +			goto read_failed;
> +
> +		*buf++ = data;
> +		len--;
> +	}
> +
> +read_failed:
> +	return ret;
> +}
> +
> +static int
> +i2c_ssbi_pa_write_bytes(struct i2c_ssbi_dev *ssbi, struct i2c_msg *msg)
> +{
> +	int ret = 0;
> +	u8 *buf = msg->buf;
> +	u16 len = msg->len;
> +	u32 addr = SSBI_PA_CMD_REG_ADDR(msg->addr);
> +
> +	while (len) {
> +
> +		u32 write_cmd = addr | (*buf++&  SSBI_PA_CMD_REG_DATA_MASK);
> +
> +		ret = i2c_ssbi_pa_transfer(ssbi, write_cmd, NULL);
> +		if (ret)
> +			goto write_failed;
> +		len--;
> +	}
> +
> +write_failed:
> +	return ret;
> +}
> +
> +static int
> +i2c_ssbi_transfer(struct i2c_adapter *adap, struct i2c_msg msgs[], int num)
> +{
> +	int ret = 0;
> +	int rem = num;
> +	struct i2c_ssbi_dev *ssbi = i2c_get_adapdata(adap);
> +
> +	while (rem) {
> +		if (msgs->flags&  I2C_M_RD) {
> +			ret = ssbi->read(ssbi, msgs);
> +			if (ret)
> +				goto transfer_failed;
> +		} else {
> +			ret = ssbi->write(ssbi, msgs);
> +			if (ret)
> +				goto transfer_failed;
> +		}
> +
> +		msgs++;
> +		rem--;
> +	}
> +
> +	return num;
> +
> +transfer_failed:
> +	return ret;
> +}
> +
> +static u32 i2c_ssbi_i2c_func(struct i2c_adapter *adap)
> +{
> +	return I2C_FUNC_I2C;
> +}
> +
> +static const struct i2c_algorithm msm_i2c_algo = {
> +	.master_xfer	= i2c_ssbi_transfer,
> +	.functionality	= i2c_ssbi_i2c_func,
> +};
> +
> +static int __devinit i2c_ssbi_probe(struct platform_device *pdev)
> +{
> +	int			 ret = 0;
> +	struct resource		*ssbi_res;
> +	struct i2c_ssbi_dev	*ssbi;
> +	struct msm_ssbi_platform_data *pdata;
> +
> +	pdata = pdev->dev.platform_data;
> +	if (!pdata) {
> +		ret = -ENXIO;
> +		dev_err(&pdev->dev, "platform data not initialized\n");
> +		goto err_probe_exit;
> +	}
> +
> +	ssbi = kzalloc(sizeof(struct i2c_ssbi_dev), GFP_KERNEL);
> +	if (!ssbi) {
> +		ret = -ENOMEM;
> +		dev_err(&pdev->dev, "allocation failed\n");
> +		goto err_probe_exit;
> +	}
> +
> +	ssbi_res = platform_get_resource_byname(pdev,
> +						IORESOURCE_MEM, "ssbi_base");
> +	if (!ssbi_res) {
> +		ret = -ENXIO;
> +		dev_err(&pdev->dev, "get_resource_byname failed\n");
> +		goto err_probe_res;
> +	}
> +
> +	ssbi->mem_phys_addr = ssbi_res->start;
> +	ssbi->mem_size = resource_size(ssbi_res);
> +	if (!request_mem_region(ssbi->mem_phys_addr, ssbi->mem_size,
> +				SSBI_MSM_NAME)) {
> +		ret = -ENXIO;
> +		dev_err(&pdev->dev, "request_mem_region failed\n");
> +		goto err_probe_reqmem;
> +	}
> +
> +	ssbi->base = ioremap(ssbi->mem_phys_addr, ssbi->mem_size);
> +	if (!ssbi->base) {
> +		dev_err(&pdev->dev, "ioremap failed\n");
> +		goto err_probe_ioremap;
> +	}
> +
> +	ssbi->dev =&pdev->dev;
> +	platform_set_drvdata(pdev, ssbi);
> +
> +	ssbi->controller_type = pdata->controller_type;
> +	if (ssbi->controller_type == MSM_SBI_CTRL_PMIC_ARBITER) {
> +		ssbi->read = i2c_ssbi_pa_read_bytes;
> +		ssbi->write = i2c_ssbi_pa_write_bytes;
> +	} else {
> +		ssbi->read = i2c_ssbi_read_bytes;
> +		ssbi->write = i2c_ssbi_write_bytes;
> +	}
> +
> +	i2c_set_adapdata(&ssbi->adapter, ssbi);
> +	ssbi->adapter.algo =&msm_i2c_algo;
> +	strlcpy(ssbi->adapter.name,
> +		"MSM SSBI adapter",
> +		sizeof(ssbi->adapter.name));
> +
> +	ssbi->adapter.nr = pdev->id;
> +	ret = i2c_add_numbered_adapter(&ssbi->adapter);
> +	if (ret) {
> +		dev_err(&pdev->dev, "i2c_add_numbered_adapter failed\n");
> +		goto err_add_adapter_failed;
> +	}
> +	return 0;
> +
> +err_add_adapter_failed:
> +	iounmap(ssbi->base);
> +	platform_set_drvdata(pdev, NULL);
> +err_probe_ioremap:
> +	release_mem_region(ssbi->mem_phys_addr, ssbi->mem_size);
> +err_probe_reqmem:
> +err_probe_res:
> +	kfree(ssbi);
> +err_probe_exit:
> +	return ret;
> +}
> +
> +static int __devexit i2c_ssbi_remove(struct platform_device *pdev)
> +{
> +	struct i2c_ssbi_dev *ssbi = platform_get_drvdata(pdev);
> +
> +	platform_set_drvdata(pdev, NULL);
> +	i2c_del_adapter(&ssbi->adapter);
> +	iounmap(ssbi->base);
> +	release_mem_region(ssbi->mem_phys_addr, ssbi->mem_size);
> +	kfree(ssbi);
> +	return 0;
> +}
> +
> +static struct platform_driver i2c_ssbi_driver = {
> +	.probe          = i2c_ssbi_probe,
> +	.driver		= {
> +		.name	= "i2c_ssbi",
> +		.owner	= THIS_MODULE,
> +	},
> +	.remove		= __devexit_p(i2c_ssbi_remove),
> +};
> +
> +static int __init i2c_ssbi_init(void)
> +{
> +	return platform_driver_register(&i2c_ssbi_driver);
> +}
> +arch_initcall(i2c_ssbi_init);
> +
> +static void __exit i2c_ssbi_exit(void)
> +{
> +	platform_driver_unregister(&i2c_ssbi_driver);
> +}
> +module_exit(i2c_ssbi_exit);
> diff --git a/include/linux/i2c-ssbi.h b/include/linux/i2c-ssbi.h
> new file mode 100755
> index 0000000..75386d5
> --- /dev/null
> +++ b/include/linux/i2c-ssbi.h
> @@ -0,0 +1,33 @@
> +/*
> + * Qualcomm MSM i2c Controller Platform Data
> + *
> + * Copyright (c) 2010, Code Aurora Forum. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 and
> + * only version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
> + * 02110-1301, USA.
> + */
> +#ifndef __LINUX_I2C_SSBI_H
> +#define __LINUX_I2C_SSBI_H
> +
> +enum msm_ssbi_controller_type {
> +	MSM_SBI_CTRL_SSBI = 0,
> +	MSM_SBI_CTRL_SSBI2,
> +	MSM_SBI_CTRL_PMIC_ARBITER,
> +};
> +
> +struct msm_ssbi_platform_data {
> +	enum msm_ssbi_controller_type controller_type;
> +};
> +
> +#endif /* __LINUX_I2C_SSBI_H */


-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
