Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509Ab2K0Naj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 08:30:39 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:32822 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753233Ab2K0Nah (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 08:30:37 -0500
Date: Tue, 27 Nov 2012 15:23:36 +0200
From: Felipe Balbi <balbi@ti.com>
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
CC: <linux-arm-kernel@lists.infradead.org>,
        <linux-samsung-soc@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-i2c@vger.kernel.org>,
        <naveenkrishna.ch@gmail.com>, <kgene.kim@samsung.com>,
        <grant.likely@secretlab.ca>, <w.sang@pengutronix.de>,
        <linux-kernel@vger.kernel.org>, <taeggyun.ko@samsung.com>
Subject: Re: [PATCH 1/3] i2c: exynos5: add High Speed I2C controller driver
Message-ID: <20121127132336.GB22556@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1354021236-28596-1-git-send-email-ch.naveen@samsung.com>
 <1354021236-28596-2-git-send-email-ch.naveen@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qcHopEYAB45HaUaB"
Content-Disposition: inline
In-Reply-To: <1354021236-28596-2-git-send-email-ch.naveen@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--qcHopEYAB45HaUaB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Nov 27, 2012 at 06:30:34PM +0530, Naveen Krishna Chatradhi wrote:
> diff --git a/drivers/i2c/busses/i2c-exynos5.c b/drivers/i2c/busses/i2c-ex=
ynos5.c
> new file mode 100644
> index 0000000..5983aa9
> --- /dev/null
> +++ b/drivers/i2c/busses/i2c-exynos5.c
> @@ -0,0 +1,758 @@
> +/* linux/drivers/i2c/busses/i2c-exynos5.c
> + *
> + * Copyright (C) 2012 Samsung Electronics Co., Ltd.
> + *
> + * Exynos5 series High Speed I2C controller driver
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> +*/
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +
> +#include <linux/i2c.h>
> +#include <linux/init.h>
> +#include <linux/time.h>
> +#include <linux/interrupt.h>
> +#include <linux/delay.h>
> +#include <linux/errno.h>
> +#include <linux/err.h>
> +#include <linux/platform_device.h>
> +#include <linux/clk.h>
> +#include <linux/slab.h>
> +#include <linux/io.h>
> +#include <linux/of_i2c.h>
> +#include <linux/of_gpio.h>
> +
> +#include <asm/irq.h>

are you sure you want to include this header ? Just making sure...

> +#include "i2c-exynos5.h"
> +
> +#define HSI2C_POLLING 0
> +#define HSI2C_FAST_SPD 0
> +#define HSI2C_HIGH_SPD 1
> +
> +/* Max time to wait for bus to become idle after a xfer */
> +#define EXYNOS5_I2C_TIMEOUT (msecs_to_jiffies(1000))
> +
> +struct exynos5_i2c {
> +	unsigned int		suspended:1;
> +
> +	struct i2c_msg		*msg;
> +	struct completion	msg_complete;
> +	unsigned int		msg_byte_ptr;
> +
> +	unsigned int		irq;
> +
> +	void __iomem		*regs;
> +	struct clk		*clk;
> +	struct device		*dev;
> +	struct resource		*ioarea;

you don't need to save the struct resource here, see more below.

> +	struct i2c_adapter	adap;

I would put this as the first memeber of the structure, so that a
container_of() gets optmized into a cast.

> +	unsigned int		bus_number;
> +	unsigned int		speed_mode;
> +	unsigned int		fast_speed;
> +	unsigned int		high_speed;
> +	int			operation_mode;
> +	int			gpios[2];
> +};
> +
> +static struct platform_device_id exynos5_driver_ids[] =3D {
> +	{
> +		.name		=3D "exynos5-hs-i2c",
> +		.driver_data	=3D 0,

no need to zero-initialize.

> +	}, { },
> +};
> +MODULE_DEVICE_TABLE(platform, exynos5_driver_ids);
> +
> +#ifdef CONFIG_OF
> +static const struct of_device_id exynos5_i2c_match[] =3D {
> +	{ .compatible =3D "samsung,exynos5-hs-i2c", .data =3D (void *)0 },

remove the (void *)0 initialization. the variable is static and will be
zero-initialized.

> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, exynos5_i2c_match);
> +#endif
> +
> +static inline void dump_i2c_register(struct exynos5_i2c *i2c)
> +{
> +	dev_dbg(i2c->dev, "Register dump(%d) :\n %x\n %x\n %x\n %x\n"
> +		" %x\n %x\n %x\n %x\n %x\n"
> +		" %x\n %x\n %x\n %x\n %x\n"
> +		" %x\n %x\n %x\n %x\n %x\n"
> +		" %x\n %x\n %x\n %x\n %x\n"
> +		, i2c->suspended
> +		, readl(i2c->regs + HSI2C_CTL)
> +		, readl(i2c->regs + HSI2C_FIFO_CTL)
> +		, readl(i2c->regs + HSI2C_TRAILIG_CTL)
> +		, readl(i2c->regs + HSI2C_CLK_CTL)
> +		, readl(i2c->regs + HSI2C_CLK_SLOT)
> +		, readl(i2c->regs + HSI2C_INT_ENABLE)
> +		, readl(i2c->regs + HSI2C_INT_STATUS)
> +		, readl(i2c->regs + HSI2C_ERR_STATUS)
> +		, readl(i2c->regs + HSI2C_FIFO_STATUS)
> +		, readl(i2c->regs + HSI2C_TX_DATA)
> +		, readl(i2c->regs + HSI2C_RX_DATA)
> +		, readl(i2c->regs + HSI2C_CONF)
> +		, readl(i2c->regs + HSI2C_AUTO_CONFING)
> +		, readl(i2c->regs + HSI2C_TIMEOUT)
> +		, readl(i2c->regs + HSI2C_MANUAL_CMD)
> +		, readl(i2c->regs + HSI2C_TRANS_STATUS)
> +		, readl(i2c->regs + HSI2C_TIMING_HS1)
> +		, readl(i2c->regs + HSI2C_TIMING_HS2)
> +		, readl(i2c->regs + HSI2C_TIMING_HS3)
> +		, readl(i2c->regs + HSI2C_TIMING_FS1)
> +		, readl(i2c->regs + HSI2C_TIMING_FS2)
> +		, readl(i2c->regs + HSI2C_TIMING_FS3)
> +		, readl(i2c->regs + HSI2C_TIMING_SLA)
> +		, readl(i2c->regs + HSI2C_ADDR));
> +}

I would make this dev_vdbg() since this is really only needed when
something is terribly wrong. In fact, I don't like these big register
dump functions in code. To me that's something that should be done on
debugfs.

Also, your comma character placement is a bit weird. Usually it goes to
end of the line, not to the beginning of the next.

> +static inline void exynos5_i2c_stop(struct exynos5_i2c *i2c)
> +{
> +	writel(0, i2c->regs + HSI2C_INT_ENABLE);
> +
> +	complete(&i2c->msg_complete);
> +}
> +
> +static inline void exynos5_disable_irq(struct exynos5_i2c *i2c)
> +{
> +	unsigned long tmp =3D readl(i2c->regs + HSI2C_INT_STATUS);
> +
> +	writel(tmp, i2c->regs +  HSI2C_INT_STATUS);
> +}
> +
> +static void exynos5_i2c_en_timeout(struct exynos5_i2c *i2c)
> +{
> +	unsigned long i2c_timeout =3D readl(i2c->regs + HSI2C_TIMEOUT);
> +
> +	/* Clear to enable Timeout */
> +	i2c_timeout &=3D ~HSI2C_TIMEOUT_EN;
> +	writel(i2c_timeout, i2c->regs + HSI2C_TIMEOUT);
> +}
> +
> +static irqreturn_t exynos5_i2c_irq(int irqno, void *dev_id)
> +{
> +	struct exynos5_i2c *i2c =3D dev_id;
> +	unsigned char byte;
> +
> +	if (i2c->msg->flags & I2C_M_RD) {
> +		while ((readl(i2c->regs + HSI2C_FIFO_STATUS) &
> +			0x1000000) =3D=3D 0) {
> +			byte =3D (unsigned char)readl(i2c->regs + HSI2C_RX_DATA);
> +			i2c->msg->buf[i2c->msg_byte_ptr++] =3D byte;
> +		}
> +
> +		if (i2c->msg_byte_ptr >=3D i2c->msg->len)
> +			exynos5_i2c_stop(i2c);
> +	} else {
> +		byte =3D i2c->msg->buf[i2c->msg_byte_ptr++];
> +		writel(byte, i2c->regs + HSI2C_TX_DATA);
> +
> +		if (i2c->msg_byte_ptr >=3D i2c->msg->len)
> +			exynos5_i2c_stop(i2c);
> +	}

you never check which event generated the IRQ. Why don't you use
register address 0x24 ??

> +	exynos5_disable_irq(i2c);

why are you masking IRQs here ?

> +
> +	return IRQ_HANDLED;
> +}
> +
> +static int exynos5_i2c_init(struct exynos5_i2c *i2c);
> +
> +static int exynos5_i2c_reset(struct exynos5_i2c *i2c)
> +{
> +	unsigned long usi_ctl;
> +
> +	usi_ctl =3D readl(i2c->regs + HSI2C_CTL);
> +	usi_ctl |=3D (1u << 31);
> +	writel(usi_ctl, i2c->regs + HSI2C_CTL);
> +	usi_ctl =3D readl(i2c->regs + HSI2C_CTL);
> +	usi_ctl &=3D ~(1u << 31);
> +	writel(usi_ctl, i2c->regs + HSI2C_CTL);
> +	exynos5_i2c_init(i2c);
> +
> +	return 0;
> +}
> +
> +static int exynos5_i2c_xfer_msg(struct exynos5_i2c *i2c,
> +			      struct i2c_msg *msgs, int num, int stop)

this "num" argument is useless.

> +{
> +	unsigned long timeout;
> +	unsigned long trans_status;
> +	unsigned long usi_fifo_stat;
> +	unsigned long usi_ctl;
> +	unsigned long i2c_auto_conf;
> +	unsigned long i2c_addr;
> +	unsigned long usi_int_en;
> +	unsigned long usi_fifo_ctl;
> +	unsigned char byte;
> +	int ret =3D 0;
> +	int operation_mode =3D i2c->operation_mode;
> +
> +	i2c->msg =3D msgs;
> +	i2c->msg_byte_ptr =3D 0;
> +
> +	init_completion(&i2c->msg_complete);

actually, init_completion() should be done on your probe(). Here you
should be calling INIT_COMPLETION() instead.

> +	usi_ctl		=3D readl(i2c->regs + HSI2C_CTL);
> +	i2c_auto_conf	=3D readl(i2c->regs + HSI2C_AUTO_CONFING);

do you really need to read these two registers ? You're programming a
new transfer, meaning that you're likely to change the entire
register...

> +	exynos5_i2c_en_timeout(i2c);
> +
> +	/* Set default trigger level for TXFIFO and RXFIFO */
> +	usi_fifo_ctl =3D HSI2C_TXFIFO_TRIGGER_LEVEL |
> +					HSI2C_RXFIFO_TRIGGER_LEVEL;
> +	/* Enable RXFIFO and TXFIFO */
> +	usi_fifo_ctl =3D HSI2C_RXFIFO_EN | HSI2C_TXFIFO_EN;
> +
> +	writel(usi_fifo_ctl, i2c->regs + HSI2C_FIFO_CTL);
> +
> +	usi_int_en =3D 0;
> +	if (msgs->flags & I2C_M_RD) {
> +		usi_ctl &=3D ~HSI2C_TXCHON;
> +		usi_ctl |=3D HSI2C_RXCHON;
> +
> +		i2c_auto_conf |=3D HSI2C_READ_WRITE;
> +
> +		usi_int_en |=3D (HSI2C_INT_RX_ALMOSTFULL_EN |
> +					HSI2C_INT_TRAILING_EN);
> +	} else {
> +		usi_ctl &=3D ~HSI2C_RXCHON;
> +		usi_ctl |=3D HSI2C_TXCHON;
> +
> +		i2c_auto_conf &=3D ~HSI2C_READ_WRITE;
> +
> +		usi_int_en |=3D HSI2C_INT_TX_ALMOSTEMPTY_EN;
> +	}
> +
> +	if (stop =3D=3D 1)
> +		i2c_auto_conf |=3D HSI2C_STOP_AFTER_TRANS;
> +	else
> +		i2c_auto_conf &=3D ~HSI2C_STOP_AFTER_TRANS;

How about:

i2c_auto_conf |=3D stop ? HSI2C_STOP_AFTER_TRANS : 0; ??

> +
> +

one blank line only.

> +	i2c_addr =3D readl(i2c->regs + HSI2C_ADDR);

why do you need to read it ? Is there more information in this register
other than the address ???

> +	/* Clear Slave Address for I2C Master (Auto mode only) */
> +	i2c_addr &=3D ~(0x3ff << 10);
> +	/* Clear Slave Address for I2C Slave */
> +	i2c_addr &=3D ~(0x3ff << 0);
> +	/* Clear Master ID for I2C Master (Auto and HS mode only) */
> +	if (i2c->speed_mode =3D=3D HSI2C_HIGH_SPD)
> +		i2c_addr &=3D ~(0xff << 24);
> +
> +	i2c_addr |=3D ((msgs->addr & 0x7f) << 10);
> +	writel(i2c_addr, i2c->regs + HSI2C_ADDR);
> +
> +	writel(usi_ctl, i2c->regs + HSI2C_CTL);
> +
> +	/* Clear and set TRANS_LEN */
> +	i2c_auto_conf &=3D ~(0xffff);
> +	i2c_auto_conf |=3D i2c->msg->len;
> +	writel(i2c_auto_conf, i2c->regs + HSI2C_AUTO_CONFING);
> +
> +	/* Start data transfer in Master mode */
> +	i2c_auto_conf =3D readl(i2c->regs + HSI2C_AUTO_CONFING);
> +	i2c_auto_conf |=3D HSI2C_MASTER_RUN;
> +	writel(i2c_auto_conf, i2c->regs + HSI2C_AUTO_CONFING);
> +
> +	/* Enable appropriate interrupts */
> +	if (operation_mode !=3D HSI2C_POLLING)
> +		writel(usi_int_en, i2c->regs + HSI2C_INT_ENABLE);
> +
> +	ret =3D -EAGAIN;
> +	if (msgs->flags & I2C_M_RD) {
> +		if (operation_mode =3D=3D HSI2C_POLLING) {

why do you want to support polling ? Do you really have situations where
IRQ wouldn't cut it ?

> +			timeout =3D jiffies + EXYNOS5_I2C_TIMEOUT;
> +			while (time_before(jiffies, timeout)) {
> +				if ((readl(i2c->regs + HSI2C_FIFO_STATUS) &
> +					0x1000000) =3D=3D 0) {

no magic constants, please.

> +					byte =3D (unsigned char)readl
> +						(i2c->regs + HSI2C_RX_DATA);
> +					i2c->msg->buf[i2c->msg_byte_ptr++]
> +						=3D byte;
> +				}
> +
> +				if (i2c->msg_byte_ptr >=3D i2c->msg->len) {
> +					ret =3D 0;
> +					break;
> +				}
> +			}
> +
> +			if (ret =3D=3D -EAGAIN) {

you can avoid this (and the above initialization of ret to -EAGAIN) if
you reorder this code a little bit.

> +				exynos5_i2c_reset(i2c);
> +				dev_warn(i2c->dev, "rx timeout\n");
> +				return ret;
> +			}
> +		} else {
> +			timeout =3D wait_for_completion_interruptible_timeout
> +				(&i2c->msg_complete, EXYNOS5_I2C_TIMEOUT);
> +
> +			if (timeout =3D=3D 0) {
> +				exynos5_i2c_reset(i2c);
> +				dev_warn(i2c->dev, "rx timeout\n");
> +				return ret;
> +			}
> +
> +			ret =3D 0;
> +		}

if you really *must* support polling and IRQ modes, I suggest you
re-factor all of this into separate functions so that your code looks
like:

if (operation_mode =3D=3D HSI2C_POLLING)
	ret =3D exynos5_i2c_xfer_msg_polling(i2c, msgs, stop,
		msg->flags & I2C_M_RD);
else
	ret =3D exynos5_i2c_xfer_msg_irq(i2c, msgs, stop,
		msg->flags & I2C_M_RD);

> +	} else {
> +		if (operation_mode =3D=3D HSI2C_POLLING) {
> +			timeout =3D jiffies + EXYNOS5_I2C_TIMEOUT;
> +			while (time_before(jiffies, timeout) &&
> +				(i2c->msg_byte_ptr < i2c->msg->len)) {
> +				if ((readl(i2c->regs + HSI2C_FIFO_STATUS)
> +					& 0x7f) < 64) {
> +					byte =3D i2c->msg->buf
> +						[i2c->msg_byte_ptr++];
> +					writel(byte,
> +						i2c->regs + HSI2C_TX_DATA);
> +				}
> +			}
> +		} else {
> +			timeout =3D wait_for_completion_interruptible_timeout
> +				(&i2c->msg_complete, EXYNOS5_I2C_TIMEOUT);
> +
> +			if (timeout =3D=3D 0) {
> +				exynos5_i2c_reset(i2c);
> +				dev_warn(i2c->dev, "tx timeout\n");
> +				return ret;
> +			}
> +
> +			timeout =3D jiffies + timeout;
> +		}
> +		while (time_before(jiffies, timeout)) {
> +			usi_fifo_stat =3D readl(i2c->regs + HSI2C_FIFO_STATUS);
> +			trans_status =3D readl(i2c->regs + HSI2C_TRANS_STATUS);
> +			if ((usi_fifo_stat =3D=3D HSI2C_FIFO_EMPTY) &&
> +				((trans_status =3D=3D 0) ||
> +				((stop =3D=3D 0) &&
> +				(trans_status =3D=3D 0x20000)))) {
> +				ret =3D 0;
> +				break;
> +			}
> +		}
> +		if (ret =3D=3D -EAGAIN) {
> +			exynos5_i2c_reset(i2c);
> +			dev_warn(i2c->dev, "tx timeout\n");
> +			return ret;
> +		}
> +	}
> +
> +	return ret;
> +}
> +
> +static int exynos5_i2c_xfer(struct i2c_adapter *adap,
> +			struct i2c_msg *msgs, int num)
> +{
> +	struct exynos5_i2c *i2c =3D (struct exynos5_i2c *)adap->algo_data;
> +	int retry, i;
> +	int ret;
> +	int stop =3D 0;
> +	struct i2c_msg *msgs_ptr =3D msgs;
> +
> +	if (i2c->suspended) {
> +		dev_err(i2c->dev, "HS-I2C is not initialzed.\n");
> +		return -EIO;
> +	}
> +
> +	clk_prepare_enable(i2c->clk);
> +
> +	for (retry =3D 0; retry < adap->retries; retry++) {
> +		for (i =3D 0; i < num; i++) {
> +			if (i =3D=3D num - 1)
> +				stop =3D 1;
> +			ret =3D exynos5_i2c_xfer_msg(i2c, msgs_ptr, 1, stop);
> +			msgs_ptr++;
> +
> +			if (ret =3D=3D -EAGAIN) {
> +				msgs_ptr =3D msgs;
> +				stop =3D 0;
> +				break;
> +			}
> +		}
> +		if (i =3D=3D num) {
> +			clk_disable_unprepare(i2c->clk);

why don't you use pm_runtime for that ? With the OMAP driver, we figured
that asynchronous PM improved transfer processing time quite a lot
because we would only cut controller's clocks when it was idle for at
least 500ms.

> +			return num;
> +		}
> +
> +		dev_dbg(i2c->dev, "retrying transfer (%d)\n", retry);
> +
> +		udelay(100);
> +	}
> +
> +	clk_disable_unprepare(i2c->clk);
> +
> +	return -EREMOTEIO;
> +}
> +
> +static u32 exynos5_i2c_func(struct i2c_adapter *adap)
> +{
> +	return I2C_FUNC_I2C;

do you not support SMBUS ? Should you request for SW emulation, then ?

> +}
> +
> +static const struct i2c_algorithm exynos5_i2c_algorithm =3D {
> +	.master_xfer		=3D exynos5_i2c_xfer,
> +	.functionality		=3D exynos5_i2c_func,
> +};
> +
> +static int exynos5_i2c_set_timing(struct exynos5_i2c *i2c)
> +{
> +	unsigned long i2c_timing_s1;
> +	unsigned long i2c_timing_s2;
> +	unsigned long i2c_timing_s3;
> +	unsigned long i2c_timing_sla;
> +	unsigned int op_clk;
> +	unsigned int clkin =3D clk_get_rate(i2c->clk);
> +	unsigned int n_clkdiv;
> +	unsigned int t_start_su, t_start_hd;
> +	unsigned int t_stop_su;
> +	unsigned int t_data_su, t_data_hd;
> +	unsigned int t_scl_l, t_scl_h;
> +	unsigned int t_sr_release;
> +	unsigned int t_ftl_cycle;
> +	unsigned int i =3D 0, utemp0 =3D 0, utemp1 =3D 0, utemp2 =3D 0;
> +
> +	if (i2c->speed_mode =3D=3D HSI2C_HIGH_SPD)
> +		op_clk =3D i2c->high_speed;
> +	else
> +		op_clk =3D i2c->fast_speed;
> +
> +	/* FPCLK / FI2C =3D
> +	 * (CLK_DIV + 1) * (TSCLK_L + TSCLK_H + 2) + 8 + 2 * FLT_CYCLE
> +	 * uTemp0 =3D (CLK_DIV + 1) * (TSCLK_L + TSCLK_H + 2)
> +	 * uTemp1 =3D (TSCLK_L + TSCLK_H + 2)
> +	 * uTemp2 =3D TSCLK_L + TSCLK_H
> +	*/
> +	t_ftl_cycle =3D (readl(i2c->regs + HSI2C_CONF) >> 16) & 0x7;
> +	utemp0 =3D (clkin / op_clk) - 8 - 2 * t_ftl_cycle;
> +
> +	/* CLK_DIV max is 256 */
> +	for (i =3D 0; i < 256; i++) {
> +		utemp1 =3D utemp0 / (i + 1);
> +		/* SCLK_L/H max is 256 / 2 */
> +		if (utemp1 < 128) {
> +			utemp2 =3D utemp1 - 2;
> +			break;
> +		}
> +	}
> +
> +	n_clkdiv =3D i;
> +	t_scl_l =3D utemp2 / 2;
> +	t_scl_h =3D utemp2 / 2;
> +	t_start_su =3D t_scl_l;
> +	t_start_hd =3D t_scl_l;
> +	t_stop_su =3D t_scl_l;
> +	t_data_su =3D t_scl_l / 2;
> +	t_data_hd =3D t_scl_l / 2;
> +	t_sr_release =3D utemp2;
> +
> +	i2c_timing_s1 =3D t_start_su << 24 | t_start_hd << 16 | t_stop_su << 8;
> +	i2c_timing_s2 =3D t_data_su << 24 | t_scl_l << 8 | t_scl_h << 0;
> +	i2c_timing_s3 =3D n_clkdiv << 16 | t_sr_release << 0;
> +	i2c_timing_sla =3D t_data_hd << 0;
> +
> +	dev_dbg(i2c->dev, "tSTART_SU: %X, tSTART_HD: %X, tSTOP_SU: %X\n",
> +		t_start_su, t_start_hd, t_stop_su);
> +	dev_dbg(i2c->dev, "tDATA_SU: %X, tSCL_L: %X, tSCL_H: %X\n",
> +		t_data_su, t_scl_l, t_scl_h);
> +	dev_dbg(i2c->dev, "nClkDiv: %X, tSR_RELEASE: %X\n",
> +		n_clkdiv, t_sr_release);
> +	dev_dbg(i2c->dev, "tDATA_HD: %X\n", t_data_hd);
> +
> +	if (i2c->speed_mode =3D=3D HSI2C_HIGH_SPD) {
> +		writel(i2c_timing_s1, i2c->regs + HSI2C_TIMING_HS1);
> +		writel(i2c_timing_s2, i2c->regs + HSI2C_TIMING_HS2);
> +		writel(i2c_timing_s3, i2c->regs + HSI2C_TIMING_HS3);
> +	} else {
> +		writel(i2c_timing_s1, i2c->regs + HSI2C_TIMING_FS1);
> +		writel(i2c_timing_s2, i2c->regs + HSI2C_TIMING_FS2);
> +		writel(i2c_timing_s3, i2c->regs + HSI2C_TIMING_FS3);
> +	}
> +	writel(i2c_timing_sla, i2c->regs + HSI2C_TIMING_SLA);
> +
> +	return 0;
> +}
> +
> +#ifdef CONFIG_OF
> +static int exynos5_i2c_parse_dt_gpio(struct exynos5_i2c *i2c)
> +{
> +	int idx, gpio, ret;
> +
> +	for (idx =3D 0; idx < 2; idx++) {
> +		gpio =3D of_get_gpio(i2c->dev->of_node, idx);
> +		if (!gpio_is_valid(gpio)) {
> +			dev_err(i2c->dev, "invalid gpio[%d]: %d\n", idx, gpio);
> +			goto free_gpio;
> +		}
> +		i2c->gpios[idx] =3D gpio;
> +
> +		ret =3D gpio_request(gpio, "hsi2c-bus");
> +		if (ret) {
> +			dev_err(i2c->dev, "gpio [%d] request failed\n", gpio);
> +			goto free_gpio;
> +		}
> +	}
> +	return 0;
> +
> +free_gpio:
> +	while (--idx >=3D 0)
> +		gpio_free(i2c->gpios[idx]);
> +	return -EINVAL;
> +}
> +
> +static void exynos5_i2c_dt_gpio_free(struct exynos5_i2c *i2c)
> +{
> +	unsigned int idx;
> +
> +	for (idx =3D 0; idx < 2; idx++)
> +		gpio_free(i2c->gpios[idx]);
> +}
> +#else
> +static int exynos5_i2c_parse_dt_gpio(struct exynos5_i2c *i2c)
> +{
> +	return 0;
> +}
> +
> +static void exynos5_i2c_dt_gpio_free(struct exynos5_i2c *i2c)
> +{
> +}
> +#endif
> +
> +static int exynos5_i2c_init(struct exynos5_i2c *i2c)
> +{
> +	unsigned long usi_ctl =3D HSI2C_FUNC_MODE_I2C | HSI2C_MASTER;
> +	unsigned long usi_trailing_ctl =3D HSI2C_TRAILING_COUNT;
> +	unsigned long i2c_conf =3D readl(i2c->regs + HSI2C_CONF);
> +
> +	if (exynos5_i2c_parse_dt_gpio(i2c))
> +		return -EINVAL;
> +
> +	writel(usi_ctl, i2c->regs + HSI2C_CTL);
> +
> +	writel(usi_trailing_ctl, i2c->regs + HSI2C_TRAILIG_CTL);
> +
> +	exynos5_i2c_set_timing(i2c);
> +
> +	if (i2c->speed_mode =3D=3D HSI2C_HIGH_SPD) {
> +		i2c_conf |=3D HSI2C_HS_MODE;
> +		writel(i2c_conf, i2c->regs + HSI2C_CONF);
> +	}
> +
> +	return 0;
> +}
> +
> +static int exynos5_i2c_probe(struct platform_device *pdev)
> +{
> +	struct exynos5_i2c *i2c;
> +	struct resource *res;
> +	int ret;
> +
> +	i2c =3D devm_kzalloc(&pdev->dev, sizeof(struct exynos5_i2c), GFP_KERNEL=
);
> +	if (!i2c) {
> +		dev_err(&pdev->dev, "no memory for state\n");
> +		return -ENOMEM;
> +	}
> +
> +	if (pdev->dev.of_node) {
> +		/* i2c bus number is dynamically assigned */
> +		i2c->bus_number =3D -1;
> +
> +		if (of_property_read_u32(pdev->dev.of_node,
> +				"samsung,hsi2c-speed-mode", &i2c->speed_mode))
> +			i2c->speed_mode =3D 1;
> +		if (!of_property_read_u32(pdev->dev.of_node,
> +				"samsung,hsi2c-hs-clk", &i2c->high_speed))
> +			i2c->high_speed =3D 2500000;
> +		if (!of_property_read_u32(pdev->dev.of_node,
> +				"samsung,hsi2c-fs-clk", &i2c->fast_speed))
> +			i2c->fast_speed =3D 400000;
> +	} else {
> +		dev_err(&pdev->dev, "no device node\n");
> +		return -ENOENT;
> +	}
> +
> +	strlcpy(i2c->adap.name, "exynos5250-i2c", sizeof(i2c->adap.name));
> +	i2c->adap.owner   =3D THIS_MODULE;
> +	i2c->adap.algo    =3D &exynos5_i2c_algorithm;
> +	i2c->adap.retries =3D 2;
> +	i2c->adap.class   =3D I2C_CLASS_HWMON | I2C_CLASS_SPD;
> +
> +	i2c->dev =3D &pdev->dev;
> +	i2c->clk =3D clk_get(&pdev->dev, "hsi2c");

how about devm_clk_get() ?

> +	if (IS_ERR(i2c->clk)) {
> +		dev_err(&pdev->dev, "cannot get clock\n");
> +		ret =3D -ENOENT;
> +		goto err_noclk;
> +	}
> +
> +	clk_prepare_enable(i2c->clk);
> +
> +	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (res =3D=3D NULL) {
> +		dev_err(&pdev->dev, "cannot find HS-I2C IO resource\n");
> +		ret =3D -ENOENT;
> +		goto err_clk;
> +	}
> +
> +	i2c->ioarea =3D request_mem_region(res->start, resource_size(res),
> +					 pdev->name);

please use devm_request_and_ioremap() instead.

> +
> +	if (i2c->ioarea =3D=3D NULL) {
> +		dev_err(&pdev->dev, "cannot request HS-I2C IO\n");
> +		ret =3D -ENXIO;
> +		goto err_clk;
> +	}
> +
> +	i2c->regs =3D ioremap(res->start, resource_size(res));
> +
> +	if (i2c->regs =3D=3D NULL) {
> +		dev_err(&pdev->dev, "cannot map HS-I2C IO\n");
> +		ret =3D -ENXIO;
> +		goto err_ioarea;
> +	}
> +
> +	dev_dbg(&pdev->dev, "registers %p (%p, %p)\n",
> +		i2c->regs, i2c->ioarea, res);
> +
> +	i2c->adap.algo_data =3D i2c;
> +	i2c->adap.dev.parent =3D &pdev->dev;
> +
> +	ret =3D exynos5_i2c_init(i2c);
> +	if (ret !=3D 0)
> +		goto err_iomap;
> +
> +	i2c->irq =3D ret =3D platform_get_irq(pdev, 0);
> +	if (ret <=3D 0) {
> +		dev_err(&pdev->dev, "cannot find HS-I2C IRQ\n");
> +		goto err_iomap;
> +	}
> +
> +	ret =3D request_irq(i2c->irq, exynos5_i2c_irq, IRQF_DISABLED,
> +			  dev_name(&pdev->dev), i2c);

devm_request_irq().

> +
> +	if (ret !=3D 0) {
> +		dev_err(&pdev->dev, "cannot request HS-I2C IRQ %d\n", i2c->irq);
> +		goto err_iomap;
> +	}
> +
> +	i2c->adap.nr =3D i2c->bus_number;
> +	i2c->adap.dev.of_node =3D pdev->dev.of_node;
> +
> +	ret =3D i2c_add_numbered_adapter(&i2c->adap);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "failed to add bus to i2c core\n");
> +		goto err_irq;
> +	}
> +
> +	of_i2c_register_devices(&i2c->adap);
> +	platform_set_drvdata(pdev, i2c);
> +
> +	dev_info(&pdev->dev, "%s: Exynos5 HS-I2C adapter\n",
> +		dev_name(&i2c->adap.dev));

