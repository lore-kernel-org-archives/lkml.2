Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484Ab1BYCXx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 21:23:53 -0500
Received: from fifo99.com ([67.223.236.141]:55535 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751760Ab1BYCXv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 21:23:51 -0500
Subject: Re: [PATCH v2 2/2] msm: add single-wire serial bus interface
 (SSBI) driver
From: Daniel Walker <dwalker@fifo99.com>
To: Kenneth Heitke <kheitke@codeaurora.org>
Cc: davidb@codeaurora.org, dima@android.com, linux-arm-msm@vger.kernel.org,
        tsoni@codeaurora.org, linux-arm-kernel@lists.infradead.org,
        swetland@google.com, open list <linux-kernel@vger.kernel.org>
In-Reply-To: <1298585954-22422-3-git-send-email-kheitke@codeaurora.org>
References: <1298585954-22422-1-git-send-email-kheitke@codeaurora.org>
	 <1298585954-22422-3-git-send-email-kheitke@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Feb 2011 18:23:41 -0800
Message-ID: <1298600621.17118.27.camel@m0nster>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


You have some submission problems. one is that the subject should be
"drivers: msm: ..." , this patch also shouldn't go to David.

On Thu, 2011-02-24 at 15:19 -0700, Kenneth Heitke wrote:
> SSBI is the Qualcomm single-wire serial bus interface used to connect
> the MSM devices to the PMIC and other devices.
> 
> Since SSBI only supports a single slave, the driver gets the name of the
> slave device passed in from the board file through the master device's
> platform data.
> 
> SSBI registers pretty early (postcore), so that the PMIC can come up
> before the board init. This is useful if the board init requires the
> use of gpios that are connected through the PMIC.
> 
> Based on a patch by Dima Zavin <dima@android.com> that can be found at:
> http://android.git.kernel.org/?p=kernel/msm.git;a=commitdiff;h=eb060bac4

I don't really like links in the commit text, cause as soon as Google
deletes this tree the link is worthless.

> This patch adds PMIC Arbiter support for the MSM8660. The PMIC Arbiter
> is a hardware wrapper around the SSBI 2.0 controller that is designed to
> overcome concurrency issues and security limitations.  A controller_type
> field is added to the platform data to specify the type of the SSBI
> controller (1.0, 2.0, or PMIC Arbiter).
> 
> Signed-off-by: Kenneth Heitke <kheitke@codeaurora.org>
> ---
>  drivers/Kconfig          |    2 +
>  drivers/Makefile         |    1 +
>  drivers/msm/Kconfig      |   13 ++
>  drivers/msm/Makefile     |    4 +
>  drivers/msm/ssbi.c       |  376 ++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/msm_ssbi.h |   49 ++++++
>  6 files changed, 445 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/msm/Kconfig
>  create mode 100644 drivers/msm/Makefile
>  create mode 100644 drivers/msm/ssbi.c
>  create mode 100644 include/linux/msm_ssbi.h
> 
> diff --git a/drivers/Kconfig b/drivers/Kconfig
> index 9bfb71f..fceeb20 100644
> --- a/drivers/Kconfig
> +++ b/drivers/Kconfig
> @@ -117,4 +117,6 @@ source "drivers/staging/Kconfig"
>  source "drivers/platform/Kconfig"
>  
>  source "drivers/clk/Kconfig"
> +
> +source "drivers/msm/Kconfig"
>  endmenu
> diff --git a/drivers/Makefile b/drivers/Makefile
> index b423bb1..14cb94b 100644
> --- a/drivers/Makefile
> +++ b/drivers/Makefile
> @@ -117,3 +117,4 @@ obj-y				+= platform/
>  obj-y				+= ieee802154/
>  #common clk code
>  obj-y				+= clk/
> +obj-y				+= msm/
> diff --git a/drivers/msm/Kconfig b/drivers/msm/Kconfig
> new file mode 100644
> index 0000000..413bb65
> --- /dev/null
> +++ b/drivers/msm/Kconfig
> @@ -0,0 +1,13 @@
> +menu "Qualcomm MSM specific device drivers"
> +	depends on ARCH_MSM
> +
> +config MSM_SSBI
> +	bool "Qualcomm Single-wire Serial Bus Interface (SSBI)"
> +	help
> +	  If you say yes to this option, support will be included for the
> +	  built-in SSBI interface on Qualcomm MSM family processors.
> +
> +	  This is required for communicating with Qualcomm PMICs and
> +	  other devices that have the SSBI interface.
> +
> +endmenu
> diff --git a/drivers/msm/Makefile b/drivers/msm/Makefile
> new file mode 100644
> index 0000000..ea8c1e4
> --- /dev/null
> +++ b/drivers/msm/Makefile
> @@ -0,0 +1,4 @@
> +#
> +# Makefile for the MSM specific device drivers.
> +#
> +obj-$(CONFIG_MSM_SSBI) += ssbi.o
> diff --git a/drivers/msm/ssbi.c b/drivers/msm/ssbi.c
> new file mode 100644
> index 0000000..1fae443
> --- /dev/null
> +++ b/drivers/msm/ssbi.c
> @@ -0,0 +1,376 @@
> +/* Copyright (c) 2009-2011, Code Aurora Forum. All rights reserved.
> + * Copyright (c) 2010, Google Inc.
> + *
> + * Original authors: Code Aurura Forum

Spelling problem.

> + * Author: Dima Zavin <dima@android.com>
> + *  - Largely rewritten from original to not be an i2c driver.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 and
> + * only version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/delay.h>
> +#include <linux/err.h>
> +#include <linux/io.h>
> +#include <linux/kernel.h>
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> +#include <linux/msm_ssbi.h>
> +
> +/* SSBI 2.0 controller registers */
> +#define SSBI2_CMD			0x0008
> +#define SSBI2_RD			0x0010
> +#define SSBI2_STATUS			0x0014
> +#define SSBI2_MODE2			0x001C
> +
> +/* SSBI_CMD fields */
> +#define SSBI_CMD_RDWRN			(1 << 24)
> +
> +/* SSBI_STATUS fields */
> +#define SSBI_STATUS_RD_READY		(1 << 2)
> +#define SSBI_STATUS_READY		(1 << 1)
> +#define SSBI_STATUS_MCHN_BUSY		(1 << 0)
> +
> +/* SSBI_MODE2 fields */
> +#define SSBI_MODE2_REG_ADDR_15_8_SHFT	0x04
> +#define SSBI_MODE2_REG_ADDR_15_8_MASK	(0x7f << SSBI_MODE2_REG_ADDR_15_8_SHFT)
> +
> +#define SET_SSBI_MODE2_REG_ADDR_15_8(MD, AD) \
> +	(((MD) & 0x0F) | ((((AD) >> 8) << SSBI_MODE2_REG_ADDR_15_8_SHFT) & \
> +	SSBI_MODE2_REG_ADDR_15_8_MASK))
> +
> +/* SSBI PMIC Arbiter command registers */
> +#define SSBI_PA_CMD			0x0000
> +#define SSBI_PA_RD_STATUS		0x0004
> +
> +/* SSBI_PA_CMD fields */
> +#define SSBI_PA_CMD_RDWRN		(1 << 24)
> +
> +/* SSBI_PA_RD_STATUS fields */
> +#define SSBI_PA_RD_STATUS_TRANS_DONE	(1 << 27)
> +#define SSBI_PA_RD_STATUS_TRANS_DENIED	(1 << 26)
> +
> +#define SSBI_TIMEOUT_US			100
> +
> +struct msm_ssbi {
> +	struct device		*dev;
> +	struct device		*slave;
> +	void __iomem		*base;
> +	spinlock_t		lock;
> +	enum msm_ssbi_controller_type controller_type;
> +	int (*read)(struct msm_ssbi *, u16 addr, u8 *buf, int len);
> +	int (*write)(struct msm_ssbi *, u16 addr, u8 *buf, int len);
> +};
> +
> +#define to_msm_ssbi(dev)	platform_get_drvdata(to_platform_device(dev))
> +
> +static inline u32 ssbi_readl(struct msm_ssbi *ssbi, u32 reg)
> +{
> +	return readl(ssbi->base + reg);
> +}
> +
> +static inline void ssbi_writel(struct msm_ssbi *ssbi, u32 val, u32 reg)
> +{
> +	writel(val, ssbi->base + reg);
> +}
> +
> +static int ssbi_wait_mask(struct msm_ssbi *ssbi, u32 set_mask, u32 clr_mask)
> +{
> +	u32 timeout = SSBI_TIMEOUT_US;
> +	u32 val;
> +
> +	while (timeout--) {
> +		val = ssbi_readl(ssbi, SSBI2_STATUS);
> +		if (((val & set_mask) == set_mask) && ((val & clr_mask) == 0))
> +			return 0;
> +		udelay(1);
> +	}
> +
> +	dev_err(ssbi->dev, "%s: timeout (status %x set_mask %x clr_mask %x)\n",
> +		__func__, ssbi_readl(ssbi, SSBI2_STATUS), set_mask, clr_mask);
> +	return -ETIMEDOUT;
> +}
> +
> +static int
> +msm_ssbi_read_bytes(struct msm_ssbi *ssbi, u16 addr, u8 *buf, int len)
> +{
> +	u32 cmd = SSBI_CMD_RDWRN | ((addr & 0xff) << 16);
> +	int ret = 0;
> +
> +	if (ssbi->controller_type == MSM_SBI_CTRL_SSBI2) {
> +		u32 mode2 = ssbi_readl(ssbi, SSBI2_MODE2);
> +		mode2 = SET_SSBI_MODE2_REG_ADDR_15_8(mode2, addr);
> +		ssbi_writel(ssbi, mode2, SSBI2_MODE2);
> +	}
> +
> +	while (len) {
> +		ret = ssbi_wait_mask(ssbi, SSBI_STATUS_READY, 0);
> +		if (ret)
> +			goto err;
> +
> +		ssbi_writel(ssbi, cmd, SSBI2_CMD);
> +		ret = ssbi_wait_mask(ssbi, SSBI_STATUS_RD_READY, 0);
> +		if (ret)
> +			goto err;
> +		*buf++ = ssbi_readl(ssbi, SSBI2_RD) & 0xff;
> +		len--;
> +	}
> +
> +err:
> +	return ret;
> +}
> +
> +static int
> +msm_ssbi_write_bytes(struct msm_ssbi *ssbi, u16 addr, u8 *buf, int len)
> +{
> +	int ret = 0;
> +
> +	if (ssbi->controller_type == MSM_SBI_CTRL_SSBI2) {
> +		u32 mode2 = ssbi_readl(ssbi, SSBI2_MODE2);
> +		mode2 = SET_SSBI_MODE2_REG_ADDR_15_8(mode2, addr);
> +		ssbi_writel(ssbi, mode2, SSBI2_MODE2);
> +	}
> +
> +	while (len) {
> +		ret = ssbi_wait_mask(ssbi, SSBI_STATUS_READY, 0);
> +		if (ret)
> +			goto err;
> +
> +		ssbi_writel(ssbi, ((addr & 0xff) << 16) | *buf, SSBI2_CMD);
> +		ret = ssbi_wait_mask(ssbi, 0, SSBI_STATUS_MCHN_BUSY);
> +		if (ret)
> +			goto err;
> +		buf++;
> +		len--;
> +	}
> +
> +err:
> +	return ret;
> +}
> +
> +static inline int
> +msm_ssbi_pa_transfer(struct msm_ssbi *ssbi, u32 cmd, u8 *data)
> +{
> +	u32 timeout = SSBI_TIMEOUT_US;
> +	u32 rd_status = 0;
> +
> +	ssbi_writel(ssbi, cmd, SSBI_PA_CMD);
> +
> +	while (timeout--) {
> +		rd_status = ssbi_readl(ssbi, SSBI_PA_RD_STATUS);
> +
> +		if (rd_status & SSBI_PA_RD_STATUS_TRANS_DENIED) {
> +			dev_err(ssbi->dev, "%s: transaction denied (0x%x)\n",
> +					__func__, rd_status);
> +			return -EPERM;
> +		}
> +
> +		if (rd_status & SSBI_PA_RD_STATUS_TRANS_DONE) {
> +			if (data)
> +				*data = rd_status & 0xff;
> +			return 0;
> +		}
> +		udelay(1);
> +	}
> +
> +	dev_err(ssbi->dev, "%s: timeout, status 0x%x\n", __func__, rd_status);
> +	return -ETIMEDOUT;
> +}
> +
> +static int
> +msm_ssbi_pa_read_bytes(struct msm_ssbi *ssbi, u16 addr, u8 *buf, int len)
> +{
> +	u32 cmd;
> +	int ret = 0;
> +
> +	cmd = SSBI_PA_CMD_RDWRN | (addr & 0x3fff) << 8;
> +
> +	while (len) {
> +		ret = msm_ssbi_pa_transfer(ssbi, cmd, buf);
> +		if (ret)
> +			goto err;
> +		buf++;
> +		len--;
> +	}
> +
> +err:
> +	return ret;
> +}
> +
> +static int
> +msm_ssbi_pa_write_bytes(struct msm_ssbi *ssbi, u16 addr, u8 *buf, int len)
> +{
> +	u32 cmd;
> +	int ret = 0;
> +
> +	while (len) {
> +		cmd = (addr & 0x3fff) << 8 | *buf;
> +		ret = msm_ssbi_pa_transfer(ssbi, cmd, NULL);
> +		if (ret)
> +			goto err;
> +		buf++;
> +		len--;
> +	}
> +
> +err:
> +	return ret;
> +}
> +
> +int msm_ssbi_read(struct device *dev, u16 addr, u8 *buf, int len)
> +{
> +	struct msm_ssbi *ssbi = to_msm_ssbi(dev);
> +	unsigned long flags;
> +	int ret;
> +
> +	BUG_ON(ssbi->dev != dev);

Are you sure you don't just want to bail out here, cause this hangs the
system when it triggers?

> +	spin_lock_irqsave(&ssbi->lock, flags);
> +	ret = ssbi->read(ssbi, addr, buf, len);
> +	spin_unlock_irqrestore(&ssbi->lock, flags);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(msm_ssbi_read);
> +
> +int msm_ssbi_write(struct device *dev, u16 addr, u8 *buf, int len)
> +{
> +	struct msm_ssbi *ssbi = to_msm_ssbi(dev);
> +	unsigned long flags;
> +	int ret;
> +
> +	BUG_ON(ssbi->dev != dev);
> +
> +	spin_lock_irqsave(&ssbi->lock, flags);
> +	ret = ssbi->write(ssbi, addr, buf, len);
> +	spin_unlock_irqrestore(&ssbi->lock, flags);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(msm_ssbi_write);
> +
> +static int __devinit msm_ssbi_add_slave(struct msm_ssbi *ssbi,
> +				     const struct msm_ssbi_slave_info *slave)
> +{
> +	struct platform_device *slave_pdev;
> +	int ret;
> +
> +	if (ssbi->slave) {
> +		pr_err("%s: slave already attached??\n", __func__);
> +		return -EBUSY;

You can use a pr_fmt line to add the __func__ part, look in mach-msm for
examples.

> +	}
> +
> +	slave_pdev = platform_device_alloc(slave->name, -1);
> +	if (!slave_pdev) {
> +		pr_err("%s: cannot allocate pdev for slave '%s'", __func__,
> +		       slave->name);
> +		ret = -ENOMEM;
> +		goto err;
> +	}
> +
> +	slave_pdev->dev.parent = ssbi->dev;
> +	slave_pdev->dev.platform_data = slave->platform_data;
> +
> +	ret = platform_device_add(slave_pdev);
> +	if (ret) {
> +		pr_err("%s: cannot add slave platform device for '%s'\n",
> +		       __func__, slave->name);
> +		goto err;
> +	}
> +
> +	ssbi->slave = &slave_pdev->dev;
> +	return 0;
> +
> +err:
> +	if (slave_pdev)
> +		platform_device_put(slave_pdev);
> +	return ret;
> +}
> +
> +static int __devinit msm_ssbi_probe(struct platform_device *pdev)
> +{
> +	const struct msm_ssbi_platform_data *pdata = pdev->dev.platform_data;
> +	struct resource *mem_res;
> +	struct msm_ssbi *ssbi;
> +	int ret = 0;
> +
> +	printk(KERN_INFO "%s: %s\n", __func__, pdata->slave.name);

pr_info() ?

Daniel