please drop this dev_info() as it brings no useful information. The core
I2C subsystem already prints enough information when you register an
adapter.

> +	clk_disable_unprepare(i2c->clk);
> +	return 0;
> +
> + err_irq:
> +	free_irq(i2c->irq, i2c);
> +
> + err_iomap:
> +	iounmap(i2c->regs);
> +
> + err_ioarea:
> +	release_resource(i2c->ioarea);
> +	kfree(i2c->ioarea);
> +
> + err_clk:
> +	clk_disable_unprepare(i2c->clk);
> +	clk_put(i2c->clk);
> +
> + err_noclk:
> +	return ret;
> +}
> +
> +static int exynos5_i2c_remove(struct platform_device *pdev)
> +{
> +	struct exynos5_i2c *i2c =3D platform_get_drvdata(pdev);
> +
> +	i2c_del_adapter(&i2c->adap);
> +	free_irq(i2c->irq, i2c);
> +
> +	clk_disable_unprepare(i2c->clk);
> +	clk_put(i2c->clk);
> +
> +	iounmap(i2c->regs);
> +
> +	release_resource(i2c->ioarea);
> +	exynos5_i2c_dt_gpio_free(i2c);
> +	kfree(i2c->ioarea);
> +
> +	return 0;
> +}
> +
> +#ifdef CONFIG_PM
> +static int exynos5_i2c_suspend_noirq(struct device *dev)
> +{
> +	struct platform_device *pdev =3D to_platform_device(dev);
> +	struct exynos5_i2c *i2c =3D platform_get_drvdata(pdev);
> +
> +	i2c_lock_adapter(&i2c->adap);
> +	i2c->suspended =3D 1;
> +	i2c_unlock_adapter(&i2c->adap);
> +
> +	return 0;
> +}
> +
> +static int exynos5_i2c_resume(struct device *dev)

maybe you could add _noirq suffix here too.

> +{
> +	struct platform_device *pdev =3D to_platform_device(dev);
> +	struct exynos5_i2c *i2c =3D platform_get_drvdata(pdev);
> +
> +	i2c_lock_adapter(&i2c->adap);
> +	clk_prepare_enable(i2c->clk);
> +	exynos5_i2c_init(i2c);
> +	clk_disable_unprepare(i2c->clk);
> +	i2c->suspended =3D 0;
> +	i2c_unlock_adapter(&i2c->adap);
> +
> +	return 0;
> +}
> +
> +static const struct dev_pm_ops exynos5_i2c_dev_pm_ops =3D {
> +	.suspend_noirq	=3D exynos5_i2c_suspend_noirq,
> +	.resume_noirq	=3D exynos5_i2c_resume,

you need to define poweroff, thaw, freeze, restore.

> +};
> +
> +#define EXYNOS5_DEV_PM_OPS (&exynos5_i2c_dev_pm_ops)
> +#else
> +#define EXYNOS5_DEV_PM_OPS NULL
> +#endif
> +
> +static struct platform_driver exynos5_i2c_driver =3D {
> +	.probe		=3D exynos5_i2c_probe,
> +	.remove		=3D exynos5_i2c_remove,
> +	.id_table	=3D exynos5_driver_ids,
> +	.driver		=3D {
> +		.owner	=3D THIS_MODULE,
> +		.name	=3D "exynos5-i2c",
> +		.pm	=3D EXYNOS5_DEV_PM_OPS,
> +		.of_match_table =3D of_match_ptr(exynos5_i2c_match),
> +	},
> +};
> +
> +static int __init i2c_adap_exynos5_init(void)
> +{
> +	return platform_driver_register(&exynos5_i2c_driver);
> +}
> +subsys_initcall(i2c_adap_exynos5_init);
> +
> +static void __exit i2c_adap_exynos5_exit(void)
> +{
> +	platform_driver_unregister(&exynos5_i2c_driver);
> +}
> +module_exit(i2c_adap_exynos5_exit);
> +
> +MODULE_DESCRIPTION("Exynos5 HS-I2C Bus driver");
> +MODULE_AUTHOR("Taekgyun Ko, <taeggyun.ko@samsung.com>");
> +MODULE_LICENSE("GPL");

looks like this should be GPL v2, judging by the comment in the
beginning of this file.

> diff --git a/drivers/i2c/busses/i2c-exynos5.h b/drivers/i2c/busses/i2c-ex=
ynos5.h
> new file mode 100644
> index 0000000..063051e
> --- /dev/null
> +++ b/drivers/i2c/busses/i2c-exynos5.h
> @@ -0,0 +1,80 @@
> +/*
> + * Copyright (C) 2012 Samsung Electronics Co., Ltd.
> + *
> + * Exynos5 series HS-I2C Controller
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> +*/
> +
> +#ifndef __ASM_ARCH_REGS_HS_IIC_H
> +#define __ASM_ARCH_REGS_HS_IIC_H __FILE__

no need for the __FILE__ at the end...

> +
> +/*
> + *	Register Map
> + */

this is a single line comment. Should be /* Register Map */ instead.

--=20
balbi

--qcHopEYAB45HaUaB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQtL7YAAoJEIaOsuA1yqRE1j0P/2JSys9KK0I0NB4NqrjVk8CH
B21DmtRhbLukK80cHQBvBR5OcC022LclsjfOiqCp9vmBYETpenDoq7gvYfaozwtt
WGoOBKW3hezHpZ012Vi4q8To3VOFy0yEgG5nwCvc6l7BRdyomo/AakqGJAg0Vrtm
S/uMMfFWEFjAI9KqdSil8mjqLg8WoWf0BfKK6CISmWm9OwgRTZE72ag2aT60rKbD
Z5ZR9qAu91zYSobnNdGDuKRGmjFQ80ECyShdwa/R06vYWVtQyLNaKEY/djmKrCSn
OE+FGwDossRRnzVEeJFoMVqYAMEwR7WNi9MqwZTGp+FoFvYMwruEqrHoYAgiLcT5
0M/r77LErnTa3lIiZWwrSb0tix3TtWybM8pqgvdW9DwgGe/trybjDuBboPisFFvM
gIet0uCqTmTs49qUQJDMIDRwi0HrSU54ihREoJ/uM5e9N4JGlnAp70UvFxzBM4Xs
shfTAVgwCmwPlbF2422qBp2KMFNpeJKHGc1fIOnDWvnTrZKVQHmoUL9Lg+MJ2OkC
gLhxmXKNIVsk1G2ntXHfxgEkFO/REVE03p/YlYiH+xPw7i0dp7Weh50GM2G7wDt4
ZAyKWBu8cvYJqjwOsM2ok6Kh9pjftCW7/7/di5HHS3wTtNynkwztuhPI/lqVec7P
CKGY6NGTH7DJ4IhLYxGu
=C+xa
-----END PGP SIGNATURE-----

--qcHopEYAB45HaUaB--
